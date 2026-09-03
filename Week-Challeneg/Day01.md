# 🔥 1 Week Challenge:-


# 🔥 Day 1 — Questions to Prepare

## Git — 3

### What is Git, and why is it used in DevOps?

Git is a version control system where multiple developers can work on the same project and track changes.

### What is the difference between git pull and git fetch?

Git pull downloads changes from the remote repository to the local repository and merges them. Git fetch only downloads the changes; it does not merge them into the local branch.

### What is a Git branch, and why do we use branches?

A branch is a separate copy of the code where we can develop and test new changes without affecting the main branch.

## AWS + Linux — 5

### An EC2 server is running, but you cannot SSH into it. How will you troubleshoot?

I know the answer perfect

### CPU utilization is continuously 90–100%. How will you troubleshoot it?

I know the perfect answer

### An EC2 server has 90% disk utilization. What steps will you take?

I kn ow the perfect answer

### An application is running on an EC2 instance, but users cannot access it. How will you troubleshoot?

I know the perfect answer

### How do you troubleshoot high memory utilization on a Linux server?

I know the perfect answer

### Docker — 5

### What happens when you run docker run?
When we run docker run, the Docker CLI sends a request to the Docker daemon. The Docker daemon manages Docker components like containers, images, networks and volumes. It first checks for the image locally. If the image is not available, it pulls the image from Docker Hub and then creates and starts the container.

### A Docker container starts and immediately exits. How will you troubleshoot it?

First, I will check the container status using docker ps -a. Then I will check the container logs and inspect the container to identify the exact error. Based on the error, I will troubleshoot the issue. It could be related to the application, configuration, or resources. If it is an application issue, I will coordinate with the application team. If it is a configuration issue, I will check the Dockerfile, environment variables, CMD, and ENTRYPOINT. If it is a resource issue, I will increase the resources after approval.

### What is the difference between a Docker image and a container?

I know the perfect answer

### How do you reduce the size of a Docker image?

There are multiple ways to reduce Docker image size. I can use a smaller base image like Alpine. I can use a multi-stage build, where I build the application in the first stage and copy only the required artifact, like a JAR file, to the second stage. I can also combine multiple RUN commands to reduce the number of layers.

### How does Docker networking work, and how can containers communicate with each other?

For container-to-container communication, I can create a bridge network and attach both containers to the same network. Containers can communicate using the container name instead of IP address. We use the network because the container IP can change when the container is recreated, but the container name remains stable.

### Terraform — 5

### What is Terraform state, and why is it important?

Terraform state is the information about the resources created or managed by Terraform. It is stored in the terraform.tfstate file and helps Terraform track those resources and identify what changes are required.

### What will you do if Terraform state is locked?

First, I will check whether another Terraform process is running using ps -ef | grep terraform. I will also check if any Terraform pipeline is currently running.
If it is running, I will wait for it to complete. If no operation is running and the lock is stale, I will safely remove the lock according to the backend and SOP.

### What is the difference between terraform plan and terraform apply?

I know perfect

### What is the difference between a Terraform variable and a local value

Both variables and local values are reusable values. A variable gets its value from outside the Terraform configuration and can be overridden, while a local value is defined inside the configuration and cannot be overridden directly.

### You run terraform plan and see unexpected changes. How will you investigate?

First, I will check which resource has unexpected changes. Then I will check what exactly has changed and compare it with my Terraform configuration. I will also check whether the change was planned or caused by any manual change. After verifying the reason, I will take the appropriate action after approval.

## Jenkins — 3

### What is Jenkins, and how is it used in CI/CD?

Jenkins is an open-source automation tool used to automate tasks in CI/CD, such as building, testing, and deploying applications.

### How will you troubleshoot a Jenkins pipeline that suddenly starts failing?

First, I will check the console output and identify which stage has failed. Then I will check the exact error and troubleshoot based on the error. It may be related to the Git URL, credentials, code quality, filesystem, image vulnerability, Jenkins agent being offline, or resource issues. Once I find the root cause, I will resolve the issue.

### The Jenkins build is successful, but deployment fails. How will you troubleshoot it?

First, I will check the console output and identify the exact reason why the deployment failed. It may be related to credentials, permissions, environment configuration, Docker image, target server or container, network connectivity, or resource issues. Once I identify the root cause, I will resolve it and redeploy.

## Kubernetes — 5

### A Pod is in CrashLoopBackOff. How will you troubleshoot it?

First, I will check which Pod is in CrashLoopBackOff using kubectl get pods. Then I will check the current and previous logs. After that, I will run kubectl describe pod and check the Events section to identify the exact reason. It may be related to resource issues, configuration, probes, or storage like PV and PVC. Based on the error, I will resolve the issue.

### A Pod is Running but NotReady. What will you check?

First, I will check which Pod is NotReady using kubectl get pods. Then I will check the logs and run kubectl describe pod to identify the exact reason. I will mainly check the readiness probe, application health, configuration, and Events section. Based on the error, I will resolve the issue.

### A Kubernetes Service is not accessible. How will you troubleshoot it?

“First, I will check the Service using kubectl get svc. Then I will check the Service selector and verify whether the backend Pods are running or not. After that, I will check the endpoints to make sure the Service is correctly connected to the Pods.”

### If we already have a LoadBalancer Service, why do we need Ingress and an Ingress Controller?

“LoadBalancer Service gives an external endpoint to access the application. But if we have multiple applications, we may need multiple LoadBalancers. Ingress provides a single entry point and can route traffic based on host or path. The Ingress Controller handles this routing and forwards traffic to the correct Service.”

### What is self-healing in Kubernetes? Give a practical example.

“Kubernetes provides self-healing. If a Pod crashes or stops, Kubernetes automatically restarts it or creates a new Pod to maintain the desired number of replicas.”
