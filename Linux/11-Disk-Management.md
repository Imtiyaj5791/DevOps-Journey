# 💾 Linux Disk Management

Disk Management is one of the most important responsibilities of a Linux Administrator. It involves monitoring disk usage, managing partitions, mounting file systems, and troubleshooting storage-related issues.

---

# 📚 Disk Management Concepts

Before managing disks, understand these basic concepts:

- Disk
- Partition
- File System
- Mount Point
- Swap Space

---

# 📦 Common File Systems

| File System | Description |
|-------------|-------------|
| ext4 | Default Linux file system |
| XFS | High-performance file system (RHEL default) |
| Btrfs | Advanced Linux file system |
| vfat | FAT file system |
| NTFS | Windows file system |

---

# 💻 Important Commands

## Display Disk Usage

```bash
df -h
```

---

## Display Directory Size

```bash
du -sh /var
```

---

## List Block Devices

```bash
lsblk
```

---

## Show Partition Information

```bash
fdisk -l
```

---

## Display Mounted File Systems

```bash
mount
```

---

## Mount a File System

```bash
mount /dev/sdb1 /mnt
```

---

## Unmount a File System

```bash
umount /mnt
```

---

## Display File System UUID

```bash
blkid
```

---

## Check Disk Usage of Current Directory

```bash
du -sh .
```

---

## Check Inode Usage

```bash
df -i
```

---

# 📄 /etc/fstab

The **/etc/fstab** file is used to automatically mount file systems during system boot.

Example:

```text
UUID=xxxx-xxxx   /data   ext4   defaults   0 0
```

View the file:

```bash
cat /etc/fstab
```

---

# 📖 Practical Examples

### Check Available Disk Space

```bash
df -h
```

---

### Find Large Directories

```bash
du -sh /*
```

---

### List All Disks

```bash
lsblk
```

---

### View Partition Details

```bash
fdisk -l
```

---

### Mount a New Disk

```bash
mount /dev/sdb1 /mnt
```

---

# 🎯 Interview Questions

### Q1. Which command checks disk space?

```bash
df -h
```

---

### Q2. Which command checks directory size?

```bash
du -sh
```

---

### Q3. Which command lists disks and partitions?

```bash
lsblk
```

---

### Q4. What is the purpose of `/etc/fstab`?

**Answer:**

It stores file system mount information and automatically mounts file systems during system boot.

---

### Q5. Difference between `df` and `du`?

| df | du |
|----|----|
| Shows filesystem usage | Shows directory/file usage |
| Displays free and used disk space | Displays size of files/directories |

---

### Q6. What is a mount point?

A mount point is a directory where a file system is attached and made accessible.

---

# 🚀 Production Scenarios

## Scenario 1: Disk Usage Reached 100%

### Troubleshooting Steps

```bash
df -h
du -sh /*
du -sh /var/*
find /var/log -type f -size +100M
```

Clean unnecessary logs (only after verification).

---

## Scenario 2: Application Failed Due to No Space Left

### Steps

1. Check disk usage.

```bash
df -h
```

2. Identify large directories.

```bash
du -sh /*
```

3. Check log files.

```bash
du -sh /var/log/*
```

4. Archive or remove unnecessary files after confirmation.

---

## Scenario 3: New Disk Not Visible

### Troubleshooting Steps

```bash
lsblk
fdisk -l
blkid
dmesg | tail
```

---

# ⚠️ Common Mistakes

- Forgetting to update `/etc/fstab` after adding a new disk.
- Deleting production logs without verification.
- Unmounting a file system that is currently in use.
- Ignoring inode usage (`df -i`) when disk space appears available.
- Mounting the wrong partition.

---

# 💡 Quick Revision

- `df -h` → Disk usage
- `du -sh` → Directory size
- `lsblk` → List disks
- `fdisk -l` → Partition details
- `mount` → Mount filesystem
- `umount` → Unmount filesystem
- `blkid` → Display UUID
- `df -i` → Check inode usage
- `/etc/fstab` → Auto-mount configuration
