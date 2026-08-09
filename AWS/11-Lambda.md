# AWS Lambda

## What is AWS Lambda?

AWS Lambda is a serverless compute service which is used to run code without managing servers.

AWS manages the underlying infrastructure and we only need to provide our code.

---

## Why do we use Lambda?

Lambda is mainly used when we want to execute some code automatically based on an event or trigger.

For example:

- Automatically start or stop an EC2 instance.
- Execute code when a file is uploaded to S3.
- Execute code when an SNS or SQS event occurs.
- Execute a task at a scheduled time using EventBridge.

---

## What is a Lambda Function?

A Lambda Function is the actual task or code which we create inside AWS Lambda.

For example, if we want to stop an EC2 instance automatically, we can create a Lambda function for EC2 stop operation.

Simple flow:

```text
AWS Lambda
     |
     └── Lambda Function
              |
              └── Code
```

---

## What is Runtime in Lambda?

Runtime defines which programming language will be used to execute our Lambda code.

Examples:

```text
Python
Node.js
Java
```

In our lab, we used Python runtime.

---

## What is a Lambda Handler?

Handler is the entry point of a Lambda function.

When Lambda is triggered, execution of the code starts from the handler.

Example:

```python
def lambda_handler(event, context):
```

For our support/interview level, we only need to understand its purpose. We do not need to write Lambda code from memory.

---

## What is a Trigger in Lambda?

A trigger is an event or AWS service which invokes the Lambda function.

Some common Lambda triggers are:

- EventBridge
- S3
- SNS
- SQS
- API Gateway

Example:

```text
EventBridge
     |
     v
Lambda Function
     |
     v
Execute Code
```

---

## Why does Lambda need an IAM Role?

Lambda needs permission when it performs an action on another AWS service.

For example, if our Lambda function needs to stop an EC2 instance, Lambda must have permission to perform the EC2 stop operation.

We provide this permission through an IAM execution role.

```text
Lambda Function
      |
      v
IAM Role
      |
      v
EC2 Permission
      |
      v
EC2 Instance
```

---

## Can AWS create the Lambda IAM Role automatically?

Yes.

While creating a Lambda function, AWS can create a basic execution role automatically.

If our Lambda function needs additional permissions, such as EC2 start or stop permission, we need to provide those required permissions to the Lambda execution role.

---

## What is EventBridge in Lambda?

EventBridge can be used to trigger a Lambda function based on an event or schedule.

For example, if we want to execute a Lambda function every day at a particular time, we can create an EventBridge schedule.

```text
Given Time
    |
    v
EventBridge
    |
    v
Lambda Function
    |
    v
Execute Code
```

---

## What is the difference between Lambda and EventBridge?

Lambda executes the code.

EventBridge triggers the Lambda function based on an event or schedule.

Simple way to remember:

```text
EventBridge = When to run
Lambda      = What code to run
```

---

## What is Lambda Timeout?

Timeout defines how long a Lambda function can run before AWS stops the execution.

The maximum Lambda timeout is 15 minutes.

---

## What are Environment Variables in Lambda?

Environment variables are used to keep configuration values outside the Lambda code.

For example:

```text
INSTANCE_ID = i-xxxxxxxxxxxx
ENVIRONMENT = production
```

Instead of changing the code every time, we can provide configuration values through environment variables.

Sensitive information like passwords should preferably be stored in services such as AWS Secrets Manager or SSM Parameter Store.

---

# Lambda Hands-on Lab

## Lab Objective

In this lab, we understood how Lambda can be used with EventBridge to execute code automatically at a scheduled time.

Basic architecture:

```text
EventBridge Schedule
        |
        v
Lambda Function
        |
        v
IAM Execution Role
        |
        v
AWS Resource
```

---

## Step 1 - Open AWS Lambda

Go to:

```text
AWS Console
→ Lambda
→ Functions
```

Click:

```text
Create function
```

---

## Step 2 - Create Lambda Function

Select:

```text
Author from scratch
```

Provide a function name.

Select the required runtime, for example:

```text
Python
```

Create the Lambda function.

---

## Step 3 - Understand the IAM Execution Role

During Lambda function creation, an execution role is required.

The IAM role provides permission to the Lambda function.

For example:

```text
Lambda
   |
IAM Role
   |
EC2 Permission
   |
EC2
```

If Lambda needs to start or stop EC2, the execution role needs the required EC2 permissions.

---

## Step 4 - Add the Lambda Code

Inside the Lambda function, go to the Code section.

Add the required code.

The code depends on what action we want Lambda to perform.

For example:

```text
Start EC2
Stop EC2
Process S3 Event
Send Notification
```

For our interview level, we should understand the flow and purpose of the code. We do not need to memorize the complete Python code.

---

## Step 5 - Deploy the Code

After adding or modifying the code, deploy/save the changes.

This makes the latest code available to the Lambda function.

---

## Step 6 - Test the Lambda Function

Before configuring automatic execution, test the Lambda function manually.

Create a test event and execute the function.

Check whether the function executes successfully.

```text
Code
  |
  v
Test
  |
  v
Execution Result
```

If the test fails, check:

- Lambda execution logs
- IAM permissions
- Code errors
- Resource details

---

## Step 7 - Create EventBridge Schedule

After the Lambda function is tested successfully, configure EventBridge.

Create an EventBridge schedule/rule based on the required time.

Example:

```text
Every day at required time
        |
        v
EventBridge
```

---

## Step 8 - Select Lambda as Target

In EventBridge, select the Lambda function as the target.

Now the flow becomes:

```text
EventBridge Schedule
        |
        v
Lambda Function
```

At the scheduled time, EventBridge invokes the Lambda function.

---

## Step 9 - Lambda Executes the Required Task

Once EventBridge triggers the function, Lambda executes the code.

For example:

```text
Scheduled Time
      |
      v
EventBridge
      |
      v
Lambda
      |
      v
EC2 Start/Stop
```

---

## How would you troubleshoot if a Lambda function is not working?

First, I will check whether the Lambda function is being triggered.

Then I will check the Lambda execution logs in CloudWatch Logs.

I will also verify the IAM execution role permissions and check whether the code or resource configuration is correct.

---

## How would you explain Lambda in an interview?

AWS Lambda is a serverless compute service which is used to run code without managing servers.

Lambda is event-driven and can be triggered by services like EventBridge, S3, SNS or SQS.

For example, we can use EventBridge to trigger a Lambda function at a scheduled time and Lambda can perform an action like starting or stopping an EC2 instance.

---

## How would you explain your Lambda hands-on experience?

I have basic hands-on knowledge of AWS Lambda.

I created a Lambda function, configured the required IAM execution role, added and tested the function code, and understood how EventBridge can be used to trigger the Lambda function based on a schedule.

My production experience is mainly in AWS and Linux support, so I use Lambda at a basic hands-on level for automation use cases.

---

## Lambda Quick Revision

```text
Lambda
→ Serverless compute service
→ Runs code without managing servers

Function
→ Actual code/task inside Lambda

Runtime
→ Programming language used by Lambda

Handler
→ Entry point of Lambda code

Trigger
→ Invokes Lambda

EventBridge
→ Can trigger Lambda based on schedule/event

IAM Role
→ Gives Lambda permission to access other AWS services

Timeout
→ Maximum execution time is 15 minutes

Environment Variable
→ Stores configuration outside the code
```

---

## Lambda Interview Flow to Remember

```text
Requirement
    |
    v
Create Lambda Function
    |
    v
Attach Required IAM Role
    |
    v
Add Code
    |
    v
Test Function
    |
    v
Create EventBridge Schedule
    |
    v
EventBridge Triggers Lambda
    |
    v
Lambda Executes the Task
```
