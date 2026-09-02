Kubernetes — Final 30 Interview Questions

# 🔵 A. Architecture & Core — 6

## Q1. Explain Kubernetes architecture and its major components.

Kubernetes architecture consists of two main parts:

#### Control Plane:-

The Control Plane manages the cluster state and includes components like:- API Server, etcd, Scheduler, Controller Manager

****API Server**** is the main gatekeeper of Kubernetes. To communicate between two Kubernetes resources/components, the communication goes through API Server.

****etcd**** is like a database in Kubernetes. It stores all the cluster information in key-value format, such as: Nodes, Pods, Deployments.

****Scheduler**** decides on which Worker Node the new Pod will run, based on available resources.

****Controller Manager**** continuously checks the current and desired state of the cluster. If there is any mismatch, it takes action to match the current state with the desired state.

#### Worker Nodes:-

Worker Nodes are where our application runs and include:- Kubectl, Kubeproxy, Container run time

****Kubelet**** is an agent running on every Worker Node. Its main job is to make sure all assigned Pods and containers are running properly on that Worker Node.

****Container Runtime**** is responsible for creating and running containers inside the Pod.

****kube-proxy**** manages network traffic and sends Service traffic to the correct Pod.



## Q2. Explain the complete flow when you run:kubectl apply -f deployment.yaml

When we run kubectl apply -f deployment.yaml, the request first goes to the API Server, where it is authenticated, authorized and validated. The desired state is stored in etcd. Then the Controller Manager works to maintain the desired state, and the Scheduler selects a suitable worker node for the Pod. The kubelet on that node detects the assigned Pod and asks the Container Runtime to pull the image and run the container

# 🟢 B. Workloads — 6

## Q3. What is a Pod and why do we use it?

A Pod is the smallest deployable unit in Kubernetes and can contain one or more containers that share networking and storage.

## Q4. Explain the difference between Pod, ReplicaSet, Deployment, StatefulSet and DaemonSet.

A Pod is the smallest deployable unit in Kubernetes and can contain one or more containers that share networking and storage.

A ReplicaSet ensures that the desired number of Pod replicas are running.

A Deployment manages ReplicaSets and provides features like rolling updates and rollbacks.

A StatefulSet is used for stateful applications where Pods need stable identities and often stable storage. For example, Pods can have names like mysql-0, mysql-1, and mysql-2.

A DaemonSet ensures that a Pod runs on every eligible node, commonly for logging, monitoring, or other node-level agents.

## Q5. What happens when a Pod managed by a Deployment crashes?

If a Pod managed by a Deployment crashes, the ReplicaSet associated with the Deployment detects that the actual number of Pods is lower than the desired number. It creates a replacement Pod. The Scheduler assigns the new Pod to a suitable node, then the Kubelet asks the container runtime to start the container. This brings the application back to the desired replica count.

## Q6. How do you scale a Deployment?

We can manually scale a Deployment by changing the replicas value in the Deployment manifest or by using kubectl scale deployment <name> --replicas=<number>. For automatic scaling, we use HPA, which adjusts the number of replicas based on metrics such as CPU or memory utilization within the configured minimum and maximum replica limits.

## Q7. How do you perform a Rolling Update in Kubernetes?

A Rolling Update gradually replaces the old version of Pods with the new version without bringing the entire application down. For example, if four Pods are running with image v1, Kubernetes gradually replaces them with Pods running image v2 according to the Deployment's rolling update strategy. We can update the image using kubectl set image, and monitor the update using kubectl rollout status

## Q8. How do you rollback a Deployment?

If the newly deployed version has an issue, I would first check the Deployment rollout history. If the previous revision is stable, I can rollback using kubectl rollout undo deployment/<name>. If I need to rollback to a specific revision, I can use --to-revision. Then I would verify the rollout status and application health.

# 🟡 C. Services, Networking & Ingress — 6

## Q9. What is a Kubernetes Service and why do we need it?

A Kubernetes Service provides a stable network endpoint. We need it because Pod IPs can change when Pods are recreated

## Q10. Explain the difference between ClusterIP, NodePort and LoadBalancer.

****ClusterIP**** provides a stable endpoint for internal communication inside the Kubernetes cluster.

****NodePort**** provides a stable endpoint for  external access to the application through a port on the Kubernetes node.

****LoadBalancer**** provides a stable endpoint for  external access to the application through a load balancer.

## Q11. A Service exists but the application is not accessible. How will you troubleshoot it?

First, I will check the Pod status, logs, and describe the Pod to find the error. Then I will check whether the Service selector matches the Pod labels.

## Q12. A Service has no Endpoints. What will you check?

First, I will check the Service selector and Pod labels. Then I will check whether the Pods are running and ready.


## Q13. If we already have a LoadBalancer Service, why do we need Ingress and an Ingress Controller?

LoadBalancer provides a stable endpoint for external access to an application. Ingress allows us to define host or path-based routing for multiple applications. The Ingress Controller reads the Ingress configuration and forwards the traffic to the correct Service.

## Q14. Explain the traffic flow from Ingress → Service → Pod.

Ingress sends traffic to the Service. The Service uses its selector to find the correct Pods and forwards the traffic to them.

## Q15. A Pod can access another Pod using its IP, but it cannot access the Service using the Service name, for example my-service.default.svc.cluster.local. How will you troubleshoot this issue?

"First, I will check the CoreDNS Pods are running. Then I will check the CoreDNS logs and test DNS resolution from inside a Pod using nslookup. After that, I will check the kube-dns Service."

# 🔴 D. Troubleshooting — 7 ⭐

## Q16. A Pod is stuck in Pending state. How will you troubleshoot it?

First, I will identify the Pod that is in Pending state using kubectl get pods.

Then I will run kubectl describe pod <pod-name> and check the Events section to identify the exact reason why the Pod is not being scheduled.

Based on the error, I will check CPU/memory resources, node availability, nodeSelector, and PVC issues. If required, I will also check Kubernetes events using kubectl get events.

After resolving the issue, I will verify that the Pod changes from Pending to Running.

## Q17. A Pod is Pending even though nodes have enough resources. What scheduling-related things will you check?

If the nodes have enough resources but the Pod is still Pending, I will check kubectl describe pod <pod-name> and look at the Events section. I will check scheduling-related settings such as nodeSelector, taints and tolerations, and node affinity to find the exact reason.

## Q18. A Pod is showing CrashLoopBackOff. What will you check first and how will you troubleshoot it?

First, I will check the Pod status using kubectl get pods.

Then I will run kubectl describe pod <pod-name> and check the Events section.

After that, I will check the container logs using kubectl logs <pod-name>. If the container has restarted, I will also check the previous logs using kubectl logs <pod-name> --previous.

I will identify the exact error, such as an application error, configuration issue, wrong command, permission issue, or missing dependency, and fix the root cause.

Finally, I will verify that the Pod is running successfully.

## Q19. A container starts and immediately exits. How will you identify the root cause?

First, I will check the Pod status using kubectl get pods.

Then I will use kubectl describe pod <pod-name> and check the Events section.

After that, I will check the container logs using kubectl logs <pod-name>. If it has restarted, I will use kubectl logs <pod-name> --previous.

I will also check the container command, configuration, environment variables, and exit code to identify why the container is exiting.

Based on the root cause, I will fix the issue and verify that the container remains running.

## Q20. A Pod is showing ImagePullBackOff / ErrImagePull. How will you troubleshoot it?

First, I will identify the Pod using kubectl get pods. Then I will run kubectl describe pod <pod-name> and check the Events section for the exact image-pull error. I will verify the image name and tag, check whether the image exists in the registry, and if it is a private registry, I will check the image pull credentials or imagePullSecrets. I will also check registry connectivity if required. After fixing the issue, I will verify that the Pod starts successfully.

## Q21. A Pod is getting OOMKilled and then entering CrashLoopBackOff. How will you troubleshoot it?

First, I will check the Pod status using kubectl get pods.

Then I will run kubectl describe pod <pod-name> and check the Events and container state to confirm the Pod was OOMKilled.

After that, I will check the memory usage inside the container using kubectl exec and top to identify which process is consuming high memory.

I will discuss the findings with the application team to identify why the application is consuming more memory.

If required, and after proper analysis and approval, I will increase the memory resource limit and monitor the Pod to make sure the issue is resolved.

## Q22. A Worker Node becomes NotReady. How will you troubleshoot it?

First, I will check the Node status using kubectl get nodes. Then I will run kubectl describe node <node-name> and check the Node Conditions and Events to identify the exact reason for the NotReady state. Based on the error, I will check the kubelet, disk space, memory or CPU pressure, container runtime, and network connectivity. I will resolve the root cause and then verify that the Node changes back to Ready.

# 🟣 E. Configuration, Storage & Autoscaling — 5

## Q23. What is a ConfigMap and how is it used?

ConfigMap is used to store non-sensitive configuration data, such as application settings, environment variables, or application paths. We can then integrate the ConfigMap with the Deployment YAML and inject the values into the Pod as environment variables or mount them as configuration files.
One important point: Kubernetes Secrets are not automatically strongly encrypted just because they are Secrets; by default, their values are base64-encoded

## Q24. What is a Secret and how is it used?

Secret is used to store sensitive data such as database passwords, API keys, or tokens. We can integrate the Secret with the Deployment YAML and inject the values into the Pod as environment variables or mount them as files.”

## Q25. Explain PV, PVC and StorageClass.

PersistentVolume (PV) is a storage resource in Kubernetes, and PersistentVolumeClaim (PVC) is a request to claim storage from a PV. StorageClass defines how storage is dynamically provisioned, for example using AWS EBS, NFS, or local storage depending on the environment. If a PVC is stuck in Pending, I would check whether a suitable PV is available, storage capacity, access permissions, and StorageClass or provisioner issues. For a Multi-Attach error, I would check whether the volume is already attached to another node and verify the Pod and PV status using kubectl describe.


## Q26. What is HPA and how does it work?

HPA stands for Horizontal Pod Autoscaler. It automatically scales the number of Pods based on resource utilization such as CPU or memory. For example, if we set the target CPU utilization to 70% and the utilization goes above the target, HPA increases the number of Pods up to the configured maxReplicas. When the load decreases, it scales the Pods down, but not below the configured minReplicas.


## Q27. A Deployment is created successfully, but Pods are not becoming Ready. How will you troubleshoot it?

“First, I will check the Pod status using kubectl get pods. Then I will use kubectl describe pod and check the Events section. I will also check the Pod logs and previous logs if required. Depending on the error, I will check readiness probe, container/application health, service or configuration issues, resource limits, node selector or affinity, and taints and tolerations. Based on the root cause, I will fix the issue or coordinate with the respective team.”


## Q28सेट ई में एक स्टोरेज ट्रबलशूटिंग का सवाल ऐड करना होगा।

# 🅵 Set F — 
Production Scenarios + Interview Q&AF ka fixed question list abhi define nahi hai.Ismein hum daily:
Production 
scenariosInterview 
follow-upsCross-topic 
troubleshootingReal 
interview-style questions
