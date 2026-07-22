# DevOps & Cloud Computing

## Overview

DevOps is a set of practices that combines software development (Dev) and IT operations (Ops) to shorten the development lifecycle and deliver high-quality software continuously. Cloud computing provides on-demand computing resources over the internet.

## Key Concepts

### DevOps Lifecycle

```
    ┌─────────────────────────────────────────────────┐
    │                 DevOps Lifecycle                 │
    │                                                  │
    │   ┌──────┐   ┌──────┐   ┌──────┐   ┌──────┐   │
    │   │ Plan │──▶│ Code │──▶│ Build│──▶│ Test │   │
    │   └──────┘   └──────┘   └──────┘   └──────┘   │
    │                                      │          │
    │                                      ▼          │
    │   ┌──────┐   ┌──────┐   ┌──────┐   ┌──────┐   │
    │   │Monitor│◀──│Operate│◀──│Deploy│◀──│Release│  │
    │   └──────┘   └──────┘   └──────┘   └──────┘   │
    │       │                                         │
    │       └──────────── Feedback ──────────────┘    │
    └─────────────────────────────────────────────────┘
```

### Cloud Service Models

| Model | Description | Examples | Control Level |
|-------|-------------|----------|---------------|
| **IaaS** | Infrastructure as a Service | AWS EC2, Azure VMs | High |
| **PaaS** | Platform as a Service | Heroku, Google App Engine | Medium |
| **SaaS** | Software as a Service | Gmail, Salesforce | Low |
| **FaaS** | Function as a Service | AWS Lambda, Azure Functions | Varies |

### Cloud Provider Comparison

| Feature | AWS | Azure | GCP |
|---------|-----|-------|-----|
| Market Share | ~32% | ~23% | ~10% |
| Free Tier | 12 months | 12 months | Always free |
| Best For | Enterprise, Startups | .NET, Enterprise | Data/ML, K8s |
| Pricing | Pay-as-you-go | Hybrid focus | Per-second billing |

## Docker Basics

Docker packages applications into containers for consistent deployment.

### Dockerfile Example

```dockerfile
# Multi-stage build for a Node.js application
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .
RUN npm run build

# Production stage
FROM node:18-alpine AS production

WORKDIR /app

# Create non-root user
RUN addgroup -g 1001 -S appgroup && \
    adduser -S appuser -u 1001

COPY --from=builder --chown=appuser:appgroup /app/dist ./dist
COPY --from=builder --chown=appuser:appgroup /app/node_modules ./node_modules

USER appuser

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -qO- http://localhost:3000/health || exit 1

CMD ["node", "dist/server.js"]
```

### Essential Docker Commands

```bash
# Build and run
docker build -t myapp:1.0 .
docker run -d -p 8080:3000 --name myapp myapp:1.0

# Manage containers
docker ps -a                    # List all containers
docker logs -f myapp            # Follow logs
docker exec -it myapp sh        # Shell into container

# Cleanup
docker system prune -a          # Remove unused resources
docker volume prune             # Remove unused volumes

# Docker Compose
docker-compose up -d            # Start services
docker-compose down             # Stop services
docker-compose logs -f          # Follow all logs
```

## Kubernetes Concepts

Kubernetes (K8s) orchestrates containerized applications across clusters.

### Core Resources

| Resource | Purpose |
|----------|---------|
| **Pod** | Smallest deployable unit (1+ containers) |
| **Service** | Stable network endpoint for pods |
| **Deployment** | Manages pod replicas and updates |
| **ConfigMap/Secret** | Configuration and sensitive data |
| **Ingress** | HTTP routing to services |

### Deployment YAML

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  labels:
    app: web-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-app
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: web
        image: nginx:1.25-alpine
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "250m"
          limits:
            memory: "128Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 80
          initialDelaySeconds: 10
          periodSeconds: 5
```

## Terraform Basics

Terraform is an Infrastructure as Code (IaC) tool for provisioning cloud resources.

```hcl
# AWS EC2 instance with Terraform
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "web" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "web-subnet"
  }
}

resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.web.id

  tags = {
    Name = "WebServer"
  }
}

output "instance_ip" {
  value = aws_instance.web_server.public_ip
}
```

## CI/CD Pipeline Example

```yaml
# GitHub Actions workflow
name: CI/CD Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: 18
      - run: npm ci
      - run: npm test
      - run: npm run lint

  deploy:
    needs: test
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: docker build -t myapp:${{ github.sha }} .
      - run: docker push myapp:${{ github.sha }}
      - run: kubectl set image deployment/web app=myapp:${{ github.sha }}
```

## Common Interview Questions

1. **What is the difference between continuous integration, continuous delivery, and continuous deployment?**
   - CI: Automated build/test on code changes
   - CD (Delivery): Artifacts ready for manual release
   - CD (Deployment): Automatic release to production

2. **Explain the Docker layer caching mechanism.** Layers are cached; only changed layers rebuild, making subsequent builds faster.

3. **What is the difference between a Docker container and a virtual machine?**
   - Containers share host OS kernel (lightweight)
   - VMs have full guest OS (heavyweight, stronger isolation)

4. **How does Kubernetes handle self-healing?** Through liveness/readiness probes and the controller reconciliation loop that restarts failed pods.

5. **Explain Terraform state management.** State tracks resource-to-config mapping; stored in state files or remote backends (S3, Consul) for team collaboration.

## See Also

- [[Cheat-Sheets]]
- [[Web-Development]]
- [[Resources]]

> Full content: [20-Docker](../20-Docker/), [24-Kubernetes](../24-Kubernetes/), [25-Cloud-Computing](../25-Cloud-Computing/), [26-Terraform](../26-Terraform/)
