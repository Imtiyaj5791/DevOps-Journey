# 💽 EBS Interview Questions

---

# Q1. What is Amazon EBS?

## Answer

Amazon EBS (Elastic Block Store) is a block storage service provided by AWS.

It is mainly used as storage for EC2 instances.

In my project, we use EBS volumes to store the operating system, application files and data.

My responsibilities include monitoring disk utilization, extending EBS volumes, taking snapshots before major changes and troubleshooting storage-related issues.

---

# Q2. What are the different EBS Volume Types?

## Answer

AWS provides multiple EBS volume types.

### gp3

General Purpose SSD.

Suitable for most production workloads.

### io2

High-performance SSD.

Used for applications that require high IOPS like databases.

### st1

Throughput Optimized HDD.

Used for large sequential workloads.

### sc1

Cold HDD.

Used for infrequently accessed data.

In our project, we mostly use **gp3** volumes.

---

# Q3. What is the difference between EBS and Instance Store?

## Answer

| EBS | Instance Store |
|-----|----------------|
| Persistent Storage | Temporary Storage |
| Data remains after Stop | Data is lost |
| Snapshot supported | Snapshot not supported |
| Can be detached and attached | Cannot be detached |

For production servers, we use EBS because the data remains even after the instance is stopped.

---

# Q4. What is an EBS Snapshot?

## Answer

An EBS Snapshot is a backup of an EBS volume stored in Amazon S3.

We use snapshots before patching, maintenance activities or major configuration changes.

If required, we can create a new EBS volume from the snapshot and attach it to an EC2 instance.

---

# Q5. Do you take a Snapshot before patching?

## Answer

Yes.

For production EC2 instances, we take an EBS Snapshot before patching or any major activity.

This helps us recover the server quickly if any issue occurs after the change.

---

# Q6. How do you increase the size of an EBS Volume?

## Answer

First I verify the CloudWatch alert and confirm that disk utilization is continuously high.

Then I login to the server and verify which filesystem is full.

```bash
df -h
```

I identify the directory consuming more space.

```bash
du -sh /var/*
```

If cleanup is not sufficient, I take the required approval.

Then I increase the EBS volume size from the AWS Console.

After AWS completes the modification, I verify that the operating system has detected the new size.

```bash
lsblk
```

Finally, I extend the filesystem and verify the application.

---

# Q7. How do you extend the filesystem after increasing the EBS Volume?

## Answer

First I verify the partition.

```bash
lsblk
```

If required, I extend the partition.

```bash
growpart
```

For XFS filesystem:

```bash
xfs_growfs
```

For ext4 filesystem:

```bash
resize2fs
```

Finally, I verify the new size.

```bash
df -h
```

---

# Q8. What will you do if Disk Utilization reaches 95%?

## Answer

First I verify the alert in CloudWatch.

I check whether it is a temporary spike or continuously increasing.

Then I login to the server.

I check disk utilization.

```bash
df -h
```

I identify the directory consuming more space.

```bash
du -sh /var/*
```

If log files are consuming space, I archive or remove old logs as per company SOP.

I verify logrotate.

If space is still insufficient, I extend the EBS volume.

Then I extend the filesystem.

Finally, I verify the application, monitor CloudWatch, update Jira and prepare the RCA.

---

# Q9. Can one EBS Volume be attached to multiple EC2 instances?

## Answer

Normally, No.

One EBS volume can be attached to only one EC2 instance at a time.

However, **Multi-Attach** is supported only for specific **io1/io2** volumes and supported workloads.

In our project, we normally attach one EBS volume to one EC2 instance.

---

# Q10. Can you detach the Root Volume?

## Answer

Yes.

But the EC2 instance must be stopped before detaching the root EBS volume.

For production servers, we perform this activity only during approved maintenance.

---

# Q11. Explain one EBS production issue you handled.

## Answer

CloudWatch generated a High Disk Utilization alert for a production EC2 instance.

First I checked CloudWatch to see whether the utilization was continuously increasing.

Then I connected to the server using SSH.

I checked the filesystem.

```bash
df -h
```

Then I identified the directory consuming the maximum space.

```bash
du -sh /var/*
```

Application logs were consuming most of the disk space.

As per our SOP, I archived the logs and removed old logs.

I verified logrotate.

Disk utilization was still high.

Then I increased the EBS volume.

I extended the filesystem.

Finally, I verified the application, monitored CloudWatch until utilization became normal, updated Jira and prepared the RCA.

---

# Q12. What EBS operations do you perform in your project?

## Answer

In my project, I regularly perform:

- Monitor disk utilization
- Take EBS snapshots
- Increase EBS volume size
- Extend filesystem
- Verify disk utilization
- Troubleshoot storage-related alerts
- Coordinate with the Application Team
- Update Jira and prepare RCA

# 💽 EBS Interview Questions - Part 02 (Advanced)

---

# Q13. What is the difference between gp2 and gp3?

## Answer

In gp3, we get 3,000 free IOPS regardless of size, whereas in gp2, IOPS depends on storage size at 3 IOPS per 1 GB.

gp3 is cheaper (around 20% lower cost) compared to gp2.

In gp3, IOPS and throughput are separate from storage size, but in gp2 they are tied together.

Overall, gp3 is more flexible and offers better performance control than gp2."

Both gp2 and gp3 are General Purpose SSD volumes.

### gp2

- Performance depends on volume size.
- As the volume size increases, IOPS also increase.

### gp3

- Better performance.
- IOPS and Throughput can be configured independently.
- Lower cost than gp2 for most workloads.

In our project, we mostly use **gp3** volumes.

---

# Q14. What is the difference between io1 and io2?

## Answer

Both are Provisioned IOPS SSD volumes.

### io1

Older generation.

### io2

Latest generation.

Provides higher durability and better performance.

Mostly used for high-performance databases like Oracle or SQL Server.

---

# Q15. Are EBS Snapshots Full or Incremental?

## Answer

The first snapshot is a full snapshot.

After that, AWS stores only the changed blocks.

This is called an Incremental Snapshot.

It helps save storage space and reduces backup time.

---

# Q16. Where are EBS Snapshots stored?

## Answer

EBS Snapshots are stored in Amazon S3.

AWS manages the storage automatically.

We cannot directly access the S3 bucket because it is managed by AWS.

---

# Q17. Can you restore an EBS Snapshot?

## Answer

Yes.

We cannot restore a snapshot directly to an existing volume.

First we create a new EBS volume from the snapshot.

Then we attach it to the EC2 instance.

If required, we mount the filesystem and verify the application.

---

# Q18. What is Delete on Termination?

## Answer

Delete on Termination is an EBS setting.

If it is enabled, the root EBS volume is deleted automatically when the EC2 instance is terminated.

If it is disabled, the EBS volume remains available even after the instance is terminated.

For production servers, we verify this setting before terminating any EC2 instance.

---

# Q19. What is EBS Encryption?

## Answer

EBS Encryption protects data stored in the EBS volume.

It encrypts:

- Data at Rest
- Snapshots
- Data transferred between the EC2 instance and the EBS volume

AWS uses AWS KMS keys for encryption.

For production workloads, we generally use encrypted EBS volumes.

---

# Q20. Can you encrypt an existing unencrypted EBS volume?

## Answer

No.

We cannot directly encrypt an existing unencrypted EBS volume.

The common approach is:

- Create a snapshot of the existing volume.
- Copy the snapshot with encryption enabled.
- Create a new encrypted EBS volume.
- Attach the new volume to the EC2 instance.

---

# Q21. What is Multi-Attach?

## Answer

Multi-Attach allows one EBS volume to be attached to multiple EC2 instances at the same time.

It is supported only for **io1** and **io2** volumes.

It is mainly used for clustered applications.

In our project, we do not use Multi-Attach.

---

# Q22. Can you decrease the size of an EBS Volume?

## Answer

No.

AWS allows only increasing the EBS volume size.

If a smaller volume is required, we create a new smaller EBS volume, copy the data and replace the old volume.

---

# Q23. What happens after increasing the EBS Volume?

## Answer

Increasing the volume size in the AWS Console only increases the storage at the AWS level.

Inside the operating system, we still need to extend the partition and filesystem.

Normally I verify:

```bash
lsblk
```

Then extend the partition if required.

```bash
growpart
```

Then extend the filesystem.

For XFS

```bash
xfs_growfs
```

For ext4

```bash
resize2fs
```

Finally I verify.

```bash
df -h
```

---

# Q24. Can you resize an EBS Volume without stopping the EC2 instance?

## Answer

Yes.

AWS supports online EBS volume expansion.

After increasing the volume size from the AWS Console, I extend the filesystem inside Linux.

In most cases, no reboot is required.

However, I always perform this activity during an approved maintenance window.

---

# Q25. What is the difference between Root Volume and Additional Volume?

## Answer

### Root Volume

- Contains the Operating System.
- Required for booting the EC2 instance.
- Usually mounted as `/`.

### Additional Volume

- Used for application data, logs or database files.
- Can be attached or detached when required.

---

# Q26. What checks do you perform before increasing an EBS Volume?

## Answer

Before increasing an EBS volume, I verify:

- CloudWatch alert history
- Whether the issue is a temporary spike
- Which filesystem is full
- Directory consuming maximum space
- Whether log cleanup is possible
- Logrotate status
- Current EBS volume size
- Required approval
- Recent snapshot availability

Only after these checks do I increase the EBS volume.

---

# Q27. What checks do you perform after increasing an EBS Volume?

## Answer

After increasing the volume, I verify:

- Volume modification completed successfully
- Operating System detects the new size

```bash
lsblk
```

- Filesystem extended successfully

```bash
df -h
```

- Application is running properly
- CloudWatch Disk Utilization returns to normal

Finally, I update the Jira ticket.

---

# Q28. What storage-related issues do you handle in production?

## Answer

Some common issues are:

- High Disk Utilization
- Filesystem Full
- Log Files Growing
- EBS Volume Extension
- Snapshot Verification
- Disk Performance Alerts
- Filesystem Resize
- Storage Monitoring through CloudWatch

---

# Q29. Explain your complete EBS troubleshooting approach.

## Answer

Whenever I receive a Disk Utilization alert, I first check CloudWatch to verify whether the issue is continuous or temporary.

Then I login to the server.

I verify the filesystem.

```bash
df -h
```

Then I identify the directory consuming more space.

```bash
du -sh /var/*
```

If log files are consuming space, I archive or remove them as per the company SOP.

I verify logrotate.

If cleanup is not enough, I increase the EBS volume.

Then I extend the filesystem.

Finally, I verify the application, monitor CloudWatch, update Jira and prepare the RCA.

---

# Q30. Explain one storage-related production issue you handled.

## Answer

CloudWatch generated a High Disk Utilization alert for a production EC2 instance.

First I checked CloudWatch to identify when the disk utilization started increasing.

Then I connected to the server using SSH.

I checked the filesystem.

```bash
df -h
```

Then I identified the directory consuming maximum space.

```bash
du -sh /var/*
```

Application logs were consuming most of the disk space.

As per our company SOP, I archived the logs and removed old logs.

I verified logrotate.

Disk utilization was still high.

Then I increased the EBS volume from the AWS Console.

After AWS completed the modification, I verified the new disk.

```bash
lsblk
```

Then I extended the filesystem.

Finally, I verified the application, monitored CloudWatch until disk utilization returned to normal, updated Jira and prepared the RCA.
