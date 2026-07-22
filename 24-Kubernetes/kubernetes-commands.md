# Kubernetes Commands Reference

## Cluster Information

| Command | Description |
|---------|-------------|
| `kubectl cluster-info` | Display cluster info |
| `kubectl get nodes` | List all nodes |
| `kubectl describe node <name>` | Node details |
| `kubectl top nodes` | Node resource usage |
| `kubectl api-resources` | List all resource types |
| `kubectl api-versions` | List API versions |

## Pod Management

### Viewing Pods

| Command | Description |
|---------|-------------|
| `kubectl get pods` | List pods in current namespace |
| `kubectl get pods -A` | List pods in all namespaces |
| `kubectl get pods -o wide` | Pods with extra info (node, IP) |
| `kubectl get pods -l app=web` | Filter by label |
| `kubectl get pods --field-selector status.phase=Running` | Filter by status |
| `kubectl describe pod <name>` | Detailed pod info |
| `kubectl logs <pod>` | View container logs |
| `kubectl logs <pod> -c <container>` | Logs from specific container |
| `kubectl logs <pod> --previous` | Previous container logs |
| `kubectl logs -f <pod>` | Follow/stream logs |
| `kubectl exec -it <pod> -- bash` | Shell into pod |
| `kubectl exec <pod> -- env` | Run command in pod |
| `kubectl port-forward <pod> 8080:80` | Forward port to local |
| `kubectl cp <pod>:/path ./local` | Copy from pod |
| `kubectl top pods` | Pod resource usage |

### Creating and Deleting

```bash
# Create from YAML
kubectl apply -f pod.yaml

# Create from command line
kubectl run nginx --image=nginx:alpine --port=80

# Delete pod
kubectl delete pod <name>

# Delete pods by label
kubectl delete pods -l app=web

# Force delete stuck pod
kubectl delete pod <name> --grace-period=0 --force
```

## Deployment Management

| Command | Description |
|---------|-------------|
| `kubectl get deployments` | List deployments |
| `kubectl describe deployment <name>` | Deployment details |
| `kubectl create deployment nginx --image=nginx` | Create deployment |
| `kubectl scale deployment <name> --replicas=5` | Scale deployment |
| `kubectl rollout status deployment <name>` | Check rollout status |
| `kubectl rollout history deployment <name>` | View rollout history |
| `kubectl rollout undo deployment <name>` | Rollback to previous |
| `kubectl rollout undo deployment <name> --to-revision=3` | Rollback to specific |
| `kubectl rollout restart deployment <name>` | Restart pods |
| `kubectl autoscale deployment <name> --min=2 --max=10 --cpu-percent=80` | Auto-scale |

## Service Management

| Command | Description |
|---------|-------------|
| `kubectl get svc` | List services |
| `kubectl expose deployment <name> --port=80 --type=LoadBalancer` | Create service |
| `kubectl describe svc <name>` | Service details |
| `kubectl get endpoints <name>` | View endpoints |

## Namespace Management

| Command | Description |
|---------|-------------|
| `kubectl get namespaces` | List namespaces |
| `kubectl create namespace dev` | Create namespace |
| `kubectl config set-context --current --namespace=dev` | Switch namespace |
| `kubectl get pods -n kube-system` | Pods in specific namespace |

## Configuration and Secrets

```bash
# Create ConfigMap
kubectl create configmap myconfig --from-literal=key1=value1
kubectl create configmap myconfig --from-file=config.yaml

# Create Secret
kubectl create secret generic mysecret --from-literal=password=abc123
kubectl create secret tls mycert --cert=cert.pem --key=key.pem

# View ConfigMap
kubectl get configmap myconfig -o yaml

# View Secret (base64 encoded)
kubectl get secret mysecret -o jsonpath='{.data.password}' | base64 -d
```

## Debugging

| Command | Description |
|---------|-------------|
| `kubectl describe <resource> <name>` | Detailed resource info |
| `kubectl logs <pod> --previous` | Logs from crashed container |
| `kubectl get events --sort-by='.lastTimestamp'` | View cluster events |
| `kubectl get events -w` | Watch events in real-time |
| `kubectl debug node/<name> -it --image=busybox` | Debug node |
| `kubectl run debug --image=busybox -it --rm -- sh` | Debug pod |
| `kubectl explain pod` | Document for resource type |
| `kubectl explain pod.spec.containers` | Nested field docs |

## Resource Management

```bash
# Get resource usage
kubectl top pods
kubectl top nodes

# Delete all resources in namespace
kubectl delete all --all -n <namespace>

# Export YAML from running resource
kubectl get deployment <name> -o yaml > exported.yaml

# Dry run (validate without applying)
kubectl apply -f deployment.yaml --dry-run=client

# Apply with server-side validation
kubectl apply -f deployment.yaml --server-side
```

## Labeling and Annotations

```bash
# Add label
kubectl label pod <pod> env=production

# Remove label
kubectl label pod <pod> env-

# Add annotation
kubectl annotate pod <pod> description="web server"

# Selector queries
kubectl get pods -l 'app in (web, api)'
kubectl get pods -l 'env=production,tier=frontend'
```

## Taints and Tolerations

```bash
# Add taint to node
kubectl taint nodes node1 key=value:NoSchedule

# Remove taint
kubectl taint nodes node1 key=value:NoSchedule-

# List taints
kubectl describe node node1 | grep Taints
```

## Context and Configuration

| Command | Description |
|---------|-------------|
| `kubectl config view` | View current config |
| `kubectl config get-contexts` | List contexts |
| `kubectl config use-context <context>` | Switch context |
| `kubectl config set-context --current --namespace=dev` | Set default namespace |

## Quick Reference: kubectl Cheat Sheet

```bash
# Get everything
kubectl get all -n <namespace>

# Watch mode
kubectl get pods -w

# JSON path query
kubectl get pods -o jsonpath='{.items[*].metadata.name}'

# Custom columns
kubectl get pods -o custom-columns=NAME:.metadata.name,STATUS:.status.phase

# Sort output
kubectl get pods --sort-by='.status.startTime'

# Verbose output
kubectl apply -f pod.yaml -v=9

# Wait for condition
kubectl wait --for=condition=Ready pod/<name> --timeout=120s
kubectl wait --for=condition=available deployment/<name>
```
