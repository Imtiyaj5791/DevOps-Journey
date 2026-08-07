Erriscon:-

Tell Me About Yourself?

Hi, thank you for giving me this opportunity.

I am Imtiyaz Ansari. I have around 11 years of experience in IT Infrastructure. I started my career as a Desktop Support Engineer, where I worked for around six years. For the last five years, I have been working as a Linux and AWS Support Engineer.

In my current organization, my responsibilities are monitoring the Linux servers, handling production incidents, and ensuring all servers are running smoothly.

For AWS, I work with services like EC2, EBS, IAM, S3, VPC, CloudWatch, etc.

For monitoring and patching activities, we use tools like CloudWatch, Opsgenie, Grafana, and NinjaRMM.

We also coordinate with the application team, network team, database team, and cloud team to resolve production incidents.

My day starts with logging in to the monitoring tools to make sure all servers are running smoothly. After that, I check my emails and Jira tickets for any tasks assigned to me.

On a daily basis, we receive different types of alerts like high CPU utilization, memory utilization, disk utilization, MySQL replication issues, service down, etc. We also have physical servers, so sometimes we receive hardware replacement and power-related tickets.

If we receive any alert, we access the server through SSH, follow the required troubleshooting steps, and try to resolve the issue. If the issue is not resolved, we escalate it to the concerned team and share all our findings in the Jira ticket.

Currently, I am looking for an opportunity where I can utilize my AWS and Linux experience, expand my DevOps knowledge, and contribute to the organization's success.


Explain your Project and your role?

Our application is deployed on AWS and follows a 3-tier architecture. Users access the application through an Application Load Balancer. The Load Balancer distributes the traffic to EC2 instances managed by an Auto Scaling Group. The backend database is Amazon RDS deployed in private subnets. To ensure high availability, we use an Auto Scaling Group across multiple Availability Zones. We use CloudWatch for monitoring, EBS Snapshots for backup and recovery, and Security Groups to control traffic between different application tiers.

My responsibility includes monitoring Linux servers, handling production incidents, performing initial troubleshooting, and working with AWS services such as EC2, EBS, IAM, S3, CloudWatch, and CloudTrail. If required, I coordinate with the Application, Database, Network, and Cloud teams until the issue is resolved.

Project Based Question:-

-- Why did you use an Application Load Balancer in your project?
We use an Application Load Balancer because it works at Layer 7 of the OSI model. It supports path-based routing and host-based routing, which helps route requests based on the URL path or hostname.
It also distributes incoming traffic across multiple EC2 instances managed by the Auto Scaling Group, which helps improve application availability.

-- Why did you use Auto Scaling Group (ASG) in your project?

We use Auto Scaling Group to maintain high availability of the application. It is configured across multiple Availability Zones. If any EC2 instance becomes unhealthy, Auto Scaling automatically terminates it and launches a new EC2 instance using the Launch Template. It can also automatically scale out or scale in based on the traffic and scaling policy.

-- Why did you use Amazon RDS instead of installing MySQL on an EC2 instance?

We use Amazon RDS because it is a managed database service. It supports Multi-AZ deployment for high availability and provides automated backups. Database administration is handled by the database team. My role is mainly on the infrastructure side.

-- Why is your RDS deployed in a private subnet instead of a public subnet?

We deploy Amazon RDS in a private subnet because it stores sensitive user data. We don't want the database to be directly accessible from the internet. Keeping it in a private subnet provides better security. Only the application servers running on EC2 can access the database.

-- Why did you use Security Groups in your project?

We use Security Groups because they act as a virtual firewall for AWS resources. We define inbound and outbound rules to allow only the required ports and protocols.




-- Manually Snapshot failed. How will you troubleshoot?

First, I will go to AWS Console → EC2 → Snapshots, select the failed snapshot, and check the error message in the Status/Description section to understand why it failed.

Based on the error, I will verify the EBS volume from EC2 → Volumes and check whether the volume is in an In-use or Available state and ensure it is not deleted or in an error state.

If the error indicates an IAM permission issue, I will verify that the user or IAM role has the required ec2:CreateSnapshot permission.

After fixing the issue, I will retry creating the snapshot manually. If it still fails, I will collect the error details and escalate the issue to the Cloud Team or AWS Support.

-- A scheduled snapshot ran at night. In the morning you see it failed. What will you do?

First, I will go to EC2 → Lifecycle Manager (DLM) and check whether the DLM policy executed successfully or failed. Then I will check the failure reason. Based on the error, I will verify the source EBS volume status and ensure the IAM role used by DLM has the required permissions. After fixing the issue, I will manually create a snapshot to verify that the issue is resolved. If it still fails, I will collect the error details and escalate the issue to the Cloud Team or AWS Support.

-- Server crashed. What will you check? / Just tell me Backup and Restore.

First, I will check the EC2 instance state and status checks (Instance Status, System Status) from the AWS Console. If the instance can be recovered, I will try basic recovery actions like reboot or stop/start and troubleshoot the issue. If it is not recoverable, I will restore the server using the latest available snapshot and bring the application back online.

-- After restore, what will you check?

After the restore, first I will verify that the EC2 instance is in the Running state and all status checks are passing. Then I will verify that the EBS volume is properly attached and the filesystem is mounted correctly. After that, I will check that all required services are running, verify the application is accessible, and finally review the system and application logs to ensure everything is working properly.

-- What do you use for Disaster Recovery in your project?
-- All environment / AZ / Region failed, How you recover business?

Disaster Recovery means if any major disaster happens like Region failure or complete infrastructure failure and our application becomes unavailable, then we recover the application using our backup and DR plan.

First, we keep a DR environment ready in another Region. Normally, all user traffic goes to the Primary Region. If the Primary Region becomes unavailable due to any disaster, Route 53 Failover Routing automatically redirects the traffic to the DR Region. The passive servers become active, and users can continue accessing the application with minimum downtime. Once the Primary Region is healthy again, traffic is switched back to the Primary Region.

-- How is data available in DR?

The database team maintains the database replication between the primary and Secondary environments. From the infrastructure side, my responsibility is to ensure the DR environment is available and the application comes back online successfully.

-- Does the passive server always remain ON? If yes, the cost will be high. If no, how will it have the latest data?

It depends on the business requirement. If the business requires fast recovery, we keep the passive environment ready, but the cost is higher. If the business wants to reduce the cost, then the DR setup is designed accordingly.

-- RTO and RPO?

RTO means how much time the business allows us to recover the application after a disaster.
RPO means how much data loss the business allows during a disaster.

-- What networking activities have you performed in Linux?

In Linux, I mostly work on basic network troubleshooting. I check the server IP address using ip a, verify network connectivity using ping, test port connectivity using telnet or nc, check DNS resolution using nslookup or dig, and verify listening ports using ss -tunlp or netstat. If SSH is not working, I check the SSH service, firewall rules, and whether port 22 is listening. I also verify the routing table using ip route whenever required.

-- If the bash script fails, how will you troubleshoot?

First, I will run the script manually and check whether it is failing or not. If it fails, I will check the error message. Then I will verify whether the script has execute permission ls -l script.sh , check the shebang (#!/bin/bash), and make sure the file path and commands used in the script are correct. If the script is running through cron, I will verify the crontab entry and check the cron logs to confirm whether the job was triggered successfully. After fixing the issue, I will run the script again and verify the output.

-- SSH is not working. What will you do?

First I verify whether the EC2 instance is in the Running state.

Then I check both System Status Check and Instance Status Check.

Next I verify the Security Group and make sure port 22 is allowed.

Then I verify Network ACL, Route Table and Internet Gateway if it is a public server.

I also verify whether I am using the correct username and PEM key.

If SSH is still not working, I use EC2 Instance Connect, Systems Manager or Serial Console if available.

After logging into the server, I check whether the SSH service is running.

Then I check SSH logs.

I also check whether the disk is full because sometimes SSH does not work if the root filesystem is 100%.

If required, I restart the SSH service after verifying the issue.

Finally, I verify SSH connectivity and update the Jira ticket.

