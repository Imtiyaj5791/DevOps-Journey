# 🔧 Linux Service Management

Linux services (also called daemons) are background processes that keep applications and system components running. Managing services is a daily responsibility for Linux Administrators and DevOps Engineers.

---

# 📚 What is a Service?

A service is a background process that starts automatically or manually and performs a specific task.

Examples:

- SSH
- Nginx
- Apache
- Docker
- MySQL
- Cron

---

# ⚙️ systemd and systemctl

Most modern Linux distributions use **systemd** as the init system.

The **systemctl** command is used to manage services.

---

# 💻 Important Commands

## Check Service Status

```bash
systemctl status nginx
```

---

## Start a Service

```bash
systemctl start nginx
```

---

## Stop a Service

```bash
systemctl stop nginx
```

---

## Restart a Service

```bash
systemctl restart nginx
```

---

## Reload a Service

```bash
systemctl reload nginx
```

---

## Enable Service at Boot

```bash
systemctl enable nginx
```

---

## Disable Service at Boot

```bash
systemctl disable nginx
```

---

## Check if Service is Enabled

```bash
systemctl is-enabled nginx
```

---

## List Running Services

```bash
systemctl list-units --type=service
```

---

## View Failed Services

```bash
systemctl --failed
```

---

# 📖 Practical Examples

### Restart SSH Service

```bash
systemctl restart sshd
```

---

### Check Docker Service

```bash
systemctl status docker
```

---

### Enable Docker at Boot

```bash
systemctl enable docker
```

---

### Restart Nginx After Configuration Change

```bash
systemctl restart nginx
```

---

# 🎯 Interview Questions

### Q1. What is systemd?

**Answer:**  
systemd is the service manager and init system used by most modern Linux distributions.

---

### Q2. What is the difference between `start` and `enable`?

| start | enable |
|--------|---------|
| Starts the service immediately | Starts the service automatically after every reboot |

---

### Q3. Difference between `restart` and `reload`?

| restart | reload |
|----------|---------|
| Stops and starts the service | Reloads configuration without stopping the service (if supported) |

---

### Q4. Which command checks the status of a service?

```bash
systemctl status service_name
```

Example:

```bash
systemctl status nginx
```

---

### Q5. Which command lists failed services?

```bash
systemctl --failed
```

---

### Q6. Which command enables a service during system boot?

```bash
systemctl enable service_name
```

---

# 🚀 Production Scenario

## Issue

Users report that the website is not accessible.

### Troubleshooting Steps

1. Check whether the web service is running.

```bash
systemctl status nginx
```

2. If the service is stopped, start it.

```bash
systemctl start nginx
```

3. If configuration was recently changed, verify it and restart the service.

```bash
systemctl restart nginx
```

4. Check logs for errors.

```bash
journalctl -u nginx
```

5. Verify that the required port is listening.

```bash
ss -tunlp
```

---

# ⚠️ Common Mistakes

- Restarting services without checking logs first.
- Forgetting to enable services after installation.
- Restarting production services without understanding the impact.
- Ignoring failed service dependencies.

---

# 💡 Quick Revision

- `systemctl status` → Check service status
- `systemctl start` → Start service
- `systemctl stop` → Stop service
- `systemctl restart` → Restart service
- `systemctl reload` → Reload configuration
- `systemctl enable` → Enable at boot
- `systemctl disable` → Disable at boot
- `systemctl --failed` → Show failed services
- `journalctl -u service_name` → View service logs
