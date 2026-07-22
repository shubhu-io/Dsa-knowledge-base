# Microsoft Azure - Cloud Computing Platform

## Overview

Microsoft Azure is a comprehensive cloud computing platform offering 200+ services for building, deploying, and managing applications through Microsoft-managed data centers. Azure is the second-largest cloud provider and excels in enterprise integration, hybrid cloud, and Microsoft ecosystem support.

## Learning Path

### Stage 1: Cloud Fundamentals (Week 1-2)
- [Azure Guide](azure-guide.md) - Complete beginner to intermediate guide
- Understanding Azure cloud concepts
- Azure Global Infrastructure
- Azure Active Directory and RBAC

### Stage 2: Core Services (Week 3-4)
- [Azure Services Overview](azure-services-overview.md) - Detailed service catalog
- Virtual Machines, Blob Storage, SQL Database, VNets
- Hands-on labs with Azure Free Account

### Stage 3: Architecture & Design (Week 5-6)
- [Azure Architecture](azure-architecture.md) - Well-Architected Framework
- Designing resilient architectures
- Cost optimization strategies

### Stage 4: Interview Preparation (Week 7-8)
- [Azure Interview Questions](azure-interview-questions.md) - 100+ questions
- System design scenarios
- Hands-on project deployment

## Key Files

| File | Description | Lines |
|------|-------------|-------|
| [azure-guide.md](azure-guide.md) | Comprehensive Azure learning guide | 200 |
| [azure-services-overview.md](azure-services-overview.md) | All major Azure services explained | 200 |
| [azure-architecture.md](azure-architecture.md) | Well-Architected Framework & patterns | 200 |
| [azure-interview-questions.md](azure-interview-questions.md) | Interview prep with answers | 200 |

## Azure Certification Paths

```
AZ-900: Azure Fundamentals
    |
    +---> AZ-104: Azure Administrator
    |         |
    |         +---> AZ-305: Azure Solutions Architect Expert
    |
    +---> AZ-204: Azure Developer Associate
    |         |
    |         +---> AZ-400: DevOps Engineer Expert
    |
    +---> AZ-500: Azure Security Engineer
    |         |
    |         +---> SC-100: Cybersecurity Architect Expert
    |
    +---> DP-203: Azure Data Engineer
    +---> AI-102: Azure AI Engineer
```

## Azure Global Regions

| Region | Location | Use Case |
|--------|----------|----------|
| East US | Virginia | Default region |
| West US 2 | Washington | West Coast |
| West Europe | Netherlands | Europe |
| Southeast Asia | Singapore | Asia Pacific |
| Japan East | Tokyo | Japan |

## Quick Start Commands

```bash
# Install Azure CLI
winget install Microsoft.AzureCLI

# Login
az login

# Create resource group
az group create --name myRG --location eastus

# Create VM
az vm create --resource-group myRG --name myVM \
    --image UbuntuLTS --admin-username azureuser \
    --ssh-key-value ~/.ssh/id_rsa.pub
```

## Prerequisites

- Azure Free Account ($200 credit for 30 days)
- Basic understanding of networking
- Command line familiarity
- Programming knowledge (C#, Python, JavaScript helpful)

## Resources

- [Azure Documentation](https://docs.microsoft.com/azure/)
- [Azure Architecture Center](https://docs.microsoft.com/azure/architecture/)
- [Microsoft Learn](https://docs.microsoft.com/learn/)
- [Azure Sandbox](https://shell.azure.com/)

---

**Next:** Start with [azure-guide.md](azure-guide.md) for a complete learning journey.
