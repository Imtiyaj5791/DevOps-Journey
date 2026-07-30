# Docker Important Commands

This document contains commonly used Docker and Docker Compose commands for daily administration and troubleshooting.

---

# Docker Images

### Check all Docker images

```bash
docker images
```

**Purpose:** Display all Docker images available on the local system.

---

### Download an image

```bash
docker pull nginx
```

**Purpose:** Download an image from Docker Hub.

---

### Build an image

```bash
docker build -t my-image .
```

**Purpose:** Build a Docker image from a Dockerfile.

---

### Tag an image

```bash
docker tag my-image:latest my-image:v1
```

**Purpose:** Create another tag for an existing image.

---

### Push an image

```bash
docker push username/my-image:v1
```

**Purpose:** Upload an image to Docker Hub.

---

### Remove an image

```bash
docker rmi nginx
```

**Purpose:** Remove a Docker image.

---

### Remove multiple images

```bash
docker rmi image1 image2 image3
```

**Purpose:** Remove multiple Docker images.

---

### Remove all images

```bash
docker rmi $(docker images -q)
```

**Purpose:** Remove all local Docker images.

---

### View image history

```bash
docker history nginx
```

**Purpose:** Display image layers.

---

### Inspect an image

```bash
docker inspect nginx
```

**Purpose:** Display detailed image information.

---

# Docker Containers

### Run a container

```bash
docker run -d --name nginx-container -p 80:80 nginx
```

**Purpose:** Create and start a container.

---

### List running containers

```bash
docker ps
```

**Purpose:** Display running containers.

---

### List all containers

```bash
docker ps -a
```

**Purpose:** Display running and stopped containers.

---

### Stop a container

```bash
docker stop nginx-container
```

**Purpose:** Stop a running container.

---

### Stop multiple containers

```bash
docker stop container1 container2
```

**Purpose:** Stop multiple containers.

---

### Stop all running containers

```bash
docker stop $(docker ps -q)
```

**Purpose:** Stop all running containers.

---

### Start a container

```bash
docker start nginx-container
```

**Purpose:** Start a stopped container.

---

### Restart a container

```bash
docker restart nginx-container
```

**Purpose:** Restart a container.

---

### Remove a container

```bash
docker rm nginx-container
```

**Purpose:** Remove a stopped container.

---

### Force remove a container

```bash
docker rm -f nginx-container
```

**Purpose:** Force remove a running container.

---

### Remove multiple containers

```bash
docker rm -f container1 container2 container3
```

**Purpose:** Remove multiple containers.

---

### Remove all containers

```bash
docker rm -f $(docker ps -aq)
```

**Purpose:** Remove all containers.

---

### Execute commands inside a container

```bash
docker exec -it nginx-container bash
```

**Purpose:** Open a shell inside the container.

---

### View container logs

```bash
docker logs nginx-container
```

**Purpose:** Display container logs.

---

### Follow live logs

```bash
docker logs -f nginx-container
```

**Purpose:** Display live container logs.

---

### View running processes

```bash
docker top nginx-container
```

**Purpose:** Display running processes inside the container.

---

### Monitor CPU and Memory

```bash
docker stats
```

**Purpose:** Display container resource usage.

---

### Inspect a container

```bash
docker inspect nginx-container
```

**Purpose:** Display detailed container information.

---

### Check changes inside a container

```bash
docker diff nginx-container
```

**Purpose:** Show file changes made inside the container.

---

# Docker Volumes

### List volumes

```bash
docker volume ls
```

**Purpose:** Display all Docker volumes.

---

### Create a volume

```bash
docker volume create mysql-data
```

**Purpose:** Create a named volume.

---

### Inspect a volume

```bash
docker volume inspect mysql-data
```

**Purpose:** Display volume details.

---

### Remove a volume

```bash
docker volume rm mysql-data
```

**Purpose:** Remove a Docker volume.

---

### Remove unused volumes

```bash
docker volume prune
```

**Purpose:** Remove all unused volumes.

---

# Docker Networks

### List networks

```bash
docker network ls
```

**Purpose:** Display all Docker networks.

---

### Create a network

```bash
docker network create my-net
```

**Purpose:** Create a custom Docker network.

---

### Inspect a network

```bash
docker network inspect my-net
```

**Purpose:** Display network details.

---

### Connect container to network

```bash
docker network connect my-net container-name
```

**Purpose:** Connect a running container to a network.

---

### Disconnect container from network

```bash
docker network disconnect my-net container-name
```

**Purpose:** Disconnect a container from a network.

---

### Remove a network

```bash
docker network rm my-net
```

**Purpose:** Remove a Docker network.

---

### Remove unused networks

```bash
docker network prune
```

**Purpose:** Remove all unused Docker networks.

---

# Docker System

### Display Docker disk usage

```bash
docker system df
```

**Purpose:** Show Docker disk usage.

---

### Remove unused objects

```bash
docker system prune
```

**Purpose:** Remove unused containers, networks and dangling images.

---

### Remove everything unused

```bash
docker system prune -a
```

**Purpose:** Remove unused containers, networks and all unused images.

---

# Docker Compose

### Validate Compose file

```bash
docker compose config
```

**Purpose:** Validate docker-compose.yml syntax.

---

### Build images

```bash
docker compose build
```

**Purpose:** Build all service images.

---

### Start services

```bash
docker compose up -d
```

**Purpose:** Start all services.

---

### Build and start services

```bash
docker compose up -d --build
```

**Purpose:** Build images and start services.

---

### Check running services

```bash
docker compose ps
```

**Purpose:** Display Compose containers.

---

### View all logs

```bash
docker compose logs
```

**Purpose:** Display logs of all services.

---

### View logs of one service

```bash
docker compose logs web
```

**Purpose:** Display logs of a specific service.

---

### Execute commands inside a service

```bash
docker compose exec web bash
```

**Purpose:** Open a shell inside a service container.

---

### Stop services

```bash
docker compose stop
```

**Purpose:** Stop Compose services.

---

### Start stopped services

```bash
docker compose start
```

**Purpose:** Start previously stopped services.

---

### Restart services

```bash
docker compose restart
```

**Purpose:** Restart services.

---

### Stop and remove services

```bash
docker compose down
```

**Purpose:** Remove containers and network.

---

### Stop and remove services with volumes

```bash
docker compose down -v
```

**Purpose:** Remove containers, network and volumes.