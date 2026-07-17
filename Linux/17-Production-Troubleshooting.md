# 🚨 Linux Production Troubleshooting

Production troubleshooting is one of the most important responsibilities of a Linux Administrator and AWS Support Engineer.

The objective is not just to restart a service but to identify the **Root Cause**, restore the service safely, validate the fix, and prevent the issue from happening again.

---

# 🎯 Standard Troubleshooting Approach

Always follow this order:

1. Understand the issue.
2. Verify the impact.
3. Check logs.
4. Identify the root cause.
5. Fix the issue.
6. Validate the fix.
7. Perform RCA (Root Cause Analysis).

---

# 🚀 Scenario 1: Server is Not Reachable

## Interview Answer

**Step 1 – Verify the Issue**

First, I will verify whether the issue is affecting only me or all users.

---

**Step 2 – Check Network Connectivity**

```bash
ping <server_ip>
```

If ping fails, I'll verify:

```bash
ip a
ip route
```

---

**Step 3 – If the Server is on AWS**

I will check:

- EC2 Instance State (Running)
- EC2 Status Checks (2/2)
- Security Group
- Network ACL
- Route Table
- Internet Gateway / NAT Gateway
- Elastic IP (if used)

---

**Step 4 – Check SSH Service**

```bash
systemctl status sshd
ss -tunlp | grep 22
```

---

**Step 5 – Check Logs**

```bash
journalctl -u sshd
tail -f /var/log/secure
```

Ubuntu

```bash
tail -f /var/log/auth.log
```

---

**Step 6 – Check Recent Changes**

If everything looks healthy, I'll verify whether anyone recently changed:

- Firewall Rules
- SSH Configuration
- Security Group
- Network Configuration
- OS Patch
- Deployment

---

**Step 7 – Resolution**

After identifying the issue, I'll restore the service, verify SSH connectivity, inform stakeholders, and perform RCA.

---

# 🚀 Scenario 2: Website is Down

## Interview Answer

### Step 1

First, I'll verify whether the issue is affecting all users.

---

### Step 2

Check whether the server is reachable.

```bash
ping <server_ip>
```

---

### Step 3

Check whether the web service is running.

```bash
systemctl status nginx
```

or

```bash
systemctl status httpd
```

---

### Step 4

Verify listening ports.

```bash
ss -tunlp
```

---

### Step 5

Test the application locally.

```bash
curl http://localhost
```

---

### Step 6

Check logs.

```bash
journalctl -u nginx
tail -f /var/log/nginx/error.log
```

---

### Step 7 (AWS)

If hosted on AWS, I'll verify:

- EC2 Health
- ALB Status
- Target Group Health
- Security Group
- Network ACL
- Route Table
- Route53 (if applicable)

---

### Step 8

If infrastructure looks healthy, I'll check:

- Recent deployment
- Configuration changes
- Application changes
- SSL Certificate expiry

---

### Step 9

Fix the issue, validate the website, monitor logs, and perform RCA.

---

# 🚀 Scenario 3: High CPU Usage

## Interview Answer

First, I'll verify CPU utilization.

```bash
top
```

Then I'll identify the process consuming CPU.

```bash
ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu | head
```

Then I'll check:

- Application logs
- Recent deployment
- Recent cron jobs

If the application is hosted on AWS, I'll also verify:

- CloudWatch CPU Metrics
- Auto Scaling Events
- Recent deployments

If required, I'll restart the application only after approval.

Finally, I'll validate CPU utilization and perform RCA.

---

# 🚀 Scenario 4: High Memory Usage

## Interview Answer

First, I'll verify memory utilization.

```bash
free -h
top
```

Then I'll identify the process consuming memory.

```bash
ps -eo pid,user,%mem,%cpu,comm --sort=-%mem | head
```

Next, I'll check:

- Swap usage
- OOM Killer logs
- Memory leaks
- Recent deployments

```bash
dmesg | grep -i oom
```

If hosted on AWS, I'll verify CloudWatch Memory metrics (if configured).

After resolving the issue, I'll monitor memory usage and perform RCA.

---

# 🚀 Scenario 5: Disk Full

## Interview Answer

First, I'll check disk usage.

```bash
df -h
```

Then I'll identify large directories.

```bash
du -sh /*
```

Next, I'll verify:

- Log files
- Backup files
- Temporary files

```bash
find /var/log -type f -size +100M
```

If hosted on AWS, I'll also verify whether EBS volume expansion is required.

After cleanup, I'll validate disk usage and update RCA.

---

# 🚀 Scenario 6: Service Failed

## Interview Answer

First, I'll verify service status.

```bash
systemctl status service_name
```

Then I'll check logs.

```bash
journalctl -u service_name
```

Next I'll verify:

- Configuration
- Dependencies
- Port Availability
- Permissions

If everything is correct, I'll check recent configuration changes.

Finally, restart the service (if required), validate functionality, and document RCA.

---

# 🚀 Scenario 7: DNS Resolution Failed

## Interview Answer

First I'll verify whether internet connectivity is working.

```bash
ping 8.8.8.8
```

Then I'll check DNS.

```bash
nslookup google.com
dig google.com
cat /etc/resolv.conf
```

If hosted on AWS, I'll verify:

- Route53
- VPC DNS Settings
- Security Group
- Network ACL

Then I'll validate DNS resolution.

---

# 🚀 Scenario 8: Cron Job Failed

## Interview Answer

First I'll verify cron configuration.

```bash
crontab -l
```

Then I'll check whether cron service is running.

```bash
systemctl status crond
```

Then I'll verify:

- Script path
- Execute permission
- Cron logs

```bash
tail -f /var/log/cron
```

Finally, I'll execute the script manually to verify whether the issue is with the script or cron scheduler.

---

# 💡 Golden Interview Tip

Always answer production scenarios in this order:

1. Understand the issue
2. Verify the issue
3. Check Linux
4. Check Logs
5. If hosted on AWS, verify AWS components
6. Check recent deployments/configuration changes
7. Resolve the issue
8. Validate the service
9. Perform RCA
