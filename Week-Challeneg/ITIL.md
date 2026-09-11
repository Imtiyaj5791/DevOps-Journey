squ_f6e1404d33c36bed5ce657f3493c59a81010a69e


# ITIL:-

### Incident Management

“An incident is an unexpected issue that affects a service. We need to restore the service as quickly as possible based on its priority and impact.”


### Service Request

A service request is a standard request from a user, such as access, software installation, or a new laptop.”

### Problem Management

“Problem Management is used when the same issue or incident occurs repeatedly. We investigate the root cause and take corrective or preventive action to avoid recurrence.”

### Change Management

“Change Management is used when we need to make a planned change in a production environment, such as upgrading a software version. We raise a change request, discuss the impact and risk with stakeholders, get approval, implement the change during the planned window, and verify the service after the change.”


### P1 / P2 / P3

“P1, P2, and P3 are incident priorities. We decide the priority based on business impact and urgency. Each priority can have different SLA targets. P1 is critical and requires immediate attention, while P2 and P3 have lower urgency.”


### SLA / SLO / SLI

SLA is the customer agreement. For example, we have to resolve the P1 ticket within 4 hours.

SLO is our internal target. We may keep a target to resolve it within 3 hours.

SLI is the actual measurement. For example, if we actually resolved the ticket in 2.5 hours, that is the measured result.

“For example, suppose we receive a P1 production ticket. SLA is the customer agreement. For example, we have to resolve the P1 ticket within 4 hours. SLO is our internal target. We may keep a target to resolve it within 3 hours. SLI is the actual measurement. For example, if we actually resolved the ticket in 2.5 hours, that is the measured result. So, SLA is customer commitment, SLO is internal target, and SLI is the actual measurement.”


### Monitoring vs Logging vs Alerting

Monitoring means continuously checking the health and performance of an application or infrastructure, such as CPU, memory, disk usage, and response time.
Logging means keeping records of application and system events, errors, and activities so we can troubleshoot issues.
Alerting means generating notifications when a defined threshold or condition is met. For example, high CPU can trigger an alert, then we check monitoring metrics and logs to find the issue.

### Escalation

“Escalation means transferring an incident to the appropriate next-level team when we are unable to resolve it at our level. We document our findings and troubleshooting steps in the ticket and escalate it to the relevant team, such as the DB, application, or network team.”

### RCA

“RCA means Root Cause Analysis. After resolving an incident, we investigate and document the actual root cause, impact, resolution, and preventive actions so that the same issue does not happen again.”


### Major / P1 Incident Management

“P1 is a critical incident with major business or customer impact, for example, the production application is completely down. We immediately inform the stakeholders, open a bridge call or communication channel, and troubleshoot the issue in parallel. Once the service is restored, we inform the stakeholders, document the resolution, and perform RCA to prevent recurrence.”

### Production Incident Communication

“During a production incident, we communicate the impact, current findings, troubleshooting status, and the actions we are taking to resolve the issue. We keep the stakeholders updated until the service is restored, and then communicate the resolution.”

