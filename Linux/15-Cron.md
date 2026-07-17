# ⏰ Linux Cron Jobs

Cron is a time-based job scheduler in Linux used to automate repetitive tasks such as backups, log cleanup, report generation, and application maintenance.

---

# 📚 What is Cron?

Cron allows administrators to schedule commands or scripts to run automatically at specified times.

Common Use Cases:

- Database Backup
- Log Rotation
- Disk Cleanup
- Health Check Scripts
- Application Restart
- Email Reports

---

# 🏗 Cron Components

- **cron** → Background service (daemon)
- **crontab** → User-specific cron schedule
- **crond** → Cron daemon (RHEL/CentOS)

---

# 📂 Important Files

| File | Purpose |
|------|---------|
| `/etc/crontab` | System-wide cron configuration |
| `/etc/cron.daily/` | Daily scheduled jobs |
| `/etc/cron.weekly/` | Weekly scheduled jobs |
| `/etc/cron.monthly/` | Monthly scheduled jobs |
| `/var/log/cron` | Cron logs (RHEL/CentOS) |

---

# 🕒 Cron Syntax

```text
* * * * * command
│ │ │ │ │
│ │ │ │ └── Day of Week (0-7)
│ │ │ └──── Month (1-12)
│ │ └────── Day of Month (1-31)
│ └──────── Hour (0-23)
└────────── Minute (0-59)
```

---

# 💻 Important Commands

## View Current Cron Jobs

```bash
crontab -l
```

---

## Edit Cron Jobs

```bash
crontab -e
```

---

## Remove All Cron Jobs

```bash
crontab -r
```

---

## List Another User's Cron Jobs

```bash
crontab -u username -l
```

---

## Check Cron Service Status

```bash
systemctl status crond
```

Ubuntu:

```bash
systemctl status cron
```

---

# 📖 Practical Examples

### Run Every Day at 2:00 AM

```text
0 2 * * * /home/user/backup.sh
```

---

### Run Every 5 Minutes

```text
*/5 * * * * /home/user/health-check.sh
```

---

### Run Every Sunday at Midnight

```text
0 0 * * 0 /home/user/cleanup.sh
```

---

### Run Every Hour

```text
0 * * * * /home/user/script.sh
```

---

### Run at System Reboot

```text
@reboot /home/user/startup.sh
```

---

# 🎯 Interview Questions

### Q1. What is Cron?

Cron is a Linux job scheduler used to automate repetitive tasks.

---

### Q2. Which command edits cron jobs?

```bash
crontab -e
```

---

### Q3. Which command lists cron jobs?

```bash
crontab -l
```

---

### Q4. Which command removes all cron jobs?

```bash
crontab -r
```

---

### Q5. What does `*/10 * * * *` mean?

Runs a job every **10 minutes**.

---

### Q6. What does `0 3 * * *` mean?

Runs a job every day at **3:00 AM**.

---

# 🚀 Production Scenarios

## Scenario 1: Backup Script Not Running

### Troubleshooting Steps

```bash
crontab -l
systemctl status crond
tail -f /var/log/cron
```

Verify:

- Script path
- Execute permission
- User ownership
- Cron syntax

---

## Scenario 2: Health Check Script Failing

### Troubleshooting Steps

```bash
crontab -l
chmod +x health-check.sh
tail -f /var/log/cron
```

Run the script manually:

```bash
./health-check.sh
```

---

## Scenario 3: Cron Job Runs Manually but Not Automatically

### Possible Causes

- Incorrect PATH environment
- Missing execute permission
- Wrong cron syntax
- Cron service stopped
- Incorrect script path

---

# ⚠️ Common Mistakes

- Using relative paths instead of absolute paths.
- Forgetting to make scripts executable.
- Assuming cron uses the same environment variables as the shell.
- Not checking cron logs after failures.
- Forgetting to verify the cron service status.

---

# 💡 Quick Revision

- `crontab -e` → Edit cron jobs
- `crontab -l` → List cron jobs
- `crontab -r` → Remove cron jobs
- `systemctl status crond` → Check cron service
- `/etc/crontab` → System-wide cron configuration
- `/var/log/cron` → Cron logs (RHEL/CentOS)
- `@reboot` → Run at system startup
- `*/5 * * * *` → Every 5 minutes
