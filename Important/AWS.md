

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

First, I increase the EBS volume size from the AWS Console.

Then I log in to the server and check the disk and partition size using:
```
lsblk
```
If there is a partition, I extend the partition using:
```
growpart /dev/nvme0n1 1
```
Then I extend the filesystem.

For ext4 / For XFS::
```
resize2fs /dev/nvme0n1p1
xfs_growfs /
```
Finally, I verify the new filesystem size using:
```
df -h
```

# 11 What is the difference between EBS Snapshot and AMI?

An EBS Snapshot is a backup of an EBS volume. We mainly use it for backup and recovery of the volume.

An AMI is a template used to launch a new EC2 instance. It contains the OS, applications and configurations, along with references to the required EBS snapshots.

So, simply:

Snapshot → EBS volume backup

AMI → EC2 launch template

For example, if I want to recover an EBS volume, I can use a snapshot. If I want to launch a new EC2 with the same OS and configuration, I can use an AMI.


# 12 EC2 instance is running but application is not accessible. How will you troubleshoot?

First, I will check whether the application service is running using systemctl status <service_name>.

If the service is stopped or failed, I will check the service logs using journalctl -u <service_name> and restart the service after approval.

If the service is running, I will check whether the required application port is listening using ss -tulnp.

If the port is not listening, I will check the application configuration and logs to identify why the application is not listening on that port.

If the port is listening, I will check the Security Group and NACL rules to verify that the required traffic is allowed.

If the application is behind a Load Balancer, I will also check the Target Group health, health check path and health check port.

Finally, I will test the application locally using curl and review the application logs to identify the root cause.

```
systemctl status <service_name>
journalctl -u <service_name>
ss -tulnp
curl localhost:<port>
```

# 13 What happens when an EC2 instance goes down unexpectedly?

First, I will check the EC2 instance status in the AWS Console and verify whether the instance is running and whether the 2/2 status checks are passing.

Then, I will check the reboot history and uptime using last reboot and uptime.

If the instance was rebooted, I will check the previous boot logs using journalctl -b -1 to identify any OS-level issue.

After that, I will check CloudWatch metrics such as CPU, memory, disk and status checks to identify any resource or infrastructure issue.

Finally, I will check CloudTrail to verify whether someone or any automation performed a Stop, Reboot or Terminate action.

```
last reboot
uptime
journalctl -b -1
```

# 14 Users are unable to open the website. How will you troubleshoot?

First, I will check DNS resolution using nslookup website.com. If DNS resolution is working, then I will check the Load Balancer listener and Target Group health. If the Target Group is unhealthy, I will check the health check path and port, then verify the application service and listening port on the EC2 instance using systemctl status <service_name> and ss -tulnp.

After that, I will check the application logs using tail -100f /var/log/application.log to identify the actual issue.

If the application service is stopped or not responding, then after approval, I will restart the service using systemctl restart <service_name> and perform post-checks.

# 15 Website is slow. How will you troubleshoot?

First, I will check the server CPU utilization using top.

If CPU is high, I will identify which process is consuming more CPU using ps aux --sort=-%cpu | head.

Then, I will check memory utilization using free -h. If memory is high, I will identify the process consuming more memory using ps aux --sort=-%mem | head.

After that, I will check disk space using df -h and disk performance if required using iostat.

Then, I will check whether the application service is running properly using systemctl status <service_name> and whether the required port is listening using ss -tulnp.

If the server-side checks are normal and the application is behind a Load Balancer, I will check CloudWatch metrics such as response time and Load Balancer latency to identify whether the issue is related to application or infrastructure performance.

```
top
free -h
df -h
iostat
ps aux --sort=-%cpu | head
ps aux --sort=-%mem | head
systemctl status <service_name>
ss -tulnp
```


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

A public subnet is a subnet whose route table has a route to an Internet Gateway, and resources can be internet-accessible if they also have a public or Elastic IP and the required security rules.

Example Route:

```text
0.0.0.0/0 → IGW
```

## Private Subnet

A private subnet does not have a direct route to an Internet Gateway. Resources in a private subnet are not directly accessible from the internet. If they need outbound internet access, they can use a NAT Gateway.

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

An Internet Gateway is a VPC component that provides communication between resources in a VPC and the internet.

For an EC2 instance to access the internet through an Internet Gateway, the subnet route table must have a route to the IGW, and the EC2 instance must have a Public IP or Elastic IP with the required Security Group and NACL rules.

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

A private EC2 instance can access the internet for outbound traffic through a NAT Gateway.

First, the private subnet route table should have a default route 0.0.0.0/0 pointing to the NAT Gateway.

The NAT Gateway is placed in a public subnet and has an Elastic IP. The public subnet route table has a route to the Internet Gateway.

---

# 22 How will you connect to a private EC2 instance?

A private EC2 instance does not have direct internet access, so I can connect to it using a Bastion Host or AWS Systems Manager Session Manager.

Using a Bastion Host, I first connect to the Bastion Host through its public IP, and then connect to the private EC2 using its private IP.

For a more secure approach, I can use AWS Systems Manager Session Manager, which allows me to access the private EC2 without opening SSH port 22 or using a Bastion Host.

Other options include VPN or Direct Connect when connectivity from an on-premises network is required.

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

VPC Endpoint allows resources in a VPC to access AWS services privately without sending traffic through the public internet.

There are mainly two types of VPC Endpoints:

1. Gateway Endpoint — mainly used for S3 and DynamoDB.

2. Interface Endpoint — uses private IP addresses through ENIs and is used to privately access many AWS services.

For example, a private EC2 instance can access S3 using a Gateway Endpoint:

With a VPC Endpoint, we can avoid using an Internet Gateway or NAT Gateway for that AWS service traffic.

---

# 26 What are VPC Flow Logs?

VPC Flow Logs capture information about network traffic going to and from network interfaces in a VPC.

It records details such as source IP, destination IP, source port, destination port, protocol and whether the traffic was accepted or rejected.

I mainly use VPC Flow Logs to troubleshoot connectivity and security-related issues. For example, if an application server cannot connect to a database, I can check the Flow Logs to see whether the traffic is being accepted or rejected.

Flow Logs can be delivered to:

CloudWatch Logs
Amazon S3

One important point is that VPC Flow Logs do not capture the actual application data or packet contents; they provide metadata about the network traffic.


# 27 What is IAM?

IAM (Identity and Access Management) is a global AWS service used for authentication and authorization. It controls who can access AWS resources and what actions they can perform. Using IAM, we can create users, groups, roles and policies to provide secure access to AWS resources.

**Authentication** means verifying the identity of the user (Who are you?).

**Authorization** means deciding what resources and actions the user is allowed to access (What can you do?).

---

# 28 What is the difference between IAM User, Group, Role and Policy?

IAM User, Group, Role and Policy are different IAM components used to manage access in AWS.

User is an identity created in IAM for a person or application that needs AWS access. The Root User is separate from IAM Users and has full account-level access.

Group is a collection of IAM Users. We can attach permissions to the group, and users in that group inherit those permissions.

Role provides temporary credentials and is mainly used by AWS services like EC2 and Lambda, or for cross-account access, instead of using long-term access keys.

Policy is a JSON document that defines what actions are allowed or denied on specific AWS resources.

For example, an EC2 instance can assume an IAM Role and use the permissions defined in the attached policy to access S3 without storing access keys on the server.

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

IAM Policy is a JSON document that defines what actions are allowed or denied on AWS resources.

There are mainly three types of IAM policies:

1. AWS Managed Policy — Created and managed by AWS.

2. Customer Managed Policy — Created and managed by us according to our requirements.

3. Inline Policy — Directly embedded into a specific User, Group or Role and has a one-to-one relationship with that identity.

Example:

AWS Managed Policy    → AWS manages it
Customer Managed      → We manage it
Inline Policy         → Directly attached to one identity

In general, Customer Managed Policies are preferred when we need our own reusable permission policy.

# 34 Amazon S3

## What is Amazon S3? How have you used it in your environment?

Amazon S3 is a highly scalable object storage service used to store and retrieve data such as application logs, backups, files and other objects.

In my environment, S3 is used for storing application logs, backups and required files.

S3 provides high durability and scalability, and data is stored as objects inside buckets.

We can also use features like Versioning, Lifecycle Policies and encryption to protect and manage the data.


# 35 What are the different S3 Storage Classes?

Amazon S3 provides different storage classes based on how frequently we access the data and how long we need to retain it.

S3 Standard is used for frequently accessed data.

**S3 Standard-IA** is used for data that is accessed less frequently but still needs quick access.

**S3 One Zone-IA** is similar to Standard-IA but stores data in a single Availability Zone, so it is suitable for data that can be recreated if required.

**S3 Intelligent-Tiering** automatically moves objects between access tiers based on changing access patterns.

**S3 Glacier Instant Retrieval** is used for archive data that still needs fast retrieval.

**S3 Glacier Flexible Retrieval** is used for long-term archive data where retrieval can take more time.

**S3 Glacier Deep Archive** is used for very long-term archival and lowest-cost storage.

In my environment, I would select the storage class based on the data access pattern, retention requirement and cost.

# 36 What is Versioning in S3 and why do we use it?

Versioning keeps multiple versions of the same object in an S3 bucket.

If someone accidentally deletes or overwrites a file, we can restore the previous version when versioning is enabled. Without versioning, the data may be permanently lost.

---

# 37 What is S3 Lifecycle Policy?

S3 Lifecycle Policy is used to automatically move data between different storage classes based on access requirements. It can also automatically delete objects after a specified number of days, helping reduce storage cost.

---

# 38 What is the difference between IAM Policy and Bucket Policy?

IAM Policy and Bucket Policy both can be used to control access to an S3 bucket, but they are attached to different places.

IAM Policy is attached to an IAM User, Group or Role and defines what AWS resources and actions that identity can access.

Bucket Policy is a resource-based policy attached directly to an S3 bucket. It defines which users, roles or AWS accounts can access that bucket and what actions they can perform.

For example, if an EC2 application needs to upload files to S3, I can give the EC2 IAM Role permission through an IAM Policy.

If I need to allow or restrict access at the bucket level, I can use a Bucket Policy.

Final access is allowed only when there is no applicable explicit Deny.

# 39 Amazon CloudWatch

## What is Amazon CloudWatch? How have you used it in your environment?

Amazon CloudWatch is a monitoring service used to monitor AWS resources.

We use it to create dashboards, monitor CPU, memory and disk utilization, and configure alarms for notifications.

---

# 40 How do you monitor Memory Utilization in CloudWatch?

By default, CloudWatch provides metrics like CPU, Network and some disk-related metrics, but Memory Utilization is not available by default.

To monitor memory, I install and configure the CloudWatch Agent on the EC2 instance.

First, I attach the required IAM Role with CloudWatchAgentServerPolicy to the EC2 instance.

Then, I install and configure the CloudWatch Agent to collect memory metrics and send them to CloudWatch.

After that, I can view the Memory Utilization metric in CloudWatch and create alarms or dashboards based on it.

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

Amazon Route 53 is a highly available and scalable DNS service used to route users to applications and AWS resources.

It converts a domain name into the appropriate destination so users can access the application using a domain name instead of remembering an IP address.

For example, users can access:

www.example.com
       ↓
    Route 53
       ↓
      ALB
       ↓
   EC2 / ECS

For an ALB, we normally use a Route 53 Alias record to point the domain to the Load Balancer.

Route 53 also supports features such as routing policies and health checks for controlling how traffic is routed.

# 48 What is a Hosted Zone?

Hosted Zone is a container that stores DNS records for a domain.

### Public Hosted Zone

Used for internet-facing applications and accessible from the internet.

### Private Hosted Zone

Used for internal applications and accessible only within the VPC.

---

# 49 What is the difference between A Record and CNAME Record and Alias?

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
### Alias

In Route 53, when pointing a domain to an AWS resource such as an ALB, we normally use an Alias record.
```
example.com
     ↓
Route 53 Alias
     ↓
ALB
```

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

The choice of Load Balancer depends on the application requirement.

For HTTP/HTTPS applications, I would use an Application Load Balancer because it works at Layer 7 and supports features like host-based and path-based routing.

For TCP/UDP applications where high performance and low latency are required, I would use a Network Load Balancer, which works at Layer 4.

In my environment, my work is mainly around monitoring and troubleshooting the AWS infrastructure, so I have working knowledge of ALB and NLB based on the application requirement.
```
HTTP/HTTPS
   ↓
ALB
   ↓
Web Application

TCP/UDP
   ↓
NLB
   ↓
Application
```

# 55 What is the difference between ALB and NLB?

ALB and NLB are both AWS Load Balancers, but they operate at different OSI layers and are used for different requirements.

ALB works at Layer 7 (Application Layer). It is mainly used for HTTP/HTTPS traffic and supports features like host-based routing, path-based routing and HTTP-level routing.

NLB works at Layer 4 (Transport Layer). It is mainly used for TCP/UDP/TLS traffic where high performance, low latency and large-scale connection handling are required.

# 56 What is Listener in ALB?

A Listener is a process on the ALB that listens for incoming traffic on a specific port and protocol, such as HTTP port 80 or HTTPS port 443.

When a request arrives, the Listener checks the configured Listener Rules and then forwards the request to the appropriate Target Group.

# 57 What is Target Group?

A Target Group is a logical group of registered targets, such as EC2 instances, where the ALB forwards incoming traffic.

The Target Group also contains configuration such as the target port and Health Check settings. The ALB forwards traffic only to healthy targets.

# 58 What is Health Check?

Health Check is used by the Load Balancer to determine whether a registered target is healthy and able to receive traffic.
It checks the configured protocol, port and health check path and expects a successful response.
If a target fails the health checks, the Load Balancer stops sending new traffic to that target until it becomes healthy again.-

# 59 Website is down behind ALB. How will you troubleshoot?

First, I will verify whether the issue is affecting one user or multiple users.

Then, I will check the ALB Listener and Target Group health.

If the Target Group is unhealthy, I will check the health check path, port and protocol, and verify the Security Group between the ALB and EC2.

After that, I will log in to the EC2 instance and check the application service, listening port and application response using systemctl status, ss -tulnp and curl.

If the application is not responding, I will check the application logs.

Finally, I will check the ALB and EC2 CloudWatch metrics and coordinate with the application team if the issue is application-related.

# 60 Target Group is showing Unhealthy. How will you troubleshoot?

## Health Check is failing continuously. How will you troubleshoot?

First, I will verify the Target Group health check configuration, including the protocol, port and health check path.

Then I will check the Security Group rules between the ALB and EC2.

After that, I will log in to the EC2 instance and verify whether the application is running and listening on the expected port.

I will test the health check endpoint locally using curl.

Finally, I will check the application logs to identify why the health check is failing.

```
systemctl status <service_name>
ss -tulnp
curl localhost:<port>/<health-check-path>
```

# 61 How does ALB work / How do you manage traffic in ALB?

When a user sends a request, the ALB Listener receives the request on a configured port and protocol, such as HTTP 80 or HTTPS 443.

The Listener then evaluates the configured Listener Rules, such as host-based or path-based routing.

Based on the rule, ALB forwards the request to the appropriate Target Group.

The Target Group contains registered targets such as EC2 instances, and ALB sends traffic only to healthy targets based on the configured health checks.

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

How does ASG know when to launch or terminate EC2 instances?

First, ASG maintains the configured Desired Capacity.

Then the configured Scaling Policy, usually based on CloudWatch metrics, determines when to scale out or scale in.

For example, with Target Tracking:

Target CPU = 60%

CPU increases above target
        ↓
ASG launches EC2 instances

CPU decreases
        ↓
ASG terminates instances

ASG also respects the configured Minimum and Maximum Capacity.

It can also scale based on scheduled actions or other scaling policies.

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

First, I will check the ASG Activity History to understand why new instances are being launched.

Then I will check the Scaling Policies and CloudWatch Alarms to verify which policy is triggering the scale-out.

I will check the relevant metrics such as CPU utilization, request count, or other configured scaling metrics to confirm whether there is genuine load.

I will also verify the Desired, Minimum and Maximum Capacity and check whether there is any abnormal application behavior causing the metric to remain high.

Finally, I will check whether unhealthy instances are continuously being replaced by ASG.

# 68 EC2 Instance was terminated by ASG. How will you investigate?

First, I will check the ASG Activity History to verify why ASG terminated the EC2 instance.

Then I will check whether it was terminated because of the Scaling Policy, for example if CPU utilization went below the configured threshold.

After that, I will check the Target Group Health because if the instance becomes unhealthy, ASG may replace it.

I will also verify the EC2 Status Checks.

Finally, I will check CloudTrail logs to confirm whether the instance was terminated by ASG or manually by a user.

---

# 69 How will you perform maintenance on an Auto Scaling Group without downtime?


I will use Instance Refresh to gradually replace the existing EC2 instances with new instances.

I can configure the minimum healthy percentage so that ASG keeps enough healthy instances running during the refresh.

Old Instances
      ↓
Instance Refresh
      ↓
Launch New Instance
      ↓
Health Check
      ↓
Terminate Old Instance
      ↓
Repeat

This allows me to update the AMI, Launch Template or application configuration while maintaining application availability.

# 70 CPU utilization is high, but ASG is not launching new EC2 instances. How will you troubleshoot?

First, I will check the ASG Activity History to identify whether there is any scaling error.

Then I will verify the CloudWatch Alarm and Scaling Policy to confirm that the scaling condition is being triggered correctly.

After that, I will check the Desired, Min and Max Capacity. If the ASG has already reached the Max Capacity, it cannot launch additional instances.

I will also verify:

Launch Template
Subnet IP availability
EC2 service quotas
Instance warm-up or cooldown

Finally, I will check whether the high CPU is genuine application traffic or caused by an application/process issue.

# 71 A new EC2 instance is launched by ASG, but the website is not working. How will you troubleshoot?

First, I will check the Target Group health and verify whether the new instance is registered and passing the health check.

Then I will check the Launch Template configuration, especially the AMI, Security Group, IAM Role and User Data.

After that, I will log in to the EC2 instance and verify:

systemctl status <service_name>
ss -tulnp
curl localhost:<port>

If the application is not running, I will check the application logs and User Data execution:

cat /var/log/cloud-init-output.log

Finally, I will verify the Security Group between ALB and EC2, health-check port/path, and application response.

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

First, I will use AWS Cost Explorer to identify what is causing the high EC2 cost.

Then I will check for unused or underutilized EC2 instances, unattached EBS volumes, old snapshots and unused public IPv4 addresses.

For running instances, I will review utilization and consider rightsizing the instance type if it is over-provisioned.

For long-term workloads, I can consider Savings Plans or Reserved Instances. For suitable non-production workloads, I can use Spot Instances.

For Dev/Test environments, I can also schedule instances to stop during non-business hours after approval.

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

I follow the least privilege principle and provide only the permissions required for the user's job.

I will:

Enable MFA
Avoid unnecessary permissions
Regularly review and remove unused permissions
Avoid using the root user for daily activities
Prefer IAM Roles and temporary credentials for AWS workloads instead of long-term access keys
Rotate or remove access keys if they are required and no longer needed

# 77 How do you secure an AWS environment?

I secure the AWS environment at multiple layers.

Identity and Access: IAM, least privilege and MFA
Network: Security Groups, NACLs and private subnets
Data: Encryption using KMS
S3: Block Public Access, IAM policies and Bucket Policies
Monitoring/Auditing: CloudWatch and CloudTrail
Threat Detection: GuardDuty
Vulnerability Management: Amazon Inspector
Configuration Compliance: AWS Config

The main objective is to follow least privilege, defense in depth and continuous monitoring.

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

First, I will check CloudTrail to identify who modified the Security Group and when the change was made.

Then, I will check AWS Config to compare the previous and current Security Group configuration.

I will verify what SSH rule was added or modified, assess the impact, and after approval, remove any unauthorized rule.

CloudTrail → Who changed it + When
AWS Config → What configuration changed

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

First, I will review the Inspector finding and identify the affected EC2 instance, vulnerable package, CVE and severity.

Then I will assess the impact and coordinate with the application/team owner.

After approval, I will patch or upgrade the vulnerable package using the appropriate maintenance process.

After patching, I will verify the server and application health and confirm through Amazon Inspector that the vulnerability has been resolved.

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

First, I will verify that the RDS instance is available and check the RDS endpoint and database port.

Then I will verify the network connectivity:

Application and RDS are in reachable subnets
RDS Security Group allows the database port from the Application Security Group
Route tables and NACLs are not blocking the traffic

For example:

Application SG
      ↓
   TCP 3306
      ↓
RDS Security Group

Then I will test connectivity from the application server using the appropriate database client or network test.

If the AWS/network side is healthy, I will coordinate with the DBA/application team to check database credentials, connection limits or database-side issues.

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

First, I will identify the type and extent of corruption and check the available backup, EBS snapshot or AMI.

If the EBS volume is corrupted, I can restore it from the latest valid snapshot and attach the restored volume to an EC2 instance.

If the complete server needs to be rebuilt, I can launch a new EC2 instance from a known-good AMI and restore the required data from backups/snapshots.

After recovery, I will verify:

EC2 status checks
Filesystem and mounted volumes
Network connectivity
Required services
Application health

Finally, I will perform post-recovery validation with the application team.

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

AWS Systems Manager is an AWS service used to manage and operate EC2 instances centrally.

I have working knowledge of SSM and have used it in the lab for instance management and automation.

It provides features such as:

Session Manager — secure shell access without SSH/Bastion
Run Command — execute commands remotely
Patch Manager — manage OS patching
Automation — automate operational tasks

In my lab, I mainly used Session Manager and basic instance management.

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

AWS Lambda is a serverless compute service that runs code without requiring us to manage servers.

I have working knowledge of Lambda and have used it in the lab for basic EC2 automation, such as starting and stopping EC2 instances.

Lambda can be triggered by services such as EventBridge, API Gateway, S3 events, or other AWS services.

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

First, I will check DNS resolution and verify the Route 53 record.

Then I will check the Load Balancer listener and Target Group health.

If the targets are unhealthy, I will check:

EC2 status checks
ALB and EC2 Security Groups
Health check path and port
Application service
Listening port
Application logs

If the application is healthy, I will check the RDS status, endpoint, database port and Security Group connectivity if the application depends on RDS.

Finally, if the AWS infrastructure is healthy, I will coordinate with the application, network or DBA team.

User
 ↓
Route 53
 ↓
ALB
 ↓
Target Group
 ↓
EC2 / ECS
 ↓
Application
 ↓
RDS

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

First, I will check the ECS Service events and Task status.

Then I will check the Target Group health and verify the health check path, port and protocol.

After that, I will verify:

ALB Listener and Listener Rules
ALB Security Group
ECS Task Security Group
ECS container port mapping
ECS Task Definition
Container/application logs in CloudWatch

For example, if the application listens on port 5000, the ECS Task Security Group should allow port 5000 from the ALB Security Group.

Finally, I will verify the application from inside the container if required and check the root cause from the logs.

# 101 How will you deploy a new application version to ECS without downtime?

First, I will build the new Docker image and push it to Amazon ECR.

Then I will create a new Task Definition revision with the new image and update the ECS Service.

With a rolling deployment, ECS launches new Tasks and waits for them to become healthy through the Target Group health checks before stopping the old Tasks, according to the configured deployment settings.

New Image
   ↓
ECR
   ↓
New Task Definition Revision
   ↓
Update ECS Service
   ↓
New Tasks Launch
   ↓
Health Check
   ↓
Old Tasks Stop
   ↓
New Version Live

For deployments requiring safer traffic switching, Blue/Green deployment can also be used.


# 102. A new ECS deployment has an issue. How will you roll back?

I will first identify the issue from ECS Service events, Target Group health and application logs.

If the new deployment is causing the issue, I will roll back the ECS Service to the previous stable Task Definition revision.

Bad Revision
     ↓
Previous Stable Revision
     ↓
Update ECS Service
     ↓
Previous Tasks Launch
     ↓
Health Check
     ↓
Traffic to Healthy Tasks

If Blue/Green deployment is being used, I can shift traffic back to the previous stable environment.

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

The deployment flow is:

Source Code
    ↓
Docker Image Build
    ↓
Tag Image
    ↓
Authenticate to ECR
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
Traffic to Healthy Tasks
    ↓
Old Tasks Stop

In production, this process can be automated using a CI/CD pipeline such as Jenkins.

The pipeline can build the image, push it to ECR, create/update the Task Definition and deploy the new revision to ECS.

# 107 How will you migrate an application from EC2 to ECS?

First, I will understand the existing application architecture, dependencies, ports, environment variables and storage requirements.

Then I will containerize the application and build a Docker image, test it and push it to ECR.

After that, I will create the ECS cluster, Task Definition and Service, and configure the required ALB Target Group, Security Groups and networking.

I will deploy the ECS application alongside the existing EC2 application and perform testing using a temporary DNS record or ALB routing rule.

After successful validation, I will gradually shift production traffic from the EC2 Target Group to the ECS Target Group.

Finally, after confirming application stability, I will decommission the old EC2-based deployment according to the change/rollback plan.
