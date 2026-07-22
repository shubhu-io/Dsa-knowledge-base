# AWS Complete Guide - From Zero to Cloud Architect

## Table of Contents

1. [Cloud Computing Basics](#cloud-computing-basics)
2. [AWS Global Infrastructure](#aws-global-infrastructure)
3. [Getting Started](#getting-started)
4. [Core Services Deep Dive](#core-services-deep-dive)
5. [Networking in AWS](#networking-in-aws)
6. [Storage Solutions](#storage-solutions)
7. [Compute Services](#compute-services)
8. [Database Services](#database-services)
9. [Security & IAM](#security--iam)
10. [Monitoring & Management](#monitoring--management)
11. [Cost Optimization](#cost-optimization)
12. [Best Practices](#best-practices)

---

## Cloud Computing Basics

### What is Cloud Computing?

Cloud computing is the on-demand delivery of computing power, database storage, applications, and other IT resources through a cloud services platform via the internet.

### Cloud Service Models

```
+---------------------------------------------------+
|              SaaS (Software as a Service)          |
|         Examples: Gmail, Salesforce, Dropbox       |
+---------------------------------------------------+
|              PaaS (Platform as a Service)          |
|       Examples: Elastic Beanstalk, Heroku          |
+---------------------------------------------------+
|              IaaS (Infrastructure as a Service)    |
|         Examples: EC2, Azure VMs, GCE             |
+---------------------------------------------------+
|              On-Premises Infrastructure            |
+---------------------------------------------------+
```

### Deployment Models

| Model | Description | Example |
|-------|-------------|---------|
| **Public Cloud** | Resources shared across organizations | AWS, Azure, GCP |
| **Private Cloud** | Dedicated to single organization | VMware, OpenStack |
| **Hybrid Cloud** | Mix of public and private | AWS Outposts |
| **Multi-Cloud** | Multiple cloud providers | AWS + Azure |

### Benefits of Cloud Computing

- **Cost Efficiency**: Pay only for what you use
- **Scalability**: Scale up or down instantly
- **Global Reach**: Deploy worldwide in minutes
- **Reliability**: Built-in redundancy and backups
- **Speed**: Deploy resources in seconds
- **Security**: Enterprise-grade security features

---

## AWS Global Infrastructure

### Regions
- Geographic areas with multiple Availability Zones
- Choose based on: latency, compliance, service availability, cost

### Availability Zones (AZs)
- Isolated locations within a region
- Connected by high-speed, low-latency networking
- Typically 3 AZs per region

### Edge Locations
- Content delivery network (CloudFront) endpoints
- 400+ locations worldwide
- Used for caching and DNS

```
Region: us-east-1 (N. Virginia)
    |
    +-- AZ-1a (Data Center)
    +-- AZ-1b (Data Center)
    +-- AZ-1c (Data Center)
    |
    +-- Edge Locations (CDN)
```

---

## Getting Started

### Step 1: Create AWS Account
1. Visit aws.amazon.com
2. Sign up with email and payment method
3. Verify phone number
4. Select support plan (Free tier recommended for beginners)

### Step 2: Set Up IAM Root Account Security
```bash
# Enable MFA on root account
# Create admin user with programmatic access
# Never use root account for daily tasks
```

### Step 3: Install AWS CLI
```bash
# Windows
msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi

# macOS
brew install awscli

# Linux
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

### Step 4: Configure Credentials
```bash
aws configure
# AWS Access Key ID: ****
# AWS Secret Access Key: ****
# Default region name: us-east-1
# Default output format: json
```

---

## Core Services Deep Dive

### Amazon EC2 (Elastic Compute Cloud)

**What it does**: Provides resizable virtual machines (instances)

**Instance Types**:
| Type | Use Case | Example |
|------|----------|---------|
| General Purpose | Balanced compute, memory, networking | t3, m5 |
| Compute Optimized | CPU-intensive tasks | c5, c6g |
| Memory Optimized | In-memory databases, real-time | r5, x1 |
| Storage Optimized | High sequential read/write | i3, d2 |
| Accelerated Computing | GPU/ML workloads | p4, g4 |

**Pricing Models**:
- **On-Demand**: Pay per hour, no commitment
- **Reserved**: 1-3 year commitment, up to 75% savings
- **Spot**: Up to 90% off, can be interrupted
- **Dedicated**: Single-tenant hardware

```bash
# Launch EC2 instance
aws ec2 run-instances \
    --image-id ami-0c55b159cbfafe1f0 \
    --instance-type t2.micro \
    --key-name MyKeyPair \
    --security-group-ids sg-12345678 \
    --subnet-id subnet-12345678
```

### Amazon S3 (Simple Storage Service)

**What it does**: Object storage with 99.999999999% durability

**Storage Classes**:
| Class | Use Case | Retrieval |
|-------|----------|-----------|
| S3 Standard | Frequently accessed data | Immediate |
| S3 Intelligent | Unknown/changing access | Immediate |
| S3 Standard-IA | Infrequent access | Immediate |
| S3 One Zone-IA | Non-critical, re-creatible | Immediate |
| S3 Glacier | Archive, long-term | Minutes-hours |
| S3 Glacier Deep Archive | Rarely accessed | Hours |

```bash
# Create bucket
aws s3 mb s3://my-bucket --region us-east-1

# Upload file
aws s3 cp myfile.txt s3://my-bucket/

# Sync directory
aws s3 sync ./local-dir s3://my-bucket/remote-dir
```

### Amazon VPC (Virtual Private Cloud)

**What it does**: Isolated virtual network in AWS

```
VPC: 10.0.0.0/16
    |
    +-- Public Subnet (10.0.1.0/24)
    |       +-- Web Server (EC2)
    |       +-- NAT Gateway
    |
    +-- Private Subnet (10.0.2.0/24)
    |       +-- App Server (EC2)
    |       +-- Database (RDS)
    |
    +-- Internet Gateway
    +-- Route Tables
    +-- Security Groups
    +-- NACLs
```

---

## Networking in AWS

### Key Components

| Component | Description |
|-----------|-------------|
| VPC | Your virtual network |
| Subnet | IP range within VPC |
| Route Table | Controls traffic routing |
| Internet Gateway | Connects VPC to internet |
| NAT Gateway | Allows outbound internet for private subnets |
| Security Group | Stateful firewall (instance level) |
| NACL | Stateless firewall (subnet level) |

### VPC Peering
- Connect two VPCs privately
- Can peer within same or different regions
- Cannot overlap CIDR ranges

### Transit Gateway
- Hub for connecting multiple VPCs and on-premises
- Simplifies network architecture
- Supports multicast

---

## Storage Solutions

### Block Storage (EBS)
- Network-attached storage for EC2
- Persist data when instance stops
- Types: gp3, io1, io2, st1, sc1

### Object Storage (S3)
- Store unlimited objects (files)
- HTTP/HTTPS access
- Versioning and lifecycle policies

### File Storage (EFS)
- Managed NFS file system
- Multiple EC2 instances can access simultaneously
- Scalable and elastic

### File Storage (FSx)
- Managed Windows File Server or Lustre
- For Windows workloads or HPC

---

## Database Services

| Service | Type | Use Case |
|---------|------|----------|
| RDS | Relational | Traditional SQL workloads |
| Aurora | Relational | MySQL/PostgreSQL compatible, 5x faster |
| DynamoDB | NoSQL Key-Value | Single-digit ms latency at scale |
| ElastiCache | In-Memory | Caching, session management |
| Redshift | Data Warehouse | Analytics and reporting |
| Neptune | Graph | Social networks, fraud detection |
| DocumentDB | Document | MongoDB-compatible |
| Keyspaces | Wide-column | Cassandra-compatible |

---

## Security & IAM

### IAM Best Practices

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::my-bucket/*"
        }
    ]
}
```

1. **Least Privilege**: Grant minimum permissions needed
2. **MFA**: Enable on all users
3. **Rotate Credentials**: Regular key rotation
4. **Use Roles**: Not access keys for EC2/Lambda
5. **CloudTrail**: Log all API calls

### Security Services

| Service | Purpose |
|---------|---------|
| IAM | Access management |
| KMS | Encryption key management |
| WAF | Web application firewall |
| Shield | DDoS protection |
| GuardDuty | Threat detection |
| Inspector | Vulnerability assessment |
| Macie | Data privacy for S3 |
| Security Hub | Security posture management |

---

## Monitoring & Management

### Amazon CloudWatch
- Metrics, logs, and alarms
- Custom dashboards
- Auto-scaling triggers

```bash
# Create alarm for CPU usage
aws cloudwatch put-metric-alarm \
    --alarm-name "High-CPU" \
    --metric-name CPUUtilization \
    --namespace AWS/EC2 \
    --statistic Average \
    --period 300 \
    --threshold 80 \
    --comparison-operator GreaterThanThreshold
```

### AWS CloudTrail
- Log all API calls
- Compliance auditing
- Operational troubleshooting

### AWS Config
- Track resource configurations
- Compliance rules
- Change history

---

## Cost Optimization

### Strategies

| Strategy | Savings |
|----------|---------|
| Right-sizing | Match instance to workload |
| Reserved Instances | Up to 75% vs On-Demand |
| Spot Instances | Up to 90% vs On-Demand |
| Savings Plans | Flexible pricing commitment |
| S3 Lifecycle | Move old data to cheaper tiers |
| Unused Resources | Stop/delete idle resources |

### Cost Monitoring Tools
- **AWS Cost Explorer**: Visualize and forecast costs
- **AWS Budgets**: Set spending alerts
- **Cost & Usage Reports**: Detailed billing data
- **Trusted Advisor**: Optimization recommendations

---

## Best Practices

### Well-Architected Framework Pillars

1. **Operational Excellence**
   - Infrastructure as Code (CloudFormation)
   - CI/CD pipelines
   - Monitoring and logging

2. **Security**
   - Encrypt everything
   - Enable MFA everywhere
   - Audit with CloudTrail

3. **Reliability**
   - Multi-AZ deployments
   - Auto-scaling
   - Backup and recovery

4. **Performance Efficiency**
   - Choose right instance types
   - Use caching (ElastiCache, CloudFront)
   - CDN for static content

5. **Cost Optimization**
   - Monitor with Cost Explorer
   - Use appropriate storage classes
   - Clean up unused resources

6. **Sustainability**
   - Right-size resources
   - Use Spot Instances
   - Minimize data transfer

---

## Next Steps

1. Complete the [AWS Services Overview](aws-services-overview.md)
2. Study [AWS Architecture](aws-architecture.md) patterns
3. Practice with [Interview Questions](aws-interview-questions.md)
4. Build a project: Deploy a 3-tier web application
5. Pursue AWS Certified Solutions Architect Associate
