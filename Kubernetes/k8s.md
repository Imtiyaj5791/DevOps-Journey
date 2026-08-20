# Kubernetes Notes 

## What is Kubernetes?

Kubernetes is a container orchestration tool used to deploy, manage and scale containerized applications.

For example, if we have 20 containers, Kubernetes helps us manage all these containers.

---

## Why Do We Need Kubernetes?

Let's assume we have a large number of containers running in production.

- If traffic increases, we need to increase containers.
- If traffic decreases, we can reduce containers.
- If any container crashes, we need to replace it.
- If we have a new application version, we need to update containers safely.
- If any server/node goes down, we need to keep the application running.

Managing all these things manually is difficult, so we use Kubernetes to manage them automatically.

---

## Kubernetes Cluster

A Kubernetes cluster is a group of nodes where we run and manage our containerized applications.

---

# Kubernetes Architecture

Kubernetes architecture is mainly divided into two parts:

1. Control Plane
2. Worker Nodes

The **Control Plane** manages the Kubernetes cluster.

The **Worker Nodes** are where our application Pods and containers run.

### Control Plane Components

- API Server
- Scheduler
- etcd
- Controller Manager

### Worker Node Components

- kubelet
- kube-proxy
- Container Runtime

---

## API Server

API Server acts as the main entry point and gatekeeper of the Kubernetes cluster.

If Kubernetes components need to communicate with each other, they communicate through the API Server.

When we send a request using `kubectl`, it first goes to the API Server.

The API Server authenticates, authorizes and validates the request.

### Remember

`kubectl → API Server`

---

## etcd

etcd acts like a database for Kubernetes.

It stores Kubernetes cluster state and configuration information in key-value format, such as information about Nodes, Pods and Deployments.

### Remember

`etcd = Kubernetes cluster state database`

---

## Scheduler

Scheduler decides on which Worker Node a new Pod should run based on available resources and scheduling requirements.

### Remember

`Scheduler = Select Worker Node for Pod`

---

## Controller Manager

Controller Manager continuously checks the current state and desired state of the cluster.

If there is a mismatch, it takes action to bring the current state to the desired state.

Example:

`Desired Pods = 3`

`Current Pods = 2`

Kubernetes takes action to bring the number back to 3.

### Remember

`Controller Manager = Current State vs Desired State`

---

# Worker Node

## kubelet

Kubelet is an agent running on every Worker Node.

Its main job is to make sure the Pods assigned to that Worker Node are running properly.

### Remember

`kubelet = Agent on Worker Node`

---

## kube-proxy

kube-proxy manages network traffic on the Worker Node and helps send Service traffic to the correct Pod.

### Remember

`kube-proxy = Service Traffic → Correct Pod`

---

## Container Runtime

Container Runtime is responsible for running and managing containers inside Pods.

Examples:

- containerd
- CRI-O

### Remember

`Container Runtime = Run Containers`

---

# If One Pod Crashes — Flow

Assume one Pod becomes unhealthy.

1. Kubelet detects/reports the Pod status.
2. Status is communicated through the API Server.
3. Kubernetes controllers compare the current state with the desired state.
4. If a replacement Pod is required, Kubernetes creates the required Pod.
5. Scheduler decides which Worker Node should run the new Pod.
6. Kubelet on that Worker Node receives the Pod assignment.
7. Kubelet works with the Container Runtime to run the containers.

### Easy Flow

`Pod Problem → kubelet → API Server → Controller → Scheduler → kubelet → Container Runtime`

---

# Kubernetes Core Objects

## Pod

Pod is the smallest deployable unit in Kubernetes.

A Pod can contain one or more containers. Normally, we run one main application container inside a Pod.

### Remember

`Pod → Container`

---

## ReplicaSet

ReplicaSet maintains the required number of Pods.

For example, if we define 3 replicas and one Pod goes down or gets deleted, ReplicaSet ensures a new Pod is created to maintain 3 Pods.

### Example

`Required = 3 Pods`

`1 Pod Deleted`

`Current = 2 Pods`

`ReplicaSet → Bring it back to 3 Pods`

### Remember

`ReplicaSet = Maintain Required Pods`

---

## Deployment

Deployment manages ReplicaSets.

Deployment is also used for application updates and rollbacks.

### Flow

`Deployment → ReplicaSet → Pods`

### Remember

`Deployment = Manage ReplicaSet + Update + Rollback`

---

## Service

Service provides a stable endpoint to access Pods because Pod IP addresses can change.

If a Pod is deleted and recreated, its IP may change, but the Service endpoint remains stable and sends traffic to the available Pods.

### Example

`Service → Pod-1 / Pod-2 / Pod-3`

### Remember

`Service = Stable Endpoint`

`Pod IP = Can Change`

---

## Namespace

Namespace is used to separate and organize resources inside the same Kubernetes cluster.

For example, we can create separate namespaces for Dev, Test and Prod.

Each namespace can have its own Pods, Services and Deployments.

### Example

`One Kubernetes Cluster`

`→ DEV Namespace`

`→ TEST Namespace`

`→ PROD Namespace`

### Remember

`Namespace = Separate + Organize Resources in Same Cluster`

---

# Quick Revision

`Kubernetes = Container Orchestration`

`Cluster = Control Plane + Worker Nodes`

`API Server = Main Entry Point / Gatekeeper`

`etcd = Cluster State Database`

`Scheduler = Select Worker Node for Pod`

`Controller Manager = Current State vs Desired State`

`kubelet = Worker Node Agent`

`kube-proxy = Service Traffic → Correct Pod`

`Container Runtime = Run Containers`

`Pod = Smallest Deployable Unit`

`ReplicaSet = Maintain Required Pods`

`Deployment = Manage ReplicaSet + Update + Rollback`

`Service = Stable Endpoint for Pods`

`Namespace = Separate + Organize Resources in Same Cluster`
