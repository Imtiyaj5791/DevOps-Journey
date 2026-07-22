# 📀 AWS Elastic Block Store (EBS) – (Fundamentals)

> A complete guide to understanding Amazon Elastic Block Store (EBS) from basics to production concepts.


# What is Amazon EBS?

**Amazon Elastic Block Store (Amazon EBS)** is a **persistent block storage service** provided by AWS for Amazon EC2 instances.

An EBS volume works like a **virtual hard disk (SSD/HDD)** that is attached to an EC2 instance.

It stores:

- Operating System
- Applications
- Database Files
- Log Files
- User Data
- Configuration Files

Simply put,

> **EC2 provides Compute (CPU & RAM), while EBS provides Persistent Storage.**

---

## Real World Analogy

Imagine you buy a laptop.

- Laptop = EC2 Instance
- SSD / Hard Disk = EBS Volume

Without a hard disk, the laptop cannot store Windows, applications, or files.

Similarly,

Without EBS, an EC2 instance cannot permanently store the operating system or application data.

---

# Why Do We Need EBS?

Every server needs storage.

A Linux server stores:

- Boot files
- Kernel
- Installed packages
- Configuration files
- Application binaries
- Database
- Logs
- User files

AWS provides EBS to store this information reliably.

### Advantages of EBS

- Persistent Storage
- High Availability within an Availability Zone
- Easy Backup using Snapshots
- Online Storage Expansion
- Encryption using AWS KMS
- Multiple Volume Types
- High Performance SSD Options
- Cost-effective HDD Options

---

# How EBS Works

The workflow is simple.

```text
Create EBS Volume
        │
        ▼
Attach to EC2
        │
        ▼
Linux Detects Disk
        │
        ▼
Create Filesystem
        │
        ▼
Mount Volume
        │
        ▼
Application Starts Using Storage
```

From the Linux operating system perspective, an EBS volume behaves exactly like a physical disk.

Example:

```text
/dev/xvdf
/dev/xvdg
/dev/nvme1n1
```

After attaching the volume, Linux administrators perform:

```bash
lsblk
fdisk
mkfs
mount
df -h
```

to make the disk usable.

---

# EBS Architecture

```text
                   AWS Region
                        │
        ┌───────────────┴───────────────┐
        │                               │
  Availability Zone A             Availability Zone B
        │                               │
   ┌───────────┐                   ┌───────────┐
   │    EC2    │                   │    EC2    │
   └─────┬─────┘                   └─────┬─────┘
         │                               │
         ▼                               ▼
    EBS Volume                     EBS Volume
```

---

## Important Rule

An EBS volume can only be attached to an EC2 instance in the **same Availability Zone (AZ).**

Example:

```text
EC2
Location : ap-south-1a

EBS
Location : ap-south-1a

✔ Attachment Possible
```

Example:

```text
EC2
Location : ap-south-1a

EBS
Location : ap-south-1b

❌ Direct Attachment Not Possible
```

To move the volume to another Availability Zone:

```text
EBS Volume
      │
      ▼
Create Snapshot
      │
      ▼
Create New Volume
      │
      ▼
Attach to EC2
```

This is a very common AWS interview question.

---

# EBS Components

## 1. EC2 Instance

The virtual server that consumes storage.

Examples:

- Web Server
- Application Server
- Database Server
- Jenkins Server

---

## 2. EBS Volume

The persistent block storage attached to an EC2 instance.

Stores:

- Operating System
- Applications
- Database Files
- Logs
- User Data

---

## 3. Snapshot

A point-in-time backup of an EBS volume.

Snapshots are stored internally by AWS and are used for:

- Backup
- Recovery
- Migration
- Disaster Recovery

> Snapshots will be covered in detail in Part-3.

---

## 4. Availability Zone

Every EBS volume belongs to one Availability Zone.

This means:

```text
One Volume
       │
       ▼
One Availability Zone
```

---

## 5. Device Name

When attaching an EBS volume, AWS assigns a device name.

Examples:

```text
/dev/xvdf

/dev/xvdg

/dev/sdf
```

Inside modern Nitro-based EC2 instances, the device may appear as:

```text
/dev/nvme1n1
```

---

# Core Features of EBS

## 1. Persistent Storage

Unlike temporary storage, EBS data remains available after an EC2 stop and start.

Example:

```text
EC2 Running
      │
      ▼
Stop Instance
      │
      ▼
Start Instance
      │
      ▼
Data Still Available
```

---

## 2. Elastic Storage

EBS storage can be increased without rebuilding the server.

Example:

```text
50 GB

↓

100 GB

↓

200 GB
```

After increasing the size in AWS, the partition and filesystem inside Linux may also need to be extended.

---

## 3. Snapshots

EBS supports point-in-time backups.

Benefits:

- Backup
- Restore
- Migration
- Disaster Recovery

Snapshots are incremental, which helps reduce storage costs.

---

## 4. Encryption

EBS supports encryption using **AWS Key Management Service (KMS).**

Encryption protects:

- Volume Data
- Snapshots
- Restored Volumes

Recommended for all production workloads.

---

## 5. High Availability

AWS automatically replicates EBS data within the same Availability Zone to protect against hardware failures.

However,

> EBS **does not automatically replicate data across Availability Zones or Regions.**

For cross-AZ or cross-Region recovery, use:

- Snapshot
- Cross-Region Snapshot Copy
- Disaster Recovery Strategy

---

## 6. Multiple Volume Types

AWS provides different storage options depending on workload requirements.

Examples:

- gp3
- io2
- st1
- sc1

These will be discussed in **Part-1B**.

---

# Key Points

- Amazon EBS is a persistent block storage service.
- EBS works like a virtual SSD/HDD attached to EC2.
- EC2 provides compute, while EBS provides storage.
- One EBS volume belongs to one Availability Zone.
- EBS supports snapshots, encryption, resizing, and high availability within an AZ.
- Linux detects EBS volumes as block devices such as `/dev/xvdf` or `/dev/nvme1n1`.

---

# 📀 AWS Elastic Block Store (EBS) –

> Understanding EBS Volume Types, Root Volume, Additional Volume, Instance Store, and Production Storage Design.

---

# Root Volume vs Additional Volume

Whenever an EC2 instance is launched, AWS creates a **Root Volume**.

Additional storage can later be attached using **Additional EBS Volumes**.

---

## Root Volume

The Root Volume contains the operating system required to boot the EC2 instance.

Linux Example:

```text
/
```

Windows Example:

```text
C:\
```

A Root Volume generally contains:

- Operating System
- Boot Loader
- Kernel
- Installed Packages
- System Configuration
- System Logs

Without the Root Volume, an EC2 instance cannot start.

---

## Additional Volume

Additional Volumes are attached separately to store application or business data.

Examples:

- Database
- Application Files
- Logs
- Docker Data
- Jenkins Home
- Backup Files

Example Architecture

```text
EC2 Instance

├── Root Volume (30 GB gp3)

├── Application Volume (100 GB gp3)

└── Database Volume (500 GB io2)
```

---

## Why Separate Volumes?

Keeping everything on the root volume is not recommended.

Benefits of separate volumes:

- Easy Backup
- Easy Restore
- Easy Resize
- Better Performance Planning
- OS can be rebuilt without affecting application data

---

# EBS Volume Types

AWS provides different EBS volume types based on performance requirements.

---

## 1. gp3 (General Purpose SSD)

Recommended for most workloads.

Suitable for:

- Linux Servers
- Windows Servers
- Web Servers
- Application Servers
- Jenkins
- Docker
- Boot Volumes
- Small Databases

### Advantages

- Best price-to-performance ratio
- High durability
- Independent performance tuning
- Default recommendation for most production workloads

Interview Tip

> If the interviewer asks which EBS type you will use for a Linux server, the answer is **gp3**.

---

## 2. gp2 (Previous Generation SSD)

Older version of General Purpose SSD.

Nowadays AWS recommends using gp3 for new workloads.

---

## 3. io2 (Provisioned IOPS SSD)

Designed for mission-critical workloads.

Suitable for:

- Oracle Database
- SQL Server
- SAP
- Banking Applications
- Financial Systems

Advantages:

- Very High IOPS
- Consistent Performance
- High Durability

Use io2 only when the application requires guaranteed disk performance.

---

## 4. io1

Older generation Provisioned IOPS SSD.

Mostly replaced by io2.

---

## 5. st1 (Throughput Optimized HDD)

Designed for workloads requiring high throughput instead of high IOPS.

Suitable for:

- Hadoop
- Big Data
- Log Processing
- Media Processing
- Large Sequential Reads/Writes

Not recommended for boot volumes.

---

## 6. sc1 (Cold HDD)

Lowest-cost HDD storage.

Suitable for:

- Archive
- Old Logs
- Backup Data
- Rarely Accessed Files

Not suitable for production databases.

---

# Quick Comparison

| Volume Type | Storage | Best For |
|-------------|---------|----------|
| gp3 | SSD | General Purpose |
| gp2 | SSD | Older General Purpose |
| io2 | SSD | High Performance Database |
| io1 | SSD | Older Provisioned IOPS |
| st1 | HDD | Big Data & Logs |
| sc1 | HDD | Archive |

---

# EBS vs Instance Store

Many beginners get confused between these two.

| Feature | EBS | Instance Store |
|----------|-----|----------------|
| Persistent | ✅ Yes | ❌ No |
| Snapshot Support | ✅ Yes | ❌ No |
| Resize | ✅ Yes | ❌ No |
| Encryption | ✅ Yes | Limited |
| Detach/Attach | ✅ Yes | ❌ No |
| Best Use | OS, Database, Applications | Cache, Temporary Files |

---

## When Should We Use EBS?

Use EBS for:

- Operating System
- Databases
- Application Data
- Jenkins
- Docker
- User Files
- Production Logs

---

## When Should We Use Instance Store?

Use Instance Store only for temporary data.

Examples:

- Cache
- Buffer
- Temporary Files
- Scratch Space

If the EC2 instance is terminated, Instance Store data is lost.

---

# Multi-Attach

Normally,

> **One EBS Volume = One EC2 Instance**

However,

AWS supports **Multi-Attach** for selected **io1** and **io2** volumes.

Example:

```text
           io2 Volume
          /     |      \
         /      |       \
      EC2-1   EC2-2   EC2-3
```

### Important

Multi-Attach should only be used with applications that support shared block storage.

Using a normal filesystem (such as ext4 or XFS) on multiple servers simultaneously can cause data corruption.

---

# Production Storage Design

### Web Server

```text
Root Volume (30 GB gp3)

Application Volume (100 GB gp3)

Log Volume (100 GB gp3)
```

---

### Database Server

```text
Root Volume (50 GB gp3)

Database Volume (500 GB io2)

Backup Volume (gp3)
```

---

### Jenkins Server

```text
Root Volume

↓

Jenkins Home

↓

Separate gp3 Volume
```

This allows Jenkins data to remain safe even if the operating system needs to be rebuilt.

---

### Docker Server

```text
Root Volume

↓

Docker Images

↓

Separate gp3 Volume
```

This prevents the root filesystem from becoming full.

---

# Best Practices

✅ Use gp3 unless there is a special performance requirement.

✅ Keep the operating system on the Root Volume.

✅ Store application and database data on separate EBS volumes.

✅ Use io2 only for workloads requiring high and consistent IOPS.

✅ Never store production data on Instance Store.

✅ Tag every EBS volume with:

- Name
- Project
- Environment
- Owner

✅ Take snapshots before resizing or making major changes.

---

# Key Points

- Root Volume contains the Operating System.
- Additional Volumes store business data.
- gp3 is the default recommendation for most workloads.
- io2 is used for critical databases.
- Instance Store is temporary storage.
- Multi-Attach is supported only for selected io1/io2 volumes.

---

# 📀 AWS Elastic Block Store (EBS) –

> Understanding Performance, Encryption, Pricing, Monitoring, and Production Scenarios.


# EBS Performance

Storage performance is one of the most important concepts in AWS.

Whenever an application becomes slow, one of the first things engineers check is storage performance.

EBS performance mainly depends on:

- Volume Type
- IOPS
- Throughput
- Latency
- Queue Length

---

# What is IOPS?

**IOPS (Input/Output Operations Per Second)** represents how many read/write operations a storage device can perform every second.

Example:

```text
1000 IOPS

↓

Storage can perform approximately

1000 Read/Write Operations

every second
```

Higher IOPS means faster random disk operations.

---

## Applications requiring High IOPS

- Oracle Database
- SQL Server
- Banking Applications
- SAP
- OLTP Databases

Recommended Volume:

```text
io2
```

---

# What is Throughput?

Throughput represents how much data can be transferred every second.

Example:

```text
500 MB/sec
```

This means

500 MB of data can be transferred in one second.

---

## Applications requiring High Throughput

- Hadoop
- Log Processing
- Video Processing
- Big Data
- Backup Servers

Recommended Volume

```text
st1
```

---

# IOPS vs Throughput

| IOPS | Throughput |
|------|------------|
| Number of operations | Amount of data transferred |
| Small random requests | Large sequential requests |
| Important for Databases | Important for Big Data |

Example

Database

```text
Millions of small queries

↓

Need High IOPS
```

Video Processing

```text
Large Files

↓

Need High Throughput
```

---

# What is Latency?

Latency means

> Time taken to complete one disk operation.

Lower latency means better performance.

Example

```text
Disk Request

↓

2 ms

↓

Response
```

Lower latency is always preferred for:

- Databases
- Banking Applications
- Financial Systems

---

# Queue Length

Queue Length represents

> Number of disk requests waiting to be processed.

If Queue Length remains high continuously, it may indicate:

- Storage bottleneck
- Low IOPS
- Heavy workload
- Slow application

---

# Burst Balance

Some EBS volume types support Burst Performance.

When workload is low,

AWS accumulates burst credits.

When workload suddenly increases,

those credits are used to provide temporary higher performance.

Example

```text
Normal Load

↓

Credits Collected

↓

Heavy Load

↓

Burst Performance
```

CloudWatch provides a metric called:

```text
BurstBalance
```

If Burst Balance reaches zero,

performance may decrease.

---

# EBS Encryption

Amazon EBS supports encryption using

**AWS Key Management Service (AWS KMS).**

Encryption protects:

- Data at Rest
- Data in Transit
- Snapshots
- Restored Volumes

Architecture

```text
Application

↓

EC2

↓

Encrypted EBS

↓

Encrypted Snapshot
```

---

## Why Enable Encryption?

Benefits:

- Protect Sensitive Data
- Meet Compliance Requirements
- Secure Customer Information
- Secure Backups

Production recommendation:

> Always enable EBS Encryption unless there is a specific business reason not to.

---

# EBS Pricing

EBS pricing depends on several factors.

## 1. Storage Size

Example

```text
100 GB

↓

Pay for 100 GB
```

---

## 2. Volume Type

Example

```text
gp3

↓

Lower Cost

io2

↓

Higher Cost
```

---

## 3. Provisioned IOPS

For io2 volumes,

higher IOPS means higher cost.

---

## 4. Throughput

Additional throughput configuration may increase cost.

---

## 5. Snapshots

Snapshots are billed separately.

Unused snapshots should be cleaned up after verifying retention requirements.

---

# Monitoring using CloudWatch

AWS CloudWatch continuously monitors EBS performance.

Important Metrics

- VolumeReadOps
- VolumeWriteOps
- VolumeReadBytes
- VolumeWriteBytes
- VolumeQueueLength
- BurstBalance

Operations teams regularly monitor these metrics when troubleshooting storage issues.

---

# Production Scenario 1

## Disk Utilization Increasing

Application team reports

> Disk is almost full.

Investigation

```bash
df -h
```

Result

```text
95% Used
```

Solution

- Increase EBS Size
- Extend Partition
- Extend Filesystem

No downtime required for most supported configurations.

---

# Production Scenario 2

## Database Slow

Application Team:

> Database response is slow.

Investigation

CloudWatch shows

```text
High Queue Length

High Disk Utilization
```

Solution

- Verify workload
- Increase IOPS
- Upgrade from gp3 to io2 if required

---

# Production Scenario 3

## Root Filesystem Full

Symptoms

- SSH Login Slow
- Services Failing
- Logs Cannot Be Written

Investigation

```bash
df -h
du -sh /*
```

Solution

- Remove unnecessary files
- Move application data to another EBS volume
- Extend storage if required

---

# Production Scenario 4

## Backup Before Maintenance

Before:

- Kernel Upgrade
- Patch Update
- Database Upgrade
- Filesystem Changes

Always create

```text
Snapshot
```

If something goes wrong,

restore using Snapshot.

---

# Common Mistakes

❌ Keeping everything on Root Volume

❌ Using io2 for normal Linux servers

❌ Forgetting Snapshots before maintenance

❌ Creating EBS in the wrong Availability Zone

❌ Ignoring CloudWatch metrics

❌ Leaving unused EBS volumes attached

❌ Forgetting to delete old snapshots

❌ Running production without encryption

---

# Best Practices

✅ Use gp3 for most workloads

✅ Separate OS, Application and Database volumes

✅ Enable Encryption

✅ Monitor CloudWatch Metrics

✅ Take Snapshots before changes

✅ Delete unused resources

✅ Monitor Disk Usage

```bash
df -h
```

✅ Monitor Disk Performance

```bash
iostat

iotop
```

---

# Key Points

- IOPS = Number of Operations
- Throughput = Amount of Data
- Latency = Time to Respond
- Queue Length = Waiting Requests
- Burst Balance = Temporary Performance Credits
- Encryption uses AWS KMS
- CloudWatch monitors EBS
- Snapshots should be taken before maintenance

---

# 📀 AWS Elastic Block Store (EBS) – Part 1D

> Backup, Disaster Recovery, Snapshots, AMI, AWS Backup, Cross-Region Strategy, RTO, RPO & Interview Questions

---

# Backup

A **Backup** is simply a copy of your data.

Its purpose is to restore lost or corrupted data.

AWS provides multiple backup options.

- EBS Snapshot
- AMI
- AWS Backup

Example

```text
Production EBS

      │

      ▼

Snapshot Stored Safely
```

---

# Why Backup is Required?

Without backup,

- Hardware failure
- Human mistake
- Accidental deletion
- Data corruption
- Ransomware

can permanently destroy data.

Backup allows recovery.

---

# Snapshot

An **EBS Snapshot** is a point-in-time backup of an EBS Volume.

Architecture

```text
EBS Volume

      │

      ▼

Snapshot

      │

      ▼

New EBS Volume
```

Snapshot can be used for

- Backup
- Restore
- Migration
- Disaster Recovery

---

## Snapshot Features

- Incremental Backup
- Stored in Amazon S3 (managed internally by AWS)
- Faster Recovery
- Supports Encryption
- Can create new EBS Volumes

---

# AMI (Amazon Machine Image)

AMI is a complete image of an EC2 Instance.

It contains

- Operating System
- Installed Software
- Configuration
- EBS Snapshot
- Boot Configuration

Architecture

```text
EC2 Instance

      │

Create AMI

      │

      ▼

Launch New EC2
```

---

## Snapshot vs AMI

| Snapshot | AMI |
|-----------|-----|
| Backup of EBS Volume | Complete EC2 Template |
| Storage Only | OS + Configuration + Snapshot |
| Restore Volume | Launch New EC2 |
| Used for Backup | Used for Server Cloning |

---

# AWS Backup

AWS Backup is a managed backup service.

It can automate backups for

- EBS
- EC2
- RDS
- EFS
- DynamoDB

Benefits

- Automated Backup
- Retention Policies
- Central Management
- Compliance
- Lifecycle Management

---

# Cross-Region Backup

Production Example

```
Mumbai Region

↓

Snapshot

↓

Copy Snapshot

↓

Singapore Region
```

Purpose

If the Mumbai Region becomes unavailable,

the backup in Singapore can be used.

---

# Cross-Account Backup

Many companies keep backups in another AWS Account.

Example

```text
Production Account

↓

Snapshot

↓

Backup Account
```

Why?

If the Production Account is compromised,

the Backup Account still contains safe copies.

---

# Backup vs Disaster Recovery

Many beginners think these are the same.

They are NOT.

## Backup

Goal

Recover Data.

## Disaster Recovery

Goal

Recover the Entire Service.

Example

Production Server crashes.

Backup alone is not enough.

Need

- EC2
- Storage
- Database
- Networking
- DNS
- Application

Everything must become operational.

---

# Disaster Recovery Strategies

AWS commonly recommends four strategies.

---

## 1. Backup & Restore

```text
Production

↓

Snapshot / AMI

↓

Disaster

↓

Restore Server
```

Advantages

- Cheapest
- Easy

Disadvantages

- Longer downtime

Use Case

Development servers

Small applications

Internal tools

---

## 2. Pilot Light

Only the critical infrastructure remains ready.

Example

```text
Database

Running

↓

Application

Stopped

↓

Snapshots Ready
```

During disaster

Start remaining servers.

Good balance between cost and recovery time.

---

## 3. Warm Standby

This is one of the most common enterprise strategies.

Example

```text
Production

Running

        │

        ├──────────────┐

        │              │

        ▼              ▼

Primary         Standby Server

Running         Small Instance
```

Standby environment is regularly updated.

Examples

- Latest Application
- Latest Configuration
- Latest Security Patch
- Database Replication

During disaster

```text
Primary Down

↓

Start Standby

↓

Update Load Balancer

↓

Users Continue Working
```

Recovery Time

Usually

5–15 Minutes

---

## 4. Hot Standby (Multi-Site)

Most expensive.

Most reliable.

Architecture

```text
              Load Balancer

              /          \

             ▼            ▼

      Production      Secondary Site

         Running         Running
```

If Production fails,

Load Balancer automatically shifts traffic.

Downtime

Seconds.

---

# RTO

Recovery Time Objective

Maximum acceptable downtime.

Example

```
15 Minutes
```

Business expects service within 15 minutes.

---

# RPO

Recovery Point Objective

Maximum acceptable data loss.

Example

```
5 Minutes
```

Business can tolerate losing only the last five minutes of data.

---

# Production Example

Suppose

Amazon Website

Production

```
Mumbai
```

Disaster Recovery

```
Hyderabad
```

If Mumbai fails,

DNS or Load Balancer redirects users.

Business continues.

Customers may not even notice.

---

# Another Example

Company

Bank

Database

Running on EC2

Every night

- Snapshot
- AMI
- Cross Region Copy

Monthly

DR Drill

Purpose

Verify backup actually works.

---

# Best Practices

✅ Daily Snapshot

✅ Weekly AMI

✅ Cross-Region Backup

✅ Cross-Account Backup

✅ Enable Encryption

✅ Test Restore Process

✅ Perform DR Drill

✅ Monitor Backup Jobs

---

# Quick Revision

```
Snapshot = Volume Backup

AMI = Server Template

AWS Backup = Automated Backup

Cross Region = Region Failure

Cross Account = Account Failure

Backup = Recover Data

Disaster Recovery = Recover Service

Warm Standby = Ready Server

Pilot Light = Minimum Running

Hot Standby = Everything Running

RTO = Recovery Time

RPO = Data Loss
```

---

# Interview Questions

## What is EBS Snapshot?

A point-in-time backup of an EBS Volume.

---

## Difference between Snapshot and AMI?

Snapshot backs up storage.

AMI creates a launchable EC2 template.

---

## What is AWS Backup?

A managed AWS service that automates backups across multiple AWS services.

---

## Difference between Backup and Disaster Recovery?

Backup restores data.

Disaster Recovery restores the complete application and service.

---

## Why Cross-Region Backup?

Protection against complete AWS Region failure.

---

## Why Cross-Account Backup?

Protection against accidental deletion or production account compromise.

---

## What is Warm Standby?

A pre-configured standby environment that can be started quickly when production fails.

---

## What is Pilot Light?

Only critical infrastructure stays ready while application servers are launched during disaster.

---

## What is RTO?

Maximum acceptable downtime.

---

## What is RPO?

Maximum acceptable data loss.

---

# 💻 AWS Elastic Block Store (EBS) –(Hands-on)

> Complete hands-on guide to creating, attaching, formatting, mounting, resizing, and troubleshooting Amazon EBS volumes on Linux.

---

# 📚 Table of Contents

- Lab Overview
- Prerequisites
- Step 1 – Create an EBS Volume
- Step 2 – Attach the Volume to EC2
- Step 3 – Verify the Disk in Linux
- Step 4 – Create a Partition
- Step 5 – Create a Filesystem
- Step 6 – Mount the Volume
- Step 7 – Configure Permanent Mount
- Verification
- Common Errors
- Production Best Practices

---

# 🎯 Lab Overview

In this lab, we will learn how to:

- Create a new EBS Volume
- Attach it to an EC2 Instance
- Detect it in Linux
- Partition the Disk
- Create a Filesystem
- Mount the Filesystem
- Configure Automatic Mount after Reboot

---

# 🛠 Prerequisites

Before starting this lab, ensure you have:

- AWS Account
- Running EC2 Instance
- SSH Access
- Root or sudo privileges

Example Environment

```
Region : ap-south-1

Instance Name : Linux-Server

Operating System : Amazon Linux / RHEL / Ubuntu

New Volume : 20 GB gp3
```

---

# Step 1 – Create an EBS Volume

AWS Console

```
EC2

↓

Elastic Block Store

↓

Volumes

↓

Create Volume
```

Choose

```
Volume Type

↓

gp3
```

Size

```
20 GB
```

Availability Zone

```
Must match EC2 AZ
```

Example

```
EC2

ap-south-1a

↓

Create Volume

ap-south-1a
```

Click

```
Create Volume
```

✅ Volume Status

```
Available
```

---

# Step 2 – Attach Volume to EC2

Select Volume

↓

Actions

↓

Attach Volume

↓

Select EC2 Instance

↓

Attach

Status becomes

```
In-use
```

---

# Step 3 – Verify the Disk in Linux

Login to EC2

```bash
ssh ec2-user@Public-IP
```

Check available disks

```bash
lsblk
```

Example Output

```text
NAME      SIZE

xvda       20G

└─xvda1    20G

xvdf       20G
```

Alternative Commands

```bash
fdisk -l

```

```bash
blkid
```

```bash
cat /proc/partitions
```

At this stage

```
Disk Exists

Filesystem ❌

Mount ❌
```

---

# Step 4 – Create a Partition

Run

```bash
sudo fdisk /dev/xvdf
```

Inside fdisk

```
n

p

1

Enter

Enter

w
```

Reload partition table

```bash
partprobe
```

Verify

```bash
lsblk
```

Output

```text
xvdf

└── xvdf1
```

Now partition has been created.

---

# Step 5 – Create a Filesystem

For XFS

```bash
sudo mkfs.xfs /dev/xvdf1
```

For EXT4

```bash
sudo mkfs.ext4 /dev/xvdf1
```

Verify

```bash
blkid
```

Example

```text
TYPE="xfs"
```

Filesystem is now ready.

---

# Step 6 – Mount the Volume

Create directory

```bash
sudo mkdir /data
```

Mount

```bash
sudo mount /dev/xvdf1 /data
```

Verify

```bash
df -h
```

Example

```text
Filesystem

/dev/xvdf1

Mounted on

/data
```

Also verify

```bash
mount | grep data
```

Now applications can use

```
/data
```

---

# Step 7 – Permanent Mount

Temporary mounts disappear after reboot.

To mount automatically

Open

```bash
sudo vi /etc/fstab
```

Add

```text
/dev/xvdf1    /data    xfs    defaults,nofail    0    2
```

or

```text
UUID=<UUID>   /data   xfs   defaults,nofail   0 2
```

Get UUID

```bash
blkid
```

Test configuration

```bash
sudo mount -a
```

No output

↓

Configuration is correct.

---

# Verification

Check mount

```bash
df -h
```

Check filesystem

```bash
lsblk -f
```

Check UUID

```bash
blkid
```

Check mounted filesystem

```bash
mount
```

Everything should display correctly.

---

# Common Errors

## Disk Not Visible

Check

```bash
lsblk
```

If missing

Verify

- Correct AZ
- Volume Attached
- Instance Restart (rare cases)

---

## Wrong Filesystem

Example

Trying

```
mount

↓

unknown filesystem
```

Solution

```bash
blkid
```

Verify filesystem type.

---

## fstab Error

Symptoms

- Boot Failure
- Emergency Mode

Always test

```bash
mount -a
```

before reboot.

---

## Permission Issues

If application cannot write

Check

```bash
ls -ld /data
```

Fix

```bash
sudo chown

sudo chmod
```

---

# Production Best Practices

✅ Always use UUID in `/etc/fstab`

✅ Use separate mount points

```
/data

/logs

/backup
```

instead of storing everything on `/`.

✅ Verify using

```bash
df -h

lsblk

blkid
```

after every change.

✅ Take Snapshot before making filesystem changes.

✅ Never reboot without testing

```bash
mount -a
```

---

# Key Commands

```bash
lsblk

fdisk -l

fdisk /dev/xvdf

partprobe

mkfs.xfs

mkfs.ext4

mkdir

mount

df -h

blkid

mount -a
```

---

# 💻 AWS Elastic Block Store (EBS) – (Resize EBS Volume)

> Learn how to safely increase EBS storage in AWS and extend the partition and filesystem inside Linux.

---

# 📚 Table of Contents

- Why Resize an EBS Volume?
- Storage Expansion Workflow
- Step 1 – Increase EBS Size
- Step 2 – Verify New Disk Size
- Step 3 – Extend the Partition
- Step 4 – Extend the Filesystem
- Verification
- Production Scenarios
- Troubleshooting
- Best Practices

---

# Why Resize an EBS Volume?

As applications grow, storage usage also increases.

Common reasons:

- Database size increases
- Log files consume disk space
- Application uploads increase
- Backup files require more storage

Instead of creating a new server, AWS allows us to increase the size of an existing EBS volume.

---

# Storage Expansion Workflow

```text
Current Disk

↓

Increase EBS Size (AWS Console)

↓

Operating System Detects New Size

↓

Extend Partition

↓

Extend Filesystem

↓

Application Uses New Space
```

---

# Step 1 – Increase EBS Size

AWS Console

```
EC2

↓

Volumes

↓

Select Volume

↓

Actions

↓

Modify Volume
```

Example

```
Old Size

20 GB

↓

New Size

50 GB
```

Click

```
Modify
```

Wait until

```
Optimizing

↓

Completed
```

---

# Step 2 – Verify New Disk Size

Login to Linux

Run

```bash
lsblk
```

Example

Before

```text
xvdf

20G
```

After AWS Resize

```text
xvdf

50G
```

Notice

The partition may still be

```text
xvdf1

20G
```

This means

Disk increased

Partition not increased.

---

# Step 3 – Extend the Partition

Install growpart if required.

Amazon Linux

```bash
sudo yum install cloud-utils-growpart -y
```

Ubuntu

```bash
sudo apt install cloud-guest-utils -y
```

Run

```bash
sudo growpart /dev/xvdf 1
```

Meaning

```
Disk

↓

/dev/xvdf

Partition

↓

1
```

Verify

```bash
lsblk
```

Now

```text
xvdf1

50G
```

---

# Step 4 – Extend the Filesystem

The command depends on the filesystem.

---

## XFS Filesystem

Check

```bash
df -Th
```

If

```text
xfs
```

Run

```bash
sudo xfs_growfs /data
```

Verify

```bash
df -h
```

Storage is now available.

---

## EXT4 Filesystem

Check

```bash
df -Th
```

If

```text
ext4
```

Run

```bash
sudo resize2fs /dev/xvdf1
```

Verify

```bash
df -h
```

Filesystem has been expanded.

---

# Complete Resize Flow

```text
Modify Volume (AWS)

↓

lsblk

↓

growpart

↓

xfs_growfs / resize2fs

↓

df -h
```

---

# Verification

Check disk

```bash
lsblk
```

Check filesystem

```bash
df -Th
```

Check available space

```bash
df -h
```

Check block device

```bash
blkid
```

Everything should now display the new storage size.

---

# Production Scenario 1

## Root Filesystem 95% Full

Monitoring Alert

```
Disk Usage

95%
```

Steps

```text
Modify Volume

↓

growpart

↓

xfs_growfs

↓

Disk Normal
```

No application migration required.

---

# Production Scenario 2

## Database Storage Full

Symptoms

- Database cannot write
- Application errors
- Transactions fail

Solution

Increase EBS

↓

Extend Partition

↓

Extend Filesystem

↓

Database resumes normal operation

---

# Production Scenario 3

## Log Files Filling Disk

Investigation

```bash
df -h

du -sh /*
```

If cleanup is insufficient,

Increase storage using the resize process.

---

# Troubleshooting

## growpart Not Found

Install

Amazon Linux

```bash
sudo yum install cloud-utils-growpart -y
```

Ubuntu

```bash
sudo apt install cloud-guest-utils -y
```

---

## Filesystem Not Increasing

Possible causes

- Partition not extended
- Wrong filesystem command used

Always verify

```bash
df -Th
```

before running

```
resize2fs

or

xfs_growfs
```

---

## Still Showing Old Size

Run

```bash
lsblk
```

If partition size is unchanged,

Run

```bash
growpart
```

again after confirming the volume modification is complete.

---

# Best Practices

✅ Take an EBS Snapshot before resizing.

✅ Verify the filesystem type before extending.

```bash
df -Th
```

✅ Use

```bash
growpart
```

before

```bash
resize2fs

or

xfs_growfs
```

✅ Verify using

```bash
lsblk

df -h

blkid
```

after completion.

✅ Perform the resize during a maintenance window for critical production systems if required by company policy.

---

# Quick Revision

```text
Increase Volume (AWS)

↓

lsblk

↓

growpart

↓

xfs_growfs (XFS)

OR

resize2fs (EXT4)

↓

df -h
```

---

# Interview Questions

## Can we increase an EBS volume without creating a new one?

Yes. AWS allows online EBS volume expansion by modifying the volume size.

---

## Which command extends the partition?

```bash
growpart
```

---

## Which command extends an XFS filesystem?

```bash
xfs_growfs
```

---

## Which command extends an EXT4 filesystem?

```bash
resize2fs
```

---

## How do you verify the filesystem type?

```bash
df -Th
```

or

```bash
lsblk -f
```

---

## Can we reduce the size of an EBS volume?

No.

AWS supports increasing the size of an EBS volume, but direct shrinking is not supported. To reduce storage, create a new smaller volume, migrate the data, validate it, and then replace the old volume.

---

# 💻 AWS Elastic Block Store (EBS) – (LVM & Production Troubleshooting)

> Learn how to use Logical Volume Manager (LVM) with Amazon EBS and handle real-world production storage scenarios.

---

# 📚 Table of Contents

- What is LVM?
- Why Do We Use LVM?
- LVM Architecture
- LVM Components
- Create a New LVM
- Extend Existing LVM
- Important Commands
- Production Scenarios
- Troubleshooting
- Best Practices
- Interview Questions

---

# What is LVM?

**LVM (Logical Volume Manager)** is a storage management layer in Linux.

It allows multiple physical disks to be combined into a single storage pool and enables storage expansion without rebuilding the server.

Without LVM

```text
Disk

↓

Filesystem

↓

Mount
```

With LVM

```text
Disk

↓

Physical Volume (PV)

↓

Volume Group (VG)

↓

Logical Volume (LV)

↓

Filesystem

↓

Mount
```

---

# Why Do We Use LVM?

LVM provides flexibility.

Benefits:

- Increase storage without reinstalling Linux
- Combine multiple EBS volumes
- Easy storage management
- Better production scalability
- Easier disaster recovery
- Online filesystem expansion

---

# LVM Architecture

```text
EBS Volume 1
       │
       ▼
     PV1

EBS Volume 2
       │
       ▼
     PV2

       │
       ▼

+----------------------+
|   Volume Group (VG)  |
+----------------------+

           │

           ▼

+----------------------+
| Logical Volume (LV)  |
+----------------------+

           │

           ▼

Filesystem (XFS / EXT4)

           │

           ▼

Mounted Directory
```

---

# LVM Components

## 1. Physical Volume (PV)

A disk initialized for LVM.

Example

```bash
pvcreate /dev/xvdf
```

---

## 2. Volume Group (VG)

A storage pool created from one or more Physical Volumes.

Example

```bash
vgcreate app_vg /dev/xvdf
```

---

## 3. Logical Volume (LV)

A virtual disk created from the Volume Group.

Example

```bash
lvcreate -L 10G -n app_lv app_vg
```

---

# Create a New LVM

## Step 1

Create Physical Volume

```bash
pvcreate /dev/xvdf
```

---

## Step 2

Create Volume Group

```bash
vgcreate app_vg /dev/xvdf
```

---

## Step 3

Create Logical Volume

```bash
lvcreate -L 10G -n app_lv app_vg
```

---

## Step 4

Create Filesystem

XFS

```bash
mkfs.xfs /dev/app_vg/app_lv
```

EXT4

```bash
mkfs.ext4 /dev/app_vg/app_lv
```

---

## Step 5

Create Mount Directory

```bash
mkdir /data
```

---

## Step 6

Mount

```bash
mount /dev/app_vg/app_lv /data
```

---

## Step 7

Permanent Mount

Get UUID

```bash
blkid
```

Edit

```bash
vi /etc/fstab
```

Example

```text
UUID=<UUID> /data xfs defaults 0 2
```

Test

```bash
mount -a
```

---

# Extend Existing LVM

Suppose

```
Application Team

↓

Disk Full
```

Attach a new EBS volume.

Example

```
Old Disk

↓

20 GB

↓

New EBS

↓

20 GB
```

---

## Step 1

Create Physical Volume

```bash
pvcreate /dev/xvdg
```

---

## Step 2

Extend Volume Group

```bash
vgextend app_vg /dev/xvdg
```

---

## Step 3

Verify

```bash
vgs
```

---

## Step 4

Extend Logical Volume

Use all free space

```bash
lvextend -l +100%FREE /dev/app_vg/app_lv
```

Or extend by size

```bash
lvextend -L +20G /dev/app_vg/app_lv
```

---

## Step 5

Extend Filesystem

For XFS

```bash
xfs_growfs /data
```

For EXT4

```bash
resize2fs /dev/app_vg/app_lv
```

---

## Step 6

Verify

```bash
df -h
```

Storage has now increased.

---

# Important LVM Commands

Show Physical Volumes

```bash
pvs
```

Show Volume Groups

```bash
vgs
```

Show Logical Volumes

```bash
lvs
```

Detailed Information

```bash
pvdisplay

vgdisplay

lvdisplay
```

Filesystem

```bash
df -Th
```

---

# Production Scenario 1

## Application Disk Full

Monitoring Alert

```
95% Disk Usage
```

Steps

```text
Attach New EBS

↓

pvcreate

↓

vgextend

↓

lvextend

↓

xfs_growfs

↓

Application Normal
```

---

# Production Scenario 2

## Database Storage Full

Database Team

```
Cannot Write Data
```

Investigation

```bash
df -h

lvs

vgs
```

Solution

Increase storage using LVM.

---

# Production Scenario 3

## Root Filesystem Full

Never store

- Database
- Logs
- Backups

on

```
/
```

Instead

Use separate LVM mount points

```text
/data

/logs

/backup
```

---

# Troubleshooting

## VG Not Found

Check

```bash
vgs
```

---

## LV Not Found

Check

```bash
lvs
```

---

## PV Missing

Check

```bash
pvs
```

---

## Filesystem Not Growing

Verify

```bash
df -Th
```

Run correct command

XFS

```bash
xfs_growfs
```

EXT4

```bash
resize2fs
```

---

## Mount Failure

Check

```bash
mount -a
```

Review

```bash
/etc/fstab
```

---

# Best Practices

✅ Use LVM for production servers.

✅ Keep separate mount points.

```
/data

/logs

/backup
```

✅ Take Snapshot before LVM changes.

✅ Monitor free space.

```bash
vgs

lvs

df -h
```

✅ Use UUID in `/etc/fstab`.

---

# Quick Revision

```text
Disk

↓

PV

↓

VG

↓

LV

↓

Filesystem

↓

Mount
```

Expansion Flow

```text
Attach EBS

↓

pvcreate

↓

vgextend

↓

lvextend

↓

xfs_growfs

↓

df -h
```

---

# Interview Questions

## What is LVM?

LVM is a Linux storage management technology that allows flexible storage allocation and online expansion using Physical Volumes, Volume Groups, and Logical Volumes.

---

## What are the components of LVM?

- Physical Volume (PV)
- Volume Group (VG)
- Logical Volume (LV)

---

## Which command creates a Physical Volume?

```bash
pvcreate
```

---

## Which command extends a Volume Group?

```bash
vgextend
```

---

## Which command extends a Logical Volume?

```bash
lvextend
```

---

## How do you check LVM information?

```bash
pvs
vgs
lvs
```

---

## Why is LVM preferred in production?

Because it allows storage expansion, better disk management, easier maintenance, and reduced downtime without rebuilding the server.

---

# 📸 AWS Elastic Block Store (EBS) – (Snapshots)

> Complete guide to Amazon EBS Snapshots for Backup, Restore, Migration, and Disaster Recovery.

---

# 📚 Table of Contents

- What is an EBS Snapshot?
- Why Do We Need Snapshots?
- How Snapshots Work
- Snapshot Architecture
- Snapshot Lifecycle
- Incremental Snapshots
- Snapshot Encryption
- Snapshot Restore
- Snapshot Use Cases
- Best Practices

---

# What is an EBS Snapshot?

An **Amazon EBS Snapshot** is a **point-in-time backup** of an EBS Volume.

A Snapshot captures the data stored on an EBS volume and stores it safely inside AWS.

Unlike a normal file copy, an EBS Snapshot is storage-efficient because AWS stores only the changed blocks after the first backup.

---

# Why Do We Need Snapshots?

Snapshots are mainly used for

- Backup
- Restore
- Disaster Recovery
- Migration
- Cloning
- Data Protection
- Before Maintenance
- Before Major Upgrades

Without snapshots,

if an EBS volume becomes corrupted or is accidentally deleted, recovering the data may not be possible.

---

# How Snapshots Work

```
Application

↓

EC2

↓

EBS Volume

↓

Snapshot

↓

Amazon S3
(Managed Internally by AWS)
```

> AWS manages the underlying storage automatically. Users do not directly access the S3 bucket used for snapshots.

---

# Snapshot Architecture

```
EC2 Instance
      │
      ▼
+-------------------+
|   EBS Volume      |
+-------------------+
          │
 Create Snapshot
          │
          ▼
+-------------------+
|   Snapshot        |
+-------------------+
          │
          ▼
Create New Volume
          │
          ▼
Attach to EC2
```

---

# Snapshot Lifecycle

```
Create Volume

↓

Store Data

↓

Create Snapshot

↓

Modify Data

↓

Create Another Snapshot

↓

Restore When Required
```

Snapshots become the recovery point for future restores.

---

# Incremental Snapshots

This is one of the most important interview topics.

### First Snapshot

```
100 GB Volume

↓

Snapshot-1

100 GB Copied
```

---

### Second Snapshot

Suppose only **5 GB** of data changes.

AWS copies only those changed blocks.

```
Changed Data

↓

5 GB

↓

Snapshot-2
```

AWS does **not** copy the complete 100 GB again.

---

### Third Snapshot

Again,

only changed blocks are stored.

```
Snapshot-1

↓

Snapshot-2

↓

Snapshot-3
```

This makes snapshots:

- Faster
- Cheaper
- Storage Efficient

---

# Snapshot Encryption

If the source EBS volume is encrypted,

the snapshot will also remain encrypted.

```
Encrypted Volume

↓

Encrypted Snapshot

↓

Encrypted Restored Volume
```

Encryption is handled using **AWS Key Management Service (KMS).**

---

# Restore from Snapshot

Snapshots can be used to create a new EBS volume.

Workflow

```
Snapshot

↓

Create Volume

↓

Attach to EC2

↓

Mount

↓

Application Ready
```

The original snapshot remains unchanged.

---

# Common Snapshot Use Cases

## Before OS Upgrade

Always take a snapshot before

- Kernel Upgrade
- Package Update
- Major Patch

If anything fails,

restore using the snapshot.

---

## Before Application Deployment

Production deployments should always begin with a snapshot.

This allows quick rollback if deployment fails.

---

## Before Database Upgrade

Before upgrading

- MySQL
- PostgreSQL
- Oracle
- SQL Server

take an EBS snapshot.

---

## Before Filesystem Changes

Before

- Partition Changes
- LVM Expansion
- Filesystem Resize

create a snapshot.

---

# Production Example

A banking application stores customer transactions on an EBS volume.

Every night:

```
02:00 AM

↓

Automatic Snapshot

↓

Retention Policy

↓

30 Days
```

If corruption occurs,

operations can restore data from the latest healthy snapshot.

---

# Snapshot Limitations

Snapshots are **volume-level backups**.

They do not automatically capture:

- Running application state
- Memory (RAM)
- CPU state

For complete server cloning,

AMI is generally a better option.

---

# Best Practices

✅ Take snapshots before maintenance.

✅ Automate snapshots.

✅ Tag snapshots.

✅ Delete unused snapshots after verifying retention policies.

✅ Encrypt production snapshots.

✅ Copy critical snapshots to another AWS Region.

✅ Test restore procedures regularly.

---

# Quick Revision

```
Snapshot

↓

Point-in-Time Backup

↓

Incremental

↓

Stored by AWS

↓

Restore New Volume

↓

Attach to EC2
```

---

# Interview Questions

## What is an EBS Snapshot?

A point-in-time backup of an Amazon EBS volume.

---

## Are EBS Snapshots Incremental?

Yes.

After the first full snapshot, AWS stores only changed blocks.

---

## Can a Snapshot be attached directly to an EC2 instance?

No.

A new EBS volume must first be created from the snapshot.

---

## Can encrypted snapshots create encrypted volumes?

Yes.

Encrypted snapshots create encrypted EBS volumes unless a different encryption option is selected where supported.

---

## When should you take a Snapshot?

- Before patching
- Before upgrades
- Before resizing storage
- Before application deployment
- Before database maintenance

---

# 🖥️ AWS Elastic Block Store (EBS) –(Amazon Machine Image - AMI)

> Complete guide to Amazon Machine Image (AMI) for EC2 deployment, cloning, backup, disaster recovery, and production environments.

---

# 📚 Table of Contents

- What is AMI?
- Why Do We Need AMI?
- AMI Components
- AMI Architecture
- How AMI Works
- Create an AMI
- Launch EC2 from AMI
- AMI Types
- Golden AMI
- AMI vs Snapshot
- Production Use Cases
- Best Practices
- Interview Questions

---

# What is AMI?

**Amazon Machine Image (AMI)** is a pre-configured template used to launch an EC2 instance.

An AMI contains everything required to create a new server.

It includes:

- Operating System
- Installed Packages
- Applications
- Configuration Files
- EBS Snapshot(s)
- Boot Configuration

Think of an AMI as a **template of a complete server**.

---

# Why Do We Need AMI?

Imagine you configured one production server with:

- Amazon Linux
- Apache
- Java
- Docker
- Monitoring Agent
- Security Hardening

Now you need 20 more identical servers.

Instead of configuring every server manually,

simply create an AMI and launch new EC2 instances from it.

Advantages:

- Faster deployment
- Standardized servers
- Easy rollback
- Disaster Recovery
- Auto Scaling
- Environment consistency

---

# AMI Architecture

```text
                 EC2 Instance
                      │
                      ▼
      +-------------------------------+
      | Operating System              |
      | Installed Software            |
      | Configuration                 |
      | Boot Volume                   |
      | Additional EBS Volumes*       |
      +-------------------------------+
                      │
               Create AMI
                      │
                      ▼
            Amazon Machine Image
                      │
          Launch New EC2 Instance
                      │
                      ▼
          Identical Server Created
```

> *Additional EBS volumes can be included if selected during AMI creation.

---

# AMI Components

## 1. Operating System

Examples:

- Amazon Linux
- Ubuntu
- RHEL
- Windows Server

---

## 2. EBS Snapshot

AMI internally uses one or more **EBS Snapshots**.

These snapshots store the disk data.

---

## 3. Launch Permissions

Launch permissions determine who can use the AMI.

Examples:

- Private
- Shared with another AWS Account
- Public

---

## 4. Block Device Mapping

Defines:

- Root Volume
- Additional Volumes
- Volume Size
- Delete on Termination
- Volume Type

---

# How AMI Works

```text
Existing EC2

↓

Create AMI

↓

AMI Created

↓

Launch New EC2

↓

New Server Ready
```

Every EC2 launched from the same AMI starts with the same operating system and configuration.

---

# Create an AMI

AWS Console

```
EC2

↓

Instances

↓

Select Instance

↓

Actions

↓

Image and Templates

↓

Create Image
```

Provide

```
Image Name

↓

Description

↓

Create Image
```

AWS automatically creates:

- EBS Snapshot
- AMI

---

# Launch EC2 from AMI

```
EC2

↓

Launch Instance

↓

My AMIs

↓

Select Required AMI

↓

Launch
```

The new server will contain:

- Same Operating System
- Same Installed Software
- Same Configuration
- Same Packages

---

# Types of AMIs

## Public AMI

Created by:

- AWS
- Community
- Marketplace Vendors

Examples:

- Amazon Linux
- Ubuntu
- Windows Server

---

## Private AMI

Visible only within your AWS account.

Mostly used in production.

---

## Shared AMI

Shared with specific AWS Accounts.

Useful when multiple AWS accounts belong to the same organization.

---

# Golden AMI

A **Golden AMI** is a company-approved master image.

It already contains:

- Approved OS
- Latest Patches
- Security Configuration
- Monitoring Agent
- Company Software
- Security Policies

Example:

```text
Golden AMI

↓

Launch 100 Servers

↓

All Servers Identical
```

Large organizations use Golden AMIs to maintain standardization.

---

# AMI vs Snapshot

| Snapshot | AMI |
|----------|-----|
| Backup of EBS Volume | Complete EC2 Template |
| Stores Storage Only | Stores Server Configuration |
| Cannot Launch EC2 Directly | Can Launch EC2 Directly |
| Used for Restore | Used for Cloning & Deployment |
| Volume Level | Server Level |

---

# Production Use Cases

## 1. Auto Scaling

Auto Scaling Groups launch new EC2 instances using an AMI.

```text
Traffic Increase

↓

Auto Scaling

↓

Launch EC2

↓

Using Golden AMI
```

---

## 2. Disaster Recovery

Production server crashes.

Instead of installing everything again,

launch a new EC2 using the latest AMI.

Recovery becomes much faster.

---

## 3. Development Environment

Developers require identical servers.

Instead of manual installation,

launch servers from the same AMI.

---

## 4. Patch Rollback

Before patching,

create an AMI.

If the patch fails,

launch a new EC2 using the previous AMI.

---

# Best Practices

✅ Create AMIs before major upgrades.

✅ Keep naming standards.

Example:

```
prod-web-v1

prod-web-v2

prod-web-v3
```

✅ Delete unused AMIs.

✅ Remove old snapshots after verifying they are no longer required.

✅ Encrypt production AMIs.

✅ Use Golden AMIs for Auto Scaling.

✅ Test AMIs before using them in production.

---

# Common Mistakes

❌ Creating AMIs too frequently without cleanup.

❌ Forgetting that AMIs also consume snapshot storage.

❌ Not testing the AMI before production deployment.

❌ Using outdated AMIs for Auto Scaling.

❌ Forgetting to update the Golden AMI after security patches.

---

# Quick Revision

```text
AMI

↓

Complete Server Template

↓

Contains

OS

+

Configuration

+

Application

+

EBS Snapshot

↓

Launch New EC2

↓

Identical Server
```

---

# Interview Questions

## What is an AMI?

An Amazon Machine Image (AMI) is a pre-configured template used to launch EC2 instances. It includes the operating system, configuration, installed software, and references to EBS snapshots.

---

## Does an AMI contain a Snapshot?

Yes.

An EBS-backed AMI uses one or more EBS snapshots to store the volume data.

---

## Difference between Snapshot and AMI?

Snapshot is a backup of an EBS volume.

AMI is a complete EC2 template that can launch new instances.

---

## Why is AMI used in Auto Scaling?

Auto Scaling launches new EC2 instances from an AMI to ensure every instance has the same operating system, software, and configuration.

---

## What is a Golden AMI?

A Golden AMI is a company-approved standard image containing patched OS, security configurations, monitoring agents, and required software for production deployments.

---

## Can we update an existing AMI?

No.

AMIs are immutable.

If changes are required:

1. Launch an EC2 from the existing AMI.
2. Make the required changes.
3. Create a new AMI.
4. Replace the old AMI where necessary.

---

# 🎯 Key Takeaways

- AMI is a complete EC2 template.
- AMI includes EBS Snapshot(s).
- Used for cloning, Auto Scaling, Disaster Recovery, and standard deployments.
- Golden AMIs provide consistency across environments.
- AMIs should be versioned, tested, and regularly updated.

---

# 💾 AWS Elastic Block Store (EBS) – (AWS Backup & Data Lifecycle Manager)

> Complete guide to AWS Backup and Data Lifecycle Manager (DLM) for automating EBS backups and implementing enterprise backup strategies.

---

# 📚 Table of Contents

- What is AWS Backup?
- Why Use AWS Backup?
- AWS Backup Architecture
- Backup Components
- Creating a Backup Plan
- Backup Vault
- Restore Process
- What is Data Lifecycle Manager (DLM)?
- AWS Backup vs DLM
- Production Use Cases
- Best Practices
- Interview Questions

---

# What is AWS Backup?

AWS Backup is a **fully managed backup service** that centralizes and automates backups for AWS resources.

Supported services include:

- Amazon EBS
- Amazon EC2 (via EBS)
- Amazon RDS
- Amazon DynamoDB
- Amazon EFS
- Amazon FSx
- Amazon S3 (supported through AWS Backup)

Instead of manually creating snapshots, AWS Backup automates the process.

---

# Why Use AWS Backup?

Without automation:

```text
Administrator

↓

Login Daily

↓

Create Snapshot

↓

Delete Old Backup

↓

Repeat Every Day
```

This is time-consuming and error-prone.

With AWS Backup:

```text
Backup Plan

↓

Automatic Backup

↓

Retention Policy

↓

Automatic Cleanup
```

Advantages:

- Automated backups
- Centralized management
- Compliance support
- Cross-region backup
- Cross-account backup
- Automatic retention

---

# AWS Backup Architecture

```text
EC2

↓

EBS Volume

↓

AWS Backup Plan

↓

Backup Vault

↓

Restore When Needed
```

---

# AWS Backup Components

## 1. Backup Plan

Defines:

- Backup Schedule
- Backup Frequency
- Retention Period
- Lifecycle Rules

Example:

```
Daily Backup

02:00 AM

Retention

30 Days
```

---

## 2. Backup Rule

Defines:

- When backup runs
- Backup window
- Lifecycle
- Cold storage transition (where supported)

---

## 3. Backup Vault

A secure storage location for backups.

Example:

```text
Production Vault

Development Vault

Finance Vault
```

Backups are organized inside Backup Vaults.

---

## 4. Resource Assignment

Defines which resources will be protected.

Example:

```
Production EC2

↓

EBS Volumes

↓

Backup Plan
```

Assignments can be based on:

- Resource IDs
- Tags

---

# Create a Backup Plan

AWS Console

```
AWS Backup

↓

Backup Plans

↓

Create Backup Plan
```

Choose

```
Build New Plan
```

Example

```
Plan Name

Daily-Production
```

Schedule

```
Every Day

02:00 AM
```

Retention

```
30 Days
```

Assign Resources

```
Production Servers
```

Done.

Backups now run automatically.

---

# Backup Vault

A Backup Vault stores recovery points.

Example

```text
Backup Vault

↓

Recovery Point 1

Recovery Point 2

Recovery Point 3
```

Vaults can be encrypted using AWS KMS.

---

# Restore Process

Workflow

```text
Backup Vault

↓

Recovery Point

↓

Restore

↓

New EBS Volume

↓

Attach to EC2
```

Or restore according to the supported workflow for the protected service.

---

# What is Data Lifecycle Manager (DLM)?

Amazon Data Lifecycle Manager (DLM) automates the creation, retention, and deletion of **EBS Snapshots** and **EBS-backed AMIs**.

It is designed specifically for EBS lifecycle management.

---

# DLM Workflow

```text
EBS Volume

↓

Lifecycle Policy

↓

Automatic Snapshot

↓

Retention

↓

Automatic Deletion
```

Example

```
Every Night

↓

Create Snapshot

↓

Keep 7 Days

↓

Delete Older Snapshots
```

No manual work required.

---

# DLM Policy Example

Policy

```text
Frequency

Every 24 Hours

Retention

7 Snapshots

Target

Tag = Production
```

Every EBS volume with the specified tag will automatically follow the policy.

---

# AWS Backup vs DLM

| AWS Backup | DLM |
|------------|-----|
| Supports Multiple AWS Services | Focused on EBS Snapshots & EBS-backed AMIs |
| Centralized Backup Management | Simple Lifecycle Automation |
| Backup Vault | No Backup Vault |
| Compliance Features | Basic Automation |
| Cross-Service Backup | EBS-focused |

---

# Production Scenario 1

## Daily Production Backup

Requirement

```
Every Day

02:00 AM

Keep

30 Days
```

Solution

AWS Backup Plan

↓

Automatic Backup

↓

Automatic Retention

---

# Production Scenario 2

## Automatic Snapshot Cleanup

Requirement

```
Create Snapshot

Every Night

Keep Last

7 Snapshots
```

Solution

DLM Policy

↓

Automatic Cleanup

---

# Production Scenario 3

## Tag-Based Backup

All resources with

```
Environment=Production
```

automatically receive scheduled backups.

No need to manually add new servers.

---

# Best Practices

✅ Encrypt Backup Vaults.

✅ Use IAM roles with least privilege.

✅ Apply tag-based backup assignments.

✅ Test restore procedures regularly.

✅ Copy critical backups to another AWS Region.

✅ Define retention policies based on business requirements.

✅ Use AWS Backup for centralized multi-service backup.

✅ Use DLM for simple EBS snapshot automation.

---

# Common Mistakes

❌ Never testing restores.

❌ Keeping backups forever without a retention policy.

❌ Forgetting to protect newly created resources.

❌ Not encrypting production backups.

❌ Using only one region for critical backups.

---

# Quick Revision

```text
AWS Backup

↓

Backup Plan

↓

Backup Vault

↓

Recovery Point

↓

Restore
```

---

```text
DLM

↓

Lifecycle Policy

↓

Automatic Snapshot

↓

Retention

↓

Automatic Cleanup
```

---

# Interview Questions

## What is AWS Backup?

AWS Backup is a fully managed service that centralizes and automates backups for multiple AWS services.

---

## What is DLM?

Amazon Data Lifecycle Manager automates EBS snapshot and EBS-backed AMI creation, retention, and deletion.

---

## Difference between AWS Backup and DLM?

AWS Backup supports multiple AWS services with centralized management.

DLM focuses specifically on automating EBS snapshot and EBS-backed AMI lifecycle.

---

## What is a Backup Vault?

A secure logical container that stores backup recovery points.

---

## Can AWS Backup perform cross-region backups?

Yes.

AWS Backup supports copying backups to another AWS Region for disaster recovery.

---

## Why are tags useful in AWS Backup?

Tags allow backup plans or lifecycle policies to automatically include new resources that match the tag.

---

# 🎯 Key Takeaways

- AWS Backup is an enterprise backup solution.
- Backup Plans automate scheduling.
- Backup Vault stores recovery points securely.
- DLM automates EBS snapshot and EBS-backed AMI lifecycle.
- Tag-based policies simplify production management.
- Always verify restore capability—not just backup success.

---

# 🌍 AWS Elastic Block Store (EBS) – (Disaster Recovery - DR)

> Complete guide to Disaster Recovery (DR) strategies in AWS, including RTO, RPO, Backup & Restore, Pilot Light, Warm Standby, Hot Standby, and Multi-Region DR.

---

# 📚 Table of Contents

- What is Disaster Recovery?
- Why is Disaster Recovery Important?
- DR Terminology
- RTO (Recovery Time Objective)
- RPO (Recovery Point Objective)
- Disaster Recovery Workflow
- DR Strategies
- Backup & Restore
- Pilot Light
- Warm Standby
- Hot Standby (Multi-Site)
- Multi-Region Disaster Recovery
- Production Examples
- Best Practices
- Interview Questions

---

# What is Disaster Recovery?

Disaster Recovery (DR) is the process of restoring IT services after a major failure or disaster.

Examples of disasters:

- AWS Region Failure
- Availability Zone Failure
- Data Corruption
- Ransomware Attack
- Accidental Data Deletion
- Hardware Failure
- Natural Disaster

The goal of DR is to minimize downtime and data loss.

---

# Why is Disaster Recovery Important?

Without DR:

```text
Production Server

↓

Failure

↓

Business Stops
```

With DR:

```text
Production Failure

↓

Disaster Recovery

↓

Business Continues
```

---

# Disaster Recovery Terminology

| Term | Meaning |
|------|---------|
| DR | Disaster Recovery |
| RTO | Recovery Time Objective |
| RPO | Recovery Point Objective |
| Failover | Switch traffic to DR environment |
| Failback | Return traffic to Primary environment |

---

# Recovery Time Objective (RTO)

RTO is the **maximum acceptable downtime** after a disaster.

Example

```
Server Down

↓

Business Can Wait

30 Minutes
```

RTO = **30 Minutes**

Lower RTO means faster recovery.

---

# Recovery Point Objective (RPO)

RPO is the **maximum acceptable amount of data loss**.

Example

```
Backup

10:00 AM

↓

Crash

10:15 AM
```

If backups run every 15 minutes,

Maximum Data Loss = **15 Minutes**

Therefore,

```
RPO = 15 Minutes
```

---

# Disaster Recovery Workflow

```text
Production Environment

↓

Disaster

↓

Recovery Strategy

↓

Restore Services

↓

Users Continue Working
```

---

# Strategy 1 – Backup & Restore

Architecture

```text
Production

↓

Backup

↓

S3 / Snapshot

↓

Disaster

↓

Restore

↓

New Infrastructure
```

Recovery Time

High

Cost

Low

Best For

- Development
- Testing
- Small Businesses

---

# Strategy 2 – Pilot Light

Only critical infrastructure keeps running.

Example

```text
Production

↓

Database Running

↓

Application Servers OFF

↓

Disaster

↓

Launch Remaining Servers
```

Recovery Time

Medium

Cost

Low-Medium

Best For

Medium-sized applications.

---

# Strategy 3 – Warm Standby

A smaller but fully functional environment runs continuously.

Architecture

```text
Primary Region

↓

Full Production

──────────────

DR Region

↓

Small Environment

↓

Scale Up During Disaster
```

Recovery Time

Low

Cost

Medium

Advantages

- Faster recovery
- Easier testing
- Better availability

---

# Strategy 4 – Hot Standby (Multi-Site)

Both environments remain active.

Architecture

```text
Users

↓

Load Balancer

↓

Primary Region

↓

Secondary Region

(Both Running)
```

Traffic automatically shifts if one region fails.

Recovery Time

Very Low

Cost

High

Best For

- Banking
- Healthcare
- E-commerce
- Payment Systems

---

# Multi-Region Disaster Recovery

Example

```text
Mumbai Region

↓

Production

──────────────

Hyderabad Region

↓

Disaster Recovery
```

If Mumbai becomes unavailable,

traffic is redirected to Hyderabad.

Common AWS Services Used

- Route 53
- Elastic Load Balancer
- Auto Scaling
- EC2
- EBS
- RDS
- S3 Cross-Region Replication

---

# DR Strategy Comparison

| Strategy | Cost | Recovery Time | Complexity |
|----------|------|---------------|------------|
| Backup & Restore | Low | High | Low |
| Pilot Light | Low-Medium | Medium | Medium |
| Warm Standby | Medium | Low | Medium |
| Hot Standby | High | Very Low | High |

---

# Production Scenario 1

## Application Server Failure

Issue

```
EC2 Crash
```

Solution

Launch replacement from the latest AMI.

Attach restored EBS volume if required.

Recovery completes in minutes.

---

# Production Scenario 2

## Region Failure

Issue

```
Primary Region Down
```

Solution

- Route 53 Failover
- DR Region becomes Active
- Applications continue serving users

---

# Production Scenario 3

## Ransomware Attack

Actions

- Isolate affected server
- Restore clean EBS Snapshot
- Launch new EC2 using Golden AMI
- Validate application
- Redirect users

---

# Production Scenario 4

## Database Corruption

Solution

- Restore database from backup
- Restore application server if required
- Verify application functionality
- Resume production traffic

---

# Best Practices

✅ Define RTO and RPO for every application.

✅ Test Disaster Recovery regularly.

✅ Keep backups in another Region.

✅ Automate backup schedules.

✅ Maintain updated Golden AMIs.

✅ Encrypt backups and snapshots.

✅ Document the DR process.

✅ Perform DR drills periodically.

---

# Common Mistakes

❌ Never testing the recovery process.

❌ Keeping backups only in one Region.

❌ Outdated AMIs.

❌ No recovery documentation.

❌ No ownership during DR events.

---

# Quick Revision

```text
Disaster

↓

Choose DR Strategy

↓

Recover Infrastructure

↓

Restore Data

↓

Business Continues
```

---

```text
Backup & Restore

↓

Pilot Light

↓

Warm Standby

↓

Hot Standby
```

---

# Interview Questions

## What is Disaster Recovery?

Disaster Recovery is the process of restoring IT services and data after a major failure while minimizing downtime and data loss.

---

## What is RTO?

Recovery Time Objective is the maximum acceptable time to restore a service after a disaster.

---

## What is RPO?

Recovery Point Objective is the maximum acceptable amount of data that can be lost.

---

## Difference between RTO and RPO?

| RTO | RPO |
|------|------|
| Downtime | Data Loss |
| Time to recover | Time between last good backup and failure |

---

## Which DR strategy has the lowest cost?

Backup & Restore.

---

## Which DR strategy provides the fastest recovery?

Hot Standby (Multi-Site).

---

## Why is Warm Standby preferred by many organizations?

It offers a good balance between recovery time and infrastructure cost.

---

## Which AWS services are commonly used in Disaster Recovery?

- EC2
- EBS
- AMI
- AWS Backup
- Route 53
- Elastic Load Balancer
- Auto Scaling
- Amazon RDS
- Amazon S3

---

# 🎯 Key Takeaways

- DR minimizes downtime and data loss.
- RTO measures recovery time.
- RPO measures acceptable data loss.
- Backup & Restore is cheapest.
- Pilot Light keeps only critical components running.
- Warm Standby keeps a scaled-down environment running.
- Hot Standby keeps fully active environments in multiple locations.
- Regular DR testing is as important as taking backups.

---
