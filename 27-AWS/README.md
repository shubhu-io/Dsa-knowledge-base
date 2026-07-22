# Amazon Web Services (AWS) - Cloud Computing Platform

## Overview

Amazon Web Services (AWS) is the world's most comprehensive and widely adopted cloud platform, offering over 200 fully featured services from data centers globally. Launched in 2006, AWS provides on-demand cloud computing platforms and APIs to individuals, companies, and governments.

## Learning Path

### Stage 1: Cloud Fundamentals (Week 1-2)
- [AWS Guide](aws-guide.md) - Complete beginner to intermediate guide
- Understanding cloud computing concepts
- AWS Global Infrastructure
- IAM (Identity and Access Management)

### Stage 2: Core Services (Week 3-4)
- [AWS Services Overview](aws-services-overview.md) - Detailed service catalog
- EC2, S3, RDS, VPC
- Hands-on labs with AWS Free Tier

### Stage 3: Architecture & Design (Week 5-6)
- [AWS Architecture](aws-architecture.md) - Well-Architected Framework
- Designing resilient architectures
- Cost optimization strategies

### Stage 4: Interview Preparation (Week 7-8)
- [AWS Interview Questions](aws-interview-questions.md) - 100+ questions
- System design scenarios
- Hands-on project deployment

## Key Files

| File | Description | Lines |
|------|-------------|-------|
| [aws-guide.md](aws-guide.md) | Comprehensive AWS learning guide | 200 |
| [aws-services-overview.md](aws-services-overview.md) | All major AWS services explained | 200 |
| [aws-architecture.md](aws-architecture.md) | Well-Architected Framework & patterns | 200 |
| [aws-interview-questions.md](aws-interview-questions.md) | Interview prep with answers | 200 |

## AWS Certification Paths

```
Cloud Practitioner (CLF-C02)
    |
    +---> Solutions Architect Associate (SAA-C03)
    |         |
    |         +---> Solutions Architect Professional (SAP-C02)
    |
    +---> Developer Associate (DVA-C02)
    |         |
    |         +---> DevOps Engineer Professional (DOP-C02)
    |
    +---> SysOps Administrator Associate (SOA-C02)
```

## AWS Global Regions

| Region | Location | Use Case |
|--------|----------|----------|
| us-east-1 | N. Virginia | Default, largest |
| us-west-2 | Oregon | West Coast US |
| eu-west-1 | Ireland | Europe |
| ap-southeast-1 | Singapore | Asia Pacific |
| ap-northeast-1 | Tokyo | Japan |

## Quick Start Commands

```bash
# Install AWS CLI
pip install awscli

# Configure AWS CLI
aws configure

# List S3 buckets
aws s3 ls

# Launch an EC2 instance
aws ec2 run-instances --image-id ami-0c55b159cbfafe1f0 \
    --instance-type t2.micro --key-name MyKeyPair
```

## Prerequisites

- AWS Free Tier account (12 months free)
- Basic understanding of networking (IP, DNS, HTTP)
- Command line familiarity
- Programming knowledge (Python, JavaScript helpful)

## Resources

- [AWS Documentation](https://docs.aws.amazon.com/)
- [AWS Well-Architected Labs](https://wellarchitectedlabs.com/)
- [AWS Skill Builder](https://skillbuilder.aws/)
- [AWS re:Post](https://repost.aws/)

---

**Next:** Start with [aws-guide.md](aws-guide.md) for a complete learning journey.
