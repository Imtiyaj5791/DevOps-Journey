# SECTION A: CORE ARCHITECTURE - 10 Qs

## 1. What is Kubernetes and why do we use?

Kubernetes is a container orchestration tools for managing containers at scale.
In production with microservices, we need auto-healing, auto-scaling, service discovery, load balancing and zero-downtime deployments. 
Kubernetes provides all of that declaratively, which is why we use EKS in production. 

## 2. Explain K8s Architecture.

" K8s has 2 parts - Control Plane and Worker Nodes.

Control Plane has 4 components:

API Server - entry point, all requests go through 

etcd - key-value database, stores all cluster state

Scheduler - decides which node pod will go to based on resource

Controller Manager - maintains desired state, like ensuring 3 replicas are running

Worker Node has 3 components:

Kubelet - agent that ensures pods are running on that node

Kube-proxy - handles networking and service routing

Container Runtime - containerd, which actually runs containersIn EKS, AWS manages control plane, we only manage worker nodes."

## 3. What is etcd and how do you backup/restore it?

etcd is the cluster database storing all data in key-value format. We take snapshot backup using etcdctl snapshot save command. 
But since we use EKS, AWS manages etcd backup automatically, we don't do it manually.

## 4. What is Pod? Why we use Deployment not Pod?

Pod is the smallest deployable unit in Kubernetes. It can have 1 or multiple containers, but those containers share same network,
same storage and same lifecycle. They are tightly coupled.

## 5. Deployment vs StatefulSet vs DaemonSet?

Deployment is mainly used for stateless applications. It manages ReplicaSets and provides features like application updates and rollback.
StatefulSet is used for stateful applications where Pods need stable names, stable network identity, and persistent storage.
DaemonSet is run on worker nodes and it is basically used for monitoring and logging. It ensures one Pod runs on each worker node.

## 6. What is Namespace and why use it?

Namespace helps us logically separate, organize, and manage resources in the same Kubernetes cluster.

## 7. What is Kubelet?

"Kubelet is an agent, installed on every worker node. It checks health status of pod and it communicates with API server. 
It makes sure pod is running."

## 8. What are Static Pods?

Static Pod is managed directly by Kubelet, not by API Server. Kubelet itself creates it. 
We put manifest file in /etc/kubernetes/manifests folder, then Kubelet will read and create pod.
Example: kube-apiserver, etcd, controller-manager are static pods

## 9. What happens when you run kubectl apply -f deployment.yaml?

"When we run kubectl apply, this is the flow:

kubectl sends the YAML file to the API Server.

API Server authenticates the request and validates the YAML.

API Server saves the deployment data in etcd.

Scheduler sees there is a new pod to schedule, and it selects a worker node based on resources.

Controller Manager sees the desired state is 3 replicas but current is 0, so it creates the pods.

Kubelet on each worker node watches the API Server, and when it sees a pod assigned to its node, it tells the container runtime (containerd) to run the pod."

## 10. What is difference between Docker and ContainerD?

Docker is a containerization tool which is used to build, run, manage and share application inside lightweight containers
containerd is a part of Docker which actually runs the containers in background. Docker uses containerd inside.

# SECTION B: WORKLOADS & CONFIG - 10 Qs

## 11. What is difference between Request and Limit?

Request is what Kubernetes needs to schedule the pod. Like if I say request 100MB, scheduler will find a node which has at least 100MB free
Limit is the maximum a pod can use. Like if limit is 500MB, pod can use up to 500MB max, it cannot cross it.
If pod tries to cross memory limit, it gets OOMKilled.


## 12. What is ConfigMap and Secret? Best practice?

ConfigMap is used to store non-sensitive data like port number, app name, config.
Secret is used to store sensitive data like DB password, API keys, secret keys. Secret data is base64 encoded.

## 13. Explain PV, PVC, StorageClass.
PV is the actual storage, like a hard disk in cluster.
PVC is the request for storage. Like pod says 'I need 10GB', that is PVC.
StorageClass defines how storage will be provisioned for a Kubernetes application. In EKS, 
it is commonly used to dynamically create EBS volumes through the EBS CSI driver

## 14. Liveness vs Readiness vs Startup Probe?

Liveness Probe: Checks if pod is alive. If dead, it restarts the pod.
Readiness Probe: Checks if pod is ready for traffic. If not ready, no traffic is sent.
Startup Probe: Checks if app has started. Used for slow-starting apps.

## 15. What is Init Container and Sidecar?

Init container is a container that runs first to do setup work before main app starts.
Sidecar is a second container in pod that helps main container, like sending logs.

## 16. What is HPA and how it works?

HPA automatically increases or decreases pods based on resource utilization like CPU and Memory.
For example, if traffic is high and CPU goes above 70%, HPA will add more pods. And if traffic is low, it will remove pods to save cost.

## 17. What is Helm?

Helm is a package manager for Kubernetes.
It helps to install and manage full applications with one command.
We use values.yaml file to change configuration and deploy easily. We don't need to apply many yaml files one by one.

helm create myapp
helm install myapp ./myapp -n nginx-ns
helm upgrade myapp ./myapp -n nginx-ns (pod 1 to 3)

## 18. What is Job vs CronJob?

Job runs only one time. After finishing work, it stops.Example: Database backup one time.
CronJob runs on a schedule, again and again. Like an alarm.Example: Database backup every day at 10 PM.

## 19. What is Rolling Update strategy?

Rolling Update is a strategy to update application with zero downtime.
It gradually replaces old pods with new pods one by one. So users face no downtime.
If we have 5 pods, it will gradually delete old version and create new version until all pods are new.

## 20. How to do Canary or Blue-Green in K8s?

In Canary, we send small traffic to new version first to test. If stable, we gradually send all traffic
In Blue-Green, we have two environments. Blue is old live version, Green is new. After testing green, we switch all traffic from blue to green at once."

# SECTION C: NETWORKING & SECURITY - 10 Qs

## 21. ClusterIP vs NodePort vs LoadBalancer vs Ingress?

ClusterIP is mainly used for internal communication within the Kubernetes cluster

NodePort is used for external communication. It exposes the Service through: Node IP + NodePort

LoadBalancer is used for external communication through an external/cloud Load Balancer. It provisions one AWS ELB per Service.
It is costly so we avoid it in production.

Ingress is used for external communication in production with a single Load Balancer. It provides path-based and host-based 
routing through one AWS ALB. Example: /api -> backend-service, / -> frontend-service


## 22. How does Service discovery work? What is CoreDNS?

Service discovery is the way Pods find each other by service name instead of IP address. When you create a Service, 
Kubernetes gives it a fixed name and a fixed ClusterIP. So even if Pod IPs change, other Pods can still find it using that service name.

CoreDNS is the internal DNS server of Kubernetes. It stores the mapping of service name to ClusterIP.
For example, if you have a service named backend-service, you can call http://backend-service from any Pod. 
CoreDNS will resolve it to its ClusterIP.

## 23. What is CNI? Which CNI you used?

CNI stands for Container Network Interface. It is a plugin that gives IP addresses to Pods and allows Pods to talk to each other. 
Without CNI, Pods cannot communicate.
Which CNI I used: In our EKS project we used AWS VPC CNI. In this CNI, every Pod gets a real IP address from the VPC itself.

## 24. What is NetworkPolicy?

NetworkPolicy is like a firewall for Pods.By default, all Pods can talk to each other. NetworkPolicy is used to control which Pod can talk
to which Pod.For example, you can create a rule that frontend Pod can only talk to backend Pod, but cannot talk to database Pod directly.
 
## 25. What is RBAC?

RBAC stands for Role-Based Access Control.It is used to control who can do what in the Kubernetes cluster.
Example: You can give developers permission to only view Pods, but not delete Pods. And give admin full access.
Main parts of RBAC:
Role / ClusterRole - What permissions (like get, list, delete pods)
RoleBinding / ClusterRoleBinding - Who gets that permission (like a User or ServiceAccount)

## 26. How do you secure K8s in production?

We secure K8s in production in 4 layers:

1. Cluster Access - RBAC:
We use RBAC so developers get only view access, not delete access. No one uses admin directly.

2. Pod Security - NetworkPolicy & SecurityContext:
We use NetworkPolicy to control Pod to Pod communication. And we run containers as non-root user with read-only filesystem.

3. Secrets & Images:
We never put passwords in YAML. We use AWS Secrets Manager / K8s Secrets. And we scan images for vulnerabilities and use only private ECR images.

4. Cluster Level:
We enable private EKS cluster, enable audit logging, and keep Kubernetes version updated.

## 27. What is ServiceAccount and IRSA?

ServiceAccount = The identity used by a Pod to authenticate to the Kubernetes API Server.
IRSA: Stands for IAM Roles for Service Accounts.
It is AWS EKS specific. It allows a Pod to access AWS services securely.
Example: If your Pod wants to access S3, you attach an IAM Role (with S3 access) to the ServiceAccount. Then that Pod can access S3.
No need to put AWS keys inside the Pod.

## 28. What is difference between Ingress and LoadBalancer Controller?
Ingress - It is just a rulebook / a Kubernetes object. It only contains routing rules like if path is /api, go to api-service. 
It cannot do anything by itself.

Ingress Controller / LoadBalancer Controller - It is the actual engine that implements those rules. e.g., NGINX Controller, 
AWS Load Balancer Controller. Without a controller, Ingress rules do nothing.

SECTION D: PRODUCTION & CLOUD - 10 Qs - MOST IMPORTANT FOR YOU

## 29. Pod is in CrashLoopBackOff, how to troubleshoot?

If a pod is in CrashLoopBackOff, first I check the logs using kubectl logs and kubectl logs --previous to see why the application crashed, 
then I do kubectl describe pod to check the exit code and events for OOMKilled or probe failures. In most cases it's an application issue 
like wrong environment variables, database connection failure, resource limits being too low, or liveness probe failing.

## 30. Pod is in Pending, why?

When a pod is in Pending, I check the describe section to see events, it is usually because of insufficient CPU or memory on nodes,
PVC not bound, or nodeSelector and taint mismatch.

## 31. Node is NotReady, what to do?

If a node is NotReady, I check the node status with kubectl describe node to see events, then I log into the node to check kubelet status, 
disk pressure, memory pressure and network issues, and if needed I restart kubelet.

## 32. Your API returns 5xx but pod is Running - steps?

If API returns 5xx but pod is Running, the app inside may be down even though container is running. I check pod logs, 
then describe pod for readiness probe failure, and check service endpoints whether it is pointing to the pod
502 Bad Gateway means backend is not reachable, like app crashed or wrong port.
For 502 I check if app is listening on correct port and check pod logs if app crashed.

503 Service Unavailable means service has no ready endpoints, like readiness probe failing or pods are overloaded.
For 503 I check kubectl get endpoints and readiness probe, because service has no ready pods.

504 Gateway Timeout means backend is too slow to respond.
For 504 I check if app is slow, increase timeout and check HPA and resource usage and DB slowness.

## 33. How to rollback a bad deployment?

I rollback using kubectl rollout undo deployment <name> to go to previous version, 
and if I need a specific version then I use kubectl rollout undo deployment <name> --to-revision=<number>, 
and after that I check rollout status.

## 34. How to do zero-downtime deployment?

For zero-downtime I use RollingUpdate strategy with maxSurge and maxUnavailable set properly and add readiness probe 
so traffic only goes to ready pods and old pods terminate only after new pods are ready.

## 35. How do you monitor K8s in production?

In production I monitor K8s using Prometheus for metrics, Grafana for dashboards, Loki or ELK for logs, and alertmanager for alerts, 
and I monitor pod CPU memory, node health, pod restarts and API latency.

## 36. How to reduce cost in EKS/GKE?

To reduce cost I use cluster autoscaler and HPA to scale down unused nodes, use spot instances for non-critical workloads, 
set proper resource requests and limits to avoid over-provisioning, and clean up unused PVCs, LoadBalancers and old images.

## 37. What is Cluster Autoscaler vs Karpenter vs HPA?

HPA scales pods based on CPU or memory or custom metrics, 
Cluster Autoscaler scales nodes based on pending pods but slow and tied to node groups,
Karpenter is faster and directly provisions right-sized nodes without node groups so more cost-efficient.

## 38. How do you manage secrets in EKS?

I manage secrets in EKS using AWS Secrets Manager or Parameter Store with External Secrets Operator, and enable encryption at rest using KMS, 
and avoid using plain K8s secrets in git and use RBAC and short-lived secrets.

## 39. What is PDB and why needed?

PDB = PodDisruptionBudget. It defines minimum number of pods that must stay available during voluntary disruptions like node drain or upgrade.
For example if I have 3 replicas and PDB says minAvailable 2, then Kubernetes will not drain or kill more than 1 pod at a time, so app stays up.

## 40. Tell me about your EKS production setup? (They will ask this)

My production EKS setup is like this:

Cluster: EKS 1.29+ private cluster across 3 AZs, managed node groups + Karpenter for spot.
Networking: VPC with private subnets, ALB Ingress Controller for external traffic, Calico for network policies.
Deployment: Helm + ArgoCD for GitOps, RollingUpdate with readiness/liveness probes, PDB for HA.
Scaling: HPA on CPU/memory + Cluster Autoscaler/Karpenter.
Observability: Prometheus + Grafana for metrics, Loki for logs, CloudWatch + Alertmanager.
Security: IRSA for AWS permissions, Secrets via External Secrets Operator + Secrets Manager, KMS encryption, RBAC.
CI/CD: Jenkins/GitHub Actions builds image -> ECR -> ArgoCD auto-sync to EKS.

## 41 How to Use secret in K8s Aws seret manager

Step 1: Create IAM role with EKS Pod Identity and secretsmanager:GetSecretValue.
Step 2: Create secret in AWS Secrets Manager.
Step 3: Create EKS Pod Identity Association and map IAM role to ServiceAccount.
Step 4: Install/enable Secrets Store CSI Driver + AWS provider.
Step 5: Create SecretProviderClass for the AWS secret.
Step 6: Mount the CSI volume in the Deployment so the Pod can read the secret.


## 42 How to use EBS as storage in K8s

Step 1: Create IAM role for the EBS CSI Driver with the required EBS permissions using EKS Pod Identity.
Step 2: Install/enable the Amazon EBS CSI Driver EKS add-on and associate the IAM role with it.
Step 3: Create a PVC requesting the required storage size.
Step 4: Apply the PVC; Kubernetes dynamically provisions a PV through the StorageClass and EBS CSI Driver.
Step 5: AWS EBS volume is provisioned and the PV gets Bound to the PVC.
Step 6: Reference the PVC in the Deployment and mount it inside the Pod, for example at /data.
Step 7: Verify that the Pod is using the PVC and the EBS volume is successfully attached.

PVC → StorageClass/CSI → PV → EBS → Pod

