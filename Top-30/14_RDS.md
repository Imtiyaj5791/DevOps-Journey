# Amazon RDS — Top 15 Interview Questions

## 1. What is Amazon RDS?

Amazon RDS is a managed relational database service provided by AWS.

AWS manages tasks like backups, patching and database infrastructure maintenance.

---

## 2. Why do you use RDS instead of installing MySQL on EC2?

RDS is a managed service, so AWS handles activities like backups, patching and infrastructure maintenance.

It reduces our administrative work.

---

## 3. Which database engines are supported by RDS?

RDS supports:

- MySQL
- PostgreSQL
- MariaDB
- Oracle
- SQL Server
- Amazon Aurora

---

## 4. Why is RDS generally deployed in a private subnet?

We keep RDS in private subnets for security so that the database is not directly accessible from the internet.

---

## 5. How does an application running on EC2 connect to RDS?

The application connects to RDS using the RDS endpoint and database port.

The RDS Security Group should allow the required database port from the Application/EC2 Security Group.

Example:

    Application EC2 SG
            ↓
         TCP 3306
            ↓
          RDS SG

---

## 6. What is Multi-AZ in RDS?

Multi-AZ is mainly used for High Availability.

AWS maintains a standby database in another Availability Zone.

If the primary database has a problem, AWS can automatically fail over to the standby database.

**Remember:**

    Multi-AZ = High Availability + Failover

---

## 7. What is an RDS Read Replica?

Read Replica is a copy of the database mainly used to handle read traffic and reduce the read load on the primary database.

**Remember:**

    Read Replica = Read Scaling

---

## 8. What is the difference between Multi-AZ and Read Replica?

Multi-AZ is mainly used for High Availability and automatic failover.

Read Replica is mainly used to handle read traffic and improve read performance.

**Remember:**

    Multi-AZ     → HA / Failover
    Read Replica → Read Scaling

---

## 9. How do you take a backup of RDS?

RDS provides two common backup options:

1. Automated Backups
2. Manual DB Snapshots

Automated backups are managed according to the configured retention period.

We can also manually create a DB snapshot when required.

---

## 10. What is an RDS Snapshot?

An RDS snapshot is a backup of the database.

We can use the snapshot to restore the database when required.

---

## 11. What happens during RDS Multi-AZ failover?

If the primary database fails, AWS automatically switches to the standby database in another Availability Zone.

The application continues using the same RDS endpoint.

---

## 12. Your EC2 application cannot connect to RDS. What will you check?

I will check:

1. RDS instance status
2. RDS endpoint
3. Database port
4. RDS Security Group
5. EC2/Application Security Group
6. Network connectivity
7. NACL and routing if applicable
8. Database credentials
9. Application/database logs

Example for MySQL:

    Application SG
          ↓
      TCP 3306
          ↓
        RDS SG

---

## 13. How do you monitor Amazon RDS?

We can monitor Amazon RDS using CloudWatch.

Important metrics include:

- CPU Utilization
- Database Connections
- Free Storage Space
- Freeable Memory

We can also configure CloudWatch alarms based on these metrics.

---

## 14. What will you do if RDS storage is getting full?

First, I will check the storage utilization and identify why the database storage is increasing.

If required, I will increase the allocated RDS storage.

I will also coordinate with the application or database team if unexpected data growth is causing the issue.

---

## 15. How do you recover an RDS database if data is accidentally deleted?

Depending on the requirement, we can restore the database using:

- DB Snapshot
- Point-in-Time Recovery (PITR), if automated backups are enabled

Point-in-Time Recovery allows us to restore the database to a specific point within the available backup retention period.

---

# Quick Revision

    RDS
    → Managed Relational Database Service

    RDS vs EC2 Database
    → AWS manages more administrative tasks in RDS

    Private Subnet
    → Database is not directly exposed to Internet

    EC2 → RDS
    → Endpoint + DB Port + Security Group

    Multi-AZ
    → High Availability + Failover

    Read Replica
    → Read Scaling

    Multi-AZ vs Read Replica
    → HA vs Read Scaling

    Backup
    → Automated Backup + Manual Snapshot

    Snapshot
    → Backup used for restore

    PITR
    → Restore to a specific point in time

    RDS Monitoring
    → CloudWatch

    RDS Connection Issue
    → Status → Endpoint → Port → SG → Network → Credentials → Logs

---

# Most Important Interview Questions

1. Why RDS instead of MySQL on EC2?
2. Why is RDS deployed in a private subnet?
3. How does EC2 connect to RDS?
4. What is Multi-AZ?
5. What is Read Replica?
6. Multi-AZ vs Read Replica?
7. What happens during Multi-AZ failover?
8. How will you troubleshoot EC2 to RDS connectivity?
9. How do you recover accidentally deleted RDS data?
