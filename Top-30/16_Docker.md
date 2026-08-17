# Docker — Top 30 Interview Questions

## 1. What is Docker?

Docker is a containerization platform used to package and run applications inside containers.

A container contains the application code and required libraries and dependencies.

---

## 2. What is a Docker Container?

A Docker container is a running instance of a Docker image.

**Remember:**

    Image     → Template
    Container → Running Instance of Image

---

## 3. What is a Docker Image?

A Docker image is a read-only template used to create containers.

It contains application code, libraries and dependencies required to run the application.

---

## 4. What is the difference between a Docker Image and a Container?

Docker Image is a template that contains application code, libraries and dependencies.

Docker Container is a running instance of that image.

**Remember:**

    Image     → Template
    Container → Running Instance

---

## 5. What is a Dockerfile?

Dockerfile is a text file containing instructions used to build a Docker image.

Example:

    FROM nginx
    COPY index.html /usr/share/nginx/html/

We build the image using:

    docker build -t myapp:v1 .

---

## 6. What is the difference between `docker run` and `docker start`?

`docker run` creates a new container from an image and starts it.

`docker start` starts an existing stopped container.

**Remember:**

    docker run   → Create + Start
    docker start → Start Existing Container

---

## 7. What is the difference between `docker stop` and `docker kill`?

`docker stop` tries to stop the container gracefully.

`docker kill` immediately sends a kill signal to the container.

**Remember:**

    stop → Graceful
    kill → Immediate

---

## 8. What is the difference between `docker exec` and `docker attach`?

`docker exec` is used to run a new command inside a running container.

Example:

    docker exec -it mycontainer /bin/bash

`docker attach` connects our terminal to the main process of the running container.

**Remember:**

    exec   → Run new command inside container
    attach → Connect to main process

---

## 9. How do you check running Docker containers?

Command:

    docker ps

To check running and stopped containers:

    docker ps -a

---

## 10. How do you check Docker container logs?

Command:

    docker logs <container-name>

To continuously follow logs:

    docker logs -f <container-name>

---

## 11. What happens to data if a Docker container is deleted?

Data stored only inside the container's writable layer is normally lost when the container is removed.

For persistent data, we use Docker Volumes or Bind Mounts.

**Remember:**

    Container Deleted
          ↓
    Internal Data Lost

    Volume
          ↓
    Data Persists

---

## 12. What is a Docker Volume?

Docker Volume is used to store container data persistently.

The data remains available even if the container is deleted.

Example:

    docker volume create mysql-data

Then:

    docker run -d \
      -v mysql-data:/var/lib/mysql \
      mysql

**Remember:**

    Volume = Persistent Data

---

## 13. What is a Bind Mount?

Bind Mount maps a file or directory from the host machine directly into the container.

Example:

    docker run -d \
      -v /home/user/data:/app/data \
      myapp

**Remember:**

    Bind Mount = Host Path → Container Path

---

## 14. What is the difference between Docker Volume and Bind Mount?

Docker Volume is managed by Docker.

Bind Mount uses a specific path from the host system.

**Remember:**

    Volume     → Managed by Docker
    Bind Mount → Host filesystem path

---

## 15. What is Docker Networking?

Docker Networking allows containers to communicate with each other and with external networks.

We can create a custom network using:

    docker network create app-network

Then containers connected to the same custom network can communicate using container names.

---

## 16. Why do we use a custom Docker network?

Container IP addresses can change when containers are recreated.

With a custom Docker network, containers can communicate using their names instead of depending on changing IP addresses.

Example:

    frontend → backend

instead of:

    frontend → 172.x.x.x

**Remember:**

    Custom Network → Container Name Communication

---

## 17. What is Docker Port Mapping?

Port mapping allows users to access a container application through a host port.

Example:

    docker run -d -p 8080:80 nginx

Here:

    8080 → Host Port
    80   → Container Port

Flow:

    User
      ↓
    Host:8080
      ↓
    Container:80

---

## 18. What is the difference between `CMD` and `ENTRYPOINT`?

Both are used to define the command that runs when a container starts.

`CMD` provides a default command or arguments and can easily be overridden at runtime.

`ENTRYPOINT` defines the main executable and is not normally replaced in the same way; runtime arguments are typically appended to it.

**Remember:**

    CMD        → Default command/arguments
    ENTRYPOINT → Main executable

---

## 19. What is the difference between `COPY` and `ADD` in Dockerfile?

`COPY` simply copies files/directories from the build context into the image.

`ADD` can do some additional operations, such as automatically extracting a local tar archive.

For normal file copying, `COPY` is generally preferred.

**Remember:**

    COPY → Simple Copy
    ADD  → Copy + Additional Features

---

## 20. What is a Multi-Stage Docker Build?

Multi-stage build is used to reduce the final Docker image size.

In the first stage, we build the application and create the required artifact.

In the second stage, we copy only the required artifact into a smaller runtime image.

Example:

    FROM maven AS builder

    WORKDIR /app
    COPY . .
    RUN mvn package

    FROM eclipse-temurin

    COPY --from=builder /app/target/app.jar /app.jar

    CMD ["java", "-jar", "/app.jar"]

**Remember:**

    Stage 1 → Build Application
    Stage 2 → Copy Required Artifact Only

---

## 21. How do you reduce Docker image size?

We can reduce Docker image size by:

1. Using multi-stage builds
2. Using smaller base images where appropriate
3. Copying only required files
4. Removing unnecessary packages/files
5. Using `.dockerignore`

**Remember:**

    Multi-Stage Build = Important Method

---

## 22. What is `.dockerignore`?

`.dockerignore` is used to prevent unnecessary files from being sent to the Docker build context.

Example:

    .git
    logs/
    node_modules/
    *.log

This can make builds cleaner and reduce unnecessary build context.

---

## 23. What is Docker Hub?

Docker Hub is a container registry where we can store and share Docker images.

Common flow:

    Build Image
        ↓
    Tag Image
        ↓
    Login
        ↓
    Push Image

Example:

    docker tag myapp:latest username/myapp:v1

    docker login

    docker push username/myapp:v1

---

## 24. What is the difference between Docker Hub and Amazon ECR?

Both are container registries used to store Docker/container images.

Docker Hub is a general container registry.

Amazon ECR is AWS's managed container registry service.

**Remember:**

    Docker Hub → Container Registry
    ECR        → AWS Managed Container Registry

---

## 25. What is Docker Compose?

Docker Compose is used to define and run multiple containers together using a YAML file.

For example:

    Frontend
       ↓
    Backend
       ↓
    Database

These services can be defined in a Compose file and started together.

Command:

    docker compose up -d

---

## 26. A Docker container is running, but the application is not accessible. How will you troubleshoot?

First, I will check whether the container is running:

    docker ps

Then I will check:

1. Container logs
2. Port mapping
3. Application process inside the container
4. Docker network
5. Host firewall/Security Group if applicable
6. Application configuration

Useful commands:

    docker logs <container>
    docker port <container>
    docker exec -it <container> /bin/bash

---

## 27. A Docker container keeps restarting. How will you troubleshoot?

First, I will check the container status:

    docker ps -a

Then I will check the logs:

    docker logs <container>

I will verify:

1. Application errors
2. Startup command
3. Environment variables/configuration
4. Required files/dependencies
5. Container exit code
6. Resource-related issues if applicable

I will fix the actual issue based on the error.

---

## 28. You deployed a new Docker image and the application is not working. How will you roll back?

First, I will verify the issue with the new image.

If rollback is required, I will stop/remove the container running the problematic version and start the application using the previous working image tag.

Example:

Current problematic version:

    myapp:v2

Previous working version:

    myapp:v1

Rollback:

    docker stop myapp
    docker rm myapp

    docker run -d \
      --name myapp \
      -p 80:80 \
      myapp:v1

Then I will verify the application.

**Remember:**

    v2 Problem
        ↓
    Stop v2
        ↓
    Run Previous v1
        ↓
    Validate Application

---

## 29. What happens when you run `docker run`?

When we run:

    docker run nginx

Docker checks whether the image is available locally.

If the image is not available locally, Docker pulls it from the configured registry.

Then Docker creates and starts a container from that image.

**Flow:**

    docker run
        ↓
    Check Image Locally
        ↓
    Not Available → Pull Image
        ↓
    Create Container
        ↓
    Start Container

---

## 30. How would you troubleshoot a Docker container that exits immediately after starting?

First, I will check:

    docker ps -a

Then:

    docker logs <container>

I will check the container exit code and verify the main process/startup command.

A container normally remains running while its main process is running.

If the main process exits or fails, the container also exits.

I will fix the application/startup issue based on the logs.

---

# Quick Revision

    Docker
    → Containerization Platform

    Image
    → Template

    Container
    → Running Instance of Image

    Dockerfile
    → Instructions to Build Image

    docker build
    → Build Image

    docker run
    → Create + Start Container

    docker start
    → Start Existing Container

    docker stop
    → Graceful Stop

    docker exec
    → Run Command Inside Container

    docker logs
    → Check Container Logs

    Volume
    → Persistent Data

    Bind Mount
    → Host Path → Container Path

    Docker Network
    → Container Communication

    Custom Network
    → Communicate Using Container Names

    Port Mapping
    → Host Port : Container Port

    CMD
    → Default Command/Arguments

    ENTRYPOINT
    → Main Executable

    Multi-Stage Build
    → Reduce Final Image Size

    .dockerignore
    → Exclude Unnecessary Build Files

    Docker Hub
    → Container Registry

    ECR
    → AWS Managed Container Registry

    Docker Compose
    → Manage Multiple Containers

    Rollback
    → Run Previous Working Image Version

---

# Most Important Interview Questions

1. What is Docker?
2. Docker Image vs Container?
3. What is Dockerfile?
4. `docker run` vs `docker start`?
5. `docker exec` vs `docker attach`?
6. What happens to data when a container is deleted?
7. What is a Docker Volume?
8. Volume vs Bind Mount?
9. What is Docker Networking?
10. Why do we use a custom Docker network?
11. Explain Docker port mapping.
12. CMD vs ENTRYPOINT?
13. COPY vs ADD?
14. What is a Multi-Stage Build?
15. How do you reduce Docker image size?
16. What is `.dockerignore`?
17. Docker Hub vs ECR?
18. What is Docker Compose?
19. Container is running but application is inaccessible. How will you troubleshoot?
20. Container keeps restarting. How will you troubleshoot?
21. How will you roll back a problematic Docker deployment?
22. What happens internally when you run `docker run`?
23. Container exits immediately. How will you troubleshoot?
