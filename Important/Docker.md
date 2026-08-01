# Docker Interview Notes (Day-1)

## What is Docker?

Docker is a containerization tool which is used to deploy, run, manage and ship applications inside lightweight containers.

---

## Why do we use Docker when we can deploy the application directly on the server?

We use Docker because it provides the same environment everywhere. If application works on my laptop, it will also work on the testing server and production server.

Docker is lightweight because it uses the host kernel, so it starts very fast and saves resources.

---

## What is the difference between a Docker Image and a Docker Container?

Docker Image is a pre-configured template which contains application code, dependencies, libraries and everything required to run the application.

Docker Container is a running instance of a Docker Image.

---

## What is the difference between Docker and Virtual Machine?

Docker is lightweight and uses the host kernel.

Virtual Machine has its own operating system, so it uses more resources and starts slower than Docker.

---

# Explain Docker Architecture

Docker architecture has five main components:

- Docker CLI
- Docker Daemon
- Docker Images
- Docker Containers
- Docker Registry

When we run a Docker command from Docker CLI, it sends the request to the Docker Daemon.

Docker Daemon is responsible for managing Docker images and containers.

Docker Image is a pre-configured template which contains application code, dependencies and libraries.

Container is the running instance of the Docker Image.

Docker Registry is used to store, pull and push Docker Images.

---

## What happens in the background when you run:

```bash
docker run nginx
```

When we run:

```bash
docker run nginx
```

Docker CLI sends the request to the Docker Daemon.

Docker Daemon first checks whether the nginx image is available locally.

If the image is available, it creates the container.

If the image is not available locally, it pulls the image from Docker Hub and then creates the container.

---

# What is Dockerfile? Why do we use Dockerfile?

We write the code inside the Dockerfile to create our own Docker image.

In the Dockerfile we define:

- Base Image
- Working Directory
- Copy Application Code
- Install Required Dependencies
- Expose Port
- Command to Run Application

### Build Docker Image

```bash
docker build -t myapp:v1 .
```

### Create Container

```bash
docker run -d myapp:v1
```

---

# What is the difference between CMD and ENTRYPOINT?

Both are used to run the application when the container starts.

CMD is the default command, and it can be overridden while running the container.

ENTRYPOINT is the fixed command, and it cannot be overridden while running the container.

---

# What is the difference between COPY and ADD?

COPY is used to copy files from the local machine to the Docker image.

ADD can also copy files, but it has two extra features.

- Extract archived files
- Download files from a remote URL

In production, I prefer COPY unless I specifically need these extra features.

---

# What is the difference between EXPOSE and -p (Port Mapping)?

EXPOSE only documents the container port in the Dockerfile.

It does not publish the port.

The `-p` option is used while running the container to map the container port to the host port so that we can access the application from outside.

### Example

```bash
docker run -d -p 8080:80 nginx
```

Host Port:

```
8080
```

Container Port:

```
80
```
# What is the difference between Volume and Bind Mount?

Both are used for data persistence.

In Named Volume, Docker manages the data.

In Bind Mount, the data is stored on the local machine, and we manage it.

For example, if we have a database container without any volume and someone accidentally removes the container, all the data will be lost.

But if we use a Named Volume, we can create a new container and attach the same volume, and all the data will be available again.

### Create Named Volume

```bash
docker volume create mysql-data
```

### Run Container with Named Volume

```bash
docker run -d \
--name mysql-db \
-v mysql-data:/var/lib/mysql \
mysql:8
```

### Bind Mount Example

```bash
docker run -d \
-v /home/ubuntu/app:/app \
nginx
```

---

# What is Docker Network? Why do we need Docker Networking?

Docker Network is used for communication between containers.

For example, if we have two containers like an application container and a database container, we create a Docker network and attach both containers to the same network.

Then the application can communicate with the database using the container name instead of the IP address.

### Create Network

```bash
docker network create my-network
```

### Run Containers on Network

```bash
docker run -d \
--name mysql \
--network my-network \
mysql:8
```

```bash
docker run -d \
--name flask-app \
--network my-network \
flask-app:v1
```

---

# Why do we use the container name instead of the IP address?

Because if someone removes the container and creates a new one, the container IP may change.

In that case, communication will break.

But the container name remains the same, so communication continues without any changes.

---

# What is Docker Compose? Why do we use it?

Docker Compose is mainly used to create and manage multiple containers using a single YAML file.

Instead of creating containers one by one, we write the configuration in a `docker-compose.yml` file, and with a single command, Docker creates and starts all the required containers.

### Start All Containers

```bash
docker compose up -d
```

### Stop All Containers

```bash
docker compose down
```

### View Running Containers

```bash
docker compose ps
```

### View Logs

```bash
docker compose logs
```

---

# When I run docker compose up -d, what all things happen in the background?

When we run:

```bash
docker compose up -d
```

Docker Compose first reads the `docker-compose.yml` file.

If a service has a **build** section, it builds the Docker image.

If a service uses an **image**, it first checks whether the image is available locally.

If not, it pulls the image from Docker Hub.

Then it creates the required network (if not already created), creates the containers, attaches them to the same network, and starts all the containers in detached mode.

---

# Your Docker container is exiting immediately after starting.

## How will you troubleshoot it?

First, I will check the container status.

```bash
docker ps -a
```

Then I will check the logs.

```bash
docker logs <container_name>
```

If required, I will verify the container configuration.

```bash
docker inspect <container_name>
```

If the issue is still not resolved, then I will check:

- Dockerfile
- Startup Command
- Environment Variables
- Port Mapping
- Volumes

If required, I will coordinate with the application team and share the logs.

---

# Container is running, but the application is not accessible from the browser.

## How will you troubleshoot it?

First, I will check the port mapping.

```bash
docker ps
```

Then I will verify whether the application is listening on the correct port inside the container.

I will test it locally.

```bash
curl localhost:<port>
```

Then I will check the container logs.

```bash
docker logs <container_name>
```

If it works locally but not from outside, I will check:

- Security Group
- Firewall Rules

# What is the difference between docker stop and docker kill?

Docker stop gracefully stops the container, while Docker kill forcefully stops the container immediately.

We usually use docker stop in production because it allows the application to shut down properly.

By default, Docker waits for **10 seconds** before forcefully killing the container.

### Stop Container

```bash
docker stop <container_name>
```

### Stop with Custom Timeout

```bash
docker stop -t 30 <container_name>
```

### Force Kill Container

```bash
docker kill <container_name>
```

---

# What is the difference between docker exec and docker attach?

Both are used to access a running container.

docker exec starts a new shell inside the container.

When we exit, only the shell exits and the container keeps running.

docker attach connects to the main process of the container.

If the main process stops, the container also stops.

### docker exec

```bash
docker exec -it <container_name> bash
```

or

```bash
docker exec -it <container_name> sh
```

### docker attach

```bash
docker attach <container_name>
```

---

# What is Multi-stage Dockerfile? Why do we use it?

Multi-stage Dockerfile is mainly used to reduce the final Docker image size.

In the first stage, we copy the application code and install all the required dependencies.

In the second stage, we copy only the required files from the first stage using `COPY --from=builder`.

This removes unnecessary files and makes the final image smaller.

### Build Multi-stage Image

```bash
docker build -t myapp:v1 .
```

### Example

```dockerfile
FROM maven:3.9 AS builder

WORKDIR /app

COPY . .

RUN mvn clean package

FROM eclipse-temurin:17-jre

WORKDIR /app

COPY --from=builder /app/target/app.jar app.jar

CMD ["java","-jar","app.jar"]
```

---

# Can you give me a real example of Multi-stage?

For example, in a Java application, the first stage uses Maven to build the JAR file.

In the second stage, we use a lightweight JRE image and copy only the JAR file.

We don't copy Maven or the source code, so the final image size is much smaller.

---

# Useful Docker Commands

### Pull Image

```bash
docker pull nginx
```

### List Images

```bash
docker images
```

### List Running Containers

```bash
docker ps
```

### List All Containers

```bash
docker ps -a
```

### Run Container

```bash
docker run -d nginx
```

### Run Container with Port Mapping

```bash
docker run -d -p 8080:80 nginx
```

### Build Docker Image

```bash
docker build -t myapp:v1 .
```

### View Container Logs

```bash
docker logs <container_name>
```

### Inspect Container

```bash
docker inspect <container_name>
```

### Execute Command Inside Container

```bash
docker exec -it <container_name> bash
```

### Stop Container

```bash
docker stop <container_name>
```

### Start Container

```bash
docker start <container_name>
```

### Restart Container

```bash
docker restart <container_name>
```

### Remove Container

```bash
docker rm <container_name>
```

### Remove Image

```bash
docker rmi <image_name>
```

### List Docker Networks

```bash
docker network ls
```

### List Docker Volumes

```bash
docker volume ls
```

### Docker Compose

```bash
docker compose up -d
docker compose down
docker compose ps
docker compose logs
```

---

# Docker Interview Summary

### Docker Basics

- Docker
- Why Docker
- Docker vs VM
- Image vs Container
- Docker Architecture

### Dockerfile

- Dockerfile
- CMD vs ENTRYPOINT
- COPY vs ADD
- EXPOSE vs Port Mapping

### Storage

- Named Volume
- Bind Mount

### Networking

- Docker Network
- Container Name vs IP

### Docker Compose

- docker-compose.yml
- docker compose up -d
- Background Flow

### Troubleshooting

- Container exiting immediately
- Application not accessible
- docker logs
- docker inspect

### Production

- docker stop vs docker kill
- docker exec vs docker attach

### Optimization

- Multi-stage Dockerfile
