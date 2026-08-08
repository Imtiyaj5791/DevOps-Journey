# CloudWatch + SNS Practical Notes

## 1. What is Amazon CloudWatch?

Amazon CloudWatch is a monitoring service in AWS.

We can use CloudWatch to:

- Monitor AWS resources
- Monitor EC2 CPU utilization
- Create alarms
- Create dashboards
- Monitor logs
- Monitor custom metrics
- Send notifications using SNS
- Troubleshoot production issues

---

## 2. Important CloudWatch Components

### Metrics

CloudWatch Metrics are numerical values of AWS resources, like EC2 CPU utilization, NetworkIn and NetworkOut.

Examples:

- CPUUtilization
- NetworkIn
- NetworkOut
- DiskReadBytes
- DiskWriteBytes
- StatusCheckFailed

With CloudWatch Agent:

- mem_used_percent
- disk_used_percent
- swap_used_percent
- diskio_io_time

---

## 3. Default EC2 Metrics vs CloudWatch Agent Metrics

EC2 automatically sends some metrics to CloudWatch.

Examples:

- CPUUtilization
- NetworkIn
- NetworkOut
- DiskReadOps
- DiskWriteOps
- StatusCheckFailed

But EC2 does **not provide OS-level Memory utilization and filesystem Disk used percentage by default**.

For these metrics, we need to install **CloudWatch Agent** inside the EC2 instance.

Important:

```text
CPU → Available by default in CloudWatch

Memory → CloudWatch Agent required

Filesystem Disk Usage % → CloudWatch Agent required
```

---

## 4. CloudWatch Alarm

CloudWatch Alarm monitors a metric against a threshold.

Example:

```text
CPUUtilization > 80%
        ↓
CloudWatch Alarm
        ↓
ALARM State
        ↓
SNS Topic
        ↓
Email Notification
```

CloudWatch Alarm has three main states:

### OK

Metric is within the configured threshold.

### ALARM

Metric has crossed the configured threshold.

### INSUFFICIENT_DATA

CloudWatch does not have enough data to determine the alarm state.

---

# Practical 1 - CPU Alarm + SNS Email

## 5. CPU Alarm Practical

We created a CloudWatch alarm for EC2 CPU utilization.

Flow:

```text
EC2
 ↓
CPUUtilization
 ↓
CloudWatch
 ↓
CloudWatch Alarm
 ↓
SNS Topic
 ↓
Email
```

We generated CPU load on the EC2 instance and verified that the CPU utilization increased.

After the configured threshold was crossed:

```text
OK → ALARM
```

CloudWatch triggered SNS and we received an email notification.

---

# Amazon SNS

## 6. What is SNS?

Amazon SNS stands for:

**Simple Notification Service**

SNS is a publish/subscribe messaging service.

In our monitoring scenario, CloudWatch Alarm publishes a notification to SNS.

SNS then sends the notification to its subscribers.

Example:

```text
CloudWatch Alarm
       ↓
   SNS Topic
       ↓
    Subscriber
       ↓
      Email
```

---

## 7. SNS Topic

SNS Topic acts as a communication channel.

Example:

```text
EC2-Monitoring-Alerts
```

Multiple CloudWatch alarms can use the same SNS topic.

For example:

```text
CPU Alarm ──────┐
Memory Alarm ───┼──> SNS Topic ──> Email
Disk Alarm ─────┘
```

We do not need to create a separate SNS topic for every alarm.

In production, a generic name such as:

```text
EC2-Monitoring-Alerts
```

is better than a CPU-specific topic name if the topic is used for multiple alerts.

---

## 8. SNS Subscription

After creating an SNS topic, we add a subscription.

Example protocol:

```text
Email
```

SNS sends a confirmation email.

We must confirm the subscription before SNS can send notifications to that email address.

---

# CloudWatch Dashboard

## 9. What is CloudWatch Dashboard?

CloudWatch Dashboard provides a graphical view of monitoring metrics.

We can add widgets for:

- CPU utilization
- Memory utilization
- Disk utilization
- Network traffic
- Application metrics
- Alarm status

Dashboard helps the operations team quickly understand server health.

Example:

```text
              CloudWatch Dashboard

------------------------------------------------
 EC2-01 CPU        EC2-01 Memory
     35%                62%

 EC2-01 Network    EC2-01 Disk
    Graph               55%
------------------------------------------------
```

In production, dashboards are useful for identifying:

- When a spike started
- Which server is affected
- Whether CPU/Memory/Disk increased together
- Current resource utilization
- Historical trends

---

# CloudWatch Agent Practical

## 10. Why Did We Install CloudWatch Agent?

CloudWatch already provides EC2 CPU metrics.

But we wanted to monitor:

```text
Memory Utilization
Disk Used Percentage
```

These are OS-level metrics.

Therefore, we installed CloudWatch Agent inside Ubuntu EC2.

Complete flow:

```text
Ubuntu EC2
    ↓
CloudWatch Agent
    ↓
Collect OS Metrics
    ↓
CloudWatch
    ↓
CWAgent Namespace
    ↓
Alarm
    ↓
SNS
    ↓
Email
```

---

## 11. CloudWatch Agent Installation Flow

Easy way to remember:

```text
Install → IAM → Configure → Start → Verify
```

### Step 1 - Install CloudWatch Agent

On Ubuntu:

```bash
sudo apt update
```

Download/install the Amazon CloudWatch Agent package according to the AWS-supported installation method for the Ubuntu version.

After installation, CloudWatch Agent files are available under:

```text
/opt/aws/amazon-cloudwatch-agent/
```

---

## 12. IAM Role for CloudWatch Agent

The EC2 instance needs permission to send metrics to CloudWatch.

We attached an IAM role to EC2 with:

```text
CloudWatchAgentServerPolicy
```

Flow:

```text
EC2
 ↓
IAM Role
 ↓
CloudWatchAgentServerPolicy
 ↓
Permission to publish monitoring data
 ↓
CloudWatch
```

We should use IAM Role instead of storing AWS Access Key and Secret Key inside the EC2 instance.

---

## 13. CloudWatch Agent Configuration Wizard

We used the configuration wizard to create the agent configuration.

Important selections for our practical:

```text
Operating System → Linux

Environment → EC2

Run as user → root

StatsD → No

CollectD → No

Host Metrics → Yes

CPU Metrics Per Core → No

Add EC2 Dimensions → Yes

Aggregate by InstanceId → Yes

Collection Interval → 60 seconds

Default Metrics Config → Standard

Existing Log Agent Config → No

Log Files → No

Journald Logs → No

X-Ray Traces → No

SSM Parameter Store → No
```

We did not configure logs because our practical was focused on:

```text
Memory + Disk Metrics
```

---

## 14. CloudWatch Agent Config File

The wizard generated:

```text
/opt/aws/amazon-cloudwatch-agent/bin/config.json
```

We verified it using:

```bash
sudo cat /opt/aws/amazon-cloudwatch-agent/bin/config.json
```

Important configuration:

```json
"mem": {
    "measurement": [
        "mem_used_percent"
    ],
    "metrics_collection_interval": 60
}
```

This collects memory utilization every 60 seconds.

Disk configuration:

```json
"disk": {
    "measurement": [
        "used_percent",
        "inodes_free"
    ],
    "metrics_collection_interval": 60,
    "resources": [
        "*"
    ]
}
```

This collects disk utilization information for the configured filesystems.

---

## 15. Metrics Collected in Our Practical

After starting the agent, we could see these metrics:

```text
disk_inodes_free
disk_used_percent
diskio_io_time
mem_used_percent
swap_used_percent
```

These metrics appeared under:

```text
CloudWatch
   ↓
Metrics
   ↓
All Metrics
   ↓
CWAgent
```

---

## 16. Start CloudWatch Agent

We started the agent using our configuration file:

```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
-a fetch-config \
-m ec2 \
-s \
-c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
```

Meaning:

```text
-a fetch-config  → Load configuration
-m ec2           → Run in EC2 mode
-s               → Start the agent
-c file:...      → Use this configuration file
```

During startup we received:

```text
Configuration validation succeeded
```

This confirmed that the configuration was valid.

---

## 17. Check CloudWatch Agent Status

We verified the service using:

```bash
sudo systemctl status amazon-cloudwatch-agent --no-pager
```

Status was:

```text
running
```

This confirmed that CloudWatch Agent was running successfully.

---

# Memory Alarm Practical

## 18. Verify Memory Metric

After CloudWatch Agent started, we went to:

```text
CloudWatch
 ↓
Metrics
 ↓
All Metrics
 ↓
CWAgent
 ↓
InstanceId
 ↓
mem_used_percent
```

We successfully received the memory utilization metric from our Ubuntu EC2 instance.

---

## 19. Memory Alarm

We created an alarm using:

```text
mem_used_percent
```

For testing, we configured a low threshold.

Example:

```text
Memory > 30%
```

Our memory utilization was approximately:

```text
68.37%
```

Therefore:

```text
68.37% > 30%
```

CloudWatch changed the alarm state:

```text
OK → ALARM
```

---

## 20. Memory Alarm + SNS Result

The complete test was successful:

```text
Ubuntu EC2
    ↓
CloudWatch Agent
    ↓
mem_used_percent
    ↓
CloudWatch
    ↓
High_Memory Alarm
    ↓
Threshold Crossed
    ↓
SNS
    ↓
Email Received
```

We successfully received:

```text
ALARM: "High_Memory"
```

This proved that our CloudWatch Agent + Alarm + SNS configuration was working end-to-end.

---

# Production Troubleshooting

## 21. What Will You Do If You Receive High CPU Alert?

First, I will check the CloudWatch dashboard and verify the CPU spike and since when CPU utilization is high.

Then I will connect to the server and check:

```bash
top
```

or:

```bash
htop
```

I will identify which process is consuming high CPU.

I can also check:

```bash
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head
```

Then I will check whether it is an application process, database process, scheduled job, or any unexpected process.

Based on findings, I will coordinate with the respective team and take action as per SOP.

---

## 22. What Will You Do If You Receive High Memory Alert?

First, I will check the CloudWatch dashboard and verify the memory spike and since when memory utilization is high.

Then I will connect to the server and check:

```bash
free -h
```

Then:

```bash
top
```

or:

```bash
htop
```

I will identify the process consuming high memory.

I can also use:

```bash
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head
```

Then I will check whether memory consumption is expected or there is any application issue or memory leak.

I will not directly restart or kill a production process without checking impact and following the SOP/change process.

---

## 23. What Will You Do If You Receive Disk Utilization Alert?

First, I will check disk utilization:

```bash
df -h
```

Then I will identify which filesystem is highly utilized.

I can check large directories using:

```bash
du -sh /*
```

or check the required filesystem/directory specifically.

Then I will check:

- Application logs
- System logs
- Old backup files
- Temporary files
- Core dumps
- Unexpected large files

I will archive/rotate/remove files according to retention policy and SOP.

I will not directly delete production files without verification and approval.

---

# Interview Questions and Answers

## Q1. What is Amazon CloudWatch?

Amazon CloudWatch is an AWS monitoring service. We use it to monitor AWS resources, collect metrics and logs, create dashboards and alarms, and trigger notifications through SNS.

---

## Q2. What is a CloudWatch metric?

CloudWatch Metrics are numerical values of AWS resources, like EC2 CPU utilization, NetworkIn and NetworkOut.

For example:

```text
CPUUtilization
NetworkIn
NetworkOut
mem_used_percent
disk_used_percent
```

---

## Q3. Does CloudWatch monitor EC2 memory utilization by default?

No. EC2 does not provide memory utilization to CloudWatch by default.

For memory monitoring, we need to install and configure CloudWatch Agent inside the EC2 instance.

---

## Q4. How do you monitor memory utilization of an EC2 instance?

I install CloudWatch Agent on the EC2 server.

Then I attach an IAM role with `CloudWatchAgentServerPolicy`, create the agent configuration for memory metrics, and start the agent.

After that I can see `mem_used_percent` under the `CWAgent` namespace in CloudWatch.

Then I can create a CloudWatch alarm and configure SNS notification.

---

## Q5. Why is CPU available by default but memory is not?

CPU utilization can be measured from the EC2 infrastructure/hypervisor level.

Memory usage is inside the guest operating system, so AWS needs an agent running inside the OS to collect that information.

---

## Q6. What IAM policy did you use for CloudWatch Agent?

I used:

```text
CloudWatchAgentServerPolicy
```

I attached it through an IAM role to the EC2 instance.

---

## Q7. Why should we use an IAM Role instead of Access Key on EC2?

IAM Role is more secure because we do not need to store long-term Access Key and Secret Key credentials on the server.

The EC2 instance receives temporary credentials automatically through the IAM role.

---

## Q8. Where can you find CloudWatch Agent metrics?

CloudWatch Agent metrics are normally available under:

```text
CloudWatch → Metrics → All Metrics → CWAgent
```

---

## Q9. Which memory metric did you monitor?

I monitored:

```text
mem_used_percent
```

It shows the percentage of memory being used on the server.

---

## Q10. Which disk metric did you monitor?

I collected:

```text
disk_used_percent
```

It shows filesystem disk utilization percentage.

---

## Q11. What are the states of a CloudWatch Alarm?

There are three main states:

```text
OK
ALARM
INSUFFICIENT_DATA
```

`OK` means the metric is within the threshold.

`ALARM` means the configured threshold condition has been met.

`INSUFFICIENT_DATA` means CloudWatch does not currently have enough data to determine the state.

---

## Q12. What is Amazon SNS?

Amazon SNS is Simple Notification Service.

It is a publish/subscribe messaging service.

We can integrate CloudWatch Alarm with SNS to send notifications through email or other supported endpoints.

---

## Q13. Can multiple CloudWatch alarms use the same SNS topic?

Yes.

For example, CPU, memory and disk alarms can publish to the same SNS topic.

```text
CPU Alarm ────┐
Memory Alarm ─┼──> SNS → Email
Disk Alarm ───┘
```

---

## Q14. How did you test the CloudWatch alarm?

For CPU, I generated CPU load on the EC2 instance and monitored the CPUUtilization metric.

For memory, I configured a test threshold on `mem_used_percent`.

When memory utilization crossed the threshold, the alarm changed from `OK` to `ALARM`.

SNS then sent an email notification.

---

## Q15. What practical work have you done with CloudWatch?

I have created CloudWatch alarms for EC2 monitoring, configured SNS email notifications, created CloudWatch dashboards, and configured CloudWatch Agent on Ubuntu EC2 for memory and disk metrics.

I also tested CPU and memory alarms and verified SNS email notifications.

---

## Q16. What will you check when you receive a high CPU alert?

First I check the CloudWatch graph to understand when the CPU spike started and whether it is continuous or temporary.

Then I connect to the server and use `top`, `htop`, or `ps` to identify the process consuming high CPU.

After identifying the process, I check the application/service and coordinate with the respective team if required.

---

## Q17. What will you check when you receive a high memory alert?

First I check the CloudWatch graph and verify the memory utilization.

Then I connect to the server and check:

```bash
free -h
top
```

I identify the high-memory process and investigate whether it is expected usage, an application issue, or a possible memory leak.

---

## Q18. What will you do if CloudWatch Agent is not sending metrics?

First I will check the agent status:

```bash
sudo systemctl status amazon-cloudwatch-agent
```

Then I will check:

- Agent configuration
- IAM role
- `CloudWatchAgentServerPolicy`
- Network connectivity
- AWS Region
- Agent logs

I will also verify that the configuration is valid and the agent is running.

---

## Q19. What is the difference between CloudWatch and SNS?

CloudWatch is mainly used for monitoring.

SNS is mainly used for notification/messaging.

Example:

```text
CloudWatch detects high CPU
        ↓
CloudWatch Alarm triggers
        ↓
SNS sends notification
        ↓
Support team receives email
```

---

## Q20. Explain your CloudWatch + SNS practical in an interview.

I created CloudWatch monitoring for an EC2 instance.

First, I created a CPU utilization alarm and integrated it with an SNS topic for email notification. I generated CPU load and verified that the alarm moved to ALARM state and I received the SNS email.

Then I configured CloudWatch Agent on an Ubuntu EC2 instance because memory and filesystem disk utilization are not available as standard EC2 metrics.

I attached an IAM role with `CloudWatchAgentServerPolicy`, configured memory and disk metrics, and started the agent.

After that, I verified `mem_used_percent` and `disk_used_percent` under the `CWAgent` namespace.

Finally, I created a memory alarm and successfully received an SNS email when the memory threshold was crossed.
