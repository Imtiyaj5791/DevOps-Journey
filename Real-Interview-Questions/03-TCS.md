<h1 align="center"><span style="color:red">🚀 TCS Interview Questions</span></h1>

> **Status:** ✅ Completed  
> **Role:** AWS Linux Support Engineer

---

# 🌐 Application Troubleshooting

## ❓ Some users are able to access the application, but some users are not able to access it. How will you troubleshoot?

First, I will check whether the affected users are from the same office/network or from different locations. Then I will verify whether they are properly connected to the VPN if VPN is required.

After that, I will check the **Security Group** and **NACL** to make sure the affected user's network or IP range is not blocked. Then I will check DNS resolution using `nslookup` or `dig` to verify whether the application hostname is resolving properly.

If the application is behind an **ALB**, I will also check the **Target Group health** and ALB-related configuration.

Finally, I will ask the affected users to try from another browser or incognito mode to rule out browser or cache-related issues.

---

# 💾 EBS – gp2 vs gp3

## ❓ Why did you change/migrate gp2 to gp3?

We migrated from gp2 to gp3 because gp3 is more flexible and cost-effective.

It provides **3000 IOPS** and **125 MB/s throughput** by default.

In gp2, performance depends on the volume size, but in gp3, we can increase **IOPS** and **throughput** independently without increasing the volume size.

---

# 🖥️ AMI

## ❓ How do you copy an AMI from one AWS Region to another Region?

To copy an AMI to another Region, first I will go to **EC2 → AMIs**, select the required AMI, then go to **Actions → Copy AMI**.

After that, I will select the destination Region and start the copy.

Once the copy is completed, I will verify the AMI in the destination Region.

---

# ⚖️ ALB vs NLB

## ❓ What is the difference between ALB and NLB?

**ALB** works at **Application Layer, Layer 7**. It supports path-based and host-based routing, so we can route traffic based on URL path, domain, or subdomain.

**NLB** works at **Network Layer, Layer 4**, and handles TCP/UDP traffic. When we require very high performance and low latency, we use NLB.

---

# 🔀 Application Load Balancer

## ❓ How does an Application Load Balancer work?

Application Load Balancer works at **Application Layer, Layer 7**.

When a user sends a request, the **Listener** receives the request on a particular port like **80 or 443**.

Based on the Listener Rules, ALB forwards the request to the **Target Group**, and the Target Group sends the request to a **healthy EC2 instance**.

Then the user can access the application.

**Traffic Flow:**

```text
User → ALB → Listener → Listener Rule → Target Group → Healthy EC2
```

---

# 💽 Increase EBS Volume Size

## ❓ How do you increase EBS volume size?

First, I will go to **EC2 → EBS Volumes**, select the required volume, choose **Actions → Modify Volume**, and increase the size as per the requirement.

After modification is completed, I will log in to the server and verify the new size using:

```bash
lsblk
```

Then I will extend the partition using:

```bash
growpart
```

For an **ext4** filesystem, I will use:

```bash
resize2fs
```

For an **XFS** filesystem, I will use:

```bash
xfs_growfs
```

Finally, I will verify the increased filesystem size using:

```bash
df -h
```

---

# 📊 CloudWatch vs CloudTrail

## ❓ What is the difference between CloudWatch and CloudTrail?

**CloudWatch** is a monitoring service. We use it to monitor AWS resources using metrics like CPU utilization and network traffic.

We can create dashboards and alarms. For memory and disk utilization, we can use the **CloudWatch Agent**.

**CloudTrail** is used for auditing and security. It records AWS API activities and tells us **who performed an action, what action was performed, and when it happened**.

For example, if someone terminates an EC2 instance, we can check in CloudTrail who terminated it and when.

We can also deliver CloudTrail logs to an **S3 bucket** for long-term storage.

---

# 📁 EFS vs EBS

## ❓ What is the difference between EFS and EBS?

**EBS** is block-level storage, while **EFS** is a network file system.

Normally, EBS is attached to a single EC2 instance at a time, while EFS can be mounted on multiple EC2 instances at the same time.

In EBS, we define the volume size, but EFS automatically grows and shrinks based on the data stored.

EBS is mainly used for things like OS and application volumes, while EFS is useful when multiple servers need to access the same files.

---

# 📂 EFS Configuration

## ❓ Have you configured EFS? If yes, how do you configure and mount EFS on EC2?

Yes, I have configured EFS in my **self lab, not in production**.

First, I will create a **Security Group** and allow **NFS port 2049** from the EC2 Security Group.

Then I will go to the EFS console and create the EFS in the required VPC and create **Mount Targets** in the required Availability Zones.

After that, I will log in to the EC2 instance, install the required EFS/NFS client, create a mount point, and mount the EFS.

Finally, I will verify the mount using:

```bash
df -h
```

---

# 🔐 IAM Policy

## ❓ Which type of IAM policy do you use, and is it user-based?

I have worked with different IAM policies like **EC2 start/stop permission** and **S3 bucket access**.

Normally, for users we prefer **group-based permission** instead of attaching policies individually to each user.

We create a group as per the required access, attach the policy to the group, and add users to that group.

For AWS services like EC2, we use **IAM Roles** instead of access keys.

We can also use **Inline Policies** when specific permission is required for a particular user, group, or role.

---

# 🔎 CloudTrail Event History

## ❓ How do you check the latest logs/events in CloudTrail?

To check the latest activity in CloudTrail, I will go to:

**AWS Console → CloudTrail → Event History**

There I can see the latest events and check:

- **Who** performed the activity
- **What** action was performed
- **When** the activity was performed

If required, I can filter the events by:

- Event Name
- Resource Name
- Username
- Time Range


<h1 align="center"><span style="color:red">🚀 TCS 2nd Interview Questions</span></h1>

> **Status:** ✅ Completed  
> **Role:** AWS Linux Support Engineer

---

# 💽 AWS & On-Premises Volume Mounting

## ❓ How do you mount a volume in AWS and on an on-premises Linux server?

In AWS, first I will create a new **EBS volume** and attach it to the EC2 instance.

Then I will log in to the server through SSH and run:

```bash
lsblk
```

After that, I will create the filesystem using `mkfs.xfs` for XFS or `mkfs.ext4` for ext4.

```bash
mkfs.xfs /dev/xvdf
```

or

```bash
mkfs.ext4 /dev/xvdf
```

Then I will create a mount directory and mount the volume using the `mount` command.

```bash
mkdir /data
mount /dev/xvdf /data
```

Finally, for permanent mounting, I will add the entry in `/etc/fstab` and verify it using:

```bash
df -h
```

For an **on-premises Linux server**, first we add the new disk to the server.

Then I will verify the disk, create the required partition using `fdisk`, create the filesystem, create a mount directory, and mount it.

For permanent mounting, I will add the entry in `/etc/fstab`.

---

# 📂 NFS Mounting

## ❓ How do you mount an NFS share on a Linux server, and how does an end user access it?

First, I will install the **NFS client package** on the Linux server.

Then I will create a mount point and mount the NFS share using the NFS server IP and exported path.

Example:

```bash
mkdir /data
mount -t nfs 10.0.1.10:/shared /data
```

After that, I will verify it using:

```bash
df -h
```

For permanent mounting, I will add the entry in `/etc/fstab`.

Once NFS is mounted, the end user can access the shared files through the mounted directory based on the **user and group permissions**.

---

# 🏗️ Terraform

## ❓ What is the difference between terraform.tfvars and locals in Terraform?

**terraform.tfvars** is used to provide values for input variables, and we can change them as required.

**Locals** are used for internal or reusable values and cannot be directly overridden during `terraform apply`.

---

# 🐳 Docker, ECS & ECR

## ❓ What is Docker, ECS, and ECR?

**Docker** is a containerization tool used to build, run, manage, and deploy applications inside lightweight containers.

**ECS** is an AWS container orchestration service used to run and manage containers.

**ECR** is an AWS container registry used to store and manage Docker images privately.

```text
Docker → Build & Run Containers
ECR    → Store Docker Images
ECS    → Run & Manage Containers
```

---

# 🐳 CMD vs ENTRYPOINT

## ❓ What is the difference between CMD and ENTRYPOINT in Docker, and where are they defined?

CMD and ENTRYPOINT both are used to run an application when the container starts.

**CMD** is a default command and we can easily override it while creating the container.

**ENTRYPOINT** is the main command and normally we don't change it.

Both are defined in the **Dockerfile**.

---

# 📈 Auto Scaling Group Capacity

## ❓ How does an Auto Scaling Group know how many instances need to run? What happens if Minimum Capacity is set to 0?

When we create an ASG, we define **Minimum, Maximum and Desired capacity**.

ASG initially launches instances based on the **Desired Capacity**.

After that, it scales in or scales out based on the scaling policy.

If Minimum is `0`, ASG can scale down to zero instances if the Desired Capacity or scaling policy allows it.

In that case, the application may become unavailable.

Example:

```text
Minimum = 0
Desired = 2
Maximum = 4

Initial EC2 Instances = 2
```

---

# 🔧 Linux Server Patching

## ❓ How do you perform patching on Linux servers?

In my organization, we use **NinjaRMM** for patching activity. The Engineering Team pushes the patches from the backend.

Before patching starts, we create a **maintenance window** in the monitoring tool and start the required development servers.

Once patching is completed, we verify the patch status. Then we stop the development servers if required and disable the maintenance window.

If patching fails, first I check the patch history and error in NinjaRMM.

Then I log in to the server and verify whether the required/latest package version is available.

I retry the patch manually through NinjaRMM.

If it still fails, I collect the error details and coordinate with the Engineering Team.

Finally, we make sure all production servers are **up and running properly**.

---
