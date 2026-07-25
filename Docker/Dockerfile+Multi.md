# 🐳 Docker Day 03 - Dockerfile Fundamentals

> **Status:** Part 1   
> **Goal:** Learn how to create custom Docker images using Dockerfile and apply the same pattern to Python, Node.js, and Java applications.


---

# 1. What is a Dockerfile?

A Dockerfile is a text file containing instructions used to build a Docker image.

```text
Application Files
      +
   Dockerfile
      │
      │ docker build
      ▼
 Docker Image
      │
      │ docker run
      ▼
  Container
```

---

# 2. Basic Dockerfile Instructions

| Instruction | Purpose |
|---|---|
| `FROM` | Defines base image |
| `RUN` | Runs commands during image build |
| `COPY` | Copies files into image |
| `WORKDIR` | Sets working directory |
| `CMD` | Default command when container starts |
| `EXPOSE` | Documents application port |
| `ENV` | Sets environment variables |
| `ENTRYPOINT` | Defines fixed executable |
| `ADD` | Copies files with some extra features |
| `ARG` | Defines build-time variables |

---

# 3. FROM

Example:

```dockerfile
FROM python:3.12-slim
```

Meaning:

> Build the custom image on top of the Python 3.12 slim base image.

Other examples:

```dockerfile
FROM node:20-slim
```

```dockerfile
FROM ubuntu:24.04
```

```dockerfile
FROM maven:3.9-eclipse-temurin-17
```

---

# 4. RUN

`RUN` executes commands during image build.

Example:

```dockerfile
RUN apt update && apt install -y apache2
```

Python.py:

```dockerfile
RUN pip install -r requirements.txt
```

Node.js:

```dockerfile
RUN npm install
```

Java:

```dockerfile
RUN mvn package
```

---

# 5. COPY

Copies files from build context into the Docker image.

Example:

```dockerfile
COPY index.html /var/www/html/index.html
```

General syntax:

```text
COPY <source> <destination>
```

Example with `WORKDIR`:

```dockerfile
WORKDIR /app
COPY app.py .
```

This means:

```text
app.py → /app/app.py
```

---

# 6. COPY vs Bind Mount

`COPY` happens during image build.

```text
Host File
   ↓
docker build
   ↓
Image
```

If the host file changes later, the existing image does not automatically update.

Bind Mount is different:

```text
Host Directory
      ↕
Container Directory
```

Changes are reflected immediately.

---

# 7. WORKDIR

Example:

```dockerfile
WORKDIR /app
```

It is similar to:

```bash
cd /app
```

inside the image/container.

After:

```dockerfile
WORKDIR /app
```

this:

```dockerfile
COPY app.py .
```

means:

```text
/app/app.py
```

---

# 8. CMD

`CMD` defines the default command that runs when the container starts.

General pattern:

```dockerfile
CMD ["program", "argument1", "argument2"]
```

Examples:

Python:

```dockerfile
CMD ["python", "app.py"]
```

Node.js:

```dockerfile
CMD ["node", "app.js"]
```

Java:

```dockerfile
CMD ["java", "-cp", "target/docker-demo-1.0.jar", "App"]
```

Important:

> The command inside `CMD` depends on how the application is normally started.

---

# 9. How to Decide CMD?

First find the application's startup command.

If application normally starts with:

```bash
python app.py
```

Dockerfile:

```dockerfile
CMD ["python", "app.py"]
```

If application starts with:

```bash
node app.js
```

Dockerfile:

```dockerfile
CMD ["node", "app.js"]
```

If application starts with:

```bash
java -jar payment.jar
```

Dockerfile:

```dockerfile
CMD ["java", "-jar", "payment.jar"]
```

Do not guess application startup commands.

Use:

- Project README
- Developer instructions
- Existing deployment configuration
- Service configuration
- Application entry point

---

# 10. EXPOSE

Example:

```dockerfile
EXPOSE 5000
```

It documents that the application uses port `5000`.

Important:

```dockerfile
EXPOSE 5000
```

does NOT publish the port to the host.

Actual port publishing:

```bash
docker run -p 5000:5000 my-image
```

Remember:

```text
EXPOSE → Documentation / Metadata
-p     → Actual Port Publishing
```

---

# 11. ENV

Example:

```dockerfile
ENV APP_ENV=production
```

Inside container:

```bash
echo $APP_ENV
```

Output:

```text
production
```

Avoid hardcoding secrets in Dockerfile.

---

# 12. ENTRYPOINT

`ENTRYPOINT` defines a fixed executable.

Example:

```dockerfile
ENTRYPOINT ["python"]
CMD ["app.py"]
```

Together:

```bash
python app.py
```

Basic difference:

```text
ENTRYPOINT → Fixed executable
CMD        → Default command / arguments
```

---

# 13. ADD

Example:

```dockerfile
ADD application.tar.gz /app/
```

`ADD` can perform additional operations such as extracting local tar archives.

For normal file copy:

```dockerfile
COPY
```

is preferred.

---

# 14. ARG

Build-time variable:

```dockerfile
ARG APP_VERSION=1.0
```

Build:

```bash
docker build \
  --build-arg APP_VERSION=2.0 \
  -t myapp .
```

Difference:

```text
ARG → Build time
ENV → Image / Container environment
```

---

# 15. .dockerignore

Example:

```text
.git
*.log
temp
logs
```

It prevents unnecessary files from being included in the Docker build context.

---

# 16. Docker Image Build

Example:

```bash
docker build -t my-apache:v1 .
```

Meaning:

```text
docker build     → Build image
-t               → Tag image
my-apache        → Image name
v1               → Version tag
.                → Current directory as build context
```

---

# 17. Docker Image Layers

Example Dockerfile:

```dockerfile
FROM ubuntu:24.04

RUN apt update && apt install -y apache2
```

Each instruction contributes to the image structure.

Check image history:

```bash
docker history my-apache:v1
```

Example:

```text
Ubuntu Base Layer
      +
Apache Installation Layer
      ↓
Custom Image
```

---

# 18. Docker Build Cache

First build:

```text
FROM ubuntu
RUN install apache
```

Second build:

```dockerfile
FROM ubuntu:24.04

RUN apt update && apt install -y apache2

COPY index.html /var/www/html/index.html
```

During rebuild:

```text
RUN apt install apache
→ Using cache ✅

COPY index.html
→ New layer
```

Example output:

```text
Step 2/3 : RUN apt update && apt install -y apache2
 ---> Using cache
```

---

# 19. Build Cache Best Practice

Good order:

```dockerfile
COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .
```

Why?

If application code changes but dependency file does not change:

```text
pip install layer → reused from cache
application code  → rebuilt
```

This improves build speed.

---

# 🐍 Python Dockerfile Practical

## Project Structure

```text
python-docker-app/
├── app.py
├── requirements.txt
└── Dockerfile
```

---

## app.py

```python
from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "Hello from Python Docker App!"

app.run(host="0.0.0.0", port=5000)
```

---

## requirements.txt

```text
flask
```

---

## Dockerfile

```dockerfile
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
```

---

## Build Image

```bash
docker build -t my-python .
```

---

## Run Container

```bash
docker run -d \
  --name python-app \
  -p 5000:5000 \
  my-python
```

---

## Verify

```bash
docker ps
```

```bash
curl localhost:5000
```

Output:

```text
Hello from Python Docker App!
```

Browser:

```text
http://<EC2-PUBLIC-IP>:5000
```

---

# 🟢 Node.js Dockerfile Practical

## Project Structure

```text
node-docker-app/
├── app.js
├── package.json
└── Dockerfile
```

---

## app.js

```javascript
const express = require("express");

const app = express();

app.get("/", (req, res) => {
  res.send("Hello from Node.js Docker App!");
});

app.listen(3000, "0.0.0.0", () => {
  console.log("Server running on port 3000");
});
```

---

## package.json

```json
{
  "name": "node-docker-app",
  "version": "1.0.0",
  "main": "app.js",
  "scripts": {
    "start": "node app.js"
  },
  "dependencies": {
    "express": "^5.1.0"
  }
}
```

---

## Dockerfile

```dockerfile
FROM node:20-slim

WORKDIR /app

COPY package*.json .

RUN npm install

COPY . .

EXPOSE 3000

CMD ["node", "app.js"]
```

---

## Why `npm install` Before `COPY . .`?

Better build caching.

```text
package.json
     ↓
npm install
     ↓
dependency layer
     ↓
application code
```

If only `app.js` changes:

```text
npm install → cache ✅
COPY app    → rebuild
```

---

## Build Image

```bash
docker build -t my-node .
```

---

## Run Container

```bash
docker run -d \
  --name node-app \
  -p 3000:3000 \
  my-node
```

---

## Browser

```text
http://<EC2-PUBLIC-IP>:3000
```

Output:

```text
Hello from Node.js Docker App!
```

---

# ☕ Java Dockerfile Practical

## Project Structure

```text
java-docker-app/
├── pom.xml
├── src/
│   └── main/
│       └── java/
│           └── App.java
└── Dockerfile
```

---

## App.java

```java
public class App {
    public static void main(String[] args) {
        System.out.println("Hello from Java Docker App!");
    }
}
```

---

## Maven Build Concept

Java source code normally goes through a build step:

```text
App.java
   ↓
mvn package
   ↓
Compile
   ↓
Package
   ↓
JAR
```

`mvn package` includes compilation.

---

## Maven Output

Maven normally creates output under:

```text
target/
```

To verify:

```bash
ls target
```

or:

```bash
find . -name "*.jar"
```

---

## Java Dockerfile

```dockerfile
FROM maven:3.9-eclipse-temurin-17

WORKDIR /app

COPY pom.xml .

COPY src ./src

RUN mvn package

CMD ["java", "-cp", "target/docker-demo-1.0.jar", "App"]
```

---

## Build Image

```bash
docker build -t java .
```

---

## Run Container

```bash
docker run java
```

Output:

```text
Hello from Java Docker App!
```

The container exits after printing the message because the Java program finishes.

This is expected.

---

# 20. Why Java App Does Not Open in Browser?

The current Java program only prints:

```text
Hello from Java Docker App!
```

It does not run a web server.

Therefore:

```text
Python Flask → Web Server → Browser ✅

Node Express → Web Server → Browser ✅

Current Java App → Terminal Output → Browser ❌
```

A Java web application such as Spring Boot would normally listen on a port such as `8080`.

---

# 21. Image vs Container

Very important:

```bash
docker build -t my-python .
```

creates an:

```text
IMAGE
```

It does NOT automatically create a running container.

To create and start a container:

```bash
docker run my-python
```

Flow:

```text
Dockerfile
    ↓
docker build
    ↓
Image
    ↓
docker run
    ↓
Container
```

---

# ⭐ Common Commands Used

```bash
docker build -t <image-name> .
```

```bash
docker images
```

```bash
docker history <image-name>
```

```bash
docker run <image-name>
```

```bash
docker run -d \
  --name <container-name> \
  -p <host-port>:<container-port> \
  <image-name>
```

```bash
docker ps
```

```bash
docker ps -a
```

```bash
docker logs <container-name>
```

```bash
docker inspect <container-name>
```

---

# 🎯 Interview Questions

## Q1. What is a Dockerfile?

A Dockerfile is a text file containing instructions used by Docker to build a custom image.

---

## Q2. What is the difference between RUN and CMD?

`RUN` executes during image build.

`CMD` executes by default when the container starts.

---

## Q3. What does FROM do?

It defines the base image.

Example:

```dockerfile
FROM python:3.12-slim
```

---

## Q4. What does WORKDIR do?

It sets the working directory inside the image/container.

Example:

```dockerfile
WORKDIR /app
```

---

## Q5. What does COPY do?

It copies files from the Docker build context into the image.

---

## Q6. What does EXPOSE do?

It documents the port used by the application.

It does not publish the port to the host.

---

## Q7. Difference between EXPOSE and `-p`?

```text
EXPOSE → Image metadata/documentation

-p → Publishes container port on host
```

---

## Q8. What is Docker build cache?

Docker can reuse unchanged image layers from previous builds to speed up future builds.

---

## Q9. Why copy dependency files before application source code?

To improve build caching.

Example:

```dockerfile
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
```

Application source changes do not force dependency installation again.

---

## Q10. How do you decide what to put in CMD?

Use the application's actual startup command.

Example:

```bash
python app.py
```

becomes:

```dockerfile
CMD ["python", "app.py"]
```

---

## Q11. Difference between CMD and ENTRYPOINT?

Basic answer:

```text
ENTRYPOINT → Defines the primary executable

CMD → Defines default command or arguments
```

---

## Q12. COPY vs ADD?

Use `COPY` for normal file copying.

Use `ADD` only when its additional features are required.

---

# ⭐ Dockerfile Pattern to Remember

For most applications:

```dockerfile
FROM <base-image>

WORKDIR /app

COPY <dependency-file> .

RUN <install-dependencies>

COPY . .

EXPOSE <application-port>

CMD ["<program>", "<startup-file>"]
```

Examples:

### Python

```text
python → pip → 5000 → python app.py
```

### Node.js

```text
node → npm → 3000 → node app.js
```

### Java

```text
maven → mvn package → JAR → java command
```

---
