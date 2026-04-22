from diagrams import Diagram, Cluster, Edge
from diagrams.aws.compute import EC2
from diagrams.aws.network import VPC, PublicSubnet
from diagrams.onprem.vcs import Github
from diagrams.onprem.client import User
from diagrams.generic.os import Ubuntu

with Diagram("Jenkins Server Architecture", show=False, filename="architecture", direction="LR", outformat="png"):
    user = User("User / Developer")
    admin = User("Admin / Ansible")
    github = Github("GitHub Webhook")

    with Cluster("AWS Cloud (us-east-1)"):
        with Cluster("Default VPC"):
            with Cluster("Public Subnet (Security Group: ports 8080, 22)"):
                jenkins = EC2("Jenkins Server\n(t3.small, 20GB gp3 EBS)")
                
    user >> Edge(label="HTTP (8080)") >> jenkins
    github >> Edge(label="HTTP (8080)") >> jenkins
    admin >> Edge(label="SSH (22)") >> jenkins
