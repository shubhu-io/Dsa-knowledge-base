# Azure Interview Questions - Comprehensive Guide

## Table of Contents

1. [Fundamental Questions](#fundamental-questions)
2. [Compute Questions](#compute-questions)
3. [Storage Questions](#storage-questions)
4. [Database Questions](#database-questions)
5. [Networking Questions](#networking-questions)
6. [Security Questions](#security-questions)
7. [Architecture Questions](#architecture-questions)
8. [Cost Optimization Questions](#cost-optimization-questions)
9. [Scenario-Based Questions](#scenario-based-questions)
10. [Hands-On Lab Questions](#hands-on-lab-questions)

---

## Fundamental Questions

### Q1: What is Microsoft Azure and its key features?

**Answer**:
Azure is Microsoft's cloud computing platform offering 200+ services:
- **Compute**: VMs, App Service, Functions, AKS
- **Storage**: Blob, Files, Data Lake
- **Database**: SQL Database, Cosmos DB, MySQL/PostgreSQL
- **Networking**: VNet, Load Balancer, Front Door
- **AI/ML**: Cognitive Services, Azure ML
- **DevOps**: Azure DevOps, Pipelines

### Q2: What is Azure Active Directory (Azure AD)?

**Answer**:
Azure AD is Microsoft's cloud-based identity and access management service:
- **SSO**: Single sign-on across applications
- **MFA**: Multi-factor authentication
- **Conditional Access**: Risk-based policies
- **B2B/B2C**: External identities
- **500M+ identities**: Largest identity provider

### Q3: What is the difference between Azure AD and Active Directory?

**Answer**:
| Feature | Azure AD | Active Directory |
|---------|----------|------------------|
| Type | Cloud-based | On-premises |
| Protocol | OAuth, OIDC, SAML | LDAP, Kerberos |
| Structure | Flat (no OUs) | Hierarchical |
| Use Case | Modern apps | Traditional apps |
| Management | Portal | ADUC/GPO |

### Q4: What are Azure Resource Groups?

**Answer**:
- Logical containers for Azure resources
- Resources can be in only one group
- Group can contain resources from different regions
- Used for access control, billing, and lifecycle management

### Q5: Explain Azure Regions and Availability Zones

**Answer**:
- **Region**: Geographic area with one or more data centers
- **Availability Zone**: Physically separate data center within a region
- **Region Pair**: Two regions in same geography for DR
- **Example**: East US has 3 AZs, paired with West US

---

## Compute Questions

### Q6: When would you use Azure Functions vs Logic Apps?

**Answer**:
| Feature | Functions | Logic Apps |
|---------|-----------|------------|
| Type | Code (C#, Java, Python) | Low-code designer |
| Trigger | Custom code | 200+ connectors |
| Runtime | Consumption/Premium | Consumption/Standard |
| Use Case | Custom logic | Integration workflows |
| State | Stateless/Durable | Stateful |

### Q7: What is Azure Kubernetes Service (AKS)?

**Answer**:
- Managed Kubernetes control plane
- Free control plane, pay for worker nodes
- Integration with Azure AD, Monitor, Policy
- Options: System/User node pools, Virtual Nodes
- Use Case: Container orchestration at scale

### Q8: What are VM Scale Sets (VMSS)?

**Answer**:
- Group of load-balanced VMs
- Auto-scaling (metric-based, schedule)
- Up to 1000 instances
- Use Case: Web servers, batch processing
- Integration with App Gateway, Load Balancer

### Q9: What is the difference between Azure App Service and Azure Functions?

**Answer**:
| Feature | App Service | Functions |
|---------|-------------|-----------|
| Hosting | Always running | On-demand |
| Scaling | Manual/Auto | Automatic |
| Use Case | Web apps, APIs | Event-driven |
| Pricing | Per instance hour | Per execution |
| Cold Start | No | Yes (can be mitigated) |

### Q10: What is Azure Container Instances (ACI)?

**Answer**:
- Serverless containers
- Per-second billing
- Fast startup (seconds)
- Use Cases: Build tasks, data processing, ML inference
- Integration: Azure Functions, Logic Apps, Kubernetes

---

## Storage Questions

### Q11: What are the Azure Blob Storage tiers?

**Answer**:
| Tier | Access | Use Case | Cost |
|------|--------|----------|------|
| Hot | Frequent | Active data | Highest |
| Cool | Infrequent | 30+ days | Medium |
| Archive | Rare | 180+ days | Lowest |

**Lifecycle Management**:
```json
{
    "rules": [{
        "actions": {
            "baseBlob": {
                "tierToCool": { "daysAfterModificationGreaterThan": 30 },
                "tierToArchive": { "daysAfterModificationGreaterThan": 180 }
            }
        }
    }]
}
```

### Q12: What is the difference between Azure Files and Azure Blob Storage?

**Answer**:
| Feature | Azure Files | Blob Storage |
|---------|-------------|--------------|
| Protocol | SMB/NFS | REST API |
| Access | Mount as drive | HTTP/HTTPS |
| Use Case | Shared files | Objects, backups |
| Performance | Standard/Premium | Standard/Premium |
| Metadata | Limited | Unlimited |

### Q13: What is Azure Data Lake Storage Gen2?

**Answer**:
- Hadoop-compatible storage
- Hierarchical namespace (folders)
- Designed for big data analytics
- Integration: Spark, Databricks, Synapse
- Performance: High throughput, low latency

### Q14: What are the redundancy options for Azure Storage?

**Answer**:
- **LRS**: 3 copies in one data center
- **ZRS**: 3 copies across 3 AZs
- **GRS**: 6 copies (2 regions)
- **RA-GRS**: GRS + read access to secondary
- **GZRS**: ZRS + geo-redundancy
- **RA-GZRS**: GZRS + read access

### Q15: What is Azure Managed Disks?

**Answer**:
- Block storage for VMs
- Types: Ultra SSD, Premium SSD, Standard SSD, Standard HDD
- Features: Snapshots, encryption, resizing
- Performance: Up to 160,000 IOPS
- Use Cases: OS disks, data disks, databases

---

## Database Questions

### Q16: When to use Azure SQL Database vs SQL Managed Instance?

**Answer**:
| Feature | SQL Database | SQL Managed Instance |
|---------|--------------|---------------------|
| Compatibility | Most SQL Server | Near 100% |
| Cross-DB Queries | No | Yes |
| Instance Features | Limited | Full |
| Migration | Easy | Lift-and-shift |
| Use Case | New apps | Legacy migration |

### Q17: What is Cosmos DB and its consistency levels?

**Answer**:
Globally distributed NoSQL database with 5 consistency levels:
1. **Strong**: Linearizable, highest latency
2. **Bounded Staleness**: Version based, configurable lag
3. **Session**: Default, consistent within session
4. **Consistent Prefix**: Reads lag behind writes
5. **Eventual**: No ordering guarantee, lowest latency

### Q18: What is Azure Cache for Redis?

**Answer**:
- In-memory data store (Redis)
- **Tiers**: Basic, Standard, Premium, Enterprise
- **Use Cases**: Session storage, database caching, messaging
- **Features**: Clustering, persistence, geo-replication
- **Performance**: Sub-millisecond latency

### Q19: What is Azure Synapse Analytics?

**Answer**:
- Unified analytics platform
- **Components**: SQL pools, Spark pools, Data Explorer
- **Features**: Serverless and dedicated options
- **Integration**: Power BI, Azure ML
- **Use Cases**: Data warehousing, big data analytics

### Q20: What is Azure Database Migration Service?

**Answer**:
- Migrate databases to Azure
- **Support**: SQL Server, MySQL, PostgreSQL, Oracle, MongoDB
- **Methods**: Online and offline migration
- **Features**: Schema migration, data sync, minimal downtime
- **Use Cases**: Cloud migration, version upgrades

---

## Networking Questions

### Q21: What is Azure Virtual Network (VNet)?

**Answer**:
- Isolated network in Azure
- **Components**: Subnets, NSGs, Route Tables, Peering
- **Features**: Private IP addresses, DNS, DHCP
- **Connectivity**: VPN Gateway, ExpressRoute, VNet Peering
- **Best Practice**: Segment into subnets (web, app, data)

### Q22: What is the difference between NSG and Azure Firewall?

**Answer**:
| Feature | NSG | Azure Firewall |
|---------|-----|----------------|
| Level | Subnet/NIC | VNet |
| Rules | L3/L4 | L3/L4/L7 |
| Features | Allow/Deny | FQDN, threat intelligence |
| Use Case | Basic filtering | Advanced security |
| Cost | Free | Premium |

### Q23: What is Azure Front Door?

**Answer**:
- Global load balancer + CDN
- **Features**: SSL offloading, WAF, caching
- **Routing**: Priority, Weighted, Session Affinity
- **Health Probes**: Continuous monitoring
- **Use Case**: Global applications, high availability

### Q24: What is the difference between Azure Load Balancer and Application Gateway?

**Answer**:
| Feature | Load Balancer | Application Gateway |
|---------|---------------|-------------------|
| Layer | L4 (TCP/UDP) | L7 (HTTP/HTTPS) |
| Features | Basic LB | WAF, SSL termination |
| Use Case | Non-HTTP traffic | Web applications |
| Routing | IP/Port | URL, host, path |
| WAF | No | Yes |

### Q25: What is Azure ExpressRoute?

**Answer**:
- Dedicated private connection to Azure
- **Speeds**: 50 Mbps to 100 Gbps
- **Features**: Low latency, high bandwidth
- **Use Cases**: Hybrid cloud, data migration
- **SLA**: 99.95% uptime

---

## Security Questions

### Q26: What is Azure Key Vault?

**Answer**:
- Secure store for secrets, keys, certificates
- **Types**: Standard, Premium (HSM-backed)
- **Features**: Access policies, audit logging
- **Integration**: Azure services, DevOps
- **Use Cases**: Connection strings, encryption keys, certificates

### Q27: What is Azure Sentinel?

**Answer**:
- Cloud-native SIEM and SOAR
- **Features**: AI-powered threat detection
- **Integration**: Azure services, third-party
- **Automation**: Playbooks for response
- **Use Cases**: Security monitoring, incident response

### Q28: What is Azure Policy?

**Answer**:
- Enforce organizational standards
- **Types**: Built-in, custom, initiative
- **Features**: Compliance evaluation, remediation
- **Use Cases**: Resource tagging, allowed VM sizes, regions
- **Integration**: Azure Blueprints, ARM templates

### Q29: What is Azure AD Conditional Access?

**Answer**:
- Risk-based access policies
- **Signals**: User, location, device, app, risk
- **Controls**: MFA, blocking, compliant device
- **Use Cases**: Require MFA for admins, block legacy auth
- **Integration**: Identity Protection, PIM

### Q30: What is Azure DDoS Protection?

**Answer**:
- Protect against DDoS attacks
- **Tiers**: Basic (free), Standard (advanced)
- **Features**: Adaptive tuning, real-time metrics
- **Integration**: Azure Firewall, WAF
- **Use Cases**: Public-facing applications

---

## Architecture Questions

### Q31: Design a highly available web application

**Answer**:
```
Architecture:
- Multi-AZ deployment
- VM Scale Sets or App Service
- Azure Load Balancer/Application Gateway
- Traffic Manager for DNS failover
- Azure SQL with auto-failover groups
- Azure Cache for Redis

Components:
1. Traffic Manager (DNS, failover)
2. Front Door (CDN, WAF)
3. App Gateway (Load balancing)
4. VMSS/App Service (Web tier)
5. Azure SQL (Database)
6. Redis Cache (Caching)
```

### Q32: How would you migrate an on-premises SQL Server to Azure?

**Answer**:
```
Options:
1. Azure Database Migration Service
   - Online migration with minimal downtime
   - Schema and data migration

2. SQL Server on Azure VM
   - Lift-and-shift
   - Full SQL Server compatibility

3. Azure SQL Database
   - Modernize to PaaS
   - Limited compatibility

Steps:
1. Assess with DMA (Database Migration Assistant)
2. Create target (SQL Database/MI)
3. Configure DMS
4. Test and validate
5. Cutover
```

### Q33: Design a serverless API

**Answer**:
```
Architecture:
Client -> Front Door -> API Management -> Functions -> Cosmos DB

Benefits:
- No servers to manage
- Auto-scaling
- Pay per request
- High availability

Components:
- Front Door: CDN, SSL
- API Management: API gateway
- Functions: Compute
- Cosmos DB: NoSQL database
- Azure AD B2C: Authentication
```

### Q34: How do you handle disaster recovery in Azure?

**Answer**:
```
Strategies (by RTO/RPO):

1. Backup & Restore (Hours)
   - Azure Backup, Storage snapshots
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
   - Traffic Manager failover
   - RTO: Near zero, RPO: Near zero
```

### Q35: What is Azure Arc?

**Answer**:
- Extend Azure to any infrastructure
- **Servers**: Manage on-prem/other cloud servers
- **Kubernetes**: Manage clusters anywhere
- **Data Services**: Run data services anywhere
- **Use Cases**: Hybrid cloud, multi-cloud management

---

## Cost Optimization Questions

### Q36: How do you reduce Azure costs?

**Answer**:
```
Strategies:
1. Reserved Instances (up to 72% savings)
2. Azure Hybrid Benefit (use existing licenses)
3. Spot VMs (up to 90% savings)
4. Right-sizing (Azure Advisor)
5. Auto-shutdown dev/test VMs
6. Azure Cost Management
7. DevTest Labs (cost control)
```

### Q37: What is Azure Hybrid Benefit?

**Answer**:
- Use existing Windows Server/Datacenter licenses
- Save up to 85% on VMs
- Save up to 55% on SQL Server
- Apply to VMs, SQL Database, SQL Managed Instance
- Requires Software Assurance

### Q38: What is Azure Reserved Instances?

**Answer**:
- Commit to 1 or 3 year term
- Save up to 72% vs Pay-As-You-Go
- Apply to VMs, SQL Database, Cosmos DB
- Exchangeable across VM sizes
- Cancel with penalty

### Q39: How do you set up billing alerts?

**Answer**:
```bash
# Create budget
az consumption budget create \
    --amount 1000 \
    --name "Monthly Budget" \
    --category Cost \
    --time-grain Monthly \
    --start-date 2024-01-01 \
    --end-date 2024-12-31

# Set alert threshold
az consumption budget create \
    --amount 1000 \
    --threshold 80 \
    --contact emails "admin@company.com"
```

### Q40: What is Azure Advisor?

**Answer**:
- Personalized recommendations
- **Areas**: Reliability, Security, Performance, Cost
- **Features**: Actionable insights, best practices
- **Integration**: Azure Portal, REST API
- **Use Cases**: Optimization, compliance

---

## Scenario-Based Questions

### Q41: Your application is experiencing high latency. How do you diagnose?

**Answer**:
```
Diagnosis:
1. Azure Monitor metrics (VM, network)
2. Application Insights (dependencies)
3. SQL Database metrics (DTU/IO)
4. Network Watcher (latency, throughput)

Fixes:
1. Enable Front Door/CDN caching
2. Add Redis Cache
3. Right-size VMs
4. Optimize SQL queries
5. Enable compression
6. Use Availability Zones
```

### Q42: You need to process 1TB of data daily. Which services?

**Answer**:
```
Options:
1. Databricks (Spark) - Complex processing
2. Data Factory (ETL) - Data integration
3. Synapse Analytics - SQL queries
4. Functions (Small chunks) - Event-driven
5. Event Hubs + Stream Analytics (Real-time)

Architecture:
Storage (Data Lake) -> Data Factory (ETL) -> Synapse (Analytics) -> Power BI (BI)
```

### Q43: How do you handle sudden traffic spikes?

**Answer**:
```
Immediate:
1. VMSS auto-scaling
2. App Service auto-scale
3. Front Door for static content
4. Redis Cache for database load

Long-term:
1. Implement CDN caching
2. Database read replicas
3. Queue-based architecture (Service Bus)
4. Static content on Storage/Static Web Apps
```

### Q44: Your application needs to be PCI DSS compliant. How?

**Answer**:
```
Requirements:
1. Network segmentation (VNet, NSGs)
2. Encryption at rest (Key Vault, TDE)
3. Encryption in transit (TLS 1.3)
4. Access controls (Azure AD, RBAC)
5. Logging (Azure Monitor, Sentinel)
6. Regular assessments (Security Center)

Services:
- VNet, NSGs, Azure Firewall
- Key Vault, Storage Service Encryption
- Azure AD, PIM
- Azure Monitor, Sentinel
```

### Q45: How do you monitor a distributed microservices application?

**Answer**:
```
Monitoring Stack:
1. Azure Monitor: Metrics, Logs, Alerts
2. Application Insights: Distributed tracing
3. Log Analytics: Centralized logging
4. Sentinel: Security monitoring

Best Practices:
- Centralized logging (Log Analytics)
- Service maps (Application Insights)
- Custom dashboards
- Automated alerts (Action Groups)
```

---

## Hands-On Lab Questions

### Q46: Deploy a static website to Azure Storage

**Answer**:
```bash
# Create storage account
az storage account create \
    --name mystorageaccount \
    --resource-group myRG \
    --location eastus \
    --sku Standard_LRS \
    --kind StorageV2

# Enable static website
az storage blob service-properties update \
    --account-name mystorageaccount \
    --static-website

# Upload files
az storage blob upload-batch \
    --account-name mystorageaccount \
    --source ./website \
    --destination \$web
```

### Q47: Set up a CI/CD pipeline with Azure DevOps

**Answer**:
```
Components:
1. Azure Repos: Source repository
2. Azure Pipelines: CI/CD
3. Azure Artifacts: Package management
4. Azure Test Plans: Testing

YAML Pipeline:
trigger:
  branches:
    include:
      - main

pool:
  vmImage: 'ubuntu-latest'

stages:
- stage: Build
  jobs:
  - job: BuildJob
    steps:
    - task: DotNetCoreCLI@2
      inputs:
        command: 'build'

- stage: Deploy
  jobs:
  - deployment: DeployWeb
    environment: 'staging'
```

### Q48: Create a Function triggered by Queue Storage

**Answer**:
```csharp
// C# Azure Function
[FunctionName("QueueTrigger")]
public static async Task Run(
    [QueueTrigger("myqueue", Connection = "AzureWebJobsStorage")]
    string myQueueItem,
    ILogger log)
{
    log.LogInformation($"Processing queue item: {myQueueItem}");
    
    // Process the message
    await Task.CompletedTask;
}
```

### Q49: Set up Azure Monitor alerts

**Answer**:
```bash
# Create action group
az monitor action-group create \
    --resource-group myRG \
    --name myActionGroup \
    --short-name myAG

# Create alert rule
az monitor metrics alert create \
    --resource-group myRG \
    --name "High CPU" \
    --scopes /subscriptions/{sub-id}/resourceGroups/myRG/providers/Microsoft.Compute/virtualMachines/myVM \
    --condition "avg Percentage CPU > 80" \
    --window-size 5m \
    --evaluation-frequency 1m \
    --action myActionGroup
```

### Q50: Implement Azure Policy for compliance

**Answer**:
```bash
# Create policy definition
az policy definition create \
    --name "Allowed VM Sizes" \
    --rules '{
        "if": {
            "allOf": [
                {
                    "field": "type",
                    "equals": "Microsoft.Compute/virtualMachines"
                },
                {
                    "not": {
                        "field": "Microsoft.Compute/virtualMachines/vmSize",
                        "in": ["Standard_D2s_v3", "Standard_D4s_v3"]
                    }
                }
            ]
        },
        "then": {
            "effect": "deny"
        }
    }'

# Assign policy
az policy assignment create \
    --name "VM Size Restriction" \
    --policy "Allowed VM Sizes" \
    --scope /subscriptions/{sub-id}/resourceGroups/myRG
```

---

## Additional Resources

### Practice Labs
- Microsoft Learn
- Azure Sandbox
- Pluralsight Azure Labs
- A Cloud Guru Azure Labs

### Certification Paths
1. AZ-900: Azure Fundamentals
2. AZ-104: Azure Administrator
3. AZ-204: Azure Developer
4. AZ-305: Azure Solutions Architect
5. AZ-500: Azure Security Engineer
6. AZ-400: DevOps Engineer

### Key Services to Know
- **Compute**: VMs, App Service, Functions, AKS
- **Storage**: Blob, Files, Data Lake
- **Database**: SQL Database, Cosmos DB, Redis
- **Networking**: VNet, Front Door, Application Gateway
- **Security**: Azure AD, Key Vault, Sentinel
- **Monitoring**: Azure Monitor, Application Insights
