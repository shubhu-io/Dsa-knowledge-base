# Kubernetes Deployments

## Overview

Deployments provide declarative updates for Pods and ReplicaSets. They manage the desired state of your application and handle rolling updates, rollbacks, and scaling.

## Deployment Architecture

```
┌─────────────────────────────────────────────┐
│              Deployment                      │
│  ┌───────────────────────────────────────┐  │
│  │  Desired State: 3 replicas            │  │
│  │  Image: myapp:v2                      │  │
│  │  Strategy: RollingUpdate              │  │
│  └───────────────┬───────────────────────┘  │
│                  │                           │
│         ┌────────▼────────┐                  │
│         │   ReplicaSet    │                  │
│         │  (manages pods) │                  │
│         └──┬─────┬─────┬─┘                  │
│            │     │     │                     │
│         ┌──▼─┐┌──▼─┐┌──▼─┐                 │
│         │Pod1││Pod2││Pod3│                 │
│         └────┘└────┘└────┘                 │
└─────────────────────────────────────────────┘
```

## Deployment YAML

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
  namespace: default
  labels:
    app: myapp
    version: v1
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1        # Max pods above desired count
      maxUnavailable: 0   # Max pods below desired count
  template:
    metadata:
      labels:
        app: myapp
        version: v1
    spec:
      containers:
      - name: myapp
        image: myapp:v1.0
        ports:
        - containerPort: 8080
        resources:
          requests:
            cpu: "250m"
            memory: "256Mi"
          limits:
            cpu: "500m"
            memory: "512Mi"
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 15
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: url
        volumeMounts:
        - name: config
          mountPath: /app/config
      volumes:
      - name: config
        configMap:
          name: myapp-config
```

## Deployment Strategies

### Rolling Update (Default)

Gradually replaces old pods with new ones.

```
Initial State:     [v1] [v1] [v1]

Step 1:            [v1] [v1] [v1] [v2]     (maxSurge: 1)
Step 2:            [v1] [v1]      [v2]     (remove old)
Step 3:            [v1] [v1] [v2] [v2]     (add new)
Step 4:            [v1]      [v2] [v2]     (remove old)
Step 5:            [v2] [v2] [v2]          (done)
```

```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0
```

### Recreate

Kills all old pods before creating new ones. Causes downtime.

```yaml
strategy:
  type: Recreate
```

```
Initial State:     [v1] [v1] [v1]
Step 1:            [v1] [v1] [v1] [v2]     (scale up all new)
Step 2:            [v2] [v2] [v2]          (scale down all old)
```

### Blue-Green Deployment

Two identical environments. Switch traffic atomically.

```
                    ┌──────────────┐
                    │   Service    │
                    └──────┬───────┘
                           │
              ┌────────────┼────────────┐
              │            │            │
         ┌────▼────┐  ┌────▼────┐      │
         │ Blue    │  │ Green   │      │
         │ (v1)    │  │ (v2)    │      │
         │ ACTIVE  │  │ STANDBY │      │
         └─────────┘  └─────────┘      │
                                       │
        Swap selector to switch traffic│
```

### Canary Deployment

Route a small percentage of traffic to new version.

```
         ┌──────────────┐
         │   Ingress    │
         └──────┬───────┘
                │
    ┌───────────┼───────────┐
    │ 90%      │ 10%        │
    ▼          ▼            │
┌───────┐  ┌───────┐        │
│ v1    │  │ v2    │        │
│ (9)   │  │ (1)   │        │
└───────┘  └───────┘        │
```

## Scaling

```bash
# Manual scaling
kubectl scale deployment myapp --replicas=5

# Autoscaling (HPA)
kubectl autoscale deployment myapp --min=2 --max=10 --cpu-percent=70

# HPA YAML
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
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

## Complete Production Example

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-api
  namespace: production
  labels:
    app: web-api
    team: platform
spec:
  replicas: 3
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: web-api
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    metadata:
      labels:
        app: web-api
        version: v2
    spec:
      serviceAccountName: web-api
      securityContext:
        runAsNonRoot: true
        runAsUser: 1000
      containers:
      - name: api
        image: registry.example.com/web-api:v2.1.0
        ports:
        - containerPort: 8080
          name: http
        resources:
          requests:
            cpu: "200m"
            memory: "256Mi"
          limits:
            cpu: "1000m"
            memory: "512Mi"
        livenessProbe:
          httpGet:
            path: /healthz
            port: 8080
          initialDelaySeconds: 10
          periodSeconds: 15
          failureThreshold: 3
        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5
          failureThreshold: 3
        startupProbe:
          httpGet:
            path: /healthz
            port: 8080
          failureThreshold: 30
          periodSeconds: 2
        env:
        - name: APP_ENV
          value: "production"
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: web-api-secrets
              key: db-password
        - name: REDIS_URL
          valueFrom:
            configMapKeyRef:
              name: web-api-config
              key: redis-url
        volumeMounts:
        - name: tmp
          mountPath: /tmp
      volumes:
      - name: tmp
        emptyDir: {}
      topologySpreadConstraints:
      - maxSkew: 1
        topologyKey: kubernetes.io/hostname
        whenUnsatisfiable: DoNotSchedule
        labelSelector:
          matchLabels:
            app: web-api
```

## Rollback Operations

```bash
# Check rollout history
kubectl rollout history deployment/web-api

# Rollback to previous version
kubectl rollout undo deployment/web-api

# Rollback to specific revision
kubectl rollout undo deployment/web-api --to-revision=3

# Watch rollout progress
kubectl rollout status deployment/web-api

# Pause a rollout
kubectl rollout pause deployment/web-api

# Resume a paused rollout
kubectl rollout resume deployment/web-api
```

## Best Practices

1. Always set resource requests and limits
2. Use liveness, readiness, and startup probes
3. Set `maxUnavailable: 0` for zero-downtime deploys
4. Use `topologySpreadConstraints` for pod distribution
5. Set `revisionHistoryLimit` for rollback capability
6. Use specific image tags, never `:latest`
7. Run as non-root user
8. Use `emptyDir` for writable temp directories
