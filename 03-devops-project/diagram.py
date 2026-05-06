from diagrams import Diagram, Cluster, Edge
from diagrams.aws.compute import EC2
from diagrams.aws.network import VPC, PublicSubnet
from diagrams.onprem.vcs import Github
from diagrams.onprem.client import User
from diagrams.generic.os import Ubuntu

with Diagram("Jenkins Distributed Architecture", show=False, filename="architecture", direction="LR", outformat="png"):
    user = User("User / Developer")
    admin = User("Admin / Ansible")
    github = Github("GitHub Webhook")

    with Cluster("AWS Cloud (us-east-1)"):
        with Cluster("Default VPC"):
            with Cluster("Public Subnet (Security Group: ports 8080, 22)"):
                jenkins_master = EC2("Jenkins Master\n(t3.small, 20GB gp3 EBS)")
                jenkins_agent = EC2("Jenkins Agent\n(t3.small, 20GB gp3 EBS)")
                
    user >> Edge(label="HTTP (8080)") >> jenkins_master
    github >> Edge(label="HTTP (8080)") >> jenkins_master
    admin >> Edge(label="SSH (22)") >> [jenkins_master, jenkins_agent]
    jenkins_master >> Edge(label="SSH (22)") >> jenkins_agent
