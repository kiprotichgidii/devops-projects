# 🚀 Jenkins + Terraform + Ansible CI/CD Pipeline

![CI](https://img.shields.io/badge/CI-Jenkins-blue)
![IaC](https://img.shields.io/badge/IaC-Terraform-purple)
![Config](https://img.shields.io/badge/Config-Ansible-red)
![Cloud](https://img.shields.io/badge/Cloud-AWS-orange)

---

### 📌 Overview
This project demonstrates a **production-grade DevOps pipeline** that provisions, configures, and deploys applications on AWS using:

- **Terraform** → Infrastructure provisioning  
- **Ansible** → Configuration management  
- **Jenkins** → CI/CD orchestration  


### 🏗️ Architecture

```text
GitHub → Jenkins → Terraform → AWS Infra → Ansible → App Deployment
```


### 🧰 Tech Stack

| Category | Tools |
|--------|------|
| CI/CD | Jenkins |
| IaC | Terraform |
| Config Mgmt | Ansible |
| Cloud | AWS (EC2, VPC, S3, DynamoDB) |
| Containerization | Docker (optional) |


### 📂 Repository Structure

```
.
├── Jenkinsfile
├── terraform/
├── ansible/
├── app/
├── scripts/
└── docs/
```

### ⚙️ Pipeline Stages

1. Checkout code  
2. Terraform init & validate  
3. Terraform plan  
4. Manual approval  
5. Terraform apply  
6. Ansible configuration  
7. Application deployment  

### 🔐 Security Best Practices

- No hardcoded credentials  
- Jenkins credential store used  
- Remote state in S3 with DynamoDB locking  
- SSH keys securely managed  

### 🔥 Key Features

- Infrastructure as Code pipeline  
- Manual approval gates  
- Dynamic inventory (AWS EC2)  
- Modular Terraform design  
- Idempotent Ansible execution  


### 🧠 Learning Outcomes

- CI/CD for infrastructure  
- Separation of concerns  
- AWS automation workflows  

### 📸 Future Improvements

- Multi-environment support  
- Monitoring integration  
- Rollback mechanisms  
