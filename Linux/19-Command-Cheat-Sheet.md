# 📋 Linux Command Cheat Sheet

This cheat sheet contains the most commonly used Linux commands for daily administration, troubleshooting, and production support.

---

# 📂 Navigation Commands

| Command | Description |
|---------|-------------|
| `pwd` | Show current directory |
| `ls` | List files and directories |
| `ls -l` | Long listing |
| `ls -la` | Show hidden files |
| `cd` | Change directory |
| `cd ..` | Move one directory back |
| `cd ~` | Go to home directory |

---

# 📁 File & Directory Commands

| Command | Description |
|---------|-------------|
| `touch file.txt` | Create a file |
| `mkdir test` | Create directory |
| `mkdir -p dir1/dir2` | Create nested directories |
| `cp file1 file2` | Copy file |
| `mv old new` | Move/Rename file |
| `rm file` | Remove file |
| `rm -rf dir` | Remove directory recursively |

---

# 🔐 Permissions

| Command | Description |
|---------|-------------|
| `ls -l` | View permissions |
| `chmod 755 file` | Change permissions |
| `chmod +x script.sh` | Make executable |
| `chown user file` | Change owner |
| `chgrp group file` | Change group |

---

# 👤 Users & Groups

| Command | Description |
|---------|-------------|
| `useradd user` | Create user |
| `passwd user` | Set password |
| `usermod -aG group user` | Add user to group |
| `groupadd group` | Create group |
| `id user` | Show user information |
| `groups user` | Show user groups |

---

# ⚙️ Process Management

| Command | Description |
|---------|-------------|
| `ps -ef` | List processes |
| `top` | Real-time monitoring |
| `htop` | Interactive monitoring |
| `pgrep nginx` | Find process |
| `kill PID` | Graceful stop |
| `kill -9 PID` | Force stop |

---

# 🔧 Service Management

| Command | Description |
|---------|-------------|
| `systemctl status service` | Service status |
| `systemctl start service` | Start service |
| `systemctl stop service` | Stop service |
| `systemctl restart service` | Restart service |
| `systemctl enable service` | Enable at boot |
| `systemctl --failed` | Failed services |

---

# 🌐 Networking

| Command | Description |
|---------|-------------|
| `ip a` | IP address |
| `ip route` | Routing table |
| `ping host` | Connectivity test |
| `ss -tunlp` | Listening ports |
| `curl URL` | Test HTTP/HTTPS |
| `wget URL` | Download file |
| `nslookup domain` | DNS lookup |
| `dig domain` | DNS lookup |
| `traceroute host` | Trace route |

---

# 📜 Logs

| Command | Description |
|---------|-------------|
| `tail -f file` | Monitor logs |
| `journalctl` | System logs |
| `journalctl -u service` | Service logs |
| `grep error file` | Search logs |
| `head file` | First 10 lines |
| `tail file` | Last 10 lines |

---

# 💾 Disk Management

| Command | Description |
|---------|-------------|
| `df -h` | Disk usage |
| `df -i` | Inode usage |
| `du -sh dir` | Directory size |
| `lsblk` | List disks |
| `fdisk -l` | Partition details |
| `mount` | Mounted filesystems |
| `umount /mnt` | Unmount filesystem |
| `blkid` | Display UUID |

---

# 🧠 Memory Management

| Command | Description |
|---------|-------------|
| `free -h` | Memory usage |
| `vmstat` | Memory statistics |
| `cat /proc/meminfo` | Memory details |
| `swapon --show` | Swap usage |

---

# ⚡ CPU Monitoring

| Command | Description |
|---------|-------------|
| `top` | CPU monitoring |
| `uptime` | Load average |
| `mpstat` | CPU statistics |
| `sar -u` | CPU utilization |
| `lscpu` | CPU information |
| `nproc` | CPU cores |

---

# 🔐 SSH

| Command | Description |
|---------|-------------|
| `ssh user@host` | SSH login |
| `ssh -i key.pem user@host` | Login using key |
| `scp file user@host:/path` | Copy file |
| `sftp user@host` | Secure file transfer |
| `ssh-keygen` | Generate SSH keys |
| `ssh-copy-id user@host` | Copy public key |

---

# ⏰ Cron

| Command | Description |
|---------|-------------|
| `crontab -l` | List cron jobs |
| `crontab -e` | Edit cron jobs |
| `crontab -r` | Remove cron jobs |
| `systemctl status crond` | Cron service status |

---

# 🖥️ Bash Scripting

| Command | Description |
|---------|-------------|
| `bash script.sh` | Run script |
| `chmod +x script.sh` | Make executable |
| `./script.sh` | Execute script |

---

# 🚀 Daily Production Commands

```bash
top
free -h
df -h
ip a
ip route
ss -tunlp
systemctl status nginx
systemctl status sshd
journalctl -u nginx
journalctl -u sshd
tail -f /var/log/messages
tail -f /var/log/secure
ps -ef
lsblk
mount
uptime
vmstat
```

---

# 💡 Quick Interview Revision

| Requirement | Command |
|------------|---------|
| CPU Usage | `top` |
| Memory Usage | `free -h` |
| Disk Usage | `df -h` |
| Directory Size | `du -sh` |
| Running Processes | `ps -ef` |
| Service Status | `systemctl status` |
| Logs | `journalctl` |
| Live Logs | `tail -f` |
| Network | `ip a` |
| Ports | `ss -tunlp` |
| DNS | `nslookup` / `dig` |
| SSH | `ssh` |
| Disk List | `lsblk` |
| Load Average | `uptime` |

---

# ⭐ Pro Tips

- Check logs before restarting any service.
- Verify the root cause before applying a fix.
- Always validate the service after resolving the issue.
- If the server is hosted on AWS, check EC2, Security Groups, Network ACLs, Route Tables, Load Balancers, and CloudWatch metrics.
- Document the RCA after every production incident.
