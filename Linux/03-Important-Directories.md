# 📁 Important Linux Directories

Linux follows a hierarchical directory structure where each directory has a specific purpose. Understanding these directories is essential for Linux Administration and Production Support.

---

# 🏗 Directory Structure

```text
/
├── bin
├── boot
├── dev
├── etc
├── home
├── lib
├── media
├── mnt
├── opt
├── proc
├── root
├── run
├── sbin
├── srv
├── sys
├── tmp
├── usr
└── var
```

---

# 📖 Important Directories

## 📂 /

The root directory. Everything in Linux starts from here.

---

## 📂 /bin

Contains essential user commands.

Examples:

```bash
ls
cp
mv
cat
pwd
```

---

## 📂 /boot

Contains bootloader and Linux kernel files.

Examples:

- vmlinuz
- initramfs
- grub

---

## 📂 /dev

Contains device files.

Examples:

```text
/dev/sda
/dev/null
/dev/tty
```

---

## 📂 /etc

Contains system configuration files.

Examples:

```text
/etc/passwd
/etc/hosts
/etc/fstab
/etc/ssh/sshd_config
```

---

## 📂 /home

Contains home directories of normal users.

Example:

```text
/home/imtiyaj
/home/user1
```

---

## 📂 /root

Home directory of the root user.

---

## 📂 /lib

Contains shared libraries required by system binaries.

---

## 📂 /media

Mount point for removable media.

Example:

- USB Drive
- DVD

---

## 📂 /mnt

Temporary mount point for manually mounted file systems.

---

## 📂 /opt

Used to install third-party applications.

Example:

```text
/opt/tomcat
/opt/google
```

---

## 📂 /proc

Virtual file system containing process and kernel information.

Useful files:

```text
/proc/cpuinfo
/proc/meminfo
```

---

## 📂 /run

Stores runtime information of running services.

---

## 📂 /sbin

Contains system administration commands.

Examples:

```bash
fdisk
fsck
reboot
shutdown
```

---

## 📂 /srv

Stores service-related data.

Example:

- FTP
- Web Server

---

## 📂 /sys

Contains information about hardware and kernel devices.

---

## 📂 /tmp

Stores temporary files.

Contents may be removed after reboot.

---

## 📂 /usr

Contains user applications and utilities.

Examples:

```text
/usr/bin
/usr/sbin
/usr/local
```

---

## 📂 /var

Stores variable data.

Examples:

```text
/var/log
/var/spool
/var/cache
```

---

# 💻 Important Commands

```bash
pwd
ls /
tree /
cd /etc
cd /var/log
du -sh /var
df -h
```

---

# 🎯 Interview Questions

### Q1. Which directory contains Linux configuration files?

**Answer:** `/etc`

---

### Q2. Which directory contains log files?

**Answer:** `/var/log`

---

### Q3. What is the difference between `/home` and `/root`?

| `/home` | `/root` |
|----------|----------|
| Home directory for normal users | Home directory of the root user |

---

### Q4. Which directory contains device files?

**Answer:** `/dev`

---

### Q5. Where are temporary files stored?

**Answer:** `/tmp`

---

# 🚀 Production Notes

- Check `/var/log` first while troubleshooting production issues.
- Never modify files inside `/boot` unless required.
- Verify `/etc` for configuration-related issues.
- Monitor `/var` and `/tmp` regularly to avoid disk space problems.
- Avoid deleting files from system directories without understanding their purpose.
