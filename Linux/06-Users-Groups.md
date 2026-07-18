# 👥 Linux Users and Groups

Linux is a multi-user operating system where every user belongs to one or more groups. Proper user and group management is essential for security, access control, and system administration.

---

# 📚 User Types

| User Type | Description |
|------------|-------------|
| Root User | Superuser with full system privileges |
| Normal User | Regular user with limited permissions |
| System User | Used by services like Nginx, Apache, MySQL |

---

# 👤 User Information Files

| File | Purpose |
|------|---------|
| `/etc/passwd` | User account information |
| `/etc/shadow` | Encrypted passwords |
| `/etc/group` | Group information |
| `/etc/gshadow` | Group passwords |

---

# 👥 Groups

A group is a collection of users who share the same permissions.

### Types of Groups

- Primary Group
- Secondary Group

Example:

```text
User : imtiyaj

Primary Group : imtiyaj

Secondary Groups :
- sudo
- docker
- developers
```

---

# 💻 Important Commands

## Create User

```bash
useradd john
```

---

## Set Password

```bash
passwd john
```

---

## Create Group

```bash
groupadd developers
```

---

## Add User to Group

```bash
usermod -aG developers john
```

---

## View User Information

```bash
id john
```

---

## View User Groups

```bash
groups john
```

---

## Delete User

```bash
userdel -r john
```

---

## Delete Group

```bash
groupdel developers
```

---

# 📖 Practical Examples

### Create a New User

```bash
useradd devuser
passwd devuser
```

---

### Create a New Group

```bash
groupadd awsadmins
```

---

### Add User to Docker Group

```bash
usermod -aG docker devuser
```

---

### Verify User Details

```bash
id devuser
```

Example Output:

```text
uid=1001(devuser)
gid=1001(devuser)
groups=1001(devuser),998(docker)
```

---

# 🎯 Interview Questions

### Q1. What is the difference between Root User and Normal User?

| Root User | Normal User |
|------------|-------------|
| Full system access | Limited permissions |
| UID = 0 | UID starts from 1000 (in most Linux distributions) |

---

### Q2. Difference between Primary Group and Secondary Group?

| Primary Group | Secondary Group |
|----------------|----------------|
| Assigned during user creation | Additional groups assigned later |
| Only one | One or more |

---

### Q3. Which file stores user information?

**Answer:**

```text
/etc/passwd
```

---

### Q4. Which file stores encrypted passwords?

**Answer:**

```text
/etc/shadow
```



---

### Q5. Which command shows user details?

```bash
id
```

---

### Q6. Which command displays the groups of a user?

```bash
groups
```

---

### Q7. Which command adds a user to a group?

```bash
usermod -aG group_name user_name
```

Example:

```bash
usermod -aG docker john
```
### Q8. Which command deletes a user to a group?

```bash
sudo gpasswd -d username groupname

```

Example:

```bash
sudo gpasswd -d  john docker
```
---

# 🚀 Production Notes

- Never perform daily activities using the **root** account.
- Grant only the minimum required permissions to users.
- Use groups to manage access instead of assigning permissions individually.
- Always verify user membership after modifying groups.
- Regularly remove inactive users from production servers.
- Review `/etc/passwd` and `/etc/group` during access-related troubleshooting.
