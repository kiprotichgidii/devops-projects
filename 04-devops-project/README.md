# ⚡ Distributed Jenkins with Static & Kubernetes Agents

![CI](https://img.shields.io/badge/CI-Jenkins-blue)
![Cloud](https://img.shields.io/badge/Cloud-AWS-orange)
![Kubernetes](https://img.shields.io/badge/K8s-Enabled-green)

---

### 📌 Overview

This project showcases a **scalable Jenkins architecture** using:

- Static EC2-based agents  
- Dynamic Kubernetes-based agents  

---

### 🏗️ Architecture

```text
             Jenkins Master
              /        \
     EC2 Agents     Kubernetes Pods
```

---

### 🧰 Tech Stack

| Category | Tools |
|--------|------|
| CI/CD | Jenkins |
| Cloud | AWS EC2 |
| Orchestration | Kubernetes |

---

### 📂 Repository Structure

```
.
├── Jenkinsfile
├── k8s/
├── scripts/
└── docs/
```

---

### ⚙️ Pipeline Workflow

1. Trigger via webhook  
2. Assign agent  
3. Execute pipeline stages  

---

### 🔥 Key Features

- Distributed builds  
- Hybrid agent architecture  
- Ephemeral Kubernetes agents  
- Parallel execution  

---

### 🧠 Concepts Covered

- Jenkins master-agent architecture  
- Dynamic scaling  
- Resource optimization  

---

### 🔐 Security Considerations

- Secure SSH agent connections  
- Kubernetes RBAC  
- Credential management  

---

### 📈 Benefits

- Faster builds  
- Scalable pipelines  
- Reduced cost via ephemeral agents  

