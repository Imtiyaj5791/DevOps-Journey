# 📊 CloudWatch + SNS – Top 30 Interview Questions

> **Level:** AWS Cloud / Linux Support – L2  
> **Focus:** CloudWatch Metrics + Alarms + Logs + Agent + Dashboards + SNS + Production Troubleshooting + Scenarios

---

# Q1. What is Amazon CloudWatch?

## Answer

Amazon CloudWatch is a monitoring service in AWS.

It is used to monitor AWS resources and applications using:

- Metrics
- Alarms
- Logs
- Dashboards

For example, we can monitor EC2 CPU utilization and create an alarm when CPU crosses a defined threshold.

**Remember:**

`CloudWatch = Monitoring`

---

# Q2. What are CloudWatch Metrics?

## Answer

CloudWatch Metrics are numerical data points used to monitor the performance of AWS resources.

For EC2, common metrics are:

- CPUUtilization
- NetworkIn
- NetworkOut
- DiskReadOps
- DiskWriteOps
- StatusCheckFailed

Example:

```text
EC2
 ↓
CPUUtilization
 ↓
CloudWatch Metric
```

We can use these metrics to create alarms and dashboards.

---

# Q3. Does CloudWatch monitor EC2 Memory and Disk Utilization by default?

## Answer

No.

CloudWatch provides many EC2 infrastructure metrics by default, such as CPU utilization and network metrics.

Memory utilization and filesystem disk usage are operating system-level metrics and are not available as standard EC2 metrics by default.

For Memory and Disk utilization, we can install and configure the **CloudWatch Agent** on the EC2 instance.

**Remember:**

```text
CPU     → Available without CloudWatch Agent

Memory  → CloudWatch Agent required

Disk %  → CloudWatch Agent required
```

---

# Q4. What is a CloudWatch Alarm?

## Answer

CloudWatch Alarm monitors a metric and performs an action when the configured condition is met.

Example:

```text
EC2 CPUUtilization
       ↓
CPU > 80%
       ↓
CloudWatch Alarm
       ↓
SNS
       ↓
Email Notification
```

We can configure:

- Metric
- Threshold
- Evaluation period
- Alarm action

---

# Q5. What are the states of a CloudWatch Alarm?

## Answer

A CloudWatch Alarm has three main states:

### OK

Metric is within the configured threshold.

### ALARM

Metric has breached the configured threshold according to the alarm condition.

### INSUFFICIENT_DATA

CloudWatch does not have enough data to determine the alarm state.

**Remember:**

```text
OK
ALARM
INSUFFICIENT_DATA
```

---

# Q6. How do you create a CPU Utilization Alarm for EC2?

## Answer

First I select the EC2 CPUUtilization metric in CloudWatch.

Then I configure the required threshold.

Example:

```text
CPUUtilization > 80%
```

Then I configure:

- Evaluation period
- Alarm action
- SNS Topic

When CPU crosses the configured threshold according to the alarm condition, CloudWatch changes the alarm state and SNS can send the notification.

**Flow:**

```text
EC2 CPU
   ↓
CloudWatch Metric
   ↓
CloudWatch Alarm
   ↓
SNS Topic
   ↓
Email
```

---

# Q7. What is an Evaluation Period in CloudWatch Alarm?

## Answer

Evaluation Period defines how many monitoring periods CloudWatch evaluates when deciding the alarm state.

For example:

```text
Period = 5 minutes
Evaluation = 2 periods
```

CloudWatch evaluates the configured datapoints over those periods based on the alarm settings.

This helps avoid triggering alarms because of a very short temporary spike.

---

# Q8. What is a CloudWatch Dashboard?

## Answer

CloudWatch Dashboard provides a single view where we can monitor multiple AWS metrics using widgets and graphs.

For example, a dashboard can show:

- EC2 CPU
- Memory
- Disk
- Network
- Load Balancer metrics
- RDS metrics

In production support, dashboards help us quickly identify spikes and understand when an issue started.

---

# Q9. What is CloudWatch Logs?

## Answer

CloudWatch Logs is used to centrally collect, store and monitor log data.

Logs can come from:

- EC2 applications
- Operating systems
- Lambda functions
- AWS services

Example:

```text
Application
    ↓
Log File
    ↓
CloudWatch Logs
    ↓
Log Group
    ↓
Log Stream
```

It helps in troubleshooting and centralized log monitoring.

---

# Q10. What is the difference between Log Group and Log Stream?

## Answer

### Log Group

A Log Group is a collection of related log streams.

Example:

```text
/production/application
```

### Log Stream

A Log Stream contains log events from a particular source.

For example:

```text
EC2-Server-01
EC2-Server-02
```

**Simple Example:**

```text
Log Group
   |
   |-- Server-01 Log Stream
   |-- Server-02 Log Stream
   |-- Server-03 Log Stream
```

---

# Q11. What is CloudWatch Agent?

## Answer

CloudWatch Agent is installed on a server to collect additional operating system-level metrics and logs.

It can collect metrics such as:

- Memory utilization
- Disk utilization
- Disk I/O
- Other configured system metrics

It can also collect configured log files and send them to CloudWatch Logs.

**Remember:**

`CloudWatch Agent = OS Metrics + Logs`

---

# Q12. How do you install and configure CloudWatch Agent on EC2?

## Answer

First I attach an IAM Role to EC2 with the required CloudWatch Agent permissions.

For example:

```text
CloudWatchAgentServerPolicy
```

Then I install CloudWatch Agent on the server.

On Ubuntu:

```bash
sudo apt update
sudo apt install amazon-cloudwatch-agent
```

Then I run the configuration wizard:

```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
```

The wizard allows us to select metrics such as:

- Memory
- Disk
- Disk I/O
- Logs

After creating the configuration, I start the agent using the required configuration.

Example when using a local configuration file:

```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
-a fetch-config \
-m ec2 \
-s \
-c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
```

Then I verify the Agent status and check the metrics in CloudWatch.

---

# Q13. What IAM permission is required for CloudWatch Agent?

## Answer

The EC2 instance needs an IAM Role with permissions required by CloudWatch Agent to publish metrics and logs.

A commonly used AWS managed policy is:

```text
CloudWatchAgentServerPolicy
```

We should attach permissions through an IAM Role instead of storing AWS access keys on the EC2 server.

---

# Q14. CloudWatch Agent is running but Memory metric is not showing. How will you troubleshoot?

## Answer

First I will verify that the CloudWatch Agent is running.

Then I will check:

- Agent configuration
- Memory metric is enabled
- IAM Role and permissions
- Agent logs
- AWS Region
- CloudWatch namespace and dimensions

I can check the Agent status using:

```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
-m ec2 \
-a status
```

I will also check CloudWatch Agent logs for errors.

**Troubleshooting Flow:**

```text
Agent Status
    ↓
Configuration
    ↓
IAM Role
    ↓
Agent Logs
    ↓
Region / Namespace / Dimensions
```

---

# Q15. What is Amazon SNS?

## Answer

Amazon SNS (Simple Notification Service) is a messaging and notification service.

It follows a publish-subscribe model.

In monitoring, we commonly use SNS with CloudWatch Alarm to send notifications.

Example:

```text
CloudWatch Alarm
       ↓
SNS Topic
       ↓
Email
```

SNS can deliver messages to supported endpoints such as:

- Email
- SMS
- HTTP/HTTPS
- SQS
- Lambda

---

# Q16. What is an SNS Topic?

## Answer

An SNS Topic is a communication channel where publishers send messages.

Subscribers subscribe to the Topic to receive those messages.

Example:

```text
CloudWatch Alarm
       ↓
   SNS Topic
    /      \
   ↓        ↓
Email-1   Email-2
```

One SNS Topic can have multiple subscriptions.

---

# Q17. What is an SNS Subscription?

## Answer

SNS Subscription connects an endpoint to an SNS Topic.

For example:

```text
Topic:
Production-Alerts

Subscription:
Email → support@example.com
```

When a message is published to the Topic, SNS sends it to the subscribed endpoint according to the subscription configuration.

For email subscriptions, the recipient must confirm the subscription before notifications can be received.

---

# Q18. Can the same SNS Topic be used for multiple CloudWatch Alarms?

## Answer

Yes.

The same SNS Topic can be used with multiple CloudWatch Alarms.

For example:

```text
CPU Alarm ----\
               \
Memory Alarm ---> Production-Alerts SNS Topic → Email
               /
Disk Alarm ----/
```

This is useful when the same operations team should receive multiple infrastructure alerts.

---

# Q19. CloudWatch Alarm is in ALARM state but Email Notification is not received. How will you troubleshoot?

## Answer

First I will verify whether the CloudWatch Alarm action is configured with the correct SNS Topic.

Then I will check:

- SNS Topic
- Email subscription
- Subscription confirmation status
- Correct email address
- Alarm action configuration
- SNS delivery-related information where applicable

For email subscriptions, I will make sure the subscription is confirmed.

**Troubleshooting Flow:**

```text
CloudWatch Alarm
       ↓
Alarm Action
       ↓
SNS Topic
       ↓
Subscription Confirmed?
       ↓
Email
```

---

# Q20. What is the difference between CloudWatch and SNS?

## Answer

### CloudWatch

Used for monitoring resources, metrics, logs and alarms.

### SNS

Used for sending messages and notifications.

Example:

```text
CloudWatch
= Detect / Monitor

SNS
= Notify
```

Together:

```text
CloudWatch Alarm
       ↓
SNS
       ↓
Support Team
```

---

# Q21. You received a High CPU Alarm. How will you troubleshoot?

## Answer

First I will check the CloudWatch dashboard and CPU graph to verify the spike and identify since when CPU is high.

Then I will connect to the EC2 instance and check CPU utilization.

Commands:

```bash
top
```

or

```bash
htop
```

I can also identify CPU-consuming processes using:

```bash
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head
```

Then I will check:

- Which process is consuming CPU
- Whether traffic increased
- Application logs
- Any recent changes
- Whether scaling is working if the server is part of ASG

I will troubleshoot based on the root cause and update the incident ticket.

---

# Q22. You received a High Memory Alarm. How will you troubleshoot?

## Answer

First I will check the CloudWatch Memory metric and verify when memory utilization increased.

Then I will connect to the server.

I will check:

```bash
free -h
```

and:

```bash
top
```

I can identify high memory-consuming processes using:

```bash
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head
```

Then I will check:

- Which process is consuming memory
- Application behavior
- Recent changes
- Application logs
- Whether the process is continuously increasing memory usage

I will take action according to the issue and SOP.

---

# Q23. You received a High Disk Utilization Alarm. How will you troubleshoot?

## Answer

First I will check the CloudWatch Disk metric and identify the affected server/filesystem.

Then I will connect to the server and check filesystem utilization.

```bash
df -h
```

Then I will identify which directory is consuming space.

Example:

```bash
du -xsh /* 2>/dev/null
```

I will check:

- Application logs
- System logs
- Temporary files
- Old backup files
- Large files

I will not directly delete production data.

I will archive, rotate or remove files according to the retention policy and approval process.

I will also check whether logrotate is working properly.

---

# Q24. CPU is high but CloudWatch Alarm did not trigger. What will you check?

## Answer

First I will verify the actual CloudWatch CPU metric.

Then I will check the Alarm configuration:

- Correct EC2 instance/metric
- Threshold
- Period
- Evaluation periods
- Datapoints to alarm
- Alarm state
- Missing data configuration

For example, if CPU crossed 80% only for a very short time but the alarm requires multiple breaching datapoints, the alarm may not move to ALARM state.

---

# Q25. CloudWatch shows INSUFFICIENT_DATA. What does it mean and what will you check?

## Answer

INSUFFICIENT_DATA means CloudWatch does not currently have enough data to determine whether the alarm should be OK or ALARM.

I will check:

- Whether the resource is running
- Whether the metric is being published
- Correct metric and dimensions
- Monitoring period
- CloudWatch Agent status for custom/agent metrics
- Missing data configuration

For an Agent-based metric, I will also verify the CloudWatch Agent.

---

# Q26. Memory was high, but after some time the Alarm automatically changed back to OK. Why?

## Answer

CloudWatch continuously evaluates the metric.

When Memory utilization crossed the configured threshold, the alarm moved to ALARM state.

After Memory utilization returned to the normal range and satisfied the configured alarm evaluation condition, CloudWatch changed the state back to OK.

Example:

```text
Memory Normal
     ↓
     OK

Memory > Threshold
     ↓
   ALARM

Memory Normal Again
     ↓
     OK
```

---

# Q27. How will you monitor an application log and alert when a specific error occurs?

## Answer

First I will send the application logs to CloudWatch Logs.

Then I can create a metric filter for a specific pattern.

For example:

```text
ERROR
```

The metric filter creates/publishes a CloudWatch metric when matching log events occur.

Then I can create a CloudWatch Alarm on that metric.

Finally, I can connect the Alarm to SNS.

**Flow:**

```text
Application Log
      ↓
CloudWatch Logs
      ↓
Metric Filter
      ↓
CloudWatch Metric
      ↓
Alarm
      ↓
SNS
      ↓
Email
```

---

# Q28. Application is down but CPU and Memory are normal. What will you check?

## Answer

Normal CPU and Memory do not mean the application is healthy.

First I will check whether the application service is running.

```bash
systemctl status <service-name>
```

Then I will check whether the required port is listening.

```bash
ss -tulnp
```

Then I will check:

- Application logs
- Load Balancer Target Health
- Security Group
- DNS
- Network connectivity
- Recent application changes

If the application is behind an ALB, I will also verify the Target Group health.

**Remember:**

`CPU Normal ≠ Application Healthy`

---

# Q29. CloudWatch Alarm is generating too many alerts. How will you handle it?

## Answer

First I will analyze the metric and alarm history to understand why the alarm is triggering frequently.

Then I will review:

- Threshold
- Period
- Evaluation periods
- Datapoints to alarm
- Whether the threshold matches the actual production requirement

If the alarm configuration is too sensitive, I will tune it based on the application baseline and monitoring requirement after proper discussion and approval.

I will not simply disable the alarm to stop notifications.

---

# Q30. Explain one CloudWatch + SNS issue you handled.

## Answer

One common scenario is a High CPU alert.

I receive the alert through CloudWatch Alarm and SNS notification.

First I check the CloudWatch dashboard and CPU graph to verify the spike and identify when CPU utilization started increasing.

Then I connect to the EC2 instance and check:

```bash
top
```

I identify which process is consuming high CPU.

Then I check the application logs and any recent changes.

If the server is behind an Auto Scaling Group, I also verify whether scaling is working properly.

After identifying the issue, I take action according to the SOP and coordinate with the application team if required.

Finally, I monitor the CPU utilization until it returns to normal and update the Jira ticket with the findings and resolution.

---

# ⭐ Frequently Asked Cross Questions

### Q1. Can CloudWatch monitor Memory Utilization of EC2 by default?

**Answer:**

No.

For EC2 OS-level Memory utilization, we normally install and configure the CloudWatch Agent.

---

### Q2. Do we need CloudWatch Agent for EC2 CPUUtilization?

**Answer:**

No.

EC2 CPUUtilization is available as a standard CloudWatch metric.

---

### Q3. Can one CloudWatch Alarm send notification to multiple people?

**Answer:**

Yes.

The Alarm can publish to an SNS Topic, and the SNS Topic can have multiple subscriptions.

Example:

```text
Alarm
  ↓
SNS Topic
  ↓
-------------------
↓        ↓        ↓
Email-1  Email-2  Email-3
```

---

### Q4. Can we use the same SNS Topic for CPU, Memory and Disk Alarms?

**Answer:**

Yes.

If the same team needs all these alerts, multiple alarms can publish to the same SNS Topic.

---

### Q5. What happens if an SNS Email Subscription is not confirmed?

**Answer:**

The email endpoint will not receive notifications until the subscription is confirmed.

---

### Q6. What is the difference between CloudWatch Metrics and CloudWatch Logs?

**Answer:**

**Metrics** are numerical monitoring data.

Example:

```text
CPUUtilization = 85%
```

**Logs** contain event or application log records.

Example:

```text
ERROR: Database connection failed
```

---

### Q7. Where will you check first after receiving a High CPU alert?

**Answer:**

First I will check the CloudWatch metric/dashboard to verify the alert and identify when the spike started.

Then I will connect to the server and troubleshoot the process causing high CPU.

---

### Q8. Can CloudWatch Alarm restart or recover an EC2 instance?

**Answer:**

CloudWatch alarms support certain EC2 alarm actions, such as stop, terminate, reboot, or recover, depending on the metric/action and supported configuration.

For normal production monitoring, we commonly use alarm notifications through SNS and take action according to the required automation or SOP.

---

### Q9. CloudWatch Agent is installed but stopped. What happens?

**Answer:**

The Agent will stop publishing the metrics and logs that depend on that Agent.

Standard AWS metrics such as EC2 CPUUtilization can still continue because they do not depend on the CloudWatch Agent.

---

### Q10. What CloudWatch activities do you perform in your project?

**Answer:**

In my project, I work with CloudWatch for activities such as:

- Monitoring EC2 metrics
- Checking CPU utilization
- Checking dashboards
- Reviewing alarm status
- Troubleshooting High CPU, Memory and Disk alerts
- Working with CloudWatch Agent for OS-level metrics
- Checking logs when required
- Verifying SNS notifications
- Coordinating with application and infrastructure teams
- Updating Jira tickets after incident resolution

---

# 🔥 CloudWatch + SNS Complete Flow

```text
AWS Resource / EC2
        ↓
CloudWatch Metric
        ↓
CloudWatch Alarm
        ↓
SNS Topic
        ↓
Subscription
        ↓
Email / Supported Endpoint
        ↓
Support Engineer
        ↓
Troubleshooting
        ↓
Resolution
```

---

# 🔥 CloudWatch Agent Flow

```text
EC2 Operating System
        ↓
CloudWatch Agent
        ↓
Memory / Disk / Configured Metrics
        ↓
CloudWatch
        ↓
Alarm
        ↓
SNS
        ↓
Notification
```

---

# 🔥 Log-Based Alert Flow

```text
Application
     ↓
Log File
     ↓
CloudWatch Agent / Supported Log Delivery
     ↓
CloudWatch Logs
     ↓
Metric Filter
     ↓
Metric
     ↓
Alarm
     ↓
SNS
     ↓
Notification
```

---

# 🔥 Final Quick Revision

```text
CloudWatch
= Monitoring Service

Metrics
= Numerical monitoring data

Alarm
= Monitors metric against configured condition

Alarm States
= OK / ALARM / INSUFFICIENT_DATA

Dashboard
= Single monitoring view

CloudWatch Logs
= Centralized log collection and monitoring

Log Group
= Collection of related Log Streams

Log Stream
= Log events from a source

CloudWatch Agent
= Collect OS-level metrics and configured logs

EC2 CPU
= Available without CloudWatch Agent

Memory
= CloudWatch Agent required

Filesystem Disk %
= CloudWatch Agent required

SNS
= Messaging / Notification Service

SNS Topic
= Communication channel

SNS Subscription
= Endpoint subscribed to Topic

High CPU
= Dashboard → top/ps → Process → Logs → Recent Changes

High Memory
= Dashboard → free/top/ps → Process → Logs

High Disk
= df → du → Logs/Large Files → Retention Policy

No Email
= Alarm Action → SNS Topic → Subscription Confirmation

INSUFFICIENT_DATA
= Not enough metric data

Too Many Alerts
= Review Threshold + Period + Evaluation + Datapoints

CPU/Memory Normal
≠ Application Healthy
```
