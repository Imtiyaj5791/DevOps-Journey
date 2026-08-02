# AWS EC2 & VPC Interview Notes

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
