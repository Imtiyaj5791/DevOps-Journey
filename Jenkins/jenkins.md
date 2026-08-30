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


# Install Jenkins
```
install java

Install Jenkins Library from jenkis website

sudo apt update 

Install Jenkins :- sudo apt install jenkins -y

Configure the Jenkis through GUI
```

# Create First Freestyle Job:

Freestyle Project is a basic Jenkins job where you configure the build steps through the Jenkins UI instead of writing a Jenkinsfile.

Create a first freestyle job--- select free style--- build step--- execue shell

# Triggers

****Build after other projects are built****: Triggers a build after another specified Jenkins project completes successfully.
****Build periodically****: Automatically runs a build at a scheduled time or regular interval using a cron expression.
****GitHub hook trigger for GITScm polling****: Automatically triggers a build when GitHub sends a webhook after a repository change.
****Poll SCM****: Periodically checks the SCM repository for changes and triggers a build when changes are detected.
****Trigger builds remotely****: Allows an external script or tool to trigger a Jenkins build using a URL and authentication.

# Demo Pipeline

****Jenkins Pipeline****: A Jenkins Pipeline is a set of automated steps defined as code to build, test, and deploy an application
****Jenkinsfile****: A Jenkinsfile is a text file that contains the definition of a Jenkins Pipeline.
****Declarative Pipeline****: Declarative Pipeline is a structured and easier-to-read way of defining Jenkins pipelines using predefined syntax.
****Scripted Pipeline****: Scripted Pipeline Groovy-based flexible pipeline approach hai jisme zyada programming flexibility milti hai.

```
pipeline {

    agent any

    stages {

        stage('Build') {
            steps {
                echo 'Building application'
            }
        }

        stage('Test') {
            steps {
                echo 'Testing application'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application'
            }
        }
    }
}
```

### Credentials Management

Jenkins Credentials provide a secure way to store and access sensitive information without hardcoding secrets in jobs or Jenkinsfiles.

Username/password
SSH keys
API tokens
AWS credentials
GitHub tokens

Dashboard--- security--- Credential--- usename with pass--- ad your git details.

# Flask + Docker Compose — Simple Lab Note

Project Directory:- 
```
jenkins-flask-demo/
├── app.py
├── requirements.txt
├── Dockerfile
├── docker-compose.yml
└── Jenkinsfile
```

Then push it to GitHub and create a pipeline with Pipeline script from DCM and Branch is */main

```
pipeline {

    agent any

    stages {

        stage('Git Checkout') {
            steps {
                git branch: 'main',
                url: 'https://github.com/Imtiyaj5791/jenkins-flask-demo.git'
            }
        }

        stage('Build') {
            steps {
                
		sh 'docker compose build'
            }
        }

        stage('Test') {
            steps {
                sh 'docker compose up -d'
                sh 'curl -f http://localhost:5000'
            }
        }

        stage('Deploy') {
            steps {
                sh 'docker compose up -d'
            }
        }
    }
}
```
# Jenkins Architecture

Jenkins architecture consists of a Controller and Agents. The Jenkins Controller manages jobs, pipelines, and scheduling, while Jenkins Agents execute build, test, and deployment tasks.

```
Controller
    |
    | Assigns work
    ↓
Agent
    |
    ├── Build
    ├── Test
    └── Deploy
```
Jenkins Controller communicates with Agents using methods such as SSH, inbound agents, or WebSocket, depending on the agent configuration.

```
Jenkins Controller
       |
       | SSH
       ↓
Linux Agent
       |
       ↓
Build / Test / Deploy
```

## Lab MAster to Slave:

-- Create a slave machine
-- Generate a ssh-keygen on master and copy public key to slave in authorized file
-- Install java on slave
-- Jenkins---nodes--add nodes--permanent---create--- remote root dir (/home/ubuntu/jenkins-agent) --- Labels (linux-agent)---login agent via ssh 
    host---slave ip, Credential( Add credential user name ubuntu and Private key)

```
pipeline {
    agent {
        label 'linux-agent'
    }

    stages {
        ...
    }
}
```

# Roll-Based
RBAC in Jenkins is used to control user access based on roles. Instead of giving all users administrative privileges, we assign specific permissions according to their responsibilities. This follows the principle of least privilege and improves Jenkins security.

Lab:

Insatll Plugin--  Role-based Authorization Strategy
Enable Role-Based Authorization from Console-- Security---Authorization---Role-Based Strategy
Create a user 
Role Management---Manage Role---Add role (Dev and give required permission)
Assign this role to created user

# Multibranch Pipeline

A Jenkins job that automatically discovers branches from a Git repository and creates a separate pipeline for each branch.

Create a pipeline with multibranch then scan multibranch and it will show all your branch in pipeline.

# Jenkins backup and Restore:

Jenkins backup means taking a backup of the Jenkins Home directory, which contains Jenkins jobs, configurations, credentials and other Jenkins data required for recovery.

I would back up the Jenkins Home directory, usually /var/lib/jenkins, because it contains Jenkins jobs, configurations, credentials-related data, plugins and other important Jenkins data.

I would not rely on a single manual backup. I would schedule automated backups of Jenkins Home to remote storage with a defined RPO and retain multiple backup versions.

# Jenkins Troubleshhot:

Build Failure
     ↓
Console Output
     ↓
Find Exact Error
     ↓
Identify the Problem Area
     ↓
Check Logs / Status / Configuration
     ↓
Fix the Issue
     ↓
Run the Build Again


# Scenario 1

A Jenkins pipeline is stuck at “Waiting for next available executor.” What will you check?

First, I will check the Jenkins queue and see if any executor is available. Then I will check the node status and how many executors are configured. If all executors are busy, I will check the running jobs. If required, I will increase the executor or use another available agent.

# Scenario 2

A Jenkins pipeline starts, but the Git checkout stage fails with “Authentication failed.” What will you check?

First, I will check the console output for the exact error. Then I will verify the Credential ID, username and password/token. I will also check whether the correct credential is configured in the Jenkinsfile. After that, I will verify that the credential has access to the Git repository.

# Scenario 3

A Jenkins pipeline fails at the Docker build stage with “permission denied.” What will you check?

In this case, I will check the console output for the exact error. Then I will check whether Docker is installed and the Docker service is running. I will also check whether the Jenkins user is added to the Docker group. After fixing the issue, I will run the build again.

# Scenario 4

A Jenkins pipeline is failing because of “No space left on device.” What will you check?

The issue is related to disk space, so first I will check the disk space. Then I will identify and clean unnecessary files. If we still need more space, I will increase the disk size after approval. Then I will run the pipeline again.

# Scenario 5

A Jenkins agent suddenly goes offline. How will you troubleshoot it?

First, I will check the agent status and try to ping the agent from the Jenkins server. Then I will check whether there is any connectivity issue or resource issue. I will also check SSH connectivity and the agent log. After fixing the issue, I will reconnect the agent and verify the pipeline.

# Scenario 6

A Jenkins pipeline is running very slowly. What will you check?

First, I will check the resource availability of the agent, like CPU, memory and disk space. Then I will check the executor and see if multiple jobs are running on the same agent. I will also check the build logs to identify which stage is taking more time.

# Scenario 7

If your Jenkins pipeline takes 1 hour, how would you reduce it to around 10 minutes?”

First, I will check the pipeline logs and find which stage is taking more time. Then I will optimize that stage. If possible, I will run independent tasks in parallel. If the agent is slow, I will use a better agent.

# Scenario 8

A Jenkins pipeline is successful, but the application is not running after deployment. What will you check?

First, I will check whether the application is running by using curl on localhost. If the application is deployed on Kubernetes, I will check the Pod status and logs. If it is deployed using Docker, I will check the container status and logs. After that, I will check whether the required port is listening and verify the Security Group if required.

# Scenario 9

A Jenkins pipeline fails during the deployment stage. What will you check first?

First, I will check the console output to find the exact error. Then I will check whether it is a dependency issue, configuration issue, or an issue in the Jenkinsfile. Based on the error, I will fix the issue and run the pipeline again.

# Scenario 10

A Jenkins build is failing with command not found. How will you troubleshoot it?

If I get a command not found error, first I will check the Jenkinsfile and verify the command. Then I will check whether the required tool is installed on the Jenkins agent and whether it is available in the PATH. I will fix the issue and run the pipeline again.

# Scenario 11

What happen during the pipeline Master and Slave goes down?

If the Jenkins Controller goes down, the running pipeline is affected. After the Controller comes back, Jenkins can resume the pipeline from its saved state, depending on the pipeline state and durability. It does not necessarily start from the beginning.

If the agent goes down, the Controller remains available, but the pipeline cannot continue the work that requires that agent. Once the agent comes back, Jenkins can recover or resume the pipeline from its saved state, depending on the step and pipeline state.

# Scenario 12

Which Jenkins plugins have you used?

I have mainly worked with Git, Pipeline, Credentials and Docker-related plugins. Git plugin is used for source code checkout, Pipeline plugin is used for Jenkinsfile-based pipelines, Credentials plugin is used to manage credentials securely, and Docker Pipeline plugin is used for Docker-related operations.






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
