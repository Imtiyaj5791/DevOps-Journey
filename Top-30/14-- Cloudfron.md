# Amazon CloudFront — Top 15 Interview Questions

## 1. What is Amazon CloudFront?

Amazon CloudFront is a Content Delivery Network (CDN) service provided by AWS.

It delivers content to users from the nearest Edge Location, which helps reduce latency and improve application performance.

---

## 2. Why do we use CloudFront?

We use CloudFront to deliver content faster to users.

Instead of every request going directly to the origin server, CloudFront can cache the content at Edge Locations and serve it closer to the users.

**Remember:**

    CloudFront = Faster Content Delivery + Reduced Latency

---

## 3. What is an Edge Location?

An Edge Location is an AWS location where CloudFront caches content closer to users.

When a user requests cached content, CloudFront can serve it from a nearby Edge Location instead of requesting it from the origin every time.

---

## 4. What is an Origin in CloudFront?

Origin is the original location where our application or content is stored.

Common CloudFront origins include:

- Amazon S3
- Application Load Balancer
- EC2/Web Server
- API Gateway
- Other HTTP servers

Example:

    User
      ↓
    CloudFront
      ↓
    Origin (S3 / ALB)

---

## 5. How does CloudFront work?

When a user requests content:

1. The request goes to CloudFront.
2. CloudFront checks the Edge Location for cached content.
3. If the content is available in cache, CloudFront sends it directly to the user.
4. If the content is not available, CloudFront gets it from the origin.
5. CloudFront can cache the content for future requests.

**Flow:**

    User
      ↓
    CloudFront Edge Location
      ↓
    Cache Available?
      ↓
    YES → Send to User
    NO  → Get from Origin → Cache → Send to User

---

## 6. What is the difference between CloudFront and S3?

S3 is mainly an object storage service.

CloudFront is a CDN service used to deliver content faster to users.

We can use S3 as an origin and CloudFront in front of it.

**Remember:**

    S3         = Store Content
    CloudFront = Deliver Content Faster

---

## 7. What is the difference between CloudFront and an Application Load Balancer?

ALB distributes incoming application traffic across multiple backend targets such as EC2 instances.

CloudFront delivers and caches content closer to users through Edge Locations.

They can also be used together.

Example:

    User
      ↓
    CloudFront
      ↓
    ALB
      ↓
    EC2-1 / EC2-2 / EC2-3

**Remember:**

    CloudFront = CDN / Content Delivery
    ALB        = Distribute Traffic to Backend Servers

---

## 8. What is CloudFront caching?

CloudFront caching means storing copies of content at Edge Locations.

If another user requests the same cached content, CloudFront can serve it directly from the Edge Location instead of going to the origin again.

This helps reduce latency and origin load.

---

## 9. What are Cache Hit and Cache Miss?

**Cache Hit:**

The requested content is already available in the CloudFront cache.

    User → CloudFront Cache → Content

**Cache Miss:**

The content is not available in the cache, so CloudFront gets it from the origin.

    User → CloudFront → Origin → CloudFront → User

**Remember:**

    Cache Hit  = Content available at Edge
    Cache Miss = Get content from Origin

---

## 10. What is TTL in CloudFront?

TTL stands for Time To Live.

It defines how long CloudFront can keep content in its cache before checking or retrieving updated content from the origin.

**Remember:**

    TTL = How long content stays cached

---

## 11. What is CloudFront Cache Invalidation?

Cache invalidation is used when we want CloudFront to remove cached content before its normal cache expiration.

For example, if we update a website file but CloudFront is still serving the old cached version, we can create an invalidation.

Example:

    /index.html

or

    /*

After invalidation, CloudFront retrieves the latest content from the origin when requested.

---

## 12. How can you securely use an S3 bucket with CloudFront?

We can keep the S3 bucket private and allow CloudFront to access the bucket using Origin Access Control (OAC).

Users access the content through CloudFront instead of directly accessing the S3 bucket.

**Flow:**

    User
      ↓
    CloudFront
      ↓
    Private S3 Bucket

**Remember:**

    Private S3 + CloudFront + OAC

---

## 13. Can CloudFront use HTTPS?

Yes.

CloudFront supports HTTPS.

We can use an SSL/TLS certificate with CloudFront to provide secure HTTPS access to users.

AWS Certificate Manager (ACM) can be used to manage the certificate.

Example:

    User
      ↓
    HTTPS
      ↓
    CloudFront
      ↓
    Origin

---

## 14. Users are getting old content from CloudFront after a new application version was deployed. What will you check?

First, I will check whether CloudFront is serving old cached content.

I will check:

1. CloudFront cache behavior
2. TTL configuration
3. Whether the latest content is available at the origin
4. Cache invalidation

If required, I can create a CloudFront invalidation to remove the old cached content.

---

## 15. Users in one location are facing slow application performance. How can CloudFront help?

CloudFront can cache and deliver content from Edge Locations closer to users.

This reduces the distance between the user and the content and helps reduce latency.

**Remember:**

    User → Nearest Edge Location → Faster Content Delivery

---

# Quick Revision

    CloudFront
    → Content Delivery Network (CDN)

    Main Purpose
    → Faster Content Delivery + Reduced Latency

    Edge Location
    → Cache content closer to users

    Origin
    → Original source of content

    Common Origins
    → S3 / ALB / EC2 / API Gateway

    Cache Hit
    → Content available in CloudFront cache

    Cache Miss
    → CloudFront gets content from Origin

    TTL
    → How long content stays cached

    Invalidation
    → Remove old cached content

    S3 + CloudFront
    → Private S3 + OAC

    CloudFront vs S3
    → Deliver vs Store

    CloudFront vs ALB
    → CDN vs Load Balancing

    HTTPS
    → CloudFront + ACM Certificate

---

# Most Important Interview Questions

1. What is CloudFront and why do we use it?
2. What is an Edge Location?
3. What is an Origin?
4. How does CloudFront work?
5. CloudFront vs S3?
6. CloudFront vs ALB?
7. What are Cache Hit and Cache Miss?
8. What is TTL?
9. What is Cache Invalidation?
10. How do you securely access a private S3 bucket through CloudFront?
11. Users are getting old cached content. How will you troubleshoot?
