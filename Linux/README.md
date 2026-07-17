\## Linux Architecture



Linux is an open-source operating system that manages hardware resources and acts as a bridge between the user and the hardware.



\### Linux Architecture



```

+----------------------+

|     Applications     |

+----------------------+

|        Shell         |

+----------------------+

|       Kernel         |

+----------------------+

|      Hardware        |

+----------------------+

```



\### Components



\#### Hardware

Physical components like CPU, RAM, Disk, Network Card, etc.



\#### Kernel

The core of Linux responsible for:

\- Process Management

\- Memory Management

\- Device Management

\- File System Management

\- Security

\- Networking



\#### Shell

The interface between the user and the kernel. It accepts commands from the user and passes them to the kernel.



Common Shells:

\- bash

\- sh

\- zsh

\- ksh



\#### Applications

Software installed on Linux such as:

\- nginx

\- apache

\- docker

\- mysql

\- vim



\### Important Commands



```bash

uname -a

hostnamectl

cat /etc/os-release

whoami

pwd

```



\### Interview Questions



\*\*Q1. What is Linux?\*\*



Linux is an open-source operating system that manages hardware resources and allows applications to run.



\*\*Q2. What is Kernel?\*\*



Kernel is the core component of Linux that manages CPU, memory, devices, and processes.



\*\*Q3. What is Shell?\*\*



Shell is a command-line interpreter that accepts user commands and passes them to the kernel.



\*\*Q4. Difference between Kernel and Shell?\*\*



| Kernel | Shell |

|--------|-------|

| Core of OS | Command Interpreter |

| Manages Hardware | Accepts User Commands |

| Always Running | Starts when user logs in |



\### Production Notes



Understanding Linux Architecture helps in troubleshooting CPU, memory, service, and boot-related issues in production environments.



\## Linux File System



Linux follows a hierarchical file system where everything is treated as a file, including directories, devices, and processes. The file system starts from the root (/) directory and organizes data in a structured manner.



\### Linux File System Structure



```text

&#x20;               /

&#x20;     ---------------------

&#x20;     |   |   |   |   |

&#x20;   /bin /etc /home /var /usr

&#x20;               |

&#x20;            /home/user

```



\### File System Types



\#### ext4

The most commonly used Linux file system. It provides good performance, reliability, and supports large files.



\#### XFS

A high-performance file system mainly used in enterprise environments. It is the default file system in RHEL/CentOS.



\#### Btrfs

A modern file system that supports snapshots, compression, and advanced storage management.



\### Important Commands



```bash

pwd

ls -l

df -h

du -sh \*

lsblk

mount

find /

```



\### Common Terms



\#### Root Directory (/)

The top-most directory from where every file and directory starts.



\#### File

Stores user data such as text, scripts, logs, and configuration.



\#### Directory

A folder used to organize files and other directories.



\#### Mount Point

A directory where a storage device is attached to the Linux file system.



\### Interview Questions



\*\*Q1. What is Linux File System?\*\*



Linux File System is a hierarchical directory structure used to store and organize files and directories.



\*\*Q2. What is the Root (/) directory?\*\*



Root (/) is the top-level directory from which all other directories originate.



\*\*Q3. Difference between ext4 and XFS?\*\*



| ext4 | XFS |

|------|-----|

| General Purpose | Enterprise Workloads |

| Faster Recovery | Better for Large Files |

| Common in Ubuntu | Default in RHEL/CentOS |



\*\*Q4. What is a Mount Point?\*\*



A mount point is a directory where a storage device is attached so that Linux can access its data.



\### Production Notes



Always monitor disk usage using `df -h` and `du -sh`. Ensure critical file systems do not reach 100% utilization, as this can cause applications and services to stop functioning properly.



\## Important Directories



Linux stores system files, user data, configuration files, logs, and applications in predefined directories. Understanding these directories is essential for Linux administration and troubleshooting.



\### Linux Directory Structure



```text

/

├── bin

├── boot

├── dev

├── etc

├── home

├── lib

├── media

├── mnt

├── opt

├── proc

├── root

├── run

├── srv

├── sys

├── tmp

├── usr

└── var

```



\### Important Directories



\#### /bin

Contains essential user commands such as `ls`, `cp`, `mv`, `cat`, and `mkdir`.



\#### /boot

Stores boot loader files, Linux kernel, and files required during system startup.



\#### /dev

Contains device files representing hardware like disks, USB devices, and terminals.



\#### /etc

Stores system-wide configuration files.



Examples:

\- hosts

\- passwd

\- fstab

\- ssh/sshd\_config



\#### /home

Default location for normal users' personal files.



Example:



```text

/home/john

/home/ec2-user

```



\#### /lib

Contains shared libraries required by system binaries.



\#### /media

Automatically mounts removable devices like USB drives and DVDs.



\#### /mnt

Temporary mount point used by administrators.



\#### /opt

Stores third-party software and optional applications.



\#### /proc

Virtual file system containing information about running processes and kernel.



\#### /root

Home directory of the root user.



\#### /run

Stores temporary runtime information.



\#### /srv

Contains data served by services like FTP or web servers.



\#### /sys

Virtual file system providing hardware and kernel information.



\#### /tmp

Stores temporary files that may be deleted after reboot.



\#### /usr

Contains user applications, libraries, and documentation.



\#### /var

Stores variable data such as logs, cache, mail, and spool files.



Important folders inside /var:



```text

/var/log

/var/cache

/var/spool

```



\### Important Commands



```bash

pwd

ls /

cd /etc

cd /var/log

cd /home

tree /

find /etc -name "\*.conf"

du -sh /var/\*

```



\### Interview Questions



\*\*Q1. Which directory contains configuration files?\*\*



`/etc`



\---



\*\*Q2. Where are Linux log files stored?\*\*



Most log files are stored inside `/var/log`.



\---



\*\*Q3. What is the difference between /bin and /usr/bin?\*\*



| /bin | /usr/bin |

|------|----------|

| Essential system commands | Additional user applications |

| Required during boot | Used after system startup |



\---



\*\*Q4. Difference between /media and /mnt?\*\*



| /media | /mnt |

|---------|------|

| Auto-mounted removable devices | Manual temporary mount point |



\---



\*\*Q5. What is the purpose of /proc?\*\*



`/proc` is a virtual file system that provides information about running processes and the Linux kernel.



\### Production Notes



Linux administrators frequently use:



\- `/etc` to modify configuration files.

\- `/var/log` to troubleshoot production issues.

\- `/home` to manage user data.

\- `/proc` to inspect process and system information.

\- `/tmp` to check temporary files consuming disk space.



Knowing these directories helps in faster troubleshooting during production incidents.



\## Basic Linux Commands



Linux commands are used to interact with the operating system for managing files, directories, users, processes, services, and system resources. Mastering basic commands is essential for every Linux Administrator and DevOps Engineer.



\### Categories of Linux Commands



```text

Linux Commands

│

├── Navigation

├── File Management

├── Directory Management

├── Search Commands

├── File Viewing

├── System Information

└── Miscellaneous

```



\### Navigation Commands



\#### pwd

Displays the current working directory.



```bash

pwd

```



\#### ls

Lists files and directories.



```bash

ls

ls -l

ls -la

ls -lh

```



\#### cd

Changes the current directory.



```bash

cd /home

cd ..

cd \~

```



\### File Management Commands



\#### touch

Creates an empty file.



```bash

touch file.txt

```



\#### cp

Copies files or directories.



```bash

cp file1 file2

cp -r dir1 dir2

```



\#### mv

Moves or renames files.



```bash

mv file1 /tmp

mv old.txt new.txt

```



\#### rm

Deletes files or directories.



```bash

rm file.txt

rm -r directory

rm -rf directory

```



\### Directory Management Commands



\#### mkdir

Creates a directory.



```bash

mkdir project

mkdir -p project/dev/app

```



\#### rmdir

Removes an empty directory.



```bash

rmdir test

```



\### File Viewing Commands



\#### cat

Displays file contents.



```bash

cat file.txt

```



\#### less



View large files page by page.



```bash

less file.txt

```



\#### head



Displays the first 10 lines.



```bash

head file.txt

head -20 file.txt

```



\#### tail



Displays the last 10 lines.



```bash

tail file.txt

tail -f /var/log/messages

```



\### Search Commands



\#### find



Search files and directories.



```bash

find /home -name "\*.log"

find / -type f

```



\#### grep



Search text inside files.



```bash

grep root /etc/passwd

grep -i error app.log

grep -r nginx /etc

```



\### System Information Commands



```bash

hostname

hostnamectl

whoami

id

date

uptime

uname -a

cat /etc/os-release

```



\### Important Commands



```bash

pwd

ls -la

cd

mkdir

touch

cp

mv

rm

cat

less

head

tail

find

grep

whoami

hostnamectl

uname -a

```



\### Interview Questions



\*\*Q1. Difference between `cp` and `mv`?\*\*



| cp | mv |

|----|----|

| Copies files | Moves or renames files |

| Original file remains | Original file is moved |



\---



\*\*Q2. Difference between `cat`, `less`, and `tail`?\*\*



| Command | Purpose |

|----------|---------|

| cat | Display entire file |

| less | View large files page by page |

| tail | View last lines of a file |



\---



\*\*Q3. How do you search a file in Linux?\*\*



Use the `find` command.



Example:



```bash

find /home -name "test.txt"

```



\---



\*\*Q4. How do you search a word inside a file?\*\*



Use the `grep` command.



Example:



```bash

grep "ERROR" application.log

```



\---



\*\*Q5. Which command is used to monitor logs in real time?\*\*



```bash

tail -f /var/log/messages

```



\### Production Notes



The most frequently used commands in production are:



\- `ls`

\- `cd`

\- `pwd`

\- `find`

\- `grep`

\- `tail -f`

\- `cat`

\- `cp`

\- `mv`

\- `rm`

\- `hostnamectl`

\- `uname -a`



These commands are used daily for log analysis, troubleshooting, configuration verification, and file management on Linux servers.



\## File Permissions



Linux uses a permission-based security model to control who can read, write, or execute files and directories. Every file and directory has an owner, a group, and permission settings.



\### Permission Structure



```text

\-rwxr-xr--



│ │ │

│ │ └── Others

│ └──── Group

└────── Owner

```



\### Permission Types



| Symbol | Value | Meaning |

|--------|------:|---------|

| r | 4 | Read |

| w | 2 | Write |

| x | 1 | Execute |

| - | 0 | No Permission |



\### Permission Classes



\#### Owner (User)

The user who owns the file.



\#### Group

Users belonging to the same group.



\#### Others

All remaining users on the system.



\### Numeric Permissions



| Permission | Value |

|-----------|------:|

| rwx | 7 |

| rw- | 6 |

| r-x | 5 |

| r-- | 4 |

| --- | 0 |



Examples:



| Numeric | Meaning |

|---------|---------|

| 777 | Full permissions for everyone |

| 755 | Owner full, Group \& Others read/execute |

| 644 | Owner read/write, Group \& Others read |

| 600 | Owner read/write only |



\### Important Commands



\#### View Permissions



```bash

ls -l

```



\#### Change Permissions



```bash

chmod 755 file.sh

chmod 644 file.txt

chmod +x script.sh

chmod -R 755 directory

```



\#### Change Owner



```bash

chown user file.txt

chown user:group file.txt

```



\#### Change Group



```bash

chgrp developers file.txt

```



\#### Check Current User



```bash

whoami

id

groups

```



\### Symbolic Permissions



Grant execute permission:



```bash

chmod +x script.sh

```



Remove write permission:



```bash

chmod -w file.txt

```



Add read permission:



```bash

chmod +r file.txt

```



\### Special Permissions



\#### SUID



Runs a program with the owner's privileges.



```bash

chmod 4755 file

```



\#### SGID



Runs with the group's privileges.



```bash

chmod 2755 directory

```



\#### Sticky Bit



Only the owner can delete their files inside the directory.



```bash

chmod 1777 /shared

```



Example:



```text

drwxrwxrwt

```



\### Interview Questions



\*\*Q1. What do the permissions `755` mean?\*\*



Owner has Read, Write, Execute. Group and Others have Read and Execute permissions.



\---



\*\*Q2. Difference between `644` and `755`?\*\*



| 644 | 755 |

|-----|-----|

| Read/Write for Owner | Read/Write/Execute for Owner |

| Read for Group/Others | Read/Execute for Group/Others |

| Used for files | Used for executable files and directories |



\---



\*\*Q3. What is the difference between `chmod` and `chown`?\*\*



| chmod | chown |

|--------|--------|

| Changes permissions | Changes file ownership |



\---



\*\*Q4. What is SUID?\*\*



SUID allows a user to execute a file with the permissions of the file owner.



\---



\*\*Q5. What is Sticky Bit?\*\*



Sticky Bit prevents users from deleting files owned by other users in a shared directory like `/tmp`.



\### Production Notes



Linux administrators commonly use:



\- `chmod 755` for application directories.

\- `chmod 644` for configuration files.

\- `chmod +x` for executable scripts.

\- `chown` after deploying applications.

\- Sticky Bit on shared directories.

\- Always follow the \*\*Principle of Least Privilege\*\* by granting only the minimum required permissions.



\## Users \& Groups



Linux is a multi-user operating system where every user belongs to one or more groups. Users and groups help manage authentication, permissions, and access control.



\### User Management



```text

Linux Users

│

├── Root User

├── System Users

└── Normal Users

```



\#### Root User



\- Superuser with complete administrative privileges.

\- User ID (UID) is \*\*0\*\*.



\#### System Users



\- Created automatically for services.

\- Used by applications like nginx, apache, mysql, and ssh.



Examples:



```text

nginx

mysql

sshd

```



\#### Normal Users



Users created by administrators for daily login and application access.



Example:



```text

ec2-user

ubuntu

john

```



\---



\### Group Management



A group is a collection of users that share common permissions.



Types of Groups:



\- Primary Group

\- Secondary Group



Example:



```text

User: john

Primary Group: developers

Secondary Groups: docker, sudo

```



\---



\### User Information Files



\#### /etc/passwd



Stores user account information.



Example:



```text

john:x:1001:1001:John:/home/john:/bin/bash

```



\#### /etc/shadow



Stores encrypted passwords.



Only the root user can access this file.



\#### /etc/group



Stores group information.



\---



\### Important Commands



\#### Display Current User



```bash

whoami

id

groups

```



\#### Create User



```bash

sudo useradd john

```



\#### Set Password



```bash

sudo passwd john

```



\#### Modify User



```bash

sudo usermod -aG docker john

```



\#### Delete User



```bash

sudo userdel john

```



Delete user with home directory:



```bash

sudo userdel -r john

```



\#### Create Group



```bash

sudo groupadd developers

```



\#### Delete Group



```bash

sudo groupdel developers

```



\#### View Logged-in Users



```bash

who

w

users

```



\---



\### Important Commands



```bash

whoami

id

groups

useradd

usermod

userdel

passwd

groupadd

groupdel

who

w

```



\---



\### Interview Questions



\*\*Q1. What is the difference between Root User and Normal User?\*\*



| Root User | Normal User |

|------------|-------------|

| UID 0 | UID starts from 1000 (generally) |

| Full system access | Limited permissions |

| Can manage all users | Cannot perform admin tasks without sudo |



\---



\*\*Q2. Difference between Primary Group and Secondary Group?\*\*



| Primary Group | Secondary Group |

|---------------|-----------------|

| Default group of a user | Additional groups assigned |

| Only one | Multiple allowed |



\---



\*\*Q3. What is the purpose of `/etc/passwd`?\*\*



It stores user account details such as username, UID, GID, home directory, and login shell.



\---



\*\*Q4. What is `/etc/shadow`?\*\*



It stores encrypted user passwords and password policy information.



\---



\*\*Q5. How do you add an existing user to a group?\*\*



```bash

sudo usermod -aG docker john

```



\---



\### Production Notes



In production environments, administrators commonly:



\- Create users for application access.

\- Assign users to appropriate groups.

\- Use `sudo` instead of logging in as root.

\- Verify user permissions using `id` and `groups`.

\- Remove inactive users to improve security.

\- Follow the \*\*Principle of Least Privilege\*\* by granting only the required access.



\## Process Management



A process is a running instance of a program. Linux provides various commands to monitor, manage, and control processes. Effective process management is essential for troubleshooting and maintaining system performance.



\### Process Lifecycle



```text

Program

&#x20;  │

&#x20;  ▼

Execution

&#x20;  │

&#x20;  ▼

Running Process

&#x20;  │

&#x20;  ├── Running

&#x20;  ├── Sleeping

&#x20;  ├── Waiting

&#x20;  ├── Stopped

&#x20;  └── Zombie

```



\### Process States



\#### Running (R)



The process is currently executing on the CPU.



\#### Sleeping (S)



The process is waiting for an event or resource.



\#### Waiting (D)



The process is waiting for disk or I/O operations.



\#### Stopped (T)



The process has been paused manually or by the system.



\#### Zombie (Z)



The process has completed execution, but its parent process has not yet collected its exit status.



\---



\### Important Commands



\#### Display Running Processes



```bash

ps

ps -ef

ps aux

```



\#### Real-Time Process Monitoring



```bash

top

htop

```



\#### Find Process by Name



```bash

pgrep nginx

pidof nginx

```



\#### Search Process



```bash

ps -ef | grep nginx

```



\#### Kill a Process



```bash

kill PID

kill -9 PID

pkill nginx

killall nginx

```



\#### Process Priority



View priority:



```bash

top

```



Start process with lower priority:



```bash

nice -n 10 command

```



Change priority of a running process:



```bash

renice 5 -p PID

```



\---



\### Important Commands



```bash

ps -ef

ps aux

top

htop

pgrep

pidof

grep

kill

kill -9

pkill

killall

nice

renice

```



\---



\### Interview Questions



\*\*Q1. What is a process?\*\*



A process is a running instance of a program with its own Process ID (PID), memory, and CPU resources.



\---



\*\*Q2. Difference between Program and Process?\*\*



| Program | Process |

|----------|----------|

| Static file | Running instance |

| Stored on disk | Loaded into memory |

| Passive | Active |



\---



\*\*Q3. Difference between `kill` and `kill -9`?\*\*



| kill | kill -9 |

|-------|----------|

| Sends SIGTERM (15) | Sends SIGKILL (9) |

| Process can terminate gracefully | Process is forcefully terminated |



\---



\*\*Q4. How do you find the PID of a process?\*\*



```bash

ps -ef | grep nginx

pgrep nginx

pidof nginx

```



\---



\*\*Q5. What is a Zombie Process?\*\*



A Zombie Process is a completed process whose parent has not yet collected its exit status.



\---



\*\*Q6. Difference between `top` and `htop`?\*\*



| top | htop |

|------|------|

| Default Linux utility | Interactive utility |

| Basic interface | Colorful interface |

| Limited controls | Easy process management |



\---



\### Production Notes



Linux administrators commonly use:



\- `top` or `htop` to monitor CPU and memory usage.

\- `ps -ef` to verify running processes.

\- `pgrep` or `pidof` to quickly locate a process.

\- `kill` to stop unresponsive applications.

\- `kill -9` only when a normal termination fails.

\- `nice` and `renice` to optimize CPU usage for critical applications.



Proper process management helps maintain system stability and resolve production issues efficiently.



\## Service Management



Linux services (also called daemons) are background processes that start automatically or manually to provide system and application functionality. Services are managed using \*\*systemd\*\* and the \*\*systemctl\*\* command in modern Linux distributions.



\### Service Lifecycle



```text

&#x20;       Service

&#x20;          │

&#x20;          ▼

&#x20;     systemd Manager

&#x20;          │

&#x20; -----------------------

&#x20; |     |      |       |

Start Stop Restart Status

```



\### Service States



\#### Active (Running)



The service is currently running and serving requests.



\#### Inactive (Stopped)



The service is installed but not running.



\#### Enabled



The service starts automatically after every system boot.



\#### Disabled



The service does not start automatically during boot.



\#### Failed



The service attempted to start but encountered an error.



\---



\### Important Commands



\#### Check Service Status



```bash

systemctl status nginx

systemctl status sshd

```



\#### Start a Service



```bash

sudo systemctl start nginx

```



\#### Stop a Service



```bash

sudo systemctl stop nginx

```



\#### Restart a Service



```bash

sudo systemctl restart nginx

```



\#### Reload Configuration



```bash

sudo systemctl reload nginx

```



\#### Enable Service at Boot



```bash

sudo systemctl enable nginx

```



\#### Disable Service



```bash

sudo systemctl disable nginx

```



\#### View Failed Services



```bash

systemctl --failed

```



\#### List Running Services



```bash

systemctl list-units --type=service --state=running

```



\#### View Service Logs



```bash

journalctl -u nginx

journalctl -xe

```



\---



\### Important Commands



```bash

systemctl status

systemctl start

systemctl stop

systemctl restart

systemctl reload

systemctl enable

systemctl disable

systemctl is-active

systemctl is-enabled

systemctl --failed

journalctl

```



\---



\### Interview Questions



\*\*Q1. What is a Linux Service?\*\*



A Linux service is a background process (daemon) that performs specific tasks such as running a web server, database, or SSH server.



\---



\*\*Q2. What is systemd?\*\*



Systemd is the default service manager in most modern Linux distributions. It is responsible for starting, stopping, and managing system services.



\---



\*\*Q3. Difference between `restart` and `reload`?\*\*



| Restart | Reload |

|----------|---------|

| Stops and starts the service | Reloads configuration without stopping the service |

| May cause downtime | Usually no downtime |



\---



\*\*Q4. Difference between `enable` and `start`?\*\*



| enable | start |

|---------|-------|

| Starts service automatically after boot | Starts service immediately |

| One-time configuration | Current session only |



\---



\*\*Q5. How do you check why a service failed to start?\*\*



```bash

systemctl status nginx

journalctl -u nginx

journalctl -xe

```



\---



\*\*Q6. How do you check whether a service is enabled?\*\*



```bash

systemctl is-enabled nginx

```



\---



\### Production Notes



Linux administrators commonly:



\- Use `systemctl status` to verify service health.

\- Check logs using `journalctl` before restarting services.

\- Use `reload` instead of `restart` whenever possible to avoid downtime.

\- Enable critical services to start automatically after reboot.

\- Monitor failed services using `systemctl --failed`.



Proper service management helps ensure high availability and quick troubleshooting in production environments.



\## Networking



Networking in Linux enables communication between systems over a network. Linux provides powerful tools to configure network interfaces, troubleshoot connectivity issues, verify DNS resolution, and monitor open ports.



\### Linux Networking Overview



```text

&#x20;         Client

&#x20;            │

&#x20;            ▼

&#x20;     Network Interface

&#x20;            │

&#x20;            ▼

&#x20;       IP Address

&#x20;            │

&#x20;            ▼

&#x20;       Default Gateway

&#x20;            │

&#x20;            ▼

&#x20;           Router

&#x20;            │

&#x20;            ▼

&#x20;         Internet

```



\### Networking Components



\#### IP Address



A unique address assigned to a system for communication.



Example:



```text

192.168.1.10

```



\---



\#### Subnet Mask



Defines the network and host portion of an IP address.



Example:



```text

255.255.255.0

```



\---



\#### Default Gateway



The router used to communicate with other networks.



\---



\#### DNS (Domain Name System)



Converts domain names into IP addresses.



Example:



```text

google.com → 142.250.xxx.xxx

```



\---



\#### Network Interface



Represents the physical or virtual network adapter.



Examples:



```text

eth0

ens5

ens33

```



\---



\### Important Commands



\#### Check IP Address



```bash

ip a

hostname -I

```



\---



\#### Check Routing Table



```bash

ip route

route -n

```



\---



\#### Test Network Connectivity



```bash

ping 8.8.8.8

ping google.com

```



\---



\#### Check Open Ports



```bash

ss -tulnp

netstat -tulnp

```



\---



\#### DNS Lookup



```bash

nslookup google.com

dig google.com

```



\---



\#### Test HTTP Connectivity



```bash

curl https://google.com

wget https://example.com

```



\---



\#### Trace Network Path



```bash

traceroute google.com

tracepath google.com

```



\---



\#### Display Hostname



```bash

hostname

hostnamectl

```



\---



\### Important Commands



```bash

ip a

ip route

hostnamectl

ping

ss -tulnp

netstat -tulnp

curl

wget

nslookup

dig

traceroute

tracepath

```



\---



\### Interview Questions



\*\*Q1. Difference between `ping` and `traceroute`?\*\*



| ping | traceroute |

|------|------------|

| Checks connectivity | Shows complete network path |

| Tests latency | Identifies where packets stop |



\---



\*\*Q2. Difference between `netstat` and `ss`?\*\*



| netstat | ss |

|----------|----|

| Older utility | Modern replacement |

| Slower | Faster |

| Deprecated in many distros | Recommended command |



\---



\*\*Q3. How do you check your server's IP address?\*\*



```bash

ip a

hostname -I

```



\---



\*\*Q4. How do you verify whether a service is listening on a port?\*\*



```bash

ss -tulnp

```



\---



\*\*Q5. How do you troubleshoot if a website is not opening from your Linux server?\*\*



1\. Check IP address



```bash

ip a

```



2\. Verify network connectivity



```bash

ping 8.8.8.8

```



3\. Verify DNS



```bash

nslookup google.com

```



4\. Check routing



```bash

ip route

```



5\. Test HTTP connectivity



```bash

curl https://website.com

```



\---



\*\*Q6. Which file stores DNS server information?\*\*



```text

/etc/resolv.conf

```



\---



\### Production Notes



Linux administrators commonly use:



\- `ip a` to verify network configuration.

\- `ping` to test connectivity.

\- `ss -tulnp` to check listening ports.

\- `curl` to verify application availability.

\- `nslookup` or `dig` to troubleshoot DNS issues.

\- `traceroute` to identify network path failures.



Networking is one of the most important areas of Linux troubleshooting because many production issues are caused by DNS failures, firewall rules, routing problems, or application ports not listening.



\## Logs



Logs are text files that record system events, application activities, user actions, and errors. They are the first place Linux administrators check while troubleshooting production issues.



\### Linux Logging Architecture



```text

Applications

&#x20;     │

&#x20;     ▼

&#x20;System Services

&#x20;     │

&#x20;     ▼

&#x20;rsyslog / systemd-journald

&#x20;     │

&#x20;     ▼

&#x20;   /var/log

&#x20;     │

&#x20;     ├── messages/syslog

&#x20;     ├── secure/auth.log

&#x20;     ├── cron

&#x20;     ├── boot.log

&#x20;     └── application logs

```



\### Common Log Files



\#### /var/log/messages



Stores general system logs.



> Used mainly in \*\*RHEL/CentOS\*\*.



\---



\#### /var/log/syslog



Stores system-wide logs.



> Used mainly in \*\*Ubuntu/Debian\*\*.



\---



\#### /var/log/secure



Stores authentication and security-related logs.



Examples:



\- SSH Login

\- sudo activity

\- Failed login attempts



\---



\#### /var/log/auth.log



Authentication log file in Ubuntu.



Contains:



\- SSH login

\- sudo

\- User authentication



\---



\#### /var/log/boot.log



Contains boot-related logs.



\---



\#### /var/log/cron



Stores cron job execution logs.



\---



\#### /var/log/dmesg



Contains kernel boot messages and hardware information.



\---



\### Important Commands



\#### View Entire Log



```bash

cat /var/log/messages

```



\---



\#### View Large Log File



```bash

less /var/log/messages

```



\---



\#### View Last Lines



```bash

tail /var/log/messages

tail -20 /var/log/messages

```



\---



\#### Monitor Logs in Real Time



```bash

tail -f /var/log/messages

```



\---



\#### Search Logs



```bash

grep ERROR application.log

grep sshd /var/log/secure

grep -i failed /var/log/auth.log

```



\---



\#### View Journal Logs



```bash

journalctl

```



\---



\#### View Service Logs



```bash

journalctl -u nginx

journalctl -u sshd

```



\---



\#### View Boot Logs



```bash

journalctl -b

```



\---



\#### View Recent Logs



```bash

journalctl -n 50

```



\---



\#### View Logs Since Today



```bash

journalctl --since today

```



\---



\### Important Commands



```bash

cat

less

head

tail

tail -f

grep

journalctl

journalctl -u

journalctl -b

```



\---



\### Interview Questions



\*\*Q1. Where are Linux log files stored?\*\*



Most Linux log files are stored under:



```text

/var/log

```



\---



\*\*Q2. Difference between `/var/log/messages` and `/var/log/secure`?\*\*



| /var/log/messages | /var/log/secure |

|-------------------|-----------------|

| General system logs | Authentication \& security logs |

| Services and kernel events | SSH, sudo, login failures |



\---



\*\*Q3. How do you monitor logs in real time?\*\*



```bash

tail -f /var/log/messages

```



\---



\*\*Q4. How do you check logs of a specific service?\*\*



```bash

journalctl -u nginx

```



\---



\*\*Q5. How do you search for an error inside a log file?\*\*



```bash

grep ERROR application.log

```



\---



\*\*Q6. Which command displays logs from the current boot?\*\*



```bash

journalctl -b

```



\---



\### Production Notes



During production troubleshooting, logs are always the first place to investigate.



Common workflow:



1\. Verify service status.



```bash

systemctl status nginx

```



2\. Check service logs.



```bash

journalctl -u nginx

```



3\. Monitor logs in real time.



```bash

tail -f /var/log/messages

```



4\. Search for errors.



```bash

grep -i error /var/log/messages

```



Most production issues such as \*\*application failures, SSH login problems, service crashes, permission issues, and network errors\*\* can be identified quickly by analyzing the appropriate log files.



\## Disk Management



Disk Management in Linux involves monitoring disk usage, managing partitions, mounting file systems, and ensuring sufficient storage for applications and services. Proper disk management helps prevent downtime caused by low disk space.



\### Disk Management Overview



```text

Physical Disk

&#x20;     │

&#x20;     ▼

&#x20;Partition

&#x20;     │

&#x20;     ▼

&#x20;File System

&#x20;     │

&#x20;     ▼

&#x20;Mount Point

&#x20;     │

&#x20;     ▼

&#x20;User/Application

```



\### Disk Components



\#### Physical Disk



Storage devices attached to the server.



Examples:



```text

/dev/sda

/dev/sdb

/dev/nvme0n1

```



\---



\#### Partition



A logical section of a physical disk.



Examples:



```text

/dev/sda1

/dev/sda2

```



\---



\#### File System



A method used to organize and store data.



Common File Systems:



\- ext4

\- xfs

\- btrfs



\---



\#### Mount Point



A directory where a partition is attached.



Examples:



```text

/

&#x20;/home

&#x20;/data

&#x20;/mnt

```



\---



\### Important Commands



\#### Check Disk Usage



```bash

df -h

```



\---



\#### Check Directory Size



```bash

du -sh /var/log

du -sh \*

```



\---



\#### List Block Devices



```bash

lsblk

```



\---



\#### Display Disk Partitions



```bash

fdisk -l

```



\---



\#### Check Mounted File Systems



```bash

mount

findmnt

```



\---



\#### Mount a File System



```bash

mount /dev/sdb1 /data

```



\---



\#### Unmount a File System



```bash

umount /data

```



\---



\#### Display UUID



```bash

blkid

```



\---



\#### File System Information



```bash

df -Th

```



\---



\### Important Commands



```bash

df -h

df -Th

du -sh

lsblk

fdisk -l

mount

umount

findmnt

blkid

```



\---



\### Interview Questions



\*\*Q1. Difference between `df` and `du`?\*\*



| df | du |

|----|----|

| Shows file system usage | Shows directory/file size |

| Checks available disk space | Checks space consumed by files |



\---



\*\*Q2. What is a Mount Point?\*\*



A mount point is a directory where a file system is attached so that Linux can access its contents.



\---



\*\*Q3. Which command displays all disks connected to the server?\*\*



```bash

lsblk

```



\---



\*\*Q4. How do you check disk usage?\*\*



```bash

df -h

```



\---



\*\*Q5. How do you identify which directory is consuming maximum space?\*\*



```bash

du -sh \*

```



or



```bash

du -sh /var/\*

```



\---



\*\*Q6. What is `/etc/fstab`?\*\*



`/etc/fstab` is a configuration file that defines which file systems should be mounted automatically during system boot.



\---



\### Production Notes



Disk-related issues are one of the most common production incidents.



Typical troubleshooting steps:



1\. Check disk usage.



```bash

df -h

```



2\. Identify large directories.



```bash

du -sh /var/\*

```



3\. Check mounted file systems.



```bash

mount

```



4\. Clean old logs, temporary files, or unnecessary backups.



5\. Extend the file system or attach additional storage if required.



Regular monitoring of disk usage helps prevent application failures caused by a full file system.



\## Memory Management



Memory Management in Linux is responsible for efficiently allocating, utilizing, and releasing RAM for running processes. Linux also uses Swap Memory when physical RAM becomes insufficient.



\### Memory Architecture



```text

&#x20;           RAM

&#x20;            │

&#x20;     ----------------

&#x20;     │              │

&#x20;Running Processes   Cache

&#x20;     │

&#x20;     ▼

&#x20; Swap Memory (if RAM is full)

```



\### Memory Components



\#### RAM (Random Access Memory)



RAM stores currently running programs and active processes. It is much faster than disk storage.



\---



\#### Cache



Linux uses free RAM as cache to improve system performance. Cached memory is automatically released when applications require more memory.



\---



\#### Buffers



Buffers temporarily store data during disk read/write operations to improve I/O performance.



\---



\#### Swap Memory



Swap is a reserved disk space used as virtual memory when RAM is exhausted.



Example:



```text

RAM Full

&#x20;   │

&#x20;   ▼

Swap Used

```



\---



\### Important Commands



\#### Check Memory Usage



```bash

free -h

```



\---



\#### Display Virtual Memory Statistics



```bash

vmstat

```



\---



\#### Real-Time Memory Monitoring



```bash

top

htop

```



\---



\#### Check Running Processes



```bash

ps -ef

```



\---



\#### Display Memory Information



```bash

cat /proc/meminfo

```



\---



\#### Display Process Memory Usage



```bash

ps aux --sort=-%mem

```



\---



\#### Check Swap Usage



```bash

swapon --show

```



or



```bash

free -h

```



\---



\### Important Commands



```bash

free -h

vmstat

top

htop

ps aux --sort=-%mem

cat /proc/meminfo

swapon --show

```



\---



\### Interview Questions



\*\*Q1. What is Swap Memory?\*\*



Swap is disk space used as virtual memory when physical RAM becomes full.



\---



\*\*Q2. Difference between RAM and Swap?\*\*



| RAM | Swap |

|-----|------|

| Physical Memory | Disk-based Virtual Memory |

| Very Fast | Slower than RAM |

| Used first | Used only when RAM is exhausted |



\---



\*\*Q3. Which command checks memory usage?\*\*



```bash

free -h

```



\---



\*\*Q4. How do you identify the process consuming the most memory?\*\*



```bash

ps aux --sort=-%mem

```



or



```bash

top

```



\---



\*\*Q5. Why does Linux use Cache memory?\*\*



Linux uses cache to improve system performance by storing frequently accessed data in memory.



\---



\*\*Q6. Which file contains detailed memory information?\*\*



```text

/proc/meminfo

```



\---



\### Production Notes



Memory-related issues are common in production servers.



Typical troubleshooting steps:



1\. Check memory usage.



```bash

free -h

```



2\. Identify high memory-consuming processes.



```bash

ps aux --sort=-%mem

```



3\. Monitor the server.



```bash

top

```



4\. Check Swap usage.



```bash

swapon --show

```



5\. Restart or optimize memory-intensive applications if required.



High memory usage combined with excessive Swap utilization usually indicates memory pressure and may require application tuning or additional RAM.



\## CPU Monitoring



CPU Monitoring is the process of observing CPU utilization, load, and running processes to ensure the Linux system performs efficiently. Monitoring CPU helps identify performance bottlenecks, runaway processes, and resource-intensive applications.



\### CPU Monitoring Overview



```text

&#x20;          CPU

&#x20;           │

&#x20;   ------------------

&#x20;   │       │        │

&#x20;Processes  Load   Utilization

&#x20;           │

&#x20;           ▼

&#x20;     Performance Analysis

```



\### CPU Metrics



\#### CPU Utilization



Represents the percentage of CPU currently being used.



Example:



```text

CPU Usage = 65%

```



\---



\#### Load Average



Shows the average number of processes waiting for CPU resources.



Example:



```text

0.25 0.60 0.90

```



Represents:



\- Last 1 minute

\- Last 5 minutes

\- Last 15 minutes



\---



\#### Idle CPU



The percentage of CPU that is not being used.



Higher Idle means lower CPU utilization.



\---



\#### CPU Core



A CPU may contain multiple cores capable of executing processes simultaneously.



Check CPU information:



```bash

lscpu

```



\---



\### Important Commands



\#### Monitor CPU Usage



```bash

top

```



\---



\#### Advanced Interactive Monitoring



```bash

htop

```



\---



\#### Display CPU Information



```bash

lscpu

```



\---



\#### Display System Load



```bash

uptime

```



\---



\#### CPU Statistics



```bash

mpstat

```



\---



\#### Display Running Processes



```bash

ps -ef

```



\---



\#### Top CPU Consuming Processes



```bash

ps aux --sort=-%cpu

```



\---



\#### Real-Time Process Monitoring



```bash

top

```



\---



\### Important Commands



```bash

top

htop

uptime

lscpu

mpstat

ps -ef

ps aux --sort=-%cpu

```



\---



\### Interview Questions



\*\*Q1. How do you check CPU utilization?\*\*



```bash

top

```



or



```bash

htop

```



\---



\*\*Q2. Which command shows CPU architecture?\*\*



```bash

lscpu

```



\---



\*\*Q3. What does Load Average mean?\*\*



Load Average indicates the average number of processes waiting for CPU over the last 1, 5, and 15 minutes.



\---



\*\*Q4. How do you find the highest CPU-consuming process?\*\*



```bash

ps aux --sort=-%cpu

```



\---



\*\*Q5. Which command displays CPU statistics?\*\*



```bash

mpstat

```



\---



\*\*Q6. Difference between CPU Utilization and Load Average?\*\*



| CPU Utilization | Load Average |

|-----------------|--------------|

| Percentage of CPU in use | Number of processes waiting for CPU |

| Indicates current CPU usage | Indicates system workload |



\---



\### Production Notes



CPU spikes are common in production environments due to application issues or high traffic.



Typical troubleshooting steps:



1\. Check CPU utilization.



```bash

top

```



2\. Identify the highest CPU-consuming process.



```bash

ps aux --sort=-%cpu

```



3\. Verify system load.



```bash

uptime

```



4\. Check application and system logs.



```bash

journalctl

```



5\. Restart or optimize the affected application if necessary.



Continuous CPU monitoring helps prevent performance degradation and ensures system stability.



\## SSH (Secure Shell)



SSH (Secure Shell) is a secure network protocol used to remotely access and manage Linux servers over an encrypted connection. It is widely used by Linux administrators for server management, file transfer, and remote troubleshooting.



\### SSH Architecture



```text

&#x20;       SSH Client

&#x20;            │

&#x20;    Encrypted Connection

&#x20;            │

&#x20;    Port 22 (Default)

&#x20;            │

&#x20;            ▼

&#x20;       SSH Server

&#x20;            │

&#x20;            ▼

&#x20;      Linux Machine

```



\### SSH Components



\#### SSH Client



The system from which you connect to a remote server.



Examples:



```text

Windows

Linux

macOS

```



\---



\#### SSH Server



The Linux machine that accepts incoming SSH connections.



SSH Service:



```text

sshd

```



\---



\#### Port



By default, SSH uses \*\*TCP Port 22\*\*.



Example:



```text

22/tcp

```



\---



\#### Authentication



SSH supports two authentication methods:



\- Password Authentication

\- SSH Key Authentication (Recommended)



\---



\### Important Commands



\#### Connect to a Remote Server



```bash

ssh user@192.168.1.10

```



Example:



```bash

ssh ec2-user@10.0.0.15

```



\---



\#### Connect Using a Private Key



```bash

ssh -i aws-key.pem ec2-user@54.xx.xx.xx

```



\---



\#### Copy File to Remote Server



```bash

scp file.txt user@192.168.1.10:/home/user

```



\---



\#### Copy File from Remote Server



```bash

scp user@192.168.1.10:/tmp/file.txt .

```



\---



\#### Check SSH Service Status



```bash

systemctl status sshd

```



\---



\#### Restart SSH Service



```bash

systemctl restart sshd

```



\---



\#### Check SSH Port



```bash

ss -tulnp | grep ssh

```



\---



\#### SSH Configuration File



```text

/etc/ssh/sshd\_config

```



Restart SSH after configuration changes:



```bash

systemctl restart sshd

```



\---



\### Important Commands



```bash

ssh

scp

ssh-keygen

systemctl status sshd

systemctl restart sshd

ss -tulnp

cat /etc/ssh/sshd\_config

```



\---



\### Interview Questions



\*\*Q1. What is SSH?\*\*



SSH (Secure Shell) is a secure protocol used to remotely access and manage Linux servers over an encrypted connection.



\---



\*\*Q2. Which port does SSH use?\*\*



By default, SSH uses \*\*TCP Port 22\*\*.



\---



\*\*Q3. Difference between Password Authentication and Key-Based Authentication?\*\*



| Password Authentication | Key-Based Authentication |

|-------------------------|--------------------------|

| Uses username and password | Uses public/private key pair |

| Less secure | More secure |

| Suitable for testing | Recommended for production |



\---



\*\*Q4. Which file stores SSH server configuration?\*\*



```text

/etc/ssh/sshd\_config

```



\---



\*\*Q5. How do you verify whether the SSH service is running?\*\*



```bash

systemctl status sshd

```



\---



\*\*Q6. How do you troubleshoot if SSH is not working?\*\*



1\. Check SSH service.



```bash

systemctl status sshd

```



2\. Verify Port 22 is listening.



```bash

ss -tulnp | grep ssh

```



3\. Check firewall rules.



```bash

firewall-cmd --list-all

```



4\. Verify Security Group (AWS).



5\. Review SSH logs.



RHEL/CentOS:



```bash

tail -f /var/log/secure

```



Ubuntu:



```bash

tail -f /var/log/auth.log

```



\---



\### Production Notes



SSH is one of the most critical services in Linux administration.



Common production checks:



\- Verify `sshd` service is running.

\- Ensure Port \*\*22\*\* is open.

\- Use \*\*SSH Key Authentication\*\* instead of passwords.

\- Disable root login whenever possible.

\- Monitor failed login attempts through authentication logs.

\- Keep SSH configuration secure to prevent unauthorized access.



SSH troubleshooting is one of the most frequently asked interview topics for Linux and AWS administrators.



\## Cron Jobs



A Cron Job is a scheduled task in Linux used to automate repetitive tasks such as backups, log cleanup, report generation, and application maintenance. Cron runs tasks automatically at specified dates and times.



\### Cron Architecture



```text

&#x20;           User

&#x20;             │

&#x20;             ▼

&#x20;       crontab Entry

&#x20;             │

&#x20;             ▼

&#x20;        cron Service

&#x20;             │

&#x20;             ▼

&#x20;     Executes Scheduled Job

&#x20;             │

&#x20;             ▼

&#x20;  Script / Command / Program

```



\### Cron Components



\#### cron Service



The background service responsible for executing scheduled jobs.



Check service status:



```bash

systemctl status crond

```



or (Ubuntu)



```bash

systemctl status cron

```



\---



\#### crontab



A file containing scheduled tasks for a user.



Edit crontab:



```bash

crontab -e

```



View existing jobs:



```bash

crontab -l

```



Remove all jobs:



```bash

crontab -r

```



\---



\### Cron Time Format



```text

\* \* \* \* \* command

│ │ │ │ │

│ │ │ │ └── Day of Week (0-7)

│ │ │ └──── Month (1-12)

│ │ └────── Day of Month (1-31)

│ └──────── Hour (0-23)

└────────── Minute (0-59)

```



\---



\### Common Cron Examples



\#### Run Every Day at 2:00 AM



```cron

0 2 \* \* \* /home/ec2-user/backup.sh

```



\---



\#### Run Every 5 Minutes



```cron

\*/5 \* \* \* \* /home/ec2-user/health\_check.sh

```



\---



\#### Run Every Hour



```cron

0 \* \* \* \* /home/ec2-user/script.sh

```



\---



\#### Run Every Sunday at 11 PM



```cron

0 23 \* \* 0 /home/ec2-user/cleanup.sh

```



\---



\#### Run at System Startup



```cron

@reboot /home/ec2-user/startup.sh

```



\---



\### Important Commands



\#### Edit Cron Jobs



```bash

crontab -e

```



\---



\#### List Cron Jobs



```bash

crontab -l

```



\---



\#### Remove Cron Jobs



```bash

crontab -r

```



\---



\#### Check Cron Service



RHEL/CentOS



```bash

systemctl status crond

```



Ubuntu



```bash

systemctl status cron

```



\---



\#### View Cron Logs



RHEL/CentOS



```bash

grep CRON /var/log/cron

```



Ubuntu



```bash

grep CRON /var/log/syslog

```



\---



\### Important Commands



```bash

crontab -e

crontab -l

crontab -r

systemctl status crond

systemctl restart crond

grep CRON /var/log/cron

```



\---



\### Interview Questions



\*\*Q1. What is Cron?\*\*



Cron is a Linux scheduler that automatically executes commands or scripts at specified times.



\---



\*\*Q2. What is crontab?\*\*



Crontab is a file that stores scheduled jobs for a user.



\---



\*\*Q3. How do you list all Cron Jobs?\*\*



```bash

crontab -l

```



\---



\*\*Q4. How do you edit a Cron Job?\*\*



```bash

crontab -e

```



\---



\*\*Q5. What does this Cron expression mean?\*\*



```cron

0 2 \* \* \*

```



It executes the job \*\*every day at 2:00 AM\*\*.



\---



\*\*Q6. How do you troubleshoot a Cron Job that is not running?\*\*



1\. Verify Cron service.



```bash

systemctl status crond

```



2\. Check Cron entry.



```bash

crontab -l

```



3\. Verify script permissions.



```bash

chmod +x script.sh

```



4\. Use absolute paths in scripts.



5\. Check Cron logs.



```bash

grep CRON /var/log/cron

```



\---



\### Production Notes



Cron Jobs are extensively used in production for:



\- Daily database backups

\- Log rotation and cleanup

\- Disk usage monitoring

\- Health check scripts

\- Report generation

\- Automated maintenance tasks



Always test Cron Jobs manually before scheduling them and monitor execution logs to ensure successful completion.



\## Bash Scripting



Bash Scripting is the process of writing a series of Linux commands in a file and executing them automatically. It helps automate repetitive tasks such as backups, monitoring, deployments, log cleanup, and health checks.



\### Bash Script Workflow



```text

Script (.sh)

&#x20;     │

&#x20;     ▼

Bash Interpreter

&#x20;     │

&#x20;     ▼

Execute Commands

&#x20;     │

&#x20;     ▼

Output / Automation

```



\### Basic Script Structure



```bash

\#!/bin/bash



echo "Hello World"

```



\- `#!/bin/bash` → Specifies the Bash interpreter.

\- `echo` → Prints output to the terminal.



\---



\### Variables



Variables store values that can be reused in the script.



```bash

\#!/bin/bash



NAME="John"

AGE=25



echo "Name: $NAME"

echo "Age: $AGE"

```



\---



\### User Input



```bash

\#!/bin/bash



read -p "Enter your name: " NAME



echo "Welcome $NAME"

```



\---



\### Command Line Arguments



```bash

\#!/bin/bash



echo "First Argument: $1"

echo "Second Argument: $2"

echo "Total Arguments: $#"

```



Run:



```bash

./script.sh Linux AWS

```



\---



\### Conditional Statements



\#### if



```bash

\#!/bin/bash



NUM=10



if \[ $NUM -gt 5 ]

then

&#x20;   echo "Greater"

fi

```



\---



\#### if...else



```bash

\#!/bin/bash



if \[ -f test.txt ]

then

&#x20;   echo "File Exists"

else

&#x20;   echo "File Not Found"

fi

```



\---



\### Loops



\#### for Loop



```bash

\#!/bin/bash



for i in 1 2 3 4 5

do

&#x20;   echo $i

done

```



\---



\#### while Loop



```bash

\#!/bin/bash



COUNT=1



while \[ $COUNT -le 5 ]

do

&#x20;   echo $COUNT

&#x20;   COUNT=$((COUNT+1))

done

```



\---



\### Functions



```bash

\#!/bin/bash



greet() {

&#x20;   echo "Welcome to Linux"

}



greet

```



\---



\### Common Linux Commands in Scripts



```bash

df -h

free -h

uptime

hostname

whoami

date

```



\---



\### Make Script Executable



```bash

chmod +x script.sh

```



Run the script:



```bash

./script.sh

```



\---



\### Debug a Script



```bash

bash -x script.sh

```



\---



\### Important Commands



```bash

bash

chmod +x

read

echo

if

for

while

function

exit

bash -x

```



\---



\### Interview Questions



\*\*Q1. What is Bash Scripting?\*\*



Bash Scripting is the process of automating Linux tasks by writing commands inside a shell script.



\---



\*\*Q2. What is the purpose of `#!/bin/bash`?\*\*



It specifies that the script should be executed using the Bash interpreter.



\---



\*\*Q3. How do you pass arguments to a Bash Script?\*\*



```bash

./script.sh arg1 arg2

```



Access them using:



```bash

$1

$2

$#

```



\---



\*\*Q4. How do you make a script executable?\*\*



```bash

chmod +x script.sh

```



\---



\*\*Q5. How do you debug a Bash Script?\*\*



```bash

bash -x script.sh

```



\---



\*\*Q6. Name some real-world Bash Scripts you have written.\*\*



Examples:



\- Disk Monitoring Script

\- CPU Monitoring Script

\- Memory Monitoring Script

\- Service Monitoring Script

\- Health Check Script

\- Backup Script



\---



\### Production Notes



Bash Scripting is widely used in production to automate repetitive administrative tasks.



Common use cases:



\- Server Health Checks

\- Disk Usage Alerts

\- CPU \& Memory Monitoring

\- Service Status Checks

\- Automated Backups

\- Log Cleanup

\- User Management

\- Application Deployment



Automation through Bash reduces manual effort, minimizes human error, and improves operational efficiency.



\## Production Troubleshooting



Production troubleshooting is the process of identifying, analyzing, and resolving issues affecting Linux servers or applications with minimum downtime. A Linux Administrator should always follow a structured approach instead of randomly executing commands.



\### Troubleshooting Flow



```text

Incident Report

&#x20;     │

&#x20;     ▼

Understand the Issue

&#x20;     │

&#x20;     ▼

Check Server Reachability

&#x20;     │

&#x20;     ▼

Check Server Health

&#x20;     │

&#x20;     ▼

Check Service Status

&#x20;     │

&#x20;     ▼

Check Logs

&#x20;     │

&#x20;     ▼

Identify Root Cause

&#x20;     │

&#x20;     ▼

Apply Fix

&#x20;     │

&#x20;     ▼

Validate the Solution

&#x20;     │

&#x20;     ▼

Perform RCA

```



\---



\## Common Production Scenarios



\### 1. Website is Down



\*\*Answer:\*\*



First, I will verify whether the issue is affecting all users or only a specific user.



\*\*Step 1:\*\* Check server connectivity.

\- Verify whether the server is reachable using Ping or SSH.

\- If the server is unreachable, I will investigate the network, firewall, or AWS Security Group.



\*\*Step 2:\*\* Check the overall server health.

\- Verify CPU, Memory, Disk utilization and Load Average.

\- If any resource is exhausted, identify the reason before proceeding.



\*\*Step 3:\*\* Check whether the web service is running.

\- Verify the status of Nginx, Apache, or Tomcat.

\- If the service is stopped, identify why it stopped instead of directly restarting it.



\*\*Step 4:\*\* Verify the application port.

\- Ensure Port 80 or 443 is in the LISTEN state.



\*\*Step 5:\*\* Review application and system logs.

\- Check for configuration errors, permission issues, or application crashes.



\*\*Step 6:\*\* Verify DNS and application response.

\- Test the application locally from the server.



\*\*Step 7:\*\* Apply the fix.

\- Restart the service only if required.

\- Fix configuration, permission, disk, or application issues.



\*\*Step 8:\*\* Validate.

\- Verify the website is accessible.

\- Monitor logs for a few minutes.



\*\*Step 9:\*\* Document the RCA.



\---



\### 2. SSH is Not Working



\*\*Answer:\*\*



\*\*Step 1:\*\* Verify whether the server is reachable.



\*\*Step 2:\*\* Check whether the SSH service is running.



\*\*Step 3:\*\* Verify that Port 22 is listening.



\*\*Step 4:\*\* Check Firewall and AWS Security Group.



\*\*Step 5:\*\* Review authentication logs.



\*\*Step 6:\*\* Verify SSH configuration.



\*\*Step 7:\*\* Restart SSH service only if required.



\*\*Step 8:\*\* Validate SSH login.



\---



\### 3. CPU Usage is 100%



\*\*Answer:\*\*



\*\*Step 1:\*\* Check current CPU utilization.



\*\*Step 2:\*\* Identify the process consuming maximum CPU.



\*\*Step 3:\*\* Verify whether it is expected or abnormal.



\*\*Step 4:\*\* Review application logs.



\*\*Step 5:\*\* Optimize or restart the application if required.



\*\*Step 6:\*\* Monitor CPU after the fix.



\---



\### 4. Memory Usage is High



\*\*Answer:\*\*



\*\*Step 1:\*\* Check memory and swap utilization.



\*\*Step 2:\*\* Identify the highest memory-consuming process.



\*\*Step 3:\*\* Verify whether there is a memory leak.



\*\*Step 4:\*\* Check application logs.



\*\*Step 5:\*\* Restart or optimize the application if necessary.



\*\*Step 6:\*\* Continue monitoring memory usage.



\---



\### 5. Disk Usage is 100%



\*\*Answer:\*\*



\*\*Step 1:\*\* Verify disk usage.



\*\*Step 2:\*\* Identify which filesystem is full.



\*\*Step 3:\*\* Find the directory consuming maximum space.



\*\*Step 4:\*\* Check logs, backups, temporary files, and old data.



\*\*Step 5:\*\* Remove unnecessary files or extend storage.



\*\*Step 6:\*\* Verify available space after cleanup.



\---



\### 6. Service Failed to Start



\*\*Answer:\*\*



\*\*Step 1:\*\* Check service status.



\*\*Step 2:\*\* Review service logs.



\*\*Step 3:\*\* Verify configuration files.



\*\*Step 4:\*\* Check permissions and dependencies.



\*\*Step 5:\*\* Fix the issue and restart the service.



\*\*Step 6:\*\* Verify service health.



\---



\### 7. DNS Resolution Issue



\*\*Answer:\*\*



\*\*Step 1:\*\* Verify IP connectivity.



\*\*Step 2:\*\* Test DNS resolution.



\*\*Step 3:\*\* Check DNS configuration.



\*\*Step 4:\*\* Verify network routing.



\*\*Step 5:\*\* Test the application again.



\---



\### 8. Permission Denied



\*\*Answer:\*\*



\*\*Step 1:\*\* Verify the current user.



\*\*Step 2:\*\* Check file ownership.



\*\*Step 3:\*\* Verify file permissions.



\*\*Step 4:\*\* Correct ownership or permissions if required.



\*\*Step 5:\*\* Validate access.



\---



\## General Troubleshooting Checklist



Before making any changes, always verify:



\- Server Reachability

\- CPU Utilization

\- Memory Utilization

\- Disk Utilization

\- Load Average

\- Running Services

\- Listening Ports

\- Logs

\- Network Connectivity

\- DNS Resolution

\- Application Status



\---



\## Production Best Practices



\- Never restart a service without checking logs.

\- Always identify the root cause before applying a fix.

\- Validate the application after every change.

\- Document the RCA after resolving the issue.

\- Escalate to the Application Team if the issue is application-related.

\- Monitor the server after implementing the solution.





\## Linux Interview Questions



These are some of the most frequently asked Linux interview questions for Linux Administrator, AWS Operations, and DevOps Engineer roles.



\---



\### Q1. What is Linux?



Linux is an open-source operating system that manages hardware resources and provides an interface for users and applications to interact with the system.



\---



\### Q2. What is the Kernel?



Kernel is the core component of Linux responsible for:



\- Process Management

\- Memory Management

\- Device Management

\- File System Management

\- Networking

\- Security



\---



\### Q3. Difference between Kernel and Shell?



| Kernel | Shell |

|--------|-------|

| Core of Operating System | Command Interpreter |

| Manages Hardware Resources | Accepts User Commands |

| Always Running | Starts when User Logs In |



\---



\### Q4. What is the Linux File System?



Linux File System is a hierarchical structure that starts from the Root (/) directory and stores all files and directories.



\---



\### Q5. Difference between Hard Link and Soft Link?



| Hard Link | Soft Link |

|-----------|-----------|

| Shares the same inode | Has a different inode |

| Cannot cross file systems | Can cross file systems |

| Works even if original file is deleted | Breaks if original file is deleted |



\---



\### Q6. Difference between ext4 and XFS?



| ext4 | XFS |

|------|-----|

| General-purpose file system | Enterprise-grade file system |

| Faster recovery | Better for large files |

| Common in Ubuntu | Default in RHEL/CentOS |



\---



\### Q7. Difference between cp and mv?



| cp | mv |

|----|----|

| Copies files | Moves or renames files |

| Original file remains | Original file is moved |



\---



\### Q8. Difference between kill and kill -9?



| kill | kill -9 |

|-------|----------|

| Sends SIGTERM | Sends SIGKILL |

| Allows graceful shutdown | Immediately terminates the process |



\---



\### Q9. Difference between systemctl restart and reload?



| Restart | Reload |

|----------|---------|

| Stops and starts the service | Reloads configuration without stopping the service |

| May cause downtime | Usually no downtime |



\---



\### Q10. Difference between enable and start?



| enable | start |

|---------|-------|

| Starts service automatically after boot | Starts service immediately |

| Permanent configuration | Current session only |



\---



\### Q11. Difference between df and du?



| df | du |

|----|----|

| Shows file system usage | Shows directory/file size |

| Checks available disk space | Checks consumed disk space |



\---



\### Q12. Difference between RAM and Swap?



| RAM | Swap |

|-----|------|

| Physical Memory | Virtual Memory |

| Faster | Slower |

| Used first | Used when RAM is full |



\---



\### Q13. Difference between netstat and ss?



| netstat | ss |

|----------|----|

| Older command | Modern replacement |

| Slower | Faster |

| Deprecated in many distributions | Recommended |



\---



\### Q14. Difference between Password Authentication and SSH Key Authentication?



| Password Authentication | SSH Key Authentication |

|-------------------------|--------------------------|

| Uses username/password | Uses public/private key |

| Less secure | More secure |

| Suitable for testing | Recommended for production |



\---



\### Q15. What is Cron?



Cron is a Linux scheduler used to execute commands or scripts automatically at specified times.



\---



\### Q16. What is Bash Scripting?



Bash Scripting is the process of automating Linux tasks by writing commands in a shell script.



\---



\### Q17. How do you troubleshoot a website that is down?



My troubleshooting approach would be:



1\. Verify server connectivity.

2\. Check CPU, Memory, Disk, and Load.

3\. Verify application service.

4\. Check listening ports.

5\. Review application and system logs.

6\. Verify DNS and network connectivity.

7\. Apply the fix.

8\. Validate the application.

9\. Document the RCA.



\---



\### Q18. How do you troubleshoot high CPU utilization?



1\. Check CPU usage.

2\. Identify the process consuming high CPU.

3\. Review application logs.

4\. Optimize or restart the application.

5\. Monitor the server.



\---



\### Q19. How do you troubleshoot SSH failure?



1\. Verify server reachability.

2\. Check SSH service.

3\. Verify Port 22.

4\. Check Firewall and Security Group.

5\. Review authentication logs.

6\. Validate SSH configuration.



\---



\### Q20. What is Root Cause Analysis (RCA)?



Root Cause Analysis (RCA) is the process of identifying the actual cause of an incident, resolving it, and implementing preventive measures to avoid future occurrences.



\---



\### Interview Tip



Always answer troubleshooting questions in a structured approach:



\*\*Verify → Analyze → Identify Root Cause → Fix → Validate → RCA\*\*



This approach reflects real-world production experience and is highly appreciated by interviewers.



\## Linux Command Cheat Sheet



This section contains the most commonly used Linux commands for day-to-day administration, production support, and interview revision.



\---



\## System Information



| Command | Description |

|----------|-------------|

| `hostname` | Display hostname |

| `hostnamectl` | Show system information |

| `uname -a` | Display kernel information |

| `cat /etc/os-release` | Display OS version |

| `uptime` | Show system uptime and load |

| `date` | Display current date and time |

| `whoami` | Display current user |

| `id` | Display user and group IDs |



\---



\## Navigation Commands



| Command | Description |

|----------|-------------|

| `pwd` | Print current directory |

| `ls` | List files |

| `ls -l` | Long listing |

| `ls -la` | Show hidden files |

| `cd` | Change directory |

| `cd ..` | Move one directory back |

| `cd \~` | Go to home directory |



\---



\## File \& Directory Management



| Command | Description |

|----------|-------------|

| `touch file` | Create file |

| `mkdir dir` | Create directory |

| `mkdir -p` | Create nested directories |

| `cp` | Copy files |

| `mv` | Move/Rename files |

| `rm file` | Delete file |

| `rm -rf dir` | Delete directory recursively |

| `find` | Search files |

| `tree` | Display directory structure |



\---



\## File Viewing



| Command | Description |

|----------|-------------|

| `cat` | Display file content |

| `less` | View large files |

| `head` | First 10 lines |

| `tail` | Last 10 lines |

| `tail -f` | Monitor log file |



\---



\## File Permissions



| Command | Description |

|----------|-------------|

| `ls -l` | View permissions |

| `chmod` | Change permissions |

| `chown` | Change owner |

| `chgrp` | Change group |



Examples:



```bash

chmod 755 script.sh

chmod 644 file.txt

chown user:user file.txt

```



\---



\## User Management



| Command | Description |

|----------|-------------|

| `useradd` | Create user |

| `usermod` | Modify user |

| `userdel -r` | Delete user |

| `passwd` | Set password |

| `groupadd` | Create group |

| `groupdel` | Delete group |

| `groups` | Display groups |

| `who` | Logged-in users |



\---



\## Process Management



| Command | Description |

|----------|-------------|

| `ps -ef` | Running processes |

| `top` | CPU \& Memory usage |

| `htop` | Interactive monitoring |

| `kill PID` | Stop process |

| `kill -9 PID` | Force stop |

| `pkill` | Kill by name |

| `nice` | Start with priority |

| `renice` | Change priority |



\---



\## Service Management



| Command | Description |

|----------|-------------|

| `systemctl status` | Service status |

| `systemctl start` | Start service |

| `systemctl stop` | Stop service |

| `systemctl restart` | Restart service |

| `systemctl reload` | Reload configuration |

| `systemctl enable` | Enable at boot |

| `systemctl disable` | Disable at boot |

| `journalctl -u` | View service logs |



\---



\## Networking



| Command | Description |

|----------|-------------|

| `ip a` | IP Address |

| `ip route` | Routing table |

| `ping` | Connectivity check |

| `ss -tulnp` | Listening ports |

| `curl` | Test URL |

| `wget` | Download files |

| `nslookup` | DNS lookup |

| `dig` | DNS details |

| `traceroute` | Network path |



\---



\## Logs



| Command | Description |

|----------|-------------|

| `tail -f` | Live log monitoring |

| `grep` | Search logs |

| `journalctl` | System logs |

| `journalctl -u service` | Service logs |

| `journalctl -b` | Boot logs |



\---



\## Disk Management



| Command | Description |

|----------|-------------|

| `df -h` | Disk usage |

| `du -sh` | Directory size |

| `lsblk` | Block devices |

| `fdisk -l` | Disk partitions |

| `mount` | Mounted file systems |

| `umount` | Unmount file system |

| `blkid` | UUID information |



\---



\## Memory Management



| Command | Description |

|----------|-------------|

| `free -h` | Memory usage |

| `vmstat` | Virtual memory statistics |

| `cat /proc/meminfo` | Memory details |

| `swapon --show` | Swap information |



\---



\## CPU Monitoring



| Command | Description |

|----------|-------------|

| `top` | CPU usage |

| `htop` | Interactive monitoring |

| `uptime` | Load Average |

| `lscpu` | CPU information |

| `mpstat` | CPU statistics |

| `ps aux --sort=-%cpu` | Highest CPU process |



\---



\## SSH



| Command | Description |

|----------|-------------|

| `ssh user@host` | Remote login |

| `scp` | Secure file copy |

| `ssh-keygen` | Generate SSH key |

| `systemctl status sshd` | SSH service |

| `ss -tulnp` | Check Port 22 |



\---



\## Cron Jobs



| Command | Description |

|----------|-------------|

| `crontab -e` | Edit cron jobs |

| `crontab -l` | List cron jobs |

| `crontab -r` | Remove cron jobs |

| `systemctl status crond` | Cron service |



\---



\## Bash Scripting



| Command | Description |

|----------|-------------|

| `chmod +x script.sh` | Make executable |

| `./script.sh` | Execute script |

| `bash script.sh` | Run script |

| `bash -x script.sh` | Debug script |



\---



\## Top 20 Commands Used Daily in Production



```bash

pwd

ls -la

cd

find

grep

cat

tail -f

top

free -h

df -h

du -sh

ps -ef

systemctl status

journalctl

ip a

ss -tulnp

curl

ssh

chmod

chown

```



\---



\## Quick Troubleshooting Checklist



✅ Check Server Reachability



✅ Check CPU Utilization



✅ Check Memory Utilization



✅ Check Disk Utilization



✅ Check Running Services



✅ Check Listening Ports



✅ Check Logs



✅ Check Network Connectivity



✅ Check DNS Resolution



✅ Validate the Application



\---



> \*\*Tip:\*\* In production, always follow this sequence:

>

> \*\*Connectivity → Server Health → Service Status → Ports → Logs → Root Cause → Fix → Validation → RCA\*\*

