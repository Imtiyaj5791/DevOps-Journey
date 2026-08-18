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

# LVM (Logical Volume Manager) Interview Notes

---

# What is LVM in Linux?

LVM (Logical Volume Manager) is a storage management solution in Linux that provides flexibility in managing disks and filesystems.

It allows us to:

- Extend storage without repartitioning.
- Combine multiple disks into a single storage pool.
- Increase filesystem size easily.
- Manage storage dynamically.

In enterprise environments, LVM is commonly used because storage requirements can grow over time.

---

# LVM Architecture

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
Mount Point
```

Example:

```text
/dev/xvdf
    ↓
PV
    ↓
vg_data
    ↓
lv_data
    ↓
ext4 / xfs
    ↓
/data
```

---

# What is a Physical Volume (PV)?

A Physical Volume is a disk or partition that is initialized for LVM.

### Create PV

```bash
pvcreate /dev/xvdf
```

### Display PV Information

```bash
pvs
```

or

```bash
pvdisplay
```

---

# What is a Volume Group (VG)?

A Volume Group is a pool of storage created using one or more Physical Volumes.

### Create VG

```bash
vgcreate vg_data /dev/xvdf
```

### View VG Details

```bash
vgs
```

or

```bash
vgdisplay
```

---

# What is a Logical Volume (LV)?

A Logical Volume is created from a Volume Group and is used like a normal disk partition.

### Create LV

```bash
lvcreate -L 10G -n lv_data vg_data
```

### View LV Details

```bash
lvs
```

or

```bash
lvdisplay
```

---

# How do you create a filesystem on LVM?

## Ext4 Filesystem

```bash
mkfs.ext4 /dev/vg_data/lv_data
```

## XFS Filesystem

```bash
mkfs.xfs /dev/vg_data/lv_data
```

---

# How do you mount an LVM filesystem?

### Create Mount Point

```bash
mkdir /data
```

### Mount Filesystem

```bash
mount /dev/vg_data/lv_data /data
```

### Verify Mount

```bash
df -h
```

---

# How do you make LVM mount permanent?

### Get UUID

```bash
blkid
```

### Edit fstab

```bash
vi /etc/fstab
```

Example:

```text
/dev/vg_data/lv_data   /data   ext4   defaults   0 0
```

### Verify

```bash
mount -a
```

---

# How do you check LVM information?

### Check Physical Volumes

```bash
pvs
```

### Check Volume Groups

```bash
vgs
```

### Check Logical Volumes

```bash
lvs
```

### Complete Details

```bash
pvdisplay
vgdisplay
lvdisplay
```

---

# Difference Between Partition and LVM

## Traditional Partition

- Fixed size
- Difficult to resize
- Less flexible

Examples:

```text
/dev/sda1
/dev/sda2
```

## LVM

- Easy to extend
- Flexible storage management
- Supports dynamic resizing
- Enterprise preferred

Examples:

```text
/dev/vg_data/lv_data
```

---

# How do you extend an existing LVM filesystem?

### Step 1: Verify Current Usage

```bash
df -h
```

### Step 2: Check LVM Layout

```bash
pvs
vgs
lvs
```

### Step 3: Extend Logical Volume

```bash
lvextend -L +10G /dev/vg_data/lv_data
```

or

```bash
lvextend -r -L +10G /dev/vg_data/lv_data
```

### Step 4: Extend Filesystem

For Ext4:

```bash
resize2fs /dev/vg_data/lv_data
```

For XFS:

```bash
xfs_growfs /data
```

### Step 5: Verify

```bash
df -h
```

---

# How do you add a new disk to an existing LVM?

### Verify New Disk

```bash
lsblk
```

### Create Physical Volume

```bash
pvcreate /dev/xvdf
```

### Extend Volume Group

```bash
vgextend vg_data /dev/xvdf
```

### Verify

```bash
vgs
```

---

# Interview Scenario: Disk Full and Filesystem is on LVM

## Answer

First, I will check the filesystem utilization.

```bash
df -h
```

Then I will verify the LVM structure.

```bash
pvs
vgs
lvs
```

If free space is available inside the Volume Group, I will extend the Logical Volume.

```bash
lvextend -L +10G /dev/vg_data/lv_data
```

Then I will resize the filesystem.

For Ext4:

```bash
resize2fs /dev/vg_data/lv_data
```

For XFS:

```bash
xfs_growfs /data
```

Finally, I will verify the filesystem size.

```bash
df -h
```

If there is no free space available inside the Volume Group, I will attach a new disk and extend the Volume Group before extending the Logical Volume.

---

# Most Important LVM Commands

```bash
pvs
```

```bash
vgs
```

```bash
lvs
```

```bash
pvcreate
```

```bash
vgcreate
```

```bash
vgextend
```

```bash
lvcreate
```

```bash
lvextend
```

```bash
resize2fs
```

```bash
xfs_growfs
```

```bash
df -h
```

```bash
lsblk
```

---

# Quick Interview Answer

### What is LVM?

LVM (Logical Volume Manager) is a storage management layer in Linux that provides flexible disk management. It allows us to create, extend and manage storage volumes dynamically without repartitioning disks. The main components of LVM are Physical Volume (PV), Volume Group (VG) and Logical Volume (LV).

# Linux Additional Interview Questions — Networking, Services, Filesystem, Process & Production Scenarios

## 1. How do you troubleshoot a network connectivity issue in Linux?

First, I will check the IP address of the server.

```bash
ip a
```

Then I will check the routing table.

```bash
ip route
```

After that, I will check connectivity using:

```bash
ping <destination_ip>
```

If it is an application connectivity issue, I will check the required port.

```bash
ss -tulnp
```

I can also test the application using:

```bash
curl http://<server_ip>:<port>
```

For DNS-related issues, I will use:

```bash
nslookup <domain>
```

or

```bash
dig <domain>
```

---

## 2. One Linux server cannot communicate with another server. How will you troubleshoot?

First, I will check whether both servers have the correct IP address and network configuration.

```bash
ip a
ip route
```

Then I will test connectivity.

```bash
ping <destination_ip>
```

If ping is working, I will check whether the required application port is reachable.

I will also verify:

- Firewall rules
- Security Group if hosted on AWS
- NACL if required
- Route Table
- Application service
- Listening port

```bash
ss -tulnp
```

---

## 3. DNS is not resolving on a Linux server. How will you troubleshoot?

First, I will check whether the server has network connectivity.

```bash
ping <gateway_or_ip>
```

Then I will test DNS resolution.

```bash
nslookup google.com
```

or

```bash
dig google.com
```

I will check the DNS configuration.

```bash
cat /etc/resolv.conf
```

I will also verify `/etc/hosts` if local hostname resolution is being used.

```bash
cat /etc/hosts
```

---

## 4. What is `/etc/hosts`?

`/etc/hosts` is used for local hostname-to-IP mapping.

Example:

```text
10.0.1.10 appserver
10.0.1.20 dbserver
```

The server can resolve these hostnames locally without querying an external DNS server.

---

## 5. What is `/etc/resolv.conf`?

`/etc/resolv.conf` contains DNS resolver information used by the Linux system.

Example:

```text
nameserver 10.0.0.2
```

If DNS resolution is not working, this is one of the configurations I will verify.

---

# Linux Service Troubleshooting

## 6. A Linux service failed to start. How will you troubleshoot?

First, I will check the service status.

```bash
systemctl status <service_name>
```

Then I will check the service logs.

```bash
journalctl -u <service_name>
```

or

```bash
journalctl -xe
```

I will check:

- Service configuration
- Application logs
- Required port
- File permissions
- Dependencies

I will also verify whether another process is already using the required port.

```bash
ss -tulnp
```

After identifying and fixing the issue, I will start or restart the service.

```bash
systemctl restart <service_name>
```

---

## 7. Service is running but application is not accessible. What will you check?

First, I will verify the service status.

```bash
systemctl status <service_name>
```

Then I will check whether the application is listening on the expected port.

```bash
ss -tulnp
```

I will test the application locally.

```bash
curl localhost:<port>
```

If it works locally but not remotely, I will check:

- Firewall
- Security Group
- NACL
- Route
- Load Balancer

I will also check application logs.

---

# Filesystem & Mount Troubleshooting

## 8. Filesystem is not mounted after server reboot. How will you troubleshoot?

First, I will check the mounted filesystems.

```bash
df -h
```

Then I will check the available disks.

```bash
lsblk
```

I will verify the `/etc/fstab` configuration.

```bash
cat /etc/fstab
```

Then I will validate the entries using:

```bash
mount -a
```

If there is an error, I will check:

- Device/UUID
- Mount point
- Filesystem type
- fstab entry

I can verify the UUID using:

```bash
blkid
```

---

## 9. Why do we use UUID in `/etc/fstab`?

UUID provides a unique identification for the filesystem.

Device names can sometimes change, but UUID remains associated with the filesystem.

Example:

```text
UUID=xxxxxxxx /data ext4 defaults 0 0
```

Using UUID makes permanent mounting more reliable.

---

# Linux Process Management

## 10. How do you check running processes in Linux?

We can use:

```bash
ps -ef
```

or:

```bash
top
```

To find a specific process:

```bash
ps -ef | grep <process_name>
```

---

## 11. What is the difference between a Process and a Service?

A **process** is a running instance of a program.

A **service** is generally a background application managed by the operating system/service manager such as systemd.

Example:

```text
nginx → Service
nginx worker process → Process
```

We can manage a service using:

```bash
systemctl status nginx
systemctl start nginx
systemctl stop nginx
systemctl restart nginx
```

---

## 12. What is PID?

PID stands for **Process ID**.

Every running process has a unique PID.

We can check processes using:

```bash
ps -ef
```

Example:

```text
root   1234   nginx
```

Here:

```text
1234 = PID
```

---

## 13. What is the difference between `kill` and `kill -9`?

Normal `kill` sends a termination signal and gives the process a chance to shut down properly.

```bash
kill <PID>
```

`kill -9` forcefully terminates the process.

```bash
kill -9 <PID>
```

I will normally try a graceful termination first. I will use `kill -9` only when required and after following the proper approval/process in production.

---

## 14. What is a Zombie Process?

A zombie process is a process that has completed execution, but its parent process has not yet collected its exit status.

We can identify process states using:

```bash
ps -ef
```

or:

```bash
ps aux
```

Zombie processes generally show a `Z` state.

---

# Permission Troubleshooting

## 15. Application is getting "Permission Denied". How will you troubleshoot?

First, I will identify the affected file or directory.

Then I will check its permissions and ownership.

```bash
ls -l <file_name>
```

I will verify:

- Owner
- Group
- Read permission
- Write permission
- Execute permission

If ownership is incorrect, after verification I can correct it using:

```bash
chown user:group <file_name>
```

If permissions are incorrect:

```bash
chmod <permission> <file_name>
```

I will not directly give `777` permission without understanding the requirement.

---

# Unexpected Reboot / Boot Issue

## 16. A Linux server rebooted unexpectedly. How will you investigate?

First, I will check when the server rebooted.

```bash
last reboot
```

Then I will check the uptime.

```bash
uptime
```

I will review logs from the previous boot.

```bash
journalctl -b -1
```

I will check for:

- Kernel issues
- System errors
- Resource issues
- Scheduled activities
- Manual reboot

If the server is hosted on AWS, I will also check:

- EC2 Status Checks
- CloudWatch
- CloudTrail

CloudTrail can help identify whether someone manually rebooted or stopped the EC2 instance.

---

## 17. Linux server is not booting properly. What will you check?

I will check whether there is any issue with:

- Filesystem
- `/etc/fstab`
- Disk
- GRUB
- Kernel
- Failed services

A wrong `/etc/fstab` entry can also create boot issues.

I will review boot/system logs and identify the exact error before making changes.

---

# Package Management

## 18. How do you manage packages in Ubuntu?

First, I update the package information.

```bash
sudo apt update
```

To install a package:

```bash
sudo apt install <package_name>
```

To check available upgrades:

```bash
apt list --upgradable
```

To upgrade approved packages:

```bash
sudo apt upgrade
```

To remove a package:

```bash
sudo apt remove <package_name>
```

---

## 19. How do you check whether a package is installed and its version?

We can use:

```bash
dpkg -l | grep <package_name>
```

or:

```bash
apt list --installed | grep <package_name>
```

For some applications, we can directly check the version.

Example:

```bash
nginx -v
```

---

# Production Troubleshooting Scenarios

## 20. Server is pinging but SSH is not working. What will you check?

If ping is working, basic network connectivity is available.

Then I will check:

- SSH port 22
- SSH service
- Firewall
- Security Group
- NACL
- SSH configuration

Check SSH service:

```bash
systemctl status ssh
```

Check listening port:

```bash
ss -tulnp | grep :22
```

Check SSH logs:

```bash
journalctl -u ssh
```

If it is an AWS EC2 instance, I will also verify Security Group and NACL rules.

---

## 21. DNS is resolving but application port is not reachable. How will you troubleshoot?

If DNS is resolving correctly, I will focus on application and network connectivity.

I will check whether the application service is running.

```bash
systemctl status <service_name>
```

Then I will verify whether the application is listening on the required port.

```bash
ss -tulnp
```

I will test it locally.

```bash
curl localhost:<port>
```

Then I will check:

- Linux firewall
- Security Group
- NACL
- Load Balancer
- Application logs

---

## 22. Application is accessible locally but users cannot access it remotely. What will you check?

If this works:

```bash
curl localhost:<port>
```

then the application is running locally.

I will check:

- Application listening address
- Linux firewall
- Security Group
- NACL
- Route Table
- Load Balancer Listener
- Target Group Health

I will identify where the traffic is getting blocked and take action accordingly.

---

# Quick Revision

```text
Linux Network Issue
→ ip a → ip route → ping → ss → curl

DNS Issue
→ nslookup/dig → /etc/resolv.conf → /etc/hosts

Service Failed
→ systemctl status → journalctl → config → port → logs

Mount Issue After Reboot
→ lsblk → fstab → blkid → mount -a

Process
→ ps → top → PID → kill

Permission Denied
→ ls -l → owner/group → chmod/chown

Unexpected Reboot
→ last reboot → uptime → journalctl -b -1

Ubuntu Package
→ apt update → apt install/upgrade

Ping Working but SSH Failed
→ Port 22 → SSH service → firewall/SG/NACL → logs

Application Local Working but Remote Failed
→ Port → Firewall → SG/NACL → Route → ALB
```
