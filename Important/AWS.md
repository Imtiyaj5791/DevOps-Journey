

---

# What is EC2? How have you used EC2 in your current environment?

EC2 (Elastic Compute Cloud) is an AWS compute service that provides scalable and pay-as-you-go virtual servers where we can deploy and run applications.

### Experience

Yes, I have worked with EC2 in my current environment.

- We use EC2 instances to host applications and services.
- I monitor EC2 instances and troubleshoot issues such as:
  - High CPU utilization
  - SSH connectivity issues
  - Instance health issues
  - Application availability problems

### Example

Sometimes CPU utilization reaches 100% and users are unable to connect through SSH.

I perform initial troubleshooting and verify CloudWatch metrics. If required and approved by the client, I restart the instance from the AWS Console and perform post-checks to ensure services are healthy.

We also use EC2 instances as development machines. During patching windows:

- Start required EC2 instances
- Perform patching activities
- Validate applications
- Stop instances after maintenance to optimize cost

### Useful Commands

```bash
uptime
```

```bash
top
```

```bash
free -h
```

```bash
df -h
```

---

# What are the different states of an EC2 instance?

EC2 instances go through different states during their lifecycle.

### Pending

AWS is preparing and launching the instance.

### Running

Instance is available and ready for use.

### Stopping

Instance is in the process of stopping.

### Stopped

Instance is stopped but EBS volumes remain attached and data is preserved.

### Shutting-down

Instance is being terminated.

### Terminated

Instance is permanently deleted and cannot be started again.

---

# What is the difference between Stop, Reboot and Terminate?

## Stop

- Temporarily stops the instance.
- Can be started again later.
- EBS storage remains attached.
- Data is preserved.

## Reboot

- Restarts the operating system.
- Instance remains available after reboot.
- Generally used for OS-level issues.

## Terminate

- Permanently deletes the instance.
- Cannot be started again.
- EBS volume is deleted if DeleteOnTermination is enabled.
- Detached EBS volumes can be reattached for data recovery.

---

# What is AMI in AWS? How have you used AMI?

AMI (Amazon Machine Image) is a pre-configured template used to launch EC2 instances.

An AMI contains:

- Operating System
- Installed Applications
- Packages
- Configurations

### Usage

We use AMIs to create identical servers quickly without performing manual installation and configuration.

---

# What is the difference between Security Group and NACL?

Both Security Groups and NACLs are used to control network traffic.

## Security Group

- Instance-level firewall
- Stateful
- Supports only Allow rules

Example:

```text
Allow TCP 22 from 10.10.10.0/24
```

## NACL

- Subnet-level firewall
- Stateless
- Supports Allow and Deny rules

Example:

```text
Allow TCP 22
Deny TCP 23
```

---

# What is the difference between Public IP, Private IP and Elastic IP?

## Public IP

- Used for internet communication.
- Can change after stop/start operation.

## Private IP

- Used for communication inside VPC.
- Not accessible directly through the internet.
- Remains associated with the instance.

## Elastic IP

- Static public IP address.
- Remains same even after stop/start.
- Commonly used for Bastion Hosts and public-facing applications.

---

# What are the different types of EBS volumes? Which one have you used?

## gp2 / gp3

General Purpose SSD.

Commonly used for:

- Application servers
- Web servers
- Linux servers

## io1 / io2

Provisioned IOPS SSD.

Used for:

- Databases
- High-performance applications

## st1

Throughput Optimized HDD.

Used for:

- Big data
- Log processing

## sc1

Cold HDD.

Used for:

- Archival workloads
- Infrequently accessed data

### Experience

Mostly worked with **gp3** volumes.

---

# What is the difference between gp2 and gp3?

## gp2

- IOPS depends on volume size.
- Less flexible.

## gp3

- 3000 IOPS included by default.
- IOPS and throughput can be increased independently.
- More cost-effective.
- Better performance flexibility.

---

# How do you attach and mount a new EBS volume?

### Verify New Disk

```bash
lsblk
```

### Create Filesystem

For Ext4:

```bash
mkfs.ext4 /dev/xvdf
```

For XFS:

```bash
mkfs.xfs /dev/xvdf
```

### Create Mount Point

```bash
mkdir /data
```

### Mount Filesystem

```bash
mount /dev/xvdf /data
```

### Verify Mount

```bash
df -h
```

### Permanent Mount

Get UUID:

```bash
blkid
```

Edit fstab:

```bash
vi /etc/fstab
```

Example:

```text
UUID=xxxxxxxx /data ext4 defaults 0 0
```

Validate:

```bash
mount -a
```

---

# How do you increase the size of an EBS volume?

### Verify Disk

```bash
lsblk
```

### Grow Partition

```bash
growpart /dev/nvme0n1 1
```

### Ext4 Filesystem

```bash
resize2fs /dev/nvme0n1p1
```

### XFS Filesystem

```bash
xfs_growfs /
```

### Verify

```bash
df -h
```

---

# What is the difference between EBS Snapshot and AMI?

## Snapshot

- Backup of EBS volume.
- Used for volume restoration.
- Contains only disk data.

## AMI

- Complete machine template.
- Contains:
  - Operating System
  - Configuration
  - Applications
  - EBS snapshot references

AMI is used to launch new EC2 instances, while snapshots are used for backup and recovery.

---

# EC2 instance is running but application is not accessible. How will you troubleshoot?

### Check Listening Port

```bash
ss -tulnp
```

### Check Service Status

```bash
systemctl status <service_name>
```

### Check Application Logs

```bash
journalctl -u <service_name>
```

### Verify Security Groups

Confirm required ports are allowed.

### Verify NACL Rules

Check subnet-level filtering.

### Check Load Balancer

- Target Group Health
- Health Check Path
- Health Check Port

### Check ASG

Verify whether new instances are launching successfully.

---

# What happens when an EC2 instance goes down unexpectedly?

### Check Reboot History

```bash
last reboot
```

### Check Uptime

```bash
uptime
```

### Check System Logs

Previous boot logs:

```bash
journalctl -b -1
```

### Check CloudTrail

Verify who performed:

- Reboot
- Stop
- Terminate actions

### Review CloudWatch

Check:

- CPU
- Memory
- Disk
- Status Checks

---

# Users are unable to open the website. How will you troubleshoot?

### Check DNS Resolution

```bash
nslookup website.com
```

or

```bash
dig website.com
```

### Verify Load Balancer

Check:

- Listener configuration
- Target Group health

### Verify Application Port

```bash
ss -tulnp
```

### Check Service

```bash
systemctl status <service_name>
```

### Review Logs

```bash
tail -100f /var/log/application.log
```

### Restart Service (After Approval)

```bash
systemctl restart <service_name>
```

---

# Website is slow. How will you troubleshoot?

### Check CPU

```bash
top
```

### Check Memory

```bash
free -h
```

### Check Disk

```bash
df -h
```

### Check Processes

```bash
ps aux --sort=-%cpu | head
```

```bash
ps aux --sort=-%mem | head
```

### Check Service

```bash
systemctl status <service_name>
```

### Check Port

```bash
ss -tulnp
```

### Review CloudWatch

Validate:

- CPU
- Memory
- Response time
- Load Balancer latency

---

# What is VPC and how have you used it?

VPC (Virtual Private Cloud) is an isolated network in AWS where we can define our own networking architecture.

### Components

- CIDR Block
- Subnets
- Route Tables
- Security Groups
- NACLs
- Internet Gateway

### Experience

In my environment we use VPCs to:

- Create public and private subnets
- Deploy EC2 instances
- Configure routing and security
- Isolate workloads

---

# Difference Between Public and Private Subnet

## Public Subnet

Has route to Internet Gateway.

Example Route:

```text
0.0.0.0/0 → IGW
```

## Private Subnet

No direct route to Internet Gateway.

Uses NAT Gateway for outbound internet access.

Example Route:

```text
0.0.0.0/0 → NAT Gateway
```

---

# What is a Route Table?

Route Table determines where network traffic should be routed.

### Example

Public Subnet Route:

```text
10.0.0.0/16 → Local
0.0.0.0/0 → IGW
```

Private Subnet Route:

```text
10.0.0.0/16 → Local
0.0.0.0/0 → NAT Gateway
```

---

# What is Internet Gateway (IGW)?

Internet Gateway enables communication between a VPC and the internet.

Requirements:

- Public IP
- Route to IGW
- Security Group access

---

# What is NAT Gateway?

NAT Gateway provides outbound internet access for resources in private subnets.

### Example

Private EC2 server:

- Download patches
- Install packages
- Access internet

Without exposing the server publicly.

---

# How does a private EC2 instance access the internet?

Private EC2 instances access the internet using:

1. NAT Gateway
2. Route Table pointing to NAT Gateway
3. Elastic IP attached to NAT Gateway

---

# How will you connect to a private EC2 instance?

## Using Bastion Host

Connect to Bastion Server:

```bash
ssh ec2-user@public-ip
```

Then connect to private server:

```bash
ssh ec2-user@private-ip
```

## Other Methods

- AWS Systems Manager (SSM)
- VPN
- AWS Direct Connect

---

# What is VPC Peering?

VPC Peering provides private communication between two VPCs.

Benefits:

- No internet required
- Low latency communication
- Private connectivity

---

# What is Transit Gateway?

Transit Gateway acts as a central hub to connect:

- Multiple VPCs
- On-Premises Networks
- VPN Connections

Without creating multiple VPC peering connections.

---

# What is VPC Endpoint?

VPC Endpoint allows private access to AWS services without using the internet.

Example:

Private EC2 → S3

Traffic remains within AWS network.

No requirement for:

- Internet Gateway
- NAT Gateway

---

# What are VPC Flow Logs?

VPC Flow Logs capture network traffic information.

Useful for troubleshooting:

- Connectivity issues
- Security issues
- Traffic analysis

Information includes:

- Source IP
- Destination IP
- Source Port
- Destination Port
- Protocol
- ACCEPT / REJECT status

### Example Investigation

Check whether traffic is blocked by Security Group or NACL by reviewing VPC Flow Logs in:

```text
CloudWatch Logs
```

or

```text
Amazon S3
```


## What is IAM?

IAM (Identity and Access Management) is a global AWS service used for authentication and authorization. It controls who can access AWS resources and what actions they can perform. Using IAM, we can create users, groups, roles and policies to provide secure access to AWS resources.

**Authentication** means verifying the identity of the user (Who are you?).

**Authorization** means deciding what resources and actions the user is allowed to access (What can you do?).

---

## What is the difference between IAM User, Group, Role and Policy?

### User
User is an identity created in IAM to access AWS resources. There are two types of users:

- Root User – Full access to the AWS account.
- IAM User – Permissions are assigned based on business requirements following the least privilege principle.

### Group
Group is a collection of IAM users. Instead of assigning permissions to each user individually, we assign permissions to the group and add users to that group.

### Role
IAM Role provides temporary permissions. It is mainly used by AWS services like EC2, Lambda, ECS, or users from another AWS account to access AWS resources securely without storing access keys.

### Policy
Policy is a JSON document that defines what actions are allowed or denied on AWS resources. Policies are attached to users, groups or roles.

---

## Why do we use IAM Role instead of Access Keys on EC2?

IAM Role is more secure because it provides temporary credentials and avoids hardcoded Access Keys.

---

## How do you manage user permissions in your current environment?

In my environment, user permissions are managed using IAM Groups and Policies. When a new user needs access, the Engineering team adds the user to the appropriate IAM Group, and the required permissions are inherited through the attached IAM Policy following the least privilege principle.

---

## What is the principle of Least Privilege?

Least Privilege means providing only the minimum permissions required for a user or application to perform its task. We should not give unnecessary permissions. We also enable MFA for additional security wherever required.

---

## What is MFA?

MFA (Multi-Factor Authentication) provides an extra layer of security. Along with username and password, the user must verify identity using an OTP or authentication app.

---

## What is IAM Policy? What are the types?

IAM Policy is a JSON document that defines permissions.

Types:

- AWS Managed Policy
- Customer Managed Policy

---

# Amazon S3

## What is Amazon S3? How have you used it in your environment?

Amazon S3 (Simple Storage Service) is an object storage service used to store and retrieve large amounts of data. It provides high availability, scalability and 99.999999999% (11 9's) durability.

In my environment, we use S3 to store application logs, backups and other required files.

---

## What are the different S3 Storage Classes?

- S3 Standard – Frequently accessed data.
- S3 Standard-IA – Infrequent access data.
- S3 One Zone-IA – Stored in a single Availability Zone.
- S3 Intelligent-Tiering – Automatically moves data between storage tiers.
- S3 Glacier Instant Retrieval – Archive data with fast retrieval.
- S3 Glacier Flexible Retrieval – Long-term archive.
- S3 Glacier Deep Archive – Lowest-cost long-term archival storage.

---

## What is Versioning in S3 and why do we use it?

Versioning keeps multiple versions of the same object in an S3 bucket.

If someone accidentally deletes or overwrites a file, we can restore the previous version when versioning is enabled. Without versioning, the data may be permanently lost.

---

## What is S3 Lifecycle Policy?

S3 Lifecycle Policy is used to automatically move data between different storage classes based on access requirements. It can also automatically delete objects after a specified number of days, helping reduce storage cost.

---

## What is the difference between IAM Policy and Bucket Policy?

Both IAM Policy and Bucket Policy are used to provide access to S3.

IAM Policy is attached to IAM Users, Groups or Roles, whereas Bucket Policy is attached directly to the S3 Bucket.

IAM Policy controls user permissions, while Bucket Policy controls access to a specific S3 bucket.

---

# Amazon CloudWatch

## What is Amazon CloudWatch? How have you used it in your environment?

Amazon CloudWatch is a monitoring service used to monitor AWS resources.

We use it to create dashboards, monitor CPU, memory and disk utilization, and configure alarms for notifications.

---

## How do you monitor Memory Utilization in CloudWatch?

By default, CloudWatch provides CPU, Network and Disk metrics.

For Memory Utilization, we install and configure the CloudWatch Agent on the EC2 instance.

---

## What is CloudWatch Dashboard?

CloudWatch Dashboard is a centralized dashboard where we can monitor all AWS resources and quickly check whether they are running properly or not.

---

## What is CloudWatch Alarm?

CloudWatch Alarm is used to monitor AWS resource metrics.

When the configured threshold is crossed, it changes the alarm state and sends a notification through Amazon SNS by email or other configured channels.

**Example:**

If CPU utilization goes above 80%, CloudWatch Alarm triggers and sends a notification to the configured email or SNS topic.

---

## What are CloudWatch Metrics and Logs?

### Metrics

CloudWatch Metrics are used to monitor resource performance like CPU, Memory, Disk and Network utilization.

### Logs

CloudWatch Logs are used to collect and store application logs and system logs for monitoring and troubleshooting.

---

# Amazon CloudTrail

## What is CloudTrail? How have you used it in your environment?

Amazon CloudTrail is used to track and record AWS API activities in an AWS account. It helps us identify who performed an action, what action was performed and when it was performed.

For example, if someone creates or deletes an S3 bucket, we can use CloudTrail to check who performed the action and when it happened.

---

## How have you used CloudTrail in your environment?

In my environment, we mainly use CloudTrail during troubleshooting.

For example, if an EC2 instance is unexpectedly rebooted or an AWS resource is modified, we check CloudTrail to identify who performed the action and when it was performed.

---

## What is the difference between CloudWatch and CloudTrail?

CloudWatch monitors AWS resources.

CloudTrail monitors AWS account activities like who performed an action, what action was performed and when it was performed.

---

# Amazon Route53

## What is Amazon Route53? How have you used it?

Amazon Route53 is a highly available and scalable DNS service.

It is used to map a domain name to an EC2 instance or Load Balancer IP so users can access the application using a domain name instead of an IP address.

**Example:**

Instead of accessing **1.1.1.1**, users can access **abc.com**.

---

## What is a Hosted Zone?

Hosted Zone is a container that stores DNS records for a domain.

### Public Hosted Zone

Used for internet-facing applications and accessible from the internet.

### Private Hosted Zone

Used for internal applications and accessible only within the VPC.

---

## What is the difference between A Record and CNAME Record?

### A Record

Used to map a domain name to an IP address.

**Example:**

```
abc.com → 1.1.1.1
```

### CNAME Record

CNAME (Canonical Name) is an alias record used to map one domain name to another domain name.

**Example:**

```
www.abc.com → abc.com
```

---

## What are Routing Policies in Route53?

### Simple Routing

One resource serves all the traffic.

### Weighted Routing

Traffic is distributed based on the assigned weight.

Example:

- 30% → Server 1
- 70% → Server 2

### Latency Routing

Traffic is routed to the AWS Region that provides the lowest network latency to the user.

### Failover Routing

Active-Passive setup.

If the primary resource becomes unhealthy, traffic automatically moves to the secondary resource.

### Geolocation Routing

Routes traffic based on the user's geographic location or country.

# AWS ELB & Auto Scaling Interview Notes

---

# What is Elastic Load Balancer (ELB)?

Elastic Load Balancer is an AWS service which automatically distributes incoming traffic across multiple EC2 instances. It helps improve high availability and fault tolerance of the application.

---

# Why do we need ELB? Why can't we directly access the EC2 instance?

If we access the EC2 instance directly, all user traffic goes to a single server. If that EC2 goes down, the application also becomes unavailable.

Using ELB, user traffic is automatically distributed across multiple EC2 instances. It provides high availability and fault tolerance. Users access the ELB DNS name instead of connecting directly to an EC2 instance.

---

# What are the types of Elastic Load Balancer?

- Application Load Balancer (ALB)
- Network Load Balancer (NLB)
- Gateway Load Balancer (GWLB)
- Classic Load Balancer (CLB) (Legacy)

---

# Which Load Balancer are you using in your environment and why?

Basically, it depends on the requirement.

We use Application Load Balancer (ALB) for HTTP/HTTPS traffic, path-based routing and host-based routing. It works on Layer 7.

If the application requires very high performance and low latency, we use Network Load Balancer (NLB), which works on Layer 4 (TCP/UDP).

---

# What is the difference between ALB and NLB?

ALB works on Layer 7 (Application Layer). It supports HTTP/HTTPS traffic, path-based routing and host-based routing.

NLB works on Layer 4 (TCP/UDP). It is used for high performance applications and handles millions of requests with low latency.

---

# What is Listener in ALB?

Listener listens on a specific port and protocol. When a user send a request , the Listener receives the request and forwards it to the Target Group.

---

# What is Target Group?

Target Group is a collection of EC2 instances where the application is running. The Load Balancer sends traffic to the instances in the Target Group.

---

# What is Health Check?

Health Check checks whether the application running on the EC2 instance is healthy or not. It checks the configured path, port and application response. If the instance is unhealthy, the Load Balancer does not send traffic to it.

---

# Website is down behind ALB. How will you troubleshoot?

First, I will verify whether the issue is affecting one user or multiple users. Then I will check the EC2 system and instance status checks.

After that, I will check the ALB Listener and Target Group health status. If the target is unhealthy, I will verify the health check path, port and ALB-to-EC2 Security Group.

Then I will log in to the EC2 instance and check the application service, listening port and application response using curl.

For an internet-facing ALB, I will also verify that it is configured in public subnets with the proper route to the Internet Gateway.

If the infrastructure side is fine, I will check application logs and coordinate with the application team for recent changes.

---

# Target Group is showing Unhealthy. How will you troubleshoot?

## Health Check is failing continuously. How will you troubleshoot?

First, I will check the EC2 2/2 status checks. Then I will verify the Target Group Health Check configuration like port, path and protocol (HTTP/HTTPS).

After that, I will check the Security Group between ALB and EC2. Then I will log in to the EC2 instance and verify the application service status, listening port and test the application.

### Check Service Status

```bash
systemctl status <service_name>
```

### Check Listening Port

```bash
ss -tulnp
```

### Test Application

```bash
curl localhost:<port>
```

Finally, I will check the application logs to identify the root cause.

---

# How does ALB work / How do you manage traffic in ALB?

When a user sends a request, the ALB Listener receives the request on HTTP or HTTPS port.

Then ALB checks the configured listener rules, like path-based or host-based routing, and forwards the traffic to the appropriate Target Group.

The Target Group contains healthy EC2 instances, and ALB distributes traffic only to healthy targets.

### Example

If the request is for `/api`, ALB sends it to the API Target Group.

If the request is for `/images`, it sends it to another Target Group.

For host-based routing:

```text
app.example.com
```

can go to one Target Group and

```text
admin.example.com
```

to another.

---

# What is Auto Scaling Group (ASG)?

Auto Scaling Group (ASG) is an AWS service that automatically increases or decreases the number of EC2 instances based on application traffic or demand. It provides scale-out and scale-in functionality and also replaces unhealthy EC2 instances automatically to maintain high availability.

---

# How does ASG know when to launch or terminate EC2 instances?

Initially, ASG launches the Desired Capacity that we configure. After that, it monitors CloudWatch metrics through the configured Scaling Policy.

For example, if we configure a policy that says:

```text
CPU >= 80%
```

ASG automatically launches a new EC2 instance (Scale Out).

Similarly, if CPU utilization goes below:

```text
CPU <= 30%
```

ASG terminates an extra EC2 instance (Scale In).

---

# What is Launch Template?

Launch Template is a preconfigured template that contains the EC2 configuration, such as:

- AMI
- Instance Type
- Security Group
- Key Pair
- IAM Role
- User Data
- Other Settings

Whenever ASG launches a new EC2 instance, it uses this Launch Template.

---

# What is the difference between Min, Desired and Max Capacity?

## Min Capacity

Min Capacity is the minimum number of EC2 instances that ASG should always maintain.

## Desired Capacity

Desired Capacity is the number of EC2 instances that ASG launches initially and tries to maintain.

## Max Capacity

Max Capacity is the maximum number of EC2 instances that ASG can launch during scale-out.

---

# What are the different Scaling Policies in ASG?

## 1. Target Tracking Scaling

Target Tracking automatically increases or decreases EC2 instances to maintain a target metric like CPU utilization.

### Example

Target CPU:

```text
60%
```

ASG automatically adds or removes instances to keep CPU around 60%.

---

## 2. Step Scaling

In Step Scaling, we can define different thresholds.

### Example

```text
CPU > 70% → Add 1 EC2

CPU > 85% → Add 2 EC2

CPU > 95% → Add 3 EC2
```

---

## 3. Simple Scaling

One CloudWatch Alarm triggers one scaling action.

After that, ASG waits for the cooldown period before performing another scaling action.

---

# My Auto Scaling Group is launching too many instances. How will you investigate?

First, I will check whether ASG is launching new instances because of scaling or because unhealthy instances are being replaced.

Then I will check the CloudWatch Alarm, Scaling Policy and current CPU utilization. I will also verify whether there is genuine traffic or not.

If everything looks fine, then I will check the application because sometimes high CPU is caused by an application issue, not by actual traffic.

---

# EC2 Instance was terminated by ASG. How will you investigate?

First, I will check the ASG Activity History to verify why ASG terminated the EC2 instance.

Then I will check whether it was terminated because of the Scaling Policy, for example if CPU utilization went below the configured threshold.

After that, I will check the Target Group Health because if the instance becomes unhealthy, ASG may replace it.

I will also verify the EC2 Status Checks.

Finally, I will check CloudTrail logs to confirm whether the instance was terminated by ASG or manually by a user.

---

# How will you perform maintenance on an Auto Scaling Group without downtime?

In this case, I will use Instance Refresh.

I can set the minimum healthy percentage to 50%.

First, ASG launches one new EC2 instance with the new application.

After it becomes healthy, the old EC2 instance is terminated.

Then ASG launches the second new EC2 instance, and after it becomes healthy, the second old EC2 instance is terminated.

This way, there is no downtime.

---

# CPU utilization is high, but ASG is not launching new EC2 instances. How will you troubleshoot?

First, I will check the ASG Activity History to find the exact error.

Then I will verify the Scaling Policy and CloudWatch Alarm to confirm whether the alarm is triggering properly or not.

After that, I will check the Max Capacity because ASG may already be running at the maximum limit.

Then I will verify:

- Launch Template
- Subnet IP Availability
- EC2 Quota

I will also check whether ASG is waiting because of cooldown or instance warm-up period.

---

# A new EC2 instance is launched by ASG, but the website is not working. How will you troubleshoot?

First, I will check the Launch Template because there may be an issue with:

- User Data
- Security Group
- AMI
- Other Configuration

Then I will check the Target Group Health Status and verify the Health Check path and port configuration.

After that, I will log in to the EC2 instance and check whether the application service is running properly.

### Service Status

```bash
systemctl status <service_name>
```

### Verify Port

```bash
ss -tulnp
```

### Test Application

```bash
curl localhost:<port>
```

I will also verify whether the User Data script executed successfully.

```bash
cat /var/log/cloud-init-output.log
```

Finally, I will check application logs to identify the root cause.

---
# AWS Cost, Security & Vulnerability — Interview Questions & Answers

## 1. How do you monitor AWS cost?

I use **AWS Cost Explorer** to analyze AWS cost and usage. I can check which AWS service is generating more cost and then identify the reason.

---

## 2. What is AWS Budget?

AWS Budget is used to set a **budget limit**.

We can configure alerts, for example, when our cost reaches **80% of the defined budget**.

```text
Cost Explorer → Analyze Cost
AWS Budget    → Set Limit + Alert
```

---

## 3. EC2 cost is very high. How will you reduce it?

First, I will use **AWS Cost Explorer** to analyze the EC2 cost.

Then I will check:

- Unused EC2 instances
- Unused EBS volumes
- Old unnecessary snapshots
- Unused public IPv4 addresses

After verification and approval, I will remove unused resources.

I will also check whether we are using the **right-sized instances** according to business requirements.

For long-term workloads, I can use **Reserved Instances or Savings Plans**.

For non-critical or testing workloads, I can use **Spot Instances**.

I can also stop Dev/Test instances during **off hours**.

---

## 4. S3 cost suddenly increased 5x. What will you do?

First, I will use **AWS Cost Explorer** to analyze the S3 cost.

Then I will check:

- Storage usage
- Requests
- Data transfer

After identifying the reason, I will optimize the cost using **S3 Lifecycle Policy**.

I can move infrequently accessed data to lower-cost storage classes like:

- Standard-IA
- Glacier
- Deep Archive

I will also check old object versions and, after verification and approval, remove unnecessary old versions.

---

# AWS Security

## 5. How do you secure IAM users?

I follow the **least privilege principle** and provide only required permissions.

I will:

- Enable MFA
- Provide only required permissions
- Prefer IAM Roles instead of long-term access keys for AWS workloads
- Avoid using the root user for daily activities

---

## 6. How do you secure an AWS environment?

For **user/access security**, I use IAM with least privilege and MFA.

For **data security**, I use KMS encryption.

For **network security**, I use Security Groups and NACLs.

For **S3 security**, I keep buckets private and control access using IAM and bucket policies.

For **auditing**, I use CloudTrail.

For **threat detection**, I can use GuardDuty.

For **vulnerability detection**, I can use Amazon Inspector.

---

## 7. Someone terminated a production EC2 instance. How will you find who did it?

I will check **CloudTrail Event History** and search for the `TerminateInstances` event.

Then I will check:

- Who performed the activity
- When it was performed
- Whether it was performed manually by a user or through automation like Lambda

```text
CloudTrail = Who + When + What API Action
```

---

## 8. What is AWS Config?

AWS Config is used to track **AWS resource configurations and configuration changes over time**.

For example, if a Security Group configuration was changed, I can check its previous and current configuration using AWS Config.

```text
AWS Config = Resource Configuration History
```

---

## 9. Someone changed SSH access in a Security Group. How will you investigate it?

First, I will use **AWS Config** to check what configuration was changed.

If I want to know **who performed the change and when**, I will check **CloudTrail**.

```text
AWS Config  → What configuration changed?
CloudTrail  → Who changed it and when?
```

---

## 10. What is Amazon GuardDuty?

Amazon GuardDuty is used to detect **suspicious or malicious activities** in our AWS environment.

For example:

- Unusual API activity
- Suspicious network communication

If GuardDuty detects suspicious activity, it generates a **finding**.

```text
GuardDuty = Threat Detection
```

---

## 11. How can you receive an email alert for a GuardDuty finding?

We can integrate GuardDuty with **EventBridge and SNS**.

```text
GuardDuty Finding
       ↓
EventBridge
       ↓
SNS
       ↓
Email Alert
```

---

## 12. What is AWS Security Hub?

AWS Security Hub provides a **centralized place to monitor security findings** from different AWS security services like GuardDuty and Inspector.

```text
Security Hub = Centralized Security Findings
```

---

# AWS Vulnerability

## 13. What is Amazon Inspector?

Amazon Inspector is a **vulnerability management service**.

It scans supported AWS workloads like:

- EC2 instances
- ECR container images

It helps identify software vulnerabilities and generates findings.

```text
Inspector = Vulnerability Detection
```

---

## 14. What is the difference between GuardDuty and Inspector?

**GuardDuty** is mainly used for threat detection and suspicious activities.

**Amazon Inspector** is used to identify software vulnerabilities.

```text
GuardDuty → Threat Detection

Inspector → Vulnerability Detection
```

---

## 15. Inspector detected a critical vulnerability on a production EC2 instance. What will you do?

First, I will check the **Inspector finding** and identify:

- Affected EC2 instance
- Vulnerable package
- Severity

Then I will verify the impact and coordinate with the required team.

After approval, I will patch or update the vulnerable package.

After patching, I will verify the **server and application health** and confirm that the vulnerability is resolved.

```text
Identify
   ↓
Check Severity
   ↓
Verify Impact
   ↓
Take Approval
   ↓
Patch / Update
   ↓
Validate Server & Application
   ↓
Verify Vulnerability is Resolved
```

---

# Quick Revision

```text
Cost Explorer → Cost Analysis

AWS Budget    → Budget Limit + Alert

IAM           → Access Security

KMS           → Data Encryption

SG / NACL     → Network Security

CloudTrail    → API Activity / Who + When + What

AWS Config    → Resource Configuration History

GuardDuty     → Threat Detection

Inspector     → Vulnerability Detection

Security Hub  → Centralized Security Findings
```


---

# Most Important Interview Questions ⭐⭐⭐⭐⭐

- What is ELB?
- Why do we need ELB?
- Types of ELB
- ALB vs NLB
- What is Listener?
- What is Target Group?
- What is Health Check?
- Website is down behind ALB. How will you troubleshoot?
- Target Group is Unhealthy. How will you troubleshoot?
- Health Check is failing continuously. How will you troubleshoot?
- How does ALB work?
- What is ASG?
- How does ASG launch or terminate instances?
- What is Launch Template?
- Min vs Desired vs Max Capacity?
- Types of Scaling Policies?
- ASG launching too many instances?
- EC2 terminated by ASG?
- CPU high but ASG not scaling?
- New ASG instance launched but website not working?
