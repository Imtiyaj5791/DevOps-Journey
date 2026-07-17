# 📂 Linux File System

The Linux File System is a hierarchical directory structure that starts from the **Root Directory (`/`)**. Everything in Linux, including files, directories, devices, and processes, is organized under this single root.

---

# 🏗 File System Structure

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

| Directory | Purpose |
|-----------|---------|
| `/` | Root directory |
| `/bin` | Essential user commands |
| `/boot` | Boot loader and kernel files |
| `/dev` | Device files |
| `/etc` | Configuration files |
| `/home` | User home directories |
| `/lib` | Shared libraries |
| `/media` | Removable media |
| `/mnt` | Temporary mount point |
| `/opt` | Optional software packages |
| `/proc` | Process and kernel information |
| `/root` | Root user's home directory |
| `/run` | Runtime process information |
| `/sbin` | System administration commands |
| `/srv` | Service data |
| `/sys` | System and hardware information |
| `/tmp` | Temporary files |
| `/usr` | User applications and utilities |
| `/var` | Variable data such as logs |

---

# 💻 Important Commands

```bash
pwd
ls
ls -l
ls -la
cd
tree
find /
du -sh
df -h
```

---

# 🎯 Interview Questions

### Q1. What is the Linux File System?

The Linux File System is a hierarchical structure that stores all files and directories under a single Root (`/`) directory.

---

### Q2. What is the Root Directory?

The Root (`/`) directory is the top-most directory in Linux from which all other directories originate.

---

### Q3. What is the difference between `/home` and `/root`?

| `/home` | `/root` |
|----------|----------|
| Home directories for normal users | Home directory of the root user |
| Accessible by individual users | Accessible only by the root user |

---

### Q4. Where are Linux configuration files stored?

Most Linux configuration files are stored under the `/etc` directory.

---

### Q5. Where are log files stored?

Most system and application log files are stored in the `/var/log` directory.

---

# 🚀 Production Notes

- Always know the purpose of important directories before troubleshooting.
- Check `/var/log` first when investigating production issues.
- Verify `/etc` when debugging configuration-related problems.
- Monitor disk usage in `/var`, `/tmp`, and `/home` to prevent storage issues.
- Never delete files from system directories unless you understand their purpose.
