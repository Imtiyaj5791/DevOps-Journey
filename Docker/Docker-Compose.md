# Docker Compose

## Objective

Learn how to manage multiple Docker containers using a single
`docker-compose.yml` file.

In this practical, we created:

- Flask Application Container
- MySQL Database Container
- Custom Docker Network
- Named Volume
- Environment Variables

------------------------------------------------------------------------

# What is Docker Compose?

Docker Compose is a tool used to define and manage multiple containers
using a single YAML file.

Instead of running multiple long `docker run` commands, we define all
services inside:

```text
docker-compose.yml
```

Then we can start the complete application using:

```bash
docker compose up -d
```

------------------------------------------------------------------------

# Docker Run vs Docker Compose

## Docker Run

Used mainly to start a single container.

Example:

```bash
docker run -d \
--name nginx-container \
-p 80:80 \
nginx
```

## Docker Compose

Used to manage multiple related containers.

Example:

```yaml
services:
  web:
    image: nginx

  db:
    image: mysql:8
```

Start both containers:

```bash
docker compose up -d
```

------------------------------------------------------------------------

# Project Architecture

```text
Browser
   |
   | Port 5000
   v
Flask Container
   |
   | DB_HOST=db
   v
MySQL Container
   |
   v
Named Volume
```

------------------------------------------------------------------------

# Project Structure

```text
docker-compose-flask-mysql/
├── app.py
├── Dockerfile
├── docker-compose.yml
└── requirements.txt
```

------------------------------------------------------------------------

# Flask Application Dockerfile

```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
```

------------------------------------------------------------------------

# Docker Compose File

```yaml
services:
  web:
    build: .
    image: imtiyaj-flask:latest
    container_name: flask_app
    ports:
      - "5000:5000"
    networks:
      - my-net
    depends_on:
      - db
    environment:
      DB_HOST: db
      DB_USER: imtiyaj
      DB_PASSWORD: root
      DB_NAME: mydb

  db:
    image: mysql:8
    container_name: mysql_db
    networks:
      - my-net
    volumes:
      - mysql-data:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: mydb
      MYSQL_USER: imtiyaj
      MYSQL_PASSWORD: root

networks:
  my-net:

volumes:
  mysql-data:
```

------------------------------------------------------------------------

# Services

A service represents one container configuration.

In this project, we created two services:

```text
web
db
```

## Web Service

The `web` service runs the Flask application.

```yaml
web:
  build: .
  image: imtiyaj-flask:latest
```

## Database Service

The `db` service runs the MySQL database.

```yaml
db:
  image: mysql:8
```

------------------------------------------------------------------------

# Build

```yaml
build: .
```

It tells Docker Compose to build an image using the Dockerfile available
in the current directory.

Equivalent Docker command:

```bash
docker build -t imtiyaj-flask:latest .
```

------------------------------------------------------------------------

# Image

```yaml
image: imtiyaj-flask:latest
```

It defines the image name and tag.

For MySQL, an existing Docker Hub image is used:

```yaml
image: mysql:8
```

------------------------------------------------------------------------

# Container Name

```yaml
container_name: flask_app
```

It assigns a custom name to the container.

Containers used in this project:

```text
flask_app
mysql_db
```

------------------------------------------------------------------------

# Port Mapping

```yaml
ports:
  - "5000:5000"
```

Format:

```text
Host-Port:Container-Port
```

The Flask application runs on port `5000` inside the container.

It is accessible from the EC2 server using port `5000`.

```text
http://<EC2-Public-IP>:5000
```

------------------------------------------------------------------------

# Environment Variables

Environment variables are used to provide application configuration.

Flask environment variables:

```yaml
environment:
  DB_HOST: db
  DB_USER: imtiyaj
  DB_PASSWORD: root
  DB_NAME: mydb
```

The Flask application reads these variables using:

```python
os.getenv("DB_HOST")
os.getenv("DB_USER")
os.getenv("DB_PASSWORD")
os.getenv("DB_NAME")
```

The environment variable names in Compose must match the names expected
by the application code.

------------------------------------------------------------------------

# DB_HOST and Service Name

```yaml
DB_HOST: db
```

The value `db` is the MySQL service name.

```yaml
services:
  db:
```

Docker Compose provides automatic DNS resolution.

The Flask container connects to MySQL using:

```text
db:3306
```

We do not need to use the MySQL container IP address.

------------------------------------------------------------------------

# Docker Network

Both containers are connected to the same custom Docker network.

```yaml
networks:
  - my-net
```

Network definition:

```yaml
networks:
  my-net:
```

Because both containers use the same network, they can communicate with
each other using service names.

------------------------------------------------------------------------

# Named Volume

```yaml
volumes:
  - mysql-data:/var/lib/mysql
```

The named volume stores MySQL data outside the container lifecycle.

Volume definition:

```yaml
volumes:
  mysql-data:
```

Container path:

```text
/var/lib/mysql
```

The MySQL data remains available even if the MySQL container is deleted.

------------------------------------------------------------------------

# depends_on

```yaml
depends_on:
  - db
```

It tells Docker Compose to start the database container before starting
the Flask container.

Important:

`depends_on` only controls the startup order.

It does not guarantee that MySQL is fully ready to accept connections.

------------------------------------------------------------------------

# Validate Compose File

```bash
docker compose config
```

This command validates the syntax of the Compose file.

It also displays the final resolved configuration.

------------------------------------------------------------------------

# Start Application

Build and start containers:

```bash
docker compose up -d --build
```

Start without rebuilding:

```bash
docker compose up -d
```

------------------------------------------------------------------------

# Check Containers

```bash
docker compose ps
```

Or:

```bash
docker ps
```

Expected containers:

```text
flask_app
mysql_db
```

------------------------------------------------------------------------

# View Logs

View logs of all services:

```bash
docker compose logs
```

View Flask logs:

```bash
docker compose logs web
```

View MySQL logs:

```bash
docker compose logs db
```

Follow live logs:

```bash
docker compose logs -f
```

------------------------------------------------------------------------

# MySQL Log Verification

Important MySQL log:

```text
mysqld: ready for connections
```

It means:

- MySQL service started successfully
- MySQL is listening on port 3306
- MySQL is ready to accept connections

------------------------------------------------------------------------

# Flask Log Verification

Important Flask logs:

```text
Serving Flask app 'app'
Running on all addresses (0.0.0.0)
Running on http://127.0.0.1:5000
```

It means:

- Flask application started
- Application is listening on port 5000
- Application is accepting external connections

------------------------------------------------------------------------

# Access Application

Open in browser:

```text
http://<EC2-Public-IP>:5000
```

Expected output:

```text
Flask connected successfully with MySQL
```

This confirms:

- Flask container is running
- MySQL container is running
- Docker network is working
- Environment variables are correct
- Flask is connected to MySQL

------------------------------------------------------------------------

# Execute Command Inside Container

Open Flask container shell:

```bash
docker compose exec web bash
```

Open MySQL shell:

```bash
docker compose exec db mysql -uimtiyaj -proot mydb
```

------------------------------------------------------------------------

# Stop Containers

```bash
docker compose stop
```

This stops the containers but does not remove them.

Start them again:

```bash
docker compose start
```

------------------------------------------------------------------------

# Restart Containers

```bash
docker compose restart
```

Restart only Flask:

```bash
docker compose restart web
```

Restart only MySQL:

```bash
docker compose restart db
```

------------------------------------------------------------------------

# Remove Containers

```bash
docker compose down
```

This removes:

- Containers
- Compose network

It does not remove the named volume by default.

------------------------------------------------------------------------

# Remove Containers and Volume

```bash
docker compose down -v
```

This removes:

- Containers
- Compose network
- Named volume
- MySQL data

Use this command carefully.

------------------------------------------------------------------------

# Container Name Conflict

During the practical, the following error occurred:

```text
Conflict. The container name "/mysql_db" is already in use
```

## Reason

An old container with the same name already existed.

## Check Existing Containers

```bash
docker ps -a
```

## Remove Old Containers

```bash
docker rm -f flask_app mysql_db
```

## Start Compose Again

```bash
docker compose up -d
```

------------------------------------------------------------------------

# Important Docker Compose Commands

```bash
docker compose config
docker compose up -d
docker compose up -d --build
docker compose ps
docker compose logs
docker compose logs -f
docker compose logs web
docker compose logs db
docker compose exec web bash
docker compose stop
docker compose start
docker compose restart
docker compose down
docker compose down -v
```

------------------------------------------------------------------------

# Interview Questions

## Q1. What is Docker Compose?

Docker Compose is a tool used to define and manage multiple Docker
containers using a single YAML file.

## Q2. What is the default Compose filename?

```text
docker-compose.yml
```

or:

```text
compose.yml
```

## Q3. How do you start a Compose application?

```bash
docker compose up -d
```

## Q4. How do you rebuild the application?

```bash
docker compose up -d --build
```

## Q5. How do containers communicate in Compose?

Containers connected to the same network communicate using service
names.

## Q6. Why is `DB_HOST` set to `db`?

Because `db` is the MySQL service name defined in the Compose file.

## Q7. What is the purpose of `depends_on`?

It controls the container startup order.

It does not guarantee that the dependent service is fully ready.

## Q8. What is the purpose of a named volume?

A named volume stores persistent data outside the container lifecycle.

## Q9. What is the difference between `stop` and `down`?

`stop` only stops containers.

`down` stops and removes containers and the Compose network.

## Q10. Does `docker compose down` remove volumes?

No.

To remove the volume:

```bash
docker compose down -v
```

## Q11. How do you check Compose logs?

```bash
docker compose logs
```

## Q12. How do you check logs of one service?

```bash
docker compose logs web
```

## Q13. How do you validate a Compose file?

```bash
docker compose config
```

## Q14. What is a service in Docker Compose?

A service is the configuration used to create and run a container.

## Q15. How do you enter a running Compose container?

```bash
docker compose exec <service-name> bash
```

------------------------------------------------------------------------

# Practical Completed

In this practical:

- Created a Flask Docker image
- Created a MySQL container
- Created a Docker Compose file
- Used two services
- Used environment variables
- Created a custom network
- Used MySQL service name as DB host
- Created a named volume
- Started both containers using one command
- Checked Flask and MySQL logs
- Troubleshot container name conflict
- Verified Flask to MySQL connectivity

------------------------------------------------------------------------

# Key Takeaways

- Docker Compose manages multiple containers
- Compose configuration is written in YAML
- Each container configuration is called a service
- Containers communicate using service names
- Environment variable names must match application code
- Named volumes provide persistent storage
- `depends_on` controls startup order only
- `docker compose logs` is useful for troubleshooting
- `docker compose down` does not remove volumes
- `docker compose down -v` removes persistent data