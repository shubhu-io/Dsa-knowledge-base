# Kubernetes Guide

## Overview

Kubernetes is a container orchestration platform for managing containerized applications at scale.

## Files

| File | Description |
|------|-------------|
| `kubernetes-guide.md` | Comprehensive Kubernetes guide |

## Quick Start

```bash
# Deploy application
kubectl apply -f deployment.yaml

# Expose service
kubectl expose deployment myapp --type=LoadBalancer --port=80

# Scale deployment
kubectl scale deployment myapp --replicas=5

# Check status
kubectl get pods
```

## Key Benefits

- **Auto-scaling**: Scale based on metrics
- **Self-healing**: Restart failed containers
- **Load balancing**: Distribute traffic
- **Rolling updates**: Zero-downtime deployments