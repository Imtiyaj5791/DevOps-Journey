# AWS CloudTrail - Interview Notes & Hands-on

## What is CloudTrail?

CloudTrail is an AWS auditing service that records all API activities performed in an AWS account. It helps us identify:

- Who performed the activity
- What activity was performed
- When it was performed
- From where it was performed (Source IP)
- Which AWS resource was affected

---

## Why do we use CloudTrail?

CloudTrail is mainly used for:

- Auditing
- Security
- Compliance
- Troubleshooting
- Tracking user activities

### Example

Suppose an EC2 instance is deleted unexpectedly.

Using CloudTrail, we can check:

- Who deleted the EC2
- When it was deleted
- Source IP address
- AWS Region
- Instance ID

---

# Event History

Event History is enabled by default.

Features:

- Stores last **90 days** of Management Events
- No configuration required
- No additional charge
- Good for quick investigation

---

# Trail

A Trail continuously captures AWS activities and stores them in an S3 bucket.

Purpose:

- Long-term log storage
- Compliance
- Security audit
- Log retention

Flow:

```
AWS Activity
      │
      ▼
 CloudTrail
      │
      ▼
 S3 Bucket
```

---

# Event History vs Trail

| Event History | Trail |
|--------------|-------|
| Enabled by default | User creates it |
| Last 90 days | Long-term storage |
| AWS managed | Stores logs in S3 |
| Quick investigation | Audit & Compliance |

---

# Management Events

Management Events record resource-level activities.

Examples:

- Create EC2
- Stop EC2
- Delete EC2
- Create S3 Bucket
- Delete S3 Bucket
- Create IAM User
- Modify Security Group

Default:

- Enabled

---

# Data Events

Data Events record operations performed inside supported resources.

Examples:

- Upload Object
- Download Object
- Delete Object
- Lambda Invoke

Default:

- Disabled

---

# Management vs Data Events

| Management Events | Data Events |
|------------------|------------|
| Resource management | Data access |
| Create EC2 | Upload Object |
| Delete Bucket | Download Object |
| Modify Security Group | Delete Object |
| Enabled by default | Disabled by default |

---

# Read Events

Read Events only retrieve information.

Examples:

- DescribeInstances
- ListBuckets
- GetBucketPolicy

Read-only:

```
true
```

---

# Write Events

Write Events modify AWS resources.

Examples:

- RunInstances
- StartInstances
- StopInstances
- CreateBucket
- DeleteBucket
- ModifySecurityGroup

Read-only:

```
false
```

---

# CloudTrail Insights

CloudTrail Insights detects unusual API activity.

Example:

Normally:

```
TerminateInstances = 2/day
```

Suddenly:

```
TerminateInstances = 100 in 5 minutes
```

CloudTrail Insights identifies this as unusual activity.

It only detects unusual activity.

For notifications:

```
CloudTrail Insights
        │
        ▼
CloudWatch
        │
        ▼
SNS
        │
        ▼
Email / Opsgenie
```

---

# Event Details

Every CloudTrail event contains:

- Event Name
- Event Time
- User Name
- Event Source
- AWS Region
- Source IP
- Read-only
- Resources Referenced

---

# Resources Referenced

This section shows which AWS resources were affected.

Example:

```
AWS::EC2::Instance

i-0123456789
```

Useful during troubleshooting.

---

# CloudTrail Log Storage

CloudTrail stores logs in S3.

Folder structure:

```
AWSLogs
   │
Account ID
   │
CloudTrail
   │
Region
   │
Year
   │
Month
   │
Day
   │
.json.gz
```

---

# Why don't we open S3 logs manually?

CloudTrail stores raw JSON log files.

In production:

- Event History → Recent events
- Athena → Search old logs
- CloudTrail Lake → Search & analysis
- SIEM Tools → Enterprise monitoring

S3 is mainly used for long-term storage.

---

# Production Scenarios

## Who deleted my EC2?

Use CloudTrail.

Check:

- TerminateInstances
- User
- Source IP
- Time
- Instance ID

---

## Who modified Security Group?

Search:

```
AuthorizeSecurityGroupIngress
```

or

```
RevokeSecurityGroupIngress
```

---

## Who created an IAM User?

Search:

```
CreateUser
```

---

## Who deleted an S3 Bucket?

Search:

```
DeleteBucket
```

---

## Best Interview Questions

### What is CloudTrail?

CloudTrail is an AWS auditing service that records all API activities performed in an AWS account.

---

### Why do we use CloudTrail?

To audit user activities, improve security, troubleshoot issues, and meet compliance requirements.

---

### What is Event History?

Event History stores the last 90 days of Management Events and is enabled by default.

---

### What is a Trail?

A Trail continuously captures AWS activities and stores them in an S3 bucket for long-term auditing.

---

### Difference between Event History and Trail?

Event History stores the last 90 days of events, while a Trail stores logs in an S3 bucket for long-term retention.

---

### What are Management Events?

Management Events record resource-level operations such as creating, deleting, or modifying AWS resources.

---

### What are Data Events?

Data Events record activities performed inside supported resources, such as uploading or downloading objects in an S3 bucket.

---

### Difference between Management Events and Data Events?

Management Events track resource changes, whereas Data Events track operations performed on the data inside resources.

---

### What is CloudTrail Insights?

CloudTrail Insights detects unusual API activity by comparing current activity with normal usage patterns.

---

### What information does CloudTrail record?

CloudTrail records:

- User
- Event
- Time
- Source IP
- AWS Region
- Resource
- Event Source

---

### What is Read-only = true?

It indicates that the event only retrieved information and did not modify the resource.

---

### What is Read-only = false?

It indicates that the event modified the AWS resource.

---

### How do you identify who deleted an EC2 instance?

Search for the **TerminateInstances** event in CloudTrail and review the user, source IP, time, and instance ID.

---

### Where are CloudTrail logs stored?

CloudTrail stores logs in an Amazon S3 bucket.

---

### How do you search old CloudTrail logs?

Old CloudTrail logs stored in S3 can be searched using Amazon Athena or CloudTrail Lake.

---

# Interview Summary

- CloudTrail = Auditing Service
- Event History = Last 90 Days
- Trail = Long-term logs in S3
- Management Events = Resource management
- Data Events = Resource data operations
- Read-only = true → View only
- Read-only = false → Resource modified
- CloudTrail Insights = Detect unusual API activity
- CloudWatch + SNS = Notifications
