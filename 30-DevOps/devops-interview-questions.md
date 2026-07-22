# DevOps Interview Questions - Comprehensive Guide

## Table of Contents

1. [Fundamental Questions](#fundamental-questions)
2. [Version Control Questions](#version-control-questions)
3. [CI/CD Questions](#cicd-questions)
4. [Infrastructure as Code Questions](#infrastructure-as-code-questions)
5. [Containerization Questions](#containerization-questions)
6. [Kubernetes Questions](#kubernetes-questions)
7. [Monitoring Questions](#monitoring-questions)
8. [Security Questions](#security-questions)
9. [Scenario-Based Questions](#scenario-based-questions)
10. [Coding/Hands-On Questions](#codinghands-on-questions)

---

## Fundamental Questions

### Q1: What is DevOps and why is it important?

**Answer**:
DevOps is a set of practices combining software development (Dev) and IT operations (Ops) to deliver applications faster and more reliably.

**Key Benefits**:
- Faster time to market
- Lower failure rate
- Faster recovery from failures
- Better collaboration
- Reduced manual work

### Q2: What is the CALMS framework?

**Answer**:
- **C**ulture: Collaborative, blameless culture
- **A**utomation: Automate everything possible
- **L**ean: Eliminate waste, optimize flow
- **M**easurement: Measure everything, data-driven
- **S**haring: Share knowledge, tools, responsibilities

### Q3: What are the Three Ways of DevOps?

**Answer**:
1. **First Way (Flow)**: Optimize left-to-right workflow
2. **Second Way (Feedback)**: Create right-to-left feedback loops
3. **Third Way (Learning)**: Continual experimentation and learning

### Q4: What is the difference between Continuous Delivery and Continuous Deployment?

**Answer**:
| Aspect | Continuous Delivery | Continuous Deployment |
|--------|---------------------|----------------------|
| Production | Manual approval | Automatic |
| Risk | Lower (human gate) | Higher (auto-deploy) |
| Speed | Fast | Faster |
| Use Case | Regulated industries | Low-risk applications |

### Q5: What is a DevOps pipeline?

**Answer**:
A series of automated steps that move code from development to production:
```
Code -> Build -> Test -> Deploy to Staging -> Approve -> Deploy to Production
```

---

## Version Control Questions

### Q6: What is the difference between Git merge and Git rebase?

**Answer**:
| Aspect | Merge | Rebase |
|--------|-------|--------|
| History | Preserves all commits | Rewrites history |
| Result | Merge commit | Linear history |
| Use Case | Shared branches | Private branches |
| Safety | Safe for shared | Not safe for shared |

**When to Use**:
- **Merge**: Public branches, preserving history
- **Rebase**: Private branches, clean history

### Q7: What is Git cherry-pick?

**Answer**:
Apply a specific commit from one branch to another:
```bash
git cherry-pick <commit-hash>
```
**Use Case**: Apply hotfix without merging entire branch

### Q8: What is Git stash?

**Answer**:
Temporarily save uncommitted changes:
```bash
git stash           # Save changes
git stash list      # List stashes
git stash pop       # Apply and remove
git stash apply     # Apply without removing
```

### Q9: What is a Git hook?

**Answer**:
Scripts that run automatically on git events:
```
pre-commit: Before commit
prepare-commit-msg: Before commit message
post-commit: After commit
pre-push: Before push
```

### Q10: What is Gitflow vs GitHub Flow?

**Answer**:
| Aspect | Gitflow | GitHub Flow |
|--------|---------|-------------|
| Branches | main, develop, feature, release, hotfix | main, feature |
| Complexity | High | Low |
| Release | Scheduled | On-demand |
| Use Case | Large projects | Continuous delivery |

---

## CI/CD Questions

### Q11: What is a CI/CD pipeline?

**Answer**:
Automated sequence of steps to build, test, and deploy code:

```
Continuous Integration (CI):
- Code commit -> Build -> Test -> Artifact

Continuous Delivery (CD):
- Artifact -> Staging Test -> Production

Continuous Deployment (CD):
- Artifact -> Automated Production Deploy
```

### Q12: What is a blue/green deployment?

**Answer**:
Two identical environments (Blue and Green):
```
1. Deploy v2 to Green
2. Test Green
3. Switch traffic from Blue to Green
4. Blue becomes backup
5. Rollback by switching back to Blue
```
**Benefits**: Zero downtime, easy rollback

### Q13: What is a canary deployment?

**Answer**:
Gradually roll out changes to a subset of users:
```
1. Deploy v2 to 5% of servers
2. Monitor for errors
3. Gradually increase to 10%, 25%, 50%, 100%
4. Rollback if issues detected
```
**Benefits**: Reduced risk, real-user testing

### Q14: What is a feature flag?

**Answer**:
Toggle features on/off without deploying code:
```javascript
if (featureFlags.isEnabled('new-checkout')) {
    return newCheckout();
} else {
    return oldCheckout();
}
```
**Benefits**: Decouple deploy from release, A/B testing

### Q15: What is infrastructure as code (IaC)?

**Answer**:
Managing infrastructure through machine-readable files:
- **Declarative**: Define desired state (Terraform, CloudFormation)
- **Imperative**: Define steps to achieve state (Ansible, Pulumi)
- **Benefits**: Version control, reproducibility, automation

---

## Infrastructure as Code Questions

### Q16: What is Terraform and how does it work?

**Answer**:
Declarative IaC tool for multi-cloud:
```bash
terraform init      # Initialize provider
terraform plan      # Preview changes
terraform apply     # Apply changes
terraform destroy   # Remove resources
```
**Key Concepts**: Providers, resources, state, modules

### Q17: What is Terraform state and why is it important?

**Answer**:
Tracks mapping between configuration and real infrastructure:
- **Purpose**: Know what to add/modify/destroy
- **Storage**: Local or remote (S3, Consul)
- **Best Practice**: Use remote state with locking
- **Risk**: State corruption can cause issues

### Q18: What is idempotency in IaC?

**Answer**:
Applying the same configuration multiple times produces the same result:
```
Run 1: Creates 3 VMs
Run 2: No changes (already exists)
Run 3: No changes (still same)
```
**Importance**: Safe to re-run, predictable

### Q19: What is the difference between Terraform and Ansible?

**Answer**:
| Aspect | Terraform | Ansible |
|--------|-----------|---------|
| Type | IaC (provisioning) | CM (configuration) |
| State | Maintains state | Stateless |
| Agent | Agentless | Agentless (SSH) |
| Language | HCL | YAML |
| Use Case | Create infrastructure | Configure infrastructure |

### Q20: What is configuration drift?

**Answer**:
When actual infrastructure diverges from desired state:
```
Desired: 3 web servers
Actual: 4 web servers (manual addition)
Drift: 1 extra server
```
**Detection**: `terraform plan`, `ansible --check`
**Prevention**: IaC, immutable infrastructure

---

## Containerization Questions

### Q21: What is Docker and why use it?

**Answer**:
Platform for building, shipping, running containers:
- **Consistency**: Same environment everywhere
- **Isolation**: Processes don't interfere
- **Portability**: Run anywhere with Docker
- **Efficiency**: Lightweight vs VMs

### Q22: What is the difference between Docker and VMs?

**Answer**:
| Aspect | Docker | VMs |
|--------|--------|-----|
| Virtualization | OS-level | Hardware-level |
| Size | Megabytes | Gigabytes |
| Startup | Seconds | Minutes |
| Performance | Near-native | Overhead |
| Isolation | Process-level | Full OS |

### Q23: What is a Dockerfile?

**Answer**:
Blueprint for building Docker images:
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]
```

### Q24: What is Docker Compose?

**Answer**:
Tool for multi-container applications:
```yaml
version: '3.8'
services:
  web:
    build: .
    ports:
      - "8080:80"
  db:
    image: postgres:14
  redis:
    image: redis:7-alpine
```

### Q25: What are Docker volumes?

**Answer**:
Persistent data storage for containers:
```bash
# Create volume
docker volume create mydata

# Use volume
docker run -v mydata:/app/data my-image

# Bind mount
docker run -v /host/path:/container/path my-image
```

---

## Kubernetes Questions

### Q26: What is Kubernetes and its architecture?

**Answer**:
Container orchestration platform:
```
Control Plane:
- API Server: Entry point
- etcd: State store
- Scheduler: Places pods
- Controller Manager: Maintains state

Worker Nodes:
- kubelet: Node agent
- kube-proxy: Networking
- Container Runtime: Docker/containerd
```

### Q27: What is a Kubernetes Pod?

**Answer**:
Smallest deployable unit, group of containers:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
```

### Q28: What is the difference between Deployment and StatefulSet?

**Answer**:
| Aspect | Deployment | StatefulSet |
|--------|------------|-------------|
| Use Case | Stateless apps | Stateful apps |
| Scaling | Random | Ordered |
| Identity | No | Stable network identity |
| Storage | Shared | Persistent per pod |

### Q29: What is a Kubernetes Service?

**Answer**:
Exposes pods to network:
```yaml
# ClusterIP (internal)
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: ClusterIP
  selector:
    app: my-app
  ports:
  - port: 80
    targetPort: 8080
```

**Types**: ClusterIP, NodePort, LoadBalancer, ExternalName

### Q30: What is a Kubernetes Ingress?

**Answer**:
HTTP routing to services:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
spec:
  rules:
  - host: myapp.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-service
            port:
              number: 80
```

---

## Monitoring Questions

### Q31: What is the difference between monitoring and observability?

**Answer**:
| Aspect | Monitoring | Observability |
|--------|------------|---------------|
| Focus | Known issues | Unknown issues |
| Approach | Predefined metrics | Explore any question |
| Data | Metrics, logs | Metrics, logs, traces |
| Goal | Detect anomalies | Understand system state |

### Q32: What are the three pillars of observability?

**Answer**:
1. **Metrics**: Numerical measurements (CPU, latency)
2. **Logs**: Event records (application logs)
3. **Traces**: Request paths (distributed tracing)

### Q33: What is Prometheus and how does it work?

**Answer**:
Time-series metrics database:
- **Pull-based**: Scrapes metrics from targets
- **PromQL**: Query language
- **Alerting**: Alertmanager integration
- **Storage**: Local time-series DB

```yaml
scrape_configs:
  - job_name: 'my-app'
    static_configs:
      - targets: ['app:8080']
```

### Q34: What is the difference between SLI, SLO, and SLA?

**Answer**:
| Term | Definition | Example |
|------|------------|---------|
| SLI | Metric measured | 99.5% successful requests |
| SLO | Target value | 99.9% availability |
| SLA | Contract with penalties | 99.9% uptime, credits if missed |

### Q35: What is a runbook?

**Answer**:
Step-by-step guide for incident response:
```
1. Alert: High CPU Usage
2. Impact: Application slow
3. Investigation:
   - Check top processes
   - Review recent deployments
   - Check for traffic spikes
4. Mitigation:
   - Scale up instances
   - Kill problematic process
5. Resolution:
   - Identify root cause
   - Apply permanent fix
```

---

## Security Questions

### Q36: What is DevSecOps?

**Answer**:
Integrating security into DevOps:
```
Traditional: Dev -> Security -> Ops
DevSecOps: Dev + Security + Ops (simultaneously)
```
**Practices**: SAST, DAST, SCA, container scanning, IaC scanning

### Q37: What is shift-left security?

**Answer**:
Moving security earlier in development:
```
Traditional: Code -> Test -> Security Review -> Deploy
Shift Left: Code + Security -> Test + Security -> Deploy
```
**Benefits**: Earlier detection, lower cost, faster fixes

### Q38: What is SAST vs DAST?

**Answer**:
| Aspect | SAST | DAST |
|--------|------|------|
| Type | Static Analysis | Dynamic Analysis |
| Timing | During development | During testing |
| Target | Source code | Running application |
| Speed | Fast | Slower |
| Coverage | Code paths | User workflows |

### Q39: What is a secrets manager?

**Answer**:
Secure storage for sensitive data:
- **Examples**: HashiCorp Vault, AWS Secrets Manager, Azure Key Vault
- **Features**: Encryption, rotation, access control
- **Best Practice**: Never commit secrets to Git

### Q40: What is container image scanning?

**Answer**:
Analyzing container images for vulnerabilities:
```bash
# Trivy
trivy image my-app:latest

# Snyk
snyk container test my-app:latest
```
**When**: Before deployment, in CI/CD pipeline

---

## Scenario-Based Questions

### Q41: How would you handle a production outage?

**Answer**:
```
1. Detection
   - Alert triggered
   - Impact assessment

2. Communication
   - Notify stakeholders
   - Status page update

3. Investigation
   - Check recent deployments
   - Review logs and metrics
   - Identify affected services

4. Mitigation
   - Rollback if deployment issue
   - Scale if capacity issue
   - Feature flag if code issue

5. Resolution
   - Fix root cause
   - Verify recovery
   - Monitor for recurrence

6. Postmortem
   - Timeline reconstruction
   - Root cause analysis
   - Action items
   - Lessons learned
```

### Q42: How would you reduce deployment risk?

**Answer**:
```
Strategies:
1. Blue/Green deployments
2. Canary releases
3. Feature flags
4. Automated testing
5. Rollback procedures
6. Monitoring and alerting
7. Gradual rollouts
8. Chaos engineering
```

### Q43: How would you implement GitOps?

**Answer**:
```
Architecture:
1. Git repository (source of truth)
2. CI pipeline (build and test)
3. GitOps controller (ArgoCD/Flux)
4. Kubernetes cluster

Workflow:
1. Developer pushes to Git
2. CI builds and pushes image
3. ArgoCD detects change
4. ArgoCD syncs to cluster
5. Status reported back to Git
```

### Q44: How would you optimize cloud costs?

**Answer**:
```
Strategies:
1. Right-sizing instances
2. Reserved instances (predictable)
3. Spot/preemptible (fault-tolerant)
4. Auto-scaling
5. Storage lifecycle
6. Monitor with FinOps tools
7. Eliminate waste
8. Tag resources for attribution
```

### Q45: How would you implement infrastructure as code?

**Answer**:
```
Approach:
1. Choose tool (Terraform, CloudFormation)
2. Define modules for reusability
3. Environment separation (dev/staging/prod)
4. State management (remote, encrypted)
5. Plan before apply
6. Version control everything
7. Testing and validation
8. Documentation
```

---

## Coding/Hands-On Questions

### Q46: Write a Dockerfile for a Node.js application

**Answer**:
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
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001
COPY --from=builder --chown=nextjs:nodejs /app/dist ./dist
COPY --from=builder --chown=nextjs:nodejs /app/node_modules ./node_modules
USER nextjs
EXPOSE 3000
CMD ["node", "dist/main.js"]
```

### Q47: Write a Terraform configuration for an AWS EC2 instance

**Answer**:
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "instance_type" {
  default = "t2.micro"
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type
  
  tags = {
    Name = "WebServer"
    Environment = "production"
  }
}

output "public_ip" {
  value = aws_instance.web.public_ip
}
```

### Q48: Write a Kubernetes deployment YAML

**Answer**:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  labels:
    app: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app
        image: my-app:latest
        ports:
        - containerPort: 8080
        resources:
          requests:
            memory: "128Mi"
            cpu: "250m"
          limits:
            memory: "256Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
```

### Q49: Write a GitHub Actions CI/CD pipeline

**Answer**:
```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Run tests
      run: npm test
    
    - name: Build
      run: npm run build
    
    - name: Log in to Container Registry
      if: github.ref == 'refs/heads/main'
      uses: docker/login-action@v2
      with:
        registry: ${{ env.REGISTRY }}
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}
    
    - name: Build and push Docker image
      if: github.ref == 'refs/heads/main'
      uses: docker/build-push-action@v4
      with:
        push: true
        tags: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
```

### Q50: Write a basic Ansible playbook

**Answer**:
```yaml
---
- hosts: web_servers
  become: yes
  vars:
    http_port: 80
    app_dir: /var/www/app
    
  tasks:
    - name: Update apt cache
      apt:
        update_cache: yes
        cache_valid_time: 3600
        
    - name: Install nginx
      apt:
        name: nginx
        state: present
        
    - name: Ensure nginx is running
      service:
        name: nginx
        state: started
        enabled: yes
        
    - name: Create app directory
      file:
        path: "{{ app_dir }}"
        state: directory
        owner: www-data
        group: www-data
        mode: '0755'
        
    - name: Deploy application config
      template:
        src: templates/nginx.conf.j2
        dest: /etc/nginx/sites-available/default
      notify: Restart nginx
      
  handlers:
    - name: Restart nginx
      service:
        name: nginx
        state: restarted
```

---

## Additional Resources

### Practice Platforms
- KillerCoda (Interactive Kubernetes)
- Katacoda (Scenario-based learning)
- DevOps Roadmap (roadmap.sh)
- Linux Academy

### Certifications
1. **CKA**: Certified Kubernetes Administrator
2. **CKAD**: Certified Kubernetes Application Developer
3. **Terraform Associate**: HashiCorp Terraform
4. **Docker Certified Associate**: Docker
5. **AWS DevOps Engineer**: Professional
6. **Azure DevOps Engineer**: Expert

### Key Skills to Master

```
Technical:
- Linux/Command Line
- Git
- Docker
- Kubernetes
- Terraform/Ansible
- CI/CD (Jenkins/GitHub Actions)
- Monitoring (Prometheus/Grafana)

Soft:
- Communication
- Collaboration
- Problem-solving
- Automation mindset
- Continuous learning
```
