# GCP Complete Guide - From Zero to Cloud Architect

## Table of Contents

1. [GCP Fundamentals](#gcp-fundamentals)
2. [GCP Global Infrastructure](#gcp-global-infrastructure)
3. [Getting Started](#getting-started)
4. [Core Services Deep Dive](#core-services-deep-dive)
5. [Compute Services](#compute-services)
6. [Storage Solutions](#storage-solutions)
7. [Database Services](#database-services)
8. [Networking in GCP](#networking-in-gcp)
9. [Identity & Security](#identity--security)
10. [Monitoring & Management](#monitoring--management)
11. [Cost Optimization](#cost-optimization)
12. [Best Practices](#best-practices)

---

## GCP Fundamentals

### What Makes GCP Unique?

- **Data Analytics**: BigQuery (serverless data warehouse)
- **Machine Learning**: Vertex AI, TensorFlow
- **Kubernetes**: GKE (created Kubernetes)
- **Open Source**: Strong OSS commitment
- **Network**: Google's private network backbone

### GCP vs AWS vs Azure Comparison

| Feature | GCP | AWS | Azure |
|---------|-----|-----|-------|
| Launch Year | 2008 | 2006 | 2010 |
| Market Share | 10% | 32% | 23% |
| Strengths | Data/ML, K8s | Broadest services | Enterprise |
| Free Tier | $300 for 90 days | 12 months | $200 for 30 days |
| Kubernetes | GKE (created K8s) | EKS | AKS |

---

## GCP Global Infrastructure

### Regions
- 40+ regions worldwide
- Choose based on: latency, compliance, service availability

### Zones
- Physically separate data centers
- 3+ zones per region
- Connected by private fiber

### Edge Locations
- 200+ CDN locations
- Google Global Load Balancer
- Cloud CDN

```
Region: us-central1 (Iowa)
    |
    +-- Zone a (Data Center)
    +-- Zone b (Data Center)
    +-- Zone c (Data Center)
    |
    +-- Edge Locations (CDN)
```

---

## Getting Started

### Step 1: Create GCP Account
1. Visit cloud.google.com
2. Sign up with Google account
3. Get $300 credit for 90 days
4. Access 25+ always-free services

### Step 2: Install gcloud CLI
```bash
# macOS
brew install google-cloud-sdk

# Windows
https://cloud.google.com/sdk/docs/install

# Linux
curl https://sdk.cloud.google.com | bash
```

### Step 3: Initialize gcloud
```bash
gcloud init
# Login with Google account
# Select project
# Set default region/zone
```

### Step 4: Set Up Project
```bash
# Create project
gcloud projects create my-project --name="My Project"
gcloud config set project my-project

# Enable billing
gcloud billing accounts list
gcloud billing projects link my-project --billing-account=ACCOUNT_ID
```

---

## Core Services Deep Dive

### Compute Engine

**What it does**: Provides resizable virtual machines (instances)

**Machine Types**:
| Type | Use Case | Example |
|------|----------|---------|
| E2 | Cost-effective general purpose | e2-medium, e2-standard-4 |
| N2 | Balanced performance | n2-standard-2, n2-highmem-4 |
| C2 | Compute optimized | c2-standard-4, c2-standard-8 |
| M2 | Memory optimized | m2-ultramem-208, m2-ultramem-416 |
| A2 | GPU optimized | a2-highgpu-1g, a2-ultragpu-8g |

**Pricing Options**:
- **Pay-As-You-Go**: Per second, 1-minute minimum
- **Sustained Use**: Automatic discounts (up to 30%)
- **Committed Use**: 1-3 year commitment (up to 57% savings)
- **Preemptible/Spot**: Up to 91% discount, can be preempted

```bash
# Create VM
gcloud compute instances create my-instance \
    --zone=us-central1-a \
    --machine-type=e2-medium \
    --image-family=debian-11 \
    --image-project=debian-cloud
```

### Cloud Storage

**What it does**: Object storage for any data

**Storage Classes**:
| Class | Use Case | Retrieval | Minimum |
|-------|----------|-----------|---------|
| Standard | Frequent access | Immediate | 0 days |
| Nearline | 30+ days | Immediate | 30 days |
| Coldline | 90+ days | Immediate | 90 days |
| Archive | 365+ days | Hours | 365 days |

```bash
# Create bucket
gsutil mb -l us-central1 gs://my-bucket

# Upload file
gsutil cp myfile.txt gs://my-bucket/

# Make public
gsutil iam ch allUsers:objectViewer gs://my-bucket
```

### VPC (Virtual Private Cloud)

**What it does**: Isolated network in GCP

```
VPC: 10.0.0.0/16
    |
    +-- Subnet: web (10.0.1.0/24)
    |       +-- VM (Web Server)
    |       +-- Firewall Rules
    |
    +-- Subnet: app (10.0.2.0/24)
    |       +-- VM (App Server)
    |       +-- Firewall Rules
    |
    +-- Subnet: data (10.0.3.0/24)
    |       +-- Cloud SQL
    |       +-- Firewall Rules
    |
    +-- Cloud Router
    +-- Cloud NAT
    +-- Cloud VPN
```

---

## Compute Services

### Compute Engine
- Full control over VMs
- Custom machine types
- Per-second billing

### Google Kubernetes Engine (GKE)
- Managed Kubernetes
- Autopilot (serverless) or Standard
- Best-in-class Kubernetes experience

### Cloud Run
- Serverless containers
- Scale to zero
- HTTP/HTTPS traffic

### Cloud Functions
- Serverless functions
- Event-driven
- Gen 1 (Node.js, Python, etc.) and Gen 2 (Cloud Events)

### App Engine
- Platform as a Service
- Standard (sandboxed) or Flexible
- Python, Java, Node.js, Go, PHP, Ruby, .NET

### Cloud Build
- Serverless CI/CD
- Build and test on Google infrastructure
- Integration with Cloud Deploy

---

## Storage Solutions

### Cloud Storage (Object)
- Petabyte-scale
- Four storage classes
- Versioning and lifecycle management

### Persistent Disk (Block)
- Network-attached storage for Compute Engine
- SSD or HDD
- Snapshots and cloning

### Filestore (File)
- Managed NFS file server
- Basic, Enterprise, and Zonal tiers
- Integration with GKE and Compute Engine

### Cloud Storage FUSE
- Mount Cloud Storage as a file system
- Linux-based applications
- Integration with GKE

---

## Database Services

| Service | Type | Use Case |
|---------|------|----------|
| Cloud SQL | Relational | MySQL, PostgreSQL, SQL Server |
| Cloud Spanner | Relational | Global, strongly consistent |
| Firestore | NoSQL Document | Mobile/web apps |
| Bigtable | Wide-column | IoT, analytics, time-series |
| Memorystore | In-Memory | Redis/Memcached caching |
| BigQuery | Data Warehouse | Analytics and ML |

### Cloud SQL
- Managed MySQL, PostgreSQL, SQL Server
- Automated backups and replication
- High availability configuration

### Cloud Spanner
- Globally distributed relational database
- 99.999% SLA
- Strong consistency at global scale

### Firestore
- NoSQL document database
- Real-time synchronization
- Offline support for mobile

### Bigtable
- Petabyte-scale NoSQL
- Low latency at high throughput
- HBase-compatible API

---

## Networking in GCP

### VPC Features

| Component | Description |
|-----------|-------------|
| VPC | Global virtual network |
| Subnet | Regional IP ranges |
| Firewall Rules | Allow/Deny traffic |
| Cloud Router | BGP routing |
| Cloud NAT | Outbound internet |
| Cloud VPN | Encrypted tunnels |
| Cloud Interconnect | Dedicated connections |

### Google Cloud Load Balancing

| Type | Use Case | Layer |
|------|----------|-------|
| Global HTTP(S) | Web applications | L7 |
| Global SSL Proxy | SSL/TLS traffic | L7 |
| Global TCP Proxy | TCP traffic | L4 |
| Regional Internal | Internal services | L4 |
| Regional External | External services | L4 |

### Cloud CDN
- Global edge caching
- Low latency content delivery
- Integration with Load Balancing

---

## Identity & Security

### Cloud IAM (Identity and Access Management)

**Roles**:
- **Basic**: Owner, Editor, Viewer
- **Predefined**: Service-specific roles
- **Custom**: Create your own

```bash
# Grant role
gcloud projects add-iam-policy-binding my-project \
    --member="user:admin@example.com" \
    --role="roles/compute.admin"
```

### Cloud Identity
- Managed users and groups
- SSO for Google Cloud
- Integration with Active Directory

### VPC Service Controls
- Security perimeters for GCP services
- Prevent data exfiltration
- Audit logging

### Cloud Armor
- DDoS protection
- WAF (Web Application Firewall)
- Integration with Load Balancing

### Secret Manager
- Store API keys, passwords, certificates
- Versioning and rotation
- Integration with GCP services

---

## Monitoring & Management

### Cloud Monitoring
- Metrics and dashboards
- Alerting policies
- Uptime checks
- SLI/SLO monitoring

### Cloud Logging
- Centralized logging
- Log-based metrics
- Export to BigQuery
- Log sinks and filters

### Cloud Trace
- Distributed tracing
- Latency analysis
- Performance optimization

### Cloud Profiler
- CPU and memory profiling
- Continuous profiling
- Production environment support

### Cloud Audit Logs
- Admin activity logs
- Data access logs
- System event logs

---

## Cost Optimization

### Strategies

| Strategy | Savings |
|----------|---------|
| Committed Use Discounts | Up to 57% |
| Preemptible/Spot VMs | Up to 91% |
| Sustained Use Discounts | Up to 30% |
| Right-sizing | Match VM to workload |
| Storage Classes | Nearline/Coldline/Archive |
| Preemptible VMs | Batch processing |

### Cost Management Tools

- **Billing Reports**: Visualize spending
- **Budgets & Alerts**: Set spending limits
- **Pricing Calculator**: Estimate costs
- **Cost Management**: Analyze and optimize
- **Recommender**: Optimization suggestions

```bash
# View billing report
gcloud billing reports --filter="services.enableDate>=2024-01-01"

# Create budget
gcloud billing budgets create \
    --billing-account=ACCOUNT_ID \
    --display-name="Monthly Budget" \
    --budget-amount=1000 \
    --threshold-rule=percent=80
```

---

## Best Practices

### Well-Architected Framework Pillars

1. **Operational Excellence**
   - Infrastructure as Code (Deployment Manager, Terraform)
   - CI/CD (Cloud Build, Cloud Deploy)
   - Monitoring and logging
   - Runbooks and automation

2. **Security**
   - Least privilege IAM
   - VPC Service Controls
   - Encryption at rest and in transit
   - Cloud Armor for DDoS

3. **Reliability**
   - Multi-zone deployments
   - Load balancing
   - Auto-healing
   - Backup and recovery

4. **Performance Efficiency**
   - Right-size machines
   - Use caching (Memorystore)
   - CDN for static content
   - Auto-scaling

5. **Cost Optimization**
   - Committed Use Discounts
   - Preemptible VMs for batch
   - Storage lifecycle
   - Monitor with Billing Reports

6. **Sustainability**
   - Choose efficient regions
   - Right-size resources
   - Use managed services
   - Auto-scaling

---

## Next Steps

1. Complete the [GCP Services Overview](gcp-services-overview.md)
2. Study [GCP Architecture](gcp-architecture.md) patterns
3. Practice with [Interview Questions](gcp-interview-questions.md)
4. Build a project: Deploy a 3-tier web application
5. Pursue Associate Cloud Engineer certification
