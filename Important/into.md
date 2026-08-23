
# Intro:-

"Good morning. 

Hi, thank you for giving me this opportunity. 

I am Imtiyaz Ansari. I have around 11 years of experience in IT Infrastructure. I started my career as a Desktop Support Engineer, where I worked for around six years. For the last five years, I have been working as an AWS and Linux Operations Engineer. 

In my current organization, my responsibilities are monitoring the servers, handling production incidents, and ensuring all environments are running smoothly. 

For AWS, I work with services like EC2, EBS, IAM, S3, VPC, CloudWatch, etc. 

For monitoring and patching activities, we use tools like CloudWatch, Opsgenie, Grafana, and NinjaRMM. 

We also coordinate with the application team, network team, database team, and senior cloud team to resolve production incidents. 

My day starts with logging in to the monitoring tools to make sure all servers are running smoothly. After that, I check my emails and Jira tickets for any tasks assigned to me. 

On a daily basis, we receive different types of alerts like high CPU utilization, memory utilization, disk utilization, Kubernetes Pod alerts, service down, etc. We also have Cloud infrastructure, so sometimes we receive Instance connectivity and status check tickets. 

If we receive any alert, we access the server through SSH, follow the required troubleshooting steps, and try to resolve the issue. If the issue is not resolved, we escalate it to the concerned Senior DevOps team and share all our findings in the Jira ticket. 

Currently, I am looking for an opportunity where I can utilize my AWS and Linux experience, expand my DevOps knowledge, and contribute to the organization's success. Thank you."

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
