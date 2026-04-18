# 🛠️ Deploying a Jenkins CI/CD Server

This project provides the Infrastructure as Code (Terraform) and Configuration Management (Ansible) needed to automatically deploy a fully functional Jenkins CI/CD server on AWS. 

By running this project, you will have a dedicated Jenkins master server ready to orchestrate your other DevOps projects (like Project 04).

## 🏗️ Architecture

1.  **AWS EC2 Instance:** A `t3.small` Ubuntu instance acts as the host for the Jenkins server.
2.  **Security Groups:** Opens Port `8080` for the Jenkins Web UI and Port `22` for SSH (Ansible access).
3.  **Ansible Playbook:** Connects to the EC2 instance, installs Java, configures the Jenkins repository, installs Jenkins, and installs helpful worker tools like Terraform and the AWS CLI.

## 🚀 Deploy Jenkins Server

### 1. Provision the Infrastructure
First, use Terraform to spin up the EC2 instance and Security Groups. This will also automatically generate a secure SSH key locally in your `03-devops-project/ansible` directory.

```bash
cd terraform
terraform init
terraform apply
```

After it finishes, take note of the `jenkins_url` output (e.g., `http://3.80.x.x:8080`).

### 2. Generate the Ansible Inventory
Wait a minute or two for the EC2 instance to fully boot up, then run the dynamic inventory script.

```bash
cd ../scripts
chmod +x generate-inventory.sh
./generate-inventory.sh
```

### 3. Install and Configure Jenkins
Run the Ansible playbook. This will SSH into your new EC2 instance, install Jenkins, and print out your initial admin password!

```bash
cd ../ansible
ansible-playbook -i inventory.ini install-jenkins.yaml
```

**Look carefully at the Ansible output!** 
At the end of the run, there will be a `debug` task that prints:
> `"The initial Jenkins admin password is: [YOUR_PASSWORD_HERE]"`

### 4. Complete Jenkins Setup
1. Open the `jenkins_url` in your web browser.
2. Paste the initial admin password retrieved by Ansible.
3. Click **"Install suggested plugins"**.
4. Create your first Admin User.
5. Save and Finish!

