# Kubernetes Guide

## What is Kubernetes?

Kubernetes (K8s) is an open-source container orchestration platform for automating deployment, scaling, and management of containerized applications.

## Key Concepts

### Pods
- Smallest deployable units
- One or more containers
- Shared network and storage

### Services
- Stable network endpoint
- Load balancing across pods
- Types: ClusterIP, NodePort, LoadBalancer

### Deployments
- Declarative updates
- Rollback support
- Scaling

### ConfigMaps and Secrets
- External configuration
- Sensitive data storage

## Architecture

```
Master Node
├── API Server
├── Scheduler
├── Controller Manager
└── etcd

Worker Node
├── Kubelet
├── Kube-proxy
└── Pods
```

## Commands

| Command | Description |
|---------|-------------|
| `kubectl get pods` | List pods |
| `kubectl get services` | List services |
| `kubectl get deployments` | List deployments |
| `kubectl apply -f file.yaml` | Apply configuration |
| `kubectl delete pod pod_name` | Delete pod |
| `kubectl logs pod_name` | View logs |
| `kubectl exec -it pod_name bash` | Shell into pod |

## YAML Example

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: myapp
        image: myapp:latest
        ports:
        - containerPort: 3000
```

## Best Practices

1. Use declarative configuration
2. Implement health checks
3. Use namespaces for isolation
4. Set resource limits
5. Use Helm for package management