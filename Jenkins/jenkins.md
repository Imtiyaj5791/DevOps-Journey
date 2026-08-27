## Jenkins

Jenkins is an open-source automation server used to automate Continuous Integration (CI) and Continuous Delivery/Deployment (CD) processes.

## What is CI/CD?

### Continuous Integration (CI)

Continuous Integration is a practice where developers frequently merge their code changes into a shared repository, and automated build, testing, and validation are performed.

A typical CI pipeline includes:

- Code checkout from Git repository
- Build application
- Run automated tests
- Code quality checks (SonarQube)
- Security scanning (Trivy)
- Build Docker image
- Push Docker image to registry (ECR)

### Continuous Delivery/Deployment (CD)

CD focuses on delivering or deploying the tested application to different environments automatically.

A typical CD pipeline includes:

- Pull Docker image from registry (ECR)
- Deploy application to target environment
  - ECS
  - Kubernetes
- Perform health checks
- Release application to users

Difference:

- Continuous Delivery → Deployment may require manual approval.
- Continuous Deployment → Deployment happens automatically after successful pipeline execution.

### Jenkins Architectur:

Jenkins Architecture consists of a Controller and Agents. The Jenkins Controller manages jobs, pipelines, and scheduling, while Jenkins Agents execute build, test, and deployment tasks.


### Jenkins Pipeline:

A Jenkins Pipeline is a series of automated stages and steps that define the complete CI/CD workflow as code, usually in a Jenkinsfile

### Jenkins WorkSpace: 

Jenkins workspace is a working directory on the agent where Jenkins downloads source code and executes build, test, and other pipeline steps.

### Jenkins Job

A Jenkins Job is a task configured in Jenkins to perform a specific action, such as building, testing, or deploying an application.


Jenkins Lab:-

install java

Install Jenkins Library from jenkis website

sudo apt update 

Install Jenkins :- sudo apt install jenkins -y

Configure the Jenkis through GUI

### Create First Freestyle Job:

Freestyle Project is a basic Jenkins job where you configure the build steps through the Jenkins UI instead of writing a Jenkinsfile.

Create a first freestyle job--- select free style--- build step--- execue shell

## Triggers Type:

Trigger builds remotely (e.g., from scripts)
Build after other projects are built
Build periodically
GitHub hook trigger for GITScm polling
Poll SCM

### Jenkins Plugins

Plugin is an extension that adds additional functionality to Jenkins.

### Credentials Management

Jenkins Credentials provide a secure way to store and access sensitive information without hardcoding secrets in jobs or Jenkinsfiles.

Username/password
SSH keys
API tokens
AWS credentials
GitHub tokens

Dashboard--- security--- Credential--- usename with pass--- ad your git details.

### Jenkins Executors

Executor is a slot on a Jenkins node that allows Jenkins to run one build at a time.
If you have 2 executor then

Executor 1 → Job A
Executor 2 → Job B
Job C       → Queue

### Jenkins Labels

Jenkins labels are used to identify and select specific nodes or agents for running jobs based on their capabilities or requirements.

### Jenkins Build History & Console Output:

Build History maintains records of previous builds, while Console Output provides detailed logs of the commands and steps executed during a specific build.

### Jenkins Pipeline

Jenkins Pipeline is a set of automated steps written as code that defines how an application moves from source code to deployment.

```
Developer Push Code
        |
        ↓
Git Checkout
        |
        ↓
Build
        |
        ↓
Test
        |
        ↓
Docker Image Build
        |
        ↓
Push Image
        |
        ↓
Deploy Application
```

### Declarative Pipeline provides a structured and easier way to define CI/CD workflows and is commonly used in production. Scripted Pipeline provides more flexibility because it is based on Groovy programming and is used for complex workflows

### Jenkins Controller manages scheduling and pipeline orchestration, while Jenkins Agents execute the actual build, test, and deployment tasks. This helps distribute workload and improves scalability.

## Jenkins Production Pipeline — 2.1 to 2.8 One-Line Revision

### 2.1 Checkout Stage

➡️ Jenkins pulls the source code from the Git repository into the Jenkins workspace.

```
git branch: 'main', url: 'https://github.com/company/app.git'
```

### 2.2 Build Stage

➡️ Jenkins uses build tools like Maven/Gradle to compile the code and create a deployable artifact.
```
mvn clean package
```

### 2.3 Test Stage

➡️ Jenkins runs automated tests to validate application functionality before deployment.
```
mvn test
```

### 2.4 SonarQube Code Quality Scan

➡️ SonarQube analyzes the code to identify bugs, code smells, and security issues.
```
mvn sonar:sonar
```

### 2.5 Security Scan (Trivy)

➡️ Trivy scans Docker images and dependencies for security vulnerabilities.
```
sudo apt install trivy
trivy image ecommerce:v1
trivy image --severity HIGH,CRITICAL ecommerce:v1
```

#### 2.6 Docker Build Stage

➡️ Jenkins creates a Docker image using the Dockerfile.

```
docker build -t ecommerce:v1 .
```

### 2.7 Push Image to ECR

➡️ Jenkins authenticates with AWS and pushes the Docker image to Amazon ECR.

```
aws ecr get-login-password --region ap-south-1 | \
docker login --username AWS \
--password-stdin <account-id>.dkr.ecr.ap-south-1.amazonaws.com

docker tag ecommerce:v1 \
<account-id>.dkr.ecr.ap-south-1.amazonaws.com/ecommerce:v1

docker push \
<account-id>.dkr.ecr.ap-south-1.amazonaws.com/ecommerce:v1
```

### 2.8 Deployment Stage

➡️ Jenkins deploys the ECR image to ECS or Kubernetes by updating the deployment configuration.

For ECS

```
aws ecs update-service \
--cluster ecommerce-cluster \
--service ecommerce-service \
--force-new-deployment
```

For EKS:-

```
kubectl set image deployment/ecommerce \
ecommerce=<ECR_IMAGE>:v1

kubectl rollout status deployment/ecommerce
```
