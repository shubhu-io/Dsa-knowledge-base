# GCP Architecture - Well-Architected Framework & Patterns

## Table of Contents

1. [GCP Well-Architected Framework](#gcp-well-architected-framework)
2. [Common Architecture Patterns](#common-architecture-patterns)
3. [Reference Architectures](#reference-architectures)
4. [High Availability & Disaster Recovery](#high-availability--disaster-recovery)
5. [Security Architecture](#security-architecture)
6. [Cost-Effective Architectures](#cost-effective-architectures)
7. [Scalability Patterns](#scalability-patterns)

---

## GCP Well-Architected Framework

### The Six Pillars

```
                    +-------------------+
                    |   Operational     |
                    |   Excellence      |
                    +--------+----------+
                             |
        +--------------------+--------------------+
        |                                         |
+-------+----------+                   +----------+--------+
|    Security      |                   |   Reliability      |
+-------+----------+                   +----------+--------+
        |                                         |
        +--------------------+--------------------+
                             |
                    +--------+----------+
                    |    Performance     |
                    |    Efficiency      |
                    +--------+----------+
                             |
        +--------------------+--------------------+
        |                                         |
+-------+----------+                   +----------+--------+
|      Cost        |                   |  Sustainability   |
|   Optimization   |                   |                   |
+------------------+                   +-------------------+
```

### Pillar 1: Operational Excellence

**Practices**:
- Infrastructure as Code (Deployment Manager, Terraform)
- CI/CD pipelines (Cloud Build, Cloud Deploy)
- Monitoring and observability (Cloud Monitoring, Logging)
- Runbooks and automation

**Key Services**:
- Cloud Build
- Cloud Deploy
- Cloud Monitoring
- Cloud Logging

**Example Architecture**:
```
Developer -> Cloud Source Repos -> Cloud Build -> Cloud Deploy -> GKE/Cloud Run
                                        |
                                  Cloud Monitoring Alerts
                                        |
                                  Notification Channels
```

### Pillar 2: Security

**Practices**:
- Least privilege IAM
- VPC Service Controls
- Encryption at rest and in transit
- Cloud Armor for DDoS

**Key Services**:
- Cloud IAM, Cloud Identity
- VPC Service Controls
- Cloud KMS, Secret Manager
- Cloud Armor, Security Command Center

**Defense in Depth**:
```
Layer 1: Edge (Cloud Armor, Cloud CDN, Load Balancing)
Layer 2: Network (VPC, Firewall Rules, Cloud NAT)
Layer 3: Identity (Cloud IAM, Organization Policies)
Layer 4: Data (Cloud KMS, Encryption)
Layer 5: Application (Binary Authorization, Secret Manager)
Layer 6: Monitoring (Cloud Audit Logs, Security Command Center)
```

### Pillar 3: Reliability

**Practices**:
- Multi-zone deployments
- Load balancing and auto-healing
- Backup and disaster recovery
- Chaos engineering

**Key Services**:
- Cloud Load Balancing
- GKE (self-healing)
- Cloud SQL (HA, replicas)
- Cloud Storage (multi-region)

**Architecture Pattern**:
```
Multi-Zone Architecture:

Region: us-central1
    |
    +-- Zone a
    |       +-- Compute Engine (Web Server)
    |       +-- Cloud SQL (Primary)
    |
    +-- Zone b
    |       +-- Compute Engine (Web Server)
    |       +-- Cloud SQL (Standby)
    |
    +-- Zone c
    |       +-- Compute Engine (Web Server)
    |       +-- Cloud Storage (Data)
    |
    +-- Cloud Load Balancer
    +-- Cloud CDN
```

### Pillar 4: Performance Efficiency

**Practices**:
- Right-size machines
- Use caching (Memorystore)
- CDN for static content
- Auto-scaling

**Key Services**:
- Cloud CDN
- Memorystore
- Cloud Load Balancing
- Compute Engine (custom machine types)

### Pillar 5: Cost Optimization

**Practices**:
- Committed Use Discounts
- Preemptible/Spot VMs
- Sustained Use Discounts
- Monitor with Billing Reports

**Key Services**:
- Billing Reports
- Cost Management
- Recommender
- Pricing Calculator

**Cost Decision Tree**:
```
Is the workload predictable?
    |
    +-- Yes: Committed Use Discounts (1-3 years)
    |
    +-- No: Is it fault-tolerant?
              |
              +-- Yes: Preemptible/Spot VMs (up to 91% off)
              |
              +-- No: Pay-As-You-Go (with sustained use discounts)
```

### Pillar 6: Sustainability

**Practices**:
- Choose efficient regions
- Right-size resources
- Use managed services
- Auto-scaling

---

## Common Architecture Patterns

### 1. Three-Tier Web Application

```
                    +-----------------+
                    | Cloud DNS       |
                    | (DNS)           |
                    +--------+--------+
                             |
                    +--------+--------+
                    | Cloud CDN       |
                    | (CDN)           |
                    +--------+--------+
                             |
                    +--------+--------+
                    | Global HTTP(S)  |
                    | Load Balancer   |
                    +--------+--------+
                             |
            +----------------+----------------+
            |                |                |
    +-------+------+  +-----+--------+  +-----+--------+
    |   GKE/CE     |  |   GKE/CE     |  |   GKE/CE     |
    |  (Web Tier)  |  |  (Web Tier)  |  |  (Web Tier)  |
    +-------+------+  +-----+--------+  +-----+--------+
            |                |                |
            +----------------+----------------+
                             |
                    +--------+--------+
                    | VPC (Private)   |
                    +--------+--------+
                             |
            +----------------+----------------+
            |                                 |
    +-------+------+               +---------+--------+
    |   Cloud SQL  |               |   Memorystore    |
    |   (Database) |               |   (Cache)        |
    +-------+------+               +---------+--------+
```

**Components**:
- **Cloud DNS**: DNS routing
- **Cloud CDN**: Content caching, SSL termination
- **Global HTTP(S) Load Balancer**: Global load balancing
- **GKE/Compute Engine**: Web application servers
- **Cloud SQL**: Managed relational database
- **Memorystore**: Session storage, query caching

### 2. Serverless Web Application

```
                    +-----------------+
                    | Cloud DNS       |
                    +--------+--------+
                             |
                    +--------+--------+
                    | Cloud CDN       |
                    +--------+--------+
                             |
                    +--------+--------+
                    | Cloud Storage   |
                    | (Static Site)   |
                    +--------+--------+
                             |
                    +--------+--------+
                    | API Gateway     |
                    +--------+--------+
                             |
            +----------------+----------------+
            |                |                |
    +-------+------+  +-----+--------+  +-----+--------+
    |  Cloud       |  |  Cloud       |  |  Cloud       |
    |  Functions   |  |  Functions   |  |  Functions   |
    +-------+------+  +-----+--------+  +-----+--------+
            |                |                |
    +-------+------+  +-----+--------+  +-----+--------+
    |  Firestore   |  |  Cloud       |  |  Pub/Sub     |
    |              |  |  Storage     |  |              |
    +--------------+  +--------------+  +--------------+
```

**Components**:
- **Cloud Storage**: Static website hosting
- **Cloud CDN**: CDN and edge caching
- **API Gateway**: API management
- **Cloud Functions**: Serverless compute
- **Firestore**: Serverless NoSQL database
- **Pub/Sub**: Async message processing

### 3. Microservices Architecture

```
                    +-----------------+
                    | Global HTTP(S)  |
                    | Load Balancer   |
                    +--------+--------+
                             |
        +--------------------+--------------------+
        |                    |                    |
+-------+------+    +-------+------+    +-------+------+
| GKE Service A |    | GKE Service B |    | GKE Service C |
| (Users)      |    | (Orders)     |    | (Products)   |
+-------+------+    +-------+------+    +-------+------+
        |                    |                    |
+-------+------+    +-------+------+    +-------+------+
| Firestore    |    | Cloud SQL    |    | Memorystore  |
+--------------+    +--------------+    +--------------+

        +--------------------+--------------------+
        |                                         |
+-------+------+                        +---------+--------+
| Pub/Sub      |                        | Cloud Workflows  |
| (Messaging)  |                        | (Orchestration)  |
+--------------+                        +------------------+
```

**Best Practices**:
- GKE for container orchestration
- Service Mesh with Anthos
- Event-driven with Pub/Sub
- Distributed tracing with Cloud Trace

### 4. Data Lake Architecture

```
                    +-----------------+
                    |   Data Sources  |
                    +--------+--------+
                             |
        +--------------------+--------------------+
        |                    |                    |
+-------+------+    +-------+------+    +-------+------+
| Pub/Sub      |    | Cloud Storage |    | Cloud SQL    |
| (Streaming)  |    | (Batch)       |    | (Database)   |
+-------+------+    +-------+------+    +-------+------+
        |                    |                    |
        +--------------------+--------------------+
                             |
                    +--------+--------+
                    | Cloud Dataflow  |
                    | (ETL)           |
                    +--------+--------+
                             |
            +----------------+----------------+
            |                                 |
    +-------+------+               +---------+--------+
    | Cloud Storage|               | BigQuery         |
    | (Processed)  |               | (Analytics)      |
    +--------------+               +-----------------+
                             |
                    +--------+--------+
                    | Looker          |
                    | (Visualization) |
                    +-----------------+
```

### 5. Event-Driven Architecture

```
    +-----------------+
    |   Event Source  |
    +--------+--------+
             |
    +--------+--------+
    |   Pub/Sub       |
    +--------+--------+
             |
    +--------+--------+
    |   Topics &      |
    |   Subscriptions  |
    +--------+--------+
             |
    +--------+--------+--------+--------+
    |        |        |        |        |
+---+---+ +--+---+ +--+---+ +--+---+ +--+---+
|Cloud  | |Cloud | |Cloud | |GKE   | |CE   |
|Func   | |Run   | |Data- | |      | |     |
|       | |      | |flow  | |      | |     |
+-------+ +------+ +------+------+ +------+
```

---

## High Availability & Disaster Recovery

### Recovery Strategies

| Strategy | RTO | RPO | Cost | Complexity |
|----------|-----|-----|------|------------|
| Backup & Restore | Hours | Hours | Low | Low |
| Pilot Light | 10s min | Minutes | Medium | Medium |
| Warm Standby | Minutes | Seconds | High | High |
| Multi-Site Active/Active | Near Zero | Near Zero | Very High | High |

### Multi-Region Architecture

```
Region: us-central1                   Region: europe-west1
+-----------------+                  +-----------------+
| Cloud DNS       |                  |                 |
| (Failover)      |                  | (Standby)       |
+--------+--------+                  +--------+--------+
         |                                    |
+--------+--------+                  +--------+--------+
| Global HTTP(S)  |                  |                 |
| Load Balancer   |                  |                 |
+--------+--------+                  +--------+--------+
         |                                    |
+--------+--------+                  +--------+--------+
| GKE Cluster     |                  | GKE Cluster     |
+--------+--------+                  +--------+--------+
         |                                    |
+--------+--------+                  +--------+--------+
| Cloud SQL       |------------------| Cloud SQL       |
| (Primary)       |    (Replication) | (Read Replica)  |
+-----------------+                  +-----------------+
         |                                    |
+--------+--------+                  +--------+--------+
| Cloud Storage   |------------------| Cloud Storage   |
| (Dual Region)   |   Replication    | (Same Bucket)   |
+-----------------+                  +-----------------+
```

---

## Security Architecture

### Zero Trust Model

```
1. Verify Identity
   +-- Cloud IAM
   +-- BeyondCorp Enterprise
   +-- Identity-Aware Proxy
   +-- Context-Aware Access

2. Least Privilege
   +-- IAM Conditions
   +-- Custom Roles
   +-- Service Accounts
   +-- Workload Identity

3. Micro-segmentation
   +-- VPC Service Controls
   +-- Firewall Rules
   +-- Private Google Access
   +-- VPC-native Clusters

4. Encrypt Everything
   +-- Cloud KMS
   +-- CMEK (Customer-Managed Keys)
   +-- Default encryption
   +-- TLS 1.3

5. Continuous Monitoring
   +-- Cloud Audit Logs
   +-- Security Command Center
   +-- Chronicle
   +-- Binary Authorization
```

### Network Security Architecture

```
Internet
    |
+---+---+
| Cloud | (DDoS + WAF)
| Armor  |
+---+---+
    |
+---+---+
| Cloud | (Global LB)
| Load  |
| Balancer |
+---+---+
    |
+---+---+
| Cloud | (CDN)
| CDN   |
+---+---+
    |
+---+---+
| VPC   | (Firewall Rules)
|       |
+---+---+
    |
+---+---+
| Private| (Private Google Access)
| Access |
+---+---+
    |
+---+---+
| GKE/  | (Compute)
| CE    |
+---+---+
```

---

## Cost-Effective Architectures

### Pattern: Auto Scaling with Preemptible VMs

```
                    +-----------------+
                    | Global HTTP(S)  |
                    | Load Balancer   |
                    +--------+--------+
                             |
        +--------------------+--------------------+
        |                                         |
+-------+------+                         +--------+--------+
| Regular VMs  |                         | Preemptible     |
| (Base Load)  |                         | (Burst)         |
+-------+------+                         +--------+--------+
```

**Cost Savings**:
- Base load: Regular VMs with sustained use discounts
- Burst capacity: Preemptible VMs (up to 91% savings)
- Auto-scaling: Scale based on demand

### Pattern: Serverless Cost Optimization

```
Traditional:                      Serverless:
+------------------+              +------------------+
| Compute Engine   |              | Cloud Functions  |
| (24/7)           |              | (per request)    |
| $500/month       |              | $50/month        |
+------------------+              +------------------+
| Cloud SQL        |              | Firestore        |
| (24/7)           |              | (per document)   |
| $300/month       |              | $50              |
+------------------+              +------------------+
| Total: $800      |              | Total: $100      |
+------------------+              +------------------+
```

### Pattern: Cloud Storage Lifecycle

```
Day 0-30:    Standard ($0.020/GB)
Day 31-90:   Nearline ($0.010/GB)
Day 91-365:  Coldline ($0.004/GB)
Day 366+:    Archive ($0.0012/GB)
```

---

## Scalability Patterns

### Horizontal vs Vertical Scaling

```
Vertical Scaling:          Horizontal Scaling:
+----------+              +----------+ +----------+
|          |              |          | |          |
|   Bigger |              |  VM1     | |  VM2     |
|   VM     |              |          | |          |
|          |              +----------+ +----------+
+----------+              +----------+ +----------+
                          |          | |          |
                          |  VM3     | |  VM4     |
                          |          | |          |
                          +----------+ +----------+

Pros: Simple                 Pros: Near unlimited
Cons: Limited, downtime      Cons: Complex, stateless needed
```

### GKE Autopilot Scaling

```
Mode: Autopilot
- Automatic node provisioning
- Pod-level billing
- No node management

Scaling:
- Horizontal Pod Autoscaler (HPA)
- Vertical Pod Autoscaler (VPA)
- Cluster Autoscaler (Standard mode)
```

### Cloud Run Scaling

```
Configuration:
- Min instances: 0 (scale to zero)
- Max instances: 1000
- Concurrency: 80 requests/instance

Scaling Triggers:
- Request count
- CPU utilization
- Concurrent requests
```

---

## Reference Architecture: E-Commerce Platform

```
                        +-----------------+
                        | Cloud DNS       |
                        +--------+--------+
                                 |
                        +--------+--------+
                        | Cloud CDN       |
                        +--------+--------+
                                 |
                        +--------+--------+
                        | Global HTTP(S)  |
                        | Load Balancer   |
                        +--------+--------+
                                 |
              +------------------+------------------+
              |                  |                  |
     +--------+--------+ +------+------+ +---------+--------+
     | Cloud Storage   | | GKE: Web   | | API Gateway      |
     | (Static)        | | App        | +---------+--------+
     +-----------------+ +------+------+           |
              |                  |           +------+--------+
     +--------+--------+ +------+------+   | Cloud Run:     |
     | Memorystore     | | GKE: Product|   | Auth Service   |
     | (Sessions)      | | Service     |   +---------------+
     +-----------------+ +------+------+
              |                  |
     +--------+--------+ +------+--------+
     | Cloud SQL       | | Firestore    |
     | (Orders, Users) | | (Products)   |
     | (HA, Regional)  | | (Native)     |
     +-----------------+ +--------------+
```

**Components**:
- **Cloud DNS**: DNS routing with health checks
- **Cloud CDN**: Global content caching, SSL termination
- **Global HTTP(S) Load Balancer**: Global load balancing
- **GKE**: Containerized microservices
- **Firestore**: Product catalog (multi-region, native)
- **Cloud SQL**: Transactional data (HA configuration)
- **Memorystore**: Session management, product caching
- **API Gateway**: API management, rate limiting
- **Cloud Run**: Serverless microservices
