

---

# 1  What is EC2? How have you used EC2 in your current environment?

EC2 is an AWS compute service which provides virtual servers to run applications and services.

In my current environment, I work with EC2 for server monitoring and troubleshooting. I mainly check issues like high CPU, SSH connectivity, instance health and application availability.

For example, if CPU utilization is high and users are facing issues, I check the server using Linux commands and verify CloudWatch metrics. If required, after approval, I restart the instance and perform post-checks to make sure the application and services are working properly.

```
top
free -h
uptime
df -h
```	
---

# 2 What are the different states of an EC2 instance?

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

# 3 What is the difference between Stop, Reboot and Terminate?

## Stop

means we temporarily stop the EC2 instance. We can start it again later, and the EBS data is preserved.

## Reboot

means we restart the operating system. The instance is not terminated, and we normally use it for OS-level issues.

## Terminate

means we permanently delete the EC2 instance. We cannot start it again. The root EBS volume is also deleted if DeleteOnTermination is enabled.
---

# 4 What is AMI in AWS? How have you used AMI?

AMI (Amazon Machine Image) is a pre-configured template used to launch EC2 instances.

An AMI contains:

- Operating System
- Installed Applications
- Packages
- Configurations

### Usage

We use AMIs to create identical servers quickly without performing manual installation and configuration.

---

# 5 What is the difference between Security Group and NACL?

Both Security Groups and NACLs are used to control network traffic.

## Security Group

- Work on Instance-level firewall
- Stateful
- Supports only Allow rules


## NACL

- Work on Subnet-level firewall
- Stateless
- Supports Allow and Deny rules

---

# 6 What is the difference between Public IP, Private IP and Elastic IP?

## Public IP

is used when the EC2 instance needs internet communication. It can change when we stop and start the instance.

## Private IP

is used for communication within the VPC. It is not directly accessible from the internet

## Elastic IP

is a static public IP. It remains the same even after stop and start, and we can use it when we need a fixed public IP.

---

# 7 What are the different types of EBS volumes? Which one have you used?

EBS volumes are mainly of two types: SSD and HDD.

SSD includes gp2, gp3, io1 and io2. GP volumes are generally used for normal application servers, while io volumes are used where we need high IOPS.

HDD includes st1 and sc1, which are mainly used for high-throughput or less frequently accessed data.

In my environment, I have mostly worked with gp3 volumes.

---

# 8 What is the difference between gp2 and gp3?

gp2 and gp3 both are General Purpose SSD volumes.

In gp2, IOPS is mainly based on the volume size, so if we need more IOPS, we generally need to increase the volume size.

In gp3, we get 3000 IOPS by default, and we can increase IOPS and throughput independently without increasing the volume size.

So, gp3 gives better flexibility and is generally more cost-effective than gp2.

---

# 9 How do you attach and mount a new EBS volume?

First, I create an EBS volume and attach it to the EC2 instance from the AWS Console. The EBS volume should be in the same Availability Zone as the EC2 instance.

After attaching, I log in to the EC2 server and check the new disk using lsblk.

If it is a new disk, I format it with the required filesystem. For example, for ext4, I use:

sudo mkfs.ext4 /dev/nvme1n1

Then I create a mount point, for example /data, and mount the disk:

sudo mkdir /data
sudo mount /dev/nvme1n1 /data

Then I verify the mount using df -h.

If I want the disk to be automatically mounted after reboot, I get the UUID using blkid, add it to /etc/fstab, and test it using mount -a.

# 10 How do you increase the size of an EBS volume?

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

# 11 What is the difference between EBS Snapshot and AMI?

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


# 12 EC2 instance is running but application is not accessible. How will you troubleshoot?

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


# 13 What happens when an EC2 instance goes down unexpectedly?

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

# 14 Users are unable to open the website. How will you troubleshoot?

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

# 15 Website is slow. How will you troubleshoot?

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


# 16 What is VPC and how have you used it?

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


# 17 Difference Between Public and Private Subnet

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

# 18 What is a Route Table?

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

# 19 What is Internet Gateway (IGW)?

Internet Gateway enables communication between a VPC and the internet.

Requirements:

- Public IP
- Route to IGW
- Security Group access

---

# 20 What is NAT Gateway?

NAT Gateway provides outbound internet access for resources in private subnets.

### Example

Private EC2 server:

- Download patches
- Install packages
- Access internet

Without exposing the server publicly.

---

# 21 How does a private EC2 instance access the internet?

Private EC2 instances access the internet using:

1. NAT Gateway
2. Route Table pointing to NAT Gateway
3. Elastic IP attached to NAT Gateway

---

# 22 How will you connect to a private EC2 instance?

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

# 23 What is VPC Peering?

VPC Peering provides private communication between two VPCs.

Benefits:

- No internet required
- Low latency communication
- Private connectivity

---

# 24 What is Transit Gateway?

Transit Gateway acts as a central hub to connect:

- Multiple VPCs
- On-Premises Networks
- VPN Connections

Without creating multiple VPC peering connections.

---

# 25 What is VPC Endpoint?

VPC Endpoint allows private access to AWS services without using the internet.

Example:

Private EC2 → S3

Traffic remains within AWS network.

No requirement for:

- Internet Gateway
- NAT Gateway

---

# 26 What are VPC Flow Logs?

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


# 27 What is IAM?

IAM (Identity and Access Management) is a global AWS service used for authentication and authorization. It controls who can access AWS resources and what actions they can perform. Using IAM, we can create users, groups, roles and policies to provide secure access to AWS resources.

**Authentication** means verifying the identity of the user (Who are you?).

**Authorization** means deciding what resources and actions the user is allowed to access (What can you do?).

---

# 28 What is the difference between IAM User, Group, Role and Policy?

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

# 29 Why do we use IAM Role instead of Access Keys on EC2?

IAM Role is more secure because it provides temporary credentials and avoids hardcoded Access Keys.

---
 
# 30 How do you manage user permissions in your current environment?

In my environment, user permissions are managed using IAM Groups and Policies. When a new user needs access, the Engineering team adds the user to the appropriate IAM Group, and the required permissions are inherited through the attached IAM Policy following the least privilege principle.

---

# 31 What is the principle of Least Privilege?

Least Privilege means providing only the minimum permissions required for a user or application to perform its task. We should not give unnecessary permissions. We also enable MFA for additional security wherever required.

---

# 32 What is MFA?

MFA (Multi-Factor Authentication) provides an extra layer of security. Along with username and password, the user must verify identity using an OTP or authentication app.

---

# 33 What is IAM Policy? What are the types?

IAM Policy is a JSON document that defines permissions.

Types:

- AWS Managed Policy
- Customer Managed Policy

---

# 34 Amazon S3

## What is Amazon S3? How have you used it in your environment?

Amazon S3 (Simple Storage Service) is an object storage service used to store and retrieve large amounts of data. It provides high availability, scalability and 99.999999999% (11 9's) durability.

In my environment, we use S3 to store application logs, backups and other required files.

---

# 35 What are the different S3 Storage Classes?

- S3 Standard – Frequently accessed data.
- S3 Standard-IA – Infrequent access data.
- S3 One Zone-IA – Stored in a single Availability Zone.
- S3 Intelligent-Tiering – Automatically moves data between storage tiers.
- S3 Glacier Instant Retrieval – Archive data with fast retrieval.
- S3 Glacier Flexible Retrieval – Long-term archive.
- S3 Glacier Deep Archive – Lowest-cost long-term archival storage.

---

# 36 What is Versioning in S3 and why do we use it?

Versioning keeps multiple versions of the same object in an S3 bucket.

If someone accidentally deletes or overwrites a file, we can restore the previous version when versioning is enabled. Without versioning, the data may be permanently lost.

---

# 37 What is S3 Lifecycle Policy?

S3 Lifecycle Policy is used to automatically move data between different storage classes based on access requirements. It can also automatically delete objects after a specified number of days, helping reduce storage cost.

---

# 38 What is the difference between IAM Policy and Bucket Policy?

Both IAM Policy and Bucket Policy are used to provide access to S3.

IAM Policy is attached to IAM Users, Groups or Roles, whereas Bucket Policy is attached directly to the S3 Bucket.

IAM Policy controls user permissions, while Bucket Policy controls access to a specific S3 bucket.

---

# 39 Amazon CloudWatch

## What is Amazon CloudWatch? How have you used it in your environment?

Amazon CloudWatch is a monitoring service used to monitor AWS resources.

We use it to create dashboards, monitor CPU, memory and disk utilization, and configure alarms for notifications.

---

# 40 How do you monitor Memory Utilization in CloudWatch?

By default, CloudWatch provides CPU, Network and Disk metrics.

For Memory Utilization, we install and configure the CloudWatch Agent on the EC2 instance.

---

# 41 What is CloudWatch Dashboard?

CloudWatch Dashboard is a centralized dashboard where we can monitor all AWS resources and quickly check whether they are running properly or not.

---

# 42 What is CloudWatch Alarm?

CloudWatch Alarm is used to monitor AWS resource metrics.

When the configured threshold is crossed, it changes the alarm state and sends a notification through Amazon SNS by email or other configured channels.

**Example:**

If CPU utilization goes above 80%, CloudWatch Alarm triggers and sends a notification to the configured email or SNS topic.

---

# 43 What are CloudWatch Metrics and Logs?

### Metrics

CloudWatch Metrics are used to monitor resource performance like CPU, Memory, Disk and Network utilization.

### Logs

CloudWatch Logs are used to collect and store application logs and system logs for monitoring and troubleshooting.

---

# 44 Amazon CloudTrail

## What is CloudTrail? How have you used it in your environment?

Amazon CloudTrail is used to track and record AWS API activities in an AWS account. It helps us identify who performed an action, what action was performed and when it was performed.

For example, if someone creates or deletes an S3 bucket, we can use CloudTrail to check who performed the action and when it happened.

---

# 45 How have you used CloudTrail in your environment?

In my environment, we mainly use CloudTrail during troubleshooting.

For example, if an EC2 instance is unexpectedly rebooted or an AWS resource is modified, we check CloudTrail to identify who performed the action and when it was performed.

---

# 46 What is the difference between CloudWatch and CloudTrail?

CloudWatch monitors AWS resources.

CloudTrail monitors AWS account activities like who performed an action, what action was performed and when it was performed.

---

# 47 Amazon Route53

## What is Amazon Route53? How have you used it?

Amazon Route53 is a highly available and scalable DNS service.

It is used to map a domain name to an EC2 instance or Load Balancer IP so users can access the application using a domain name instead of an IP address.

**Example:**

Instead of accessing **1.1.1.1**, users can access **abc.com**.

---

# 48 What is a Hosted Zone?

Hosted Zone is a container that stores DNS records for a domain.

### Public Hosted Zone

Used for internet-facing applications and accessible from the internet.

### Private Hosted Zone

Used for internal applications and accessible only within the VPC.

---

# 49 What is the difference between A Record and CNAME Record?

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

# 50 What are Routing Policies in Route53?

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



---

# 51 What is Elastic Load Balancer (ELB)?

Elastic Load Balancer is an AWS service which automatically distributes incoming traffic across multiple EC2 instances. It helps improve high availability and fault tolerance of the application.

---

# 52 Why do we need ELB? Why can't we directly access the EC2 instance?

If we access the EC2 instance directly, all user traffic goes to a single server. If that EC2 goes down, the application also becomes unavailable.

Using ELB, user traffic is automatically distributed across multiple EC2 instances. It provides high availability and fault tolerance. Users access the ELB DNS name instead of connecting directly to an EC2 instance.

---

# 53 What are the types of Elastic Load Balancer?

- Application Load Balancer (ALB)
- Network Load Balancer (NLB)
- Gateway Load Balancer (GWLB)
- Classic Load Balancer (CLB) (Legacy)

---

# 54 Which Load Balancer are you using in your environment and why?

Basically, it depends on the requirement.

We use Application Load Balancer (ALB) for HTTP/HTTPS traffic, path-based routing and host-based routing. It works on Layer 7.

If the application requires very high performance and low latency, we use Network Load Balancer (NLB), which works on Layer 4 (TCP/UDP).

---

#55 What is the difference between ALB and NLB?

ALB works on Layer 7 (Application Layer). It supports HTTP/HTTPS traffic, path-based routing and host-based routing.

NLB works on Layer 4 (TCP/UDP). It is used for high performance applications and handles millions of requests with low latency.

---

# 56 What is Listener in ALB?

Listener listens on a specific port and protocol. When a user send a request , the Listener receives the request and forwards it to the Target Group.

---

# 57 What is Target Group?

Target Group is a collection of EC2 instances where the application is running. The Load Balancer sends traffic to the instances in the Target Group.

---

# 58 What is Health Check?

Health Check checks whether the application running on the EC2 instance is healthy or not. It checks the configured path, port and application response. If the instance is unhealthy, the Load Balancer does not send traffic to it.

---

# 59 Website is down behind ALB. How will you troubleshoot?

First, I will verify whether the issue is affecting one user or multiple users. Then I will check the EC2 system and instance status checks.

After that, I will check the ALB Listener and Target Group health status. If the target is unhealthy, I will verify the health check path, port and ALB-to-EC2 Security Group.

Then I will log in to the EC2 instance and check the application service, listening port and application response using curl.

For an internet-facing ALB, I will also verify that it is configured in public subnets with the proper route to the Internet Gateway.

If the infrastructure side is fine, I will check application logs and coordinate with the application team for recent changes.

---

# 60 Target Group is showing Unhealthy. How will you troubleshoot?

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

# 61 How does ALB work / How do you manage traffic in ALB?

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

# 62 What is Auto Scaling Group (ASG)?

Auto Scaling Group (ASG) is an AWS service that automatically increases or decreases the number of EC2 instances based on application traffic or demand. It provides scale-out and scale-in functionality and also replaces unhealthy EC2 instances automatically to maintain high availability.

---

# 63 How does ASG know when to launch or terminate EC2 instances?

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

# 64 What is Launch Template?

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

# 65 What is the difference between Min, Desired and Max Capacity?

## Min Capacity

Min Capacity is the minimum number of EC2 instances that ASG should always maintain.

## Desired Capacity

Desired Capacity is the number of EC2 instances that ASG launches initially and tries to maintain.

## Max Capacity

Max Capacity is the maximum number of EC2 instances that ASG can launch during scale-out.

---

# 66 What are the different Scaling Policies in ASG?

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

# 67 My Auto Scaling Group is launching too many instances. How will you investigate?

First, I will check whether ASG is launching new instances because of scaling or because unhealthy instances are being replaced.

Then I will check the CloudWatch Alarm, Scaling Policy and current CPU utilization. I will also verify whether there is genuine traffic or not.

If everything looks fine, then I will check the application because sometimes high CPU is caused by an application issue, not by actual traffic.

---

# 68 EC2 Instance was terminated by ASG. How will you investigate?

First, I will check the ASG Activity History to verify why ASG terminated the EC2 instance.

Then I will check whether it was terminated because of the Scaling Policy, for example if CPU utilization went below the configured threshold.

After that, I will check the Target Group Health because if the instance becomes unhealthy, ASG may replace it.

I will also verify the EC2 Status Checks.

Finally, I will check CloudTrail logs to confirm whether the instance was terminated by ASG or manually by a user.

---

# 69 How will you perform maintenance on an Auto Scaling Group without downtime?

In this case, I will use Instance Refresh.

I can set the minimum healthy percentage to 50%.

First, ASG launches one new EC2 instance with the new application.

After it becomes healthy, the old EC2 instance is terminated.

Then ASG launches the second new EC2 instance, and after it becomes healthy, the second old EC2 instance is terminated.

This way, there is no downtime.

---

# 70 CPU utilization is high, but ASG is not launching new EC2 instances. How will you troubleshoot?

First, I will check the ASG Activity History to find the exact error.

Then I will verify the Scaling Policy and CloudWatch Alarm to confirm whether the alarm is triggering properly or not.

After that, I will check the Max Capacity because ASG may already be running at the maximum limit.

Then I will verify:

- Launch Template
- Subnet IP Availability
- EC2 Quota

I will also check whether ASG is waiting because of cooldown or instance warm-up period.

---

# 71 A new EC2 instance is launched by ASG, but the website is not working. How will you troubleshoot?

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


# 72 How do you monitor AWS cost?

I use **AWS Cost Explorer** to analyze AWS cost and usage. I can check which AWS service is generating more cost and then identify the reason.

---

# 73 What is AWS Budget?

AWS Budget is used to set a **budget limit**.

We can configure alerts, for example, when our cost reaches **80% of the defined budget**.

```text
Cost Explorer → Analyze Cost
AWS Budget    → Set Limit + Alert
```

---

# 74 EC2 cost is very high. How will you reduce it?

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

# 75 S3 cost suddenly increased 5x. What will you do?

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



# 76 How do you secure IAM users?

I follow the **least privilege principle** and provide only required permissions.

I will:

- Enable MFA
- Provide only required permissions
- Prefer IAM Roles instead of long-term access keys for AWS workloads
- Avoid using the root user for daily activities

---

# 77 How do you secure an AWS environment?

For **user/access security**, I use IAM with least privilege and MFA.

For **data security**, I use KMS encryption.

For **network security**, I use Security Groups and NACLs.

For **S3 security**, I keep buckets private and control access using IAM and bucket policies.

For **auditing**, I use CloudTrail.

For **threat detection**, I can use GuardDuty.

For **vulnerability detection**, I can use Amazon Inspector.

---

# 78. Someone terminated a production EC2 instance. How will you find who did it?

I will check **CloudTrail Event History** and search for the `TerminateInstances` event.

Then I will check:

- Who performed the activity
- When it was performed
- Whether it was performed manually by a user or through automation like Lambda

```text
CloudTrail = Who + When + What API Action
```

---

# 79 What is AWS Config?

AWS Config is used to track **AWS resource configurations and configuration changes over time**.

For example, if a Security Group configuration was changed, I can check its previous and current configuration using AWS Config.

```text
AWS Config = Resource Configuration History
```

---

# 80 Someone changed SSH access in a Security Group. How will you investigate it?

First, I will use **AWS Config** to check what configuration was changed.

If I want to know **who performed the change and when**, I will check **CloudTrail**.

```text
AWS Config  → What configuration changed?
CloudTrail  → Who changed it and when?
```

---

# 81 What is Amazon GuardDuty?

Amazon GuardDuty is used to detect **suspicious or malicious activities** in our AWS environment.

For example:

- Unusual API activity
- Suspicious network communication

If GuardDuty detects suspicious activity, it generates a **finding**.

```text
GuardDuty = Threat Detection
```

---

# 82 How can you receive an email alert for a GuardDuty finding?

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

# 83 What is AWS Security Hub?

AWS Security Hub provides a **centralized place to monitor security findings** from different AWS security services like GuardDuty and Inspector.

```text
Security Hub = Centralized Security Findings
```

---



# 84 What is Amazon Inspector?

Amazon Inspector is a **vulnerability management service**.

It scans supported AWS workloads like:

- EC2 instances
- ECR container images

It helps identify software vulnerabilities and generates findings.

```text
Inspector = Vulnerability Detection
```

---

# 85 What is the difference between GuardDuty and Inspector?

**GuardDuty** is mainly used for threat detection and suspicious activities.

**Amazon Inspector** is used to identify software vulnerabilities.

```text
GuardDuty → Threat Detection

Inspector → Vulnerability Detection
```

---
 
# 86 Inspector detected a critical vulnerability on a production EC2 instance. What will you do?

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



# 87 What is Amazon RDS?

Amazon RDS is a **managed relational database service** in AWS.

AWS manages activities like infrastructure, backups and maintenance, while we use the database for our application.

---

# 88 What is Multi-AZ in RDS?

Multi-AZ is mainly used for **High Availability**.

AWS maintains a standby database in another Availability Zone.

If the primary database has an issue, AWS can fail over to the standby database.

```text
Primary RDS - AZ1
       ↓
   Failure
       ↓
Standby RDS - AZ2
       ↓
   Failover
```

---

# 89 Application is unable to connect to RDS. What will you check?

First, I will check whether the **RDS instance is available**.

Then I will verify:

- RDS endpoint
- Database port
- Security Group
- Network connectivity

I will check whether the application server is allowed to connect to the database port.

For example:

```text
Application SG
      ↓
DB Port 3306
      ↓
RDS SG
```

If the AWS and network side is fine, I will coordinate with the **DBA or application team**.

---



# 90 What is RTO and RPO?

**RTO (Recovery Time Objective)** is the maximum acceptable time to restore the application after a failure.

**RPO (Recovery Point Objective)** is the maximum acceptable amount of data loss measured in time.

Example:

```text
RTO = 2 Hours

Application should be restored within 2 hours.
```

```text
RPO = 30 Minutes

Maximum acceptable data loss is 30 minutes.
```

Easy way to remember:

```text
RTO → How much downtime can we accept?

RPO → How much data loss can we accept?
```

---

# 91 How will you recover an EC2 server if it becomes corrupted?

First, I will check the issue and verify the available **backup or snapshot**.

If recovery is required, we can restore the EBS volume from the latest valid snapshot or launch a new EC2 instance from the available AMI.

After recovery, I will verify:

- Filesystem
- Mounted volumes
- Required services
- Network connectivity
- Application health

---

# 92 After restoring a server from Snapshot or AMI, what will you validate?

After restoring the server, I will verify:

- EC2 instance status checks
- Filesystem
- Mounted volumes
- Network connectivity
- Required services
- Application availability

I will also coordinate with the application team for application-level validation.

```text
Restore
   ↓
Instance Status
   ↓
Filesystem / Mount
   ↓
Network
   ↓
Services
   ↓
Application Validation
```

---



# 93 What is AWS Systems Manager and how have you used it?

AWS Systems Manager is used to **manage AWS instances centrally**.

I have working knowledge of SSM and have used it in lab for instance management and automation.

It can be used for:

- Session Manager
- Patching
- Run Command
- Instance management

---

# 94 How can you access a private EC2 instance without SSH or Bastion Host?

We can use **AWS Systems Manager Session Manager**.

The EC2 instance should have:

- SSM Agent
- Required IAM Role
- Connectivity to Systems Manager endpoints

Using Session Manager, we can access the instance without opening SSH port 22 or using a Bastion Host.

```text
User
  ↓
SSM Session Manager
  ↓
Private EC2
```

---


# 95 What is AWS Lambda?

AWS Lambda is a **serverless compute service** that runs code without managing servers.

I have working knowledge of Lambda and have used it in lab for basic EC2 automation such as starting and stopping EC2 instances.

---

# 96 How can you automatically stop Dev EC2 instances during off hours?

We can create a **Lambda function** to stop the required EC2 instances.

Then we can use **Amazon EventBridge** to trigger the Lambda function on a schedule.

```text
EventBridge Schedule
        ↓
      Lambda
        ↓
   Stop Dev EC2
```

This can help reduce the cost of Dev/Test environments during off hours.

---


# 97 Users report that the application URL is not working. How will you troubleshoot from AWS side?

First, I will check **DNS resolution and Route 53**.

Then I will check the **Load Balancer Listener and Target Group health**.

If the target is unhealthy, I will check:

- EC2 status checks
- Security Groups
- Application service
- Listening port
- Application logs

If the application server is healthy but there is a database connectivity issue, I will verify:

- RDS status
- RDS endpoint
- Database port
- Security Group connectivity

If the AWS infrastructure side is fine, I will coordinate with the required **application, network or DBA team**.

```text
User
 ↓
Route 53
 ↓
Load Balancer
 ↓
Target Group
 ↓
EC2
 ↓
Application
 ↓
RDS
```



# 98 BAsic ECS/ECR

### ECR
Amazon ECR (Elastic Container Registry) is an AWS service used to store, manage, and pull Docker/container images.

### ECS
Amazon ECS (Elastic Container Service) is an AWS container orchestration service used to deploy, manage, and scale containers.

### Task Definition
A Task Definition is a blueprint for ECS Tasks. It defines the container image, CPU, memory, ports, IAM roles, environment variables, and other container settings.

### Task
A Task is a running instance of a Task Definition. One Task can contain one or multiple containers.

### Service
An ECS Service maintains the required number of Tasks and provides features like self-healing, deployment, load balancing, and auto scaling.



# 99. Your application is running on ECS Fargate. How does an end user access the application?

In production, ECS Tasks are normally placed in private subnets without public IPs.

Traffic flow:

User → Route 53 → Public ALB → Target Group → ECS Tasks

The ALB is placed in public subnets and ECS Tasks are placed in private application subnets.

Security Groups:

- ALB-SG: Allow 80/443 from the internet.
- ECS-App-SG: Allow application port only from ALB-SG.

Users never directly access the ECS Task IP.


# 100 ECS Task is running but the application is not accessible through ALB. How will you troubleshoot?

I will check:

1. ECS Task status and Service events.
2. Target Group health status.
3. ALB listener and listener rules.
4. Target Group port and health check path.
5. ALB Security Group.
6. ECS Task Security Group.
7. Container port mapping.
8. CloudWatch container logs.

For example, if the application runs on port 5000, the ECS Task Security Group should allow port 5000 from the ALB Security Group.


# 101 How will you deploy a new application version to ECS without downtime?

First, I will build the new Docker image and push it to ECR.

Then:

New Image → ECR → New Task Definition Revision → Update ECS Service → New Tasks Launch → Health Check → Old Tasks Stop

Using Rolling deployment, ECS gradually launches new Tasks and removes old Tasks after the new Tasks become healthy.

For safer deployments, Blue/Green deployment can also be used.


# 102. A new ECS deployment has an issue. How will you roll back?

I can update the ECS Service to use the previous working Task Definition revision.

Flow:

Current bad revision → Select previous Task Definition revision → Update Service → Previous version Tasks launch

If Blue/Green deployment is being used, traffic can be shifted back to the previous Blue environment during the rollback period.


# 103 Desired count is 3 and one ECS Task suddenly stops. What happens?

The ECS Service continuously maintains the desired Task count.

If:

Desired = 3
Running = 2

ECS automatically launches a replacement Task.

After replacement:

Desired = 3
Running = 3

This provides self-healing for ECS Services.


# 104 Traffic increases and ECS Tasks have high CPU utilization. How will you handle it?

I will configure ECS Service Auto Scaling.

Example:

Minimum Tasks = 2
Maximum Tasks = 6
Target CPU = 60%

When CPU utilization increases, ECS Service Auto Scaling increases the desired Task count.

When CPU utilization decreases, it reduces the desired Task count within the configured minimum and maximum limits.

The ALB distributes traffic across the available healthy Tasks.


# 105 ECS Fargate application is in private subnets and needs to connect to RDS MySQL. How will you configure it?

I will keep both the application and database private.

Architecture:

Internet
   ↓
ALB
   ↓
ECS Fargate
   ↓
RDS MySQL

Networking:

- ALB → Public Subnets
- ECS Tasks → Private App Subnets
- RDS → Private DB Subnets

Security Groups:

- ALB-SG → Allow 80/443 from internet.
- ECS-App-SG → Allow application port from ALB-SG.
- DB-SG → Allow MySQL port 3306 from ECS-App-SG.

The application will connect to the database using the RDS endpoint on port 3306.


# 106 Developers provided a new application version. Explain the complete flow from Docker image to production deployment on ECS.

The developer provides the application source code.

Then the deployment flow is:

Source Code
   ↓
Docker Image Build
   ↓
Tag Image
   ↓
Login to ECR
   ↓
Push Image to ECR
   ↓
Create New Task Definition Revision
   ↓
Update ECS Service
   ↓
New Tasks Launch
   ↓
ALB Health Check
   ↓
Old Tasks Stop
   ↓
New Version Live

In production, this complete process is normally automated through a CI/CD pipeline such as Jenkins.

# 107 How will you migrate an application from EC2 to ECS?

First, I will create a Docker image of the application and push it to ECR. Then I will create an ECS cluster, task definition and service using the existing ALB with a new ECS target group.

I will test ECS using a temporary Route 53 record and host-based ALB rule. After successful testing, I will change the production ALB rule from the EC2 target group to the ECS target group and remove the temporary test configuration.



