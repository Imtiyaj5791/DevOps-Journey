# 🚀 NovaCart – AWS 3-Tier Architecture with Cross-Region Disaster Recovery

## Project Overview

After revising AWS core services, I built this end-to-end hands-on project to connect multiple AWS services in a complete architecture.

In this project, I deployed a **3-Tier Web Application called NovaCart** in the **Mumbai Region (ap-south-1)** and then implemented a **Cross-Region Backup & Restore Disaster Recovery solution in Singapore (ap-southeast-1)**.

The project covered:

- Custom VPC networking
- Public, Private App, and Private DB subnets
- Multi-AZ subnet design
- Internet Gateway
- NAT Gateway
- Route Tables
- Security Groups
- Application Load Balancer
- Target Groups
- Auto Scaling Group
- Launch Template
- Private EC2 application servers
- Amazon RDS MySQL
- Route 53 custom domain
- ACM HTTPS certificate
- HTTP to HTTPS redirect
- AWS Systems Manager Session Manager
- Cross-Region RDS Snapshot
- Database restore in DR Region
- Route 53 Primary/Secondary Failover
- Actual DR failover testing
- Complete AWS resource cleanup

---

# 1. Complete CIDR Plan

I used a simple CIDR pattern so the same architecture can easily be recreated in the future.

## Mumbai Primary Region – ap-south-1

```text
VPC Name: prod-mumbai-vpc
VPC CIDR: 10.0.0.0/16
```

### Public Subnets

```text
Public Subnet 1
CIDR: 10.0.1.0/24
AZ: ap-south-1a

Public Subnet 2
CIDR: 10.0.2.0/24
AZ: ap-south-1b
```

Used for:

```text
Application Load Balancer
NAT Gateway
```

### Private Application Subnets

```text
Private App Subnet 1
CIDR: 10.0.11.0/24
AZ: ap-south-1a

Private App Subnet 2
CIDR: 10.0.12.0/24
AZ: ap-south-1b
```

Used for:

```text
EC2 Application Servers
Auto Scaling Group
```

### Private Database Subnets

```text
Private DB Subnet 1
CIDR: 10.0.21.0/24
AZ: ap-south-1a

Private DB Subnet 2
CIDR: 10.0.22.0/24
AZ: ap-south-1b
```

Used for:

```text
Amazon RDS MySQL
RDS DB Subnet Group
```

### Mumbai CIDR Summary

| Layer | Availability Zone | CIDR |
|---|---|---|
| VPC | Mumbai | `10.0.0.0/16` |
| Public Subnet 1 | ap-south-1a | `10.0.1.0/24` |
| Public Subnet 2 | ap-south-1b | `10.0.2.0/24` |
| Private App Subnet 1 | ap-south-1a | `10.0.11.0/24` |
| Private App Subnet 2 | ap-south-1b | `10.0.12.0/24` |
| Private DB Subnet 1 | ap-south-1a | `10.0.21.0/24` |
| Private DB Subnet 2 | ap-south-1b | `10.0.22.0/24` |

---

## Singapore DR Region – ap-southeast-1

```text
VPC Name: prod-dr-vpc
VPC CIDR: 10.1.0.0/16
```

### Public Subnets

```text
Public Subnet 1
CIDR: 10.1.1.0/24
AZ: ap-southeast-1a

Public Subnet 2
CIDR: 10.1.2.0/24
AZ: ap-southeast-1b
```

Used for:

```text
DR Application Load Balancer
DR NAT Gateway
```

### Private Application Subnets

```text
Private App Subnet 1
CIDR: 10.1.11.0/24
AZ: ap-southeast-1a

Private App Subnet 2
CIDR: 10.1.12.0/24
AZ: ap-southeast-1b
```

Used for:

```text
DR EC2 Application Servers
DR Auto Scaling Group
```

### Private Database Subnets

```text
Private DB Subnet 1
CIDR: 10.1.21.0/24
AZ: ap-southeast-1a

Private DB Subnet 2
CIDR: 10.1.22.0/24
AZ: ap-southeast-1b
```

Used for:

```text
Restored Amazon RDS MySQL
DR DB Subnet Group
```

### Singapore CIDR Summary

| Layer | Availability Zone | CIDR |
|---|---|---|
| VPC | Singapore | `10.1.0.0/16` |
| Public Subnet 1 | ap-southeast-1a | `10.1.1.0/24` |
| Public Subnet 2 | ap-southeast-1b | `10.1.2.0/24` |
| Private App Subnet 1 | ap-southeast-1a | `10.1.11.0/24` |
| Private App Subnet 2 | ap-southeast-1b | `10.1.12.0/24` |
| Private DB Subnet 1 | ap-southeast-1a | `10.1.21.0/24` |
| Private DB Subnet 2 | ap-southeast-1b | `10.1.22.0/24` |

---

## Easy CIDR Pattern to Remember

```text
                    Mumbai              Singapore
                    ------              ---------

VPC                 10.0.0.0/16         10.1.0.0/16

Public 1            10.0.1.0/24         10.1.1.0/24
Public 2            10.0.2.0/24         10.1.2.0/24

Private App 1       10.0.11.0/24        10.1.11.0/24
Private App 2       10.0.12.0/24        10.1.12.0/24

Private DB 1        10.0.21.0/24        10.1.21.0/24
Private DB 2        10.0.22.0/24        10.1.22.0/24
```

### Memory Trick

```text
1, 2    = Public
11, 12  = Private App
21, 22  = Private DB
```

Region identification:

```text
10.0.x.x = Mumbai
10.1.x.x = Singapore
```

---

# 2. Architecture Overview

## Mumbai Primary Environment

```text
                    Internet
                       |
                       v
                   Route 53
          novacart.devopsclasses.space
                       |
                       v
              Internet Gateway
                       |
                       v
          Application Load Balancer
              Public Subnets
                 2 AZs
                       |
                       v
                 Target Group
                       |
                       v
              Auto Scaling Group
                       |
             +---------+---------+
             |                   |
             v                   v
         App EC2-1           App EC2-2
              Private App Subnets
                       |
                       v
                Amazon RDS MySQL
              Private DB Subnets
```

## Singapore DR Environment

```text
                   Route 53
               Secondary Record
                       |
                       v
                 Singapore ALB
                       |
                       v
                  Target Group
                       |
                       v
              Auto Scaling Group
                       |
                       v
               Private App EC2
                       |
                       v
             Restored RDS MySQL
```

Database recovery:

```text
Mumbai RDS
    |
    v
Manual RDS Snapshot
    |
    v
Cross-Region Snapshot Copy
    |
    v
Singapore Snapshot
    |
    v
Restore RDS in Singapore
```

---

# 3. Mumbai VPC Creation

I created a custom VPC:

```text
Name: prod-mumbai-vpc
CIDR: 10.0.0.0/16
Region: ap-south-1
```

The architecture was divided into:

```text
Public Layer
Private Application Layer
Private Database Layer
```

Two Availability Zones were used to improve availability.

---

# 4. Internet Gateway

An Internet Gateway was created and attached to:

```text
prod-mumbai-vpc
```

The Internet Gateway provides internet connectivity to resources using the public route table.

---

# 5. Public Route Table

A Public Route Table was created.

Route:

```text
Destination: 0.0.0.0/0
Target: Internet Gateway
```

Associated subnets:

```text
10.0.1.0/24
10.0.2.0/24
```

Used by:

```text
Application Load Balancer
NAT Gateway
```

---

# 6. NAT Gateway

A NAT Gateway was created inside a public subnet.

An Elastic IP was associated with the NAT Gateway.

Purpose:

```text
Private EC2
     |
     v
Private App Route Table
     |
     v
NAT Gateway
     |
     v
Internet Gateway
     |
     v
Internet
```

This allowed private EC2 application servers to initiate outbound internet connections without exposing them directly to the internet.

---

# 7. Private Application Route Table

A separate route table was created for the application subnets.

Associated subnets:

```text
10.0.11.0/24
10.0.12.0/24
```

Route:

```text
0.0.0.0/0 -> NAT Gateway
```

---

# 8. Private Database Route Table

A separate route table was created for the database subnets.

Associated subnets:

```text
10.0.21.0/24
10.0.22.0/24
```

The database did not require direct internet connectivity.

Application-to-database communication used VPC local routing.

---

# 9. Security Group Design

I implemented Security Group chaining between the three application tiers.

## ALB Security Group

Allowed:

```text
HTTP  : 80  -> Internet
HTTPS : 443 -> Internet
```

## Application Security Group

Allowed:

```text
HTTP : 80
Source: ALB Security Group
```

## Database Security Group

Allowed:

```text
MySQL : 3306
Source: Application Security Group
```

Final flow:

```text
Internet
   |
   v
ALB SG
   |
   v
App SG
   |
   v
DB SG
```

This ensured that the database was not directly accessible from the internet.

---

# 10. RDS DB Subnet Group

A DB Subnet Group was created using:

```text
10.0.21.0/24
10.0.22.0/24
```

These subnets were located in different Availability Zones.

Amazon RDS was deployed using this DB Subnet Group.

---

# 11. Amazon RDS MySQL

Amazon RDS MySQL was deployed inside the private database layer.

The database was not publicly accessible.

Application database:

```text
Database: shopdb
Table: products
```

Database validation:

```sql
USE shopdb;

SHOW TABLES;

SELECT * FROM products;
```

I also inserted a test record directly into RDS:

```text
Product: AWS Cloud Lab
Description: Added directly into Amazon RDS for testing.
Price: 999
```

After refreshing NovaCart, the new product appeared on the website.

This confirmed:

```text
Browser
   |
   v
ALB
   |
   v
Application EC2
   |
   v
Amazon RDS
```

and validated database connectivity and persistence.

---

# 12. Launch Template

A Launch Template was created for application EC2 instances.

It contained:

- Ubuntu AMI
- Instance type
- Application Security Group
- IAM instance profile
- User Data
- Required EC2 configuration

The application stack included:

```text
Nginx
Python
Flask
Gunicorn
PyMySQL
```

User Data automatically configured the application when new EC2 instances were launched.

---

# 13. Auto Scaling Group

An Auto Scaling Group was created using the Launch Template.

During testing:

```text
Desired Capacity: 2
Healthy Instances: 2
```

The ASG was connected to the Target Group.

Flow:

```text
Launch Template
      |
      v
Auto Scaling Group
      |
      v
EC2 Instances
      |
      v
Target Group
```

---

# 14. Target Group

The Target Group configuration used:

```text
Target Type: Instance
Protocol: HTTP
Port: 80
Health Check Path: /health
```

During validation:

```text
Total Targets: 2
Healthy: 2
Unhealthy: 0
```

The Auto Scaling Group automatically registered the EC2 instances with the Target Group.

---

# 15. Application Load Balancer

An internet-facing Application Load Balancer was deployed across both public subnets.

```text
Public Subnet 1 -> 10.0.1.0/24
Public Subnet 2 -> 10.0.2.0/24
```

Traffic flow:

```text
User
 |
 v
ALB
 |
 v
Target Group
 |
 v
Private EC2
```

The EC2 application servers therefore did not require direct public exposure.

---

# 16. Route 53 Custom Domain

The application was configured with:

```text
novacart.devopsclasses.space
```

Initially, an Alias A record pointed the domain to the Mumbai ALB.

```text
novacart.devopsclasses.space
            |
            v
         Route 53
            |
            v
        Mumbai ALB
```

---

# 17. HTTPS with AWS Certificate Manager

An SSL/TLS certificate was issued using AWS Certificate Manager.

The ALB HTTPS listener used the ACM certificate.

Listener configuration:

```text
HTTP : 80
   |
   | HTTP 301
   v
HTTPS : 443
   |
   v
Target Group
```

This ensured users accessing HTTP were automatically redirected to HTTPS.

---

# 18. Accessing Private EC2 with SSM

Because the EC2 instances were in private subnets, I used AWS Systems Manager Session Manager instead of exposing SSH directly.

The EC2 IAM role had the required Systems Manager permissions.

Connectivity flow:

```text
Private EC2
     |
     v
NAT Gateway
     |
     v
AWS Systems Manager
```

This allowed administrative access without requiring a public IP.

---

# 19. Primary Application Validation

The application was successfully accessible using:

```text
https://novacart.devopsclasses.space
```

Validation included:

```text
Application Healthy
Products loaded from RDS
HTTPS working
ALB working
2 EC2 targets healthy
Database connectivity working
```

---

# 20. Database Validation Before DR

Before creating the DR backup, I checked:

```sql
SELECT * FROM products;
```

The database contained 9 rows.

The test record included:

```text
AWS Cloud Lab
Added directly into Amazon RDS for testing.
999
```

This record was later used to validate DR database recovery.

---

# 21. Disaster Recovery Strategy

For this project, I implemented a:

```text
Backup & Restore DR Strategy
```

Primary:

```text
Mumbai
ap-south-1
10.0.0.0/16
```

DR:

```text
Singapore
ap-southeast-1
10.1.0.0/16
```

Database recovery:

```text
Mumbai RDS
     |
     v
RDS Snapshot
     |
     v
Cross-Region Copy
     |
     v
Singapore Snapshot
     |
     v
Restore Singapore RDS
```

---

# 22. RDS Snapshot Creation

A manual snapshot was created from the Mumbai RDS database.

I waited until its status became:

```text
Available
```

before copying it to another Region.

---

# 23. Cross-Region Snapshot Copy

The snapshot was copied:

```text
Source:
Mumbai (ap-south-1)

Destination:
Singapore (ap-southeast-1)
```

After the copy completed, the snapshot became available in Singapore.

---

# 24. Singapore DR VPC

A separate VPC was created:

```text
Name: prod-dr-vpc
CIDR: 10.1.0.0/16
Region: ap-southeast-1
```

Subnet design:

```text
Public:
10.1.1.0/24
10.1.2.0/24

Private App:
10.1.11.0/24
10.1.12.0/24

Private DB:
10.1.21.0/24
10.1.22.0/24
```

---

# 25. Singapore Internet Gateway

A separate Internet Gateway was created and attached to:

```text
prod-dr-vpc
```

---

# 26. Singapore Public Route Table

The DR public route table contained:

```text
0.0.0.0/0 -> DR Internet Gateway
```

Associated subnets:

```text
10.1.1.0/24
10.1.2.0/24
```

---

# 27. Singapore NAT Gateway

A NAT Gateway was created in a Singapore public subnet.

Purpose:

```text
DR Private EC2
      |
      v
DR Private App RT
      |
      v
DR NAT Gateway
      |
      v
DR Internet Gateway
```

---

# 28. Singapore Private App Route Table

Associated subnets:

```text
10.1.11.0/24
10.1.12.0/24
```

Route:

```text
0.0.0.0/0 -> DR NAT Gateway
```

---

# 29. Singapore DB Route Table

Associated DB subnets:

```text
10.1.21.0/24
10.1.22.0/24
```

The database remained private.

No direct internet route was required for normal application-to-RDS connectivity.

---

# 30. Singapore Security Groups

The same three-tier security design was recreated.

## DR ALB SG

```text
HTTP 80   -> Internet
HTTPS 443 -> Internet
```

## DR Application SG

```text
HTTP 80
Source: DR ALB SG
```

## DR Database SG

```text
MySQL 3306
Source: DR App SG
```

Flow:

```text
Internet
   |
   v
DR ALB SG
   |
   v
DR App SG
   |
   v
DR DB SG
```

---

# 31. Singapore DB Subnet Group

The DR DB Subnet Group used:

```text
10.1.21.0/24
10.1.22.0/24
```

This allowed the restored RDS database to remain inside the private DB layer.

---

# 32. Restoring RDS in Singapore

The copied snapshot was restored as a new RDS MySQL instance.

The restored RDS received a new Singapore endpoint.

Example:

```text
prod-dr-mysql-db.<identifier>.ap-southeast-1.rds.amazonaws.com
```

Important:

```text
Mumbai RDS Endpoint != Singapore RDS Endpoint
```

Therefore, the DR application configuration had to use the Singapore RDS endpoint.

---

# 33. Singapore Target Group

A separate Target Group was created.

```text
Target Type: Instance
Protocol: HTTP
Port: 80
Health Check: /health
```

Instances were registered automatically through the DR Auto Scaling Group.

---

# 34. Singapore Application Load Balancer

A DR Application Load Balancer was created across:

```text
10.1.1.0/24
10.1.2.0/24
```

Flow:

```text
DR ALB
   |
   v
DR Target Group
   |
   v
DR Application EC2
```

---

# 35. Singapore Launch Template

A separate Launch Template was created for the DR application.

The application configuration was similar to Mumbai.

The main database change was:

```text
DB_HOST = Singapore Restored RDS Endpoint
```

User Data automatically configured NovaCart on the DR EC2 instances.

---

# 36. Singapore Auto Scaling Group

The DR ASG used:

```text
DR Launch Template
        +
Private App Subnets
10.1.11.0/24
10.1.12.0/24
        +
DR Target Group
```

The DR Target Group eventually showed:

```text
2 Healthy Targets
```

This confirmed that the DR application layer was working.

---

# 37. DR Application Validation

Before configuring Route 53 failover, the Singapore ALB was tested directly.

NovaCart successfully opened.

The application also successfully connected to the restored RDS database.

The previously inserted:

```text
AWS Cloud Lab
```

product was available, confirming successful database recovery.

---

# 38. HTTPS in Singapore

Because ACM certificates used with an ALB are regional, HTTPS was configured for the Singapore ALB as well.

Listeners:

```text
HTTP : 80
   |
   | HTTP 301 Redirect
   v
HTTPS : 443
   |
   v
DR Target Group
```

When accessing the AWS ALB DNS directly using HTTPS, the browser could display a certificate hostname warning.

Reason:

```text
Certificate:
*.devopsclasses.space

Direct URL:
*.elb.amazonaws.com
```

The certificate was created for the custom domain, not the AWS ALB hostname.

Final HTTPS testing was therefore performed through:

```text
https://novacart.devopsclasses.space
```

---

# 39. Route 53 Failover Configuration

The original Simple routing record was changed to Failover routing.

Two Alias A records were configured for the same application hostname.

## Mumbai Primary

```text
Record:
novacart.devopsclasses.space

Type:
A - Alias

Routing Policy:
Failover

Failover Record Type:
Primary

Target:
Mumbai ALB

Evaluate Target Health:
Yes

Record ID:
Mumbai-Primary
```

## Singapore Secondary

```text
Record:
novacart.devopsclasses.space

Type:
A - Alias

Routing Policy:
Failover

Failover Record Type:
Secondary

Target:
Singapore DR ALB

Evaluate Target Health:
Yes

Record ID:
Singapore-Secondary
```

Architecture:

```text
                   Route 53
                      |
          novacart.devopsclasses.space
                      |
                  Failover
                 /        \
                /          \
           PRIMARY       SECONDARY
              |              |
              v              v
         Mumbai ALB     Singapore ALB
```

No separate Route 53 Health Check resource was required for this lab because the Alias records used:

```text
Evaluate Target Health = Yes
```

to evaluate the health of the ALB target.

---

# 40. DR Failover Test

Before failure:

```text
User
 |
 v
Route 53
 |
 v
Mumbai Primary
 |
 v
Mumbai ALB
 |
 v
Mumbai EC2
 |
 v
Mumbai RDS
```

To simulate failure, I brought down the Mumbai application capacity.

The Mumbai Target Group no longer had healthy application targets.

During the transition, the application temporarily returned:

```text
503 Service Unavailable
```

because the Mumbai ALB was still reachable but did not have healthy application targets.

After Route 53 evaluated the Primary as unhealthy, traffic failed over to Singapore.

---

# 41. DR Failover Validation

After failover, I opened the same domain:

```text
https://novacart.devopsclasses.space
```

NovaCart successfully opened.

The application displayed:

```text
Application Server: ip-10-1-12-179
Database: Connected to Amazon RDS ✓
```

The IP pattern was important:

```text
10.0.x.x = Mumbai
10.1.x.x = Singapore
```

Therefore:

```text
ip-10-1-12-179
```

proved that the application was now being served from the Singapore DR environment.

At the same time:

```text
Database: Connected to Amazon RDS ✓
```

confirmed that the Singapore application was connected to the restored RDS database.

---

# 42. Complete Failover Flow

```text
                    USER
                      |
                      v
                  Route 53
                      |
               Failover Routing
                 /          \
                /            \
         Mumbai Primary    Singapore Secondary
                |                  |
                X                  v
           UNHEALTHY            DR ALB
                                   |
                                   v
                              DR Target Group
                                   |
                                   v
                              DR ASG / EC2
                                   |
                                   v
                           Restored Singapore RDS
                                   |
                                   v
                              NovaCart LIVE
```

Final proof:

```text
Same Domain:
novacart.devopsclasses.space

Application Server:
ip-10-1-12-179

Database:
Connected to Amazon RDS ✓
```

---

# 43. High Availability vs Disaster Recovery

## High Availability

High Availability protects against instance or Availability Zone failures inside the same AWS Region.

Example:

```text
Mumbai Region
     |
     +---- AZ-1
     |       |
     |      EC2
     |
     +---- AZ-2
             |
            EC2

        ALB + ASG
```

## Disaster Recovery

Disaster Recovery provides recovery when a larger failure affects the primary environment or Region.

```text
Mumbai Primary
      |
      X
   Failure
      |
      v
Singapore DR
```

---

# 44. DR Strategy Used

The database DR strategy practiced in this project was:

```text
Backup & Restore
```

Process:

```text
Primary RDS
     |
     v
Snapshot
     |
     v
Cross-Region Copy
     |
     v
Restore in DR Region
```

This approach is relatively cost effective but normally has a higher recovery time compared with strategies where infrastructure and data are continuously running in the DR Region.

---

# 45. RPO Understanding

RPO means:

```text
Recovery Point Objective
```

It defines the maximum acceptable amount of data loss measured in time.

Example:

```text
Snapshot: 10:00 AM
Disaster: 10:30 AM
```

If the latest usable recovery point is the 10:00 AM snapshot:

```text
Possible Data Loss = 30 minutes
```

Therefore, snapshot frequency must be designed according to the business RPO requirement.

For very low RPO requirements, occasional manual snapshots alone are not sufficient and a more continuous replication approach may be required.

---

# 46. RTO Understanding

RTO means:

```text
Recovery Time Objective
```

It defines how quickly the application must be restored after a disaster.

Example:

```text
RTO = 2 Hours
```

means:

```text
The application should be restored within 2 hours of the disaster.
```

Backup & Restore generally has a higher RTO because infrastructure and databases may need to be restored or recreated.

---

# 47. DR Strategies – Quick Comparison

## Backup & Restore

```text
DR Region:
Mainly backups/snapshots

After Disaster:
Restore DB
Build/restore infrastructure
Start application
```

```text
Cost: Low
RTO: High
```

---

## Pilot Light

```text
DR Region:
Critical core/data components remain ready

After Disaster:
Start remaining application infrastructure
Scale resources
```

```text
Cost: Higher than Backup & Restore
RTO: Lower than Backup & Restore
```

---

## Warm Standby

A complete environment is already running in the DR Region but at smaller capacity.

Example:

```text
Primary:
Larger application capacity

DR:
Smaller running application capacity
```

During disaster:

```text
Scale DR Environment
        |
        v
Handle Production Traffic
```

```text
Cost: Higher
RTO: Low
```

---

## Active-Active

Both Regions actively serve production traffic.

```text
             Route 53
              /    \
             /      \
         Mumbai    Singapore
           |           |
         Active      Active
```

```text
Cost: Highest
RTO: Very Low
Complexity: Highest
```

---

# 48. Troubleshooting Performed

## SSM Instance Not Appearing

Checked:

```text
IAM Instance Profile
AmazonSSMManagedInstanceCore
NAT Gateway
Private Route Table
SSM Agent
```

After the required IAM permissions and outbound connectivity were available, the private instances appeared in Systems Manager.

---

## Temporary 503 During Failover

During the DR test:

```text
503 Service Unavailable
```

was temporarily observed.

Singapore Target Group was checked:

```text
2 Healthy Targets
```

DNS was also checked:

```cmd
nslookup novacart.devopsclasses.space
```

After Route 53 completed failover evaluation, the application started serving from Singapore.

---

## HTTPS Direct ALB DNS Warning

Directly accessing:

```text
https://<ALB-DNS>.elb.amazonaws.com
```

could show:

```text
Not Secure
```

because the ACM certificate was issued for:

```text
devopsclasses.space
*.devopsclasses.space
```

and not for:

```text
*.elb.amazonaws.com
```

Using the custom domain resolved the hostname matching requirement.

---

# 49. Cleanup

After completing the DR test, I deleted the lab resources to avoid unnecessary AWS charges.

Resources cleaned included:

```text
Auto Scaling Groups
Application Load Balancers
Target Groups
NAT Gateways
Elastic IPs
RDS Instances
Manual DR Snapshots
Launch Templates
Security Groups
DB Subnet Groups
Route Tables
Subnets
Internet Gateways
VPC Resources
```

During VPC deletion, an ENI was found:

```text
Description:
RDSNetworkInterface

Requester:
amazon-rds

Requester-managed:
True
```

Because the interface was RDS-managed, it was not manually deleted.

After the dependent RDS cleanup completed, the managed network interface was removed and the remaining VPC cleanup was completed.

---

# 50. AWS Services Used

| AWS Service | Purpose |
|---|---|
| Amazon VPC | Network isolation and multi-tier architecture |
| Amazon EC2 | Application servers |
| Application Load Balancer | Distribute application traffic |
| Target Group | Manage healthy application targets |
| Auto Scaling Group | Maintain application capacity |
| Launch Template | Standard EC2 configuration |
| Amazon RDS MySQL | Database layer |
| Amazon Route 53 | DNS and DR failover |
| AWS Certificate Manager | SSL/TLS certificates |
| AWS Systems Manager | Private EC2 access |
| IAM | Instance permissions |
| NAT Gateway | Outbound access from private App subnets |
| Elastic IP | NAT Gateway public IP |
| Internet Gateway | Public internet connectivity |
| Security Groups | Tier-based traffic control |

---

# 51. What I Successfully Validated

- Custom VPC architecture
- Public and private subnet design
- Two Availability Zones
- Internet Gateway
- NAT Gateway
- Public Route Table
- Private App Route Table
- Private DB Route Table
- Security Group chaining
- Private application EC2 instances
- Private Amazon RDS
- DB Subnet Group
- Launch Template
- Auto Scaling Group
- Target Group health checks
- Application Load Balancer
- Nginx
- Flask
- Gunicorn
- PyMySQL
- Application-to-RDS connectivity
- RDS data persistence
- Route 53 custom domain
- ACM HTTPS
- HTTP to HTTPS redirect
- SSM Session Manager
- RDS manual snapshot
- Cross-Region snapshot copy
- RDS restore in another Region
- Complete Singapore DR networking
- Singapore application deployment
- Route 53 Primary/Secondary Failover
- Actual primary application failure simulation
- Successful Singapore DR recovery
- Final AWS resource cleanup

---

# 52. Interview Explanation – Tell Me About This Project

I built a 3-tier web application architecture on AWS.

The primary environment was deployed in the Mumbai Region. I created a custom VPC with public, private application, and private database subnets across two Availability Zones.

The Application Load Balancer was deployed in public subnets, while EC2 application servers were launched in private subnets using an Auto Scaling Group and Launch Template.

Amazon RDS MySQL was deployed in private database subnets.

I configured Security Groups so that application servers accepted traffic only from the ALB Security Group, and RDS accepted MySQL traffic only from the application Security Group.

For outbound connectivity from private application servers, I configured a NAT Gateway.

I configured Route 53 with a custom domain and used AWS Certificate Manager for HTTPS. HTTP traffic was redirected to HTTPS.

For administration of private EC2 instances, I used AWS Systems Manager Session Manager.

I also validated application-to-database connectivity by inserting data directly into RDS and confirming that the same data appeared in the application.

For Disaster Recovery, I created an RDS snapshot in Mumbai, copied it to Singapore, and restored a new RDS database from that snapshot.

I then created the DR VPC, networking, ALB, Target Group, Launch Template and Auto Scaling Group in Singapore and connected the DR application to the restored RDS database.

Finally, I configured Route 53 Primary/Secondary Failover routing.

I simulated a Mumbai application failure by bringing down the primary application capacity.

Route 53 evaluated the Primary ALB target health and failed traffic over to Singapore.

The same application domain successfully opened from Singapore, and the application displayed a `10.1.x.x` server address and confirmed connectivity to the restored Amazon RDS database.

---

# 53. Interview Questions & Answers

## Q1. Why did you keep EC2 instances in private subnets?

For security.

Users should not directly access application EC2 instances from the internet.

Traffic enters through the public Application Load Balancer and is forwarded to the private application servers.

---

## Q2. How do private EC2 instances access the internet?

Through a NAT Gateway.

```text
Private EC2
   |
   v
NAT Gateway
   |
   v
Internet Gateway
   |
   v
Internet
```

---

## Q3. Why is the NAT Gateway in a public subnet?

Because the NAT Gateway requires internet connectivity through the Internet Gateway.

The public subnet has:

```text
0.0.0.0/0 -> Internet Gateway
```

---

## Q4. How did you access the private EC2 instances?

I used AWS Systems Manager Session Manager.

This allowed me to access the instances without assigning public IP addresses or exposing SSH directly to the internet.

---

## Q5. How did you secure RDS?

RDS was deployed in private DB subnets.

The RDS Security Group allowed:

```text
TCP 3306
Source: Application Security Group
```

Therefore, only the application servers could connect to MySQL.

---

## Q6. How did the application connect to RDS?

The application used the RDS endpoint along with the database credentials and database name.

Network connectivity was controlled using Security Groups.

---

## Q7. What is the purpose of a DB Subnet Group?

A DB Subnet Group tells RDS which subnets it can use.

I created the DB Subnet Group using private DB subnets in two Availability Zones.

---

## Q8. Why did you use two Availability Zones?

To improve availability.

If one Availability Zone has a problem, resources in another Availability Zone can continue serving the application depending on the service configuration.

---

## Q9. What was the purpose of the Target Group?

The Target Group contained the backend application EC2 instances.

The ALB forwarded requests only to healthy targets.

---

## Q10. What health check did you configure?

```text
/health
```

The ALB Target Group periodically checked this endpoint to determine whether the application instance was healthy.

---

## Q11. How did EC2 instances automatically register with the Target Group?

The Target Group was attached to the Auto Scaling Group.

When ASG launched an EC2 instance, it automatically registered it with the Target Group.

---

## Q12. Why did you use Auto Scaling?

Auto Scaling maintains the desired number of application instances and can replace unhealthy instances.

---

## Q13. Why did you use a Launch Template?

The Launch Template provided a reusable EC2 configuration.

It included:

```text
AMI
Instance Type
Security Group
IAM Role
User Data
```

---

## Q14. How did you configure HTTPS?

I requested an ACM certificate for the custom domain and attached it to the ALB HTTPS 443 listener.

Port 80 was configured to redirect to HTTPS 443.

---

## Q15. Why did direct ALB HTTPS show Not Secure?

Because the ACM certificate was issued for my custom domain.

The ALB DNS uses an `elb.amazonaws.com` hostname, which does not match my certificate hostname.

---

## Q16. What DR strategy did you implement?

I practiced a Backup & Restore strategy.

I created an RDS snapshot in Mumbai, copied it to Singapore, and restored the database there.

---

## Q17. Why did you copy the snapshot to another Region?

Because if the primary Region has a major failure, having the backup in another Region provides a separate recovery location.

---

## Q18. Did the restored RDS use the same endpoint?

No.

The Singapore restored RDS received a new endpoint.

Therefore, the Singapore application configuration used the new DR RDS endpoint.

---

## Q19. How did you verify the restored database?

Before creating the snapshot, I inserted a test record:

```text
AWS Cloud Lab
```

After restoring RDS in Singapore, the same data was available through the DR application.

---

## Q20. How did you configure DNS failover?

I created two Route 53 Failover Alias records.

```text
Primary   -> Mumbai ALB
Secondary -> Singapore ALB
```

Both used the same application hostname.

---

## Q21. Did you create a separate Route 53 Health Check?

No.

For this ALB Alias failover lab, I enabled:

```text
Evaluate Target Health = Yes
```

so Route 53 could use the health of the Alias target for routing decisions.

---

## Q22. How did you simulate the disaster?

I brought down the Mumbai application capacity so the primary application no longer had healthy backend targets.

---

## Q23. What happened after the Mumbai application failed?

Route 53 evaluated the Primary as unhealthy and returned the Singapore Secondary environment.

The same domain then served the application from Singapore.

---

## Q24. How did you confirm traffic was coming from Singapore?

The application displayed:

```text
Application Server: ip-10-1-12-179
```

The Singapore VPC used:

```text
10.1.0.0/16
```

so the `10.1.x.x` address confirmed that the request was being served by the Singapore application server.

---

## Q25. How did you confirm the DR database was connected?

The application displayed:

```text
Database: Connected to Amazon RDS ✓
```

and the recovered product data was available.

---

## Q26. What is the limitation of snapshot-based DR?

A snapshot contains data only up to its recovery point.

Changes made after that point may be lost during recovery.

Therefore, snapshot frequency must be selected according to the required RPO.

---

## Q27. What is RPO?

RPO is Recovery Point Objective.

It defines the maximum acceptable data loss measured in time.

Example:

```text
RPO = 30 minutes
```

means the business can tolerate a maximum of approximately 30 minutes of data loss.

---

## Q28. What is RTO?

RTO is Recovery Time Objective.

It defines how quickly the application should be restored after a disaster.

Example:

```text
RTO = 2 hours
```

means the application should be restored within 2 hours.

---

## Q29. What is the difference between High Availability and Disaster Recovery?

High Availability mainly protects against failures inside the same Region using multiple Availability Zones, ALB and Auto Scaling.

Disaster Recovery provides recovery from a larger failure by using another Region.

---

## Q30. What is the difference between Backup & Restore and Warm Standby?

Backup & Restore mainly keeps backups in the DR Region and restores/builds resources when recovery is required.

Warm Standby already has a smaller but complete working environment running in the DR Region.

Therefore:

```text
Backup & Restore:
Lower Cost
Higher RTO

Warm Standby:
Higher Cost
Lower RTO
```

---

# 54. Quick Rebuild Reference

If I need to rebuild this project in the future, I can use this CIDR pattern directly:

```text
===============================
MUMBAI - PRIMARY
===============================

VPC
10.0.0.0/16

PUBLIC
10.0.1.0/24
10.0.2.0/24

PRIVATE APP
10.0.11.0/24
10.0.12.0/24

PRIVATE DB
10.0.21.0/24
10.0.22.0/24


===============================
SINGAPORE - DR
===============================

VPC
10.1.0.0/16

PUBLIC
10.1.1.0/24
10.1.2.0/24

PRIVATE APP
10.1.11.0/24
10.1.12.0/24

PRIVATE DB
10.1.21.0/24
10.1.22.0/24


===============================
MEMORY
===============================

1,2     = PUBLIC
11,12   = APP
21,22   = DB

10.0 = Mumbai
10.1 = Singapore
```

---

# Final Result

Successfully built and tested:

```text
AWS 3-Tier Web Application
          +
Custom VPC
          +
6 Subnets / Region
          +
Public ALB
          +
Private EC2
          +
Auto Scaling
          +
Private RDS MySQL
          +
Route 53 Custom Domain
          +
ACM HTTPS
          +
SSM Private Access
          +
Cross-Region RDS Snapshot
          +
Singapore DR Environment
          +
Route 53 Failover
          +
Actual DR Simulation
          +
Successful Recovery
```

```text
Primary Region:
Mumbai (ap-south-1)

Primary VPC:
10.0.0.0/16

DR Region:
Singapore (ap-southeast-1)

DR VPC:
10.1.0.0/16

Application:
NovaCart

DR Strategy Practiced:
Backup & Restore

Route 53:
Primary / Secondary Failover

Final DR Test:
SUCCESSFUL ✅
```
