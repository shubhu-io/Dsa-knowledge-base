# DevOps Complete Guide - From Zero to DevOps Engineer

## Table of Contents

1. [What is DevOps?](#what-is-devops)
2. [DevOps Culture](#devops-culture)
3. [Core Principles](#core-principles)
4. [Version Control with Git](#version-control-with-git)
5. [CI/CD Pipelines](#cicd-pipelines)
6. [Infrastructure as Code](#infrastructure-as-code)
7. [Configuration Management](#configuration-management)
8. [Containerization](#containerization)
9. [Container Orchestration](#container-orchestration)
10. [Monitoring & Observability](#monitoring--observability)
11. [DevOps Workflow](#devops-workflow)
12. [Career Path](#career-path)

---

## What is DevOps?

### Definition
DevOps is the combination of cultural philosophies, practices, and tools that increases an organization's ability to deliver applications and services at high velocity.

### Goals
- Faster time to market
- Lower failure rate of new releases
- Faster mean time to recovery (MTTR)
- Reduced manual work
- Better collaboration between teams

### DevOps vs Traditional

```
Traditional (Silos):
Development -> Testing -> Operations
    (Months)    (Weeks)    (Days)

DevOps (Collaborative):
Development <-> Testing <-> Operations
    (Hours)       (Hours)     (Hours)
```

---

## DevOps Culture

### The Three Ways

1. **First Way**: Flow (Left to Right)
   - Optimize workflow from Dev to Ops
   - Fast feedback loops
   - Shorten cycle times

2. **Second Way**: Feedback (Right to Left)
   - Constant feedback from Ops to Dev
   - Identify problems early
   - Prevent defects from occurring

3. **Third Way**: Continual Learning
   - Experimentation and risk-taking
   - Learning from failures
   - Knowledge sharing

### CALMS Framework

| Element | Description |
|---------|-------------|
| **C**ulture | Collaborative, blameless culture |
| **A**utomation | Automate everything possible |
| **L**ean | Eliminate waste, optimize flow |
| **M**easurement | Measure everything, data-driven |
| **S**haring | Share knowledge, tools, responsibilities |

---

## Core Principles

### 1. Continuous Integration (CI)
- Developers merge code changes frequently
- Automated build and test on each merge
- Catch integration issues early

### 2. Continuous Delivery (CD)
- Code is always in a deployable state
- Automated deployment to production
- Manual approval for production releases

### 3. Continuous Deployment
- Every change goes to production automatically
- No manual intervention
- Faster feedback from users

### 4. Infrastructure as Code (IaC)
- Infrastructure defined in code
- Version controlled
- Reproducible environments

### 5. Everything as Code
- Configuration as Code
- Policy as Code
- Security as Code
- Testing as Code

---

## Version Control with Git

### Git Workflow

```
Remote: main
    |
Local: main
    |
    +-- feature/login
    |       |
    |       +-- commit 1
    |       +-- commit 2
    |
    +-- feature/signup
            |
            +-- commit 1
```

### Essential Git Commands

```bash
# Clone repository
git clone https://github.com/user/repo.git

# Create branch
git checkout -b feature/new-feature

# Stage changes
git add .

# Commit
git commit -m "Add new feature"

# Push
git push origin feature/new-feature

# Pull
git pull origin main

# Merge
git merge feature/new-feature

# Rebase
git rebase main
```

### Git Branching Strategies

**Git Flow**:
```
main (production)
    |
develop (integration)
    |
    +-- feature/login
    +-- feature/signup
    |
release/v1.0
    |
hotfix/critical-bug
```

**GitHub Flow**:
```
main (production)
    |
    +-- feature-branch (pull request)
    +-- feature-branch (pull request)
```

**Trunk-Based Development**:
```
main (production)
    |
    +-- short-lived feature branches (< 1 day)
    +-- feature flags for incomplete features
```

---

## CI/CD Pipelines

### CI Pipeline

```
Code Push -> Build -> Unit Test -> Integration Test -> Artifact
    |
    +-- Linting
    +-- Security Scan
    +-- Code Quality
```

### CD Pipeline

```
Artifact -> Deploy to Staging -> Integration Test -> Deploy to Production
    |
    +-- Smoke Tests
    +-- Performance Tests
    +-- Security Tests
```

### Pipeline Tools

| Tool | Type | Features |
|------|------|----------|
| Jenkins | Self-hosted | Extensible, plugins |
| GitHub Actions | Cloud-native | Free for public repos |
| GitLab CI | Integrated | Part of GitLab |
| CircleCI | Cloud | Fast builds |
| Azure DevOps | Enterprise | Microsoft ecosystem |
| ArgoCD | GitOps | Kubernetes-native |

### Example Pipeline (GitHub Actions)

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Run tests
      run: npm test
    
    - name: Build
      run: npm run build
    
    - name: Deploy to production
      if: github.ref == 'refs/heads/main'
      run: ./deploy.sh
```

---

## Infrastructure as Code

### IaC Tools Comparison

| Tool | Type | Learning Curve | Multi-Cloud |
|------|------|----------------|-------------|
| Terraform | Declarative | Medium | Yes |
| Pulumi | Imperative | Medium | Yes |
| Ansible | Imperative | Low | Yes |
| CloudFormation | Declarative | Medium | AWS only |
| ARM/Bicep | Declarative | Medium | Azure only |

### Terraform Example

```hcl
# main.tf
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  
  tags = {
    Name = "WebServer"
  }
}

resource "aws_s3_bucket" "data" {
  bucket = "my-data-bucket"
}
```

```bash
# Terraform workflow
terraform init    # Initialize
terraform plan    # Preview changes
terraform apply   # Apply changes
terraform destroy # Remove resources
```

### Ansible Example

```yaml
# playbook.yml
- hosts: web_servers
  become: yes
  vars:
    http_port: 80
    
  tasks:
    - name: Install nginx
      apt:
        name: nginx
        state: present
        
    - name: Start nginx
      service:
        name: nginx
        state: started
```

---

## Configuration Management

### CM Tools Comparison

| Tool | Type | Agent | Language |
|------|------|-------|----------|
| Ansible | Agentless | SSH | YAML |
| Puppet | Agent-based | Puppet | DSL |
| Chef | Agent-based | Chef | Ruby |
| SaltStack | Agent-based | Salt | YAML/Python |

### Ansible Ad-hoc Commands

```bash
# Ping servers
ansible all -m ping

# Run command
ansible web_servers -m shell -a "uptime"

# Install package
ansible all -m apt -a "name=nginx state=present" --become
```

---

## Containerization

### Docker Basics

```bash
# Build image
docker build -t my-app:latest .

# Run container
docker run -d -p 8080:80 my-app:latest

# List containers
docker ps

# Stop container
docker stop <container_id>
```

### Dockerfile Example

```dockerfile
# Build stage
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
EXPOSE 3000
CMD ["node", "dist/main.js"]
```

### Docker Compose

```yaml
# docker-compose.yml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "8080:80"
    depends_on:
      - db
      - redis
      
  db:
    image: postgres:14
    environment:
      POSTGRES_DB: myapp
      POSTGRES_PASSWORD: secret
      
  redis:
    image: redis:7-alpine
```

---

## Container Orchestration

### Kubernetes Architecture

```
Control Plane:
+-- API Server (kubectl talks here)
+-- etcd (state store)
+-- Scheduler (places pods)
+-- Controller Manager (maintains state)

Worker Nodes:
+-- kubelet (agent)
+-- kube-proxy (networking)
+-- Container Runtime (Docker, containerd)
```

### Kubernetes Objects

| Object | Description |
|--------|-------------|
| Pod | Smallest deployable unit |
| Deployment | Manages replica sets |
| Service | Network endpoint for pods |
| ConfigMap | Non-sensitive configuration |
| Secret | Sensitive configuration |
| Ingress | HTTP routing |
| PV/PVC | Persistent storage |

### Kubernetes Commands

```bash
# Deploy application
kubectl apply -f deployment.yaml

# Check status
kubectl get pods
kubectl get services

# Scale deployment
kubectl scale deployment my-app --replicas=3

# View logs
kubectl logs -f deployment/my-app

# Port forward
kubectl port-forward svc/my-app 8080:80
```

---

## Monitoring & Observability

### Three Pillars

1. **Metrics**: Numerical measurements (CPU, memory, latency)
2. **Logs**: Event records (application logs, system logs)
3. **Traces**: Request paths (distributed tracing)

### Monitoring Stack

```
Metrics: Prometheus + Grafana
Logs: ELK Stack (Elasticsearch, Logstash, Kibana) or Loki
Traces: Jaeger or Zipkin
Alerting: Alertmanager or PagerDuty
```

### Prometheus + Grafana

```yaml
# prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'my-app'
    static_configs:
      - targets: ['app:8080']
```

```json
// Grafana Dashboard
{
  "panels": [{
    "type": "graph",
    "title": "Request Rate",
    "targets": [{
      "expr": "rate(http_requests_total[5m])"
    }]
  }]
}
```

### Alert Rules

```yaml
# alertmanager.yml
groups:
  - name: alerts
    rules:
      - alert: HighCPU
        expr: 100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage"
```

---

## DevOps Workflow

### Standard DevOps Pipeline

```
1. PLAN
   +-- User stories
   +-- Sprint planning
   +-- Architecture decisions

2. CODE
   +-- Feature branches
   +-- Pull requests
   +-- Code review

3. BUILD
   +-- Compile code
   +-- Run unit tests
   +-- Create artifacts

4. TEST
   +-- Integration tests
   +-- Performance tests
   +-- Security tests

5. RELEASE
   +-- Version management
   +-- Release notes
   +-- Approval gates

6. DEPLOY
   +-- Blue/green deployment
   +-- Canary release
   +-- Rolling update

7. OPERATE
   +-- Monitoring
   +-- Alerting
   +-- Incident response

8. MONITOR
   +-- Metrics collection
   +-- Log aggregation
   +-- User feedback
```

---

## Career Path

### DevOps Engineer Roles

```
Junior DevOps Engineer (0-2 years)
    |
    +-- DevOps Engineer (2-5 years)
    |         |
    |         +-- Senior DevOps Engineer
    |         +-- Platform Engineer
    |
    +-- SRE (Site Reliability Engineer)
    |         |
    |         +-- Senior SRE
    |         +-- SRE Manager
    |
    +-- Cloud Engineer
    |         |
    |         +-- Cloud Architect
    |
    +-- Security Engineer (DevSecOps)
```

### Skills Roadmap

```
Year 1-2:
- Git, Linux, Networking
- Docker, Kubernetes basics
- CI/CD basics
- Scripting (Bash, Python)

Year 2-4:
- IaC (Terraform, Ansible)
- Cloud platforms (AWS/Azure/GCP)
- Monitoring (Prometheus, Grafana)
- Advanced Kubernetes

Year 4-6:
- System design
- Security (DevSecOps)
- Cost optimization
- Team leadership

Year 6+:
- Architecture
- Strategy
- Innovation
- Mentoring
```

---

## Next Steps

1. Complete the [DevOps Tools](devops-tools.md) overview
2. Study [DevOps Practices](devops-practices.md) in depth
3. Practice with [Interview Questions](devops-interview-questions.md)
4. Build a project: Complete CI/CD pipeline
5. Pursue CKA (Certified Kubernetes Administrator) certification
