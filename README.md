# AWS-Terraform-Infrastructure-Project

A scalable and highly available infrastructure setup on AWS using Terraform.

## Featuring

* VPC: Created a Virtual Private Cloud to provide a logically isolated section of the AWS cloud.
* Internet Gateway: Set up an Internet Gateway to enable communication between the VPC and the internet.
* Route Table: Created a Route Table to route traffic from the subnets to the Internet Gateway.
* Public Subnets: Created two public subnets in different Availability Zones for high availability.
* EC2 Instances: Launched two EC2 instances, one in each subnet.
* Security Groups: Created Security Groups to control inbound and outbound traffic to the EC2 instances.
* Load Balancer: Set up a Load Balancer to distribute traffic across the EC2 instances.
* Target Groups: Created Target Groups to define the EC2 instances that receive traffic from the Load Balancer.
* Listeners: Configured Listeners to route traffic from the Load Balancer to the Target Groups.


## The Load Balancer successfully distributed incoming requests across both EC2 instances, ensuring optimal resource utilization and high availability. This setup enables:

* Efficient resource utilization: By distributing traffic across both instances, I ensured that no single instance is overwhelmed, reducing the risk of performance degradation.

  <img width="1334" height="748" alt="image" src="https://github.com/user-attachments/assets/9eb9cf1c-a7bc-4ede-8b9c-f7f8f7910b71" />


  
 
