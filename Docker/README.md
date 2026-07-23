# 🐳 Docker - Day 01: Docker Fundamentals

> **Status:** ✅ Completed
>
> **Goal:** Understand Docker Architecture, Images, Containers, Docker Commands, and Container Lifecycle.

---

# 📚 Topics Covered

- Docker Introduction
- VM vs Container
- Docker Architecture
- Docker Engine
- Docker CLI
- Docker Daemon
- Docker Hub
- Images vs Containers
- Docker Commands
- Port Mapping
- PID 1 Concept
- Docker Exec vs Attach
- Container Lifecycle
- Ephemeral Containers

---

# 1. What is Docker?

Docker is an open-source containerization platform used to build, ship, and run applications consistently across different environments.

### Benefits

- Lightweight
- Fast Deployment
- Portable
- Consistent Environment
- Better Resource Utilization

---

# 2. VM vs Container

| Virtual Machine | Docker Container |
|-----------------|------------------|
| Has Guest OS | Shares Host Kernel |
| Heavy | Lightweight |
| Slow Boot | Fast Startup |
| More Resource Usage | Less Resource Usage |

---

# 3. Docker Architecture

```
Docker CLI
      │
      ▼
Docker Daemon
      │
 ┌────┼─────────────┐
 │    │             │
 ▼    ▼             ▼
Images Containers Networks
      │
      ▼
 Docker Hub
```

### Components

### Docker CLI

Used to execute Docker commands.

Example

```bash
docker run nginx
docker ps
docker images
```

---

### Docker Daemon

Background service that manages Docker.

Responsibilities

- Pull Images
- Create Containers
- Manage Networks
- Manage Volumes

---

### Docker Image

A read-only template used to create containers.

Example

```bash
docker images
```

---

### Docker Container

A running instance of an image.

Example

```bash
docker run nginx
```

---

### Docker Hub

Public registry used to store Docker Images.

---

# 4. docker run Flow

```
docker run nginx

↓

CLI

↓

Daemon

↓

Local Image Available?

↓

No

↓

Pull from Docker Hub

↓

Create Container

↓

Run Application
```

---

# 5. Important Commands

Run Container

```bash
docker run hello-world
```

Run Nginx

```bash
docker run -d --name my-nginx -p 80:80 nginx
```

List Running Containers

```bash
docker ps
```

List All Containers

```bash
docker ps -a
```

List Images

```bash
docker images
```

Enter Container

```bash
docker exec -it my-nginx bash
```

Attach Container

```bash
docker attach my-nginx
```

Stop Container

```bash
docker stop my-nginx
```

Remove Container

```bash
docker rm -f my-nginx
```

---

# 6. Port Mapping

```
Host Port 80
      │
      ▼
Container Port 80
```

Example

```bash
docker run -d -p 8080:80 nginx
```

Access

```
http://EC2-IP:8080
```

---

# 7. docker exec vs docker attach

| docker exec | docker attach |
|-------------|---------------|
| Starts New Process | Connects Existing Process |
| Safe | Can stop container accidentally |
| Most Common | Rarely Used |

---

# 8. PID 1 Concept

PID 1 is the main process inside a container.

If PID 1 exits, the container automatically stops.

Example

```bash
ps -ef
```

---

# 9. Container Lifecycle

```
docker run

↓

Created

↓

Running

↓

Exited

↓

Removed
```

---

# 10. Ephemeral Container

Container data is temporary.

If the container is removed, all data stored inside the container is lost.

Persistent data is stored using Docker Volumes.

---

# 🎯 Interview Questions

### Q1. What is Docker?

**Answer:**
Docker is a containerization platform that packages an application along with its dependencies into a lightweight container, ensuring it runs consistently across different environments.

---

### Q2. Difference between Image and Container?

**Answer:**

- Image → Read-only template.
- Container → Running instance of an image.

---

### Q3. What is Docker Daemon?

**Answer:**
Docker Daemon (`dockerd`) is the background service responsible for creating and managing Docker containers, images, networks, and volumes.

---

### Q4. What happens when we execute `docker run nginx`?

**Answer:**

1. CLI sends request to Daemon.
2. Daemon checks local image.
3. If image is unavailable, Docker downloads it from Docker Hub.
4. Creates a new container.
5. Starts the application.

---

### Q5. Difference between docker exec and docker attach?

**Answer:**

- docker exec starts a new process inside the running container.
- docker attach connects to the existing main process.

---

### Q6. Why does hello-world container exit automatically?

**Answer:**
The `hello-world` program finishes execution immediately. Since PID 1 exits, the container also stops.

---

### Q7. What is PID 1?

**Answer:**
PID 1 is the main process inside the container. Docker monitors this process. If it exits, the container stops automatically.

---

### Q8. What are Ephemeral Containers?

**Answer:**
Containers are temporary by nature. Any data stored inside the container is lost when the container is removed unless Docker Volumes or Bind Mounts are used.

---

# ⭐ Key Takeaways

- Images are Read-only.
- Containers are Running Instances.
- Docker shares Host Kernel.
- Docker Daemon manages Docker resources.
- Docker Hub stores Images.
- Port Mapping exposes container applications.
- PID 1 controls the container lifecycle.
- Containers are Ephemeral.