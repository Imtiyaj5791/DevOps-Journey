<h1 align="center"><span style="color:red">🚀 Unknown Interview Questions</span></h1>

> **Status:** ✅ Completed  
> **Role:** AWS Linux Support Engineer

---

# ⚖️ ALB Host-Based Routing

## ❓ We have 2 domains. How will you run both on a single Load Balancer?

If we have two domains behind the same ALB, we can use **host-based routing**.

For example, if the request comes for `www.devops.com`, the ALB Listener Rule will forward the traffic to the **DevOps Target Group**.

If the request comes for `www.aws.com`, the ALB Listener Rule will forward the traffic to the **AWS Target Group**.

```text
www.devops.com → ALB → DevOps Target Group
www.aws.com    → ALB → AWS Target Group
```

---

# 🐳 Docker Image Storage

## ❓ Where do you store/save Docker images?

We mainly store Docker images in **Amazon ECR** for private repositories.

We can also use **Docker Hub** for public or private repositories.

In our AWS environment, we prefer ECR because it integrates easily with AWS services.

---

# 🪣 S3 Single Object Public Access

## ❓ How do you give public permission to only a single object in S3?

Previously, we could make a single S3 object public using **Object ACL**.

Currently, ACLs are generally disabled. If there is a requirement to make only one object public, we can use a **Bucket Policy** and specify the exact object ARN in the `Resource`.

We also need to make sure **Block Public Access** settings allow that policy.

Example:

```text
arn:aws:s3:::my-bucket/image.jpg
```

---
