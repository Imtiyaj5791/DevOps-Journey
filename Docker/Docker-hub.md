# Docker Hub - README

## Objective

Learn how to push a Docker image to Docker Hub so that it can be shared, downloaded, and used on any server.

---

# What is Docker Hub?

Docker Hub is a cloud-based registry used to store and share Docker images.

It works like:

- GitHub → Stores source code
- Docker Hub → Stores Docker images

---

# Prerequisites

- Docker installed
- Docker Hub account
- Docker image available locally

Check local images:

```bash
docker images
```

---

# Step 1: Login to Docker Hub

```bash
docker login
```

Or

```bash
docker login -u <dockerhub-username>
```

Example:

```bash
docker login -u flexis007
```

**Purpose:**
Authenticates your Docker client with Docker Hub.

---

# Step 2: Verify Local Image

```bash
docker images
```

Example:

```text
REPOSITORY         TAG
imtiyaj-flask      latest
```

**Purpose:**
Checks whether the image exists locally before pushing.

---

# Step 3: Tag the Image

Syntax:

```bash
docker tag <local-image>:<tag> <dockerhub-username>/<repository>:<tag>
```

Example:

```bash
docker tag imtiyaj-flask:latest flexis007/two-tier-flask:v1
```

**Purpose:**

Creates a new tag for the existing image in Docker Hub format.

Format:

```
DockerHubUsername/RepositoryName:Tag
```

Example:

```
flexis007/two-tier-flask:v1
```

**Note:**

- No new image is created.
- Only a new reference (tag) is created.
- Both tags point to the same Image ID.

---

# Step 4: Verify the Tag

```bash
docker images
```

Example:

```
REPOSITORY                     TAG      IMAGE ID

imtiyaj-flask                  latest   87134dc9c9bc

flexis007/two-tier-flask       v1       87134dc9c9bc
```

Notice that both repositories have the same Image ID.

---

# Step 5: Push the Image

```bash
docker push flexis007/two-tier-flask:v1
```

**Purpose:**

Uploads the Docker image to Docker Hub.

During the push, Docker uploads only the layers that do not already exist in the registry.

---

# Step 6: Verify on Docker Hub

Open Docker Hub.

Navigate to:

```
Repositories
```

You should see:

```
flexis007/two-tier-flask
```

with

```
Tag: v1
```

---

# How Docker Push Works

```
Local Image
      │
      ▼
docker tag
      │
      ▼
Docker Hub Format
      │
      ▼
docker push
      │
      ▼
Docker Hub Repository
```

---

# Important Commands

Login

```bash
docker login
```

Logout

```bash
docker logout
```

List Images

```bash
docker images
```

Tag Image

```bash
docker tag local-image:latest username/repository:v1
```

Push Image

```bash
docker push username/repository:v1
```

Pull Image

```bash
docker pull username/repository:v1
```

Remove Local Image

```bash
docker rmi username/repository:v1
```

---

# Interview Questions

### 1. What is Docker Hub?

Docker Hub is a cloud-based registry used to store, manage, and share Docker images.

---

### 2. Why do we tag an image before pushing?

Docker Hub accepts images in the format:

```
username/repository:tag
```

Tagging creates a new reference to the existing image in this format.

---

### 3. Does `docker tag` create a new image?

No.

It only creates another tag (reference) pointing to the same Image ID.

---

### 4. Why do both images have the same Image ID?

Because they refer to the same Docker image.

Only the repository name and tag are different.

---

### 5. Why is the second `docker push` faster?

Docker images are layer-based.

Only new or modified layers are uploaded.
Existing layers are skipped.

---

### 6. Difference between Docker Hub Repository and Image?

A Repository stores one or more versions (tags) of an image.

Example:

```
two-tier-flask

├── v1
├── v2
└── latest
```

---

## Practical Completed

- Created Docker Hub account
- Logged in using Docker CLI
- Tagged local image
- Pushed image to Docker Hub
- Verified repository on Docker Hub
- Pulled image using Docker Hub repository

---

## Key Takeaways

- Docker Hub is used to store Docker images.
- Images must be tagged before pushing.
- Tagging does not create a new image.
- Docker uploads only changed layers.
- Images can be pulled from Docker Hub on any server.