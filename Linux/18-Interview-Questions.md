# 🎯 Linux Interview Questions & Answers

This document contains the most frequently asked Linux interview questions for Linux Administrator, AWS Support Engineer, and DevOps Engineer roles.

---

# Q1. What happens when you power on a Linux server?

## Answer

The Linux boot process follows these steps:

1. BIOS/UEFI initializes the hardware.
2. GRUB Bootloader loads.
3. Linux Kernel loads into memory.
4. initramfs is loaded.
5. systemd (PID 1) starts.
6. Services start.
7. Login prompt appears.

---

# Q2. What is the difference between Process and Thread?

| Process | Thread |
|----------|----------|
| Independent execution | Part of a process |
| Own memory | Shared memory |
| More resource usage | Less resource usage |

---

# Q3. What is the difference between Hard Link and Soft Link?

| Hard Link | Soft Link |
|-----------|-----------|
| Same inode | Different inode |
| Works only in same filesystem | Works across filesystems |
| Cannot link directories | Can link directories |

Commands:

```bash
ln file1 hardlink
ln -s file1 softlink
```

---

# Q4. Difference between chmod and chown?

| chmod | chown |
|--------|--------|
| Changes permissions | Changes ownership |

---

# Q5. What is Swap Memory?

Swap is disk space used as virtual memory when RAM becomes full.

Check:

```bash
free -h
swapon --show
```

---

# Q6. Difference between df and du?

| df | du |
|----|----|
| Disk usage | Directory/File size |

---

# Q7. Difference between kill and kill -9?

| kill | kill -9 |
|------|----------|
| Gracefully terminates | Forcefully kills |

---

# Q8. How do you check CPU, Memory and Disk?

CPU

```bash
top
```

Memory

```bash
free -h
```

Disk

```bash
df -h
```

---

# Q9. How do you check running services?

```bash
systemctl status service_name
systemctl list-units --type=service
```

---

# Q10. How do you troubleshoot a Linux server?

## Interview Answer

I follow a structured troubleshooting approach.

- Understand the issue
- Verify the impact
- Check system resources
- Review logs
- Identify root cause
- Fix the issue
- Validate the solution
- Perform RCA

---

# Q11. A Website is Down. What will you do?

## Interview Answer

First, I'll verify whether the issue affects all users.

Then I'll check:

- Server Reachability
- Service Status
- Listening Port
- Logs

Commands

```bash
ping server_ip

systemctl status nginx

ss -tunlp

curl localhost

journalctl -u nginx
```

If hosted on AWS I'll verify:

- EC2
- Security Group
- Target Group
- Load Balancer
- Route53

Then I'll check recent deployment or configuration changes before restarting any service.

Finally I'll validate the website and perform RCA.

---

# Q12. Server is Slow. What will you do?

## Interview Answer

First I'll check:

```bash
top
```

Then

```bash
free -h
```

Next

```bash
df -h
```

Then

```bash
vmstat
```

I'll identify whether CPU, Memory, Disk or Application is causing the issue.

If hosted on AWS I'll also verify CloudWatch metrics.

Finally I'll resolve the issue and perform RCA.

---

# Q13. SSH is Not Working. What will you do?

## Interview Answer

First I'll verify whether the server is reachable.

Then I'll check:

```bash
systemctl status sshd
```

Next

```bash
ss -tunlp | grep 22
```

Then

```bash
journalctl -u sshd
```

If hosted on AWS I'll verify:

- Security Group
- Network ACL
- Route Table
- EC2 Status

Finally I'll check recent SSH configuration changes.

---

# Q14. Disk is 100% Full. What will you do?

## Interview Answer

First

```bash
df -h
```

Then

```bash
du -sh /*
```

Next I'll identify:

- Large Logs
- Backup Files
- Temporary Files

If hosted on AWS I'll check whether EBS expansion is required.

Finally I'll clean unnecessary files after approval and perform RCA.

---

# Q15. High CPU Usage. What will you do?

## Interview Answer

First

```bash
top
```

Then

```bash
ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu | head
```

Then I'll verify:

- Application logs
- Recent deployment
- Cron jobs

If hosted on AWS I'll check CloudWatch CPU metrics.

---

# Q16. High Memory Usage. What will you do?

## Interview Answer

First

```bash
free -h
```

Then

```bash
top
```

Then

```bash
dmesg | grep -i oom
```

I'll identify memory-consuming processes.

If hosted on AWS I'll verify CloudWatch Memory metrics (if configured).

---

# Q17. Why should we hire you?

## Sample Answer

I have experience in Linux Administration and AWS Operations. I am comfortable troubleshooting production issues related to Linux servers, services, networking, storage, monitoring, and AWS infrastructure. I always follow a structured troubleshooting approach, identify the root cause before making changes, validate the solution, and document RCA. I enjoy learning new technologies and continuously improving my technical skills.

---

# 💡 Interview Tips

- Never say **"I immediately restarted the service."**
- Always mention **logs**.
- Always mention **root cause analysis (RCA)**.
- Mention **AWS components** whenever the server is hosted on AWS.
- Mention **recent deployment/configuration changes** before concluding.
- Speak step by step and explain your thought process.
