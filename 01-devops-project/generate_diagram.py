from diagrams import Diagram, Cluster, Edge
from diagrams.aws.network import Route53, CloudFront
from diagrams.aws.storage import S3
from diagrams.aws.security import CertificateManager
from diagrams.aws.general import User
from diagrams.onprem.vcs import Github

with Diagram("AWS Static Website Architecture", filename="aws_architecture", show=False, direction="LR"):
    user = User("End User")
    developer = User("Developer")
    
    with Cluster("CI/CD Pipeline"):
        github = Github("GitHub Actions")
        
    with Cluster("AWS Cloud"):
        dns = Route53("Route 53 (DNS)")
        cdn = CloudFront("CloudFront (CDN)")
        acm = CertificateManager("ACM (SSL)")
        
        with Cluster("Static Origin"):
            bucket = S3("S3 Bucket")
            
        dns >> Edge(label="Alias Record") >> cdn
        acm >> Edge(label="Validates", style="dashed") >> cdn
        cdn >> Edge(label="OAC Fetch") >> bucket
        
    user >> Edge(label="HTTPS Request") >> dns
    developer >> Edge(label="Git Push") >> github
    github >> Edge(label="Sync & Invalidate", style="dashed") >> bucket
    github >> Edge(label="Deploy IaC", style="dashed") >> dns
