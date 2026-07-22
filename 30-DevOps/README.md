# DevOps - Culture, Practices & Tools

## Overview

DevOps is a set of practices, cultural philosophies, and tools that increase an organization's ability to deliver applications and services at high velocity. It combines software development (Dev) and IT operations (Ops) to shorten the development lifecycle and provide continuous delivery with high quality.

## Learning Path

### Stage 1: DevOps Fundamentals (Week 1-2)
- [DevOps Guide](devops-guide.md) - Complete beginner to intermediate guide
- Understanding DevOps culture and principles
- Version control with Git
- Linux/command line basics

### Stage 2: Core Tools (Week 3-4)
- [DevOps Tools](devops-tools.md) - Detailed tool catalog
- CI/CD pipelines
- Infrastructure as Code
- Configuration Management

### Stage 3: Practices & Methods (Week 5-6)
- [DevOps Practices](devops-practices.md) - Industry best practices
- Agile, Scrum, Kanban
- SRE practices
- GitOps and Platform Engineering

### Stage 4: Interview Preparation (Week 7-8)
- [DevOps Interview Questions](devops-interview-questions.md) - 100+ questions
- System design scenarios
- Hands-on lab exercises

## Key Files

| File | Description | Lines |
|------|-------------|-------|
| [devops-guide.md](devops-guide.md) | Comprehensive DevOps learning guide | 200 |
| [devops-tools.md](devops-tools.md) | All major DevOps tools explained | 200 |
| [devops-practices.md](devops-practices.md) | Industry best practices and methods | 200 |
| [devops-interview-questions.md](devops-interview-questions.md) | Interview prep with answers | 200 |

## DevOps Certification Paths

```
DevOps Fundamentals (DASA, DevOps Institute)
    |
    +---> Certified DevOps Engineer (AWS/Azure/GCP)
    |         |
    |         +---> Solutions Architect Professional
    |
    +---> Kubernetes Certifications
    |         |
    |         +---> CKA (Certified Kubernetes Administrator)
    |         +---> CKAD (Certified Kubernetes Application Developer)
    |
    +---> Terraform Certifications
    |         |
    |         +---> Terraform Associate
    |
    +---> Docker Certifications
              |
              +---> Docker Certified Associate
```

## DevOps Lifecycle

```
    +---------+     +---------+     +---------+
    | PLAN    | --> | CODE    | --> | BUILD   |
    +---------+     +---------+     +---------+
         |                               |
         |                               v
    +---------+     +---------+     +---------+
    | MONITOR | <-- | OPERATE | <-- | TEST    |
    +---------+     +---------+     +---------+
         |
         v
    +---------+
    | DEPLOY  |
    +---------+
```

## Core DevOps Practices

| Practice | Description | Tools |
|----------|-------------|-------|
| CI/CD | Continuous Integration/Delivery | Jenkins, GitHub Actions, GitLab CI |
| IaC | Infrastructure as Code | Terraform, Ansible, CloudFormation |
| Containers | Application packaging | Docker, Podman, containerd |
| Orchestration | Container management | Kubernetes, Docker Swarm |
| Monitoring | Observability | Prometheus, Grafana, ELK Stack |
| GitOps | Git-based workflow | ArgoCD, Flux, Helm |

## Quick Start Commands

```bash
# Install Docker
curl -fsSL https://get.docker.com | sh

# Install Kubernetes (minikube)
minikube start

# Install Terraform
brew install terraform

# Install Ansible
pip install ansible

# Install Jenkins
docker run -p 8080:8080 jenkins/jenkins:lts
```

## Prerequisites

- Basic programming knowledge
- Linux/command line familiarity
- Networking basics (IP, DNS, HTTP)
- Version control (Git)
- Text editor/IDE

## Resources

- [DevOps Roadmap](https://roadmap.sh/devops)
- [The Phoenix Project](https://itrevolution.com/the-phoenix-project/)
- [Site Reliability Engineering](https://sre.google/sre-book/table-of-contents/)
- [DevOps Days](https://devopsdays.org/)

---

**Next:** Start with [devops-guide.md](devops-guide.md) for a complete learning journey.
