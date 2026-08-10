# Jenkins – CV-Based Interview Preparation

> **Level:** Working Knowledge  
> **Focus:** Basic Concepts + Important Interview Questions + Scenario-Based Questions  
> **Purpose:** Interview preparation based on Jenkins Working Knowledge mentioned in CV.

---

## Q1. What is Jenkins?

Jenkins is an open-source automation tool used to automate application build, test and deployment.

**Remember:**

`Jenkins = Build → Test → Deploy Automation`

---

## Q2. What is CI/CD?

**Continuous Integration (CI)** means when developer pushes the code, Jenkins builds and tests the code.

**Continuous Delivery/Deployment (CD)** means after successful build and testing, application is delivered or deployed to the target environment.

**Remember:**

`CI = Build + Test`

`CD = Delivery / Deployment`

### Continuous Delivery vs Continuous Deployment

**Continuous Delivery:**  
After successful build and testing, application is ready for deployment, but production deployment can require manual approval.

**Continuous Deployment:**  
After successful build and testing, application is automatically deployed to production.

**Remember:**

`Continuous Delivery = Human intervention / Manual approval`

`Continuous Deployment = Automatic deployment`

---

## Q3. What is Jenkins Pipeline?

Jenkins Pipeline defines the complete CI/CD flow of an application, like build, test and deployment.

Example:

`Checkout → Build → Test → Deploy`

**Remember:**

`Pipeline = Complete CI/CD Flow`

---

## Q4. What is Jenkinsfile?

Jenkinsfile is a file where we write the pipeline code and normally keep it in the Git repository.

**Remember:**

`Jenkinsfile = File where Pipeline code is stored`

---

## Q5. What is the difference between Pipeline and Jenkinsfile?

Pipeline defines how our application will build, test and deploy, while Jenkinsfile stores that pipeline code.

**Remember:**

`Pipeline = CI/CD Flow`

`Jenkinsfile = Stores Pipeline Code`

---

# How Do We Write a Jenkins Pipeline?

There are two common ways to define a Jenkins Pipeline.

### Method 1 – Write Pipeline Script Directly in Jenkins

Create a Pipeline job:

`Jenkins → New Item → Pipeline → Configure`

In the **Definition** section, select:

`Pipeline script`

Then write the pipeline code directly in Jenkins.

Example:

```groovy
pipeline {
    agent any

    stages {

        stage('Build') {
            steps {
                echo 'Building Application'
            }
        }

        stage('Test') {
            steps {
                echo 'Testing Application'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying Application'
            }
        }
    }
}
```

In this method, pipeline code is configured directly in Jenkins.

---

### Method 2 – Store Pipeline Code in Jenkinsfile

We create a file named:

```text
Jenkinsfile
```

Normally we keep this file inside the Git repository along with application code.

Example repository structure:

```text
my-application/
│
├── application-code
├── Dockerfile
└── Jenkinsfile
```

The Jenkinsfile contains our pipeline code.

Example:

```groovy
pipeline {
    agent any

    stages {

        stage('Build') {
            steps {
                echo 'Building Application'
            }
        }

        stage('Test') {
            steps {
                echo 'Testing Application'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying Application'
            }
        }
    }
}
```

Then in Jenkins:

`New Item → Pipeline → Configure`

Select:

`Definition → Pipeline script from SCM`

Configure:

```text
SCM            → Git
Repository URL → GitHub Repository URL
Branch         → main
Script Path    → Jenkinsfile
```

Now Jenkins will read the pipeline code from the Jenkinsfile stored in Git.

### Important

We do **not** need to write the same pipeline code in both places.

We can use either:

`Pipeline Script directly in Jenkins`

**OR**

`Pipeline code stored in Jenkinsfile`

**Simple Difference:**

`Pipeline = Defines the CI/CD flow`

`Jenkinsfile = Stores the Pipeline code`

---

## Q6. How does Jenkins know when developer pushes new code to GitHub?

We configure a webhook in GitHub.

When developer pushes new code, GitHub sends a webhook request to Jenkins and Jenkins triggers the pipeline.

**Flow:**

`Developer → Git Push → GitHub → Webhook → Jenkins → Pipeline`

**Remember:**

`Webhook = GitHub informs Jenkins`

---

## Q7. Developer pushed the code but Jenkins Pipeline did not start. What will you check?

First I will check whether the code is pushed successfully to GitHub.

Then I will check the GitHub webhook and Jenkins build trigger configuration.

I will also check whether Jenkins is running and reachable.

**Troubleshooting Flow:**

`Git Push → Webhook → Jenkins Reachability → Build Trigger`

---

## Q8. Jenkins Pipeline failed at Build stage. What will you do?

First I will check the Jenkins console output and identify the exact error.

Then I will check the build command, dependencies and configuration based on the error.

After fixing the issue, I will run the pipeline again.

**Remember:**

`Console Output → Find Error → Fix → Re-run`

---

## Q9. Jenkins is unable to pull code from GitHub. What will you check?

First I will check the Git repository URL and branch.

Then I will check GitHub credentials or token configured in Jenkins.

I will also check network connectivity between Jenkins and GitHub.

**Remember:**

`Repository URL → Branch → Credentials → Connectivity`

---

## Q10. Build and Test are successful but Deployment failed. What will you check?

First I will check the deployment stage logs in Jenkins.

Then I will check target server connectivity, credentials and deployment command.

I will troubleshoot based on the error in the logs.

**Remember:**

`Deploy Logs → Connectivity → Credentials → Deployment Command`

---

## Q11. How do you store passwords or tokens in Jenkins?

We use Jenkins Credentials to securely store sensitive information like username, password, token and SSH key.

We should not hard-code passwords or tokens in the Jenkinsfile.

**Remember:**

`Password / Token / SSH Key → Jenkins Credentials`

---

## Q12. What is Jenkins Controller and Agent?

Jenkins Controller manages the jobs and pipelines, while Jenkins Agent executes the build tasks.

**Remember:**

`Controller = Manage`

`Agent = Execute`

---

## Q13. Jenkins Agent is offline. What will you check?

First I will check whether the agent server is running and reachable.

Then I will check network connectivity and the agent connection with Jenkins Controller.

I will also check the agent logs for the exact error.

**Troubleshooting Flow:**

`Agent Status → Connectivity → Controller Connection → Logs`

---

## Q14. What is Jenkins Plugin?

Jenkins Plugin is used to add additional features and integrations in Jenkins, like Git, Docker or Pipeline support.

**Remember:**

`Plugin = Additional Feature / Integration`

---

## Q15. What is a Parameterized Build?

Parameterized Build allows us to pass input while running a Jenkins job.

For example, we can create an environment parameter:

```text
DEV
TEST
PROD
```

While running the pipeline, we can select which environment we want to use.

**Remember:**

`Parameter = Input passed while running the build`

---

## Q16. What is Jenkins Workspace?

Jenkins Workspace is the location where Jenkins keeps the project files and performs the build.

When Jenkins takes the latest code from Git, it can keep the project files in the workspace and perform build operations there.

**Remember:**

`Workspace = Jenkins Working Location`

---

## Q17. What is an Artifact?

Artifact is the output generated after a successful build, for example JAR or WAR file, which can be used for deployment.

Example:

`Source Code → Build → app.jar → Deploy`

**Remember:**

`Build Output = Artifact`

---

## Q18. Same Pipeline needs to deploy to DEV, TEST and PROD. How will you handle it?

We can use parameters in Jenkins and select the environment like DEV, TEST or PROD while running the pipeline.

For production, we can also add manual approval before deployment.

Example:

`Pipeline → Select Environment → DEV / TEST / PROD`

---

## Q19. Password is written directly inside Jenkinsfile. Is it correct?

No.

We should not hard-code passwords or tokens in Jenkinsfile.

We should store them in Jenkins Credentials and use the credential in the pipeline.

**Remember:**

`Never Hard-Code Password → Use Jenkins Credentials`

---

## Q20. What is the difference between Webhook and Poll SCM?

In Webhook, GitHub informs Jenkins when new code is pushed.

In Poll SCM, Jenkins checks the Git repository for changes at a configured interval.

**Remember:**

`Webhook → GitHub informs Jenkins`

`Poll SCM → Jenkins checks Git`

---

## Q21. Pipeline was working yesterday but today it is failing. What will you do?

First I will check Jenkins console output and identify the failed stage.

Then I will check what changed recently in code, configuration or credentials.

Based on the error, I will troubleshoot and run the pipeline again.

**Remember:**

`Logs → Failed Stage → Recent Changes → Fix → Re-run`

---

## Q22. Jenkins server is running but Pipeline is stuck in queue. What will you check?

I will check whether the Jenkins Agent is available and has free executor capacity.

I will also check if the job is waiting for any required agent or resource.

**Remember:**

`Pipeline in Queue → Check Agent / Executor`

---

## Q23. GitHub Webhook shows successful delivery but Jenkins Job is not running. What will you check?

First I will check the Jenkins job trigger configuration.

Then I will confirm that the correct repository and branch are configured.

I will also check Jenkins logs for the webhook request.

Since webhook delivery from GitHub is successful, I will mainly troubleshoot the Jenkins side.

**Remember:**

`Webhook Success + Job Not Started → Check Jenkins Side`

---

## Q24. Deployment failed because Jenkins cannot connect to target Linux Server. What will you check?

First I will check network connectivity from Jenkins to the target server.

Then I will check the required port, security rules and SSH credentials.

I will also check the deployment logs for the exact error.

**Remember:**

`Connectivity → Port / Security → SSH Credentials → Logs`

---

## Q25. Developer says "My code is correct, Jenkins problem hai." How will you verify?

First I will check Jenkins console output and identify where the pipeline failed.

If it failed during build or test, I will check the error and recent code changes.

If it is Jenkins-related, I will check Jenkins configuration, credentials, agent and connectivity based on the error.

**Remember:**

`Do not guess → Check Console Output First`

---

## Q26. Jenkins Credentials or Token expired and Pipeline cannot access GitHub. What will you do?

First I will check the error in Jenkins console output.

If the credential or token is expired, I will update the credential in Jenkins Credentials and run the pipeline again.

**Remember:**

`Authentication Error → Check / Update Credentials`

---

## Q27. Jenkins Server disk is full and builds are failing. What will you do?

First I will check disk utilization and identify what is consuming the space.

I will check old build data, workspace and logs.

Then I will clean up based on the retention policy and run the pipeline again.

Basic Linux checks:

```bash
df -h
du -sh /var/lib/jenkins/*
```

**Remember:**

`Disk Full → Check Usage → Identify Data → Cleanup as per Policy → Re-run`

---

## Q28. Pipeline failed at one stage. Do you need to run everything again?

It depends on the pipeline configuration.

We can restart the pipeline from a failed stage if the pipeline supports restart from stage.

Otherwise, we may need to run the pipeline again.

**Remember:**

`Failed Stage → Restart option depends on Pipeline configuration`

---

## Q29. How will you control Production Deployment?

We can add manual approval before the production deployment stage.

After approval, Jenkins will continue with the deployment.

Example:

`Build → Test → Manual Approval → Production Deploy`

This is commonly used with Continuous Delivery.

---

## Q30. New code caused a problem after Production Deployment. What will you do?

First I will verify the issue and check the deployment logs.

If rollback is required, I will follow the rollback process and deploy the previous stable version.

Then I will coordinate with the development team to investigate the new change.

**Remember:**

`Verify → Logs → Rollback if required → Previous Stable Version → Investigate`

---

## Q31. How do you take backup of Jenkins?

For Jenkins backup, we take backup of the `JENKINS_HOME` directory because it contains important Jenkins data such as jobs, configurations and plugins-related data.

We should take backup regularly and store it in a safe location.

**Remember:**

`Jenkins Backup → JENKINS_HOME`

---

## Q32. Jenkins Server crashed. How will you restore Jenkins?

First I will prepare the Jenkins server and install the required Jenkins version.

Then I will restore the `JENKINS_HOME` backup and start Jenkins.

After restore, I will validate the jobs, plugins and credentials.

Finally, I will run a test job to confirm Jenkins is working properly.

**Recovery Flow:**

`Prepare Server → Install Jenkins → Restore JENKINS_HOME → Start Jenkins → Validate → Test Job`

---

# Complete Jenkins CI/CD Flow

```text
Developer
    ↓
Push Code
    ↓
GitHub
    ↓
Webhook
    ↓
Jenkins Pipeline Triggered
    ↓
Checkout Code
    ↓
Workspace
    ↓
Build
    ↓
Test
    ↓
Artifact
    ↓
Manual Approval (if required)
    ↓
Deploy
```

---

# Quick Revision

```text
Jenkins
= Build, Test and Deployment Automation

CI
= Build + Test

Continuous Delivery
= Manual approval can be required before Production

Continuous Deployment
= Automatic Production Deployment

Pipeline
= Complete CI/CD Flow

Jenkinsfile
= File where Pipeline code is stored

Webhook
= GitHub informs/triggers Jenkins

Poll SCM
= Jenkins checks Git for changes

Plugin
= Adds additional features/integrations

Credentials
= Securely stores password, token and SSH key

Controller
= Manages jobs and pipelines

Agent
= Executes build tasks

Workspace
= Jenkins working location

Artifact
= Output generated after Build

Parameterized Build
= Pass input while running Build

Console Output
= First place to check Pipeline failure

JENKINS_HOME
= Important Jenkins data / Backup location
```

---

# Most Important Troubleshooting Flow

Whenever Jenkins Pipeline fails:

```text
Check Console Output
        ↓
Identify Failed Stage
        ↓
Read Exact Error
        ↓
Check Recent Changes
        ↓
Check Configuration / Credentials / Connectivity
        ↓
Fix the Issue
        ↓
Re-run Pipeline
```

---

# CV Positioning

Jenkins should be presented as:

**Working Knowledge / Hands-on Lab Experience**

If interviewer asks about production experience:

**I have working knowledge of Jenkins through hands-on practice and lab environment. My primary production experience is in AWS and Linux infrastructure support.**

Do not claim Jenkins Production Administration experience if you have not worked on Jenkins in production.

Deep Jenkins installation, administration, complete Jenkinsfile hands-on, GitHub integration, Docker deployment, Controller-Agent configuration and advanced troubleshooting will be covered during the dedicated Jenkins roadmap sessions.
