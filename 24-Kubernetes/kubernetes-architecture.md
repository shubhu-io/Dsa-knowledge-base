# Kubernetes Architecture

## Overview

Kubernetes follows a master-worker architecture where the control plane manages the cluster and worker nodes run the actual workloads.

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    Kubernetes Cluster                            │
│                                                                  │
│  ┌──────────────── Control Plane (Master) ────────────────────┐  │
│  │                                                             │  │
│  │  ┌──────────┐  ┌────────────┐  ┌───────────────────────┐  │  │
│  │  │   API    │  │ Scheduler  │  │  Controller Manager   │  │  │
│  │  │  Server  │  │            │  │                       │  │  │
│  │  └────┬─────┘  └─────┬──────┘  │  ┌─────────────────┐  │  │  │
│  │       │              │         │  │ Node Controller  │  │  │  │
│  │       │              │         │  │ Replica Ctrl     │  │  │  │
│  │       │              │         │  │ Endpoint Ctrl    │  │  │  │
│  │       │              │         │  │ Service Account  │  │  │  │
│  │       │              │         │  └─────────────────┘  │  │  │
│  │       │              │         └───────────────────────┘  │  │
│  │       │              │                                     │  │
│  │  ┌────▼──────────────▼─────────────────────────────────┐  │  │
│  │  │                     etcd                            │  │  │
│  │  │           (distributed key-value store)              │  │  │
│  │  └─────────────────────────────────────────────────────┘  │  │
│  └─────────────────────────────────────────────────────────────┘  │
│                            │                                      │
│                    ┌───────▼───────┐                              │
│                    │  Cloud Ctrl   │                              │
│                    │  Manager      │                              │
│                    └───────────────┘                              │
│                                                                  │
│  ┌──── Worker Node 1 ────┐  ┌──── Worker Node 2 ────┐          │
│  │                        │  │                        │          │
│  │  ┌────────┐ ┌────────┐│  │  ┌────────┐ ┌────────┐│          │
│  │  │ kubelet│ │kube-   ││  │  │ kubelet│ │kube-   ││          │
│  │  │        │ │proxy   ││  │  │        │ │proxy   ││          │
│  │  └───┬────┘ └────────┘│  │  └───┬────┘ └────────┘│          │
│  │      │                │  │      │                │          │
│  │  ┌───▼──────────────┐ │  │  ┌───▼──────────────┐ │          │
│  │  │ Container Runtime│ │  │  │ Container Runtime│ │          │
│  │  │ (containerd)     │ │  │  │ (containerd)     │ │          │
│  │  └───┬──────┬───────┘ │  │  └───┬──────┬───────┘ │          │
│  │  ┌───▼──┐┌──▼───┐     │  │  ┌───▼──┐┌──▼───┐     │          │
│  │  │Pod A ││Pod B │     │  │  │Pod C ││Pod D │     │          │
│  │  │┌───┐ ││┌───┐ │     │  │  │┌───┐ ││┌───┐ │     │          │
│  │  ││ C │ │││ C │ │     │  │  ││ C │ │││ C │ │     │          │
│  │  │└───┘ ││└───┘ │     │  │  │└───┘ ││└───┘ │     │          │
│  │  └──────┘└──────┘     │  │  └──────┘└──────┘     │          │
│  └────────────────────────┘  └────────────────────────┘          │
└─────────────────────────────────────────────────────────────────┘
```

## Control Plane Components

### API Server
The front-end for the Kubernetes control plane. All communication goes through the API server.

- RESTful API (kubectl, UI, SDKs all talk to API server)
- Authentication and authorization (RBAC)
- Admission control (validation/mutation webhooks)
- Stores nothing itself - delegates to etcd

```bash
# API server communicates with
kubectl get pods           # User -> API Server
kubelet heartbeats         # Worker -> API Server
controller reconciliation  # Controllers -> API Server
```

### etcd
Distributed key-value store that holds all cluster state.

- Stores: nodes, pods, secrets, config, state
- Raft consensus algorithm for consistency
- Backup etcd = backup entire cluster state

```bash
# Backup etcd
ETCDCTL_API=3 etcdctl snapshot save backup.db \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key
```

### Scheduler
Assigns pods to nodes based on:
- Resource requirements
- Node affinity/anti-affinity
- Taints and tolerations
- Pod affinity/anti-affinity
- Data locality

### Controller Manager
Runs reconciliation loops to maintain desired state.

| Controller | Purpose |
|-----------|---------|
| Node Controller | Monitors node health |
| Replica Controller | Maintains pod replica count |
| Deployment Controller | Manages rollouts |
| Endpoint Controller | Populates Endpoint objects |
| Service Account Controller | Creates default service accounts |

## Worker Node Components

### Kubelet
Agent running on each worker node.
- Watches API server for pod assignments
- Manages pod lifecycle via container runtime
- Reports node status back to API server
- Runs health checks (liveness, readiness)

### Kube-proxy
Maintains network rules for service routing.
- Implements Services abstraction
- Load balances across pods
- Modes: iptables (default), IPVS

### Container Runtime
Runs actual containers. Supports:
- containerd (most common)
- CRI-O
- Docker (deprecated since 1.24)

## Pod Lifecycle

```
Pending ──► Running ──► Succeeded/Failed
   │            │
   │            ├──► CrashLoopBackOff (restart loop)
   │            │
   │            └──► Terminating (shutdown)
   │
   └──► ImagePullBackOff (can't pull image)
   └──► Pending (unscheduled)
```

```bash
# Check pod status
kubectl get pods -o wide
kubectl describe pod <pod-name>
kubectl get pod <pod-name> -o jsonpath='{.status.phase}'
```

## Control Flow Example

```
1. User runs: kubectl apply -f deployment.yaml
2. API Server validates & stores desired state in etcd
3. Scheduler detects unassigned pods, assigns to nodes
4. Kubelet on target node detects new pod assignment
5. Kubelet tells container runtime to pull image & start container
6. Kubelet reports pod status back to API Server
7. API Server updates state in etcd
8. Controller manager watches for drift, reconciles as needed
```

## High Availability Setup

```
┌──────────┐  ┌──────────┐  ┌──────────┐
│  Master 1│  │  Master 2│  │  Master 3│
│ API Srv  │  │ API Srv  │  │ API Srv  │
│ etcd     │  │ etcd     │  │ etcd     │
└────┬─────┘  └────┬─────┘  └────┬─────┘
     │              │              │
     └──────────────┼──────────────┘
                    │
    ┌───────────────┼───────────────┐
    │               │               │
┌───▼───┐     ┌────▼────┐    ┌────▼───┐
│Worker1│     │ Worker 2│    │Worker 3│
│       │     │         │    │        │
│ Pods  │     │  Pods   │    │  Pods  │
└───────┘     └─────────┘    └────────┘
```

**Minimum for HA**: 3 master nodes, 3+ worker nodes, load balancer in front of API servers.

## Key Concepts Summary

| Component | Role | Type |
|-----------|------|------|
| API Server | Cluster gateway | Control Plane |
| etcd | State store | Control Plane |
| Scheduler | Pod assignment | Control Plane |
| Controller Manager | Desired state reconciliation | Control Plane |
| Kubelet | Node agent | Worker Node |
| Kube-proxy | Network routing | Worker Node |
| Container Runtime | Runs containers | Worker Node |
