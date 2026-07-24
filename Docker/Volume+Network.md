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

# 🐳 Docker Day 02 - Docker Networking

> **Status:** ✅ Completed  
> **Goal:** Understand Docker networking, default bridge, custom bridge, container-to-container communication, Docker DNS, host network, and none network.

---

# 📚 Topics Covered

- Docker Networking Introduction
- Docker Network Drivers
- Bridge Network
- Container Private IP
- Docker Network Inspect
- Container-to-Container Communication
- Custom Bridge Network
- Docker DNS / Container Name Resolution
- Host Network
- None Network
- Port Mapping vs Host Network
- Important Docker Network Commands
- Interview Questions

---

# 1. What is Docker Networking?

Docker networking allows containers to communicate with:

- Other containers
- Docker Host
- External Network / Internet

Basic architecture:

```text
Container-1
     │
     │
Docker Network
     │
     │
Container-2
```

---

# 2. List Docker Networks

Command:

```bash
docker network ls
```

Example output:

```text
NETWORK ID     NAME      DRIVER    SCOPE
xxxxxxxxxxxx   bridge    bridge    local
xxxxxxxxxxxx   host      host      local
xxxxxxxxxxxx   none      null      local
```

Docker provides three important default networks:

| Network | Purpose |
|---|---|
| bridge | Default container networking |
| host | Uses host network directly |
| none | No external/container network connectivity |

---

# 3. Bridge Network

`bridge` is Docker's default network.

If we create a container without specifying a network:

```bash
docker run -dit --name cont1 ubuntu:24.04
```

Docker automatically connects it to the default `bridge` network.

---

# 4. Inspect Bridge Network

```bash
docker network inspect bridge
```

Important information:

```text
Subnet  : 172.17.0.0/16
Gateway : 172.17.0.1
```

Example:

```text
Docker Bridge
172.17.0.1
     │
     └── cont1
         172.17.0.2
```

Docker automatically assigns a private IP address to the container.

---

# 5. Create Second Container

```bash
docker run -dit --name cont2 ubuntu:24.04
```

Inspect again:

```bash
docker network inspect bridge
```

Example:

```text
Default Bridge
│
├── cont1 → 172.17.0.2
│
└── cont2 → 172.17.0.3
```

Both containers are connected to the same default bridge network.

---

# 6. Container-to-Container Communication

Enter `cont1`:

```bash
docker exec -it cont1 bash
```

Install ping utility:

```bash
apt update
apt install -y iputils-ping
```

Ping `cont2` using its IP address:

```bash
ping -c 4 172.17.0.3
```

Example:

```text
64 bytes from 172.17.0.3
0% packet loss
```

✅ Container-to-container communication is working.

---

# 7. Default Bridge Limitation

Now try using the container name:

```bash
ping -c 4 cont2
```

Result:

```text
ping: cont2: Name or service not known
```

Therefore:

```text
Default Bridge

IP Address Communication     ✅
Automatic Name Resolution    ❌
```

The default bridge does not provide the same automatic container-name DNS behavior as a user-defined bridge network.

---

# 8. Why Not Use Container IP?

Container IP addresses are dynamic.

Example:

```text
Today:

mysql-db → 172.17.0.3
```

If the container is removed and recreated:

```text
mysql-db → 172.17.0.5
```

If an application has:

```text
DB_HOST=172.17.0.3
```

the connection may fail after the IP changes.

Instead, it is better to use:

```text
DB_HOST=mysql-db
```

This is one major reason for using a **custom bridge network**.

---

# 9. Custom Bridge Network

Create a custom network:

```bash
docker network create app-network
```

Verify:

```bash
docker network ls
```

Inspect:

```bash
docker network inspect app-network
```

---

# 10. Connect Existing Containers

Our `cont1` and `cont2` were already created.

Connect `cont1`:

```bash
docker network connect app-network cont1
```

Connect `cont2`:

```bash
docker network connect app-network cont2
```

Syntax:

```text
docker network connect <network-name> <container-name>
```

Architecture:

```text
              app-network
             /           \
          cont1           cont2
             \             /
              \--- DNS ---/
```

---

# 11. Create a New Container Directly on Custom Network

If the container does not already exist, we can connect it while creating it:

```bash
docker run -dit \
  --name cont3 \
  --network app-network \
  ubuntu:24.04
```

In this case, we do not need:

```bash
docker network connect app-network cont3
```

---

# 12. Test Container Name Resolution

Enter `cont1`:

```bash
docker exec -it cont1 bash
```

Now ping `cont2` using its name:

```bash
ping -c 4 cont2
```

Result:

```text
64 bytes from cont2
```

✅ Name-based communication works.

Docker's built-in DNS resolves:

```text
cont2
  │
  ▼
Container IP
```

---

# 13. Default Bridge vs Custom Bridge

| Feature | Default Bridge | Custom Bridge |
|---|---|---|
| Private IP | ✅ | ✅ |
| Container-to-Container Communication | ✅ | ✅ |
| Communication using IP | ✅ | ✅ |
| Automatic Container Name DNS | ❌ | ✅ |
| Better Application Isolation | Limited | ✅ |
| Recommended for Multi-Container Apps | ❌ | ✅ |

---

# 14. Real-World Example

Consider two containers:

```text
PHP Application
      │
      │ mysql-db:3306
      ▼
MySQL Database
```

Instead of configuring:

```text
DB_HOST=172.18.0.3
```

we can configure:

```text
DB_HOST=mysql-db
```

Docker DNS resolves the container name to its current IP.

This means the application does not need to know the database container's IP address.

---

# 15. Host Network

In host networking, the container shares the host's network namespace.

Normal bridge:

```text
EC2 Host
   │
Docker Bridge
   │
Container
```

Host network:

```text
EC2 Host Network
       │
       │ Shared
       ▼
Container
```

---

# 16. Port Mapping vs Host Network

This command:

```bash
docker run -d \
  --name apache \
  -p 80:80 \
  httpd:2.4
```

does **NOT** mean host networking.

It normally means:

```text
Bridge Network
+
Port Mapping
```

Example:

```text
Host Port 80
     │
     ▼
Container Port 80
```

Actual host networking uses:

```bash
--network host
```

---

# 17. Host Network Practical

Run Apache:

```bash
docker run -d \
  --name apache-host \
  --network host \
  httpd:2.4
```

Notice that we did not use:

```bash
-p 80:80
```

Verify:

```bash
docker ps
```

Test from the host:

```bash
curl localhost
```

Or open:

```text
http://<EC2-PUBLIC-IP>
```

Output:

```text
It works!
```

✅ Apache is directly using the host network.

---

# 18. Why Port Mapping is Not Required with Host Network

With bridge networking:

```text
Browser
   │
Host Port 80
   │
-p 80:80
   │
Container Port 80
```

With host networking:

```text
Browser
   │
Host Port 80
   │
Apache Container
```

The container directly shares the host network namespace.

---

# 19. None Network

`none` disables external and container network connectivity for the container.

Architecture:

```text
Container
    │
    X
No External Network
```

Create container:

```bash
docker run -dit \
  --name cont-none \
  --network none \
  ubuntu:24.04
```

---

# 20. Inspect None Network

```bash
docker network inspect none
```

The `cont-none` container should appear in the output.

---

# 21. Test None Network

Enter container:

```bash
docker exec -it cont-none bash
```

Try:

```bash
apt update
```

It fails because the container does not have network connectivity.

Therefore:

```text
Internet Access              ❌
Other Container Access       ❌
External Network Access      ❌
```

`none` networking is useful when a container should be isolated from the network.

---

# 22. Important Docker Network Commands

### List Networks

```bash
docker network ls
```

### Inspect Network

```bash
docker network inspect bridge
```

### Create Custom Network

```bash
docker network create app-network
```

### Connect Existing Container

```bash
docker network connect app-network cont1
```

### Disconnect Container

```bash
docker network disconnect app-network cont1
```

### Create Container Directly on Network

```bash
docker run -dit \
  --name cont1 \
  --network app-network \
  ubuntu:24.04
```

### Run Container on Host Network

```bash
docker run -d \
  --name apache-host \
  --network host \
  httpd:2.4
```

### Run Container with No Network

```bash
docker run -dit \
  --name cont-none \
  --network none \
  ubuntu:24.04
```

### Remove Network

```bash
docker network rm app-network
```

### Remove Unused Networks

```bash
docker network prune
```

---

# 🎯 Interview Questions

## Q1. What is Docker Networking?

Docker networking allows containers to communicate with other containers, the Docker host, and external networks.

---

## Q2. What are the common Docker network drivers?

The common network drivers are:

- Bridge
- Host
- None

Docker also supports other networking drivers depending on the environment.

---

## Q3. What is the default Docker network?

The default network is:

```text
bridge
```

If no network is specified while creating a container, Docker normally attaches it to the default bridge network.

---

## Q4. What is a custom bridge network?

A custom or user-defined bridge network is a Docker network created by the user.

Example:

```bash
docker network create app-network
```

It provides features such as automatic DNS-based container name resolution and better application isolation.

---

## Q5. Why use container names instead of IP addresses?

Container IP addresses can change when containers are recreated.

Using container names avoids hardcoding dynamic IP addresses.

Example:

```text
mysql-db
```

instead of:

```text
172.18.0.3
```

---

## Q6. How can two containers communicate using their names?

Connect both containers to the same user-defined bridge network.

Example:

```bash
docker network create app-network

docker run -dit \
  --name cont1 \
  --network app-network \
  ubuntu:24.04

docker run -dit \
  --name cont2 \
  --network app-network \
  ubuntu:24.04
```

Then:

```bash
docker exec -it cont1 bash
```

```bash
ping cont2
```

---

## Q7. What is Docker DNS?

Docker provides built-in DNS-based service/container name resolution on user-defined networks.

Example:

```text
cont2 → Container IP
```

This allows applications to use container names rather than hardcoded IP addresses.

---

## Q8. What is Host Networking?

Host networking allows a container to share the host's network namespace directly.

Example:

```bash
docker run --network host httpd:2.4
```

Port publishing with `-p` is generally not required.

---

## Q9. Is `-p 80:80` the same as Host Networking?

No.

```bash
docker run -p 80:80 httpd
```

normally uses bridge networking with port publishing.

Host networking uses:

```bash
docker run --network host httpd
```

---

## Q10. What is the None Network?

The `none` network isolates the container from external/container networking.

Example:

```bash
docker run -dit \
  --network none \
  ubuntu:24.04
```

---

## Q11. How do you inspect a Docker network?

```bash
docker network inspect <network-name>
```

Example:

```bash
docker network inspect app-network
```

---

## Q12. How do you connect an existing container to a network?

```bash
docker network connect <network-name> <container-name>
```

Example:

```bash
docker network connect app-network cont1
```

---

# ⭐ Quick Revision

```text
BRIDGE
│
├── Default Docker Network
├── Private Container IP
└── Container Communication

CUSTOM BRIDGE
│
├── Container Communication
├── Automatic DNS
├── Name-Based Communication
└── Better Isolation

HOST
│
├── Shares Host Network Namespace
└── Usually No -p Required

NONE
│
└── No External/Container Network Connectivity
```

---

# ⭐ Key Takeaways

- Docker provides networking between containers and external systems.
- `bridge` is the default Docker network.
- Containers on the default bridge can communicate using IP addresses.
- Container IP addresses can change.
- User-defined bridge networks provide automatic DNS name resolution.
- Container names are preferred over hardcoded container IPs.
- `docker network connect` connects an existing container to a network.
- `--network` can connect a container while creating it.
- Host networking shares the host network namespace.
- `-p 80:80` is port mapping, not host networking.
- None networking isolates a container from external/container networking.
- `docker network inspect` is an important troubleshooting command.

---

# ✅ Day 02 Status

## Docker Volumes
- Named Volume ✅
- Bind Mount ✅
- MySQL Persistence Lab ✅
- Apache Bind Mount Lab ✅

## Docker Networking
- Bridge Network ✅
- Custom Bridge Network ✅
- Container-to-Container Communication ✅
- Docker DNS ✅
- Host Network ✅
- None Network ✅
- Hands-on Labs ✅

**Docker Day 02 Completed Successfully. 🎉**