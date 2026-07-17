# 💻 Basic Linux Commands

Linux commands are used to perform day-to-day administration tasks such as navigating directories, managing files, checking system information, and troubleshooting servers.

---

# 📚 Command Categories

- Navigation Commands
- File & Directory Commands
- File Viewing Commands
- Search Commands
- System Information Commands

---

# 📂 Navigation Commands

| Command | Description |
|----------|-------------|
| `pwd` | Display current working directory |
| `ls` | List files and directories |
| `ls -l` | Long listing format |
| `ls -la` | Show hidden files |
| `cd` | Change directory |
| `cd ..` | Move one directory back |
| `cd ~` | Go to the home directory |

### Example

```bash
pwd
ls -la
cd /etc
cd ..
cd ~
```

---

# 📁 File & Directory Commands

| Command | Description |
|----------|-------------|
| `touch` | Create an empty file |
| `mkdir` | Create a directory |
| `mkdir -p` | Create nested directories |
| `cp` | Copy files/directories |
| `mv` | Move or rename files |
| `rm` | Delete files |
| `rm -rf` | Delete directories recursively |

### Example

```bash
touch notes.txt
mkdir Linux
cp file1 file2
mv old.txt new.txt
rm test.txt
```

---

# 📖 File Viewing Commands

| Command | Description |
|----------|-------------|
| `cat` | Display file contents |
| `less` | View large files |
| `head` | Display first 10 lines |
| `tail` | Display last 10 lines |
| `tail -f` | Monitor log files in real time |

### Example

```bash
cat /etc/passwd
head file.txt
tail -f /var/log/messages
```

---

# 🔍 Search Commands

| Command | Description |
|----------|-------------|
| `find` | Search files/directories |
| `grep` | Search text inside files |
| `which` | Find command location |
| `whereis` | Find binary, source, and man page |

### Example

```bash
find / -name "*.log"
grep "error" app.log
which ssh
whereis python
```

---

# 🖥 System Information Commands

| Command | Description |
|----------|-------------|
| `hostname` | Display hostname |
| `hostnamectl` | Show system information |
| `uname -a` | Display kernel information |
| `date` | Display current date and time |
| `uptime` | Show uptime and load |
| `whoami` | Display current user |

### Example

```bash
hostname
uname -a
uptime
date
whoami
```

---

# 🎯 Interview Questions

### Q1. What is the difference between `cp` and `mv`?

| `cp` | `mv` |
|-------|------|
| Copies files/directories | Moves or renames files |
| Original file remains | Original file is moved |

---

### Q2. What is the difference between `cat` and `less`?

| `cat` | `less` |
|--------|---------|
| Displays the entire file at once | Opens the file page by page |
| Suitable for small files | Suitable for large files |

---

### Q3. Which command is used to find files?

**Answer:**

```bash
find
```

---

### Q4. Which command is used to search text inside a file?

**Answer:**

```bash
grep
```

---

### Q5. Which command shows the current working directory?

**Answer:**

```bash
pwd
```

---

# 🚀 Production Notes

- Use `ls -la` to view hidden files while troubleshooting.
- Use `tail -f` to monitor logs in real time.
- Use `grep` to quickly search for errors in log files.
- Use `find` to locate configuration files and logs.
- Avoid using `rm -rf` on production servers without verifying the path.
