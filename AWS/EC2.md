# 🚀 Amazon EC2 (Elastic Compute Cloud)

> **Amazon EC2 Documentation | Interview Preparation | Production Notes**


# 📖 Introduction

Amazon Elastic Compute Cloud (Amazon EC2) is one of the core AWS services that provides virtual servers in the cloud. It enables users to deploy applications without purchasing or maintaining physical hardware.

Amazon EC2 is designed to provide scalable, secure, and highly available compute resources for running applications of any size.

---

# 🚀 What is Amazon EC2?

### Definition

Amazon EC2 is a web service that provides secure and resizable virtual servers in the AWS Cloud.

### Explanation

Amazon EC2 allows you to launch Linux or Windows virtual machines within minutes. These virtual machines are called **Instances** and can be used to host websites, APIs, databases, enterprise applications, containerized workloads, and development environments.

Instead of purchasing expensive physical servers, organizations rent compute resources from AWS and pay only for the resources they consume.

### Common Use Cases

- Web Hosting
- Application Servers
- Development & Testing
- CI/CD Pipelines
- Big Data Processing
- Machine Learning Workloads
- Backup Servers

### Real World Example

A company launches multiple EC2 instances behind an Application Load Balancer to host its production website. During high traffic events, additional EC2 instances are automatically launched using Auto Scaling.

---

# 💻 Compute

### Definition

Compute refers to the processing resources required to run an application.

### Explanation

Compute represents the CPU, memory (RAM), operating system, and processing power required for executing workloads.

Without compute resources, applications cannot perform calculations, process requests, or serve users.

### Compute Resources Include

- CPU
- RAM
- Operating System
- Network Performance
- Storage Connectivity

### Real World Example

A Java application requires CPU for processing requests and RAM for storing active sessions. Amazon EC2 provides these compute resources without requiring physical hardware.

---

# ⭐ Amazon EC2 Features

Amazon EC2 offers the following capabilities:

- Resizable Compute Capacity
- Multiple Instance Types
- Multiple Operating Systems
- High Availability
- Elastic Scaling
- Secure Access
- Pay-As-You-Go Pricing
- Global Infrastructure
- Integration with IAM
- Integration with CloudWatch
- Integration with Elastic Load Balancer
- Integration with Auto Scaling

### Production Example

An enterprise application running on EC2 can automatically scale during business hours while remaining highly available across multiple Availability Zones.

---

# 📈 Scalability

### Definition

Scalability is the ability to increase or decrease computing resources based on business requirements.

### Explanation

As application traffic grows, additional resources are required to maintain performance. Scaling ensures that the application continues serving users efficiently.

There are two types of scaling.

## Vertical Scaling

Increasing the CPU or RAM of an existing EC2 instance.

Example

```
2 vCPU
4 GB RAM

↓

4 vCPU
8 GB RAM
```

Suitable for applications that require more processing power on a single server.

---

## Horizontal Scaling

Adding additional EC2 instances to distribute the workload.

Example

```
Before

        EC2

↓

After

EC2      EC2      EC2
```

Horizontal scaling improves both performance and availability.

### Production Example

During an online shopping festival, an e-commerce platform increases the number of EC2 instances from 5 to 50 to handle millions of customer requests.

---

# ⚡ Elasticity

### Definition

Elasticity is the automatic adjustment of compute resources based on workload demand.

### Explanation

Elasticity automatically provisions additional resources during traffic spikes and removes unnecessary resources when demand decreases.

Unlike manual scaling, elasticity minimizes operational effort while optimizing cost.

Example

```
Morning

2 EC2

↓

Afternoon

15 EC2

↓

Night

2 EC2
```

### Production Example

A food delivery application automatically launches additional EC2 instances during lunch and dinner hours and terminates them after peak traffic ends.

---

# 🌍 High Availability

### Definition

High Availability is the ability of an application to remain accessible even when a component fails.

### Explanation

High Availability is achieved by deploying EC2 instances across multiple Availability Zones. If one Availability Zone becomes unavailable, traffic is automatically redirected to healthy instances.

Example

```
Availability Zone A

EC2

        │
Application Load Balancer
        │

EC2

Availability Zone B
```

### Benefits

- Reduced downtime
- Improved reliability
- Fault tolerance
- Better customer experience

### Production Example

Internet banking applications deploy EC2 instances across multiple Availability Zones to ensure uninterrupted services even during infrastructure failures.

---

# 💰 Pay As You Go

### Definition

Pay only for the resources that you actually consume.

### Explanation

Amazon EC2 follows a usage-based pricing model where customers are billed only for the compute resources used.

There is no upfront investment for purchasing hardware.

### Benefits

- No Capital Expenditure
- Cost Optimization
- Flexible Scaling
- Suitable for Startups and Enterprises

### Production Example

A startup runs development servers only during office hours and stops them after work, significantly reducing cloud costs.

---

# 🧩 Amazon EC2 Components

An EC2 instance is created using multiple AWS components.

| Component | Purpose |
|------------|----------|
| AMI | Operating System Template |
| Instance Type | CPU & Memory Configuration |
| Key Pair | Secure Authentication |
| Security Group | Virtual Firewall |
| VPC | Networking |
| EBS Volume | Persistent Storage |
| IAM Role | Secure AWS Service Access |
| Tags | Resource Identification |

Understanding these components is essential for successfully launching and managing EC2 instances.

---

# 💿 Amazon Machine Image (AMI)

### Definition

An Amazon Machine Image (AMI) is a pre-configured template used to launch EC2 instances.

### Explanation

An AMI contains the operating system, application software, libraries, configuration files, and other settings required to launch an EC2 instance.

Instead of configuring every server manually, organizations create standardized AMIs for consistent deployments.

### Types of AMI

- AWS Managed AMI
- AWS Marketplace AMI
- Custom AMI

### Production Example

A company installs Ubuntu, Java, Docker, CloudWatch Agent, security patches, and monitoring tools on one server.

Instead of repeating the installation every time, they create a Custom AMI and launch all future servers using that image.

This ensures consistency across environments.

---

# 🖥 Instance Types

### Definition

An Instance Type defines the hardware configuration of an EC2 instance.

### Explanation

Instance Types determine the CPU, memory, storage performance, and networking capacity available to an EC2 instance.

Different workloads require different instance types.

### Common Families

| Family | Best For |
|---------|----------|
| T | General Purpose |
| M | Balanced Workloads |
| C | Compute Optimized |
| R | Memory Optimized |
| I | Storage Optimized |
| G | GPU Workloads |

### Production Example

- **t3.micro** → Learning & Development
- **m6i.large** → Business Applications
- **c6i.large** → Compute Intensive Applications
- **r6g.large** → Databases
- **g5.xlarge** → Machine Learning & Graphics

---# 🔑 Key Pair

### Definition

A Key Pair is a set of cryptographic keys used to securely access an EC2 instance.

### Explanation

A Key Pair consists of:

- Public Key
- Private Key (.pem)

The public key is stored on the EC2 instance, while the private key is downloaded by the user during key pair creation.

When connecting to a Linux EC2 instance using SSH, AWS verifies that the private key matches the stored public key.

### Authentication Flow

```
Private Key (.pem)
        │
        ▼
SSH Authentication
        │
        ▼
Public Key on EC2
        │
        ▼
Access Granted
```

### Linux Login

```bash
ssh -i my-key.pem ec2-user@Public-IP
```

### Windows Login

Windows instances generally use **RDP (Remote Desktop Protocol)** with an administrator password decrypted using the key pair.

### Best Practices

- Store the private key securely.
- Never share the `.pem` file.
- Restrict file permissions (`chmod 400 key.pem`).
- Use Systems Manager Session Manager whenever possible instead of direct SSH.

### Production Example

An administrator connects to a production Linux server using SSH with a private key instead of using passwords.

---

# 🛡 Security Group

### Definition

A Security Group is a virtual firewall that controls inbound and outbound traffic for an EC2 instance.

### Explanation

Security Groups protect EC2 instances by allowing only the required network traffic.

They are **Stateful**, meaning if inbound traffic is allowed, the response traffic is automatically allowed.

### Common Rules

| Protocol | Port | Purpose |
|----------|------|----------|
| SSH | 22 | Linux Remote Login |
| RDP | 3389 | Windows Remote Login |
| HTTP | 80 | Website |
| HTTPS | 443 | Secure Website |

### Example

```
Internet
     │
     ▼

Security Group

22  ✔ Office IP

80  ✔ Everyone

443 ✔ Everyone

3306 ❌ Blocked
```

### Best Practices

- Allow SSH only from trusted IP addresses.
- Never allow unnecessary ports.
- Follow the Principle of Least Privilege.
- Separate Security Groups for Web, Application and Database servers.

### Production Example

A production web server allows:

- HTTP (80) from Everyone
- HTTPS (443) from Everyone
- SSH (22) only from the company's VPN IP.

---

# 🌐 Elastic IP

### Definition

An Elastic IP is a static public IPv4 address provided by AWS.

### Explanation

Normally, a Public IP changes when an EC2 instance is stopped and started.

Elastic IP ensures the public IP remains the same.

This is useful for applications where clients, DNS records, or firewalls depend on a fixed IP address.

### Example

Without Elastic IP

```
Today

54.x.x.x

↓

Restart

13.x.x.x
```

With Elastic IP

```
54.x.x.x

↓

Restart

54.x.x.x
```

### Best Practices

- Allocate Elastic IP only when required.
- Release unused Elastic IPs to avoid unnecessary charges.
- Associate Elastic IP with production servers requiring static public access.

### Production Example

A banking application maps its DNS record to an Elastic IP so that customers always connect to the same public IP.

---

# 🔄 EC2 Lifecycle

### Definition

The EC2 Lifecycle represents the different operational states of an EC2 instance.

### Lifecycle

```
Launch
   │
Pending
   │
Running
├── Reboot
├── Stop
├── Start
├── Hibernate
└── Terminate
```

### State Description

| State | Description |
|--------|-------------|
| Pending | Instance is launching |
| Running | Instance is operational |
| Reboot | Operating System restarts |
| Stop | Instance stops but EBS remains |
| Start | Starts a stopped instance |
| Hibernate | Saves RAM to EBS before stopping |
| Terminate | Permanently deletes the instance |

### Important Notes

- Reboot does not change the Instance ID.
- Stop retains EBS volumes.
- Terminate deletes the instance (unless Delete on Termination is disabled for attached volumes).
- Hibernate resumes applications from the previous memory state.

### Production Example

Development servers are stopped after office hours to reduce compute costs while retaining their EBS volumes.

---

# 📜 User Data

### Definition

User Data is a bootstrap script that runs automatically when an EC2 instance launches.

### Explanation

User Data automates software installation and initial server configuration.

This removes manual configuration after launching an instance.

### Example Script

```bash
#!/bin/bash

yum update -y

yum install httpd -y

systemctl enable httpd

systemctl start httpd

echo "Welcome to AWS EC2" > /var/www/html/index.html
```

### Best Practices

- Keep User Data scripts idempotent where possible.
- Use version-controlled scripts.
- Avoid storing passwords or secrets directly in User Data.

### Production Example

Every new web server automatically installs Apache, configures services, and deploys the application during launch.

---

# 💰 Purchase Options

### Definition

Purchase Options determine how you pay for EC2 instances.

### Available Options

| Option | Best For |
|----------|----------|
| On-Demand | Short-term workloads |
| Reserved | Long-term predictable workloads |
| Spot | Fault-tolerant workloads |
| Dedicated Instance | Compliance requirements |
| Dedicated Host | License-bound software |

### Best Practices

- Use On-Demand for development.
- Use Reserved Instances or Savings Plans for long-running production workloads.
- Use Spot Instances for batch processing and CI/CD jobs.

### Production Example

A media company uses Spot Instances to process video files because interruptions can be tolerated.

---

# 📍 Placement Groups

### Definition

Placement Groups define how EC2 instances are physically placed within AWS infrastructure.

### Types

## Cluster Placement Group

Instances are placed close together.

**Use Case**

- High Performance Computing (HPC)
- Low Latency Applications

---

## Partition Placement Group

Instances are distributed across separate partitions.

**Use Case**

- Hadoop
- Kafka
- Cassandra

---

## Spread Placement Group

Each instance is placed on separate hardware.

**Use Case**

- Critical Applications
- Domain Controllers
- Small Production Clusters

### Best Practices

- Cluster → Maximum Performance
- Partition → Large Distributed Systems
- Spread → Maximum Fault Isolation

### Production Example

Financial applications deploy critical servers using Spread Placement Groups to reduce the impact of hardware failures.

---

# 📊 Monitoring

### Definition

Monitoring is the process of tracking the health and performance of EC2 instances.

### Amazon CloudWatch Metrics

- CPU Utilization
- Network In
- Network Out
- Disk Read Operations
- Disk Write Operations
- Status Check Failed

### Monitoring Types

| Type | Frequency |
|--------|-----------|
| Basic Monitoring | Every 5 Minutes |
| Detailed Monitoring | Every 1 Minute |

### Best Practices

- Enable Detailed Monitoring for production workloads.
- Configure CloudWatch Alarms.
- Send notifications using Amazon SNS.
- Continuously monitor CPU, memory, and disk usage.

### Production Example

If CPU Utilization remains above 80% for five minutes, CloudWatch triggers an alarm that automatically notifies the operations team through Amazon SNS.

---
# 🚨 EC2 Production Troubleshooting Scenarios

---

## Scenario 1: Unable to SSH into EC2

### Symptoms
- SSH connection timeout
- Permission denied
- Connection refused

### Possible Causes
- Port 22 blocked in Security Group
- Wrong Key Pair
- Incorrect Public IP
- EC2 Instance stopped
- NACL blocking traffic

### Troubleshooting
- Verify EC2 is running.
- Check Security Group allows TCP 22.
- Confirm the correct Public IP.
- Verify the private key (.pem).
- Review NACL rules.
- Check the SSH service status from the console (if possible).

### Resolution
Allow SSH from your IP, use the correct key pair, and ensure the instance is reachable.

---

## Scenario 2: Website is Not Accessible

### Symptoms
- Website not opening
- Browser timeout
- 502/503 errors

### Possible Causes
- Apache/Nginx service stopped
- HTTP/HTTPS blocked
- Application crashed
- Wrong DNS
- Load Balancer issue

### Troubleshooting
- Verify EC2 is running.
- Check web server status.
- Verify Security Group (80/443).
- Review application logs.
- Check DNS configuration.

### Resolution
Restart the web service and fix the failed component.

---

## Scenario 3: High CPU Utilization

### Symptoms
- Slow application
- High response time

### Possible Causes
- High user traffic
- Infinite loop
- Java process consuming CPU
- Cron job

### Commands

```bash
top
htop
ps -ef
```

### Resolution

- Kill unnecessary process.
- Restart application.
- Scale the instance or Auto Scaling Group.

---

## Scenario 4: High Memory Usage

### Symptoms

- Server becomes slow
- Out Of Memory errors

### Commands

```bash
free -m
top
vmstat
```

### Resolution

- Restart memory consuming service.
- Increase RAM.
- Fix memory leak.

---

## Scenario 5: Disk Full

### Symptoms

- Unable to write logs
- Application crash

### Commands

```bash
df -h
du -sh /*
find / -type f -size +500M
```

### Resolution

- Delete unnecessary files.
- Rotate logs.
- Extend EBS Volume.

---

## Scenario 6: EC2 Status Check Failed

### Symptoms

AWS Console shows

Status Check Failed

### Possible Causes

- Hardware issue
- OS issue
- Kernel panic

### Resolution

- Reboot instance.
- Review system logs.
- Recover or replace instance if required.

---

## Scenario 7: Instance Not Reachable

### Possible Causes

- Wrong Route Table
- Internet Gateway missing
- NACL issue
- Security Group issue
- Public IP missing

### Resolution

Verify VPC networking configuration.

---

## Scenario 8: Public IP Changed

### Cause

Instance was stopped and started.

### Resolution

Use an Elastic IP for servers requiring a static public address.

---

## Scenario 9: Application Down After Deployment

### Possible Causes

- Application failed to start
- Configuration issue
- Missing dependency

### Resolution

- Check application logs.
- Roll back the deployment.
- Restart the service.

---

## Scenario 10: User Data Script Failed

### Symptoms

Application not installed after launch.

### Troubleshooting

```bash
cat /var/log/cloud-init-output.log
```

### Resolution

Correct the script and relaunch the instance.

---

## Scenario 11: Unable to Download Packages

### Possible Causes

- Internet Gateway missing
- NAT Gateway issue
- DNS issue

### Resolution

Verify outbound internet connectivity.

---

## Scenario 12: Instance Accidentally Terminated

### Resolution

- Launch a new instance from AMI.
- Restore EBS Snapshot.
- Recover application using backups.

---

## Scenario 13: CloudWatch Alarm Triggered

### Example

CPU > 80%

### Resolution

- Identify high CPU process.
- Restart service if required.
- Scale resources.

---

## Scenario 14: Storage Running Out Frequently

### Resolution

- Enable log rotation.
- Monitor disk usage.
- Increase EBS size.
- Archive old data.

---

## Scenario 15: Login Successful but Server Very Slow

### Possible Causes

- High CPU
- High Memory
- Disk Utilization
- Heavy Application Load

### Commands

```bash
top
free -m
iostat
vmstat
df -h
```

### Resolution

Identify the bottleneck and optimize or scale resources.

---

## ⭐ Interview Tip

During interviews, always explain troubleshooting in this order:

1. Understand the issue.
2. Verify the EC2 instance state.
3. Check networking (VPC, Route Table, IGW, NACL, Security Group).
4. Check OS health (CPU, Memory, Disk).
5. Check application logs.
6. Implement the fix.
7. Monitor the service after recovery.
8. Perform RCA and document preventive actions.
