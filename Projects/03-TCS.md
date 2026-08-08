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
