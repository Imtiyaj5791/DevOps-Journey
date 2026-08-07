# 🚀 Ericsson Interview Questions

> **Status:** ✅ Completed  
> **Role:** AWS Linux Support Engineer

---

# 👨‍💼 Tell Me About Yourself

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

---

# 🏗️ Explain Your Project and Your Role

Our application is deployed on AWS and follows a 3-tier architecture. Users access the application through an Application Load Balancer. The Load Balancer distributes the traffic to EC2 instances managed by an Auto Scaling Group. The backend database is Amazon RDS deployed in private subnets. To ensure high availability, we use an Auto Scaling Group across multiple Availability Zones. We use CloudWatch for monitoring, EBS Snapshots for backup and recovery, and Security Groups to control traffic between different application tiers.

My responsibility includes monitoring Linux servers, handling production incidents, performing initial troubleshooting, and working with AWS services such as EC2, EBS, IAM, S3, CloudWatch, and CloudTrail. If required, I coordinate with the Application, Database, Network, and Cloud teams until the issue is resolved.

---

# 📚 Project Based Questions

## ❓ Why did you use an Application Load Balancer in your project?

We use an Application Load Balancer because it works at Layer 7 of the OSI model. It supports path-based routing and host-based routing, which helps route requests based on the URL path or hostname.

It also distributes incoming traffic across multiple EC2 instances managed by the Auto Scaling Group, which helps improve application availability.

---

## ❓ Why did you use Auto Scaling Group (ASG) in your project?

We use Auto Scaling Group to maintain high availability of the application. It is configured across multiple Availability Zones. If any EC2 instance becomes unhealthy, Auto Scaling automatically terminates it and launches a new EC2 instance using the Launch Template. It can also automatically scale out or scale in based on the traffic and scaling policy.

---

## ❓ Why did you use Amazon RDS instead of installing MySQL on an EC2 instance?

We use Amazon RDS because it is a managed database service. It supports Multi-AZ deployment for high availability and provides automated backups. Database administration is handled by the database team. My role is mainly on the infrastructure side.

---

## ❓ Why is your RDS deployed in a private subnet instead of a public subnet?

We deploy Amazon RDS in a private subnet because it stores sensitive user data. We don't want the database to be directly accessible from the internet. Keeping it in a private subnet provides better security. Only the application servers running on EC2 can access the database.

---
---

# 📸 Manual Snapshot Failed

## ❓ Manually Snapshot failed. How will you troubleshoot?

First, I will go to **AWS Console → EC2 → Snapshots**, select the failed snapshot, and check the error message in the **Status/Description** section to understand why it failed.

Based on the error, I will verify the **EBS Volume** from **EC2 → Volumes** and check whether the volume is in an **In-use** or **Available** state. I will also make sure the volume is not deleted or in an error state.

If the error indicates an IAM permission issue, I will verify that the user or IAM Role has the required **ec2:CreateSnapshot** permission.

After fixing the issue, I will retry creating the snapshot manually. If it still fails, I will collect the error details and escalate the issue to the Cloud Team or AWS Support.

---

# 🌙 Scheduled Snapshot (DLM)

## ❓ A scheduled snapshot ran at night. In the morning you see it failed. What will you do?

First, I will go to **EC2 → Lifecycle Manager (DLM)** and check whether the DLM policy executed successfully or failed.

Then I will check the failure reason. Based on the error, I will verify the source EBS volume status and ensure the IAM Role used by DLM has the required permissions.

After fixing the issue, I will manually create a snapshot to verify that the issue is resolved. If it still fails, I will collect the error details and escalate the issue to the Cloud Team or AWS Support.

---

# 💥 Server Crash / Backup & Restore

## ❓ Server crashed. What will you check? / Just tell me Backup and Restore.

First, I will check the EC2 instance state and status checks (**Instance Status** and **System Status**) from the AWS Console.

If the instance can be recovered, I will try basic recovery actions like **reboot** or **stop/start** and troubleshoot the issue.

If it is not recoverable, I will restore the server using the latest available snapshot and bring the application back online.

---

# ✅ Post Restore Validation

## ❓ After restore, what will you check?

After the restore, first I will verify that the EC2 instance is in the **Running** state and all status checks are passing.

Then I will verify that the EBS volume is properly attached and the filesystem is mounted correctly.

After that, I will check that all required services are running, verify the application is accessible, and finally review the system and application logs to ensure everything is working properly.

---

# 🛡️ Disaster Recovery (DR)

## ❓ What do you use for Disaster Recovery in your project?

## ❓ All Environment / AZ / Region failed. How do you recover the business?

Disaster Recovery means if any major disaster happens, such as Region failure or complete infrastructure failure, and our application becomes unavailable, then we recover the application using our backup and DR plan.

First, we keep a DR environment ready in another Region.

Normally, all user traffic goes to the **Primary Region**.

If the Primary Region becomes unavailable due to any disaster, **Route 53 Failover Routing** automatically redirects the traffic to the **DR Region**.

The passive servers become active, and users can continue accessing the application with minimum downtime.

Once the Primary Region becomes healthy again, traffic is switched back to the Primary Region.

---

## ❓ How is data available in DR?

The database team maintains the database replication between the **Primary** and **Secondary** environments.

From the infrastructure side, my responsibility is to ensure the DR environment is available and the application comes back online successfully.

---

## ❓ Does the passive server always remain ON? If yes, the cost will be high. If no, how will it have the latest data?

It depends on the business requirement.

If the business requires fast recovery, we keep the passive environment ready, but the cost is higher.

If the business wants to reduce the cost, then the DR setup is designed accordingly.

---

## ❓ What is RTO and RPO?

**RTO (Recovery Time Objective)** means how much time the business allows us to recover the application after a disaster.

**RPO (Recovery Point Objective)** means how much data loss the business allows during a disaster.

---

# 🌐 Linux Networking

## ❓ What networking activities have you performed in Linux?

In Linux, I mostly work on basic network troubleshooting.

- Check server IP address using `ip a`
- Verify network connectivity using `ping`
- Test port connectivity using `telnet` or `nc`
- Check DNS resolution using `nslookup` or `dig`
- Verify listening ports using `ss -tunlp` or `netstat`
- Check SSH service, firewall rules, and port 22
- Verify routing table using `ip route`

---

# 📝 Bash Script Troubleshooting

## ❓ If the bash script fails, how will you troubleshoot?

First, I will run the script manually and check whether it is failing or not.

If it fails, I will check the error message.

Then I will:

- Verify execute permission using `ls -l script.sh`
- Check the shebang (`#!/bin/bash`)
- Verify the file path and commands used in the script

If the script is running through Cron, I will verify the crontab entry and check the Cron logs to confirm whether the job was triggered successfully.

After fixing the issue, I will run the script again and verify the output.

---

# 🔐 SSH Troubleshooting

## ❓ SSH is not working. What will you do?

First, I verify whether the EC2 instance is in the **Running** state.

Then I check both **System Status Check** and **Instance Status Check**.

Next, I verify the **Security Group** and make sure **Port 22** is allowed.

Then I verify the **Network ACL**, **Route Table**, and **Internet Gateway** if it is a public server.

I also verify whether I am using the correct username and PEM key.

If SSH is still not working, I use **EC2 Instance Connect**, **Systems Manager**, or **Serial Console** if available.

After logging into the server, I check whether the SSH service is running.

Then I check the SSH logs.

I also check whether the disk is full because sometimes SSH does not work if the root filesystem is 100%.

If required, I restart the SSH service after verifying the issue.

Finally, I verify SSH connectivity and update the Jira ticket.

---

# 🚀 Atos Jubilant Interview Questions

> **Status:** ✅ Completed  
> **Role:** AWS Linux Support Engineer

---

# 🔐 Private VPC Access

## ❓ Our server is in a private VPC. I want to access it, but I don't want to use an Internet Gateway or Bastion Host. How will you access it?

If the server is in a private subnet and we don't want to use an Internet Gateway or Bastion Host, then we can use **AWS Systems Manager (SSM) Session Manager** to connect to the server.

Another option is **EC2 Instance Connect Endpoint**.

If it is a corporate environment, we can also access the private server through a **Site-to-Site VPN** or **AWS Direct Connect**.

---

# 💾 Amazon EBS

## ❓ What is the difference between gp2 and gp3?

Both gp2 and gp3 are **General Purpose SSD** volumes.

gp3 is more flexible and cost-effective than gp2.

In gp2, the performance depends on the volume size (**3 IOPS per GB**).

In gp3, we get **3000 IOPS by default** and can increase **IOPS** and **Throughput** independently without increasing the volume size.

That's why many organizations migrate from gp2 to gp3.

---

## ❓ Can we increase the volume size in gp2?

Yes, we can increase the volume size in gp2.

---

# 🖥️ EC2 Health Checks

## ❓ What is 3/3 Status Check in AWS?

- **System Status Check** → Checks the AWS infrastructure, such as host hardware, power, or network issues.

- **Instance Status Check** → Checks the operating system inside the EC2 instance, such as OS boot issues or network configuration problems.

- **EBS Status Check** → Checks whether the attached EBS volume is healthy and accessible.

---

# 🪣 Mount S3 to EC2

## ❓ How to mount S3 to EC2?

First, I will create an IAM Role with the required S3 permissions and attach it to the EC2 instance.

Then I will install the **s3fs-fuse** package.

After that, I will create a mount point, for example:

```bash
/mnt/s3-bucket
```

Then I will mount the S3 bucket using **s3fs**.

I don't remember the exact mount command.

Finally, if I want a permanent mount, I will add the entry to **/etc/fstab** and verify it using:

```bash
df -h
```

---

# 🌐 VPC Networking

## ❓ VPC Peering vs Transit Gateway

Both VPC Peering and Transit Gateway are used for private communication between multiple VPCs.

VPC Peering is suitable for connecting a small number of VPCs.

If we have many VPCs, such as **10–20**, we use **Transit Gateway** because it acts as a centralized hub and is much easier to manage than creating multiple peering connections.

---

## ❓ Can VPC Peering connect VPCs with overlapping CIDR?

No, we cannot create VPC Peering between VPCs with overlapping CIDR ranges.

Both VPCs must have different CIDR blocks; otherwise, AWS will not allow the peering connection because it creates routing conflicts.

---

## ❓ If both VPCs have the same CIDR, how will you connect them?

VPC Peering is not supported with overlapping CIDRs.

In that case, we first need to redesign the network and assign a different CIDR block to one of the VPCs.

After that, we can create the peering connection.

---

# 🛡️ Security

## ❓ Difference between Security Group, NACL, Internet Gateway, and NAT Gateway

Security Group and NACL both act as firewalls.

A **Security Group** works at the **Instance Level**, whereas a **Network ACL** works at the **Subnet Level**.

Security Groups support only **Allow Rules**, while NACLs support both **Allow** and **Deny Rules**.

Security Groups are **Stateful**, whereas NACLs are **Stateless**.

An **Internet Gateway** provides internet connectivity to resources in a public subnet.

A **NAT Gateway** is used to provide outbound internet access for EC2 instances in a private subnet without allowing inbound connections from the internet.

---

# 🐧 Linux Troubleshooting

## ❓ System is slow because disk usage is 100%. What will you perform on the OS side without moving to the AWS side?

First, I will check which filesystem is full using:

```bash
df -h
```

Then I will identify which directory is consuming more space using:

```bash
du -sh
```

or

```bash
du -sh /*
```

If the space is occupied by logs, I will check whether old logs can be archived or deleted as per the company policy.

If temporary files are consuming space, I will clean them.

If any application or process is generating large files unexpectedly, I will coordinate with the application team.

After freeing up the required space, I will verify that disk usage has come down and check whether the server performance is back to normal.

---

# ✅ Atos Jubilant Interview Preparation Completed
## ❓ Why did you use Security Groups in your project?

We use Security Groups because they act as a virtual firewall for AWS resources. We define inbound and outbound rules to allow only the required ports and protocols.
