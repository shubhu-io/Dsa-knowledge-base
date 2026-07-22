# Cloud Provider Comparison

## Overview

The three major cloud providers - AWS, Azure, and GCP - offer similar services with different strengths. This guide compares them across key dimensions.

## Service Mapping

### Compute

| Category | AWS | Azure | GCP |
|----------|-----|-------|-----|
| Virtual Machines | EC2 | Virtual Machines | Compute Engine |
| Containers | ECS, EKS | AKS | GKE |
| Serverless | Lambda | Functions | Cloud Functions |
| PaaS | Elastic Beanstalk | App Service | App Engine |
| Edge Computing | Wavelength | Azure Edge Zones | Distributed Cloud |

### Storage

| Category | AWS | Azure | GCP |
|----------|-----|-------|-----|
| Object Storage | S3 | Blob Storage | Cloud Storage |
| Block Storage | EBS | Managed Disks | Persistent Disk |
| File Storage | EFS | Azure Files | Filestore |
| Archive | Glacier | Archive Storage | Archive Storage |

### Database

| Category | AWS | Azure | GCP |
|----------|-----|-------|-----|
| Relational | RDS, Aurora | Azure SQL, MSSQL | Cloud SQL, AlloyDB |
| NoSQL | DynamoDB | Cosmos DB | Firestore, Bigtable |
| In-Memory | ElastiCache | Azure Cache | Memorystore |
| Data Warehouse | Redshift | Synapse | BigQuery |

### Networking

| Category | AWS | Azure | GCP |
|----------|-----|-------|-----|
| Virtual Network | VPC | VNet | VPC |
| Load Balancer | ALB, NLB | Load Balancer | Cloud LB |
| DNS | Route 53 | Azure DNS | Cloud DNS |
| CDN | CloudFront | Azure CDN | Cloud CDN |
| CDN | CloudFront | Azure CDN | Cloud CDN |

### AI/ML

| Category | AWS | Azure | GCP |
|----------|-----|-------|-----|
| ML Platform | SageMaker | Azure ML | Vertex AI |
| LLM Service | Bedrock | Azure OpenAI | Vertex AI PAI |
| Speech | Polly, Transcribe | Cognitive Services | Speech-to-Text |
| Vision | Rekognition | Computer Vision | Vision AI |

## Pricing Comparison

### Compute Pricing (Approximate Monthly)

| Instance | AWS | Azure | GCP |
|----------|-----|-------|-----|
| 2 vCPU, 8GB | t3.large (~$60) | B2s (~$55) | e2-standard-2 (~$49) |
| 4 vCPU, 16GB | m5.xlarge (~$140) | D4s v3 (~$130) | e2-standard-4 (~$125) |
| 8 vCPU, 32GB | m5.2xlarge (~$280) | D8s v3 (~$260) | e2-standard-8 (~$250) |

### Pricing Models

```
┌──────────────────────────────────────────────────┐
│               Pricing Spectrum                     │
│                                                   │
│  On-Demand    1yr Reserved   3yr Reserved  Spot   │
│  (100%)       (60-70%)       (40-50%)     (70-90%)│
│                                                   │
│  ◄── Flexible                    Cost Savings ──► │
└──────────────────────────────────────────────────┘

AWS:     On-Demand, Reserved, Savings Plans, Spot
Azure:   Pay-as-you-go, Reserved, Spot
GCP:     On-Demand, Committed Use, Preemptible/Spot
```

### Free Tiers

| Provider | Free Compute | Free Storage | Duration |
|----------|-------------|--------------|----------|
| AWS | 750 hrs t2.micro | 5GB S3 | 12 months |
| Azure | 750 hrs B1s | 5GB Blob | 12 months |
| GCP | 2400 vCPU-hrs e2-micro | 5GB Cloud Storage | Always free + $300 credit |

## Strengths and Weaknesses

### AWS

**Strengths:**
- Largest service catalog (200+ services)
- Most mature and battle-tested
- Widest global infrastructure
- Largest community and ecosystem
- Most compliance certifications

**Weaknesses:**
- Complex pricing model
- Console can be overwhelming
- Steep learning curve
- Support costs extra

### Microsoft Azure

**Strengths:**
- Best hybrid cloud (Azure Arc)
- Deep Microsoft ecosystem integration
- Strong enterprise support
- Good for .NET/Windows workloads
- Leading in AI (OpenAI partnership)

**Weaknesses:**
- Some services less mature than AWS
- Documentation inconsistency
- Occasional platform outages
- Complex networking

### Google Cloud Platform

**Strengths:**
- Best data analytics (BigQuery)
- Strong Kubernetes (GKE)
- Best ML/AI tools (TensorFlow, Vertex AI)
- Simplest pricing model
- Strong networking backbone

**Weaknesses:**
- Smaller service catalog
- Fewer regions than AWS
- Less enterprise adoption
- Smaller partner ecosystem

## Feature Comparison

| Feature | AWS | Azure | GCP |
|---------|-----|-------|-----|
| Regions | 33+ | 60+ | 40+ |
| Availability Zones | Yes | Yes | Yes |
| Serverless DB | Aurora Serverless | Cosmos DB serverless | AlloyDB |
| Service Mesh | App Mesh | Azure Service Mesh | Anthos Service Mesh |
| IaC | CloudFormation, CDK | ARM, Bicep, Pulumi | Deployment Manager |
| Container Registry | ECR | ACR | Artifact Registry |
| Secrets Manager | Secrets Manager | Key Vault | Secret Manager |
| Monitoring | CloudWatch | Azure Monitor | Cloud Monitoring |

## Decision Framework

```
Choose AWS if:
├── You need the widest range of services
├── Maximum global reach required
├── Large team with AWS expertise
└── Complex multi-service architectures

Choose Azure if:
├── Microsoft ecosystem (.NET, Windows, Active Directory)
├── Hybrid cloud is important
├── Enterprise agreement with Microsoft
└── AI/OpenAI integration needed

Choose GCP if:
├── Data analytics is primary (BigQuery)
├── Kubernetes-first strategy (GKE)
├── ML/AI workloads (Vertex AI, TPUs)
└── Cost optimization is critical
```

## Multi-Cloud Strategy

```
┌─────────────────────────────────────────────────┐
│              Multi-Cloud Architecture             │
│                                                  │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐     │
│  │   AWS    │  │  Azure   │  │   GCP    │     │
│  │ Primary  │  │ Microsoft│  │ Analytics│     │
│  │ workloads│  │ workloads│  │ & ML     │     │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘     │
│       │              │              │            │
│  ┌────▼──────────────▼──────────────▼────┐     │
│  │         Terraform / Pulumi            │     │
│  │         (Unified IaC)                 │     │
│  └───────────────────────────────────────┘     │
│                                                  │
│  ┌───────────────────────────────────────┐     │
│  │    Kubernetes (portable workloads)     │     │
│  └───────────────────────────────────────┘     │
└─────────────────────────────────────────────────┘
```

**Benefits**: Avoid vendor lock-in, best-of-breed services, geographic coverage.
**Challenges**: Complexity, skill breadth, cost management, networking between clouds.

## Migration Strategies (6 R's)

| Strategy | Description | Example |
|----------|-------------|---------|
| Rehost | Lift-and-shift to VMs | Migrate EC2 to EC2 |
| Replatform | Minor optimizations | Move to managed database |
| Refactor | Re-architect for cloud | Convert to serverless |
| Repurchase | Switch to SaaS | Replace custom CRM with Salesforce |
| Retire | Decommission unused | Shut down legacy system |
| Retain | Keep on-premises | Mainframe systems |

## Best Practices

1. **Start with one provider** before going multi-cloud
2. **Use cost management tools** (AWS Cost Explorer, Azure Cost Management, GCP Billing)
3. **Tag all resources** for cost allocation
4. **Use reserved/committed instances** for predictable workloads
5. **Implement proper IAM** with least privilege
6. **Enable monitoring and alerting** from day one
7. **Design for failure** across availability zones
8. **Use managed services** to reduce operational overhead
