# 🔥 Day 5 Question Set


# AWS + Linux — 5

### 1 Production EC2 server suddenly becomes very slow. How will you troubleshoot it step by step?

“First, I will check CloudWatch to check the resource utilization and identify when the slowness started. Then I will log in to the server and check the load average using uptime. After that, I will check CPU, memory, disk and the top resource-consuming processes. I will also check application logs to see if there is an increase in requests or any application-related issue. Based on the findings, I will identify the root cause and resolve the issue.”

### 2 An EC2 instance is running, but the application is not reachable from the internet. What will you check?

“First, I will log into the server and check whether the application is running locally and whether the required port is listening. Then I will check the Security Group and NACL for any blocked traffic. If the application is directly exposed to the internet, I will also check the Route Table and Internet Gateway. If it is behind a Load Balancer, I will check the listener configuration and Target Group health. Finally, I will check the application logs and coordinate with the application team if there is any application-level issue or recent change.”

### 3 CPU utilization is normal, but the application is still very slow. What will you investigate?

“If CPU and memory are normal but the application is slow, I will check disk I/O and I/O wait, network connectivity, application logs, and database performance. I will also check for any stuck or abnormal processes. Based on these metrics and logs, I will identify whether the issue is with the server, network, database, or application.”

### 4 A Linux server's disk usage reaches 100% in production. How will you troubleshoot and resolve it safely?

I know it

### 5 An application is working after deployment but becomes unavailable after a few hours. How will you investigate?

“First, I will check whether the application is running locally and check its service status. Then I will check the application logs and system resources to identify what changed after 2–3 hours. I will also check the listening port, process health, memory usage, connection issues and database connectivity. If this is related to the recent deployment and the business impact is high, I will take approval and roll back to the previous stable version. After recovery, I will verify the application and perform RCA to prevent recurrence.”


# Docker — 3

### 6 A Docker container keeps restarting in production. How will you troubleshoot it?

“First, I will identify which container is restarting and check its status and restart count. Then I will check the container logs and use docker inspect to identify the exact error. I will also check the exit code, resource utilization, configuration, application health and database connectivity. Based on the root cause, I will fix the issue and verify that the container remains stable.”

### 7 The Docker image works in your local environment but the container fails in production. What will you check?

“If the same Docker image works locally but fails in production, first I will check the container logs to identify the exact error. Then I will compare the production environment with my local environment, especially environment variables, configuration, database connectivity and network access. I will also verify that production is using the same image version and check permissions, mounted files and resource limits. Based on the error, I will identify the root cause and fix it.”

### 8 A container is running, but users cannot access the application. How will you troubleshoot the networking/port issue?

“First, I will check the container logs and docker inspect to identify the exact error. Then I will verify that the application is running and listening on the expected container port. I will check the Docker port mapping and test the application locally from the host. I will also verify the Dockerfile, CMD, environment variables and configuration. If the application works locally but is not accessible externally, I will then check the Security Group and NACL for any blocked traffic. Based on the findings, I will identify the root cause and resolve the issue.”

# Terraform — 4

### 9 terraform plan suddenly shows changes to a production resource that you did not expect. What will you do?

“First, I will check which resource is showing the change and what exactly has changed. Then I will investigate whether it is planned or unplanned and check the Terraform code and recent changes. I will not apply immediately; after confirming the change and taking approval, I will take the required action and run terraform plan again.”

### 10 Terraform apply fails halfway through a production deployment. How will you handle it?

If terraform apply fails halfway, first I will check the error and identify which resource failed. Then I will verify which resources were created successfully and check their status in Terraform state and AWS. I will fix the root cause and run terraform plan to confirm the remaining changes. If the plan looks correct, I will run terraform apply again and verify the deployment.

### 11 Two engineers run Terraform at the same time. What can happen and how will you prevent it?

“If two engineers run Terraform apply at the same time, there can be a state conflict. To avoid this, I will use a remote S3 backend with state locking. When one engineer runs apply, the state gets locked, so the second engineer has to wait.”


# Jenkins — 4

### 12 Jenkins pipeline was working yesterday but suddenly starts failing today. How will you troubleshoot it?

First, I will check the Jenkins console output and identify the failed stage and exact error. Then I will check recent changes in the code, Jenkinsfile, credentials, agent status, dependencies or environment. Based on the root cause, I will fix the issue and rerun the pipeline.

### 13 Jenkins build succeeds, but deployment to the production environment fails. What will you check?

First, I will check the Jenkins console output and identify the exact deployment error. Then I will check the deployment target, image and tag, credentials/IAM permissions, configuration, environment and network connectivity. Based on the root cause, I will fix the issue and rerun the deployment.


### 14 You have 50 Jenkins pipelines with almost the same stages and logic. How would you avoid duplicating the code?

If multiple pipelines have the same logic, I will create a Jenkins Shared Library to avoid code duplication. I will keep the common pipeline functions in the vars directory and reuse them from different Jenkinsfiles.

@Library('share') _

### 15 A Jenkins Shared Library was updated and suddenly multiple pipelines started failing. How will you troubleshoot and handle it?

“First, I will check the pipeline logs and identify the error. Then I will check the recent changes in the Shared Library. If the library change is causing the issue, I will fix or roll back the change and rerun the pipelines.”

# Kubernetes / EKS — 5

### 16 Deployment is successful and Pods are Running, but users are getting 503. How will you troubleshoot it end-to-end?

503 error means the service/server is currently not available or not ready to serve the request.

First, I will check the Ingress and Ingress Controller through:

`kubectl get ingress -n <namespace>`
`kubectl get pods -n <ingress-controller-namespace>`

Then I will describe the Ingress to check any error or configuration issue:

`kubectl describe ingress <ingress-name> -n <namespace>`

Then I will check the Service to verify that Ingress is connected to the correct backend Service:

`kubectl get svc -n <namespace>`
`kubectl describe svc <service-name> -n <namespace>`

Then I will check the Endpoints to verify that the Service has backend Pods available:

`kubectl get endpoints <service-name> -n <namespace>`

Then I will check whether the Pod is running and ready:

`kubectl get pods -n <namespace>`

Finally, I will check the Pod logs and describe the Pod to find the actual issue:

`kubectl logs <pod-name> -n <namespace>`
`kubectl describe pod <pod-name> -n <namespace>`

### 17 A Pod is Running but shows 0/1 Ready. What will you check?

“First, I will check which Pod is showing 0/1 Ready. Then I will check the Pod describe and logs to find the exact error. I will especially check the readiness probe, configuration and application. Based on the issue, I will fix it and verify the Pod becomes Ready."

### 18 Pods are getting restarted repeatedly after a new deployment. How will you identify the root cause?

“First, I will check which Pod is getting restarted. Then I will check the current and previous logs and describe the Pod to find the exact error. The issue may be with the application, configuration, probes, resources or health check. Based on the root cause, I will resolve the issue and verify the Pod.”

### 19 Kubernetes application works initially but starts failing after some time. What components will you investigate?

First, I will check which Pod is having the issue and check the current and previous logs and describe the Pod to find the exact error.

Then I will compare the current and previous logs and check resources, storage, probes, application health, database connectivity and network connectivity. The issue may be due to memory/CPU exhaustion, memory leak, storage full, DB connection issue or probe failure.

Based on the root cause, I will resolve the issue and verify the application again.

### 20 Application is running in Kubernetes, but it cannot connect to MySQL. How will you troubleshoot it?

# HTTP / Application Troubleshooting — 2

### 21 Users report that the frontend is working, but API calls are returning 502/503. How will you troubleshoot from frontend to backend?
### 22 Explain how you would differentiate and troubleshoot 400, 401, 403, 404, 429, 500, 502, 503 and 504 errors in a production environment.

# MySQL + ITIL / Production — 2

### 23 MySQL is running, but queries have suddenly become very slow. How will you troubleshoot the database?
### 24 You receive a P1 incident: production application is down and the customer is impacted. What will be your approach from detection to recovery and RCA?

# Monitoring — 1

### 26 What is the difference between Logging, Monitoring, and Alerting? Explain with a production example.

### 27  What is the difference between SLI, SLO, and SLA? Explain with a real production example.
