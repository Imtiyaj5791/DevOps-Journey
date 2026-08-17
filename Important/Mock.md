# Master Mock Question Bank — Actually Practiced

> * = Repeated in mock practice

## BASIC

1. Tell me about yourself.
2. Explain your day-to-day responsibilities.
3. Explain your project and your role.
4. What is Linux? What is your experience with Linux administration?
5. How do you check CPU, memory and disk utilization on a Linux server?
6. What networking activities have you performed in Linux?
7. What is Amazon EC2?
8. What components are required to launch an EC2 instance?
9. * What is an AMI in AWS, and why do we use it?
10. What is the difference between an AMI and an EBS Snapshot?
11. What is an Instance Type?
12. What is a Key Pair?
13. How do you connect to an EC2 instance?
14. What are EC2 Status Checks?
15. Explain the difference between System Status Check and Instance Status Check.
16. What does 2/2 Status Check mean?
17. Why do some EC2 instances show 3/3 instead of 2/2?
18. * What is the difference between gp2 and gp3 EBS volumes?
19. * What is the difference between a Security Group and a NACL?
20. How do you manage user permissions in AWS?
21. * What is the difference between a Terraform variable and a local value?
22. * What is the difference between a Docker Image and a Docker Container?
23. If a Docker container is deleted, what happens to the data stored inside it?
24. * What is the difference between stopping and terminating an EC2 instance?
25. What is the difference between Basic Monitoring and Detailed Monitoring for an EC2 instance in CloudWatch, especially in terms of monitoring interval?
26. What is the difference between `chmod` and `chown` in Linux?
27. What is the difference between a hard link and a soft link in Linux?
28. What is a Terraform state file, and why is it required?
29. What is the difference between `CMD` and `ENTRYPOINT` in a Dockerfile?


## MEDIUM

1. CPU utilization is 95%. How will you troubleshoot?
2. CloudWatch generated a High CPU alert. What will you do?
3. Memory utilization is 95%. How will you troubleshoot?
4. Disk utilization reaches 100%. How will you troubleshoot?
5. Linux server suddenly becomes very slow, but CPU utilization is normal. How will you troubleshoot?
6. If a Bash script fails, how will you troubleshoot?
7. SSH is not working on a server. How will you troubleshoot?
8. EC2 Linux server is running but suddenly becomes unreachable through SSH. Troubleshoot step by step.
9. Application service is running, but users cannot access the application on port 8080. How will you troubleshoot?
10. * EC2 instance is running, but users are unable to access the application. How will you troubleshoot?
11. Users are unable to open the website. How will you troubleshoot?
12. What is the difference between an Application Issue and a Website Issue?
13. * EC2 is in a private subnet and needs to download OS updates/packages from the internet, but should not be directly accessible from the internet. How will you configure this?
14. Why did you use an Application Load Balancer in your project?
15. Why did you use Auto Scaling Group in your project?
16. Why did you use Amazon RDS instead of installing MySQL on EC2?
17. Why is RDS deployed in a private subnet instead of a public subnet?
18. After restoring a server, what will you check?
19. What do you use for Disaster Recovery in your project?
20. Explain RTO and RPO.
21. Application has an RTO of 2 hours and RPO of 30 minutes. What does this mean, and what is your recovery expectation?
22. You created an EC2 instance using Terraform. Someone manually terminates or changes it from AWS Console. What happens when you run `terraform plan`, and why?
23. You deployed a new Docker image/version and after deployment the application is not working properly. How will you roll back to the previous working version?
24. How can an EC2 instance access an S3 bucket securely without storing AWS access keys on the server?
25. * Your EC2 instance is running and the 2/2 status checks are passed, but users are unable to access the application through the browser. How would you troubleshoot this issue?
26. You increased an EBS volume size from the AWS Console, and the volume is configured with LVM on the Linux server. What steps would you follow on the server to use the newly added space?
27. An application is running on a Linux server, but users are getting "Connection Refused." How would you troubleshoot this issue?
28. You have an existing database server that was created manually. Now you want to manage it using Terraform. How would you bring it under Terraform management?
29. You have created 5 EC2 instances using Terraform `count`. Now you want to remove only the 1st and 5th EC2 instances. How would you do it?
30. How would you reduce the size of a Docker image?


## ADVANCED

1. A Java process is consuming 98% CPU. Will you kill the process?
2. Application team says not to restart the service, but users are still facing issues. What will you do?
3. Application is behind an ALB with 3 EC2 instances. One target is Unhealthy while the other two are Healthy. How will you troubleshoot?
4. If the complete environment/AZ/Region fails, how will you recover the business?
5. How is data available in DR?
6. Does the passive server always remain ON? If yes, cost will be high. If no, how will it have the latest data?
7. You have an EC2 instance in a private subnet with no Internet Gateway and no NAT Gateway. The application needs to upload data to an S3 bucket. How would you configure this securely?
