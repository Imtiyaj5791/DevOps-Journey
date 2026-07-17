# ⚙️ Linux Process Management

A process is a running instance of a program. Linux provides various commands to monitor, manage, and control processes, which is one of the most common tasks for Linux Administrators and DevOps Engineers.

---

# 📚 Process States

| State | Description |
|-------|-------------|
| Running (R) | Process is currently executing |
| Sleeping (S) | Waiting for an event or resource |
| Stopped (T) | Process has been stopped |
| Zombie (Z) | Process has finished but still has an entry in the process table |

---

# 💻 Important Commands

## View Running Processes

```bash
ps
```

---

## Detailed Process List

```bash
ps -ef
```

---

## Monitor Processes in Real Time

```bash
top
```

---

## Enhanced Process Monitor (if installed)

```bash
htop
```

---

## Find a Process

```bash
pgrep nginx
pidof sshd
```

---

## Kill a Process

```bash
kill PID
```

Example:

```bash
kill 1234
```

---

## Force Kill a Process

```bash
kill -9 PID
```

Example:

```bash
kill -9 1234
```

---

## Kill Process by Name

```bash
pkill nginx
killall java
```

---

## Run a Process in Background

```bash
command &
```

Example:

```bash
sleep 300 &
```

---

## View Background Jobs

```bash
jobs
```

---

## Bring Background Job to Foreground

```bash
fg
```

---

# 📖 Practical Examples

### Find SSH Process

```bash
ps -ef | grep ssh
```

---

### Check Top CPU Consuming Processes

```bash
top
```

---

### Kill a Hung Process

```bash
kill -9 4567
```

---

### Find Nginx Process

```bash
pgrep nginx
```

---

# 🎯 Interview Questions

### Q1. What is a process?

A process is a running instance of a program.

---

### Q2. Difference between a Process and a Program?

| Program | Process |
|----------|----------|
| Stored on disk | Running in memory |
| Passive | Active |

---

### Q3. Difference between `kill` and `kill -9`?

| `kill` | `kill -9` |
|----------|------------|
| Sends SIGTERM (graceful termination) | Sends SIGKILL (forcefully terminates the process) |
| Allows cleanup before exit | Immediately stops the process |

---

### Q4. Which command displays running processes?

```bash
ps -ef
```

---

### Q5. Which command monitors processes in real time?

```bash
top
```

---

### Q6. Which command finds a process by name?

```bash
pgrep process_name
```

Example:

```bash
pgrep nginx
```

---

# 🚀 Production Scenario

**Issue:** Server is slow and users report application latency.

### Troubleshooting Steps

1. Check CPU and memory usage.

```bash
top
```

2. Identify high CPU or memory consuming process.

```bash
ps -ef
```

3. Check process details.

```bash
ps -p PID -f
```

4. Restart the application service if required.

```bash
systemctl restart service_name
```

5. If the process is hung and cannot exit gracefully, terminate it.

```bash
kill -9 PID
```

---

# ⚠️ Common Mistakes

- Avoid using `kill -9` as the first option.
- Always identify the correct PID before killing a process.
- Verify the impact before terminating production services.
- Use `top` or `htop` to understand resource usage before taking action.

---

# 💡 Quick Revision

- `ps -ef` → List all running processes
- `top` → Real-time process monitoring
- `pgrep` → Find process by name
- `kill` → Graceful termination
- `kill -9` → Forceful termination
- `jobs` → Show background jobs
- `fg` → Bring a background job to the foreground
