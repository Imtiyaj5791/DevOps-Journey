# 🔐 Linux File Permissions

Linux File Permissions control who can read, write, or execute a file or directory. They are an essential part of Linux security and are widely used in production environments.

---

# 📚 Permission Types

| Permission | Symbol | Value |
|------------|--------|------:|
| Read | r | 4 |
| Write | w | 2 |
| Execute | x | 1 |

---

# 👥 Permission Classes

| Class | Description |
|-------|-------------|
| User (u) | File Owner |
| Group (g) | Group Members |
| Others (o) | Everyone Else |

---

# 🏗 Permission Structure

Example:

```text
-rwxr-xr--
```

Breakdown:

```text
- rwx r-x r--
│ │   │   │
│ │   │   └── Others
│ │   └────── Group
│ └────────── Owner
└──────────── File Type
```

Where:

- `-` → Regular File
- `d` → Directory
- `l` → Symbolic Link

---

# 🔢 Numeric Permissions

| Permission | Number |
|------------|-------:|
| rwx | 7 |
| rw- | 6 |
| r-x | 5 |
| r-- | 4 |
| -wx | 3 |
| -w- | 2 |
| --x | 1 |
| --- | 0 |

Examples:

| Permission | Numeric |
|------------|--------:|
| rwxr-xr-x | 755 |
| rw-r--r-- | 644 |
| rw------- | 600 |
| rwxrwxrwx | 777 |

---

# 💻 Important Commands

## View Permissions

```bash
ls -l
```

---

## Change Permissions

```bash
chmod 755 file.sh
chmod 644 file.txt
chmod +x script.sh
```

---

## Change Owner

```bash
chown user file.txt
chown user:group file.txt
```

---

## Change Group

```bash
chgrp developers file.txt
```

---

# 📖 Practical Examples

### Make a Script Executable

```bash
chmod +x deploy.sh
```

---

### Give Read & Write Permission to Owner Only

```bash
chmod 600 secret.txt
```

---

### Change Owner

```bash
chown ubuntu:developers app.log
```

---

# 🎯 Interview Questions

### Q1. What does chmod do?

`chmod` is used to change file or directory permissions.

---

### Q2. What does chown do?

`chown` changes the owner of a file or directory.

---

### Q3. Difference between chmod and chown?

| chmod | chown |
|--------|--------|
| Changes permissions | Changes ownership |
| Works with rwx values | Works with users/groups |

---

### Q4. What is the meaning of 755?

- Owner → Read, Write, Execute
- Group → Read, Execute
- Others → Read, Execute

---

### Q5. What is the meaning of 644?

- Owner → Read, Write
- Group → Read
- Others → Read

---

### Q6. Difference between 777 and 755?

| 777 | 755 |
|------|------|
| Everyone has full access | Only owner has write access |
| Not recommended in production | Recommended for executable files |

---

# 🚀 Production Notes

- Never use **777** in production unless absolutely necessary.
- Follow the **Principle of Least Privilege**.
- Use **644** for configuration files.
- Use **755** for scripts and executable files.
- Verify ownership before troubleshooting "Permission Denied" errors.
- Always use `ls -l` before changing permissions.
