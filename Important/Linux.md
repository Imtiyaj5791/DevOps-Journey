# Linux Administration Interview README
## L2 / 5–6 Years Linux + AWS Support Level

> **Interview Style:** Simple English, troubleshooting flow, production-safe answers.
> First explain the approach, then give commands if interviewer asks.

---

# 1. What is Linux? What is your experience with Linux administration?

Linux is an open-source operating system.

I have around 5 years of experience in Linux and AWS support. In my environment, I support Linux production servers.

My day-to-day Linux activities include:

- Server monitoring
- Production incident troubleshooting
- CPU, memory and disk utilization
- Service troubleshooting
- Log analysis
- User and permission management
- SSH troubleshooting
- Patching coordination
- Working with application, network, cloud and database teams

---

# 2. How do you check CPU, memory and disk utilization?

For CPU utilization, I normally use `top` or `htop`.

For memory utilization, I use:

    free -h

For disk utilization, I use:

    df -h

If disk utilization is high, I use `du` to find which directory is consuming more space.

Commands:

    top
    htop
    free -h
    df -h
    du -sh /*
    du -sh /var/*

---

# 3. CPU utilization is 95%. How will you troubleshoot?

First, I will check the monitoring tool to confirm whether CPU utilization is a temporary spike or continuously high.

Then I will log in to the server and use `top` to identify which process is consuming high CPU.

After that, I will check the process details and verify whether any scheduled job is running.

If an application process is consuming high CPU, I will check the logs and coordinate with the application team.

I will not directly kill the process or restart the service without checking the impact and taking approval.

Commands:

    top
    ps -ef | grep <process_name>
    crontab -l

If restart is approved:

    systemctl restart <service_name>

---

# 4. Memory utilization is 95%. How will you troubleshoot?

First, I will check whether memory utilization is continuously high or it is only a temporary spike.

Then I will use `free -h` to check total, used and available memory.

I will also check swap utilization.

After that, I will identify which process is consuming high memory.

If an application process is consuming high memory, I will check the logs and coordinate with the application team before taking any restart or process-level action.

Commands:

    free -h
    swapon --show
    top
    ps aux --sort=-%mem | head

---

# 5. Disk utilization reached 100%. How will you troubleshoot?

First, I will use `df -h` to identify which filesystem is full.

Then I will use `du` to find which directory is consuming more space.

After that, I will check for large log files, temporary files or unnecessary old files.

I will clean only unnecessary files as per SOP.

If we cannot release enough space and additional capacity is required, I will extend the disk/filesystem after approval.

If it is an AWS EC2 instance, I will check the EBS volume and extend the filesystem according to the storage setup.

Commands:
```
    df -h
    du -sh /*
    du -sh /var/*
    du -sh /var/log/*
    find / -type f -size +500M 2>/dev/null
```
For an extended EBS volume:
```
    lsblk
```
For ext4:
```
    resize2fs /dev/<device>
```
For XFS:
```
    xfs_growfs <mount_point>
```
---

# 6. Server is running out of disk space because of logs. How will you troubleshoot and prevent it again?

First, I will check which filesystem is consuming more space using `df -h`.

Then I will identify which log directory or log file is consuming the space.

I will check old and large log files and clean or archive them as per company SOP.

After resolving the immediate issue, I will check whether log rotation is configured properly.

If required, I will configure or correct `logrotate` so old logs are rotated, compressed and retained only for the required period.

Commands:

    df -h
    du -sh /var/log/*
    ls -lh /var/log
    cat /etc/logrotate.conf
    ls /etc/logrotate.d/

---

# 7. SSH is not working. How will you troubleshoot?

First, I will check whether the server itself is reachable.

If it is an AWS EC2 instance, I will check EC2 status checks.

Then I will check Security Group, NACL and routing based on the network configuration.

After that, I will check whether SSH port 22 is listening and whether the SSH service is running.

Finally, I will check SSH logs to find the exact error.

Commands:

    ss -tulnp | grep :22
    systemctl status ssh
    journalctl -u ssh

---
# 8. Hard Link vs Soft Link: 

Hard link: has the same inode as the original file, while a soft link has a different inode and points to the original file path.

Inode: An inode stores a file's metadata such as permissions, ownership, size, timestamps, and disk block information.

Swap: Swap is disk space used by Linux to store less-used memory pages when available RAM is low.

systemd: systemd is the Linux system and service manager used to start, stop, restart, and manage services and system processes.

Zombie vs Orphan: A zombie is a completed process whose parent has not collected its exit status, while an orphan is a running process whose parent has terminated.

# 10. How do you create a Linux user and manage permissions?

I can create a user using `useradd`, set the password and add the user to the required group.

For file access, I use `chmod` to manage permissions and `chown` to manage ownership.

I provide only the required permissions instead of giving unnecessary access.

Commands:

    useradd username
    passwd username
    usermod -aG groupname username
    chage -d 0 username

Permissions:

    chmod 755 file_name

Ownership:

    chown user:group file_name

---

# 09. Explain your patching activity.

Answer:

We use NinjaOne for patch management.

First, we schedule the maintenance activity and inform the stakeholders.

For production servers, we take an EBS snapshot before patching.

We enable maintenance mode and start the patch installation through NinjaOne.

After patching and reboot, I verify server accessibility.

I check all required application services and verify CPU, Memory and Disk utilization.

I also verify application accessibility.

Once everything is working fine, I disable maintenance mode, update the maintenance ticket and continue monitoring the server.

# If patching fails:

First, I identify at which stage the patch failed — whether during download, installation or reboot.

Then I review NinjaOne logs and Linux system logs to identify the issue.

If the server is accessible, I verify the application services and system health.

If required, I restore the server using the latest EBS snapshot or follow the approved rollback procedure as per company SOP.

I coordinate with the Patch Management Team and Application Team.

Finally, I verify the application, update the Jira ticket, and prepare the RCA if required.

# Manual Patching:

For manual patching, I directly log in to the Linux server through SSH and perform the patching using the native package manager.

First, I check the OS version, kernel version and available disk space and review the available updates.

```
apt update
apt list --upgradable
apt upgrade
```

I review the packages before installation and apply the approved patches.

If a reboot is required, I reboot the server during the approved maintenance window.

After reboot, I verify the server accessibility, kernel version, application services, CPU, Memory, Disk and application accessibility.

Finally, I update the maintenance ticket and monitor the server.

# If patching fails:

First, I identify whether the failure happened during download, installation or reboot.

Then I check the Linux package manager logs and system logs.

If required, I follow the approved rollback procedure or restore the pre-patching EBS snapshot.

After rollback, I verify the server and application health, coordinate with the relevant teams, update the Jira ticket, and prepare the RCA if required.

# 10. Explain Linux file permissions and chmod 755.

Linux mainly has three permissions:

- Read = 4
- Write = 2
- Execute = 1

For `755`:

    Owner  = 7 = rwx
    Group  = 5 = r-x
    Others = 5 = r-x

So the owner has read, write and execute permission.

Group and others have read and execute permission.

---

# 11. What is the difference between chmod and chown?

`chmod` is used to change file or directory permissions.

Example:

    chmod 755 file_name

`chown` is used to change the owner or group of a file or directory.

Example:

    chown user:group file_name

---

# 12. Application is getting "Permission Denied". How will you troubleshoot?

First, I will identify which file or directory is giving the permission error.

Then I will check its owner, group and permissions.

I will also check which user the application is running with.

If ownership is incorrect, I will correct the ownership.

If permission is incorrect, I will provide only the required permission.

I will not directly give `777` permission without understanding the requirement.

Commands:

    ls -l <file_or_directory>
    ps -ef | grep <application>
    chown user:group <file_or_directory>
    chmod <required_permission> <file_or_directory>

---

# 13. What is a cron job?

Cron is used to automatically run commands or scripts at a scheduled time.

For example, if I need to run a backup script every day at 2 AM, I can configure it in crontab.

Edit crontab:

    crontab -e

Check existing cron jobs:

    crontab -l

Example:

    0 2 * * * /opt/scripts/backup.sh

---

# 14. What is log analysis in Linux?

Log analysis means checking system or application logs to find the exact reason for an issue.

During troubleshooting, I normally check service logs, system logs and application logs.

Commands:

    journalctl -xe
    journalctl -u <service_name>
    tail -f /var/log/syslog
    tail -f /path/to/application.log

---

# 15. How do you perform Linux patching in production?

In my environment, we use NinjaRMM for patching.

The engineering team pushes the patches and our operations team coordinates and monitors the activity.

Before and after patching, we verify the server and application status.

For Ubuntu, I can manually check available updates using:

    apt update
    apt list --upgradable

After patching, I will verify:

    uptime
    systemctl --failed

I will also verify the required application/services.

---

# 16. Do you have experience with Bash scripting?

Yes. I have working experience with basic Bash scripting for system health checks and small automation tasks.

I have used commands for CPU, memory, disk and log checks inside scripts.

Some use cases are:

- System health monitoring
- CPU/memory checks
- Disk checks
- Log cleanup
- Scheduled tasks
- Small operational automation

---

# 17. Server is slow. How will you troubleshoot?

First, I will check CPU, memory and disk utilization.

Then I will check the top CPU and memory-consuming processes.

If CPU and memory look normal, I will check disk I/O, load average, application status and logs.

I will also check network connectivity if required.

Based on the findings, I will identify whether the issue is related to OS, application, storage or network.

Commands:

    top
    free -h
    df -h
    uptime
    ps aux --sort=-%cpu | head
    ps aux --sort=-%mem | head
    journalctl -xe

---

# 18. Application is down but server is up. What will you check?

First, I will check the application service status using `systemctl status`.

Then I will check whether the required application port is listening or not.

After that, I will test the application locally using `curl`.

Then I will check the application and system logs to find the exact error.

If restart is required, I will take approval, restart the service and verify the application again.

Commands:

    systemctl status <service_name>
    ss -tulnp
    curl localhost:<port>
    journalctl -u <service_name>
    tail -100 /path/to/application.log

---


# 20. A Linux service failed to start. How will you troubleshoot?

First, I will check the service status using `systemctl status`.

Normally it gives some information about why the service failed.

Then I will check service logs using `journalctl`.

After that, I will check service configuration, file permissions, dependencies and whether another process is already using the required port.

Once I find the issue, I will fix it and start the service again.

Commands:

    systemctl status <service_name>
    journalctl -u <service_name>
    journalctl -xe
    ss -tulnp

---

# 21. Explain the Linux boot process.

When the server starts, BIOS or UEFI performs the initial hardware check.

Then GRUB loads the Linux kernel.

The kernel initializes the hardware and system resources.

After that, `systemd`, which runs as PID 1, starts the required services.

Finally, the system becomes available for users.

Easy flow:

    BIOS/UEFI
        ↓
    GRUB
        ↓
    Kernel
        ↓
    systemd (PID 1)
        ↓
    Services
        ↓
    Login

---

# NETWORKING

# 22. How do you troubleshoot a network connectivity issue in Linux?

First, I will check the server IP address.

Then I will check the routing table.

After that, I will test connectivity to the destination IP.

If basic connectivity is working, I will check whether the required application port is reachable.

If the issue is related to hostname resolution, I will also check DNS.

Commands:

    ip a
    ip route
    ping <destination_ip>
    ss -tulnp
    curl http://<server_ip>:<port>
    nslookup <domain>
    dig <domain>

---

# 23. One Linux server cannot communicate with another server. How will you troubleshoot?

First, I will check the IP address and routing configuration.

Then I will test connectivity between both servers.

If basic connectivity is working, I will check whether the required application port is listening and reachable.

If servers are hosted in AWS, I will also check Security Groups, NACL and route tables.

Based on where the traffic is failing, I will troubleshoot the OS, network or application side.

Commands:

    ip a
    ip route
    ping <destination_ip>
    ss -tulnp
    curl http://<destination_ip>:<port>

---

# 24. DNS is not resolving on a Linux server. How will you troubleshoot?

First, I will check whether basic network connectivity is working by testing an IP address.

Then I will test DNS resolution using `nslookup` or `dig`.

If DNS is not resolving, I will check DNS configuration in `/etc/resolv.conf`.

I will also check `/etc/hosts` if local hostname mapping is being used.

Commands:

    ping <known_ip>
    nslookup google.com
    dig google.com
    cat /etc/resolv.conf
    cat /etc/hosts

---

# 25. What is /etc/hosts?

`/etc/hosts` is used for local hostname-to-IP mapping.

For example:

    10.0.1.10 appserver
    10.0.1.20 dbserver

The server can resolve these hostnames locally without querying an external DNS server.

---

# 26. What is /etc/resolv.conf?

`/etc/resolv.conf` contains DNS resolver information used by the Linux system.

For example:

    nameserver 10.0.0.2

If DNS resolution is not working, this is one of the configurations I will check.

---

# 27. DNS is resolving but application port is not reachable. How will you troubleshoot?

If DNS is resolving correctly, hostname resolution is working.

Then I will check whether the application service is running.

After that, I will check whether the application is listening on the required port.

Then I will test the application locally.

If it works locally but the port is not accessible remotely, I will check firewall, Security Group, NACL and Load Balancer configuration.

Finally, I will check application logs.

Commands:

    systemctl status <service_name>
    ss -tulnp
    curl localhost:<port>

---

# FILESYSTEM, MOUNT & LVM

# 28. Filesystem is not mounted after server reboot. How will you troubleshoot?

First, I will check available disks and mounted filesystems.

Then I will check the `/etc/fstab` entry.

I will verify the UUID, mount point and filesystem type.

After that, I will run `mount -a` to validate the configuration.

If it gives an error, I will correct the entry before rebooting again.

Commands:

    lsblk
    df -h
    cat /etc/fstab
    blkid
    mount -a

---

# 29. Why do we use UUID in /etc/fstab?

We use UUID because it uniquely identifies the filesystem.

Device names can sometimes change, but the filesystem UUID remains associated with that filesystem.

So using UUID makes permanent mounting more reliable.

---

# 30. What is LVM?

LVM stands for Logical Volume Manager.

It provides flexible storage management in Linux.

With LVM, we can create and extend logical volumes more easily when storage requirements increase.

Basic flow:

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

---

# 31. What are PV, VG and LV?

PV means Physical Volume.

It is a disk or partition initialized for LVM.

VG means Volume Group.

It is a storage pool created using one or more Physical Volumes.

LV means Logical Volume.

It is created from the Volume Group and is used for creating a filesystem and mount point.

Commands:

    pvs
    vgs
    lvs

---

# 32. How do you create and mount an LVM filesystem?

First, I will create a Physical Volume from the disk.

Then I will create a Volume Group.

After that, I will create a Logical Volume from the Volume Group.

Then I will create the filesystem and mount point and mount the Logical Volume.

For permanent mounting, I will add it into `/etc/fstab` and validate using `mount -a`.

Commands:

    pvcreate /dev/xvdf

    vgcreate vg_data /dev/xvdf

    lvcreate -L 10G -n lv_data vg_data

For ext4:

    mkfs.ext4 /dev/vg_data/lv_data

Create mount point:

    mkdir /data

Mount:

    mount /dev/vg_data/lv_data /data

Verify:

    df -h

---

# 33. How do you extend an existing LVM filesystem?

First, I will check filesystem usage and the current LVM layout.

Then I will check whether free space is available in the Volume Group.

If free space is available, I will extend the Logical Volume.

After that, I will extend the filesystem and verify the new size.

Commands:

    df -h
    pvs
    vgs
    lvs

Extend LV:

    lvextend -L +10G /dev/vg_data/lv_data

For ext4:

    resize2fs /dev/vg_data/lv_data

For XFS:

    xfs_growfs /data

Verify:

    df -h

---

# 34. What will you do if there is no free space in the Volume Group?

If there is no free space in the Volume Group, I will attach or identify a new disk.

Then I will create a Physical Volume from the new disk.

After that, I will extend the existing Volume Group.

Once free space is available in the VG, I can extend the Logical Volume and filesystem.

Commands:

    lsblk
    pvcreate /dev/xvdf
    vgextend vg_data /dev/xvdf
    vgs

Then:

    lvextend -L +10G /dev/vg_data/lv_data

---

# 35. You increased an AWS EBS volume which is already used by LVM. How will you use the new space?

First, I will verify that Linux can see the increased EBS size using `lsblk`.

Then I will resize the Physical Volume so LVM can see the additional space.

After that, I will verify free space in the Volume Group.

Then I will extend the Logical Volume.

Finally, I will resize the filesystem and verify the new size.

Commands:

    lsblk
    pvs
    pvresize /dev/<lvm_device>
    vgs

Extend LV:

    lvextend -L +10G /dev/<vg>/<lv>

For ext4:

    resize2fs /dev/<vg>/<lv>

For XFS:

    xfs_growfs <mount_point>

Verify:

    df -h

---

# 36. What is the difference between a normal partition and LVM?

A normal partition is comparatively fixed and less flexible to resize.

LVM provides more flexibility.

With LVM, we can combine storage into Volume Groups and extend Logical Volumes more easily when storage requirements increase.

---

# PROCESS MANAGEMENT

# 37. How do you check running processes?

I normally use `ps -ef` to list running processes.

For real-time process and resource utilization, I use `top`.

If I need to find a specific process, I use `grep`.

Commands:

    ps -ef
    top
    ps -ef | grep <process_name>

---

# 38. What is the difference between a process and a service?

A process is a running instance of a program.

A service is normally a background application managed by a service manager like `systemd`.

One service can also have multiple processes.

---

# 39. What is PID?

PID stands for Process ID.

Every running process has a process ID which Linux uses to identify and manage that process.

Command:

    ps -ef

---

# 40. What is the difference between kill and kill -9?

Normal `kill` requests the process to terminate gracefully.

I will normally try this first.

    kill <PID>

`kill -9` forcefully terminates the process and does not give it a chance to shut down cleanly.

    kill -9 <PID>

In production, I will use `kill -9` only when required and after following the proper approval process.

---

# 41. A Java process is consuming 98% CPU. Will you kill it?

No, I will not directly kill the process.

First, I will confirm the CPU utilization and identify the process.

Then I will check whether it is a temporary spike or continuously high.

I will also check the related logs and business impact.

After that, I will coordinate with the application team.

If they confirm that the process can be restarted or terminated, I will take the approved action and monitor the server afterward.

---

# 42. What is a Zombie Process?

A zombie process is a process that has completed its execution, but its parent process has not collected its exit status.

Normally it shows `Z` in the process state.

I will identify the parent process before taking any action because directly killing the zombie itself normally does not solve the root cause.

Commands:

    ps aux
    ps -ef

---

# BOOT & PRODUCTION INCIDENTS

# 43. A Linux server rebooted unexpectedly. How will you investigate?

First, I will check when the server rebooted and check the current uptime.

Then I will check the logs from the previous boot using journalctl -b -1.

I will check whether there was any kernel issue, filesystem issue, resource issue, scheduled activity, or manual reboot.

If it is an AWS EC2 instance, I will also check EC2 Status Checks and CloudWatch for any related events or metrics.

I will also check CloudTrail to verify whether someone performed a stop, reboot, or other EC2 API action.

Based on the findings, I will identify the root cause and take the required action.

Commands:
```
    last reboot
    uptime
    journalctl -b -1
```
---

# 44. Linux server is not booting properly. What will you check?

First, I will identify at which stage the server boot is failing.

Then I will check for filesystem or `/etc/fstab` issues.

I will also check disk, GRUB, kernel and failed service issues.

I will review available boot/system logs and identify the exact error before making any changes.

---

# 45. What will you check after a Linux server restore/recovery?

First, I will confirm that the server is reachable.

Then I will check CPU, memory, disk and filesystem mounts.

After that, I will verify network configuration, required services and listening ports.

Then I will verify application connectivity and logs.

If the application has database or other dependencies, I will coordinate with the required teams for end-to-end validation before confirming recovery.

Commands:

    uptime
    free -h
    df -h
    lsblk
    ip a
    ip route
    systemctl --failed
    ss -tulnp

---

# 46. Application team says not to restart the service, but users are facing issues. What will you do?

I will not restart the service without approval.

I will continue troubleshooting using service status, process information, port checks, logs and resource utilization.

I will collect the required information and share it with the application team.

If the issue requires application-level action, I will coordinate with them and follow the incident/change process.

---

# PACKAGE MANAGEMENT

# 47. How do you manage packages in Ubuntu?

I use `apt` for package management in Ubuntu.

Update package information:

    apt update

Install:

    apt install <package_name>

Check available upgrades:

    apt list --upgradable

Upgrade:

    apt upgrade

Remove:

    apt remove <package_name>

---

# 48. How do you check whether a package is installed and its version?

I can check an installed package using `dpkg` or `apt`.

Commands:

    dpkg -l | grep <package_name>

or:

    apt list --installed | grep <package_name>

For some applications, I can directly check the version.

Example:

    nginx -v

---

# 50. How do you check which process is using a specific port?

I can use `ss` to identify the process listening on a specific port.

I can also use `lsof`.

Commands:

    ss -ltnp | grep :8080
    lsof -i :8080

---

# 51. How do you check system load and what does load average mean?

I can check load average using `uptime` or `top`.

Load average shows the average system workload over approximately 1, 5 and 15 minutes.

I will compare the load with the number of CPUs and then investigate the processes or I/O causing the load.

Commands:

    uptime
    top
    nproc

---

# 52. CPU is normal but server is still slow. What else will you check?

If CPU utilization is normal, I will check memory and swap utilization.

Then I will check disk utilization, disk I/O and load average.

After that, I will check application response and network connectivity.

Finally, I will check system and application logs.

This will help me identify whether the issue is related to memory, storage, network or application instead of CPU.

Commands:

    free -h
    swapon --show
    df -h
    uptime
    top
    journalctl -xe

---

# 53. What is the difference between df and du?

`df` shows filesystem-level disk utilization.

`du` shows how much space a particular directory or file is consuming.

Normally, I use `df -h` first to identify which filesystem is full.

Then I use `du` to find which directory is consuming the space.

Commands:

    df -h
    du -sh /var/*

---

# 54. df -h shows filesystem is full, but du does not show the same usage. What will you check?

One possible reason is that a process still has a deleted file open.

The file may be deleted from the directory, but disk space will not be released until the process closes that file.

I will check deleted but open files and identify the related process before taking any action.

Command:

    lsof +L1

---

# 55. How do you check failed services on a Linux server?

I can use `systemctl --failed` to check failed services.

Then I will check the status and logs of the affected service.

Commands:

    systemctl --failed
    systemctl status <service_name>
    journalctl -u <service_name>

---

# 56. How do you check last reboot and login history?

For reboot history:

    last reboot

For login history:

    last

I normally use these commands during incident investigation when I need to know when the server restarted or who logged in.

---

# 57. How will you troubleshoot a Bash script that is failing?

First, I will run the script and check the exact error.

Then I will verify the script permissions and interpreter/shebang.

After that, I will check file paths and commands used inside the script.

I can use `bash -x` to trace the script execution line by line.

I will also check the exit status if required.

Commands:

    ls -l script.sh
    head -1 script.sh
    bash -x script.sh
    echo $?

---

# QUICK INTERVIEW REVISION

## High CPU

    Monitoring
       ↓
    top
       ↓
    High CPU Process
       ↓
    Process / Logs / Cron
       ↓
    Application Team
       ↓
    Approved Action

---

## High Memory

    Monitoring
       ↓
    free -h
       ↓
    Swap
       ↓
    High Memory Process
       ↓
    Logs
       ↓
    Application Team

---

## Disk Full

    df -h
      ↓
    du
      ↓
    Large Directory/File
      ↓
    Logs / Temporary Files
      ↓
    Cleanup / Logrotate
      ↓
    Extend Disk if Required

---

## SSH Issue

    Server Reachability
       ↓
    AWS Status / Network
       ↓
    Port 22
       ↓
    SSH Service
       ↓
    SSH Logs

---

## Application Down

    Service
       ↓
    Port
       ↓
    curl localhost
       ↓
    Logs
       ↓
    Fix / Approved Restart
       ↓
    Verify

---

## Application Works Locally But Not Remotely

    curl localhost
         ↓
    Application OK
         ↓
    Firewall
         ↓
    SG / NACL
         ↓
    Route
         ↓
    ALB / Target Group

---

## Network Issue

    ip a
      ↓
    ip route
      ↓
    ping
      ↓
    Port
      ↓
    curl

---

## DNS Issue

    IP Connectivity
        ↓
    nslookup / dig
        ↓
    /etc/resolv.conf
        ↓
    /etc/hosts

---

## Service Failed

    systemctl status
          ↓
    journalctl
          ↓
    Config / Dependency / Port
          ↓
    Fix
          ↓
    Restart & Verify

---

## Mount Issue After Reboot

    lsblk
      ↓
    /etc/fstab
      ↓
    UUID
      ↓
    mount -a

---

## LVM

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
    Mount Point

---

## LVM Extend

    lsblk / pvs / vgs / lvs
              ↓
    pvresize (if EBS/disk increased)
              ↓
    lvextend
              ↓
    resize2fs / xfs_growfs
              ↓
    df -h

---

## Permission Denied

    ls -l
      ↓
    Application User
      ↓
    Owner / Group
      ↓
    Required chmod / chown

---

## Unexpected Reboot

    last reboot
        ↓
    uptime
        ↓
    journalctl -b -1
        ↓
    AWS Status / CloudWatch
        ↓
    CloudTrail if Required

---

## Bash Script Failed

    Exact Error
       ↓
    Permission / Shebang
       ↓
    File Path / Commands
       ↓
    bash -x
       ↓
    Exit Code

---

# MOST IMPORTANT COMMANDS

## CPU / Memory / Load

    top
    htop
    free -h
    uptime
    nproc

## Disk / Filesystem

    df -h
    du -sh /*
    lsblk
    blkid

## Process / Port

    ps -ef
    ss -tulnp
    lsof -i :8080

## Services / Logs

    systemctl status <service>
    systemctl --failed
    journalctl -u <service>
    journalctl -xe
    journalctl -b -1
    tail -f <logfile>

## Network / DNS

    ip a
    ip route
    ping <ip>
    curl localhost:<port>
    nslookup <domain>
    dig <domain>

## Users / Permissions

    useradd <user>
    usermod -aG <group> <user>
    chmod
    chown

## LVM

    pvs
    vgs
    lvs
    pvcreate
    pvresize
    vgcreate
    vgextend
    lvcreate
    lvextend
    resize2fs
    xfs_growfs

## Package Management

    apt update
    apt list --upgradable
    dpkg -l

---

# GOLDEN RULE FOR PRODUCTION INTERVIEWS

Never say:

    "I will directly restart the service."
    "I will kill -9 the process."
    "I will delete the logs."
    "I will give chmod 777."

Better approach:

    Check
      ↓
    Identify
      ↓
    Logs
      ↓
    Business Impact
      ↓
    Coordinate / Approval
      ↓
    Action
      ↓
    Verify

For production troubleshooting, first identify the issue and collect the required information.

If application-level action is required, coordinate with the application team.

Take approval where required, perform the action and verify the server/application after the change.
