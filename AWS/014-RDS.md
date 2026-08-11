# RDS Interview Questions

## What is Amazon RDS?

Answer:
Amazon RDS is an AWS managed service used to set up, operate and manage relational databases.

AWS manages:
- Database provisioning
- Patching
- Backup
- Maintenance

We manage:
- Database configuration
- Users
- Permissions
- Application connectivity


## Why do we use RDS when we can install database on EC2?

Answer:
If we install database on EC2, we have to manage OS, database installation, patching, backup and high availability manually.

With RDS, AWS manages the underlying infrastructure and database maintenance, which reduces operational overhead.


## How application connects with RDS?

Answer:
Application usually runs on EC2 and connects with RDS using the RDS endpoint.

Example:

EC2 (Application)
        |
        |
RDS (Database)

We allow EC2 Security Group in RDS Security Group on database port.


## What is Multi-AZ in RDS?

Answer:
Multi-AZ is used for high availability and automatic failover.

AWS maintains a standby database in another Availability Zone.

If primary fails, AWS automatically fails over to standby and application continues using the same RDS endpoint.


## Difference between Multi-AZ and Read Replica?

Answer:

Multi-AZ:
- Used for High Availability
- Automatic failover
- Synchronous replication

Read Replica:
- Used for Read Scaling
- Handles read traffic
- Asynchronous replication


## What is RDS Automated Backup?

Answer:
Automated Backup is used for Point-In-Time Recovery.

If data is deleted accidentally, we can restore the database to a specific time before the issue occurred.


## What is RDS Snapshot?

Answer:
Snapshot is a manual backup copy of an RDS database.

We use snapshots:
- Before major changes
- Database migration
- Testing environment
- Long-term retention


## Difference between Automated Backup and Snapshot?

Answer:

Automated Backup:
- Created automatically by AWS
- Used for Point-In-Time Recovery
- Limited retention

Snapshot:
- Created manually
- Used for fixed backup copy
- Retained until deleted


## Application EC2 is not able to connect with RDS. How will you troubleshoot?

Answer:

First I will check RDS instance status.

Then I will verify Security Group rules and confirm EC2 Security Group is allowed in RDS Security Group on required database port.

After that I will test connectivity from EC2 server.

Command:

nc -zv <RDS-endpoint> 3306

If connectivity is fine, I will check database credentials and application configuration.
