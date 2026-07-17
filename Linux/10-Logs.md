# 📜 Linux Logs

Logs are one of the most important resources for troubleshooting Linux systems. They help administrators identify errors, monitor services, investigate security events, and perform root cause analysis (RCA).

---

# 📚 What are Logs?

Logs are files that record system events, application activities, authentication attempts, and service status.

Common log types include:

- System Logs
- Authentication Logs
- Kernel Logs
- Application Logs
- Boot Logs

---

# 📂 Important Log Locations

| Directory/File | Purpose |
|----------------|---------|
| `/var/log` | Main log directory |
| `/var/log/messages` | General system logs (RHEL/CentOS) |
| `/var/log/syslog` | General system logs (Ubuntu/Debian) |
| `/var/log/secure` | Authentication logs (RHEL/CentOS) |
| `/var/log/auth.log` | Authentication logs (Ubuntu/Debian) |
| `/var/log/dmesg` | Kernel boot messages |
| `/var/log/boot.log` | Boot logs |
| `/var/log/cron` | Cron job logs |
| `/var/log/httpd/` | Apache logs |
| `/var/log/nginx/` | Nginx logs |

---

# 💻 Important Commands

## View Entire Log

```bash
cat /var/log/messages
```

---

## View Large Logs

```bash
less /var/log/messages
```

---

## View Last 10 Lines

```bash
tail /var/log/messages
```

---

## Monitor Logs in Real Time

```bash
tail -f /var/log/messages
```

---

## View First 10 Lines

```bash
head /var/log/messages
```

---

## Search for Errors

```bash
grep "error" /var/log/messages
```

---

## Search Case-Insensitive

```bash
grep -i "failed" /var/log/messages
```

---

## Display Line Numbers

```bash
grep -n "ssh" /var/log/messages
```

---

## View systemd Logs

```bash
journalctl
```

---

## View Logs for a Specific Service

```bash
journalctl -u nginx
```

---

## View Recent Boot Logs

```bash
journalctl -b
```

---

## Follow Logs in Real Time

```bash
journalctl -f
```

---

# 📖 Practical Examples

### Monitor SSH Login Attempts

```bash
tail -f /var/log/secure
```

Ubuntu:

```bash
tail -f /var/log/auth.log
```

---

### Check Nginx Errors

```bash
tail -f /var/log/nginx/error.log
```

---

### Search for Failed Logins

```bash
grep "Failed" /var/log/secure
```

---

### View Docker Service Logs

```bash
journalctl -u docker
```

---

# 🎯 Interview Questions

### Q1. Where are Linux logs stored?

**Answer:**

```text
/var/log
```

---

### Q2. Which command monitors logs in real time?

```bash
tail -f
```

---

### Q3. What is journalctl?

**Answer:**

`journalctl` is used to view logs collected by the **systemd journal**.

---

### Q4. Which command displays logs of a specific service?

```bash
journalctl -u service_name
```

Example:

```bash
journalctl -u nginx
```

---

### Q5. Difference between `tail` and `tail -f`?

| `tail` | `tail -f` |
|----------|-----------|
| Displays the last few lines | Continuously monitors new log entries |

---

### Q6. Which log file stores authentication logs?

| Distribution | Log File |
|--------------|----------|
| RHEL/CentOS | `/var/log/secure` |
| Ubuntu/Debian | `/var/log/auth.log` |

---

# 🚀 Production Scenarios

## Scenario 1: Website is Down

### Troubleshooting Steps

```bash
systemctl status nginx
journalctl -u nginx
tail -f /var/log/nginx/error.log
ss -tunlp | grep 80
```

---

## Scenario 2: SSH Login Failed

### Troubleshooting Steps

```bash
systemctl status sshd
journalctl -u sshd
tail -f /var/log/secure
```

Ubuntu:

```bash
tail -f /var/log/auth.log
```

---

## Scenario 3: Service Failed to Start

### Troubleshooting Steps

```bash
systemctl status service_name
journalctl -u service_name
journalctl -xe
```

---

# ⚠️ Common Mistakes

- Ignoring logs before restarting a service.
- Looking at the wrong log file for the operating system.
- Forgetting to use `journalctl` on systemd-based systems.
- Searching entire logs instead of filtering with `grep`.
- Ignoring timestamps while troubleshooting.

---

# 💡 Quick Revision

- `tail -f` → Monitor logs in real time
- `journalctl` → View systemd logs
- `journalctl -u service` → Service logs
- `journalctl -b` → Current boot logs
- `grep` → Search logs
- `/var/log/messages` → System logs (RHEL/CentOS)
- `/var/log/syslog` → System logs (Ubuntu/Debian)
- `/var/log/secure` → Authentication logs (RHEL/CentOS)
- `/var/log/auth.log` → Authentication logs (Ubuntu/Debian)
