# Docker Interview - Top 15 Production Scenario Questions & Answers

> These are real interview questions for L1/L2 Linux + AWS + Docker Support Engineer.

---

# 1. Container exited automatically. What will you do?

## Answer

First, I will check the container status using ```docker ps -a```. Then I will check the container logs using ```docker logs <container_name>``` to identify why the container exited. I will also check the exit code using ```docker inspect```. If the main process inside the container has stopped or crashed, the container will also stop. After identifying and fixing the application, configuration, resource, or startup issue, I will start the container again and verify its status and logs.

Then I will check the application, configuration and required files.

If the main process is stopping, the container will also stop.

After fixing the issue, I will start the container and verify it is working properly.
```
docker ps -a
docker logs <container_name>
docker inspect <container_name>
docker start <container_name>
docker ps
```
---

# 2. Website is not opening but container is running.

## Answer

First I will check whether the container is running.

```bash
docker ps
```

Then I will verify the port mapping.

```bash
docker ps
docker port <container_name>
```

After that I will check application logs.

```bash
docker logs <container_name>
```

Then I will test the application inside the container.

```bash
docker exec -it <container_name> bash
curl localhost
```

If everything is fine, I will check firewall, Security Group or Load Balancer.

Finally I will verify the website.

---

# 3. Docker daemon is not running.

## Answer

First I will check Docker service.

```bash
systemctl status docker
```

If it is stopped, I will start it.

```bash
sudo systemctl start docker
```

If it is not starting, I will check logs.

```bash
journalctl -u docker
```

Then I will fix the issue and verify Docker is running.

---

# 4. Port already allocated error.

## Answer

First I will identify which container is already using the port.

```bash
docker ps
```

or

```bash
sudo ss -tunlp
```

Then I will either stop that container or use another port.

```bash
docker stop <container_name>
```

or

```bash
docker run -p 8081:80 nginx
```

---

# 5. How do you check Docker logs?

## Answer

I use the docker logs command.

```bash
docker logs <container_name>
```

For live monitoring,

```bash
docker logs -f <container_name>
```

Logs help identify application errors and startup issues.

---

# 6. Difference between CMD and ENTRYPOINT.

## Answer

CMD provides the default command.

ENTRYPOINT always executes the main command.

CMD can be overridden.

ENTRYPOINT is mainly used to fix the executable.

---

# 7. Difference between Image and Container.

## Answer

Image is a template.

Container is a running instance of that image.

One image can create multiple containers.

---

# 8. Difference between Named Volume and Bind Mount.

## Answer

Named Volume is managed by Docker.

Bind Mount uses a host directory.

Named Volume is mostly used for databases.

Bind Mount is mostly used during development.

---

# 9. Database data disappeared after container recreation.

## Answer

First I will check whether a Docker volume was used.

```bash
docker volume ls
```

If the database was running without a volume, the data is lost.

For production I always use Named Volume.

---

# 10. Container is consuming high CPU or Memory.

## Answer

First, I will check the container resource usage using ```docker stats``` and identify which container is consuming high CPU or memory. Then I will check the processes inside that container using ```docker top <container_name>``` and review the application logs using ```docker logs <container_name>```. If required, I will access the running container using docker exec for further troubleshooting. After identifying and fixing the issue, I will monitor the resource utilization again using ```docker stats```.


# 11. Docker image size is very large.

## Answer

I will use Multi-stage Build.

I will remove unnecessary packages.

I will use a lightweight base image like Alpine whenever possible.

Finally I will rebuild the image.

---

# 12. Docker Compose services are not starting.

## Answer

First I will check the Compose file.

```bash
docker compose config
```

Then I will check logs.

```bash
docker compose logs
```

After that I will verify network, volume and environment variables.

Finally I will restart the services.

---

# 13. How do you update a running container?

## Answer

I never modify the running container directly.

I build a new image.

Then I stop the old container.

```bash
docker stop app
docker rm app
```

Finally I start a new container using the latest image.

---

# 14. How do you troubleshoot if Docker application is down?

## Answer

My troubleshooting approach is:

- Check container status
- Check logs
- Check port mapping
- Check application
- Check volume
- Check network
- Check firewall or Security Group
- Verify application

This is my normal production troubleshooting flow.

---

# 15. Which Docker commands do you use daily?

## Answer

Container

```bash
docker ps
docker ps -a
```

Images

```bash
docker images
```

Logs

```bash
docker logs
docker logs -f
```

Execute inside container

```bash
docker exec -it
```

Start/Stop

```bash
docker start
docker stop
docker restart
```

Remove

```bash
docker rm
docker rmi
```

Compose

```bash
docker compose up -d
docker compose down
docker compose logs
```

Volume

```bash
docker volume ls
```

Network

```bash
docker network ls
```

Statistics

```bash
docker stats
```

---

# Interview Tips

✅ Always explain your troubleshooting approach.

Example:

> First I will check the container status.
>
> Then I will verify the logs.
>
> After that I will check port mapping.
>
> Finally I will fix the issue and verify the application.

This simple approach creates a good impression in L1/L2 Docker interviews.
