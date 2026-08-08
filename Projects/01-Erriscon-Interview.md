<h1 align="center"><span style="color:red">🚀 Erriscon Interview Questions</span></h1>

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



---




<h1 align="center"><span style="color:red">🚀 TCS Interview Questions</span></h1>

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

---



