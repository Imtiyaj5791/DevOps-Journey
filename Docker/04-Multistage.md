# Docker Multi-Stage Builds

## Overview

A Docker Multi-Stage Build uses multiple `FROM` instructions in the same Dockerfile.

It separates:

- **Build/Preparation Stage** — application ko build/prepare karta hai.
- **Runtime Stage** — sirf application run karne ke liye required files rakhta hai.

Main purpose:

- Reduce final image size
- Remove unnecessary build tools from runtime image
- Keep production image clean
- Reduce attack surface
- Separate build and runtime environments

---

# 1. Multi-Stage Build Architecture

```text
Stage 1 — Builder
-------------------------
Build Image
Source Code
Dependencies
Build Tools
        |
        | Build / Prepare
        v
Required Output / Artifact
        |
        | COPY --from=builder
        v
Stage 2 — Runtime
-------------------------
Runtime Image
Required Artifact
Application Files
        |
        v
Final Docker Image
```

Simple rule:

> Stage 1 prepares/builds the application.  
> Stage 2 contains only what is required to run the application.

---

# 2. Basic Syntax

```dockerfile
FROM <builder-image> AS builder

WORKDIR /app

COPY <required-files> .

RUN <build-command>


FROM <runtime-image>

WORKDIR /app

COPY --from=builder <source> <destination>

CMD ["<run-command>"]
```

---

# 3. Understanding `AS builder`

Example:

```dockerfile
FROM node:20-slim AS builder
```

`AS` is Dockerfile syntax.

`builder` is the name given to Stage 1.

The name can technically be anything:

```dockerfile
FROM node:20-slim AS build
```

or:

```dockerfile
FROM node:20-slim AS production-builder
```

Industry commonly uses:

```text
builder
build
runtime
production
```

---

# 4. Understanding `COPY --from=builder`

Syntax:

```dockerfile
COPY --from=builder <source> <destination>
```

Meaning:

```text
COPY
FROM builder stage
SOURCE
TO DESTINATION
```

Example:

```dockerfile
COPY --from=builder /app/output /app/output
```

Read it as:

```text
Builder stage ke /app/output se
              ↓
Current stage ke /app/output me copy karo
```

Important:

```text
COPY --from=builder
```

is predefined Docker syntax.

---

# 5. How Do We Know What to Copy?

This is one of the most important points in multi-stage builds.

Docker does **not** decide what application artifact should be copied.

It depends on the application's build process.

General rule:

> Copy the output/files from Stage 1 that are required to run the application in Stage 2.

Examples:

| Application | Build/Install Command | Typical Output |
|---|---|---|
| Node.js | `npm install` | `node_modules/` |
| Java Maven | `mvn package` | JAR under `target/` |
| Python | `pip install` | Python dependencies |
| Frontend | `npm run build` | Often `dist/` or `build/` |

These paths are **application/build-tool specific**, not Docker rules.

---

# 6. How to Identify the Artifact in Production

Never guess.

Check:

1. Project `README`
2. Application documentation
3. `package.json`
4. `pom.xml`
5. Existing CI/CD pipeline
6. Existing Dockerfile/deployment configuration
7. Build command output
8. Developer/application team

Example documentation:

```text
Build:
mvn clean package

Output:
target/payment-service.jar

Run:
java -jar target/payment-service.jar
```

Now we know Stage 2 needs:

```text
payment-service.jar
```

Therefore:

```dockerfile
COPY --from=builder /app/target/payment-service.jar app.jar
```

Production approach:

```text
Understand application
        ↓
Identify build command
        ↓
Identify build output
        ↓
Identify runtime requirements
        ↓
COPY required artifact
        ↓
Create final runtime image
```

---

# 7. Python Multi-Stage Build

## Application Files

Example:

```text
python-docker-app/
├── app.py
├── requirements.txt
├── Dockerfile
└── Dockerfile.multi
```

Example `requirements.txt`:

```text
flask
```

---

## Dockerfile

```dockerfile
# Stage 1 — Builder

FROM python:3.12-slim AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install --target=/install -r requirements.txt


# Stage 2 — Runtime

FROM python:3.12-slim

WORKDIR /app

COPY --from=builder /install /install

ENV PYTHONPATH=/install

COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]
```

---

## Understanding Python Stage 1

```dockerfile
RUN pip install --target=/install -r requirements.txt
```

Normally:

```dockerfile
RUN pip install -r requirements.txt
```

installs Python dependencies in Python's normal location.

For this multi-stage example:

```text
--target=/install
```

places dependencies in a known directory:

```text
/install
```

This makes them easy to copy into Stage 2.

---

## Why `ENV PYTHONPATH=/install`?

We placed Python packages in a custom directory:

```text
/install
```

Therefore:

```dockerfile
ENV PYTHONPATH=/install
```

tells Python to also look in `/install` when searching for modules.

General Docker `ENV` syntax:

```dockerfile
ENV KEY=value
```

Example:

```dockerfile
ENV APP_ENV=production
```

`PYTHONPATH` is a Python-recognized environment variable.

---

## Build Python Multi-Stage Image

Because the file is named:

```text
Dockerfile.multi
```

use:

```bash
docker build -f Dockerfile.multi -t multi-python .
```

If we simply run:

```bash
docker build -t multi-python .
```

Docker looks for the default:

```text
Dockerfile
```

---

## Lab Result

Single-stage:

```text
my-python:latest
Content Size ≈ 49 MB
```

Multi-stage:

```text
multi-python:latest
Content Size ≈ 44.8 MB
```

For this small Python application, the reduction was small.

Multi-stage does not always create a huge size difference.

---

# 8. Node.js Multi-Stage Build

Example project:

```text
node-docker-app/
├── app.js
├── package.json
├── Dockerfile
└── Dockerfile.multi
```

---

## Dockerfile

```dockerfile
# Stage 1 — Builder

FROM node:20-slim AS builder

WORKDIR /app

COPY package*.json .

RUN npm install


# Stage 2 — Runtime

FROM node:20-slim

WORKDIR /app

COPY --from=builder /app/node_modules /app/node_modules

COPY app.js .

EXPOSE 3000

CMD ["node", "app.js"]
```

---

## Why `node_modules`?

This is not a Docker rule.

When:

```bash
npm install
```

runs inside:

```text
/app
```

Node/npm normally creates:

```text
/app/node_modules
```

Therefore Stage 2 copies:

```dockerfile
COPY --from=builder /app/node_modules /app/node_modules
```

Meaning:

```text
Stage 1
/app/node_modules
       |
       | COPY --from=builder
       v
Stage 2
/app/node_modules
```

---

## Build

```bash
docker build -f Dockerfile.multi -t multi-node .
```

---

## Lab Result

Single-stage:

```text
node-app:latest
Content Size ≈ 73.7 MB
```

Multi-stage:

```text
multi-node:latest
Content Size ≈ 72 MB
```

Again, this was a very small application, so the reduction was small.

---

# 9. Java Multi-Stage Build

Java demonstrates multi-stage builds much more clearly.

Java application needs Maven/JDK during build.

But after the JAR is generated, the runtime image does not need Maven.

Flow:

```text
Maven + JDK + Source
        |
        | mvn package
        v
       JAR
        |
        | COPY
        v
JRE + JAR
        |
        v
Application
```

---

## Dockerfile

```dockerfile
# Stage 1 — Builder

FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app

COPY pom.xml .

COPY src ./src

RUN mvn package


# Stage 2 — Runtime

FROM eclipse-temurin:17-jre

WORKDIR /app

COPY --from=builder /app/target/docker-demo-1.0.jar app.jar

CMD ["java", "-jar", "app.jar"]
```

---

## Understanding Stage 1

```dockerfile
FROM maven:3.9-eclipse-temurin-17 AS builder
```

Provides:

```text
Maven
+
Java build environment
```

Then:

```dockerfile
RUN mvn package
```

builds the application.

Typical Maven output:

```text
target/
```

Example artifact:

```text
target/docker-demo-1.0.jar
```

The exact artifact name must be verified from the project/build configuration or build output.

---

## Understanding Stage 2

```dockerfile
FROM eclipse-temurin:17-jre
```

Stage 2 does not need Maven.

It needs:

```text
Java Runtime
+
Application JAR
```

Therefore:

```dockerfile
COPY --from=builder /app/target/docker-demo-1.0.jar app.jar
```

copies the generated JAR from Stage 1.

Then:

```dockerfile
CMD ["java", "-jar", "app.jar"]
```

starts the application.

---

# 10. Java Image Size — Actual Lab Result

Before multi-stage:

```text
java:latest
Content Size ≈ 250 MB
```

After multi-stage:

```text
multi-java:latest
Content Size ≈ 109 MB
```

Approximate reduction:

```text
250 MB
  ↓
109 MB
```

Approximately:

```text
141 MB smaller
```

This demonstrates the real benefit of separating the heavy build environment from the runtime environment.

---

# 11. Why Java Showed a Bigger Benefit

Builder:

```text
Maven
JDK
Source Code
Build Files
```

Final runtime:

```text
JRE
JAR
```

Maven is required to **build** the application.

Maven is not required to **run** the final JAR.

Therefore it does not need to be present in the final image.

---

# 12. Single-Stage vs Multi-Stage

## Single-Stage

```text
FROM build/runtime image
        ↓
Install dependencies
        ↓
Build application
        ↓
Run application
        ↓
Everything stays in one image
```

Example concept:

```text
Build Tools
Source Code
Dependencies
Runtime
Application
      ↓
Final Image
```

---

## Multi-Stage

```text
Stage 1
Build Tools
Source Code
Dependencies
      ↓
Build Artifact
      ↓
COPY --from
      ↓
Stage 2
Runtime
Required Artifact
      ↓
Final Image
```

---

# 13. Benefits of Multi-Stage Builds

### Smaller Images

Build tools do not have to remain in the final runtime image.

### Cleaner Runtime

Only required runtime files are included.

### Reduced Attack Surface

Unnecessary compilers, package managers and build tools can be excluded.

### Better Separation

Build environment and runtime environment are separated.

### Production Friendly

Final image can contain only the application and required runtime components.

---

# 14. Important Point — Multi-Stage Does Not Always Mean Huge Size Reduction

Our lab demonstrated this clearly.

Python:

```text
Single-stage ≈ 49 MB
Multi-stage  ≈ 44.8 MB
```

Node:

```text
Single-stage ≈ 73.7 MB
Multi-stage  ≈ 72 MB
```

Java:

```text
Single-stage ≈ 250 MB
Multi-stage  ≈ 109 MB
```

Therefore:

> The benefit depends on how much build-only content can be removed from the final image.

Java had heavy build requirements, so the difference was much larger.

---

# 15. Common Multi-Stage Pattern

This is the main pattern to remember:

```dockerfile
# Stage 1

FROM <builder-image> AS builder

WORKDIR /app

COPY <dependency-files> .

RUN <install/build-command>

COPY <source-code> .

RUN <build-command-if-required>


# Stage 2

FROM <runtime-image>

WORKDIR /app

COPY --from=builder <required-output> <destination>

COPY <other-runtime-files> .

EXPOSE <port>

CMD ["<start-command>"]
```

Do not memorize application-specific paths.

Understand the structure.

---

# 16. Production Checklist

Before writing a production multi-stage Dockerfile, identify:

```text
What technology is this application?
        ↓
How is it built?
        ↓
What dependencies are required?
        ↓
What artifact/output does the build generate?
        ↓
How is the application started?
        ↓
Which files are actually required at runtime?
```

Then create the Dockerfile.

---

# 17. Interview Questions & Answers

## Q1. What is a Docker multi-stage build?

A multi-stage build uses multiple `FROM` instructions in a Dockerfile to separate the build environment from the runtime environment.

---

## Q2. Why do you use multi-stage builds?

Multi-stage builds help create smaller and cleaner runtime images by excluding unnecessary build tools and copying only required runtime artifacts into the final stage.

---

## Q3. What is `AS builder`?

It gives a name to a Docker build stage.

Example:

```dockerfile
FROM maven:3.9-eclipse-temurin-17 AS builder
```

The stage can then be referenced using:

```dockerfile
COPY --from=builder ...
```

---

## Q4. What does `COPY --from=builder` mean?

It copies files from the named builder stage into the current stage.

Example:

```dockerfile
COPY --from=builder /app/target/app.jar /app/app.jar
```

---

## Q5. How do you decide what to copy from the builder stage?

I identify the files or artifacts required at runtime by checking the project documentation, build configuration, CI/CD pipeline, build output, or application team instructions.

I then copy only the required runtime artifacts into the final stage.

---

## Q6. Do you need to remember artifact paths for every programming language?

No.

Artifact locations are application and build-tool specific.

For production applications, they should be verified from project documentation, build configuration, CI/CD pipelines, build output, or developer instructions instead of guessing.

---

## Q7. Why is Java a good use case for multi-stage builds?

A Java application may require Maven and a JDK during the build process, but the generated JAR may only require a JRE at runtime.

Therefore Maven and other build tools can be excluded from the final image.

---

## Q8. What happens to Stage 1 after the build?

Stage 1 is used to create the required artifacts.

Its entire filesystem is not automatically included in the final stage.

Only files explicitly copied from it are included.

---

## Q9. Can a Dockerfile have more than two stages?

Yes.

A Dockerfile can contain multiple stages for tasks such as building, testing, packaging and creating the final runtime image.

---

## Q10. What is the biggest advantage of multi-stage builds?

The main advantage is separating build-time dependencies from runtime requirements, resulting in cleaner and often smaller production images.

---

# 18. Troubleshooting Multi-Stage Builds

### Application artifact not found

Check the builder stage output.

Example:

```bash
mvn package
ls target/
```

Verify the actual JAR name.

---

### Node dependencies missing

Verify:

```bash
npm install
```

and check:

```bash
ls node_modules/
```

---

### Python module not found

Verify where dependencies were installed.

If using:

```dockerfile
RUN pip install --target=/install -r requirements.txt
```

and copying `/install`, Python must also be configured to search that location, for example:

```dockerfile
ENV PYTHONPATH=/install
```

---

### Final image unexpectedly large

Check whether unnecessary build tools or files are being copied into the runtime stage.

---

# 19. Quick Revision

```text
MULTI-STAGE BUILD

Stage 1
BUILD / PREPARE
      ↓
Required Artifact
      ↓
COPY --from=builder
      ↓
Stage 2
RUNTIME
      ↓
Final Image
```

Remember:

```text
AS builder
      ↓
Name Stage 1

COPY --from=builder
      ↓
Copy required output from Stage 1
```

And the most important production rule:

> **Never guess what to copy. Identify the application's required runtime artifact from its build process and documentation.**

---

# 20. Final Interview Answer

**What is Docker Multi-Stage Build?**

> A Docker multi-stage build separates the application build environment from the runtime environment by using multiple `FROM` instructions. The application is built in the builder stage, and only the required runtime artifacts are copied into the final stage using `COPY --from`. This helps create cleaner, smaller and more secure production images.
