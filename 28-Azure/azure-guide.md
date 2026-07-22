# Azure Complete Guide - From Zero to Cloud Architect

## Table of Contents

1. [Azure Fundamentals](#azure-fundamentals)
2. [Azure Global Infrastructure](#azure-global-infrastructure)
3. [Getting Started](#getting-started)
4. [Core Services Deep Dive](#core-services-deep-dive)
5. [Virtual Machines](#virtual-machines)
6. [Storage Solutions](#storage-solutions)
7. [Database Services](#database-services)
8. [Networking in Azure](#networking-in-azure)
9. [Identity & Security](#identity--security)
10. [Monitoring & Management](#monitoring--management)
11. [Cost Optimization](#cost-optimization)
12. [Best Practices](#best-practices)

---

## Azure Fundamentals

### What Makes Azure Unique?

- **Enterprise Integration**: Deep integration with Microsoft 365, Active Directory
- **Hybrid Cloud**: Azure Arc for consistent management
- **Enterprise Agreements**: Flexible licensing options
- **Open Source Support**: Strong Linux and open-source ecosystem
- **AI/ML**: Cognitive Services, Azure OpenAI

### Azure vs AWS Comparison

| Feature | Azure | AWS |
|---------|-------|-----|
| Launch Year | 2010 | 2006 |
| VM Service | Virtual Machines | EC2 |
| Storage | Blob Storage | S3 |
| Database | Azure SQL | RDS |
| Containers | AKS | EKS |
| Serverless | Functions | Lambda |
| Identity | Azure AD | IAM |
| IaC | ARM/Bicep/Terraform | CloudFormation |

---

## Azure Global Infrastructure

### Regions
- 60+ announced regions
- Most of any cloud provider
- Choose based on: latency, compliance, service availability

### Availability Zones
- Physically separate data centers
- 3 AZs in most regions
- Connected by low-latency fiber

### Regions Pairs
- Paired regions for disaster recovery
- Automatic failover capabilities
- Example: East US + West US

### Edge Locations
- Azure Front Door (CDN)
- Azure CDN
- ExpressRoute locations

```
Region: East US
    |
    +-- Availability Zone 1
    +-- Availability Zone 2
    +-- Availability Zone 3
    |
    +-- Paired Region: West US
    |
    +-- Edge Locations (CDN)
```

---

## Getting Started

### Step 1: Create Azure Account
1. Visit azure.microsoft.com
2. Sign up with Microsoft account
3. Get $200 credit for 30 days
4. Access 55+ always-free services

### Step 2: Install Azure CLI
```bash
# Windows
winget install Microsoft.AzureCLI

# macOS
brew install azure-cli

# Linux
curl -sL https://aka.ms/InstallAzureCLI | bash
```

### Step 3: Login and Set Subscription
```bash
az login
az account set --subscription "My Subscription"
az account show
```

### Step 4: Install Azure PowerShell (Optional)
```powershell
Install-Module -Name Az -AllowClobber -Scope CurrentUser
Connect-AzAccount
```

---

## Core Services Deep Dive

### Azure Virtual Machines

**What it does**: Provides resizable virtual machines (compute)

**VM Series**:
| Series | Use Case | Example |
|--------|----------|---------|
| B | Dev/Test, low-cost | B1s, B2ms |
| D | General purpose | D2s_v3, D4s_v3 |
| E | Memory optimized | E2s_v3, E4s_v3 |
| F | Compute optimized | F2s_v2, F4s_v2 |
| N | GPU/Visualization | NCasT4_v3, ND40rs_v2 |
| L | Storage optimized | L4s, L8s_v2 |

**Pricing Options**:
- **Pay-As-You-Go**: Per minute, no commitment
- **Reserved Instances**: 1-3 year commitment, up to 72% savings
- **Spot Instances**: Up to 90% discount, can be evicted
- **Azure Hybrid Benefit**: Use existing Windows Server licenses

```bash
# Create VM
az vm create \
    --resource-group myRG \
    --name myVM \
    --image UbuntuLTS \
    --size Standard_D2s_v3 \
    --admin-username azureuser \
    --ssh-key-value ~/.ssh/id_rsa.pub
```

### Azure Blob Storage

**What it does**: Scalable object storage

**Storage Tiers**:
| Tier | Access | Use Case | Cost |
|------|--------|----------|------|
| Hot | Frequent | Active data | Highest |
| Cool | Infrequent | 30+ days | Medium |
| Archive | Rare | 180+ days | Lowest |

```bash
# Create storage account
az storage account create \
    --name mystorageaccount \
    --resource-group myRG \
    --location eastus \
    --sku Standard_LRS

# Upload blob
az storage blob upload \
    --account-name mystorageaccount \
    --container-name mycontainer \
    --name myblob \
    --file ./myfile.txt
```

### Azure Virtual Network (VNet)

**What it does**: Isolated network in Azure

```
VNet: 10.0.0.0/16
    |
    +-- Subnet: Web (10.0.1.0/24)
    |       +-- VM (Web Server)
    |       +-- NSG Rules
    |
    +-- Subnet: App (10.0.2.0/24)
    |       +-- VM (App Server)
    |       +-- NSG Rules
    |
    +-- Subnet: Data (10.0.3.0/24)
    |       +-- SQL Database
    |       +-- NSG Rules
    |
    +-- Network Security Group
    +-- Route Table
    +-- VPN Gateway
```

---

## Virtual Machines

### VM Deployment Options

| Option | Description | Best For |
|--------|-------------|----------|
| Azure VMs | Full control | Custom configurations |
| Azure App Service | PaaS | Web applications |
| Azure Containers | Containers | Microservices |
| Azure Functions | Serverless | Event-driven |
| Azure Batch | Batch processing | HPC workloads |

### VM Scale Sets (VMSS)

```bash
# Create VMSS
az vmss create \
    --resource-group myRG \
    --name myVMSS \
    --image UbuntuLTS \
    --instance-count 2 \
    --admin-username azureuser \
    --ssh-key-value ~/.ssh/id_rsa.pub
```

**Features**:
- Auto-scaling (manual, schedule, metric-based)
- Load balancing integrated
- Update management
- Up to 1000 instances

### Availability Sets

- **Fault Domains**: Physical separation (up to 3)
- **Update Domains**: Logical separation (up to 20)
- Protects against hardware failures and maintenance

### VM Backup and Recovery

```bash
# Enable backup
az backup vault create \
    --resource-group myRG \
    --name myVault \
    --location eastus

az backup protection enable-for-vm \
    --resource-group myRG \
    --vault-name myVault \
    --vm myVM \
    --policy-name DefaultPolicy
```

---

## Storage Solutions

### Storage Account Types

| Type | Use Case | Performance |
|------|----------|-------------|
| Standard_LRS | General purpose | HDD |
| Standard_GRS | Geo-redundant | HDD |
| Premium_LRS | High-performance | SSD |
| Standard_ZRS | Zone-redundant | HDD |

### Storage Redundancy Options

```
LRS: 3 copies in one data center
ZRS: 3 copies across 3 AZs
GRS: 6 copies (2 regions, 3 AZs each)
RA-GRS: GRS + read access to secondary
GZRS: ZRS + geo-redundancy
RA-GZRS: GZRS + read access
```

### Azure Files

- Managed file shares (SMB/NFS)
- Accessible via SMB protocol
- Great for lift-and-shift
- Can be mounted on multiple VMs

### Azure Data Lake Storage

- Hadoop-compatible storage
- Designed for analytics
- Hierarchical namespace
- Integration with Spark, Databricks

---

## Database Services

| Service | Type | Use Case |
|---------|------|----------|
| Azure SQL Database | Relational | Enterprise SQL workloads |
| Azure Database for MySQL | Relational | MySQL workloads |
| Azure Database for PostgreSQL | Relational | PostgreSQL workloads |
| Cosmos DB | NoSQL | Global distribution, multi-model |
| Azure Cache for Redis | In-Memory | Caching, sessions |
| Azure Synapse Analytics | Data Warehouse | Analytics and BI |
| Azure SQL Managed Instance | PaaS SQL | SQL Server migration |

### Azure SQL Database Tiers

| Tier | Use Case | Features |
|------|----------|----------|
| Basic | Dev/Test | 2 DTUs, 2GB |
| Standard | Small apps | Up to 3000 DTUs |
| Premium | Mission-critical | Up to 4000 DTUs, in-memory |
| General Purpose | Most workloads | vCore, 2-96 vCores |
| Business Critical | High performance | vCore, in-memory OLTP |

### Cosmos DB

**Multi-Model Support**:
- SQL (Core)
- MongoDB
- Cassandra
- Gremlin (Graph)
- Table

**Consistency Levels**:
- Strong
- Bounded Staleness
- Session
- Consistent Prefix
- Eventual

```bash
# Create Cosmos DB
az cosmosdb create \
    --resource-group myRG \
    --name myCosmosDB \
    --kind GlobalDocumentDB \
    --location regionName=eastus \
    --default-consistency-level Session
```

---

## Networking in Azure

### Virtual Network (VNet)

**Key Components**:
- Subnets: Segment the VNet
- NSGs: Filter traffic
- Route Tables: Control routing
- VPN Gateway: Connect to on-premises
- VNet Peering: Connect VNets

### Network Security Groups (NSGs)

```bash
# Create NSG
az network nsg create \
    --resource-group myRG \
    --name myNSG

# Add rule
az network nsg rule create \
    --resource-group myRG \
    --nsg-name myNSG \
    --name AllowSSH \
    --priority 100 \
    --protocol Tcp \
    --destination-port-ranges 22 \
    --access Allow
```

### Azure Load Balancer

| Type | Use Case | Layer |
|------|----------|-------|
| Standard Load Balancer | High-performance | L4 (TCP/UDP) |
| Application Gateway | Web applications | L7 (HTTP/HTTPS) |
| Front Door | Global load balancing | L7 |

### Azure DNS

```bash
# Create DNS zone
az network dns zone create \
    --resource-group myRG \
    --name mydomain.com

# Add record
az network dns record-set a add-record \
    --resource-group myRG \
    --zone-name mydomain.com \
    --record-set-name www \
    --ipv4-address 10.0.1.4
```

---

## Identity & Security

### Azure Active Directory (Azure AD)

**Features**:
- Single Sign-On (SSO)
- Multi-Factor Authentication (MFA)
- Conditional Access
- Privileged Identity Management
- Identity Protection

### Role-Based Access Control (RBAC)

```bash
# Assign role
az role assignment create \
    --assignee user@domain.com \
    --role "Contributor" \
    --scope /subscriptions/{sub-id}/resourceGroups/myRG
```

**Built-in Roles**:
- Owner: Full access
- Contributor: Create and manage
- Reader: View only
- User Access Administrator: Manage user access

### Azure Key Vault

- Store secrets, keys, certificates
- Hardware Security Modules (HSM)
- Integration with Azure services
- Audit logging

```bash
# Create Key Vault
az keyvault create \
    --resource-group myRG \
    --name myKeyVault \
    --enabled-for-deployment true
```

### Azure Security Center

- Unified security management
- Threat protection
- Compliance assessment
- Secure Score recommendations

---

## Monitoring & Management

### Azure Monitor

**Components**:
- Metrics: Numerical data
- Logs: Log Analytics workspace
- Alerts: Notification system
- Dashboards: Visualization

```bash
# Create alert rule
az monitor metrics alert create \
    --resource-group myRG \
    --name "High CPU" \
    --scopes /subscriptions/{sub-id}/resourceGroups/myRG/providers/Microsoft.Compute/virtualMachines/myVM \
    --condition "avg Percentage CPU > 80" \
    --window-size 5m \
    --evaluation-frequency 1m
```

### Azure Log Analytics

```bash
# Create workspace
az monitor log-analytics workspace create \
    --resource-group myRG \
    --workspace-name myWorkspace

# Query logs
az monitor log-analytics query \
    --workspace myWorkspace \
    --analytics-query "Heartbeat | summarize count() by Computer"
```

### Azure Policy

- Define rules for resources
- Compliance evaluation
- Automatic remediation
- Initiative definitions

### Azure Automation

- Runbooks (PowerShell, Python)
- Update management
- Inventory management
- Change tracking

---

## Cost Optimization

### Strategies

| Strategy | Savings |
|----------|---------|
| Reserved Instances | Up to 72% vs Pay-As-You-Go |
| Spot VMs | Up to 90% vs Pay-As-You-Go |
| Azure Hybrid Benefit | Use existing licenses |
| Right-sizing | Match VM to workload |
| Auto-shutdown | Stop dev/test VMs |
| Azure Advisor | Cost recommendations |

### Cost Management Tools

- **Azure Cost Management**: Analyze and optimize
- **Azure Advisor**: Personalized recommendations
- **Pricing Calculator**: Estimate costs
- **TCO Calculator**: Compare on-prem vs cloud

```bash
# View costs
az cost management query \
    --type Usage \
    --time-period start=2024-01-01 end=2024-01-31 \
    --dataset granularity=Monthly
```

### Budget Alerts

```bash
# Create budget
az consumption budget create \
    --amount 1000 \
    --name "Monthly Budget" \
    --category Cost \
    --time-grain Monthly \
    --start-date 2024-01-01 \
    --end-date 2024-12-31
```

---

## Best Practices

### Well-Architected Framework Pillars

1. **Operational Excellence**
   - Infrastructure as Code (ARM/Bicep/Terraform)
   - CI/CD pipelines (Azure DevOps)
   - Monitoring and logging
   - Runbooks and documentation

2. **Security**
   - Zero Trust architecture
   - Azure AD with MFA
   - Key Vault for secrets
   - Network segmentation

3. **Reliability**
   - Multi-AZ deployments
   - Availability Zones
   - Auto-scaling
   - Backup and disaster recovery

4. **Performance Efficiency**
   - Right-size VMs
   - Use caching (Azure Cache for Redis)
   - CDN for static content
   - Auto-scaling

5. **Cost Optimization**
   - Reserved Instances
   - Azure Hybrid Benefit
   - Auto-shutdown dev environments
   - Monitor with Cost Management

6. **Sustainability**
   - Choose efficient regions
   - Right-size resources
   - Auto-scaling
   - Managed services

---

## Next Steps

1. Complete the [Azure Services Overview](azure-services-overview.md)
2. Study [Azure Architecture](azure-architecture.md) patterns
3. Practice with [Interview Questions](azure-interview-questions.md)
4. Build a project: Deploy a 3-tier web application
5. Pursue AZ-104: Azure Administrator certification
