# Azure Architecture - Well-Architected Framework & Patterns

## Table of Contents

1. [Azure Well-Architected Framework](#azure-well-architected-framework)
2. [Common Architecture Patterns](#common-architecture-patterns)
3. [Reference Architectures](#reference-architectures)
4. [High Availability & Disaster Recovery](#high-availability--disaster-recovery)
5. [Security Architecture](#security-architecture)
6. [Cost-Effective Architectures](#cost-effective-architectures)
7. [Scalability Patterns](#scalability-patterns)

---

## Azure Well-Architected Framework

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
- Infrastructure as Code (ARM/Bicep/Terraform)
- CI/CD pipelines (Azure DevOps, GitHub Actions)
- Monitoring and observability (Azure Monitor)
- Runbooks and automation

**Key Services**:
- Azure Resource Manager
- Azure DevOps
- Azure Monitor
- Azure Automation

**Example Architecture**:
```
Developer -> Azure Repos -> Azure Pipelines -> Staging -> Production
                                |
                          Azure Monitor Alerts
                                |
                          Action Groups
```

### Pillar 2: Security

**Practices**:
- Zero Trust architecture
- Azure AD with MFA and Conditional Access
- Key Vault for secrets management
- Network segmentation with NSGs

**Key Services**:
- Azure AD, Azure AD B2C
- Azure Key Vault
- Azure Security Center
- Azure Sentinel

**Defense in Depth**:
```
Layer 1: Perimeter (DDoS Protection, WAF)
Layer 2: Network (NSGs, Azure Firewall)
Layer 3: Identity (Azure AD, MFA, Conditional Access)
Layer 4: Compute (VM security, containers)
Layer 5: Data (TDE, encryption at rest)
Layer 6: Monitoring (Azure Monitor, Sentinel)
```

### Pillar 3: Reliability

**Practices**:
- Availability Zones
- Multi-region deployment
- Auto-scaling
- Backup and disaster recovery

**Key Services**:
- Availability Zones
- Azure Traffic Manager
- Azure Site Recovery
- Azure Backup

**Architecture Pattern**:
```
Multi-AZ Architecture:

Region: East US
    |
    +-- Availability Zone 1
    |       +-- VM (Web Server)
    |       +-- Azure SQL (Primary)
    |
    +-- Availability Zone 2
    |       +-- VM (Web Server)
    |       +-- Azure SQL (Standby)
    |
    +-- Availability Zone 3
    |       +-- VM (Web Server)
    |       +-- Storage (Data)
    |
    +-- Traffic Manager (DNS Failover)
    +-- Front Door (CDN)
```

### Pillar 4: Performance Efficiency

**Practices**:
- Right-size VMs
- Use Premium SSD/Ultra Disk
- Caching with Azure Cache for Redis
- CDN with Azure Front Door

**Key Services**:
- Azure Cache for Redis
- Azure Front Door
- Azure CDN
- Premium Storage

### Pillar 5: Cost Optimization

**Practices**:
- Reserved Instances
- Azure Hybrid Benefit
- Auto-shutdown dev/test
- Monitor with Cost Management

**Key Services**:
- Azure Cost Management
- Azure Advisor
- Pricing Calculator
- TCO Calculator

**Cost Decision Tree**:
```
Is the workload predictable?
    |
    +-- Yes: Reserved Instances (1-3 years)
    |
    +-- No: Is it fault-tolerant?
              |
              +-- Yes: Spot VMs (up to 90% off)
              |
              +-- No: Pay-As-You-Go
```

### Pillar 6: Sustainability

**Practices**:
- Choose efficient regions
- Right-size resources
- Use serverless
- Managed services

---

## Common Architecture Patterns

### 1. Three-Tier Web Application

```
                    +-----------------+
                    | Azure DNS       |
                    | (DNS)           |
                    +--------+--------+
                             |
                    +--------+--------+
                    | Front Door      |
                    | (CDN + WAF)     |
                    +--------+--------+
                             |
                    +--------+--------+
                    | Application     |
                    | Gateway (L7 LB) |
                    +--------+--------+
                             |
            +----------------+----------------+
            |                |                |
    +-------+------+  +-----+--------+  +-----+--------+
    |   VM         |  |   VM         |  |   VM         |
    |  (Web Tier)  |  |  (Web Tier)  |  |  (Web Tier)  |
    +-------+------+  +-----+--------+  +-----+--------+
            |                |                |
            +----------------+----------------+
                             |
                    +--------+--------+
                    | VNet (Private)  |
                    +--------+--------+
                             |
            +----------------+----------------+
            |                                 |
    +-------+------+               +---------+--------+
    |   Azure SQL  |               |   Redis Cache    |
    |   (Database) |               |   (Cache)        |
    +-------+------+               +---------+--------+
```

**Components**:
- **Azure DNS**: DNS routing
- **Front Door**: Global CDN, WAF, SSL termination
- **Application Gateway**: Regional load balancing, WAF
- **VMs/App Service**: Web application servers
- **Azure SQL**: Managed relational database
- **Redis Cache**: Session storage, query caching

### 2. Serverless Web Application

```
                    +-----------------+
                    | Azure DNS       |
                    +--------+--------+
                             |
                    +--------+--------+
                    | Front Door      |
                    +--------+--------+
                             |
                    +--------+--------+
                    | Static Web Apps |
                    +--------+--------+
                             |
                    +--------+--------+
                    | API Management  |
                    +--------+--------+
                             |
            +----------------+----------------+
            |                |                |
    +-------+------+  +-----+--------+  +-----+--------+
    |   Functions  |  |   Functions  |  |   Functions  |
    |  (HTTP)      |  |  (Queue)     |  |  (Timer)     |
    +-------+------+  +-----+--------+  +-----+--------+
            |                |                |
    +-------+------+  +-----+--------+  +-----+--------+
    |   Cosmos DB  |  |   Storage    |  |   Event Hub  |
    +--------------+  +--------------+  +--------------+
```

**Components**:
- **Static Web Apps**: Static website hosting
- **API Management**: API gateway and management
- **Functions**: Serverless compute
- **Cosmos DB**: Serverless NoSQL database
- **Storage**: Blob storage for files
- **Event Hub**: Event streaming

### 3. Microservices Architecture

```
                    +-----------------+
                    | App Gateway     |
                    +--------+--------+
                             |
        +--------------------+--------------------+
        |                    |                    |
+-------+------+    +-------+------+    +-------+------+
| AKS Service A|    | AKS Service B|    | AKS Service C|
| (Users)      |    | (Orders)     |    | (Products)   |
+-------+------+    +-------+------+    +-------+------+
        |                    |                    |
+-------+------+    +-------+------+    +-------+------+
| Cosmos DB    |    | Azure SQL    |    | Redis Cache  |
+--------------+    +--------------+    +--------------+

        +--------------------+--------------------+
        |                                         |
+-------+------+                        +---------+--------+
| Service Bus  |                        | Logic Apps       |
| (Messaging)  |                        | (Orchestration)  |
+--------------+                        +------------------+
```

**Best Practices**:
- API Management for routing
- Service Bus for async messaging
- AKS for container orchestration
- Application Insights for distributed tracing

### 4. Data Lake Architecture

```
                    +-----------------+
                    |   Data Sources  |
                    +--------+--------+
                             |
        +--------------------+--------------------+
        |                    |                    |
+-------+------+    +-------+------+    +-------+------+
| Event Hubs   |    | Data Factory  |    | DMS          |
| (Streaming)  |    | (ETL)         |    | (Database)   |
+-------+------+    +-------+------+    +-------+------+
        |                    |                    |
        +--------------------+--------------------+
                             |
                    +--------+--------+
                    |   Data Lake     |
                    |   Storage Gen2  |
                    +--------+--------+
                             |
                    +--------+--------+
                    |   Databricks    |
                    |   (Processing)  |
                    +--------+--------+
                             |
            +----------------+----------------+
            |                                 |
    +-------+------+               +---------+--------+
    | Synapse      |               | Power BI         |
    | Analytics    |               | (Visualization)  |
    +--------------+               +-----------------+
```

### 5. Event-Driven Architecture

```
    +-----------------+
    |   Event Source  |
    +--------+--------+
             |
    +--------+--------+
    |   Event Grid    |
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
|Func   | |Logic | |Web   | |Queue | |Event |
|       | |App   | |Hook  | |      | |Hub   |
+-------+ +------+ +------+ +------+ +------+
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
Region: East US                      Region: West Europe
+-----------------+                  +-----------------+
| Traffic Manager |                  |                 |
| (Failover)      |                  | (Standby)       |
+--------+--------+                  +--------+--------+
         |                                    |
+--------+--------+                  +--------+--------+
| Front Door      |                  | Front Door      |
+--------+--------+                  +--------+--------+
         |                                    |
+--------+--------+                  +--------+--------+
| App Gateway     |                  | App Gateway     |
+--------+--------+                  +--------+--------+
         |                                    |
+--------+--------+                  +--------+--------+
| App Service     |                  | App Service     |
+--------+--------+                  +--------+--------+
         |                                    |
+--------+--------+                  +--------+--------+
| Azure SQL       |------------------| Azure SQL       |
| (Primary)       |    (Replication) | (Secondary)     |
+-----------------+                  +-----------------+
         |                                    |
+--------+--------+                  +--------+--------+
| Storage         |------------------| Storage         |
| (RA-GRS)        |   Replication    | (Secondary)     |
+-----------------+                  +-----------------+
```

**Failover Options**:
- **Traffic Manager**: DNS-based failover
- **Azure Front Door**: Global load balancing with failover
- **SQL Auto-Failover Groups**: Database-level failover
- **Geo-Redundant Storage**: Automatic replication

---

## Security Architecture

### Zero Trust Model

```
1. Verify Identity
   +-- Azure AD
   +-- MFA
   +-- Conditional Access
   +-- Identity Protection

2. Least Privilege
   +-- RBAC
   +-- PIM (Privileged Identity Management)
   +-- Just-in-Time Access

3. Micro-segmentation
   +-- NSGs
   +-- Azure Firewall
   +-- Private Link
   +-- VNet Integration

4. Encrypt Everything
   +-- Key Vault
   +-- TDE (Transparent Data Encryption)
   +-- TLS 1.3
   +-- Azure Confidential Computing

5. Continuous Monitoring
   +-- Azure Monitor
   +-- Azure Sentinel
   +-- Security Center
   +-- Defender for Cloud
```

### Network Security Architecture

```
Internet
    |
+---+---+
| DDoS   | (Layer 3/4 protection)
| Protection |
+---+---+
    |
+---+---+
| Front  | (Global CDN + WAF)
| Door   |
+---+---+
    |
+---+---+
| App    | (L7 Load Balancing + WAF)
| Gateway |
+---+---+
    |
+---+---+
| NSG    | (Subnet-level firewall)
+---+---+
    |
+---+---+
| Azure  | (Network virtual appliance)
| Firewall |
+---+---+
    |
+---+---+
| Private| (Private Link to services)
| Link   |
+---+---+
    |
+---+---+
| VM/    | (Compute)
| Container |
+---+---+
```

---

## Cost-Effective Architectures

### Pattern: Auto Scaling with Spot VMs

```
                    +-----------------+
                    | App Gateway     |
                    +--------+--------+
                             |
        +--------------------+--------------------+
        |                                         |
+-------+------+                         +--------+--------+
| Pay-As-You-Go|                         | Spot VMs        |
| (Base Load)  |                         | (Burst)         |
+-------+------+                         +--------+--------+
```

**Cost Savings**:
- Base load: Reserved VMs (up to 72% savings)
- Burst capacity: Spot VMs (up to 90% savings)
- Auto-scaling: Scale based on demand

### Pattern: Serverless Cost Optimization

```
Traditional:                      Serverless:
+------------------+              +------------------+
| VM (24/7)        |              | Functions (per   |
| $500/month       |              | execution) $50   |
+------------------+              +------------------+
| SQL DB (24/7)    |              | Cosmos DB (per   |
| $300/month       |              | request) $50     |
+------------------+              +------------------+
| Total: $800      |              | Total: $100      |
+------------------+              +------------------+
```

### Pattern: Azure Hybrid Benefit

```
Without Hybrid Benefit:
- 100 VMs x $0.20/hour = $20/hour = $14,600/month

With Hybrid Benefit (existing Windows Server licenses):
- 100 VMs x $0.08/hour = $8/hour = $5,840/month
- Savings: $8,760/month (60%)
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

### VM Scale Sets Configuration

```
Instance Count:
- Minimum: 2 (Always running)
- Maximum: 10 (Scale limit)
- Default: 3 (Current)

Scaling Policy:
+-- Metric-based: CPU at 70%
+-- Schedule: Scale at specific times
+-- Custom: Application metrics
```

### Azure App Service Scaling

```
Standard Tier and above:
- Scale Up: Increase VM size
- Scale Out: Add instances (up to 30)
- Auto-scale: Based on metrics

Configuration:
- CPU > 70%: Add 2 instances
- CPU < 30%: Remove 1 instance
- Min instances: 2
- Max instances: 10
```

---

## Reference Architecture: E-Commerce Platform

```
                        +-----------------+
                        | Azure DNS       |
                        +--------+--------+
                                 |
                        +--------+--------+
                        | Front Door      |
                        | (CDN + WAF)     |
                        +--------+--------+
                                 |
              +------------------+------------------+
              |                  |                  |
     +--------+--------+ +------+------+ +---------+--------+
     | Static Web Apps | | App Gateway  | | API Management   |
     | (Static)        | | (L7 LB)     | | (API Gateway)    |
     +-----------------+ +------+------+ +---------+--------+
                                 |                  |
              +------------------+------------------+
              |                  |                  |
     +--------+--------+ +------+--------+ +-------+--------+
     | AKS: Web App    | | AKS: Product | | Functions: Auth |
     +-----------------+ | Service      | +-----------------+
              |          +------+--------+         |
     +--------+--------+ +------+--------+ +------+--------+
     | Redis Cache     | | Cosmos DB    | | Azure AD       |
     | (Sessions)      | | (Products)   | | (B2C)          |
     +-----------------+ +--------------+ +---------------+
              |
     +--------+--------+
     | Azure SQL       |
     | (Orders, Users) |
     | (Business Critical)
     +-----------------+
```

**Components**:
- **Azure DNS**: DNS routing
- **Front Door**: Global CDN, WAF, SSL termination
- **App Gateway**: Regional load balancing, WAF
- **AKS**: Containerized microservices
- **Cosmos DB**: Product catalog (multi-region, multi-model)
- **Azure SQL**: Transactional data (Business Critical tier)
- **Redis Cache**: Session management, product caching
- **API Management**: API gateway, rate limiting, analytics
- **Azure AD B2C**: Customer identity and access management
