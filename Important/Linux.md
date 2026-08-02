# Linux Administration Interview Notes

## What is Linux? What is your experience with Linux administration?

Linux is an open-source operating system that supports multitasking and multi-user functionality.

### Experience
- Managing more than **5000 Linux production servers**.
- Primary operating system: **Ubuntu 24.04**.
- Daily responsibilities:
  - Server monitoring
  - Production issue troubleshooting
  - CPU, memory, and disk utilization analysis
  - Log analysis
  - User and permission management
  - SSH troubleshooting
  - Incident coordination with multiple teams

---

## How do you check CPU, Memory, and Disk utilization in Linux?

### CPU Utilization
```bash
top
# or
htop
```

### Memory Utilization
```bash
free -h
```

### Disk Utilization
```bash
df -h
```

To identify large directories/files:

```bash
du -sh /*
du -sh /var/*
```

---

## If CPU utilization is 95%, how will you troubleshoot?

### Step 1: Check Monitoring Tool
Verify whether it is a temporary spike or a continuous issue using AWS CloudWatch.

### Step 2: Connect to Server
```bash
ssh user@server_ip
```

### Step 3: Identify High CPU Process
```bash
top
# or
htop
```

### Step 4: Analyze the Process
```bash
ps -ef | grep <process_name>
```

### Step 5: Check Scheduled Jobs
```bash
crontab -l
```

### Step 6: Coordinate with Application Team
- Verify business impact.
- Take approval before restarting services or killing processes.

### Step 7: Perform Approved Action
```bash
kill -9 <PID>
```

Or restart service:

```bash
sudo systemctl restart <service_name>
```

---

## If Memory utilization is 95%, how will you troubleshoot?

### Check CloudWatch
Identify whether memory usage is sustained or temporary.

### Verify Memory Usage
```bash
free -h
```

### Check Swap Usage
```bash
swapon --show
```

### Identify High Memory Processes
```bash
top
# or
htop
```

```bash
ps aux --sort=-%mem | head
```

### Take Action
- Monitor scheduled jobs.
- Coordinate with application owners.
- Restart application after approval if required.

---

## Disk utilization reached 100%. How will you troubleshoot?

### Check Filesystem Usage
```bash
df -h
```

### Find Large Directories
```bash
du -sh /*
```

### Find Large Files
```bash
find / -type f -size +500M 2>/dev/null
```

### Check Log Directory
```bash
du -sh /var/log/*
```

### Remove Old Logs (As Per SOP)
```bash
find /var/log -type f -mtime +60
```

### Clean Temporary Files
```bash
du -sh /tmp/*
```

### Extend AWS EBS Volume
Verify new disk size:

```bash
lsblk
```

For Ext4:

```bash
resize2fs /dev/<device>
```

For XFS:

```bash
xfs_growfs <mount_point>
```

---

## SSH is not working. How will you troubleshoot?

### Check Connectivity
```bash
ping <server_ip>
```

### AWS Validation
- EC2 System Status Checks
- Instance Status Checks
- Security Groups
- NACL Rules
- Route Tables
- Internet Gateway

### Verify SSH Port
```bash
ss -tulnp | grep :22
```

### Check SSH Service
```bash
sudo systemctl status ssh
# or
sudo systemctl status sshd
```

### Review SSH Logs
```bash
journalctl -u ssh
# or
journalctl -u sshd
```

---

## How do you create a user in Linux and manage permissions?

### Create User
```bash
sudo useradd username
sudo passwd username
```

### Force Password Change on First Login
```bash
sudo chage -d 0 username
```

### Add User to Existing Group
```bash
sudo usermod -aG groupname username
```

### Change Permissions
```bash
chmod 755 file_name
```

### Change Ownership
```bash
chown user:group file_name
```

---

## What are file permissions in Linux? Explain chmod 755.

Linux permissions are based on:

- Read (r) = 4
- Write (w) = 2
- Execute (x) = 1

### chmod 755

```text
Owner = 7 (rwx)
Group = 5 (r-x)
Others = 5 (r-x)
```

Command:

```bash
chmod 755 file_name
```

---

## Difference between chmod and chown

### chmod
Changes file or directory permissions.

```bash
chmod 755 file_name
```

### chown
Changes ownership.

```bash
chown user:group file_name
```

---

## What is a cron job and how do you schedule one?

Cron jobs automate tasks at scheduled times.

### Edit Crontab
```bash
crontab -e
```

### Example
Run backup script every day at 2 AM:

```bash
0 2 * * * /opt/scripts/backup.sh
```

### View Existing Cron Jobs
```bash
crontab -l
```

---

## What is log analysis in Linux?

Log analysis is the process of reviewing system, application, and security logs to identify root causes.

### Authentication Logs
```bash
cat /var/log/auth.log
```

### Using Journalctl
```bash
journalctl -xe
journalctl -u ssh
```

### Monitor Logs in Real Time
```bash
tail -f /var/log/syslog
```

---

## How do you perform Linux patching in a production environment?

### Current Process
- Using NinjaRMM for patching.
- Engineering team pushes patches.
- Operations team coordinates and monitors.

### Validate Available Updates
```bash
sudo apt update
sudo apt list --upgradable
```

### Manual Upgrade (If Approved)
```bash
sudo apt upgrade -y
```

### Post Checks
```bash
uptime
systemctl --failed
```

---

## Do you have experience with Bash scripting?

Yes. I have worked with Bash scripting for system health monitoring and automation.

### Example Commands Used in Scripts

```bash
free -h
```

```bash
df -h
```

```bash
top -bn1
```

Use cases:
- System health monitoring
- Alerting
- Log cleanup
- Task automation

---

## Server is slow. How will you troubleshoot?

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

### Check Top Processes
```bash
ps aux --sort=-%cpu | head
ps aux --sort=-%mem | head
```

### Review Logs
```bash
journalctl -xe
```

### Application Verification
```bash
systemctl status <service_name>
```

---

## Application is down but server is up. What will you check?

### Verify Service Status
```bash
systemctl status <service_name>
```

### Check Listening Ports
```bash
ss -tulnp
```

### Review Application Logs
```bash
tail -100f /path/to/application.log
```

### Restart Service (After Approval)
```bash
sudo systemctl restart <service_name>
```

---

## Explain the Linux Booting Process

1. **POST (Power-On Self-Test)** verifies hardware.
2. **BIOS/UEFI** identifies the boot device.
3. **Boot Loader (GRUB)** loads the Linux kernel.
4. **Kernel** initializes hardware and system resources.
5. **systemd/init (PID 1)** starts system services.
6. Required filesystems are mounted.
7. System reaches the login prompt and becomes available for users.
