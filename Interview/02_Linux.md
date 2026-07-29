# 🐧 Linux Interview Questions - Part 01

---

# Q1. Tell me about your Linux experience.

## Answer

I have around 5 years of experience as a Linux and AWS Support Engineer.

In my current project, I am responsible for monitoring Linux servers, handling production incidents and supporting AWS infrastructure.

I work on EC2 instances hosted on AWS.

My daily work includes checking CloudWatch and Grafana alerts, troubleshooting Linux issues, monitoring application services, patching servers, extending EBS volumes, checking logs and coordinating with Application, Network and Cloud teams.

---

# Q2. What are your day-to-day Linux activities?

## Answer

My day starts with checking monitoring dashboards like CloudWatch, Grafana and Opsgenie.

I first verify whether there are any critical alerts like High CPU, High Memory, Disk Utilization, Website Down or Service Down.

Then I check Jira for any new incidents or pending tickets.

If I receive any production alert, first I verify whether it is a genuine issue or a temporary spike.

Then I login to the affected server using SSH.

After login, I check CPU, Memory, Disk Utilization, Running Services, Application Logs and Network connectivity.

If required, I coordinate with the Application Team, Network Team, Database Team or Cloud Team.

After resolving the issue, I verify the application, monitor CloudWatch dashboard again and update the Jira ticket.

---

# Q3. What is NFS? How do you mount it and how does the end user access it?

## Answer

NFS (Network File System) is a file-level storage protocol that allows multiple Linux servers to access the same shared directory over the network.

It is commonly used to share application files, backup directories, and common data between multiple servers.

### Steps to mount an NFS share:

1. Check the available NFS exports on the server
showmount -e <NFS_Server_IP>

2. Create a mount point on the client
   mkdir /mnt/nfs
   
3. Mount the NFS share
   mount -t nfs <NFS_Server_IP>:/shared_data /mnt/nfs

4. Verify the mount
   df -h
mount | grep nfs

5. To make the mount permanent, add an entry in /etc/fstab.
   10.0.1.10:/shared_data    /mnt/nfs    nfs    defaults    0 0

### How does the end user access it?

The end user does not connect directly to the NFS server. The NFS share is mounted on the Linux application server, and the application accesses the files through the mounted directory. The user only interacts with the application, not the NFS server.
---

# Q4. Which Linux commands do you use daily?

## Answer

I use below commands almost every day.

Check CPU

```bash
top
```

Check Memory

```bash
free -h
```

Check Disk

```bash
df -h
```

Check Directory Size

```bash
du -sh *
```

Check Running Process

```bash
ps -ef
```

Check Services

```bash
systemctl status <service-name>
```

Check Logs

```bash
journalctl -xe
tail -100 /var/log/messages
```

Check Listening Ports

```bash
ss -tulnp
```

These commands help me during daily production troubleshooting.

---

# Q5. How do you troubleshoot High CPU Utilization?

## Answer

First I check the alert in CloudWatch or Grafana.

I verify whether CPU utilization is continuously high or it is just a temporary spike.

I also check since when CPU utilization is high.

If Auto Scaling is configured, I verify whether a new instance has been launched automatically.

Then I login to the server using SSH.

I check CPU utilization using

```bash
top
```

or

```bash
htop
```

I identify which process is consuming high CPU.

Then I check whether any deployment, cron job, backup or log rotation activity is running.

If it is an expected activity, I monitor it until it completes.

If it is not expected, I check application logs and system logs.

If required, I coordinate with the Application Team.

I never kill any production process without approval.

If restart is required, I take approval first.

Finally, I verify CloudWatch dashboard, make sure CPU utilization is back to normal, update Jira and prepare the RCA.

---

# Q6. How do you troubleshoot High Memory Utilization?

## Answer

First I check the alert in CloudWatch or Grafana.

I verify whether memory utilization is continuously increasing or it is a temporary spike.

Then I login to the server using SSH.

I check memory using

```bash
free -h
```

Then I check which process is consuming more memory using

```bash
top
```

or

```bash
ps -ef
```

I also check whether swap memory is being used.

Then I review application logs.

If required, I coordinate with the Application Team.

If restart is required, I take approval first.

Finally, I monitor CloudWatch dashboard again, verify memory utilization and update the Jira ticket.

---

# Q7. Disk Utilization is 95% or 100%. What will you do?

## Answer

First I check the alert in CloudWatch or Grafana.

I verify whether disk utilization is continuously increasing or it is a temporary spike.

Then I login to the server using SSH.

First I check which filesystem is full.

```bash
df -h
```

Then I identify which directory is consuming more space.

```bash
du -sh * /var/*
```

In most cases, application logs consume more space.

As per our company SOP, I first archive the old logs if required.

Then I remove logs which are approved for cleanup.

I also verify whether log rotation is working properly.(cat /etc/logrotate.conf)

If logrotate is not working, I fix the issue or coordinate with the Application Team.

If temporary files or old backup files are consuming space, I clean them after confirmation.

If disk utilization is still high, I coordinate with the Cloud Team to extend the EBS volume.

After extending the EBS volume, I extend the filesystem if required.

Finally, I verify the application, monitor CloudWatch dashboard, update Jira and prepare the RCA.

---

# Q8. How do you check logs in Linux?

## Answer

First I identify which application or service is having the issue.

Then I check the system logs using

```bash
journalctl -xe
```

If it is an application issue, I check the application log path.

I mainly look for Error, Warning and Exception messages.

I also check the timestamp to match it with the alert time.

Based on the log findings, I continue troubleshooting or coordinate with the Application Team.

---

# Q9. How do you check whether a service is running?

## Answer

First I check the service status.

```bash
systemctl status <service-name>
```

If the service is stopped, I don't restart it immediately.

First I review the logs.

```bash
journalctl -u <service-name>
```

Then I identify the reason behind the failure.

If required, I coordinate with the Application Team.

After approval, I restart the service.

Then I verify that the application port is listening.

```bash
ss -tulnp
```

Finally, I verify the application is accessible and update the Jira ticket.

---

# Q10. What is the difference between df and du?

## Answer

The **df** command shows filesystem usage.

The **du** command shows the size of files and directories.

Normally I first use **df -h** to identify which filesystem is full.

Then I use **du -sh** to identify which directory is consuming more space.

This helps me quickly identify the root cause of disk utilization.

# 🐧 Linux Interview Questions - Part 02

---

# Q11. SSH is not working. What will you do?

## Answer

First I verify whether the EC2 instance is in the Running state.

Then I check both **System Status Check** and **Instance Status Check**.

Next I verify the Security Group and make sure port **22** is allowed.

Then I verify Network ACL, Route Table and Internet Gateway if it is a public server.

I also verify whether I am using the correct username and PEM key.

If SSH is still not working, I use EC2 Instance Connect, Systems Manager or Serial Console if available.

After logging into the server, I check whether the SSH service is running.

```bash
systemctl status sshd
```

Then I check SSH logs.

```bash
journalctl -u sshd
```

I also check whether the disk is full because sometimes SSH does not work if the root filesystem is 100%.

If required, I restart the SSH service after verifying the issue.

Finally, I verify SSH connectivity and update the Jira ticket.

---

# Q12. Server is slow. How will you troubleshoot?

## Answer

First I verify the alert in CloudWatch or Grafana.

I check whether the issue is continuous or only for a short time.

Then I login to the server using SSH.

I check CPU, Memory and Disk utilization.

```bash
top
free -h
df -h
```

Then I check the Load Average.

```bash
uptime
```

I identify whether any process is consuming high resources.

I also check application logs and system logs.

If all server resources are normal, I check with the Application Team whether any deployment or batch job is running.

Finally, I verify server performance, monitor CloudWatch dashboard and update the Jira ticket.

---

# Q13. Website is down. What will you check?

## Answer

First I verify whether the issue is affecting one user or all users.

Then I check CloudWatch dashboard for any alerts.

I verify that the EC2 instance is running and both status checks are passed.

Then I login to the server.

I check whether the application service is running.

```bash
systemctl status <service-name>
```

Then I verify whether the application port is listening.

```bash
ss -tulnp
```

If the port is not listening, I check the application logs.

If the application is running, I verify the Load Balancer, Target Group Health Check, Security Group and Route 53 if applicable.

If required, I coordinate with the Application Team.

After fixing the issue, I verify the website from the browser and update the Jira ticket.

---

# Q14. Application service is not running. What will you do?

## Answer

First I check the service status.

```bash
systemctl status <service-name>
```

I do not restart the service immediately.

First I check the logs.

```bash
journalctl -u <service-name>
```

I verify why the service failed.

If it is a configuration issue, dependency issue or application issue, I coordinate with the Application Team.

If restart is required, I take approval first.

Then I restart the service.

Finally, I verify the application port, application URL and CloudWatch dashboard.

---

# Q15. Application port is not listening. What will you do?

## Answer

First I verify which port should be listening.

Then I check whether the port is listening.

```bash
ss -tulnp
```

If the port is not listening, I check whether the application service is running.

Then I review the application logs.

I verify whether any recent deployment or configuration change was done.

If required, I coordinate with the Application Team.

After fixing the issue, I verify that the port is listening and the application is accessible.

---

# Q16. Server is not reachable. What will you check?

## Answer

First I verify whether the server is running.

Then I check the ping response if allowed.

I verify EC2 status checks.

If it is an AWS server, I verify Security Group, Network ACL and Route Table.

If SSH is not working, I use EC2 Instance Connect or Systems Manager if available.

After login, I check CPU, Memory, Disk and Network.

If it is a physical server, I also verify with the Data Center Team for hardware or power issues.

Finally, I verify the server is reachable and update the Jira ticket.

---

# Q17. DNS is not resolving. What will you do?

## Answer

First I verify whether the issue is for one server or all servers.

Then I check the DNS configuration.

```bash
cat /etc/resolv.conf
```

I verify network connectivity.

```bash
ping
```

Then I check DNS resolution.

```bash
nslookup
```

or

```bash
dig
```

If Route 53 is being used, I verify the DNS record.

If required, I coordinate with the Network Team.

Finally, I verify DNS resolution and application access.

---

# Q18. Application is not accessible after deployment. What will you do?

## Answer

First I check with the Application Team whether the deployment was completed successfully.

Then I verify that the application service is running.

I check the application logs for any startup errors.

I verify the application port.

Then I check the Load Balancer Health Check.

If required, I compare the previous configuration.

Finally, after fixing the issue, I verify the application from the browser and update the Jira ticket.

---

# Q19. MySQL replication is broken. What will you do?

## Answer

First I login to the MySQL server.

Then I check the replication status.

```sql
SHOW SLAVE STATUS\G;
```

I verify the Last_SQL_Error and Last_IO_Error.

Based on the error code, I follow the company SOP.

If required, I coordinate with the Database Team.

After fixing the issue, I verify that both SQL Thread and IO Thread are running.

Finally, I monitor replication and update the Jira ticket.

---

# Q20. Java process is consuming high CPU. What will you do?

## Answer

First I verify the alert in CloudWatch or Grafana.

I check whether CPU utilization is continuously high or it is a temporary spike.

Then I login to the server.

I identify the Java process.

```bash
top
ps -ef | grep java
```

I review the application logs.

I verify whether any deployment, batch job or heavy traffic is running.

I never kill the Java process without approval.

I coordinate with the Application Team and share all findings.

If restart is required, I take approval first.

Finally, I verify CPU utilization, application health, update the Jira ticket and prepare the RCA.

# 🐧 Linux Interview Questions - Part 03

---

# Q21. Disk got full because of log files. What will you do?

## Answer

First I check the CloudWatch or Grafana alert.

Then I login to the server using SSH.

I check which filesystem is full.

```bash
df -h
```

Then I identify which directory is consuming more space.

```bash
du -sh /var/*
```

I verify that the space is consumed by application logs.

As per our company SOP, I archive the logs first.

Then I remove old logs which are approved for cleanup.

I also verify whether logrotate is working properly.

If logrotate is not working, I fix the configuration or coordinate with the Application Team.

If disk utilization is still high after cleanup, I extend the EBS volume.

Then I extend the filesystem.

Finally, I verify the application, monitor CloudWatch dashboard, update Jira and prepare the RCA.

---

# Q22. Filesystem became Read-Only. What will you do?

## Answer

First I login to the server and verify the filesystem status.

I review system logs.

```bash
journalctl -xe
dmesg
```

I check whether there are any filesystem errors or disk issues.

I also verify disk utilization.

If required, I inform the Cloud Team or Storage Team.

I do not make unnecessary changes on the production server.

After fixing the issue, I verify that the filesystem is mounted correctly and the application is working.

Finally, I update the Jira ticket and prepare the RCA.

---

# Q23. Cron job is not running. What will you check?

## Answer

First I verify whether the cron service is running.

```bash
systemctl status cron
```

or

```bash
systemctl status crond
```

Then I check the configured cron jobs.

```bash
crontab -l
```

I verify the scheduled time.

Then I review the cron logs.

I also verify script permissions and file path.

If the cron job depends on any application or database, I verify that those services are running.

After fixing the issue, I execute the script manually to confirm it is working.

Finally, I monitor the next scheduled execution and update the Jira ticket.

---

# Q24. EC2 instance is running but application is not accessible. What will you do?

## Answer

First I verify whether the issue is affecting one user or all users.

Then I verify that the EC2 instance is in the Running state.

I also verify that both System Status Check and Instance Status Check are passed.

Then I login to the server.

I verify the application service.

```bash
systemctl status <service-name>
```

Then I verify whether the application port is listening.

```bash
ss -tulnp
```

I review the application logs.

If required, I verify Security Group, Load Balancer, Target Group Health Check and Route 53.

After resolving the issue, I verify the application from the browser, update Jira and prepare the RCA.

---

# Q25. Users are reporting intermittent slowness. How will you troubleshoot?

## Answer

First I verify CloudWatch or Grafana dashboard.

I check whether CPU, Memory or Disk utilization is spiking at regular intervals.

I also check the alert history to identify when the issue started.

Then I login to the server.

I check server utilization.

```bash
top
free -h
df -h
```

I review application logs.

I verify whether any cron job, backup, deployment or batch process is running during that time.

If infrastructure is healthy, I coordinate with the Application Team.

Finally, I monitor the server again, verify performance and update the Jira ticket.

---

# Q26. Explain your patching activity.

## Answer

We use NinjaOne for patch management.

First we schedule the maintenance activity.

Then we inform the stakeholders.

For production servers, we take an EBS snapshot before patching.

We enable maintenance mode.

Then we start patch installation.

After reboot, I verify server accessibility.

I check application services.

I verify CPU, Memory and Disk utilization.

I also verify application accessibility.

Finally, I disable maintenance mode, update the maintenance ticket and monitor the server.

---

# Q27. What if patching fails?

## Answer

First I identify at which stage the patch failed.

Whether it failed during download, installation or reboot.

Then I review NinjaOne logs and Linux logs.

If the server is accessible, I verify all application services.

If required, I restore the server using the latest EBS snapshot or follow the rollback procedure as per company SOP.

I coordinate with the Patch Management Team and Application Team.

Finally, I verify the application, update Jira and prepare the RCA.

---

# Q28. Do you kill a production process if it is consuming high CPU?

## Answer

No.

I never kill any production process without approval.

First I identify the process.

Then I verify whether it is an expected activity like deployment, backup or batch job.

I collect logs and share all findings with the Application Team.

If restart or process termination is required, I take approval first.

After taking approval, I perform the activity.

Finally, I verify that the application is working properly and update the incident ticket.

---

# Q29. Tell me about one production issue you handled.

## Answer

During my night shift, we suddenly received multiple alerts that more than 100 physical servers were showing Host Down.

First I verified the issue by checking router connectivity and trying SSH access to multiple servers.

Both router ping and SSH were failing.

So I suspected a Data Center level issue instead of a server issue.

Immediately I created an Incident Bridge on Microsoft Teams.

I informed the client and shared all troubleshooting details.

Then I contacted the Equinix Data Center Team.

After investigation, they confirmed that one PDU had failed.

Once the PDU issue was resolved, all servers gradually became reachable.

Then I verified server health, closed the incident and prepared the RCA.

---

# Q30. Tell me about one AWS production issue you handled.

## Answer

CloudWatch generated a High Disk Utilization alert for one production EC2 instance.

First I checked the CloudWatch dashboard to verify whether the utilization was continuously increasing or it was only a temporary spike.

Then I connected to the EC2 instance using SSH.

I checked the filesystem.

```bash
df -h
```

Then I identified which directory was consuming more space.

```bash
du -sh /var/*
```

I found that application log files were consuming most of the disk space.

As per our company SOP, I archived the logs first.

Then I removed old logs that were approved for cleanup.

I also verified that logrotate was working properly.

Even after cleanup, disk utilization was still high.

So I increased the EBS volume from the AWS Console.

Then I extended the filesystem.

After that I verified the application, monitored CloudWatch dashboard until disk utilization returned to normal, updated the Jira ticket and prepared the RCA.

