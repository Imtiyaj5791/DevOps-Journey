# 🐳 Docker

> **Docker Documentation | DevOps | Production Notes | Interview Preparation**



# 📖 Introduction

Docker is an open-source containerization platform that allows developers to package applications along with all required dependencies into lightweight and portable containers.

It ensures that applications run consistently across Development, Testing, Staging, and Production environments.

---

# 🚀 What is Docker?

### Definition

Docker is a containerization platform that allows you to build, ship, and run applications inside lightweight containers.

### Explanation

Docker packages an application together with its libraries, runtime, dependencies, and configuration into a single container.

Since everything required by the application is already included, the application behaves the same regardless of where it is deployed.

### Why Docker?

- Fast Deployment
- Environment Consistency
- Lightweight
- Portable
- Easy Scaling
- Better Resource Utilization

### Production Example

A Java application runs successfully on the developer's laptop but fails on the production server due to different Java versions.

Using Docker, the same image runs identically in every environment because all dependencies are bundled together.

---

# ⚙ Why Docker?

Traditional deployments often fail because development and production environments differ.

Docker solves this problem by packaging the application and its runtime together.

### Without Docker

```
Developer Laptop

Java 17
Ubuntu
Application

        ❌

Production

Java 11
Different Libraries

Application Failed
```

### With Docker

```
Docker Image

Application
Java
Libraries
Dependencies

        ↓

Development ✅

Testing ✅

Production ✅
```

---

# 🏗 Docker Architecture

Docker follows a Client-Server architecture.

```
Developer

Docker CLI

      │

Docker Daemon

      │

Docker Image

      │

Docker Container
```

Docker Client sends commands.

Docker Daemon performs all operations.

Images are used to create Containers.

---

# 🧩 Docker Components

Docker consists of five major components.

## Docker Client

### Definition

Docker Client is the command line interface used to communicate with Docker.

### Common Commands

```bash
docker run
docker build
docker pull
docker push
docker ps
```

### Production Example

A DevOps Engineer deploys an application using Docker CLI from a Jenkins Pipeline.

---

## Docker Daemon

### Definition

Docker Daemon is the background service responsible for managing Docker objects.

### Responsibilities

- Build Images
- Run Containers
- Pull Images
- Push Images
- Manage Networks
- Manage Volumes

### Production Example

When Jenkins executes

```bash
docker build
```

Docker Daemon performs the actual image build.

---

## Docker Registry

### Definition

Docker Registry is a repository used to store and distribute Docker images.

### Popular Registries

- Docker Hub
- Amazon ECR
- Azure ACR
- Google Artifact Registry

### Production Example

After building an application image, it is pushed to Amazon ECR before deployment to ECS.

---

# 📦 Docker Image

### Definition

A Docker Image is a read-only template used to create Docker containers.

### Explanation

A Docker Image contains:

- Operating System
- Runtime
- Libraries
- Application Code
- Dependencies

Images cannot be modified after creation.

Every new container starts from an image.

### Example

```
Docker Image

Ubuntu

↓

Java

↓

Application

↓

Dependencies
```

### Production Example

A company builds one Docker image and deploys the same image to Development, QA, UAT, and Production.

---

# 📦 Docker Container

### Definition

A Docker Container is a running instance of a Docker Image.

### Explanation

Containers are isolated environments where applications execute.

Multiple containers can be created from a single image.

### Example

```
Docker Image

↓

Container-1

Container-2

Container-3
```

### Production Example

A Load Balancer distributes requests among multiple Nginx containers running from the same Docker image.

---

# ⚖ Container vs Virtual Machine

| Feature | Docker Container | Virtual Machine |
|----------|------------------|-----------------|
| OS | Shares Host Kernel | Own Guest OS |
| Size | MB | GB |
| Startup | Seconds | Minutes |
| Performance | High | Lower |
| Isolation | Process Level | Full OS Level |
| Resource Usage | Low | High |

### Production Example

Instead of running 20 Virtual Machines, organizations deploy 20 Docker containers on the same host to reduce infrastructure costs.

---

# 🔧 Docker Installation

Example (Ubuntu)

```bash
sudo apt update

sudo apt install docker.io -y

sudo systemctl enable docker

sudo systemctl start docker

docker --version
```

---

# 👤 Add User to Docker Group

Without adding the user to the Docker group, Docker commands require sudo.

```bash
sudo usermod -aG docker $USER

newgrp docker
```

### Verify

```bash
docker ps
```

---

# 🔄 Docker Workflow

```
Dockerfile

      │

docker build

      │

Docker Image

      │

docker run

      │

Docker Container
```

---

# 💻 Attached Mode

### Definition

Runs the container in the foreground.

### Command

```bash
docker run -it ubuntu
```

### Use Case

- Testing
- Learning
- Troubleshooting

---

# 🌐 Detached Mode

### Definition

Runs the container in the background.

### Command

```bash
docker run -itd -p 80:80 nginx
```

### Use Case

Production deployments.

---

# 📥 Enter into Running Container

```bash
docker attach <container-id>
```

> **Note:** In production, `docker exec -it <container-id> bash` is generally preferred because it opens a new shell without attaching to the container's main process.

---

# 🔐 Docker Login

```bash
docker login
```

Used to authenticate with Docker Hub before pushing or pulling private images.

---

# ✏ Rename Container

```bash
docker rename old-name new-name
```

---

# 🗑 Remove Container

Single Container

```bash
docker rm <container-id>
```

All Stopped Containers

```bash
docker rm $(docker ps -aq)
```

---

# 🧹 Docker Cleanup

Remove Unused Images

```bash
docker rmi $(docker images -aq)
```

Clean Unused Docker Resources

```bash
docker system prune
```

### Best Practice

Run cleanup carefully in production because it removes unused Docker resources.

---
# 📝 Dockerfile

### Definition

A Dockerfile is a text file that contains instructions for building a Docker image.

### Explanation

Instead of creating containers manually every time, Dockerfile automates the entire image creation process.

Docker executes every instruction from top to bottom and creates image layers.

### Docker Build Flow

Dockerfile

↓

docker build

↓

Docker Image

↓

docker run

↓

Docker Container

### Production Example

A DevOps Engineer writes one Dockerfile for a Spring Boot application.

Whenever developers push code, Jenkins automatically builds the Docker image using the same Dockerfile.

---

# 🏗 Dockerfile Instructions

---

# FROM

### Definition

Specifies the base image used for building a Docker image.

### Syntax

```dockerfile
FROM openjdk:17-jdk-alpine
```

### Explanation

Every Docker image starts from another image.

Without FROM, Docker cannot build an image.

### Production Example

Java applications usually use

```dockerfile
FROM openjdk:17-jdk-alpine
```

---

# RUN

### Definition

Executes commands while building the Docker image.

### Syntax

```dockerfile
RUN apt update
RUN apt install -y nginx
```

### Common Uses

- Install packages
- Compile code
- Create directories
- Configure software

### Production Example

Install Maven during image build.

```dockerfile
RUN apt install maven -y
```

---

# COPY

### Definition

Copies files from the local machine into the Docker image.

### Syntax

```dockerfile
COPY . .
```

### Explanation

COPY only copies local files.

It cannot download files from the Internet.

### Production Example

Copy application source code into the container.

---

# ADD

### Definition

Copies local files and can also download remote files.

### Syntax

```dockerfile
ADD app.tar.gz /app
```

### Difference

COPY

✔ Local Files

ADD

✔ Local Files

✔ Remote URLs

✔ Auto Extract Tar Files

### Best Practice

Use COPY unless ADD is specifically required.

---

# WORKDIR

### Definition

Sets the working directory inside the container.

### Syntax

```dockerfile
WORKDIR /app
```

### Explanation

Every command after WORKDIR executes inside that directory.

---

# EXPOSE

### Definition

Documents the network port used by the application.

### Syntax

```dockerfile
EXPOSE 8080
```

### Explanation

EXPOSE does not publish the port.

Port mapping still requires

```bash
docker run -p
```

---

# CMD

### Definition

Specifies the default command executed when the container starts.

### Syntax

```dockerfile
CMD ["java","-jar","app.jar"]
```

### Important

Only one CMD should exist.

The last CMD overrides previous CMD instructions.

---

# ENTRYPOINT

### Definition

Defines the main executable of the container.

### Syntax

```dockerfile
ENTRYPOINT ["java","-jar","app.jar"]
```

### Difference

CMD

Can be overridden.

ENTRYPOINT

Always executes.

---

# Dockerfile Execution Order

```
FROM

↓

WORKDIR

↓

COPY

↓

RUN

↓

EXPOSE

↓

CMD / ENTRYPOINT
```

---

# Complete Java Dockerfile

```dockerfile
FROM openjdk:17-jdk-alpine

WORKDIR /app

COPY . .

RUN javac Main.java

EXPOSE 8000

CMD ["java","Main"]
```

### Build Image

```bash
docker build -t java-app:latest .
```

### Run Container

```bash
docker run -itd --name java-app -p 8000:8000 java-app:latest
```

### Production Example

A CI/CD pipeline automatically builds this image after every successful code commit.

---

# Python Application

### Dockerfile

```dockerfile
FROM python:3.9-slim

WORKDIR /app

COPY . .

RUN pip install -r requirements.txt

EXPOSE 80

CMD ["python","run.py"]
```

### Build

```bash
docker build -t python-app:latest .
```

### Run

```bash
docker run -itd --name python-app -p 80:80 python-app:latest
```

### Production Example

A Flask API is packaged into a Docker image and deployed to production without installing Python manually on the server.

---

# Node.js Application

### Dockerfile

```dockerfile
FROM node:18-alpine

WORKDIR /app

COPY . .

RUN npm install

EXPOSE 3000

CMD ["npm","run","dev"]
```

### Build

```bash
docker build -t node-app:latest .
```

### Run

```bash
docker run -itd --name node-app -p 3000:3000 node-app:latest
```

### Production Example

A React or Node.js application is deployed as a Docker container behind Nginx or an Application Load Balancer.

---

# 🚀 Multi-Stage Dockerfile

### Definition

A Multi-stage Dockerfile uses multiple build stages to create a smaller and more secure final image.

### Why Multi-Stage?

- Smaller Images
- Faster Deployment
- Better Security
- Remove Build Dependencies
- Production Ready

### Example

```dockerfile
FROM python:3.9-slim AS builder

WORKDIR /app

COPY . .

RUN pip install -r requirements.txt

FROM gcr.io/distroless/python3

WORKDIR /app

COPY --from=builder /app /app

CMD ["run.py"]
```

### Workflow

Builder Image

↓

Compile Application

↓

Copy Required Files

↓

Distroless Image

↓

Production Container

### Distroless Images

Distroless images contain only the application and its runtime dependencies.

They do not include

- Shell
- Package Manager
- Debugging Tools

This reduces attack surface and image size.

### Production Example

Large organizations use Multi-stage Dockerfiles to reduce image size from 1.2 GB to less than 200 MB before deploying applications to Kubernetes.

---


# ☁ Docker Hub

### Definition

Docker Hub is a cloud-based registry used to store, manage, and distribute Docker images.

### Explanation

Docker Hub allows developers to push images after building them and pull the same images from anywhere.

It acts as a centralized repository for Docker images.

### Common Commands

Login

```bash
docker login
```

Pull Image

```bash
docker pull nginx
```

Push Image

```bash
docker push username/app:latest
```

### Production Example

A Jenkins pipeline builds an application image and pushes it to Docker Hub. Production servers pull the latest image directly from Docker Hub.

---

# 💾 Docker Volume

### Definition

A Docker Volume is persistent storage used by containers.

### Explanation

Container data is deleted when the container is removed.

Volumes store data outside the container so it remains available even after the container is recreated.

### Workflow

```
Container

       │

Docker Volume

       │

Persistent Data
```

### Create Volume

```bash
docker volume create my-volume
```

### Mount Volume

```bash
docker run -d \
-v my-volume:/var/lib/mysql \
mysql
```

### Benefits

- Persistent Storage
- Easy Backup
- Easy Restore
- Data Sharing
- Better Performance

### Production Example

A MySQL container stores database files inside a Docker Volume so that database data remains safe even if the container is recreated.

---

# 📂 Bind Mount

### Definition

A Bind Mount maps a host machine directory directly into a container.

### Explanation

Unlike Docker Volumes, Bind Mounts use an existing directory from the host system.

Changes made on either side are reflected immediately.

### Example

```bash
docker run -d \
-v /home/user/project:/app \
nginx
```

### Volume vs Bind Mount

| Feature | Volume | Bind Mount |
|----------|---------|------------|
| Managed by Docker | ✅ | ❌ |
| Host Path Required | ❌ | ✅ |
| Backup | Easy | Manual |
| Best for Production | ✅ | Limited |
| Best for Development | ❌ | ✅ |

### Production Example

Developers use Bind Mounts during development so source code changes are reflected instantly inside the container.

---

# 🌐 Docker Network

### Definition

Docker Network enables communication between containers and external systems.

### Explanation

Every container is attached to a network.

Docker provides multiple network drivers depending on the application architecture.

---

# 🌉 Bridge Network

### Definition

Bridge is the default Docker network for containers running on the same host.

### Example

```
Bridge Network

Container A

Container B

Container C
```

### Create

```bash
docker network create app-network
```

### Run

```bash
docker run -d \
--network app-network \
nginx
```

### Production Example

Frontend and Backend containers communicate through a custom bridge network.

---

# 🖥 Host Network

### Definition

Host Network allows the container to share the host's network stack.

### Explanation

The container does not receive a separate IP address.

### Example

```bash
docker run --network host nginx
```

### Use Case

- Low Latency Applications
- Monitoring Tools

### Production Example

Prometheus Node Exporter commonly runs in Host Network mode.

---

# 🚫 None Network

### Definition

None Network disables all networking for a container.

### Example

```bash
docker run --network none ubuntu
```

### Use Case

Offline processing or isolated workloads.

---

# 🔗 User Defined Bridge Network

### Definition

A User Defined Bridge is a custom bridge network created by users.

### Benefits

- Automatic DNS Resolution
- Better Isolation
- Easy Container Communication

### Create

```bash
docker network create backend-network
```

### Example

```
backend-network

Web

↓

API

↓

Database
```

### Production Example

Three-tier applications use custom bridge networks to isolate frontend, backend, and database communication.

---

# 🏗 Two-Tier Application

### Definition

A Two-Tier Application consists of an Application Layer and a Database Layer.

### Architecture

```
Users

↓

Application Container

↓

MySQL Container

↓

Docker Volume
```

### Run MySQL

```bash
docker run -d \
--name mysql \
-v mysql-data:/var/lib/mysql \
mysql
```

### Run Application

```bash
docker run -d \
--name app \
--network backend-network \
application-image
```

### Production Example

A Spring Boot application connects to a MySQL container using the container name over a custom Docker network.

---

# 🐙 Docker Compose

### Definition

Docker Compose is a tool used to manage multiple containers using a single YAML file.

### Why Docker Compose?

Without Compose

```
docker run

docker run

docker run

docker run
```

With Compose

```
docker compose up -d
```

### Example docker-compose.yml

```yaml
version: "3.9"

services:

  web:
    image: nginx
    ports:
      - "80:80"

  mysql:
    image: mysql
    environment:
      MYSQL_ROOT_PASSWORD: root
```

### Common Commands

Start

```bash
docker compose up -d
```

Stop

```bash
docker compose down
```

Restart

```bash
docker compose restart
```

Logs

```bash
docker compose logs
```

### Benefits

- Easy Deployment
- Infrastructure as Code
- Multi-container Management
- Repeatable Environment

### Production Example

A complete application stack consisting of Nginx, Spring Boot, Redis, and MySQL is deployed using a single Docker Compose file.

---

# ⭐ Best Practices

- Use official base images whenever possible.
- Keep images lightweight.
- Use Multi-stage Dockerfiles.
- Avoid running containers as the root user.
- Store secrets outside Docker images.
- Use Docker Volumes for persistent data.
- Remove unused images and containers regularly.
- Tag images with versions instead of using only `latest`.
- Monitor container health.
- Scan images for vulnerabilities before deployment.

---
# 🎯 Docker Production Interview Questions & Answers

---

# 1. Your Docker container is continuously restarting. How will you troubleshoot?

### Answer

Follow this approach:

1. Check container status.

```bash
docker ps -a
```

2. Check container logs.

```bash
docker logs <container-id>
```

3. Inspect exit code.

```bash
docker inspect <container-id>
```

4. Verify CMD or ENTRYPOINT.
5. Check environment variables.
6. Verify mounted volumes.
7. Restart after fixing the issue.

### Production Example

A Spring Boot container kept restarting because the database hostname was incorrect. After correcting the environment variable and recreating the container, the application started successfully.

---

# 2. Application is running but not accessible from the browser.

### Answer

Check:

- Is the container running?
- Is the application listening on the correct port?
- Is the port published?

```bash
docker ps
```

Verify

```bash
docker run -p 8080:8080
```

Also verify:

- Firewall
- Security Group (AWS)
- Application logs

---

# 3. Docker image size is 2 GB. How will you reduce it?

### Answer

Best practices:

- Use Alpine images.
- Use Multi-stage Dockerfile.
- Remove unnecessary packages.
- Clean package cache.
- Use Distroless images.
- Combine RUN commands.

### Production Example

A Java image was reduced from **1.5 GB to 180 MB** using Multi-stage Dockerfile and Distroless image.

---

# 4. Difference between Docker Image and Container?

### Answer

| Docker Image | Docker Container |
|--------------|------------------|
| Template | Running Instance |
| Read Only | Read/Write |
| Static | Dynamic |
| Created once | Can run multiple times |

---

# 5. Difference between COPY and ADD?

### Answer

COPY

- Copies local files only.

ADD

- Copies local files.
- Downloads remote files.
- Extracts tar archives automatically.

### Best Practice

Always use **COPY** unless ADD is specifically required.

---

# 6. Difference between CMD and ENTRYPOINT?

### Answer

CMD

- Default command.
- Can be overridden.

ENTRYPOINT

- Main executable.
- Always executes.

### Best Practice

Use ENTRYPOINT for the application and CMD for default arguments.

---

# 7. What happens if a container is deleted without using a Docker Volume?

### Answer

Container data is permanently lost because the writable layer is deleted.

### Solution

Use Docker Volumes for persistent application or database data.

---

# 8. Difference between Docker Volume and Bind Mount?

### Answer

| Volume | Bind Mount |
|---------|------------|
| Docker Managed | Host Managed |
| Better Security | Less Secure |
| Best for Production | Best for Development |
| Portable | Host Dependent |

---

# 9. How do containers communicate with each other?

### Answer

Containers communicate using Docker Networks.

Instead of using IP addresses, use the container name.

Example

```
Frontend

↓

Backend

↓

Database
```

---

# 10. What is the purpose of Docker Compose?

### Answer

Docker Compose manages multiple containers using a single YAML file.

Example

```bash
docker compose up -d
```

It automatically creates:

- Containers
- Networks
- Volumes

---

# 11. Docker daemon is not running. How will you troubleshoot?

### Answer

Check service status.

```bash
systemctl status docker
```

Start service.

```bash
systemctl start docker
```

Enable service.

```bash
systemctl enable docker
```

Verify

```bash
docker version
```

---

# 12. A container cannot connect to the MySQL container.

### Answer

Check:

- Docker Network
- MySQL container running
- Environment Variables
- Container Name
- Port Mapping

Verify

```bash
docker network ls

docker network inspect network-name
```

---

# 13. What is a Multi-stage Dockerfile?

### Answer

Multi-stage Dockerfile separates build and runtime environments.

Benefits:

- Smaller Image
- Better Security
- Faster Deployment
- Production Ready

---

# 14. Why should we avoid running containers as root?

### Answer

Running containers as root increases security risk.

Best Practice

Create a non-root user.

```dockerfile
RUN adduser appuser

USER appuser
```

---

# 15. Explain your Docker deployment process in Production.

### Answer

Typical deployment flow:

```
Developer

↓

Git Push

↓

Jenkins Pipeline

↓

Docker Build

↓

Docker Image

↓

Docker Hub / Amazon ECR

↓

Production Server

↓

docker pull

↓

docker compose up -d

↓

Application Running
```

### Production Steps

1. Developer pushes code to Git.
2. Jenkins triggers the build.
3. Docker image is created.
4. Image is pushed to Docker Hub or Amazon ECR.
5. Production server pulls the latest image.
6. Containers are recreated using Docker Compose.
7. Health checks are verified.
8. Logs and monitoring are checked.

---

# 🚀 Docker Troubleshooting Commands

```bash
docker ps

docker ps -a

docker images

docker logs <container>

docker exec -it <container> bash

docker inspect <container>

docker stats

docker network ls

docker volume ls

docker compose ps

docker compose logs

docker system prune
```

---

# 📌 Quick Revision

- Docker → Containerization Platform
- Image → Template
- Container → Running Instance
- Dockerfile → Image Blueprint
- Volume → Persistent Storage
- Bind Mount → Host Directory Mapping
- Bridge → Default Network
- Compose → Multi-container Deployment
- Multi-stage → Smaller Images
- Distroless → More Secure Images
- Docker Hub → Public Registry
- Amazon ECR → Private Registry

---

# ✅ Docker Complete
