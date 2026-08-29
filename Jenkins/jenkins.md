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

Pending
Multibranch Pipeline
Jenkins Backup + Restore
Jenkins Troubleshooting
project java based only pipeline


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
