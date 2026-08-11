# Amazon Route 53 Notes

## What is Amazon Route 53?

Amazon Route 53 is a global DNS service provided by AWS.

It is used for:
- Domain name resolution
- DNS record management
- Routing traffic to AWS resources
- Health checking

Example:

User
|
↓
Route 53
|
↓
AWS Resource


## What is Hosted Zone?

Hosted Zone is a container where we create and manage DNS records for a domain.

Example:

Domain:

devopsclasses.space

Inside Hosted Zone we can create records like:

- A Record
- CNAME
- MX
- TXT
- NS
- SOA


## Types of Hosted Zone

### Public Hosted Zone

Public Hosted Zone is used for internet-facing websites.

Example:

www.example.com

Anyone from the internet can resolve this domain.


### Private Hosted Zone

Private Hosted Zone is used for internal DNS resolution inside VPC.

Example:

db.internal.company.local

Only resources inside VPC can resolve this domain.


# DNS Records


## What is NS Record?

NS (Name Server) record tells who manages DNS for this domain.

Example:

I purchased my domain from GoDaddy.

I created a Hosted Zone in Route 53.

Route 53 provided 4 Name Servers.

I updated these Name Servers in GoDaddy.

After that Route 53 started managing DNS for my domain.


## Why Route 53 creates 4 NS Records?

Route 53 creates multiple Name Servers for high availability and fault tolerance.

If one Name Server fails, other Name Servers continue DNS resolution.

Example:

NS-1 ❌

NS-2 ✅

NS-3 ✅

NS-4 ✅


## What is SOA Record?

SOA (Start of Authority) record contains DNS zone authority information.

It provides information like:

- Primary Name Server
- Serial Number
- Refresh Time
- Retry Time

Simple:

NS tells:

"Who manages DNS?"

SOA tells:

"DNS zone information."


## Difference between NS and SOA?

NS Record:

It tells who manages DNS for the domain.

Example:

Route 53 Name Servers.


SOA Record:

It tells DNS zone details.

Example:

Primary Name Server and Serial Number.



# Route 53 Records


## What is A Record?

A Record maps a domain name to an IPv4 address.

Example:

test.devopsclasses.space

↓

13.201.43.54


## A Record Lab

Created A Record:

Name:

test

Type:

A

Value:

13.201.43.54


Verification:

nslookup test.devopsclasses.space


Output:

test.devopsclasses.space

Address:

13.201.43.54



## What is AAAA Record?

AAAA Record maps a domain name to an IPv6 address.

Difference:

A Record:

Domain → IPv4


AAAA Record:

Domain → IPv6



## What is CNAME Record?

CNAME maps one domain name to another domain name.

Example:

www.devopsclasses.space

↓

test.devopsclasses.space


## CNAME Lab

Created CNAME Record:

Name:

www

Type:

CNAME

Value:

test.devopsclasses.space


Verification:

nslookup www.devopsclasses.space



## What is Alias Record?

Alias Record maps a domain name directly to AWS resources.

Examples:

- Application Load Balancer
- CloudFront
- S3 Website Endpoint


Example:

devopsclasses.space

↓

ALB


## Why use Alias Record for ALB?

ALB IP addresses can change.

Instead of manually updating IP addresses, Alias directly connects the domain with AWS resources.



# Route 53 Routing Policies


## What is Simple Routing?

Simple Routing sends traffic to a single resource.

Example:

Website

↓

Single EC2 Instance


Use case:

Small application running on one server.



## What is Weighted Routing?

Weighted Routing distributes traffic based on assigned weight.

Example:

Server-1:

Weight 80


Server-2:

Weight 20


Traffic distribution:

80% → Server-1

20% → Server-2


Use case:

- Canary deployment
- Testing new application version


## Weighted Routing Lab

Created two records:

Server-1:

IP:

13.201.43.54

Weight:

80


Server-2:

IP:

13.127.234.95

Weight:

20


Verification:

nslookup weighted.devopsclasses.space



## What is Latency Routing?

Latency Routing sends users to the AWS Region that provides the lowest latency.

Simple:

It sends users to the fastest AWS Region.


Example:

Mumbai Region

Singapore Region


India user:

↓

Mumbai Region



## Latency Routing Lab

Created records:

Mumbai:

13.201.43.54


Singapore:

18.142.105.114


Route 53 selected the region with lower latency.



## What is Failover Routing?

Failover Routing is used for Disaster Recovery.

It sends traffic from primary resource to secondary resource when primary fails.


Example:


Primary Region:

Mumbai

Application Running


Secondary Region:

Singapore

DR Environment


Flow:

User

↓

Route 53 Health Check

↓

Primary Failed

↓

Secondary DR Region


Components:

- Health Check
- Primary Endpoint
- Secondary Endpoint



## What is Geolocation Routing?

Geolocation Routing routes traffic based on user location.

Example:

India Users

↓

Mumbai Region


USA Users

↓

Virginia Region


Use case:

- Location based content
- Country specific routing



## What is Geoproximity Routing?

Geoproximity Routing routes traffic based on geographic distance between user and resource.

Simple:

It routes traffic based on distance between user and AWS resource.


Example:

User

↓

Nearest AWS Region


It also supports bias to shift more traffic towards a specific resource.



## What is Multivalue Answer Routing?

Multivalue Answer Routing returns multiple healthy IP addresses for a domain.

Example:

Website:

www.example.com


Returns:

Server-1 IP

Server-2 IP

Server-3 IP


If health check finds any endpoint unhealthy, Route 53 removes that endpoint from the response.


Difference:

Weighted Routing:

It decides how much traffic each resource gets.


Multivalue Routing:

It returns which healthy resources are available.
