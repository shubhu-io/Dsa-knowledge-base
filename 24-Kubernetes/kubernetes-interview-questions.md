# Kubernetes Interview Questions

## Fundamentals

### 1. What is Kubernetes and why is it used?

**Answer:**
Kubernetes is a container orchestration platform that automates deployment, scaling, and management of containerized applications.

Key capabilities:
- **Self-healing**: Restarts failed containers, replaces unresponsive nodes
- **Auto-scaling**: Scales based on CPU/memory or custom metrics
- **Service discovery**: Internal DNS for service communication
- **Load balancing**: Distributes traffic across pods
- **Rolling updates**: Zero-downtime deployments
- **Secret management**: Encrypted storage for sensitive data

---

### 2. What is a Pod?

**Answer:**
A Pod is the smallest deployable unit in Kubernetes. It wraps one or more containers that share:
- Network namespace (same IP, can communicate via localhost)
- Storage volumes
- Lifecycle (all containers start and stop together)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp
spec:
  containers:
  - name: app
    image: myapp
  - name: sidecar
    image: log-collector
```

Sidecar pattern: main container + helper container sharing resources.

---

### 3. What is the difference between a Pod and a Deployment?

| Feature | Pod | Deployment |
|---------|-----|------------|
| Manages | Single instance | Multiple replicas |
| Self-healing | No | Yes |
| Rolling updates | No | Yes |
| Scaling | Manual | Automatic |
| Rollback | No | Yes |

Always use Deployments (or higher-level controllers) instead of bare Pods.

---

### 4. What are the different Service types?

**Answer:**

| Type | Access | Use Case |
|------|--------|----------|
| ClusterIP | Internal only | Default, internal microservices |
| NodePort | `<NodeIP>:<NodePort>` | Development, external access |
| LoadBalancer | Cloud LB IP | Production external access |
| ExternalName | DNS CNAME | External service mapping |

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: LoadBalancer
  selector:
    app: myapp
  ports:
  - port: 80
    targetPort: 8080
```

---

### 5. What is etcd?

**Answer:**
etcd is a distributed key-value store that holds all cluster state - node information, pod definitions, secrets, config maps, and more. It's the single source of truth for the cluster.

- Uses Raft consensus for consistency
- Must be backed up regularly
- 3 or 5 nodes for HA (odd numbers for quorum)

---

## Intermediate

### 6. Explain the difference between a Deployment and a StatefulSet.

| Feature | Deployment | StatefulSet |
|---------|-----------|-------------|
| Pod names | Random | Fixed (pod-0, pod-1) |
| Network | Identical | Unique per pod |
| Storage | Shared/ephemeral | Per-pod persistent |
| Scaling | Any order | Ordered (sequential) |
| Use stateless | Yes | No |
| Use stateless | No | Yes (databases) |

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgres
spec:
  serviceName: "postgres"
  replicas: 3
  selector:
    matchLabels:
      app: postgres
  template:
    # ...
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 10Gi
```

---

### 7. What are ConfigMaps and Secrets?

**Answer:**

**ConfigMap**: Non-confidental configuration data.
```bash
kubectl create configmap myconfig --from-literal=DATABASE_HOST=db.example.com
```

**Secret**: Sensitive data (base64 encoded, encrypted at rest with KMS).
```bash
kubectl create secret generic mysecret --from-literal=password=abc123
```

```yaml
# Use in pods
env:
- name: DB_HOST
  valueFrom:
    configMapKeyRef:
      name: myconfig
      key: DATABASE_HOST
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: mysecret
      key: password
```

---

### 8. What are taints and tolerations?

**Answer:**
- **Taints** on nodes repel pods that don't tolerate them
- **Tolerations** on pods allow them to schedule on tainted nodes

```bash
# Taint node
kubectl taint nodes node1 dedicated=gpu:NoSchedule

# Pod toleration
tolerations:
- key: "dedicated"
  operator: "Equal"
  value: "gpu"
  effect: "NoSchedule"
```

Use cases: dedicated nodes for specific workloads, reserving nodes for system pods.

---

### 9. What is a DaemonSet?

**Answer:**
A DaemonSet ensures exactly one pod runs on every (or selected) node.

Use cases: logging agents, monitoring exporters, network plugins (Calico, Flannel).

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: log-agent
spec:
  selector:
    matchLabels:
      name: log-agent
  template:
    metadata:
      labels:
        name: log-agent
    spec:
      containers:
      - name: fluentd
        image: fluentd:latest
```

---

### 10. How do you debug a CrashLoopBackOff pod?

```bash
# 1. Check logs
kubectl logs <pod> --previous

# 2. Describe for events
kubectl describe pod <pod>

# 3. Check resource limits
kubectl top pod <pod>

# 4. Run interactively with override
kubectl run debug --image=busybox -it --rm -- sh

# 5. Check if it's an OOMKilled
kubectl get pod <pod> -o jsonpath='{.status.containerStatuses[0].lastState.terminated.reason}'

# 6. Common causes:
# - Application error on startup
# - Missing environment variable
# - OOMKilled (increase memory limit)
# - Liveness probe failing
# - Image pull error
```

---

### 11. What are Namespaces and when to use them?

**Answer:**
Namespaces provide logical isolation within a cluster.

```bash
kubectl create namespace production
kubectl create namespace staging
kubectl get pods -n production
```

Use cases:
- Team separation (team-a, team-b)
- Environment separation (dev, staging, prod)
- Resource quotas per namespace
- RBAC boundaries

---

### 12. What is an Ingress?

**Answer:**
An Ingress exposes HTTP/HTTPS routes to services within the cluster.

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: api.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 80
  - host: web.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
```

Requires an Ingress Controller (nginx, traefik, etc.).

---

## Advanced

### 13. How do rolling updates work in Kubernetes?

**Answer:**

```
Starting:  [v1] [v1] [v1]    (3 replicas)
maxSurge: 1, maxUnavailable: 0

Step 1:    [v1] [v1] [v1] [v2]     (scale up to 4)
Step 2:    [v1] [v1]      [v2]     (terminate 1 v1)
Step 3:    [v1] [v1] [v2] [v2]     (scale up to 4)
Step 4:    [v1]           [v2] [v2] (terminate 1 v1)
Step 5:    [v1] [v2] [v2] [v2]     (scale up to 4)
Step 6:                [v2] [v2] [v2] (terminate last v1)
```

With `maxUnavailable: 0`, there's always at least 3 running pods during the update.

---

### 14. What is Horizontal Pod Autoscaler (HPA)?

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: myapp-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: myapp
  minReplicas: 2
  maxReplicas: 20
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
      - type: Percent
        value: 10
        periodSeconds: 60
```

Requires Metrics Server installed in the cluster.

---

### 15. How do you manage secrets securely in Kubernetes?

1. Use Kubernetes Secrets (encrypted at rest with KMS)
2. Enable encryption at rest in etcd
3. Use external secret stores (AWS Secrets Manager, HashiCorp Vault)
4. Limit secret access via RBAC
5. Don't log or expose secrets
6. Rotate secrets regularly

```yaml
# External Secrets Operator example
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: db-secret
spec:
  secretStoreRef:
    name: aws-secrets-manager
    kind: SecretStore
  target:
    name: db-credentials
  data:
  - secretKey: password
    remoteRef:
      key: prod/db/password
```

---

### 16. What is a NetworkPolicy?

**Answer:**
NetworkPolicies control pod-to-pod and pod-to-external traffic (requires CNI that supports it, e.g., Calico, Cilium).

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-only-api
spec:
  podSelector:
    matchLabels:
      app: database
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: api
    ports:
    - port: 5432
```

Default: deny all. Allow only specific traffic.

---

### 17. How would you design a production Kubernetes cluster?

```
┌─────────────────────────────────────────────────────┐
│                  Load Balancer                       │
│                   (L4/L7)                            │
└──────────────────────┬──────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────┐
│                 Ingress Controller                    │
│               (nginx/traefik)                        │
└──────────────────────┬──────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────┐
│                  Service Mesh                        │
│              (optional: Istio/Linkerd)               │
└──────────────────────┬──────────────────────────────┘
                       │
┌──────────┬───────────┼───────────┬──────────────┐
│ Namespace│ Namespace │ Namespace │ Namespace     │
│   dev    │  staging  │   prod    │ monitoring    │
│          │           │           │               │
│ [Pods]   │ [Pods]    │ [Pods]    │ [Prometheus]  │
│          │           │           │ [Grafana]     │
└──────────┴───────────┴───────────┴───────────────┘
                       │
┌──────────────────────▼──────────────────────────────┐
│              Persistent Storage                      │
│         (PV, PVC, StorageClasses)                    │
└─────────────────────────────────────────────────────┘
```

Key design decisions:
- Use namespaces for isolation
- Implement RBAC with least privilege
- Set resource quotas per namespace
- Use network policies for segmentation
- Deploy monitoring (Prometheus + Grafana)
- Implement log aggregation (EFK/Loki)
- Use cert-manager for TLS certificates
- Regular etcd backups
