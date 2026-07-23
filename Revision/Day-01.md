# 📅 Interview Revision - Day 01

**Date:** 23 July 2026

---


# 🗣️ HR Questions

---

## Question 1

### Tell me about yourself.

### Answer

Good morning.

Thank you for giving me this opportunity to introduce myself.

My name is Imtiyaj Ansari. I have over 11 years of experience in IT Infrastructure. I started my career as a Desktop Support Engineer, where I worked for around six years. For the last five years, I have been working as an AWS and Linux Support Engineer.

In my current role, I am responsible for monitoring Linux servers, handling production incidents, and supporting AWS infrastructure. I work with AWS services such as EC2, IAM, VPC, S3, EBS, and CloudWatch from an operations perspective.

I also work with monitoring tools such as CloudWatch, Nagios, Grafana, and NinjaOne. My daily responsibilities include server health monitoring, Linux troubleshooting, CloudWatch alert handling, EC2 operations, patching activities, and coordinating with application, network, and cloud teams during production incidents.

Currently, I am looking for an opportunity where I can utilize my AWS and Linux experience, expand my DevOps knowledge, and contribute to the organization's success.

---

# 💼 Technical Questions

---

## Question 2

### Explain your day-to-day responsibilities.

### Answer

- My day usually starts by checking monitoring dashboards such as CloudWatch, Nagios, and Grafana to make sure all production servers are healthy.

- If I receive any alerts related to CPU, memory, disk utilization, or service availability, I log in to the affected Linux server through SSH and perform the initial troubleshooting.

- I check server resource utilization, verify running services, review logs, and restart services if required after confirmation from the application team.

- On the AWS side, I work with EC2 operations such as starting and stopping instances, attaching or extending EBS volumes, monitoring CloudWatch alarms, and performing basic IAM-related tasks whenever required.

- I also schedule patching activities through NinjaOne, enable maintenance mode before patching, verify server health after reboot, update Jira tickets, and coordinate with different teams until the issue is resolved.

- At the end of my shift, I prepare the handover and make sure there are no pending critical alerts.

---

## Question 3

### CloudWatch generated High CPU Alert. What will you do?

### Answer

- First, I will connect to the affected EC2 instance using SSH.

- Then I will check CPU utilization using top or htop and identify the process consuming high CPU.

- Next, I will verify whether it is a scheduled activity by checking the cron jobs.

- If it is an expected task such as backup or log rotation, I will monitor it until it completes.

- If it is not expected, I will check the application logs and system logs to identify the root cause.

- If required, I will coordinate with the application team and, after getting approval, restart the service.

- If the server is under heavy traffic and Auto Scaling is configured, I will verify whether a new instance has been launched.

- Finally, I will update the incident ticket and prepare the RCA.

---

## Question 4

### Java process is consuming 98% CPU.

Will you kill the process?

### Answer

No.

I will never kill any production process without approval because it may impact the application and end users.

First I will identify the reason behind high CPU utilization, collect logs, and coordinate with the application owner.

Only after approval will I restart or stop the process according to the organization's incident management process.

---

## Question 5

### Application team says not to restart the service.

Users are still facing issues.

What will you do?

### Answer

- If Auto Scaling is configured, I will first verify whether a new EC2 instance has been launched automatically.

- If Auto Scaling is not working, I will immediately inform the cloud team.

- At the same time, I will continue monitoring the server, collect all required logs, and keep the application team updated.

- I will also update the incident ticket and ensure all stakeholders are informed until the issue is resolved.

---

## Question 6

### Tell me one critical production incident.

### Answer

During my night shift, we suddenly received alerts that more than 100 physical servers were showing as Host Down.

I verified the issue by checking router connectivity and attempting SSH access to multiple servers.

Since both router ping and SSH failed, I suspected a Data Center level issue.

I immediately created a Microsoft Teams Incident Bridge, informed the client, and shared all troubleshooting details.

Then I contacted the Equinix Data Center team.

After investigation, they confirmed a PDU failure.

Once the PDU issue was resolved, all servers gradually became reachable.

Finally, we verified server health, updated the incident ticket, and prepared the RCA.

---

## Question 7

### Tell me one AWS production incident.

### Answer

CloudWatch generated a high disk utilization alert for an EC2 instance.

I connected to the server through SSH and checked disk utilization.

```bash
df -h
```

The `/var` filesystem was almost full because application logs had grown continuously.

According to the application team's SOP:

- Archive logs under `/var/log/msz`.
- Remove logs older than one month.
- If space is still insufficient, extend the EBS volume.

I first archived the logs.

Then removed old logs.

After verification, disk utilization was still high.

I increased the EBS volume from AWS Console.

Then I extended the filesystem.

Finally I verified the application, monitored CloudWatch, updated Jira, and prepared the RCA.

---

## Question 8

### Explain your patching activity.

### Answer

We use NinjaOne for patch management.

My responsibilities include:

- Scheduling patching.
- Enabling maintenance mode.
- Monitoring patch installation.
- Verifying server health after reboot.
- Checking application services.
- Updating maintenance tickets.

---

## Question 9

### Do you take EBS Snapshot before patching?

### Answer

Yes. For production EC2 instances, we used to take an EBS snapshot before patching so that we could recover the server if required.

---

## Question 10

### What if patching fails?

### Answer

First I will identify whether the failure occurred during download, installation, or reboot.

I will review NinjaOne logs and Linux logs.

If the server is accessible, I will verify all application services.

If the issue cannot be resolved immediately, I will escalate it to the Patch Management Team and Application Team.

I will continue monitoring until the issue is resolved and update the incident ticket.

---

# 🛠️ Important Linux Commands

```bash
top
htop
ps -ef
df -h
free -h
uptime
systemctl status
systemctl restart
journalctl
tail -100
crontab -l
lsblk
growpart
xfs_growfs
resize2fs
```

---

# 💡 Production Tips

- Never kill a production process without approval.
- Always verify logs before restarting services.
- Follow the organization's SOP.
- Update Jira continuously during incidents.
- Prepare RCA after issue resolution.
- Verify application health after patching.
- Never claim experience that you don't have.
- Explain only real production incidents.

---



---

# ⭐ Interview Tips

- Always identify whether the issue affects a single user or all users.
- Follow a structured troubleshooting approach.
- Never restart a production service without approval.
- Mention Linux commands wherever applicable.
- Don't jump directly to restarting services.
- Always verify logs before taking action.
- Prepare RCA after issue resolution.

---
# 🎤 Mock Interview - Day 01 (Round 02)


# Question 1

## EC2 instance is Running, but users are unable to access the application.

### Best Answer

First, I will verify whether the issue is affecting a single user or all users.

Then I will verify that the EC2 instance is in the **Running** state and both **System Status Check** and **Instance Status Check** are passing.

Next, I will connect to the EC2 instance using SSH.

After logging in, I will verify whether the application service is running.

```bash
systemctl status <service-name>
```

Then I will verify whether the application port is listening.

```bash
ss -tulnp
```

Next, I will check CPU, Memory, and Disk utilization.

```bash
top
free -h
df -h
```

Then I will review the application logs and system logs.

```bash
journalctl
tail -100 /var/log/messages
```

If required, I will verify the Security Group, Network ACL, Route Table, and Internet Gateway configuration.

Finally, after resolving the issue, I will verify the application, update the incident ticket, and prepare the RCA.

--

# Question 2

## Users are unable to open the website.

### Scenario

- EC2 Running ✅
- SSH Working ✅
- Application Service Running ✅
- Website Still Not Opening ❌

### Best Answer

First, I will verify whether the issue is affecting a single user or all users.

Then I will verify whether the application is accessible directly from the EC2 instance.

Next, I will check the Application Load Balancer.

After that, I will verify the Target Group Health Status.

If the Target Group shows **Unhealthy**, I will verify:

- Health Check Path
- Health Check Port
- Application Response
- Security Group between ALB and EC2

Then I will verify whether the application is listening on the configured port.

```bash
ss -tulnp
```

Next, I will review the application logs.

If required, I will restart the application after approval.

Finally, I will verify that the Target Group becomes Healthy and confirm that the website is accessible.

---

# Question 3

## SSH is not working on the EC2 instance.

### Best Answer

First, I will verify that the EC2 instance is in the Running state.

Then I will verify that both System Status Check and Instance Status Check are passing.

Next, I will verify:

- Security Group
- Network ACL
- Route Table
- Internet Gateway
- Public IP
- Correct Username
- Correct Private Key

If SSH is still not working, I will try **EC2 Instance Connect**, **AWS Systems Manager Session Manager**, or **EC2 Serial Console** if available.

After accessing the instance, I will verify the SSH service.

```bash
systemctl status sshd
```

Then I will review SSH logs.

```bash
journalctl -u sshd
```

Next, I will verify the SSH configuration.

```bash
cat /etc/ssh/sshd_config
```

If required, I will restart the SSH service.

```bash
systemctl restart sshd
```

Finally, I will verify SSH connectivity, update the incident ticket, and prepare the RCA.

---

# Important Learning

Never say:

"I will check systemctl status sshd"

without explaining **how you will access the server** if SSH itself is not working.

Always mention:

- EC2 Instance Connect
- AWS Systems Manager
- EC2 Serial Console

---

# Question 4

## Explain the difference between System Status Check and Instance Status Check.

| System Status Check | Instance Status Check |
|--------------------|----------------------|
| Checks AWS Physical Infrastructure | Checks EC2 Operating System |
| Hardware Issues | OS Issues |
| Network Issues | Kernel Panic |
| Power Issues | Disk Full |
| AWS Responsibility | Customer Responsibility |

---

## Easy Interview Answer

### System Status Check

Checks the health of the underlying AWS infrastructure such as hardware, power, and network.

### Instance Status Check

Checks the health of the operating system running inside the EC2 instance such as boot process, filesystem, kernel, memory, and operating system.

---

# Question 5

## What is the difference between Application Issue and Website Issue?

| Application Issue | Website Issue |
|-------------------|---------------|
| Starts from EC2 | Starts from User Request |
| Service | DNS |
| Port | Load Balancer |
| Logs | Target Group |
| CPU | Health Check |
| Memory | EC2 |
| Disk | Application |

----

# Question 6

## What does 2/2 Status Check mean?

### Answer

2/2 means both health checks are passing.

- System Status Check
- Instance Status Check

---

# Question 7

## Why do some EC2 instances show 3/3 instead of 2/2?

### Answer

Some newer AWS Console versions display an additional health indicator or reachability information.

However, the two primary EC2 health checks remain:

- System Status Check
- Instance Status Check

For interviews, it is best to say:

"I will verify that all EC2 health checks are passing."

---

# Important Linux Commands

```bash
systemctl status sshd

systemctl restart sshd

journalctl -u sshd

cat /etc/ssh/sshd_config

ss -tulnp

top

free -h

df -h

tail -100 /var/log/messages
```

---

# ⭐ Interview Tips

- Always identify whether the issue affects a single user or all users.
- Follow a structured troubleshooting approach.
- Never restart a production service without approval.
- Mention Linux commands wherever applicable.
- Don't jump directly to restarting services.
- Always verify logs before taking action.
- Prepare RCA after issue resolution.

---


# 🚀 AWS Interview Revision - Round 03



# 1️⃣ Disk Utilization (95%)

## Interview Question

**Production server disk utilization reached 95%. What will you do?**

### Interview Answer

> **First, I will check the current disk utilization using `df -h`.**

Then, I will identify which directory or files are consuming the disk space using `du -sh` or `find`.

Then, I will check the log files under `/var/log`.

As per our company SOP, I will delete or archive old logs if they are approved for cleanup.

If the disk utilization is still high, I will extend the EBS volume.

After extending the volume, I will resize the filesystem using `resize2fs` (ext4) or `xfs_growfs` (XFS).

Finally, I will verify the application is working properly and prepare the RCA.

---

# 2️⃣ IAM Access Denied

## Interview Question

**Yesterday the user was accessing EC2 successfully. Today he is getting "Access Denied".**

### Interview Answer

> **First, I will check the IAM User permissions.**

Then, I will verify the IAM Group permissions.

Then, I will check whether the user has been moved to another group.

Then, I will verify if any Explicit Deny policy has been applied.

If AWS Organizations is being used, I will also verify the Service Control Policy (SCP).

Finally, I will check recent IAM changes and restore the required permissions if necessary.

---

# 3️⃣ EBS Volume Accidentally Detached

## Interview Question

**A production EBS volume was accidentally detached.**

### Interview Answer

> **First, I will identify which EC2 instance the volume belongs to.**

Then, I will attach the same EBS volume back to the EC2 instance.

Then, I will verify that the operating system has detected the volume using `lsblk`.

If required, I will mount the volume.

Then, I will verify that the application is working properly.

If the volume has been deleted, I will create a new EBS volume from the latest snapshot and attach it to the instance.

Finally, I will verify the application and prepare the RCA.

> **Note:** Filesystem resize is required only after increasing the volume size.

---

# 4️⃣ EC2 Unexpected Reboot

## Interview Question

**The EC2 instance rebooted unexpectedly.**

### Interview Answer

> **First, I will check the reboot history using `last reboot`.**

Then, I will review the system logs using `journalctl` and `/var/log/messages`.

Then, I will verify whether any cron job triggered the reboot.

Then, I will check the application status to ensure the services are running properly.

Finally, I will identify the root cause and prepare the RCA.

---

# 5️⃣ Website Down (Service Failed)

## Interview Question

**The website is down and the application service is in a failed state.**

### Interview Answer

> **First, I will not restart the service immediately.**

First, I will check the service logs using `journalctl -u <service-name>`.

Then, I will identify the root cause of the failure.

After fixing the issue, I will restart the service.

Then, I will verify that the service is running successfully.

Finally, I will verify that the website is accessible and prepare the RCA.

---

# 6️⃣ Application Slow

## Interview Question

**The application is slow, but CPU, Memory, and Disk utilization are normal.**

### Interview Answer

> **First, I will check the application logs.**

Then, I will verify the application service status.

Then, I will check the database connectivity.

Then, I will verify any external APIs or dependencies.

Then, I will check whether any recent deployment or configuration change has been made.

Finally, if the issue is application-related, I will coordinate with the Application Team.

---

# 7️⃣ Website Slow

## Interview Question

**The website is slow.**

### Interview Answer

> **First, I will identify whether the issue is affecting a single user or all users.**

If the issue is affecting only one user, I will check the browser, cache, local network, and ISP.

If the issue is affecting all users, I will check CPU utilization.

Then, I will check Memory utilization.

Then, I will check Disk utilization.

Then, I will verify that the application service is running.

Then, I will review the application logs.

If the infrastructure is healthy but the issue still exists, I will coordinate with the Application Team.

---
