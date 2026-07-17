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
