# Day 5 — Architecture Revision Questions 

## Q1. Explain Kubernetes architecture and its major components.

Kubernetes architecture consists of two main parts:

## Control Plane:- 
The Control Plane manages the cluster state and includes components like 

### API Server:- 
API Server is the main gatekeeper of Kubernetes. To communicate between two Kubernetes resources/components, the communication goes through API Server.
### etcd:- 
etcd is like a database in Kubernetes. It stores all the cluster information in key-value format, such as: Nodes, Pods, Deployments.
### Scheduler:- 
Scheduler decides on which Worker Node the new Pod will run, based on available resources.
### Controller Manager:- 
Controller Manager continuously checks the current and desired state of the cluster. If there is any mismatch, it takes action to match the current state with the desired state.


## Worker Nodes:- 
Worker Nodes are where our application runs and include 

### kubelet:- 
Kubelet is an agent running on every Worker Node. Its main job is to make sure all assigned Pods and containers are running properly on that Worker Node.
### Container runtime :- 
Container Runtime is responsible for creating and running containers inside the Pod.
### kube-proxy:- 
kube-proxy manages network traffic and sends Service traffic to the correct Pod.


## Q2. Explain the complete flow when you run: kubectl create deployment nginx --image=nginx from kubectl → API Server → etcd → Scheduler → kubelet → container. 

When we run a kubectl command, the request first goes to the API Server. API Server validates the request and stores the desired state in etcd. Scheduler identifies a suitable Worker Node for the Pod. After that kubelet on the selected node communicates with the container runtime to pull the image and run the container.

## Q3. A Pod is created but remains Pending. Which Kubernetes architecture component is responsible for selecting the node, and how would you troubleshoot it? 

kube-scheduler is responsible for assigning Pods to Worker Nodes. If a Pod is stuck in Pending state, I will first check ****kubectl describe pod**** events to identify the reason. Then I will check node resources,  and scheduling constraints to find why the scheduler is unable to assign the Pod

## Q4. What happens when a worker node becomes NotReady?

First I will check node status using ****kubectl get nodes****, then ****kubectl describe node**** to check events. After that I will verify kubelet status, kubelet logs, container runtime and node resource/network issues


# 1. Pod Pending

### Q1. A Pod is stuck in Pending state. How will you troubleshoot it?

For a Pending Pod, I will first run ****kubectl describe pod <pod-name>**** and check the Events section. Then I will verify node status using ****kubectl get nodes****, check resource availability using ****kubectl top nodes****, review scheduling constraints like node selectors and taints, and check PVC status if storage is involved. Based on the error message, I will fix the root cause.

### Q2. A Pod is Pending because the cluster does not have enough CPU/memory. How will you identify and resolve it?

First, I will run ****kubectl describe pod <pod-name>**** and check Events for insufficient CPU or memory errors. Then I will check node capacity using ****kubectl describe node**** and utilization using ****kubectl top nodes****. If resource requests are too high, I will optimize them. Otherwise, I will increase cluster capacity by adding more Worker Nodes or scaling resources.

### Q3. A Pod is Pending even though the nodes have enough resources. What Kubernetes scheduling-related things will you check?

If a Pod is Pending despite available resources, I will first check ****kubectl describe pod <pod-name>**** events. Then I will verify scheduling rules like nodeSelector, node affinity, taints and tolerations, and resource requests. The Scheduler places a Pod only when all scheduling conditions are satisfied.

# 2. CrashLoopBackOff

### Q4. A Pod is showing CrashLoopBackOff. What will you check first and how will you troubleshoot it?

For CrashLoopBackOff means the container is starting and repeatedly crashing, I first check ****kubectl describe pod**** and container logs using ****kubectl logs --previous**** to identify why the container is crashing. Then I check exit codes, application configuration, environment variables, probes and dependencies. After identifying the root cause, I fix the configuration or application issue and redeploy.

### Q5. A container starts and immediately exits. How will you identify the root cause?

If a container starts and immediately exits, I will first check ****kubectl logs**** and ****kubectl describe pod**** to identify the exit reason. Then I will verify the container command, arguments, application configuration, environment variables and external dependencies. Based on the error, I will fix the issue and redeploy the Pod.

### Q6. A Pod was running earlier but now shows CrashLoopBackOff. How will you check logs from the previous container instance?

For a Pod in CrashLoopBackOff, I will use ****kubectl logs <pod-name> --previous**** to check logs from the previous crashed container instance. I will also check ****kubectl describe pod**** for exit codes and termination reasons to identify the root cause

### Q7. A Pod is getting OOMKilled and then entering CrashLoopBackOff. How will you troubleshoot it?

For an OOMKilled Pod, I will first confirm the issue using ****kubectl describe pod**** and check the termination reason. Then I will check memory usage using kubectl top pod, review memory requests and limits, and check node resources. Based on the root cause, I will increase memory limits or optimize the application.

# 3. ImagePullBackOff / ErrImagePull

### Q8. A Pod is showing ImagePullBackOff. How will you troubleshoot it?

### Q9. The Deployment was created successfully, but Pods are showing ErrImagePull. What will you check?

### Q10. The application image is stored in a private registry and the Pod cannot pull it. How will you troubleshoot it?

# 4. Pod Not Ready

### Q11. A Pod is Running but READY shows 0/1. How will you troubleshoot it?

### Q12. A Pod's readiness probe is continuously failing. What will you check?

### Q13. Pods are Running but the Service has no usable backend because the Pods are NotReady. How will you troubleshoot it?

# 5. Service Not Accessible

### Q14. The Pod is Running but the application is not accessible through the Service. How will you troubleshoot it?

### Q15. A Service exists, but kubectl get endpoints shows no endpoints. What could be the reason?

### Q16. The Service selector is not matching the Pod labels. How will you identify and fix it?

### Q17. The Service has endpoints, but traffic is still not reaching the application. What will you check?

### Q18. The Service port is 80 but targetPort is wrong. How will you identify the issue?

# 6. Deployment / Rollout Problems

### Q19. A Deployment rollout is stuck and the new Pods are not becoming Ready. How will you troubleshoot it?

### Q20. A new application version was deployed, but the application is failing. How will you check the rollout history and rollback?

### Q21. During a Rolling Update, old Pods are terminating but new Pods are not becoming Ready. What will you investigate?

### Q22. How will you determine which ReplicaSet is currently serving the new version and which one represents the old version?

# 7. CPU / Memory Problems

### Q23. A Pod is consuming very high CPU. How will you troubleshoot it?

### Q24. A Pod is consuming more memory than expected. How will you investigate it?

### Q25. A container is repeatedly getting OOMKilled. What will you check and what possible fixes would you consider?

### 26. A Pod has CPU/memory requests and limits configured. Explain how you would troubleshoot a resource-related problem.

# 8. Node Problems

### Q27. A Kubernetes node suddenly changes to NotReady. How will you troubleshoot it?

### Q28. Pods are not getting scheduled on one particular node. What will you check?

### Q29. A node has sufficient CPU/memory, but Pods are still not being scheduled there. What Kubernetes configuration could cause this?

### Q30. How would you check whether a node has taints that are preventing Pod scheduling?

# 9. Ingress Problems

### Q31. The Service works internally, but the application is not accessible through Ingress. How will you troubleshoot it?

### Q32. Ingress exists, but requests are going to the wrong Service. What will you check?

### Q33. Ingress returns an error even though the backend Pods are Running. What components will you check?

### 34. Host-based routing is not working. How will you troubleshoot the Ingress rule?

### Q35. Path-based routing /api is not working, but / works. What will you check?

# 10. ConfigMap / Secret Problems

### Q36. The Pod is Running, but the application is using the wrong configuration value from ConfigMap. How will you troubleshoot it?

### Q37. A Pod is failing because a required environment variable is missing. How will you check whether it is coming from ConfigMap or Secret?

### Q38. A Secret exists, but the application cannot access the expected value. What will you check?

# 11. PVC / Storage Problems

### Q39. A PVC is stuck in Pending. How will you troubleshoot it?

### Q40. A Pod is stuck because its PVC cannot be mounted. What will you check?

### Q41. A Pod was recreated and the application data is still available. Explain how Kubernetes persistent storage made this possible.

# 12. DNS / Pod Connectivity

### Q42. One Pod cannot communicate with another Pod. How will you troubleshoot the connectivity issue?

### Q43. A Pod can reach another Pod by IP, but cannot reach it using the Kubernetes Service name. What will you investigate?

### Q44. A Pod cannot resolve my-service.nginx-ns.svc.cluster.local. How will you troubleshoot Kubernetes DNS?

# 13. RBAC

### Q45. A user can access the Kubernetes cluster but receives Forbidden when trying to list Pods. How will you troubleshoot the RBAC issue?

### Q46. A ServiceAccount is getting Forbidden when trying to access a Kubernetes resource. What will you check?

# 🔥Combined Production Scenarios


### Q47. Application is deployed and Pods are Running, but users are getting 503 Service Unavailable. Explain your complete troubleshooting approach.

### Q48. Pods are Running, Service exists, but Service has no endpoints. What will you check?

### Q49. Deployment is showing 3/3 Pods Ready, but users still cannot access the application. How will you troubleshoot from application → Pod → Service → Ingress?

### Q50. A new version was deployed successfully, but after deployment users started getting errors. What will you check and how would you rollback?

### Q51. Application was working yesterday. Today Pods are stuck in Pending. Nothing was changed in the Deployment YAML. How will you investigate?

### Q52. A Pod starts successfully but after some time gets OOMKilled. What commands will you use and what will you investigate?

### Q53. Service is working for some Pods but not others. What could cause this and how will you troubleshoot it?

### Q54. Ingress is working for / but /api returns an error. How will you troubleshoot the complete request path?

### Q55. A Pod can communicate with another Pod using its IP but cannot communicate using the Service DNS name. What is your troubleshooting approach?

### Q56. A user says, "The application is slow." How will you determine whether the problem is CPU, memory, Pod, Service, node, or application related?
