# Azure Services Overview - Complete Reference Guide

## Table of Contents

1. [Compute Services](#compute-services)
2. [Storage Services](#storage-services)
3. [Database Services](#database-services)
4. [Networking Services](#networking-services)
5. [Identity & Security](#identity--security)
6. [AI & Machine Learning](#ai--machine-learning)
7. [Analytics Services](#analytics-services)
8. [DevOps & Developer Tools](#devops--developer-tools)
9. [Internet of Things](#internet-of-things)
10. [Management & Governance](#management--governance)

---

## Compute Services

### Azure Virtual Machines
- **Type**: IaaS
- **Use Case**: Full control over compute resources
- **Key Features**: 500+ VM sizes, Premium SSD, Ultra Disk
- **Pricing**: Pay-As-You-Go, Reserved, Spot

### Azure App Service
- **Type**: PaaS
- **Use Case**: Web applications, APIs, mobile backends
- **Key Features**: Auto-scaling, deployment slots, custom domains
- **Support**: .NET, Java, Node.js, Python, PHP, Ruby

### Azure Functions
- **Type**: FaaS (Serverless)
- **Use Case**: Event-driven code execution
- **Key Features**: Pay per execution, auto-scaling, Durable Functions
- **Triggers**: HTTP, Timer, Queue, Blob, Event Hub

### Azure Kubernetes Service (AKS)
- **Type**: Managed Kubernetes
- **Use Case**: Container orchestration
- **Key Features**: Azure integration, auto-scaling, Azure AD
- **Pricing**: Free control plane, pay for worker nodes

### Azure Container Instances (ACI)
- **Type**: Serverless Containers
- **Use Case**: Simple container workloads
- **Key Features**: Fast startup, per-second billing, VNet integration
- **Use Cases**: Build tasks, data processing, ML inference

### Azure Container Apps
- **Type**: Serverless Containers
- **Use Case**: Microservices, web apps, APIs
- **Key Features**: Auto-scaling, Dapr integration, KEDA

### Azure Batch
- **Type**: Batch Processing
- **Use Case**: Large-scale parallel computing
- **Key Features**: Auto-scaling, task scheduling
- **Use Cases**: Rendering, simulations, encoding

### Azure Cloud Services
- **Type**: PaaS (Classic)
- **Use Case**: N-tier applications
- **Key Features**: Auto-scaling, load balancing
- **Status**: Legacy, use App Service instead

---

## Storage Services

### Azure Blob Storage
- **Type**: Object Storage
- **Use Case**: Unstructured data, files, backups
- **Key Features**: Hot/Cool/Archive tiers, lifecycle management
- **Performance**: Standard HDD, Standard SSD, Premium SSD

### Azure Files
- **Type**: Managed File Share
- **Use Case**: Lift-and-shift, shared files
- **Key Features**: SMB/NFS support, Azure File Sync
- **Integration**: Can mount on Windows, Linux, macOS

### Azure Data Lake Storage Gen2
- **Type**: Analytics Storage
- **Use Case**: Big data analytics
- **Key Features**: Hierarchical namespace, Hadoop compatibility
- **Integration**: Spark, Databricks, Synapse Analytics

### Azure Queue Storage
- **Type**: Message Queue
- **Use Case**: Async message processing
- **Key Features**: Simple messaging, reliable delivery
- **Limit**: 64 KB message size

### Azure Table Storage
- **Type**: NoSQL Key-Value
- **Use Case**: Structured non-relational data
- **Key Features**: Schemaless, fast access, low cost

### Azure Managed Disks
- **Type**: Block Storage
- **Use Case**: Persistent storage for VMs
- **Types**: Ultra SSD, Premium SSD, Standard SSD, Standard HDD
- **Features**: Snapshots, encryption, resizing

---

## Database Services

### Azure SQL Database
- **Type**: Managed Relational Database
- **Use Case**: SQL Server workloads
- **Key Features**: Built-in intelligence, auto-tuning, TDE
- **Tiers**: Basic, Standard, Premium, General Purpose, Business Critical

### Azure SQL Managed Instance
- **Type**: Managed SQL Server
- **Use Case**: SQL Server migration (lift-and-shift)
- **Key Features**: Near 100% SQL Server compatibility
- **Use Cases**: Instance-scoped features, cross-database queries

### Azure Database for MySQL
- **Type**: Managed MySQL
- **Use Case**: MySQL workloads
- **Tiers**: Flexible Server (recommended), Single Server (legacy)

### Azure Database for PostgreSQL
- **Type**: Managed PostgreSQL
- **Use Case**: PostgreSQL workloads
- **Options**: Flexible Server, Hyperscale (Citus)

### Azure Cosmos DB
- **Type**: Globally Distributed NoSQL
- **Use Case**: Global applications, multi-model
- **Key Features**: 99.999% SLA, multi-model, multi-region
- **APIs**: SQL, MongoDB, Cassandra, Gremlin, Table

### Azure Cache for Redis
- **Type**: In-Memory Cache
- **Use Case**: Caching, session storage
- **Tiers**: Basic, Standard, Premium, Enterprise
- **Features**: Clustering, persistence, geo-replication

### Azure Synapse Analytics
- **Type**: Data Warehouse
- **Use Case**: Analytics and BI
- **Key Features**: Serverless and dedicated pools, Spark integration
- **Integration**: Power BI, Azure ML

### Azure Database Migration Service
- **Type**: Database Migration
- **Use Case**: Migrate databases to Azure
- **Support**: SQL Server, MySQL, PostgreSQL, Oracle, MongoDB

---

## Networking Services

### Azure Virtual Network (VNet)
- **Type**: Virtual Network
- **Use Case**: Isolated cloud network
- **Key Features**: Subnets, NSGs, Route Tables, Peering

### Azure Load Balancer
- **Type**: Load Balancing
- **Use Case**: High availability
- **Types**: Standard (L4), Basic (L4)
- **Features**: Health probes, HA ports, outbound rules

### Azure Application Gateway
- **Type**: Layer 7 Load Balancer
- **Use Case**: Web applications
- **Features**: WAF integration, SSL termination, URL-based routing

### Azure Front Door
- **Type**: Global Load Balancer + CDN
- **Use Case**: Global applications
- **Features**: SSL offloading, caching, health probes

### Azure Traffic Manager
- **Type**: DNS Load Balancing
- **Use Case**: Global traffic distribution
- **Methods**: Priority, Weighted, Performance, Geographic, Multivalue

### Azure VPN Gateway
- **Type**: VPN Connectivity
- **Use Case**: Connect on-premises to Azure
- **Types**: Site-to-Site, Point-to-Site, VNet-to-VNet

### Azure ExpressRoute
- **Type**: Dedicated Private Connection
- **Use Case**: Hybrid cloud connectivity
- **Speeds**: 50 Mbps to 100 Gbps
- **Features**: Low latency, high bandwidth, private connection

### Azure DNS
- **Type**: DNS Hosting
- **Use Case**: Domain management
- **Features**: DNS records, alias records, DNSSEC

### Azure DDoS Protection
- **Type**: DDoS Protection
- **Use Case**: Protect against attacks
- **Tiers**: Basic (free), Standard (advanced)

---

## Identity & Security

### Azure Active Directory (Azure AD)
- **Type**: Identity and Access Management
- **Use Case**: SSO, MFA, conditional access
- **Features**: 500M+ identities, 4000+ app integrations

### Azure Key Vault
- **Type**: Secrets Management
- **Use Case**: Store secrets, keys, certificates
- **Features**: HSM support, access policies, audit logging

### Azure Security Center
- **Type**: Security Posture Management
- **Use Case**: Threat protection, compliance
- **Features**: Secure Score, recommendations, just-in-time VM access

### Azure Sentinel
- **Type**: SIEM and SOAR
- **Use Case**: Intelligent security analytics
- **Features**: AI-powered threat detection, automation

### Azure Information Protection
- **Type**: Data Protection
- **Use Case**: Classify and protect documents
- **Features**: Labels, encryption, rights management

### Azure Policy
- **Type**: Governance
- **Use Case**: Enforce standards and compliance
- **Features**: Initiatives, compliance dashboards, remediation

### Azure Blueprints
- **Type**: Environment Setup
- **Use Case**: Deploy repeatable environments
- **Components**: Role assignments, policies, ARM templates

---

## AI & Machine Learning

### Azure Machine Learning
- **Type**: ML Platform
- **Use Case**: Build, train, deploy ML models
- **Features**: AutoML, Designer, Notebooks, MLOps
- **Integration**: ONNX, MLflow, Kubeflow

### Azure Cognitive Services
- **Type**: Pre-built AI Models
- **Use Case**: Vision, Speech, Language, Decision
- **Services**:
  - Computer Vision
  - Speech Services
  - Text Analytics
  - Language Understanding
  - Translator
  - Form Recognizer

### Azure OpenAI Service
- **Type**: Generative AI
- **Use Case**: GPT, DALL-E, Codex models
- **Features**: Enterprise security, fine-tuning, responsible AI

### Azure Bot Service
- **Type**: Conversational AI
- **Use Case**: Chatbots, virtual assistants
- **Integration**: Teams, Slack, web, mobile

### Azure Cognitive Search
- **Type**: Search-as-a-Service
- **Use Case**: Full-text search, AI enrichment
- **Features**: Indexing, queries, AI skills

---

## Analytics Services

### Azure Synapse Analytics
- **Type**: Data Warehouse
- **Use Case**: Enterprise analytics
- **Features**: SQL pools, Spark pools, Data Explorer

### Azure Databricks
- **Type**: Apache Spark Platform
- **Use Case**: Big data processing, ML
- **Features**: Collaborative notebooks, auto-scaling, Delta Lake

### Azure Data Factory
- **Type**: ETL/ELT Service
- **Use Case**: Data integration and transformation
- **Features**: 100+ connectors, visual orchestration, mapping data flows

### Azure Event Hubs
- **Type**: Event Streaming
- **Use Case**: Real-time event ingestion
- **Features**: Throughput units, Kafka compatibility, capture

### Azure Stream Analytics
- **Type**: Stream Processing
- **Use Case**: Real-time analytics
- **Features**: SQL-like queries, machine learning integration

### Azure Data Lake Analytics
- **Type**: Analytics Service
- **Use Case**: On-demand analytics
- **Features**: U-SQL, parallel processing

### Azure HDInsight
- **Type**: Managed Hadoop
- **Use Case**: Open-source analytics
- **Types**: Hadoop, Spark, Kafka, HBase, LLAP

---

## DevOps & Developer Tools

### Azure DevOps
- **Type**: DevOps Platform
- **Use Case**: End-to-end DevOps
- **Components**:
  - Azure Repos: Git repositories
  - Azure Pipelines: CI/CD
  - Azure Boards: Work tracking
  - Azure Artifacts: Package management
  - Azure Test Plans: Testing

### Azure DevTest Labs
- **Type**: Test Environment Management
- **Use Case**: Dev/test environments
- **Features**: Auto-shutdown, cost control, formulas

### Azure Resource Manager (ARM)
- **Type**: Infrastructure as Code
- **Use Case**: Deploy and manage resources
- **Features**: Templates, Bicep, policies

### Azure Bicep
- **Type**: Domain-Specific Language
- **Use Case**: Simplified ARM templates
- **Features**: Clean syntax, modularity, validation

### Azure Terraform
- **Type**: Multi-cloud IaC
- **Use Case**: Infrastructure provisioning
- **Features**: State management, modules, providers

### Azure Static Web Apps
- **Type**: Static Site Hosting
- **Use Case**: Single-page applications
- **Features**: GitHub integration, custom domains, API support

---

## Internet of Things

### Azure IoT Hub
- **Type**: IoT Messaging
- **Use Case**: Device connectivity and management
- **Features**: Device twins, direct methods, file upload

### Azure IoT Central
- **Type**: IoT Application Platform
- **Use Case**: IoT solutions without coding
- **Features**: Templates, dashboards, rules

### Azure Digital Twins
- **Type**: Digital Twin Modeling
- **Use Case**: Model real-world environments
- **Features**: DTDL, graph queries, integration

### Azure Sphere
- **Type**: IoT Security
- **Use Case**: Secured MCU-based devices
- **Features**: Hardware security, OS, cloud services

---

## Management & Governance

### Azure Monitor
- **Type**: Monitoring & Observability
- **Use Case**: Metrics, logs, alerts
- **Components**: Metrics, Log Analytics, Application Insights

### Azure Policy
- **Type**: Governance
- **Use Case**: Enforce compliance
- **Features**: Built-in policies, custom definitions, initiatives

### Azure Automation
- **Type**: Process Automation
- **Use Case**: Runbooks, configuration management
- **Features**: PowerShell, Python, update management

### Azure Resource Manager
- **Type**: Resource Management
- **Use Case**: Deploy, manage, organize resources
- **Features**: Resource groups, tags, locks

### Azure Cost Management + Billing
- **Type**: Cost Optimization
- **Use Case**: Analyze and optimize spending
- **Features**: Cost analysis, budgets, recommendations

### Azure Advisor
- **Type**: Recommendations
- **Use Case**: Optimize deployments
- **Areas**: Reliability, Security, Performance, Cost

---

## Services Comparison: Azure vs AWS vs GCP

| Category | Azure | AWS | GCP |
|----------|-------|-----|-----|
| Compute | Virtual Machines | EC2 | Compute Engine |
| Containers | AKS | EKS | GKE |
| Serverless | Functions | Lambda | Cloud Functions |
| Object Storage | Blob Storage | S3 | Cloud Storage |
| Relational DB | Azure SQL | RDS | Cloud SQL |
| NoSQL | Cosmos DB | DynamoDB | Firestore |
| Data Warehouse | Synapse | Redshift | BigQuery |
| CDN | Front Door | CloudFront | Cloud CDN |
| DNS | Azure DNS | Route 53 | Cloud DNS |
| IAM | Azure AD | IAM | Cloud IAM |
| Monitoring | Azure Monitor | CloudWatch | Cloud Monitoring |
| IaC | ARM/Bicep | CloudFormation | Deployment Manager |
| ML | Azure ML | SageMaker | Vertex AI |
