# AWS Static Website Hosting with S3, CloudFront, and Route 53

This project demonstrates a production-ready approach to hosting a secure static website on AWS using Amazon S3, Amazon CloudFront, and optionally Amazon Route 53 for custom domain management. It includes dual Infrastructure as Code (IaC) implementations (Terraform and CloudFormation) and full CI/CD automation via GitHub Actions.

## Architecture

*   **Amazon S3:** Stores the static assets (HTML, CSS, JS, images). All public access to the bucket is blocked.
*   **Amazon CloudFront:** A global Content Delivery Network (CDN) that caches the static assets closer to users, providing low-latency access and HTTPS encryption.
*   **Origin Access Control (OAC):** Secures the connection between CloudFront and S3, ensuring the S3 bucket can only be accessed through the CloudFront distribution.
*   **Amazon Route 53 & ACM (Optional):** Manages DNS records to point a custom subdomain (e.g., `dev.example.com`) to your CloudFront distribution, while AWS Certificate Manager (ACM) automatically provisions and validates a free SSL/TLS certificate.

## Project Structure

```sh
.github/workflows/            # GitHub Actions CI/CD workflows
01-devops-project/
├── app/                      # Contains the static website code (e.g., index.html)
├── cloudformation/           # CloudFormation template (template.yaml) and deployment scripts
└── terraform/                # Main Terraform configuration for the website
    └── state-backend/        # Terraform configuration for the remote S3 backend                                                                                                                                                  
```

## Prerequisites

To deploy this project, you need:
1.  An **AWS Account**.
2.  **AWS CLI** installed and configured locally.
3.  **Terraform** (or OpenTofu) installed locally (if using the Terraform approach).
4.  **GitHub Repository Secrets** configured for CI/CD:
    *   `AWS_ACCESS_KEY_ID`: Your AWS IAM user access key.
    *   `AWS_SECRET_ACCESS_KEY`: Your AWS IAM user secret key.
5.  *(Optional)* A registered domain name with a Hosted Zone created in Route 53 (if you plan to use a custom domain).

---

## Infrastructure as Code (IaC) Options

You can deploy this infrastructure using either **Terraform** or **CloudFormation**. Both implementations optionally support setting up a custom domain.

### Option 1: Terraform

The Terraform setup uses a remote S3 backend with DynamoDB state locking to ensure safe, concurrent deployments via CI/CD.

**1. Deploy the State Backend (One-Time Setup)**
Before running the main deployment, you must provision the S3 bucket and DynamoDB table used for Terraform state.

```bash
cd terraform/state-backend
terraform init
terraform apply
```

**2. Deploy the Infrastructure**
You can deploy with or without a custom domain.

```sh
cd ../
# (You should now be in the 01-devops-project/terraform directory)
terraform init

# To deploy with the default CloudFront URL:
terraform apply

# To deploy with a custom domain (e.g., example.com):
# This will automatically create a subdomain based on the environment (e.g., dev.example.com)
terraform apply -var="domain_name=example.com"
```

### Option 2: CloudFormation

If you prefer native AWS tooling, you can deploy the exact same architecture using CloudFormation.

```sh
cd cloudformation

# To deploy with the default CloudFront URL:
aws cloudformation deploy \
  --template-file template.yaml \
  --stack-name devops-static-site-dev \
  --no-fail-on-empty-changeset

# To deploy with a custom domain (e.g., example.com):
aws cloudformation deploy \
  --template-file template.yaml \
  --stack-name devops-static-site-dev \
  --no-fail-on-empty-changeset \
  --parameter-overrides ProjectName=devops-static-site Environment=dev DomainName=example.com
```

---

## CI/CD with GitHub Actions

This project includes fully automated deployment and destruction pipelines located in the repository root `.github/workflows/`.

### Deployment Workflows
*   **`deploy-terraform.yml`**: Automatically runs on pushes to the `main` branch when changes are detected in `terraform/` or `app/`. It formats, validates, plans, and applies the Terraform configuration, then invalidates the CloudFront cache and outputs the final website URL.
*   **`deploy-cloudformation.yml`**: Automatically runs on pushes to the `main`. It deploys the CloudFormation stack, outputs the final website URL, syncs the `app/` directory to the S3 bucket, and invalidates the CloudFront cache.

### Cleanup Workflows
To avoid incurring unnecessary AWS charges, you can easily tear down the infrastructure via GitHub Actions.
*   **`destroy-terraform.yml`**: Manually triggered. Empties the S3 bucket and runs `terraform destroy`.
*   **`destroy-cloudformation.yml`**: Manually triggered. Empties the S3 bucket and deletes the CloudFormation stack.

