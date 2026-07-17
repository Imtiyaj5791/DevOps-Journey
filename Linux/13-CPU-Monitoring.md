# ⚡ Linux CPU Monitoring

CPU Monitoring is essential for maintaining system performance. Linux provides several commands to monitor CPU utilization, load average, process usage, and identify performance bottlenecks in production environments.

---

# 📚 CPU Concepts

Before monitoring CPU, understand these terms:

- CPU Utilization
- Load Average
- User Time
- System Time
- Idle Time
- I/O Wait
- Context Switch

---

# 💻 Important Commands

## Real-Time CPU Monitoring

```bash
top
```

---

## Interactive Process Monitor

```bash
htop
```

---

## Check Load Average

```bash
uptime
```

---

## CPU Statistics

```bash
mpstat
```

Example:

```bash
mpstat 2 5
```

> **Note:** `mpstat` is available through the `sysstat` package.

---

## System Performance Statistics

```bash
vmstat
```

Example:

```bash
vmstat 2 5
```

---

## CPU Usage Report

```bash
sar -u
```

Example:

```bash
sar -u 2 5
```

---

## Top CPU Consuming Processes

```bash
ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu | head
```

---

## Processor Information

```bash
lscpu
```

---

## Number of CPU Cores

```bash
nproc
```

---

# 📖 Practical Examples

### Check Current CPU Usage

```bash
top
```

---

### View Load Average

```bash
uptime
```

Example Output:

```text
load average: 0.45, 0.60, 0.72
```

---

### Display CPU Statistics

```bash
mpstat
```

---

### Find High CPU Processes

```bash
ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu | head
```

---

### Display CPU Information

```bash
lscpu
```

---

# 🎯 Interview Questions

### Q1. Which command shows CPU usage in real time?

```bash
top
```

or

```bash
htop
```

---

### Q2. Which command displays CPU information?

```bash
lscpu
```

---

### Q3. Which command shows the load average?

```bash
uptime
```

---

### Q4. What is Load Average?

Load Average represents the average number of processes waiting for CPU execution over the last **1, 5, and 15 minutes**.

---

### Q5. What is I/O Wait?

I/O Wait is the percentage of time the CPU spends waiting for disk or network I/O operations to complete.

---

### Q6. Which command lists the top CPU-consuming processes?

```bash
ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu | head
```

---

# 🚀 Production Scenarios

## Scenario 1: CPU Usage is Above 95%

### Troubleshooting Steps

```bash
top
ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu | head
mpstat
```

Identify the process consuming high CPU and investigate before taking action.

---

## Scenario 2: Server is Slow

### Troubleshooting Steps

```bash
uptime
vmstat
top
```

Check load average, CPU utilization, memory usage, and I/O wait.

---

## Scenario 3: Java Process Consuming High CPU

### Troubleshooting Steps

```bash
ps -ef | grep java
top
kill PID
```

If required, restart the application after confirming with the application owner.

---

# ⚠️ Common Mistakes

- Confusing high CPU usage with high load average.
- Ignoring I/O Wait during troubleshooting.
- Killing production processes without verifying business impact.
- Investigating CPU usage without checking memory and disk utilization.
- Looking only at CPU percentage without identifying the responsible process.

---

# 💡 Quick Revision

- `top` → Real-time CPU monitoring
- `htop` → Interactive process monitor
- `uptime` → Load average
- `mpstat` → CPU statistics
- `vmstat` → System performance
- `sar -u` → CPU utilization report
- `lscpu` → CPU information
- `nproc` → Number of CPU cores
- `ps -eo ... --sort=-%cpu` → Top CPU-consuming processes
