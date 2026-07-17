# 🌐 Linux Networking

Networking is one of the most important topics for Linux Administrators and DevOps Engineers. It helps troubleshoot connectivity issues, DNS problems, web server issues, and network communication.

---

# 📚 Network Basics

Every Linux server communicates using:

- IP Address
- Subnet Mask
- Gateway
- DNS Server
- MAC Address
- Ports

---

# 💻 Important Commands

## Check IP Address

```bash
ip addr
```

or

```bash
ip a
```

---

## Show Routing Table

```bash
ip route
```

---

## Check Network Interfaces

```bash
ip link
```

---

## Test Network Connectivity

```bash
ping google.com
```

---

## Check Listening Ports

```bash
ss -tunlp
```

---

## Show Open Connections

```bash
ss -tuln
```

---

## Check DNS Resolution

```bash
nslookup google.com
```

or

```bash
dig google.com
```

---

## Download a File

```bash
wget https://example.com/file.zip
```

---

## Test HTTP/HTTPS Connectivity

```bash
curl https://google.com
```

---

## Trace Network Path

```bash
traceroute google.com
```

---

## Display Network Statistics

```bash
netstat -tulnp
```

> **Note:** `netstat` is deprecated on many modern Linux distributions. Prefer using `ss`.

---

# 📖 Practical Examples

### Check Server IP

```bash
ip a
```

---

### Check Default Gateway

```bash
ip route
```

---

### Verify SSH Port

```bash
ss -tunlp | grep 22
```

---

### Verify Web Server Port

```bash
ss -tunlp | grep 80
```

---

### Test Website Response

```bash
curl http://localhost
```

---

### Verify DNS Resolution

```bash
nslookup google.com
```

---

# 🎯 Interview Questions

### Q1. Which command shows the IP address?

```bash
ip a
```

---

### Q2. Which command checks network connectivity?

```bash
ping
```

---

### Q3. Which command displays listening ports?

```bash
ss -tunlp
```

---

### Q4. Which command checks DNS resolution?

```bash
nslookup
```

or

```bash
dig
```

---

### Q5. Difference between `ping` and `curl`?

| ping | curl |
|------|------|
| Tests network connectivity | Tests application (HTTP/HTTPS) connectivity |
| Uses ICMP | Uses HTTP/HTTPS protocols |

---

### Q6. Difference between `netstat` and `ss`?

| netstat | ss |
|----------|----|
| Older command | Modern replacement |
| Slower | Faster |
| Deprecated on many systems | Recommended |

---

# 🚀 Production Scenarios

## Scenario 1: Website is Not Accessible

### Troubleshooting Steps

1. Check server IP.

```bash
ip a
```

2. Verify network connectivity.

```bash
ping 8.8.8.8
```

3. Check DNS resolution.

```bash
nslookup example.com
```

4. Verify service is listening.

```bash
ss -tunlp
```

5. Test locally.

```bash
curl http://localhost
```

---

## Scenario 2: SSH Connection Failed

### Troubleshooting Steps

```bash
systemctl status sshd
ss -tunlp | grep 22
ping server_ip
journalctl -u sshd
```

---

## Scenario 3: DNS Resolution Failed

### Troubleshooting Steps

```bash
cat /etc/resolv.conf
nslookup google.com
dig google.com
ping 8.8.8.8
```

---

# ⚠️ Common Mistakes

- Confusing network connectivity with application availability.
- Forgetting to verify DNS resolution.
- Ignoring firewall or security group rules.
- Not checking whether the required port is listening.
- Using `netstat` on systems where `ss` is preferred.

---

# 💡 Quick Revision

- `ip a` → Show IP address
- `ip route` → Show routing table
- `ping` → Test connectivity
- `ss -tunlp` → Show listening ports
- `curl` → Test HTTP/HTTPS
- `wget` → Download files
- `nslookup` / `dig` → DNS lookup
- `traceroute` → Trace network path
- `journalctl -u sshd` → View SSH service logs
