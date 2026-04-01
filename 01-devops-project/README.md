# AWS Static Website Hosting with S3 and CloudFront

This project demonstrates a production-ready approach to hosting a secure static website on AWS using Amazon S3 and Amazon CloudFront. It includes dual Infrastructure as Code (IaC) implementations (Terraform and CloudFormation) and full CI/CD automation via GitHub Actions.

## Architecture

*   **Amazon S3:** Stores the static assets (HTML, CSS, JS). All public access to the bucket is blocked.
*   **Amazon CloudFront:** A global Content Delivery Network (CDN) that caches the static assets closer to users, providing low-latency access and HTTPS encryption.
*   **Origin Access Control (OAC):** Secures the connection between CloudFront and S3, ensuring the S3 bucket can only be accessed through the CloudFront distribution.

## Project Structure

```
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
3.  **Terraform** installed locally (if using the Terraform approach).
4.  **GitHub Repository Secrets** configured for CI/CD:
    *   `AWS_ACCESS_KEY_ID`: Your AWS IAM user access key.
    *   `AWS_SECRET_ACCESS_KEY`: Your AWS IAM user secret key.

---

## Infrastructure as Code (IaC) Options

You can deploy this infrastructure using either **Terraform** or **CloudFormation**.

### Option 1: Terraform

The Terraform setup uses a remote S3 backend with DynamoDB state locking to ensure safe, concurrent deployments via CI/CD.

**1. Deploy the Backend (One-Time Setup)**
Before running the main deployment, you must provision the S3 bucket and DynamoDB table used for Terraform state.
```bash
cd terraform/state-backend
terraform init
terraform apply
```

**2. Deploy the Infrastructure**
```bash
cd ..
# (You should now be in the 01-devops-project/terraform directory)
terraform init
terraform apply
```

### Option 2: CloudFormation

If you prefer native AWS tooling, you can deploy the exact same architecture using CloudFormation.

```bash
cd cloudformation
aws cloudformation deploy \
  --template-file template.yaml \
  --stack-name devops-static-site-dev \
  --parameter-overrides ProjectName=devops-static-site Environment=dev
```
*(You can also use the `deploy.sh` script provided in the directory)*

---

## CI/CD with GitHub Actions

This project includes fully automated deployment and destruction pipelines located in the repository root `.github/workflows/`.

### Deployment Workflows
*   **`deploy-terraform.yml`**: Automatically runs on pushes to the `main` branch when changes are detected in `terraform/` or `app/`. It formats, validates, plans, and applies the Terraform configuration, then invalidates the CloudFront cache.
*   **`deploy-cloudformation.yml`**: Automatically runs on pushes to the `main`. It deploys the CloudFormation stack, syncs the `app/` directory to the S3 bucket, and invalidates the CloudFront cache.

### Cleanup Workflows
To avoid incurring unnecessary AWS charges, you can easily tear down the infrastructure via GitHub Actions.
*   **`destroy-terraform.yml`**: Manually triggered. Empties the S3 bucket and runs `terraform destroy`.
*   **`destroy-cloudformation.yml`**: Manually triggered. Empties the S3 bucket and deletes the CloudFormation stack.

**Note:** Both cleanup workflows require manual confirmation. You must type `destroy` when triggering the workflow in the GitHub UI.
