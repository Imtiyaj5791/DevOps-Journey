# 🏗 Linux Architecture

Linux Architecture defines how different components of the operating system interact with each other. It consists of four main layers: Hardware, Kernel, Shell, and User Applications.

---

## 📖 Architecture Diagram

```text
+----------------------------+
|     User Applications      |
+----------------------------+
|          Shell             |
+----------------------------+
|          Kernel            |
+----------------------------+
|         Hardware           |
+----------------------------+
```

---

## 📌 Components

### 1. Hardware
The physical components of the computer.

Examples:
- CPU
- RAM
- Hard Disk / SSD
- Network Interface Card (NIC)

---

### 2. Kernel

The Kernel is the core of the Linux operating system.

**Responsibilities:**

- Process Management
- Memory Management
- Device Management
- File System Management
- Network Management
- Security

---

### 3. Shell

The Shell acts as an interface between the user and the Kernel.

Popular Shells:

- Bash
- Sh
- Ksh
- Zsh

Example:

```bash
ls -l
pwd
cd /home
```

---

### 4. User Applications

Applications that users interact with.

Examples:

- Vim
- Nano
- Firefox
- Docker
- Nginx
- Apache

---

## ⚙️ Important Commands

| Command | Description |
|----------|-------------|
| `uname -a` | Display kernel information |
| `hostnamectl` | Show system details |
| `cat /etc/os-release` | Display OS version |
| `lscpu` | CPU information |
| `free -h` | Memory information |
| `lsblk` | List block devices |

---

## 🎯 Interview Questions

### Q1. What is Linux Architecture?

Linux Architecture is the layered design of the Linux operating system consisting of Hardware, Kernel, Shell, and User Applications.

---

### Q2. What is the Kernel?

The Kernel is the core component of Linux that manages hardware resources, processes, memory, file systems, and networking.

---

### Q3. Difference between Kernel and Shell?

| Kernel | Shell |
|--------|-------|
| Core of the Operating System | Command Interpreter |
| Directly interacts with Hardware | Interacts with Kernel |
| Always Running | Runs when user logs in |

---

## 🚀 Production Notes

- The Kernel is responsible for system stability and resource management.
- Shell provides a secure way to interact with the operating system.
- Most production troubleshooting starts by checking Kernel, system resources, and logs.
- Understanding Linux Architecture helps identify whether an issue is related to hardware, the operating system, or the application.
