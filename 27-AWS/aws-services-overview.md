# AWS Services Overview - Complete Reference Guide

## Table of Contents

1. [Compute Services](#compute-services)
2. [Storage Services](#storage-services)
3. [Database Services](#database-services)
4. [Networking & Content Delivery](#networking--content-delivery)
5. [Security, Identity & Compliance](#security-identity--compliance)
6. [Management & Governance](#management--governance)
7. [Developer Tools](#developer-tools)
8. [Machine Learning](#machine-learning)
9. [Analytics](#analytics)
10. [Application Integration](#application-integration)

---

## Compute Services

### Amazon EC2 (Elastic Compute Cloud)
- **Type**: IaaS
- **Use Case**: Virtual servers for any workload
- **Key Features**: Auto-scaling, Elastic Load Balancing, Multiple instance types
- **Pricing**: On-Demand, Reserved, Spot, Dedicated

### AWS Lambda
- **Type**: FaaS (Function as a Service)
- **Use Case**: Event-driven code execution
- **Key Features**: Pay per invocation, auto-scaling, no server management
- **Limit**: 15 min max execution, 10 GB memory

### Amazon ECS (Elastic Container Service)
- **Type**: Container Orchestration
- **Use Case**: Run Docker containers at scale
- **Key Features**: Fargate (serverless), EC2 launch type
- **Pricing**: Fargate per vCPU/hour, EC2 per instance

### Amazon EKS (Elastic Kubernetes Service)
- **Type**: Managed Kubernetes
- **Use Case**: Kubernetes workloads
- **Key Features**: Managed control plane, Fargate support
- **Pricing**: Per cluster + worker node costs

### AWS Elastic Beanstalk
- **Type**: PaaS
- **Use Case**: Deploy apps without infrastructure management
- **Key Features**: Auto-scaling, load balancing, health monitoring
- **Support**: Java, .NET, PHP, Node.js, Python, Ruby, Go, Docker

### Amazon Lightsail
- **Type**: Simplified VPS
- **Use Case**: Simple websites, small applications
- **Key Features**: Fixed monthly pricing, easy setup
- **Pricing**: Starting at $3.50/month

### AWS Batch
- **Type**: Batch Processing
- **Use Case**: Run batch computing jobs
- **Key Features**: Auto-scaling compute, managed job queues
- **Integration**: ECS, EKS, Fargate

### AWS Outposts
- **Type**: Hybrid Cloud
- **Use Case**: AWS infrastructure on-premises
- **Key Features**: Same APIs, hardware managed by AWS

---

## Storage Services

### Amazon S3 (Simple Storage Service)
- **Type**: Object Storage
- **Use Case**: Any file/object storage
- **Key Features**: 99.999999999% durability, versioning, lifecycle policies
- **Storage Classes**: Standard, IA, One Zone-IA, Glacier, Deep Archive

### Amazon EBS (Elastic Block Store)
- **Type**: Block Storage
- **Use Case**: Persistent storage for EC2
- **Key Features**: Snapshots, encryption, multiple volume types
- **Types**: gp3, io1, io2, st1, sc1

### Amazon EFS (Elastic File System)
- **Type**: Network File System
- **Use Case**: Shared file storage for EC2
- **Key Features**: Auto-scaling, NFSv4 support, multi-AZ
- **Performance**: General Purpose, Max I/O

### Amazon FSx
- **Type**: Managed File Systems
- **Use Case**: Windows/Lustre workloads
- **Options**: FSx for Windows, FSx for Lustre, FSx for NetApp ONTAP

### AWS Storage Gateway
- **Type**: Hybrid Storage
- **Use Case**: Connect on-prem to cloud storage
- **Modes**: File Gateway, Volume Gateway, Tape Gateway

### AWS Snow Family
- **Type**: Physical Data Transfer
- **Use Case**: Migrate large datasets
- **Options**: Snowcone (2TB), Snowball (80TB), Snowmobile (100PB)

---

## Database Services

### Amazon RDS (Relational Database Service)
- **Type**: Managed Relational Database
- **Engines**: MySQL, PostgreSQL, MariaDB, Oracle, SQL Server
- **Key Features**: Automated backups, Multi-AZ, read replicas
- **Use Case**: Traditional OLTP workloads

### Amazon Aurora
- **Type**: Cloud-Native Relational Database
- **Engines**: MySQL-compatible, PostgreSQL-compatible
- **Key Features**: 5x MySQL performance, 3x PostgreSQL performance
- **Storage**: Auto-scaling up to 128 TB

### Amazon DynamoDB
- **Type**: NoSQL Key-Value Document Database
- **Use Case**: High-scale applications needing consistent low latency
- **Key Features**: Single-digit ms latency, auto-scaling, global tables
- **Capacity**: On-Demand or Provisioned

### Amazon ElastiCache
- **Type**: In-Memory Cache
- **Engines**: Redis, Memcached
- **Use Case**: Caching, session stores, gaming leaderboards
- **Key Features**: Sub-millisecond latency, replication

### Amazon Redshift
- **Type**: Data Warehouse
- **Use Case**: Analytics and business intelligence
- **Key Features**: Columnar storage, ML-powered tuning, federated queries

### Amazon Neptune
- **Type**: Graph Database
- **Use Case**: Social networking, knowledge graphs, fraud detection
- **Query Languages**: Gremlin, SPARQL, openCypher

### Amazon DocumentDB
- **Type**: Document Database
- **Use Case**: MongoDB-compatible workloads
- **Key Features**: Fully managed, up to 15 read replicas

### Amazon Keyspaces
- **Type**: Wide-Column Database
- **Use Case**: Cassandra-compatible workloads
- **Key Features**: Serverless, auto-scaling

### Amazon QLDB
- **Type**: Ledger Database
- **Use Case**: Systems of record, supply chain
- **Key Features**: Immutable transaction log, cryptographically verifiable

---

## Networking & Content Delivery

### Amazon VPC (Virtual Private Cloud)
- **Type**: Virtual Network
- **Use Case**: Isolated cloud network
- **Key Features**: Subnets, route tables, internet gateways, VPN

### Amazon CloudFront
- **Type**: Content Delivery Network (CDN)
- **Use Case**: Global content delivery
- **Key Features**: 400+ edge locations, SSL/TLS, DDoS protection
- **Integration**: S3, EC2, ELB, Lambda@Edge

### AWS Direct Connect
- **Type**: Dedicated Network Connection
- **Use Case**: Hybrid cloud connectivity
- **Key Features**: 1 Gbps to 100 Gbps, consistent bandwidth

### Amazon Route 53
- **Type**: DNS Service
- **Use Case**: Domain registration and DNS routing
- **Routing**: Simple, Weighted, Latency, Failover, Geolocation

### AWS Global Accelerator
- **Type**: Network Accelerator
- **Use Case**: Improve availability and performance
- **Key Features**: Anycast IP, TCP/UDP optimization

### Elastic Load Balancing
- **Type**: Load Balancing
- **Types**: ALB (Application), NLB (Network), GLB (Gateway)
- **Use Case**: Distribute traffic across targets

---

## Security, Identity & Compliance

### AWS IAM (Identity and Access Management)
- **Type**: Access Management
- **Use Case**: Control who can access what
- **Components**: Users, Groups, Roles, Policies

### AWS KMS (Key Management Service)
- **Type**: Encryption Key Management
- **Use Case**: Create and manage encryption keys
- **Key Features**: HSM-backed, automatic key rotation

### AWS WAF (Web Application Firewall)
- **Type**: Application Security
- **Use Case**: Protect web apps from exploits
- **Features**: SQL injection prevention, XSS protection, rate limiting

### AWS Shield
- **Type**: DDoS Protection
- **Tiers**: Standard (free), Advanced (paid)
- **Use Case**: Protect against DDoS attacks

### Amazon GuardDuty
- **Type**: Threat Detection
- **Use Case**: Intelligent threat monitoring
- **Data Sources**: CloudTrail, VPC Flow Logs, DNS logs

### AWS Secrets Manager
- **Type**: Secrets Management
- **Use Case**: Rotate and manage secrets
- **Key Features**: Automatic rotation, cross-account access

### AWS Certificate Manager
- **Type**: SSL/TLS Certificates
- **Use Case**: Provision and manage certificates
- **Key Features**: Free public certificates, auto-renewal

---

## Management & Governance

### Amazon CloudWatch
- **Type**: Monitoring & Observability
- **Use Case**: Metrics, logs, alarms
- **Key Features**: Dashboards, anomaly detection, synthetics

### AWS CloudFormation
- **Type**: Infrastructure as Code
- **Use Case**: Define and provision AWS resources
- **Key Features**: Templates, stacks, drift detection

### AWS CDK (Cloud Development Kit)
- **Type**: IaC Framework
- **Use Case**: Define infrastructure with code (Python, TypeScript, etc.)
- **Key Features**: High-level constructs, reusable components

### AWS Systems Manager
- **Type**: Operations Management
- **Use Case**: Operational insights, automation
- **Features**: Parameter Store, Session Manager, Patch Manager

### AWS Config
- **Type**: Resource Configuration Tracking
- **Use Case**: Compliance monitoring
- **Key Features**: Configuration history, compliance rules

### AWS CloudTrail
- **Type**: API Logging
- **Use Case**: Governance, compliance, operational auditing
- **Key Features**: Event history, integration with CloudWatch

### AWS Trusted Advisor
- **Type**: Best Practice Recommendations
- **Use Case**: Cost optimization, security, performance
- **Key Features**: Real-time guidance, 5 pillars

---

## Developer Tools

### AWS CodeCommit
- **Type**: Source Control
- **Use Case**: Private Git repositories
- **Key Features**: Code review, branch permissions

### AWS CodeBuild
- **Type**: Build Service
- **Use Case**: Compile source, run tests, produce artifacts
- **Key Features**: Fully managed, buildspec.yml

### AWS CodeDeploy
- **Type**: Deployment Automation
- **Use Case**: Deploy code to EC2, Lambda, ECS
- **Strategies**: Rolling, Blue/Green, Canary

### AWS CodePipeline
- **Type**: CI/CD Pipeline
- **Use Case**: Automate release pipelines
- **Key Features**: Multi-stage, parallel execution

### AWS Cloud9
- **Type**: Cloud IDE
- **Use Case**: Write, run, debug code in browser
- **Key Features**: Pre-configured environments, pair programming

### AWS X-Ray
- **Type**: Distributed Tracing
- **Use Case**: Debug and analyze distributed applications
- **Key Features**: Service maps, latency analysis

---

## Machine Learning

### Amazon SageMaker
- **Type**: ML Platform
- **Use Case**: Build, train, deploy ML models
- **Key Features**: Built-in algorithms, AutoML, hosting

### Amazon Rekognition
- **Type**: Computer Vision
- **Use Case**: Image and video analysis
- **Features**: Object detection, face recognition, text detection

### Amazon Lex
- **Type**: Conversational AI
- **Use Case**: Chatbots and voice assistants
- **Key Features**: Natural language understanding, integration with Lambda

### Amazon Polly
- **Type**: Text-to-Speech
- **Use Case**: Convert text to speech
- **Key Features**: Multiple languages, SSML support

### Amazon Comprehend
- **Type**: Natural Language Processing
- **Use Case**: Text analysis, sentiment detection
- **Key Features**: Entity recognition, key phrases, language detection

### Amazon Transcribe
- **Type**: Speech-to-Text
- **Use Case**: Audio transcription
- **Key Features**: Real-time, batch, custom vocabularies

### Amazon Translate
- **Type**: Machine Translation
- **Use Case**: Language translation
- **Key Features**: Real-time, batch, custom terminology

---

## Analytics

### Amazon Athena
- **Type**: Interactive Query Service
- **Use Case**: Query S3 data using SQL
- **Key Features**: Serverless, pay per query, integrates with Glue

### AWS Glue
- **Type**: ETL Service
- **Use Case**: Prepare and load data for analytics
- **Key Features**: Serverless, data catalog, auto-discovery

### Amazon Kinesis
- **Type**: Real-time Data Streaming
- **Use Case**: Stream processing, real-time analytics
- **Components**: Data Streams, Data Firehose, Analytics

### Amazon EMR
- **Type**: Big Data Processing
- **Use Case**: Apache Spark, Hadoop, Hive
- **Key Features**: Managed clusters, auto-scaling

### Amazon MSK
- **Type**: Managed Kafka
- **Use Case**: Event streaming, log aggregation
- **Key Features**: Apache Kafka compatible, auto-scaling

---

## Application Integration

### Amazon SQS (Simple Queue Service)
- **Type**: Message Queue
- **Use Case**: Decouple distributed systems
- **Types**: Standard, FIFO
- **Key Features**: At-least-once delivery, dead letter queues

### Amazon SNS (Simple Notification Service)
- **Type**: Pub/Sub Messaging
- **Use Case**: Send notifications
- **Channels**: SMS, email, Lambda, HTTP

### Amazon EventBridge
- **Type**: Event Bus
- **Use Case**: Connect applications with events
- **Key Features**: Schema registry, partner events

### AWS Step Functions
- **Type**: Workflow Orchestration
- **Use Case**: Coordinate distributed applications
- **Types**: Standard, Express

---

## Services Comparison Matrix

| Category | AWS Service | Alternative | Best For |
|----------|-------------|-------------|----------|
| Compute | EC2 | Azure VMs, GCE | General compute |
| Serverless | Lambda | Azure Functions, Cloud Functions | Event-driven |
| Containers | ECS/EKS | AKS, GKE | Container workloads |
| Object Storage | S3 | Blob Storage, Cloud Storage | Files/objects |
| Block Storage | EBS | Managed Disks, Persistent Disk | VM storage |
| Relational DB | RDS/Aurora | Azure SQL, Cloud SQL | SQL workloads |
| NoSQL | DynamoDB | Cosmos DB, Firestore | Key-value |
| CDN | CloudFront | Azure CDN, Cloud CDN | Content delivery |
| DNS | Route 53 | Azure DNS, Cloud DNS | Domain management |
| Queue | SQS | Service Bus, Pub/Sub | Async messaging |
| Monitoring | CloudWatch | Azure Monitor, Cloud Monitoring | Observability |
| IaC | CloudFormation | ARM Templates, Deployment Manager | Infrastructure |
| ML | SageMaker | Azure ML, Vertex AI | Machine learning |
