# 🧠 Linux Memory Management

Memory Management is a critical aspect of Linux administration. It helps monitor RAM usage, swap space, buffers, cache, and identify memory-related performance issues in production environments.

---

# 📚 Memory Components

Linux memory consists of:

- Physical Memory (RAM)
- Swap Memory
- Buffers
- Cache
- Virtual Memory

---

# 💻 Important Commands

## Check Memory Usage

```bash
free -h
```

---

## Real-Time Memory Monitoring

```bash
top
```

---

## Advanced Process Monitor

```bash
htop
```

---

## Virtual Memory Statistics

```bash
vmstat
```

---

## Memory Information

```bash
cat /proc/meminfo
```

---

## System Activity Report

```bash
sar -r
```

> **Note:** `sar` is available through the `sysstat` package.

---

## Top Memory Consuming Processes

```bash
ps -eo pid,user,%mem,%cpu,comm --sort=-%mem | head
```

---

## Check Swap Usage

```bash
swapon --show
```

or

```bash
free -h
```

---

# 📖 Practical Examples

### Check Available Memory

```bash
free -h
```

---

### Monitor Live Memory Usage

```bash
top
```

---

### View Memory Statistics

```bash
vmstat 2 5
```

---

### Find High Memory Processes

```bash
ps -eo pid,user,%mem,%cpu,comm --sort=-%mem | head
```

---

### Display Detailed Memory Information

```bash
cat /proc/meminfo
```

---

# 🎯 Interview Questions

### Q1. Which command checks memory usage?

```bash
free -h
```

---

### Q2. Which command shows real-time memory usage?

```bash
top
```

or

```bash
htop
```

---

### Q3. What is Swap Memory?

Swap is disk space used as virtual memory when physical RAM becomes insufficient.

---

### Q4. What is Cache Memory?

Cache stores frequently accessed data to improve system performance. Linux automatically frees cache when applications require more memory.

---

### Q5. Difference between RAM and Swap?

| RAM | Swap |
|-----|------|
| Physical memory | Disk-based virtual memory |
| Faster | Slower |
| Used first | Used when RAM is exhausted |

---

### Q6. What is OOM Killer?

The **Out Of Memory (OOM) Killer** automatically terminates processes when the system runs out of available memory to protect system stability.

---

# 🚀 Production Scenarios

## Scenario 1: Server Memory Usage is 95%

### Troubleshooting Steps

```bash
free -h
top
ps -eo pid,user,%mem,%cpu,comm --sort=-%mem | head
```

Identify the application consuming excessive memory.

---

## Scenario 2: Application Crashes Due to OOM

### Troubleshooting Steps

```bash
dmesg | grep -i oom
journalctl -k
free -h
```

Check whether the OOM Killer terminated the process.

---

## Scenario 3: High Swap Usage

### Troubleshooting Steps

```bash
free -h
swapon --show
vmstat
```

Investigate memory-hungry processes and determine whether additional RAM is required.

---

# ⚠️ Common Mistakes

- Assuming high cache usage means low available memory.
- Ignoring swap usage.
- Restarting applications without identifying the root cause.
- Killing production processes without impact analysis.
- Not monitoring memory trends over time.

---

# 💡 Quick Revision

- `free -h` → Memory usage
- `top` → Real-time monitoring
- `htop` → Interactive process viewer
- `vmstat` → Virtual memory statistics
- `cat /proc/meminfo` → Detailed memory information
- `sar -r` → Memory utilization report
- `swapon --show` → Swap usage
- `dmesg | grep -i oom` → OOM Killer events
