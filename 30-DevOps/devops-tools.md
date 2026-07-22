# DevOps Tools - Complete Reference Guide

## Table of Contents

1. [Version Control](#version-control)
2. [CI/CD Tools](#cicd-tools)
3. [Infrastructure as Code](#infrastructure-as-code)
4. [Configuration Management](#configuration-management)
5. [Containerization](#containerization)
6. [Container Orchestration](#container-orchestration)
7. [Monitoring & Observability](#monitoring--observability)
8. [Artifact Management](#artifact-management)
9. [Security Tools](#security-tools)
10. [Collaboration Tools](#collaboration-tools)

---

## Version Control

### Git
- **Type**: Distributed Version Control
- **Use Case**: Source code management
- **Features**: Branching, merging, rebasing, staging
- **Hosting**: GitHub, GitLab, Bitbucket

### GitHub
- **Type**: Cloud-based Git Hosting
- **Use Case**: Code hosting, collaboration
- **Features**: Pull requests, Actions, Codespaces
- **Pricing**: Free for public repos

### GitLab
- **Type**: DevOps Platform
- **Use Case**: Complete DevOps lifecycle
- **Features**: CI/CD, registry, security scanning
- **Deployment**: SaaS, Self-hosted

### Bitbucket
- **Type**: Git Hosting
- **Use Case**: Enterprise Git
- **Features**: Pipelines, Jira integration
- **Pricing**: Free for small teams

---

## CI/CD Tools

### Jenkins
- **Type**: Self-hosted CI/CD
- **Use Case**: Extensible automation server
- **Features**: 1800+ plugins, pipeline as code
- **Language**: Java
- **Learning Curve**: Medium-High

```groovy
// Jenkinsfile
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'npm install'
                sh 'npm run build'
            }
        }
        stage('Test') {
            steps {
                sh 'npm test'
            }
        }
        stage('Deploy') {
            steps {
                sh './deploy.sh'
            }
        }
    }
}
```

### GitHub Actions
- **Type**: Cloud-native CI/CD
- **Use Case**: GitHub repository automation
- **Features**: Marketplace, matrix builds, caching
- **Pricing**: Free for public repos, 2000 min/month

```yaml
# .github/workflows/ci.yml
name: CI
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - run: npm ci
    - run: npm test
    - run: npm run build
```

### GitLab CI/CD
- **Type**: Integrated CI/CD
- **Use Case**: GitLab repository automation
- **Features**: Auto DevOps, security scanning, registry
- **YAML**: .gitlab-ci.yml

```yaml
# .gitlab-ci.yml
stages:
  - build
  - test
  - deploy

build:
  stage: build
  script:
    - npm install
    - npm run build

test:
  stage: test
  script:
    - npm test

deploy:
  stage: deploy
  script:
    - ./deploy.sh
  only:
    - main
```

### CircleCI
- **Type**: Cloud CI/CD
- **Use Case**: Fast, scalable builds
- **Features**: Parallelism, caching, orbs
- **Pricing**: Free tier available

### Travis CI
- **Type**: Cloud CI/CD
- **Use Case**: Open source projects
- **Features**: Multi-language, Docker support
- **Pricing**: Free for open source

### ArgoCD
- **Type**: GitOps CD
- **Use Case**: Kubernetes deployments
- **Features**: Declarative, auto-sync, rollback
- **Integration**: Helm, Kustomize

```yaml
# argocd-application.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: my-app
spec:
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  source:
    repoURL: https://github.com/user/repo
    path: k8s
    targetRevision: main
```

---

## Infrastructure as Code

### Terraform
- **Type**: Declarative IaC
- **Use Case**: Multi-cloud infrastructure
- **Features**: State management, modules, providers
- **Language**: HCL (HashiCorp Configuration Language)
- **Learning Curve**: Medium

```hcl
# main.tf
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

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  
  tags = {
    Name = "WebServer"
  }
}
```

### Ansible
- **Type**: Imperative IaC + CM
- **Use Case**: Configuration management, app deployment
- **Features**: Agentless, YAML, idempotent
- **Learning Curve**: Low

```yaml
# playbook.yml
- hosts: webservers
  become: yes
  vars:
    http_port: 80
    
  tasks:
    - name: Install nginx
      apt:
        name: nginx
        state: present
        
    - name: Copy config
      template:
        src: nginx.conf.j2
        dest: /etc/nginx/nginx.conf
      notify: Restart nginx
      
  handlers:
    - name: Restart nginx
      service:
        name: nginx
        state: restarted
```

### CloudFormation
- **Type**: AWS-native IaC
- **Use Case**: AWS resource provisioning
- **Features**: Drift detection, stack policies
- **Language**: YAML/JSON

```yaml
# template.yaml
Resources:
  MyInstance:
    Type: AWS::EC2::Instance
    Properties:
      InstanceType: t2.micro
      ImageId: ami-0c55b159cbfafe1f0
      Tags:
        - Key: Name
          Value: WebServer
```

### Pulumi
- **Type**: Imperative IaC
- **Use Case**: Multi-cloud with programming languages
- **Features**: Real programming languages, state management
- **Languages**: TypeScript, Python, Go, C#

```typescript
// index.ts
import * as aws from "@pulumi/aws";

const server = new aws.ec2.Instance("web-server", {
    ami: "ami-0c55b159cbfafe1f0",
    instanceType: "t2.micro",
    tags: {
        Name: "WebServer",
    },
});
```

---

## Configuration Management

### Puppet
- **Type**: Agent-based CM
- **Use Case**: Enterprise configuration management
- **Features**: Desired state, reporting, compliance
- **Language**: Puppet DSL

```puppet
# site.pp
package { 'nginx':
  ensure => installed,
}

service { 'nginx':
  ensure => running,
  enable => true,
}

file { '/etc/nginx/nginx.conf':
  ensure => file,
  source => 'puppet:///modules/nginx/nginx.conf',
  notify => Service['nginx'],
}
```

### Chef
- **Type**: Agent-based CM
- **Use Case**: Infrastructure automation
- **Features**: Cookbooks, recipes, compliance
- **Language**: Ruby

```ruby
# recipe.rb
package 'nginx' do
  action :install
end

service 'nginx' do
  action [:enable, :start]
end
```

### SaltStack
- **Type**: Agent-based CM
- **Use Case**: Configuration management at scale
- **Features**: Event-driven, remote execution
- **Language**: YAML/Python

```yaml
# state.sls
nginx:
  pkg.installed:
    - name: nginx
  service.running:
    - name: nginx
    - enable: True
```

---

## Containerization

### Docker
- **Type**: Container Runtime
- **Use Case**: Application packaging
- **Features**: Images, containers, volumes, networks
- **Learning Curve**: Low-Medium

```dockerfile
# Dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]
```

### Podman
- **Type**: Container Runtime
- **Use Case**: Rootless containers
- **Features**: Daemonless, OCI-compatible
- **Use Case**: Security-focused environments

### Buildah
- **Type**: Container Build Tool
- **Use Case**: Build OCI images
- **Features**: Scriptable, no daemon
- **Integration**: Podman, Docker

### Harbor
- **Type**: Container Registry
- **Use Case**: Enterprise container image storage
- **Features**: Vulnerability scanning, RBAC, replication

### Nexus Repository
- **Type**: Artifact Repository
- **Use Case**: Store build artifacts
- **Support**: Docker, Maven, npm, PyPI

---

## Container Orchestration

### Kubernetes
- **Type**: Container Orchestration
- **Use Case**: Production container management
- **Features**: Auto-scaling, self-healing, rolling updates
- **Learning Curve**: High

**Managed Services**:
| Provider | Service | Features |
|----------|---------|----------|
| AWS | EKS | Integrated with AWS |
| Azure | AKS | Azure AD integration |
| GCP | GKE | Best-in-class |
| Rancher | Rancher | Multi-cluster |

### Docker Swarm
- **Type**: Container Orchestration
- **Use Case**: Simple orchestration
- **Features**: Easy setup, Docker native
- **Learning Curve**: Low

### Nomad
- **Type**: Workload Orchestrator
- **Use Case**: Non-container workloads
- **Features**: Multi-runtime, simple
- **Learning Curve**: Medium

### Helm
- **Type**: Kubernetes Package Manager
- **Use Case**: Deploy and manage K8s apps
- **Features**: Charts, repositories, releases

```bash
# Helm commands
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/nginx
helm upgrade my-release bitnami/nginx
helm rollback my-release 1
```

---

## Monitoring & Observability

### Prometheus
- **Type**: Metrics Collection
- **Use Case**: Time-series metrics
- **Features**: PromQL, alerting, service discovery
- **Integration**: Grafana

```yaml
# prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'node-exporter'
    static_configs:
      - targets: ['localhost:9100']
```

### Grafana
- **Type**: Visualization
- **Use Case**: Dashboards and alerts
- **Features**: Multiple data sources, plugins
- **Integration**: Prometheus, Elasticsearch, CloudWatch

### ELK Stack
- **Type**: Log Management
- **Use Case**: Centralized logging
- **Components**:
  - Elasticsearch: Search and storage
  - Logstash: Log processing
  - Kibana: Visualization

### Loki
- **Type**: Log Aggregation
- **Use Case**: Log management (like Prometheus for logs)
- **Features**: Label-based indexing, Grafana integration

### Jaeger
- **Type**: Distributed Tracing
- **Use Case**: Trace requests across services
- **Features**: OpenTracing, visualization

### Datadog
- **Type**: Cloud Monitoring
- **Use Case**: Full-stack observability
- **Features**: APM, logs, metrics, security
- **Pricing**: SaaS (paid)

### New Relic
- **Type**: Application Performance Monitoring
- **Use Case**: APM and observability
- **Features**: Real-time monitoring, error tracking
- **Pricing**: SaaS (free tier available)

---

## Artifact Management

### JFrog Artifactory
- **Type**: Universal Artifact Repository
- **Use Case**: Store all artifact types
- **Support**: Docker, Maven, npm, PyPI, Go
- **Features**: Replication, security scanning

### Nexus Repository
- **Type**: Artifact Repository
- **Use Case**: Open source artifact management
- **Support**: Docker, Maven, npm, PyPI

### Docker Hub
- **Type**: Cloud Container Registry
- **Use Case**: Store and share Docker images
- **Features**: Automated builds, webhooks

### Amazon ECR
- **Type**: AWS Container Registry
- **Use Case**: Store Docker images on AWS
- **Integration**: EKS, ECS, Lambda

### Google Artifact Registry
- **Type**: GCP Artifact Repository
- **Use Case**: Store Docker, Maven, npm artifacts
- **Integration**: GKE, Cloud Build

---

## Security Tools

### Snyk
- **Type**: Developer Security
- **Use Case**: Find and fix vulnerabilities
- **Features**: SCA, SAST, container scanning
- **Integration**: GitHub, GitLab, IDE

### Trivy
- **Type**: Vulnerability Scanner
- **Use Case**: Scan containers, filesystems, repos
- **Features**: OCI-compatible, fast, comprehensive

```bash
# Scan container image
trivy image my-app:latest

# Scan filesystem
trivy fs .
```

### OWASP ZAP
- **Type**: DAST Scanner
- **Use Case**: Web application security testing
- **Features**: Automated scanning, API support

### SonarQube
- **Type**: Code Quality
- **Use Case**: Static code analysis
- **Features**: 27+ languages, quality gates
- **Integration**: CI/CD pipelines

### HashiCorp Vault
- **Type**: Secrets Management
- **Use Case**: Store and manage secrets
- **Features**: Dynamic secrets, encryption, PKI

---

## Collaboration Tools

### Slack
- **Type**: Team Communication
- **Use Case**: DevOps collaboration
- **Features**: Channels, integrations, bots

### Microsoft Teams
- **Type**: Team Communication
- **Use Case**: Enterprise collaboration
- **Integration**: Azure DevOps, Office 365

### Jira
- **Type**: Project Management
- **Use Case**: Agile project tracking
- **Features**: Scrum, Kanban, reporting

### Confluence
- **Type**: Documentation
- **Use Case**: Knowledge management
- **Integration**: Jira, Bitbucket

### PagerDuty
- **Type**: Incident Management
- **Use Case**: On-call scheduling, alerting
- **Features**: Escalation policies, integrations

---

## Tools Comparison Matrix

| Category | Tool | Type | Learning Curve |
|----------|------|------|----------------|
| CI/CD | Jenkins | Self-hosted | Medium-High |
| CI/CD | GitHub Actions | Cloud | Low |
| CI/CD | GitLab CI | Integrated | Low-Medium |
| IaC | Terraform | Declarative | Medium |
| IaC | Ansible | Imperative | Low |
| CM | Puppet | Agent-based | Medium-High |
| CM | Chef | Agent-based | Medium |
| Container | Docker | Runtime | Low-Medium |
| Orchestration | Kubernetes | Platform | High |
| Monitoring | Prometheus | Metrics | Medium |
| Monitoring | Grafana | Visualization | Low |
| Logging | ELK Stack | Logs | Medium-High |
| Tracing | Jaeger | Traces | Medium |
| Security | Trivy | Scanner | Low |
| Security | Snyk | SCA/SAST | Low |
