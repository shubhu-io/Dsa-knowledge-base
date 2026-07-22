# Google Cloud Platform (GCP) - Cloud Computing Platform

## Overview

Google Cloud Platform (GCP) is a suite of cloud computing services provided by Google, running on the same infrastructure that Google uses internally for its end-user products. GCP excels in data analytics, machine learning, Kubernetes, and open-source technologies.

## Learning Path

### Stage 1: Cloud Fundamentals (Week 1-2)
- [GCP Guide](gcp-guide.md) - Complete beginner to intermediate guide
- Understanding GCP cloud concepts
- GCP Global Infrastructure
- IAM and Organization policies

### Stage 2: Core Services (Week 3-4)
- [GCP Services Overview](gcp-services-overview.md) - Detailed service catalog
- Compute Engine, Cloud Storage, Cloud SQL, VPC
- Hands-on labs with GCP Free Tier

### Stage 3: Architecture & Design (Week 5-6)
- [GCP Architecture](gcp-architecture.md) - Well-Architected Framework
- Designing resilient architectures
- Cost optimization strategies

### Stage 4: Interview Preparation (Week 7-8)
- [GCP Interview Questions](gcp-interview-questions.md) - 100+ questions
- System design scenarios
- Hands-on project deployment

## Key Files

| File | Description | Lines |
|------|-------------|-------|
| [gcp-guide.md](gcp-guide.md) | Comprehensive GCP learning guide | 200 |
| [gcp-services-overview.md](gcp-services-overview.md) | All major GCP services explained | 200 |
| [gcp-architecture.md](gcp-architecture.md) | Well-Architected Framework & patterns | 200 |
| [gcp-interview-questions.md](gcp-interview-questions.md) | Interview prep with answers | 200 |

## GCP Certification Paths

```
Cloud Digital Leader (Foundational)
    |
    +---> Associate Cloud Engineer
    |         |
    |         +---> Professional Cloud Architect
    |         +---> Professional Cloud DevOps Engineer
    |
    +---> Associate Google Cloud Engineer (ACE)
    |
    +---> Professional Data Engineer
    +---> Professional ML Engineer
    +---> Professional Security Engineer
    +---> Professional Cloud Network Engineer
```

## GCP Global Regions

| Region | Location | Use Case |
|--------|----------|----------|
| us-central1 | Iowa | Default, most services |
| us-east1 | South Carolina | US East Coast |
| europe-west1 | Belgium | Europe |
| asia-east1 | Taiwan | Asia Pacific |
| asia-northeast1 | Tokyo | Japan |

## Quick Start Commands

```bash
# Install gcloud CLI
brew install google-cloud-sdk

# Initialize gcloud
gcloud init

# Create project
gcloud projects create my-project --name="My Project"

# Create VM
gcloud compute instances create my-instance \
    --zone=us-central1-a \
    --machine-type=e2-medium \
    --image-family=debian-11 \
    --image-project=debian-cloud
```

## Prerequisites

- GCP Free Account ($300 credit for 90 days)
- Basic understanding of networking
- Command line familiarity
- Programming knowledge (Python, Go, Java helpful)

## Resources

- [GCP Documentation](https://cloud.google.com/docs)
- [GCP Architecture Center](https://cloud.google.com/architecture)
- [Google Cloud Training](https://cloud.google.com/training)
- [Qwiklabs](https://www.cloudskillsboost.google/)

---

**Next:** Start with [gcp-guide.md](gcp-guide.md) for a complete learning journey.
