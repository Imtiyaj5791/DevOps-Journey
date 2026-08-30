
# Intro:-

Good morning.

Hi, thank you for giving me this opportunity.

I am Imtiyaj Ansari. I have around 11 years of experience in IT Infrastructure. I started my career as a Desktop Support Engineer, where I worked for around six years. For the last five years, I have been working as an AWS and Linux Operations Engineer.

In my current organization, my responsibilities include server monitoring, production incident handling, troubleshooting, and ensuring that all environments are running smoothly.

I work with AWS services like EC2, EBS, IAM, S3, VPC, and CloudWatch. Along with this, I have hands-on experience with DevOps tools like Git, Docker, Jenkins, Terraform, and Kubernetes through projects and lab environments.

I also coordinate with application, network, database, and senior DevOps teams to resolve production issues.

Currently, I am looking for an opportunity where I can utilize my AWS and Linux experience, apply my DevOps knowledge, and grow further in a DevOps role.

Thank you.


# Project:

"Our application is deployed on AWS and follows a 3-tier architecture. Users access the application through an Application Load Balancer. The Load Balancer distributes the traffic to EC2 instances managed by an Auto Scaling Group. To ensure high availability, we use an Auto Scaling Group across multiple Availability Zones. We use CloudWatch for monitoring, EBS Snapshots for backup and recovery, and Security Groups to control traffic between different application tiers. 

My responsibility includes monitoring Linux servers, handling production incidents, performing initial troubleshooting, and working with AWS services such as EC2, EBS, IAM, S3, CloudWatch, and CloudTrail. If required, I coordinate with the Application, Database, Network, and Cloud teams until the issue is resolved."

# Why not your project in k8s

"Sir, our project is highly stable and does not have hundreds of complex microservices. Our current setup with AWS EC2 and Auto Scaling handles our traffic perfectly and gives us 99.9% uptime. Moving to Kubernetes would only increase unnecessary infrastructure costs and cluster management complexity for our team."

# which project you have worked for k8s and docker

"Sir, actually in our company, we handle multiple projects. My primary project is the stable AWS EC2 3-tier architecture that I manage daily. However, we have another modern microservices-based application in our account that runs entirely on Docker and Kubernetes in production, where my role is to assist the Senior DevOps team in basic troubleshooting and infrastructure monitoring."


# Recent P1 alert

"Yes, recently I handled a P1 alert where our main Nginx web application became completely unreachable, and users faced a 502 Bad Gateway error. The alert was triggered in Opsgenie, and I immediately acknowledged it in JIRA. 

Upon troubleshooting via SSH, I checked the server logs and found that the root filesystem was 100% full because of sudden application log accumulation. As a quick fix, I compressed and cleared old rotated log files to free up disk space and restarted the Nginx service to restore the website. 

Finally, to resolve this permanently, I coordinated with the Senior Cloud team, took proper approvals, and expanded the EBS volume dynamically from the AWS console using growpart and resize2fs commands without any downtime. I documented the complete Root Cause Analysis (RCA) in JIRA."
