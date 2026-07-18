# 🖥️ Linux Bash Scripting

Bash (Bourne Again Shell) is the default command-line shell in most Linux distributions. Bash scripting helps automate repetitive tasks, reduce manual effort, and improve system administration efficiency.

---

# 📚 What is Bash Scripting?

A Bash script is a text file containing Linux commands that are executed sequentially.

Common Use Cases:

- Server Health Checks
- Backup Automation
- Log Cleanup
- User Management
- Monitoring
- Deployment Automation

---

# 📂 Script Structure

Example:

```bash
#!/bin/bash

echo "Hello, World!"
```

- `#!/bin/bash` → Shebang (tells Linux to use the Bash interpreter)
- `echo` → Prints output to the terminal

---

# 💻 Important Commands

## Create a Script

```bash
nano script.sh
```

---

## Make Script Executable

```bash
chmod +x script.sh
```

---

## Run Script

```bash
./script.sh
```

or

```bash
bash script.sh
```

---

# 📝 Variables

```bash
#!/bin/bash

name="Linux"

echo $name
```

---

# ⌨️ User Input

```bash
#!/bin/bash

read -p "Enter your name: " name

echo "Welcome $name"
```

---

# 🔀 Conditional Statements

```bash
#!/bin/bash

if [ $USER == "root" ]
then
    echo "Root User"
else
    echo "Normal User"
fi
```

---

# 🔁 For Loop

```bash
#!/bin/bash

for i in 1 2 3 4 5
do
    echo $i
done
```

---

# 🔄 While Loop

```bash
#!/bin/bash

count=1

while [ $count -le 5 ]
do
    echo $count
    ((count++))
done
```

---

# 📖 Practical Examples

## Disk Usage Check

```bash
#!/bin/bash

df -h
```

---

## Memory Usage Check

```bash
#!/bin/bash

free -h
```

---

## CPU Usage Check

```bash
#!/bin/bash

top -b -n1 | head
```

---

## Check Service Status

```bash
#!/bin/bash

systemctl status nginx
```

---

## Backup Script

```bash
#!/bin/bash

tar -czf backup.tar.gz /home/user
```

---

# 🎯 Interview Questions

### Q1. What is Bash?

Bash is a command-line shell and scripting language used to automate Linux tasks.

---

### Q2. What is the purpose of `#!/bin/bash`?

It specifies that the script should be executed using the Bash interpreter.

---

### Q3. How do you make a script executable?

```bash
chmod +x script.sh
```

---

### Q4. Difference between `bash script.sh` and `./script.sh`?

| `bash script.sh` | `./script.sh` |
|------------------|---------------|
| Runs using the Bash interpreter | Executes the script directly |
| Execute permission not required | Execute permission required |

---

### Q5. How do you accept user input?

```bash
read
```

Example:

```bash
read -p "Enter Name: " name
```

---

### Q6. Which loop is used when the number of iterations is known?

**Answer:** `for` loop

---

# 🚀 Production Scenarios

## Scenario 1: Daily Server Health Check

```bash
#!/bin/bash

echo "Hostname:"
hostname

echo "Disk Usage:"
df -h

echo "Memory Usage:"
free -h

echo "CPU Load:"
uptime
```

---

## Scenario 2: Restart Service Automatically

```bash
#!/bin/bash

systemctl restart nginx
systemctl status nginx
```

---

## Scenario 3: Delete Old Log Files

```bash
#!/bin/bash

find /var/log -type f -mtime +30 -delete
```

---

# ⚠️ Common Mistakes

- Forgetting the shebang (`#!/bin/bash`).
- Not making the script executable.
- Using relative paths instead of absolute paths.
- Running scripts as root without verification.
- Not checking the exit status of commands.

---

# 💡 Quick Revision

- `#!/bin/bash` → Bash interpreter
- `chmod +x` → Make executable
- `./script.sh` → Run script
- `read` → User input
- `if` → Conditional statement
- `for` → Loop with fixed iterations
- `while` → Loop until condition changes
- `echo` → Print output

---

# 🚀 Production Bash Scripts

These are real-world Bash scripts commonly used by Linux Administrators, AWS Support Engineers, and DevOps Engineers to automate routine tasks and monitor production servers.

---

## Script 1 – Disk Usage Monitoring

```bash
#!/bin/bash

###########################################################################

# Script Name : disk_monitor.sh
# Description : Monitors root filesystem disk usage and generates an alert
#               when usage crosses the configured threshold.
# Author      : Imtiyaj Ansari
# Created Date: 17-Jul-2026
# Version     : 1.0
#
# Usage       : ./disk_monitor.sh
#
# Exit Codes  :
#   0 - Disk usage is within the threshold
#   1 - Disk usage has crossed the threshold
#   2 - Script execution or command failure
###############################################################################

# Threshold percentage after which an alert should be generated

Threshold=80

# Log file location

LOG_FILE="/var/log/disk_monitor.log"

# Capture current date and time

CURRENT_DATE=$(date '+%Y-%m-%d %H:%M:%S')


# Get root filesystem disk usage percentage.
# df /        : Checks disk usage of the root filesystem.
# awk NR==2   : Selects the second line of df output.
# print $5    : Prints the disk usage percentage column.
# tr -d '%'   : Removes the percentage symbol.

# Get disk usage

DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

if [ "$DISK_USAGE" = "$THRESHOLD" ]
then
echo "$CURRENT_DATE : WARNING - Disk usage is ${DISK_USAGE}%" >> "$LOG_FILE"
else
echo "$CURRENT_DATE : OK - Disk usage is ${DISK_USAGE}%" >> "$LOG_FILE"
fi


```

### Purpose

Monitors disk usage and alerts when any partition exceeds the configured threshold.

### Production Use

Used to prevent production outages caused by low disk space.

---

## Script 2 – CPU Monitoring

```bash
#!/bin/bash

###############################################################################
# Script Name : cpu_monitor.sh
# Description : Monitor CPU usage and generate warning if threshold exceeds.
# Author      : Imtiyaj Ansari
# Date        : 17-Jul-2026
###############################################################################

# CPU Usage Threshold
THRESHOLD=80

# Current Date & Time
CURRENT_DATE=$(date '+%Y-%m-%d %H:%M:%S')

# Get CPU idle percentage from top command
CPU_IDLE=$(top -bn1 | grep "%Cpu(s)" | awk '{print $8}' | cut -d. -f1)

# Calculate actual CPU usage
CPU_USAGE=$((100 - CPU_IDLE))

# Compare current CPU usage with threshold
if [ "$CPU_USAGE" -ge "$THRESHOLD" ]; then
    echo "$CURRENT_DATE : WARNING - CPU usage is ${CPU_USAGE}%"
else
    echo "$CURRENT_DATE : OK - CPU usage is ${CPU_USAGE}%"
fi

```

### Purpose

Checks current CPU utilization.

### Production Use

Helps identify high CPU usage before applications become slow.

---

## Script 3 – Memory Monitoring

```bash
#!/bin/bash

###############################################################################
# Script Name : memory_monitor.sh
# Description : Monitor memory usage and generate warning if threshold exceeds.
# Author      : Imtiyaj Ansari
# Date        : 17-Jul-2026
###############################################################################

# Memory Usage Threshold
THRESHOLD=80

# Current Date & Time
CURRENT_DATE=$(date '+%Y-%m-%d %H:%M:%S')

# Total Memory
TOTAL=$(free -m | awk 'NR==2 {print $2}')

# Used Memory
USED=$(free -m | awk 'NR==2 {print $3}')

# Memory Usage
MEMORY_USAGE=$(( USED * 100 / TOTAL ))

# Compare current Memory usage with threshold
if [ "$Memory_USAGE" -ge "$THRESHOLD" ]; then
    echo "$CURRENT_DATE : WARNING - Memory usage is ${MEMORY_USAGE}%"
else
    echo "$CURRENT_DATE : OK - Memory usage is ${MEMORY_USAGE}%"
fi

```

### Purpose

Monitors memory utilization.

### Production Use

Useful for detecting memory leaks and preventing application crashes.

---

## Script 4 – Service Status Checker

```bash
#!/bin/bash

# Fetch the live status of Nginx
SERVICE_STATUS=$(systemctl is-active nginx 2>/dev/null)

if [ "$SERVICE_STATUS" = "active" ]; then
    echo "✅ SUCCESS: Nginx Server is running fine!"
else
    echo "⚠️ WARNING: Nginx Server is DOWN! Trying to start it..."
    
    # Try to start Nginx
    sudo systemctl start nginx 2>/dev/null
    
    # $? check karta hai ki JUST PEHLE WAALI command pass hui ya fail
    if [ $? -eq 0 ]; then
        echo "🚀 Nginx Server has been restarted successfully!"
    else
        echo "❌ ERROR: Nginx is not installed or failed to start! Please check manually."
    fi
fi
```

### Purpose

Checks whether a service is running.

### Production Use

Frequently used to monitor critical services such as Nginx, Apache, MySQL, Docker, and Jenkins.

---

## Script 5 – Server Health Check

```bash
#!/bin/bash

THRESHOLD=80
CURRENT_DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "======================================"
echo "        SERVER HEALTH CHECK"
echo "======================================"

echo "Date : $CURRENT_DATE"

echo "======================================"

# Disk status

DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

if [ "$DISK_USAGE" -ge "$THRESHOLD" ]
then
echo "$CURRENT_DATE : WARNING - Disk usage is ${DISK_USAGE}%"
else
echo "$CURRENT_DATE : OK - Disk usage is ${DISK_USAGE}%"
fi

# CPU Status

CPU_IDLE=$(top -bn1 | grep "%Cpu(s)" | awk '{print $8}' | cut -d. -f1)
CPU_USAGE=$((100 - CPU_IDLE))

if [ "$CPU_USAGE" -ge "$THRESHOLD" ]
then
echo "$CURRENT_DATE : WARNING - CPU usage is ${CPU_USAGE}%"
else
echo "$CURRENT_DATE : OK - CPU usage is ${CPU_USAGE}%"
fi

# Memory Status


Total=$(free -m | awk 'NR==2 {print $2}')
Used=$(free -m | awk 'NR==2 {print $3}')
MEMORY_USAGE=$(( Used * 100 / Total ))

# Compare current Memory usage with threshold
if [ "$MEMORY_USAGE" -ge "$THRESHOLD" ]; then
    echo "$CURRENT_DATE : WARNING - Memory usage is ${MEMORY_USAGE}%"
else
    echo "$CURRENT_DATE : OK - Memory usage is ${MEMORY_USAGE}%"
fi

# Service check

Service_Status=$(systemctl is-active nginx)

if [ "$Service_Status" = "active" ]
then
echo "$CURRENT_DATE : Service is running "
else
echo "$CURRENT_DATE : Service is stopped "

 # Try to start Nginx
systemctl start nginx

if [ $? -eq 0 ]
then
        echo "🚀 Nginx Server has been restarted successfully!"
    else
        echo "❌ ERROR: Nginx is not installed or failed to start! Please check manually."
    fi
fi

```

### Purpose

Generates a quick health report of the server.

### Production Use

Useful for daily server health checks and troubleshooting during production incidents.

---

> **Note:** More production automation scripts such as Backup Automation, Log Cleanup, SSL Certificate Expiry Check, and User Creation Automation will be added in future updates.
