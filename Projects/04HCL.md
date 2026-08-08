<h1 align="center"><span style="color:red">🚀 HCL Interview Questions</span></h1>

> **Status:** ✅ Completed  
> **Role:** AWS Linux Support Engineer

---

# 🐧 Linux Filesystem

## ❓ How many ways can you create a filesystem in Linux?

Linux supports multiple filesystem types, but commonly we use **ext4** and **XFS**.

We can create them using the `mkfs` command.

For ext4:

```bash
mkfs.ext4 /dev/xvdf
```

For XFS:

```bash
mkfs.xfs /dev/xvdf
```

---

# 🔄 Auto Scaling Group Maintenance

## ❓ How do you put an Auto Scaling Group in maintenance?

If we need to perform maintenance on an Auto Scaling Group, we can suspend the required Auto Scaling processes so that ASG does not automatically launch or terminate instances during maintenance.

After completing the maintenance, we resume the suspended processes.

If the maintenance is for replacing instances with a new Launch Template version, then we can use **Instance Refresh with launch-before-terminate** to minimize downtime.

---

# ⚖️ Load Balancer DNS

## ❓ How do you check the IP address behind a Load Balancer DNS/A record?

We have multiple options to check the IP addresses behind a Load Balancer DNS name.

First, I will use `nslookup` with the Load Balancer DNS name:

```bash
nslookup my-alb-123.ap-south-1.elb.amazonaws.com
```

We can also use:

```bash
dig my-alb-123.ap-south-1.elb.amazonaws.com
```

It will resolve the Load Balancer DNS name and show the current IP addresses.

---

# 📧 EC2 Email Notification

## ❓ I want an email notification if my EC2 instance restarts or powers off. How will you configure it?

In this case, I will create an **Amazon EventBridge Rule** to monitor the EC2 instance state change.

If the instance goes into **Stopped** or **Terminated** state, the EventBridge Rule will trigger an **SNS Topic**, and SNS will send an email notification to the subscribed users.

**Flow:**

```text
EC2 State Change → EventBridge Rule → SNS Topic → Email
```

---

# 🪣 Move Data from EC2 to S3

## ❓ How many ways can you move data from EC2 to S3?

There are multiple ways to move data from EC2 to S3.

We can use:

- AWS CLI
- AWS SDK
- Tools/Scripts based on the requirement

Mostly, I use **AWS CLI with an IAM Role attached to the EC2 instance**, so we don't need to hardcode Access Key and Secret Key.

Example:

```bash
aws s3 cp /data/file.txt s3://my-bucket/
```

---

# 🌐 Route 53 Routing Policies

## ❓ What is the difference between Simple Routing Policy and Weighted Routing Policy in Route 53?

**Simple Routing Policy** is used for normal routing when we don't need any special traffic distribution.

For example, we can route our domain to one application endpoint.

```text
example.com → ALB
```

**Weighted Routing Policy** is used when we want to distribute traffic between multiple resources based on weight.

For example:

```text
50% Traffic → Application A
50% Traffic → Application B
```

---

# 🔐 AWS Security

## ❓ For security, how many AWS services have you worked with / which AWS security services do you know?

For security, I have worked mainly with:

- IAM
- Security Groups
- NACL
- MFA
- SCP
- CloudTrail

We use **IAM** for access control, **Security Groups and NACL** for network security, **MFA** for additional authentication, **SCP** for organization-level permission control, and **CloudTrail** for auditing AWS activities.

---

# 🪣 S3 Private Access

## ❓ Does an S3 bucket need public access if we want to move data from EC2 to S3?

No, S3 bucket does not need to be public.

We can create an **IAM Role** with the required S3 permissions and attach that role to the EC2 instance.

Then EC2 can securely upload or download data from the S3 bucket without making the bucket public and without using Access Key and Secret Key.

---

# 🔑 S3 Read and Write Permission

## ❓ If you have only Read permission on an S3 bucket, can you download and upload data?

If we have only read permission on the S3 bucket, then we can download the objects but we cannot upload any object.

To upload data to S3, we need write permission like:

```text
s3:PutObject
```

For downloading objects:

```text
s3:GetObject
```

---

# 🛡️ Permission on a Single S3 Bucket

## ❓ How will you provide full permission on only one specific S3 bucket?

If I want to provide full access to only one S3 bucket, I will create an **IAM Policy** and specify only that bucket ARN in the `Resource` section.

Then I will attach that policy to the required user, group, or role.

This will provide access only to that particular bucket, not to all S3 buckets.

Example resources:

```json
"Resource": [
  "arn:aws:s3:::my-bucket",
  "arn:aws:s3:::my-bucket/*"
]
```

---

# 📈 Auto Scaling Group Capacity

## ❓ When an Auto Scaling Group launches, will it launch the Min, Desired, or Max number of instances?

When an Auto Scaling Group is created, it launches instances according to the **Desired Capacity**.

After that, based on the scaling policy and workload, ASG can **scale out** or **scale in**, but it maintains the capacity between the **Minimum** and **Maximum** limits.

Example:

```text
Minimum Capacity = 2
Desired Capacity = 3
Maximum Capacity = 5

Initial Launch = 3 EC2 Instances
```
