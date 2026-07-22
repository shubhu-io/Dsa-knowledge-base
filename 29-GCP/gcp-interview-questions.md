# GCP Interview Questions - Comprehensive Guide

## Table of Contents

1. [Fundamental Questions](#fundamental-questions)
2. [Compute Questions](#compute-questions)
3. [Storage Questions](#storage-squestions)
4. [Database Questions](#database-questions)
5. [Networking Questions](#networking-questions)
6. [Security Questions](#security-questions)
7. [Architecture Questions](#architecture-questions)
8. [Cost Optimization Questions](#cost-optimization-questions)
9. [Scenario-Based Questions](#scenario-based-questions)
10. [Hands-On Lab Questions](#hands-on-lab-questions)

---

## Fundamental Questions

### Q1: What is Google Cloud Platform and its key features?

**Answer**:
GCP is Google's cloud computing platform offering 100+ services:
- **Compute**: Compute Engine, GKE, Cloud Run, Functions
- **Storage**: Cloud Storage, Persistent Disk, Filestore
- **Database**: Cloud SQL, Spanner, Firestore, BigQuery
- **Networking**: VPC, Load Balancing, Cloud CDN
- **AI/ML**: Vertex AI, BigQuery ML
- **Data**: BigQuery, Dataflow, Dataproc

### Q2: What is the difference between GCP, AWS, and Azure?

**Answer**:
| Feature | GCP | AWS | Azure |
|---------|-----|-----|-------|
| Launch Year | 2008 | 2006 | 2010 |
| Market Share | 10% | 32% | 23% |
| Strengths | Data/ML, K8s | Broadest services | Enterprise |
| Kubernetes | GKE (created K8s) | EKS | AKS |
| Data Warehouse | BigQuery | Redshift | Synapse |

### Q3: What is a GCP Project?

**Answer**:
- Logical container for resources
- Billing is per project
- IAM is per project
- APIs are enabled per project
- Can be organized under Folders and Organization

### Q4: What are GCP Regions and Zones?

**Answer**:
- **Region**: Geographic area with 3+ zones
- **Zone**: Physically separate data center
- **Example**: us-central1 has zones a, b, c, f
- Choose based on: latency, compliance, services

### Q5: What is the gcloud CLI?

**Answer**:
```bash
# Install
brew install google-cloud-sdk

# Initialize
gcloud init

# Common commands
gcloud compute instances list
gcloud container clusters create my-cluster
gcloud functions deploy my-function
```

---

## Compute Questions

### Q6: When would you use Compute Engine vs GKE vs Cloud Run?

**Answer**:
| Service | Use Case | Control |
|---------|----------|---------|
| Compute Engine | Custom workloads, legacy | Full |
| GKE | Container orchestration | High |
| Cloud Run | HTTP workloads, microservices | Low |

**Decision Tree**:
```
Do you need containers?
    +-- No: Compute Engine
    +-- Yes: Do you need orchestration?
              +-- No: Cloud Run
              +-- Yes: GKE
```

### Q7: What is GKE Autopilot vs Standard?

**Answer**:
| Feature | Autopilot | Standard |
|---------|-----------|----------|
| Node Management | Google-managed | User-managed |
| Billing | Per pod | Per node |
| Config | Pod-level | Node-level |
| Use Case | Serverless containers | Full control |

### Q8: What is the difference between Cloud Functions Gen 1 and Gen 2?

**Answer**:
| Feature | Gen 1 | Gen 2 |
|---------|-------|-------|
| Trigger | Basic | Cloud Events |
| Runtime | Limited | Any |
| Scaling | Faster | More configurable |
| Features | Basic | Full Cloud Run features |

### Q9: What is App Engine and when to use it?

**Answer**:
- **Platform as a Service** for web applications
- **Standard**: Sandboxed, fast startup, free tier
- **Flexible**: Docker-based, more control
- **Use Case**: Web apps, APIs, mobile backends

### Q10: What are Sustained Use Discounts?

**Answer**:
- Automatic discounts for long-running VMs
- Up to 30% discount
- Based on percentage of month running
- No commitment required
- Applies to Compute Engine only

---

## Storage Questions

### Q11: What are the Cloud Storage classes?

**Answer**:
| Class | Use Case | Minimum | Cost |
|-------|----------|---------|------|
| Standard | Frequent access | 0 days | Highest |
| Nearline | 30+ days | 30 days | Medium |
| Coldline | 90+ days | 90 days | Low |
| Archive | 365+ days | 365 days | Lowest |

### Q12: What is the difference between Cloud Storage and Persistent Disk?

**Answer**:
| Feature | Cloud Storage | Persistent Disk |
|---------|---------------|-----------------|
| Type | Object | Block |
| Access | HTTP/API | Mounted to VM |
| Use Case | Files, backups | VM boot/data |
| Scalability | Unlimited | 64 TB |
| Performance | High throughput | High IOPS |

### Q13: What is Cloud Storage FUSE?

**Answer**:
- Mount Cloud Storage as file system
- Linux-based applications
- Use Cases:
  - ML training data
  - Container storage
  - Legacy app migration

### Q14: What is Filestore and when to use it?

**Answer**:
- Managed NFS file server
- **Tiers**: Basic HDD, Basic SSD, Enterprise
- **Use Cases**:
  - Shared file systems
  - GKE persistent volumes
  - Content management

### Q15: How do you secure a Cloud Storage bucket?

**Answer**:
```bash
# Make private
gsutil iam ch -d allUsers gs://my-bucket

# Enable versioning
gsutil versioning set on gs://my-bucket

# Enable uniform bucket-level access
gsutil uniformbucketlevelaccess set on gs://my-bucket

# Set lifecycle rule
gsutil lifecycle set lifecycle.json gs://my-bucket
```

---

## Database Questions

### Q16: When to use Cloud SQL vs Cloud Spanner vs Firestore?

**Answer**:
| Feature | Cloud SQL | Spanner | Firestore |
|---------|-----------|---------|-----------|
| Type | Relational | Relational | NoSQL |
| Scale | Regional | Global | Global |
| Consistency | Strong | Strong | Eventual |
| Use Case | Standard SQL | Global apps | Mobile/web |
| Cost | Low | High | Medium |

### Q17: What is Cloud Spanner and its unique features?

**Answer**:
- Globally distributed relational database
- **99.999% SLA** (five nines)
- Strong consistency at global scale
- Horizontal scaling
- SQL interface
- **Use Cases**: Financial systems, global applications

### Q18: What is Firestore and its data model?

**Answer**:
- NoSQL document database
- **Data Model**: Collections → Documents → Fields
- **Features**:
  - Real-time synchronization
  - Offline support
  - ACID transactions
  - Native mobile/web SDKs

### Q19: What is Bigtable and when to use it?

**Answer**:
- Petabyte-scale NoSQL
- **Use Cases**:
  - IoT time-series data
  - AdTech clickstream
  - Monitoring/metrics
  - Graph data
- **Features**: Low latency, high throughput, HBase-compatible

### Q20: What is Memorystore and its use cases?

**Answer**:
- Managed Redis/Memcached
- **Use Cases**:
  - Session storage
  - Database caching
  - Real-time analytics
  - Gaming leaderboards
- **Performance**: Sub-millisecond latency

---

## Networking Questions

### Q21: What is a GCP VPC and its features?

**Answer**:
- Global virtual network
- **Features**:
  - Global VPC (subnets in any region)
  - Shared VPC (share across projects)
  - Custom mode (define IP ranges)
  - Firewall rules (stateful)
  - Cloud NAT (outbound internet)
  - Private Google Access

### Q22: What is the difference between Cloud Load Balancers?

**Answer**:
| Type | Layer | Scope | Use Case |
|------|-------|-------|----------|
| Global HTTP(S) | L7 | Global | Web apps |
| SSL Proxy | L7 | Global | SSL traffic |
| TCP Proxy | L4 | Global | TCP traffic |
| Internal TCP/UDP | L4 | Regional | Internal services |
| Internal HTTP(S) | L7 | Regional | Internal web apps |

### Q23: What is Cloud CDN and how does it work?

**Answer**:
- Global edge caching
- **Features**:
  - 200+ edge locations
  - Integration with Load Balancing
  - Custom cache keys
  - Signed URLs/cookies
- **Use Case**: Static content, API caching

### Q24: What is Cloud Armor?

**Answer**:
- DDoS protection + WAF
- **Features**:
  - Pre-configured rules
  - Custom WAF rules
  - Adaptive protection
  - Bot management
- **Integration**: Global HTTP(S) Load Balancer

### Q25: What is Cloud Interconnect vs Cloud VPN?

**Answer**:
| Feature | Cloud Interconnect | Cloud VPN |
|---------|-------------------|-----------|
| Type | Dedicated/Partner | Encrypted tunnel |
| Speed | 50-100 Gbps | Up to 3 Gbps |
| SLA | 99.9-99.99% | 99.9% |
| Cost | Higher | Lower |
| Use Case | High bandwidth | Backup/DR |

---

## Security Questions

### Q26: What is Cloud IAM and its components?

**Answer**:
- Identity and Access Management
- **Components**:
  - Members: Users, groups, service accounts
  - Roles: Permissions collections
  - Policies: Bind roles to members
- **Role Types**: Basic, Predefined, Custom

```bash
# Grant role
gcloud projects add-iam-policy-binding my-project \
    --member="user:admin@example.com" \
    --role="roles/compute.admin"
```

### Q27: What are VPC Service Controls?

**Answer**:
- Security perimeters for GCP services
- **Use Cases**:
  - Prevent data exfiltration
  - Protect sensitive data
  - Compliance requirements
- **Features**: Perimeters, dry-run mode, audit logging

### Q28: What is Secret Manager?

**Answer**:
- Store secrets (API keys, passwords, certificates)
- **Features**:
  - Versioning
  - Rotation
  - Audit logging
  - Integration with GCP services

### Q29: What is BeyondCorp Enterprise?

**Answer**:
- Zero Trust security model
- **Features**:
  - Context-aware access
  - Identity-Aware Proxy
  - Device policies
  - Chrome enterprise

### Q30: What is Security Command Center?

**Answer**:
- Security posture management
- **Tiers**: Premium, Enterprise
- **Features**:
  - Threat detection
  - Vulnerability scanning
  - Security Health Analytics
  - Web Security Scanner

---

## Architecture Questions

### Q31: Design a highly available web application

**Answer**:
```
Architecture:
- Multi-zone deployment
- GKE or Compute Engine
- Global HTTP(S) Load Balancer
- Cloud SQL with HA
- Memorystore for caching
- Cloud CDN for static content

Components:
1. Cloud DNS (DNS, health checks)
2. Cloud CDN (CDN, SSL)
3. Global HTTP(S) LB (Load balancing)
4. GKE/CE (Web tier)
5. Cloud SQL (Database)
6. Memorystore (Caching)
```

### Q32: How would you migrate an on-premises database to GCP?

**Answer**:
```
Options:
1. Database Migration Service
   - Homogeneous: MySQL to Cloud SQL MySQL
   - Heterogeneous: Oracle to Cloud SQL PostgreSQL

2. Storage Transfer Service
   - Large datasets to Cloud Storage

3. Native Export/Import
   - mysqldump, pg_dump

Steps:
1. Assess source database
2. Create target (Cloud SQL/Spanner)
3. Configure DMS
4. Test and validate
5. Cutover
```

### Q33: Design a serverless API

**Answer**:
```
Architecture:
Client -> Cloud CDN -> Cloud Functions -> Firestore

Benefits:
- No servers to manage
- Auto-scaling
- Pay per request
- High availability

Components:
- Cloud CDN: CDN, SSL
- API Gateway: API management
- Cloud Functions: Compute
- Firestore: NoSQL database
- Identity Platform: Authentication
```

### Q34: How do you handle disaster recovery in GCP?

**Answer**:
```
Strategies (by RTO/RPO):

1. Backup & Restore (Hours)
   - Cloud Storage, Cloud SQL backups
   - RTO: Hours, RPO: Hours

2. Pilot Light (Minutes)
   - Core services running
   - Scale up on failover
   - RTO: 10s min, RPO: Minutes

3. Warm Standby (Minutes)
   - Full stack running smaller
   - Scale up on failover
   - RTO: Minutes, RPO: Seconds

4. Multi-Site Active/Active (Near Zero)
   - Full stack in multiple regions
   - Cloud DNS failover
   - RTO: Near zero, RPO: Near zero
```

### Q35: What is Anthos and when to use it?

**Answer**:
- Hybrid/multi-cloud platform
- **Components**:
  - GKE on-prem
  - GKE on other clouds
  - Service Mesh
  - Application Platform
- **Use Cases**: Hybrid cloud, multi-cloud, migration

---

## Cost Optimization Questions

### Q36: How do you reduce GCP costs?

**Answer**:
```
Strategies:
1. Committed Use Discounts (up to 57%)
2. Preemptible/Spot VMs (up to 91%)
3. Sustained Use Discounts (up to 30%)
4. Right-sizing (Recommender)
5. Storage lifecycle (Nearline/Coldline)
6. Preemptible for batch processing
7. Monitor with Billing Reports
```

### Q37: What are Committed Use Discounts?

**Answer**:
- Commit to 1 or 3 year term
- Save up to 57% vs Pay-As-You-Go
- Apply to: Compute Engine, Cloud SQL, Spanner
- Flexible: Can change machine types
- Regional: Must use in same region

### Q38: What are Preemptible/Spot VMs?

**Answer**:
- Up to 91% discount
- Can be preempted (stopped)
- Max 24 hours runtime
- **Use Cases**:
  - Batch processing
  - Fault-tolerant workloads
  - Development/testing
- **No SLA**

### Q39: How do you set up billing alerts?

**Answer**:
```bash
# Create budget
gcloud billing budgets create \
    --billing-account=ACCOUNT_ID \
    --display-name="Monthly Budget" \
    --budget-amount=1000 \
    --threshold-rule=percent=80 \
    --all-updates-rule-pubsub-topic=projects/my-project/topics/billing-alerts
```

### Q40: What is the GCP Pricing Calculator?

**Answer**:
- Estimate costs before deploying
- Configure: VMs, storage, networking
- Export estimates to CSV
- Share with team
- Link: cloud.google.com/products/calculator

---

## Scenario-Based Questions

### Q41: Your application is experiencing high latency. How do you diagnose?

**Answer**:
```
Diagnosis:
1. Cloud Monitoring metrics (VM, network)
2. Cloud Trace (distributed tracing)
3. Cloud SQL metrics (connections, queries)
4. Network Intelligence Center

Fixes:
1. Enable Cloud CDN caching
2. Add Memorystore
3. Right-size VMs
4. Optimize SQL queries
5. Enable compression
6. Use Cloud Armor
```

### Q42: You need to process 1TB of data daily. Which services?

**Answer**:
```
Options:
1. Dataflow (Apache Beam) - Stream/batch processing
2. Dataproc (Spark) - Big data processing
3. BigQuery (SQL) - Analytics queries
4. Cloud Functions (Small chunks) - Event-driven
5. Pub/Sub + Dataflow (Real-time streaming)

Architecture:
Cloud Storage (Data Lake) -> Dataflow (ETL) -> BigQuery (Analytics) -> Looker (BI)
```

### Q43: How do you handle sudden traffic spikes?

**Answer**:
```
Immediate:
1. GKE horizontal pod autoscaling
2. Cloud Run auto-scaling
3. Cloud CDN for static content
4. Memorystore for database load

Long-term:
1. Implement CDN caching
2. Database read replicas
3. Queue-based architecture (Pub/Sub)
4. Static content on Cloud Storage
```

### Q44: Your application needs to be HIPAA compliant. How?

**Answer**:
```
Requirements:
1. Network segmentation (VPC)
2. Encryption at rest (Cloud KMS)
3. Encryption in transit (TLS 1.3)
4. Access controls (Cloud IAM)
5. Audit logging (Cloud Audit Logs)
6. BAA with Google Cloud

Services:
- VPC, Firewall Rules
- Cloud KMS, CMEK
- Cloud IAM, VPC Service Controls
- Cloud Audit Logs, Security Command Center
```

### Q45: How do you monitor a distributed microservices application?

**Answer**:
```
Monitoring Stack:
1. Cloud Monitoring: Metrics, Dashboards, Alerts
2. Cloud Trace: Distributed tracing
3. Cloud Logging: Centralized logging
4. Security Command Center: Security monitoring

Best Practices:
- Centralized logging (Cloud Logging)
- Service maps (Cloud Trace)
- Custom dashboards
- Alerting policies
```

---

## Hands-On Lab Questions

### Q46: Deploy a static website to Cloud Storage

**Answer**:
```bash
# Create bucket
gsutil mb -l us-central1 gs://my-website

# Upload files
gsutil -m cp -r ./website/* gs://my-website/

# Make public
gsutil iam ch allUsers:objectViewer gs://my-website

# Set website config
gsutil web set -m index.html -e 404.html gs://my-website
```

### Q47: Set up a CI/CD pipeline with Cloud Build

**Answer**:
```yaml
# cloudbuild.yaml
steps:
  - name: 'gcr.io/cloud-builders/docker'
    args: ['build', '-t', 'gcr.io/$PROJECT_ID/my-app:$COMMIT_SHA', '.']
  - name: 'gcr.io/cloud-builders/docker'
    args: ['push', 'gcr.io/$PROJECT_ID/my-app:$COMMIT_SHA']
  - name: 'gcr.io/google-containers/kubectl'
    args: ['set', 'image', 'deployment/my-app', 
           'my-app=gcr.io/$PROJECT_ID/my-app:$COMMIT_SHA']
images:
  - 'gcr.io/$PROJECT_ID/my-app:$COMMIT_SHA'
```

### Q48: Create a Cloud Function triggered by Cloud Storage

**Answer**:
```python
# main.py
def hello_gcs(event, context):
    """Triggered by a change to a Cloud Storage bucket."""
    file = event
    print(f"File: {file['name']}")
    print(f"Event ID: {context.event_id}")
    print(f"Event type: {context.event_type}")
    
    # Process the file
    return "OK"
```

### Q49: Set up VPC and firewall rules

**Answer**:
```bash
# Create VPC
gcloud compute networks create my-vpc \
    --subnet-mode=custom

# Create subnet
gcloud compute networks subnets create my-subnet \
    --network=my-vpc \
    --region=us-central1 \
    --range=10.0.1.0/24

# Create firewall rule
gcloud compute firewall-rules create allow-ssh \
    --network=my-vpc \
    --allow=tcp:22 \
    --source-ranges=0.0.0.0/0 \
    --target-tags=ssh-allowed
```

### Q50: Implement Cloud Monitoring alerts

**Answer**:
```bash
# Create alerting policy
gcloud alpha monitoring policies create \
    --notification-channels="projects/my-project/notificationChannels/1234567890" \
    --display-name="High CPU" \
    --condition-display-name="CPU > 80%" \
    --condition-filter='resource.type = "gce_instance" AND metric.type = "compute.googleapis.com/instance/cpu/utilization"' \
    --condition-threshold-value=0.8 \
    --condition-threshold-duration=300s
```

---

## Additional Resources

### Practice Labs
- Qwiklabs (cloudskillsboost.google)
- GCP Free Tier ($300 credit)
- Google Cloud Training
- A Cloud Guru GCP Labs

### Certification Paths
1. Cloud Digital Leader (Foundational)
2. Associate Cloud Engineer
3. Professional Cloud Architect
4. Professional Data Engineer
5. Professional ML Engineer
6. Professional DevOps Engineer

### Key Services to Know
- **Compute**: Compute Engine, GKE, Cloud Run, Functions
- **Storage**: Cloud Storage, Persistent Disk, Filestore
- **Database**: Cloud SQL, Spanner, Firestore, BigQuery
- **Networking**: VPC, Load Balancing, Cloud CDN
- **Security**: Cloud IAM, VPC Service Controls, Cloud Armor
- **Monitoring**: Cloud Monitoring, Cloud Logging, Cloud Trace
