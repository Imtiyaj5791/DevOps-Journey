# Amazon Route 53 Top 30 Interview Questions and Answers

## 1. What is Amazon Route 53?

**Answer:**

Amazon Route 53 is a global DNS service provided by AWS.

It is used for:
- Domain name resolution
- DNS record management
- Traffic routing
- Health checking


## 2. Why is it called Route 53?

**Answer:**

Route 53 name comes from DNS port number 53.

DNS communication happens on port 53.


## 3. Is Route 53 a Regional or Global Service?

**Answer:**

Route 53 is a global AWS service.

It is not limited to any specific AWS Region.


## 4. What is DNS?

**Answer:**

DNS converts a domain name into an IP address.

Example:

www.example.com → IP Address

It helps users access websites using names instead of remembering IP addresses.


## 5. How does DNS resolution work?

**Answer:**

When a user enters a domain name:

1. User request goes to DNS resolver.
2. Resolver checks DNS records.
3. Route 53 returns the required IP address.
4. User connects to the server.


## 6. What is Hosted Zone in Route 53?

**Answer:**

Hosted Zone is a container where we create and manage DNS records for a domain.

Example:

devopsclasses.space

Inside Hosted Zone we can create:

- A Record
- CNAME
- NS
- SOA
- MX
- TXT


## 7. Difference between Public and Private Hosted Zone?

**Answer:**

Public Hosted Zone:

It is used for internet-facing websites.

Example:

www.company.com


Private Hosted Zone:

It is used for internal DNS resolution inside VPC.

Example:

db.internal.company.local


## 8. What is NS Record?

**Answer:**

NS Record tells who manages DNS for the domain.

Example:

I purchased my domain from GoDaddy and created a Hosted Zone in Route 53.

Route 53 provides Name Servers.

After updating these Name Servers in GoDaddy, Route 53 starts managing DNS for my domain.


## 9. Why does Route 53 provide 4 Name Servers?

**Answer:**

Route 53 provides multiple Name Servers for high availability and fault tolerance.

If one Name Server fails, other Name Servers continue DNS resolution.


## 10. What is SOA Record?

**Answer:**

SOA (Start of Authority) record contains DNS zone authority information.

It provides information like:

- Primary Name Server
- Serial Number
- Refresh Time
- Retry Time


## 11. Difference between NS and SOA Record?

**Answer:**

NS Record:

It tells who manages DNS for the domain.

SOA Record:

It tells DNS zone information like primary name server and serial number.


## 12. What is A Record?

**Answer:**

A Record maps a domain name to an IPv4 address.

Example:

test.devopsclasses.space → 13.201.43.54


## 13. Difference between A and AAAA Record?

**Answer:**

A Record maps domain to IPv4 address.

AAAA Record maps domain to IPv6 address.


## 14. What is CNAME Record?

**Answer:**

CNAME maps one domain name to another domain name.

Example:

www.example.com → example.com


## 15. Difference between CNAME and Alias Record?

**Answer:**

CNAME points one domain name to another domain name.

Alias points a domain directly to AWS resources like ALB, CloudFront, and S3.


## 16. Why do we use Alias Record with ALB?

**Answer:**

ALB IP addresses can change.

Alias allows Route 53 to directly point the domain to ALB without managing IP addresses manually.


## 17. Can we point Route 53 directly to EC2?

**Answer:**

Yes, we can point Route 53 to EC2 using an A Record with public IP.

But in production, we mostly use ALB with Alias because ALB provides better availability.


## 18. What are Route 53 Routing Policies?

**Answer:**

Routing policies decide how Route 53 routes traffic to different resources.

Types:

- Simple
- Weighted
- Latency
- Failover
- Geolocation
- Geoproximity
- Multivalue


## 19. Explain Simple Routing Policy.

**Answer:**

Simple Routing sends traffic to a single resource.

Example:

Website → Single EC2 Instance


## 20. Explain Weighted Routing with example.

**Answer:**

Weighted Routing distributes traffic based on assigned weight.

Example:

Server-1 → Weight 80

Server-2 → Weight 20

Traffic will be distributed approximately 80% and 20%.

Use case:

Canary deployment and testing new application versions.


## 21. Difference between Weighted and Multivalue Routing?

**Answer:**

Weighted Routing decides how much traffic each resource receives.

Multivalue Routing returns multiple healthy endpoints.


## 22. Explain Latency Routing.

**Answer:**

Latency Routing sends users to the AWS Region that provides the lowest latency.

Example:

India user may go to Mumbai Region because it provides better response time.


## 23. Difference between Latency and Geolocation Routing?

**Answer:**

Latency Routing:

It routes traffic based on lowest network latency.

Geolocation Routing:

It routes traffic based on user location.


## 24. Explain Geolocation Routing.

**Answer:**

Geolocation Routing routes traffic based on the user's geographic location.

Example:

India Users → Mumbai Region

USA Users → Virginia Region


## 25. Explain Geoproximity Routing.

**Answer:**

Geoproximity Routing routes traffic based on geographic distance between user and resource.

It also supports bias to shift more traffic towards a specific resource.


## 26. Explain Multivalue Answer Routing.

**Answer:**

Multivalue Answer Routing returns multiple healthy IP addresses for a domain.

It provides basic DNS-level load distribution.

If health check detects unhealthy endpoints, Route 53 removes them from the response.


## 27. What is Route 53 Health Check?

**Answer:**

Route 53 Health Check monitors the health of endpoints.

It checks whether the resource is available or not.

It is mainly used with Failover Routing.


## 28. How does Failover Routing work?

**Answer:**

Failover Routing is used for Disaster Recovery.

We configure:

- Primary Endpoint
- Secondary Endpoint
- Health Check

If the primary endpoint fails, Route 53 automatically routes traffic to the secondary endpoint.


Example:

Primary:

Mumbai Region


Secondary:

Singapore Region


Flow:

User → Route 53 Health Check → Primary Failed → DR Region


## 29. How does Route 53 help in Disaster Recovery?

**Answer:**

Route 53 helps in Disaster Recovery using Failover Routing.

We can configure a primary region and secondary DR region.

If the primary region is unavailable, traffic automatically moves to the DR region.


## 30. Scenario: Primary AWS Region is down. How will you redirect traffic to DR?

**Answer:**

First, I will configure Route 53 Failover Routing with Health Check.

The primary region will be configured as the primary endpoint and the DR region as the secondary endpoint.

If the health check detects primary failure, Route 53 automatically routes traffic to the DR region.
