<h1 align="center"><span style="color:red">🚀 Unknown Interview Questions</span></h1>

> **Status:** ✅ Completed  
> **Role:** AWS Linux Support Engineer

---

# ⚖️ ALB Host-Based Routing

## ❓ We have 2 domains. How will you run both on a single Load Balancer?

If we have two domains behind the same ALB, we can use **host-based routing**.

For example, if the request comes for `www.devops.com`, the ALB Listener Rule will forward the traffic to the **DevOps Target Group**.

If the request comes for `www.aws.com`, the ALB Listener Rule will forward the traffic to the **AWS Target Group**.

```text
www.devops.com → ALB → DevOps Target Group
www.aws.com    → ALB → AWS Target Group
```

---

# 🐳 Docker Image Storage

## ❓ Where do you store/save Docker images?

We mainly store Docker images in **Amazon ECR** for private repositories.

We can also use **Docker Hub** for public or private repositories.

In our AWS environment, we prefer ECR because it integrates easily with AWS services.

---

# 🪣 S3 Single Object Public Access

## ❓ How do you give public permission to only a single object in S3?

Previously, we could make a single S3 object public using **Object ACL**.

Currently, ACLs are generally disabled. If there is a requirement to make only one object public, we can use a **Bucket Policy** and specify the exact object ARN in the `Resource`.

We also need to make sure **Block Public Access** settings allow that policy.

Example:

```text
arn:aws:s3:::my-bucket/image.jpg
```

---

---

# How do you implement Load Balancing in AWS?

For a web application, I will use an Application Load Balancer. I will create a target group and register EC2 instances or an Auto Scaling Group with it. Then I will configure listeners and routing rules. ALB will perform health checks and distribute traffic only to healthy targets.

---

# How would you connect 3 VPCs in one AWS account, 1 VPC in another AWS account, and an on-premises server? Explain the architecture and how they can access an Amazon RDS instance.

I will use Transit Gateway for connecting multiple VPCs across accounts. For on-premises connectivity, I will use Site-to-Site VPN or Direct Connect. RDS will be in a private subnet and I will allow database access only from the application server Security Group.

---

# What is CloudFront? How do you configure it with a web application, and how does it work?

CloudFront is a CDN service provided by AWS. It is used for caching content at AWS Edge Locations so that end users can get faster responses from the nearest location.

For configuring CloudFront with a web application, we create an Origin. The origin can be an S3 bucket, Application Load Balancer, or EC2 server.

---

# What is an Amazon S3 bucket, and what are S3 Lifecycle Policies?

Amazon S3 bucket is a container used to store objects like files, documents, images, backups and other data. We can upload, retrieve and manage data from S3 using AWS services or APIs.

S3 Lifecycle Policy is used to automatically manage object storage by transitioning objects to different storage classes or deleting them after a defined period. It helps reduce storage cost.

---

# How would you access a private EC2 instance if the private PEM key is lost and EC2 Instance Connect is not available?

For lost PEM key recovery, we have multiple options.

We can recover access by attaching the EBS volume to a temporary instance and updating `authorized_keys`, create an AMI and launch a new instance with a new key pair, or if SSM/another access is available, generate a new SSH key and add the public key into `authorized_keys`.

---

# How do you restart the SSH service?

To restart the SSH service, I will use systemctl restart command.

On Ubuntu:

```bash
sudo systemctl restart ssh
```

On RHEL-based systems:

```bash
sudo systemctl restart sshd
```

Verify service status:

```bash
systemctl status ssh
```

or

```bash
systemctl status sshd
```

---

# Where are application installation files typically stored in Linux?

Application installation files are usually stored in `/usr/bin` or `/usr/sbin`.

For third-party applications, we commonly use `/opt`.

Configuration files are generally stored under:

```bash
/etc
```

Useful commands:

```bash
ls /usr/bin
```

```bash
ls /usr/sbin
```

```bash
ls /opt
```

---

# Which command is used to change file ownership?

To change file ownership in Linux, we use the `chown` command. It is used to change the owner and group ownership of a file or directory.

Example:

```bash
chown user file.txt
```

Change owner and group:

```bash
chown user:group file.txt
```

Verify ownership:

```bash
ls -l file.txt
```

---

# How do you grant a normal user sudo privileges?

I will add the user entry in the `/etc/sudoers` file or add the user to the sudo group.

```bash
sudo usermod -aG sudo username
```

Verify group membership:

```bash
groups username
```

View sudo group:

```bash
getent group sudo
```

---

# Explain Linux permission "774"

In Linux permission 774:

```text
Owner = 7 = Read + Write + Execute
Group = 7 = Read + Write + Execute
Others = 4 = Read Only
```

Example:

```bash
chmod 774 file_name
```

Verify permissions:

```bash
ls -l file_name
```

---

# What is the difference between chown and chmod?

`chown` is used to change the ownership of a file or directory. It changes the owner and group ownership.

Example:

```bash
chown user:group file.txt
```

`chmod` is used to change the file permissions like read, write and execute permissions.

Example:

```bash
chmod 755 file.txt
```

Verify:

```bash
ls -l file.txt
```

---

# Where can you check user activity and login history in Linux?

For checking user activity and login history in Linux, we can use commands like:

Login history:

```bash
last
```

Current logged-in users:

```bash
who
```

Active user sessions:

```bash
w
```

Authentication-related logs:

Ubuntu:

```bash
cat /var/log/auth.log
```

RHEL-based systems:

```bash
cat /var/log/secure
```

Real-time monitoring:

```bash
tail -f /var/log/auth.log
```

or

```bash
tail -f /var/log/secure
```

---

# What does the /etc directory contain?

The `/etc` directory contains system and application configuration files.

For example:

- SSH configuration
- Network configuration
- Service configuration
- User account configuration
- Application configuration files

Useful commands:

View directory:

```bash
ls /etc
```

SSH configuration:

```bash
cat /etc/ssh/sshd_config
```

Hosts file:

```bash
cat /etc/hosts
```

DNS configuration:

```bash
cat /etc/resolv.conf
```

Network configuration:

```bash
ip a
```

---
