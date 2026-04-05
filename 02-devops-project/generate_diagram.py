from diagrams import Diagram, Cluster, Edge
from diagrams.aws.network import ELB
from diagrams.aws.compute import EC2, AutoScaling
from diagrams.onprem.vcs import Github
from diagrams.onprem.iac import Terraform, Ansible
from diagrams.aws.general import User

with Diagram("AWS Hybrid Infrastructure Architecture", filename="aws_architecture", show=False, direction="LR"):
    user = User("End User")
    developer = User("Developer")
    
    with Cluster("CI/CD Pipeline"):
        github = Github("GitHub Actions")
        terraform = Terraform("Terraform/CFN")
        ansible = Ansible("Ansible")
        
        github >> terraform
        github >> ansible
        
    with Cluster("AWS Cloud"):
        alb = ELB("Application Load Balancer")
        
        with Cluster("Ubuntu Auto Scaling Group"):
            ubuntu_ec2 = EC2("Ubuntu Server")
            
        with Cluster("Amazon Linux Auto Scaling Group"):
            al_ec2 = EC2("Amazon Linux Server")
            
        alb >> Edge(label="HTTP Traffic") >> ubuntu_ec2
        alb >> Edge(label="HTTP Traffic") >> al_ec2
        
    user >> Edge(label="HTTP Request") >> alb
    developer >> Edge(label="Git Push") >> github
    terraform >> Edge(label="Provisions Infra", style="dashed") >> alb
    terraform >> Edge(label="Provisions Infra", style="dashed") >> ubuntu_ec2
    terraform >> Edge(label="Provisions Infra", style="dashed") >> al_ec2
    
    ansible >> Edge(label="Configures NGINX & App", style="dotted", color="red") >> ubuntu_ec2
    ansible >> Edge(label="Configures NGINX & App", style="dotted", color="red") >> al_ec2
