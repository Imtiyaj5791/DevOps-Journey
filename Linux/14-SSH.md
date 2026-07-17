# 🔐 Linux SSH (Secure Shell)

SSH (Secure Shell) is a secure network protocol used to remotely access and manage Linux servers over an encrypted connection. It is one of the most frequently used tools by Linux Administrators, AWS Engineers, and DevOps Engineers.

---

# 📚 What is SSH?

SSH allows you to:

- Connect to remote Linux servers securely
- Execute commands remotely
- Transfer files securely
- Perform server administration
- Automate tasks using SSH keys

Default SSH Port:

```text
22
```

---

# 🏗 SSH Authentication Methods

## 1. Password Authentication

- Username
- Password

---

## 2. Key-Based Authentication (Recommended)

Uses:

- Public Key
- Private Key

Example:

```text
id_rsa
id_rsa.pub
```

---

# 💻 Important Commands

## Connect to Remote Server

```bash
ssh username@server_ip
```

Example:

```bash
ssh ubuntu@192.168.1.10
```

---

## Connect Using Private Key

```bash
ssh -i mykey.pem ubuntu@server_ip
```

---

## Generate SSH Key Pair

```bash
ssh-keygen
```

---

## Copy Public Key to Remote Server

```bash
ssh-copy-id username@server_ip
```

---

## Secure File Copy (SCP)

Copy local file to remote server:

```bash
scp file.txt ubuntu@server_ip:/home/ubuntu/
```

Copy file from remote server:

```bash
scp ubuntu@server_ip:/tmp/log.txt .
```

---

## Secure File Transfer (SFTP)

```bash
sftp ubuntu@server_ip
```

---

## Verify SSH Service

```bash
systemctl status sshd
```

---

## Check SSH Listening Port

```bash
ss -tunlp | grep 22
```

---

# 📂 Important SSH Files

| File | Purpose |
|------|---------|
| `/etc/ssh/sshd_config` | SSH server configuration |
| `~/.ssh/id_rsa` | Private key |
| `~/.ssh/id_rsa.pub` | Public key |
| `~/.ssh/authorized_keys` | Authorized public keys |
| `~/.ssh/known_hosts` | Known remote hosts |

---

# 📖 Practical Examples

### Connect to AWS EC2 Instance

```bash
ssh -i mykey.pem ec2-user@54.x.x.x
```

---

### Generate SSH Keys

```bash
ssh-keygen -t rsa -b 4096
```

---

### Copy SSH Key

```bash
ssh-copy-id ubuntu@192.168.1.20
```

---

### Copy Log File

```bash
scp app.log ubuntu@server:/tmp/
```

---

# 🎯 Interview Questions

### Q1. What is SSH?

SSH (Secure Shell) is a secure protocol used for remote login and server administration.

---

### Q2. What is the default SSH port?

```text
22
```

---

### Q3. Which file stores the SSH server configuration?

```text
/etc/ssh/sshd_config
```

---

### Q4. Difference between Public Key and Private Key?

| Public Key | Private Key |
|------------|-------------|
| Shared with the server | Kept secret by the user |
| Stored in `authorized_keys` | Stored on the client machine |

---

### Q5. Which command generates an SSH key pair?

```bash
ssh-keygen
```

---

### Q6. What is SCP?

SCP (Secure Copy) is used to securely transfer files between systems over SSH.

---

# 🚀 Production Scenarios

## Scenario 1: SSH Connection Refused

### Troubleshooting Steps

```bash
systemctl status sshd
ss -tunlp | grep 22
journalctl -u sshd
```

Verify firewall rules and security groups if hosted in the cloud.

---

## Scenario 2: Permission Denied (Publickey)

### Troubleshooting Steps

- Verify the correct private key is being used.
- Check permissions on the `.ssh` directory and key files.
- Ensure the public key exists in:

```text
~/.ssh/authorized_keys
```

Verify permissions:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

---

## Scenario 3: Unable to Connect to AWS EC2

### Troubleshooting Steps

1. Verify EC2 instance is running.
2. Check Security Group allows inbound SSH (Port 22).
3. Verify Network ACLs.
4. Confirm the correct key pair is being used.
5. Ensure the SSH service is running.

---

# ⚠️ Common Mistakes

- Sharing private keys with others.
- Using incorrect file permissions for SSH keys.
- Editing `sshd_config` without taking a backup.
- Forgetting to restart the SSH service after configuration changes.
- Blocking Port 22 using firewall rules.

---

# 💡 Quick Revision

- `ssh` → Remote login
- `ssh-keygen` → Generate SSH keys
- `ssh-copy-id` → Copy public key
- `scp` → Secure file copy
- `sftp` → Secure file transfer
- `systemctl status sshd` → Check SSH service
- `ss -tunlp | grep 22` → Verify SSH port
- `/etc/ssh/sshd_config` → SSH configuration
- `authorized_keys` → Stores allowed public keys
