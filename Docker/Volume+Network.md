# 🐳 Docker Day 2 - Volumes + Network

## 📌 Objective
Learn Docker Volumes and Bind Mounts with hands-on examples.

---

# 📖 What is a Docker Volume?

A Docker Volume is a persistent storage mechanism used to store data outside the container lifecycle.

### Benefits

- Data persists after container deletion
- Best for databases
- Docker manages the storage
- Easy backup and restore

---

# 📦 Types of Storage

## 1. Anonymous Volume

Docker automatically creates the volume.

```bash
-v /var/lib/mysql
```

---

## 2. Named Volume (Recommended)

Docker manages the storage.

```bash
-v mysql-data:/var/lib/mysql
```

---

## 3. Bind Mount

User selects the host directory.

```bash
-v /home/ubuntu/website:/usr/local/apache2/htdocs
```

---

# 🧪 Hands-on 1 : Named Volume

## Create Volume

```bash
docker volume create mysql-data
```

---

## List Volumes

```bash
docker volume ls
```

---

## Inspect Volume

```bash
docker volume inspect mysql-data
```

Example Output

```
Mountpoint:
/var/lib/docker/volumes/mysql-data/_data
```

---

## Run MySQL Container

```bash
docker run -d \
--name mysql-container \
-e MYSQL_ROOT_PASSWORD=Root@123 \
-v mysql-data:/var/lib/mysql \
mysql:8
```

---

## Login to MySQL

```bash
docker exec -it mysql-container mysql -uroot -p
```

Password

```
Root@123
```

---

## Create Database

```sql
CREATE DATABASE companydb;
SHOW DATABASES;
```

Output

```
companydb
```

---

## Delete Container

```bash
docker rm -f mysql-container
```

---

## Recreate Container

```bash
docker run -d \
--name mysql-container \
-e MYSQL_ROOT_PASSWORD=Root@123 \
-v mysql-data:/var/lib/mysql \
mysql:8
```

---

## Verify Persistence

```bash
docker exec -it mysql-container mysql -uroot -p
```

```sql
SHOW DATABASES;
```

Output

```
companydb
```

✅ Database still exists because the data is stored inside the Docker Volume.

---

# 📚 Docker Volume Commands

## List Volumes

```bash
docker volume ls
```

---

## Inspect Volume

```bash
docker volume inspect mysql-data
```

---

## Remove Volume

```bash
docker volume rm mysql-data
```

---

## Remove All Unused Volumes

```bash
docker volume prune
```

---

# 🧪 Hands-on 2 : Bind Mount

Bind Mount maps a host directory into a container.

---

## Create Directory

```bash
mkdir -p ~/website
```

---

## Create HTML File

```bash
nano ~/website/index.html
```

Example

```html
<h1>Hello Docker</h1>
```

---

## Run Apache

```bash
docker run -d \
--name apache-bind \
-p 80:80 \
-v /home/ubuntu/website:/usr/local/apache2/htdocs \
httpd:2.4
```

---

## Verify

```bash
curl localhost
```

Or open

```
http://<EC2-Public-IP>
```

---

## Verify Host → Container

```bash
docker exec -it apache-bind bash
```

```bash
cd /usr/local/apache2/htdocs
ls
```

You will see

```
index.html
```

---

## Modify File on Host

```bash
nano ~/website/index.html
```

Browser updates instantly.

---

## Verify Container → Host

Inside container

```bash
echo "Docker Rocks" > docker.txt
```

Host

```bash
cat ~/website/docker.txt
```

Output

```
Docker Rocks
```

---

# 🧪 Hands-on 3 : Bind Mount with Ubuntu

Create directory

```bash
mkdir ~/project
```

Run Ubuntu

```bash
docker run -it \
--name test-container \
-v /home/ubuntu/project:/project \
ubuntu:24.04 bash
```

Inside container

```bash
cd /project
touch abc
```

Exit container

Host

```bash
ls ~/project
```

Output

```
abc
```

This proves Bind Mount works with any directory.

---

# 🔄 Named Volume vs Bind Mount

| Feature | Named Volume | Bind Mount |
|----------|-------------|------------|
| Managed By | Docker | User |
| Storage Location | Docker | Host Directory |
| Best For | Databases | Source Code |
| Portable | Yes | Less Portable |
| Production Ready | ✅ | ⚠️ Depends |

---

# 🚀 Production Use Cases

## Named Volume

- MySQL
- PostgreSQL
- MongoDB
- Redis
- Jenkins Home
- Grafana

---

## Bind Mount

- Source Code
- Nginx Config
- Apache Config
- Log Files
- Development Environment

---

# 🎯 Interview Questions

### Q1. What is a Docker Volume?

A Docker Volume is a persistent storage used to store data outside the container lifecycle.

---

### Q2. Why do we use Docker Volumes?

To persist data even after a container is deleted.

---

### Q3. Difference between Named Volume and Bind Mount?

| Named Volume | Bind Mount |
|---------------|------------|
| Docker managed | User managed |
| Best for Databases | Best for Source Code |
| Portable | Host dependent |

---

### Q4. Where are Docker Volumes stored?

```
/var/lib/docker/volumes/
```

---

### Q5. Which is recommended for MySQL?

Named Volume.

---

### Q6. Which is recommended for application source code?

Bind Mount.

---

### Q7. How do you inspect a volume?

```bash
docker volume inspect mysql-data
```

---

### Q8. How do you remove unused volumes?

```bash
docker volume prune
```

---

# 📝 Key Takeaways

- Docker Volume provides persistent storage.
- Data survives even if the container is deleted.
- Named Volume is recommended for databases.
- Bind Mount is recommended for development.
- Docker manages Named Volumes.
- Bind Mount maps a host directory directly into the container.
- Use `docker volume inspect` to view volume details.
- Always use Named Volumes for production databases.