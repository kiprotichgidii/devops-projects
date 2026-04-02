# Primary Route 53 Zone (Root Domain)
resource "aws_route53_zone" "main" {
  count = var.domain_name != "" ? 1 : 0
  name  = var.domain_name
}

# Subdomain Zone (e.g., dev.example.com)
resource "aws_route53_zone" "subdomain" {
  count = var.domain_name != "" ? 1 : 0
  name  = "${var.environment}.${aws_route53_zone.main[0].name}"

  tags = {
    Environment = var.environment
  }
}

# NS Record to delegate subdomain to the new zone
resource "aws_route53_record" "subdomain_ns" {
  count   = var.domain_name != "" ? 1 : 0
  zone_id = aws_route53_zone.main[0].zone_id
  name    = aws_route53_zone.subdomain[0].name
  type    = "NS"
  ttl     = "30"
  records = aws_route53_zone.subdomain[0].name_servers
}

# ACM Certificate for the Subdomain
resource "aws_acm_certificate" "website" {
  count             = var.domain_name != "" ? 1 : 0
  domain_name       = aws_route53_zone.subdomain[0].name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# DNS Validation Records inside the Subdomain Zone
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in(var.domain_name != "" ? aws_acm_certificate.website[0].domain_validation_options : []) : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.subdomain[0].zone_id
}

# ACM Certificate Validation
resource "aws_acm_certificate_validation" "website" {
  count                   = var.domain_name != "" ? 1 : 0
  certificate_arn         = aws_acm_certificate.website[0].arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

# Route 53 Alias Record for CloudFront (pointing subdomain to CDN)
resource "aws_route53_record" "website" {
  count   = var.domain_name != "" ? 1 : 0
  zone_id = aws_route53_zone.subdomain[0].zone_id
  name    = aws_route53_zone.subdomain[0].name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}