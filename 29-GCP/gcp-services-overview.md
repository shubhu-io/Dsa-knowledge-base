# GCP Services Overview - Complete Reference Guide

## Table of Contents

1. [Compute Services](#compute-services)
2. [Storage Services](#storage-services)
3. [Database Services](#database-services)
4. [Networking Services](#networking-services)
5. [Identity & Security](#identity--security)
6. [AI & Machine Learning](#ai--machine-learning)
7. [Analytics Services](#analytics-services)
8. [DevOps & Developer Tools](#devops--developer-tools)
9. [IoT Services](#iot-services)
10. [Management & Governance](#management--governance)

---

## Compute Services

### Compute Engine
- **Type**: IaaS
- **Use Case**: Virtual machines for any workload
- **Key Features**: Custom machine types, sustained use discounts, per-second billing
- **Machine Types**: E2, N2, C2, M2, A2

### Google Kubernetes Engine (GKE)
- **Type**: Managed Kubernetes
- **Use Case**: Container orchestration at scale
- **Modes**: Autopilot (serverless), Standard (node management)
- **Key Features**: Binary Authorization, Workload Identity, Anthos

### Cloud Run
- **Type**: Serverless Containers
- **Use Case**: Request-driven microservices
- **Key Features**: Scale to zero, HTTP/HTTPS, WebSockets
- **Pricing**: Per request and CPU time

### Cloud Functions
- **Type**: FaaS (Function as a Service)
- **Use Case**: Event-driven code execution
- **Versions**: Gen 1 (traditional), Gen 2 (Cloud Events)
- **Triggers**: HTTP, Pub/Sub, Cloud Storage, Firestore

### App Engine
- **Type**: PaaS
- **Use Case**: Web applications and APIs
- **Environments**: Standard (sandboxed), Flexible (Docker)
- **Support**: Python, Java, Node.js, Go, PHP, Ruby, .NET

### Cloud Build
- **Type**: CI/CD
- **Use Case**: Build and test applications
- **Key Features**: Serverless, parallel builds, caching
- **Integration**: Cloud Deploy, Artifact Registry

### Migrate to Virtual Machines
- **Type**: Migration Service
- **Use Case**: Lift-and-shift to Compute Engine
- **Features**: Automated migration, minimal downtime

---

## Storage Services

### Cloud Storage
- **Type**: Object Storage
- **Use Case**: Any unstructured data
- **Classes**: Standard, Nearline, Coldline, Archive
- **Features**: Versioning, lifecycle, dual-region

### Persistent Disk
- **Type**: Block Storage
- **Use Case**: Boot and data disks for VMs
- **Types**: SSD (pd-ssd, pd-balanced), HDD (pd-standard)
- **Features**: Snapshots, cloning, resize

### Filestore
- **Type**: Managed File Storage
- **Use Case**: Shared file systems
- **Tiers**: Basic HDD, Basic SSD, Enterprise, Zonal
- **Integration**: GKE, Compute Engine

### Cloud Storage FUSE
- **Type**: File System Interface
- **Use Case**: Mount Cloud Storage as file system
- **Use Cases**: ML training data, container storage

### Cloud Source Repositories
- **Type**: Git Repository
- **Use Case**: Source code management
- **Features**: Code search, Cloud Build triggers

---

## Database Services

### Cloud SQL
- **Type**: Managed Relational Database
- **Engines**: MySQL, PostgreSQL, SQL Server
- **Key Features**: Automated backups, replication, high availability
- **Use Cases**: Web applications, e-commerce

### Cloud Spanner
- **Type**: Global Relational Database
- **Use Case**: Mission-critical, globally distributed
- **Key Features**: 99.999% SLA, strong consistency, horizontal scaling
- **Pricing**: Per node + storage

### Cloud Firestore
- **Type**: NoSQL Document Database
- **Use Case**: Mobile and web applications
- **Key Features**: Real-time sync, offline support, ACID transactions
- **Integration**: Firebase, client libraries

### Cloud Bigtable
- **Type**: Wide-Column NoSQL
- **Use Case**: IoT, time-series, analytics
- **Key Features**: Petabyte scale, low latency, HBase-compatible
- **Use Cases**: AdTech, IoT, monitoring

### Memorystore
- **Type**: In-Memory Cache
- **Engines**: Redis, Memcached
- **Tiers**: Basic, Standard
- **Use Cases**: Session storage, caching, real-time analytics

### BigQuery
- **Type**: Serverless Data Warehouse
- **Use Case**: Analytics and business intelligence
- **Key Features**: ML integration, GIS support, streaming inserts
- **Pricing**: Per query (on-demand) or capacity (flat-rate)

---

## Networking Services

### Virtual Private Cloud (VPC)
- **Type**: Virtual Network
- **Use Case**: Isolated cloud network
- **Features**: Global VPC, shared VPC, custom modes

### Cloud Load Balancing
- **Type**: Load Balancing
- **Types**: Global HTTP(S), SSL Proxy, TCP Proxy, Internal
- **Features**: Health checks, auto-scaling, Cloud CDN integration

### Cloud CDN
- **Type**: Content Delivery Network
- **Use Case**: Global content caching
- **Features**: Edge caching, SSL, integration with Load Balancing

### Cloud Armor
- **Type**: DDoS and WAF Protection
- **Use Case**: Protect web applications
- **Features**: Pre-configured rules, custom rules, adaptive protection

### Cloud DNS
- **Type**: DNS Hosting
- **Use Case**: Domain management
- **Features**: 100% SLA, DNSSEC, private zones

### Cloud VPN
- **Type**: VPN Connectivity
- **Use Case**: Connect on-premises to GCP
- **Types**: HA VPN (99.99% SLA), Classic VPN

### Cloud Interconnect
- **Type**: Dedicated/Private Connection
- **Use Case**: Hybrid cloud connectivity
- **Types**: Dedicated, Partner
- **Speeds**: 50 Gbps to 100 Gbps

### Cloud Router
- **Type**: BGP Routing
- **Use Case**: Dynamic routing for VPN/Interconnect
- **Features**: BGP, custom routes

### Network Intelligence Center
- **Type**: Network Monitoring
- **Use Case**: Network visibility and troubleshooting
- **Features**: Topology, connectivity tests, firewall insights

---

## Identity & Security

### Cloud IAM
- **Type**: Identity and Access Management
- **Use Case**: Control who can access what
- **Roles**: Basic, Predefined, Custom
- **Features**: IAM Conditions, Deny policies

### Cloud Identity
- **Type**: Managed Users and Groups
- **Use Case**: SSO, user management
- **Features**: Directory, device management

### VPC Service Controls
- **Type**: Security Perimeter
- **Use Case**: Prevent data exfiltration
- **Features**: Perimeters, dry-run mode, audit logging

### Cloud Armor
- **Type**: DDoS and WAF
- **Use Case**: Protect web applications
- **Features**: Adaptive protection, bot management

### Secret Manager
- **Type**: Secrets Management
- **Use Case**: Store API keys, passwords
- **Features**: Versioning, rotation, audit logging

### Cloud KMS
- **Type**: Key Management
- **Use Case**: Manage encryption keys
- **Features**: HSM, key rotation, external keys

### Security Command Center
- **Type**: Security Posture Management
- **Use Case**: Threat detection, vulnerability scanning
- **Features**: Premium and Enterprise tiers

### Binary Authorization
- **Type**: Container Security
- **Use Case**: Deploy only trusted containers
- **Features**: Policy enforcement, attestation

---

## AI & Machine Learning

### Vertex AI
- **Type**: ML Platform
- **Use Case**: Build, deploy, scale ML models
- **Features**: AutoML, custom training, Model Garden
- **Integration**: BigQuery ML, TensorFlow

### Cloud Vision AI
- **Type**: Computer Vision
- **Use Case**: Image analysis
- **Features**: Label detection, face detection, OCR, object detection

### Cloud Natural Language
- **Type**: NLP
- **Use Case**: Text analysis
- **Features**: Sentiment, entities, syntax, content classification

### Cloud Translation
- **Type**: Machine Translation
- **Use Case**: Language translation
- **Features**: AutoML Translation, custom models

### Dialogflow
- **Type**: Conversational AI
- **Use Case**: Chatbots, voice assistants
- **Versions**: ES (Essentials), CX (Customer Experience)

### Cloud Speech-to-Text
- **Type**: Speech Recognition
- **Use Case**: Audio transcription
- **Features**: Real-time, batch, multiple languages

### Cloud Text-to-Speech
- **Type**: Speech Synthesis
- **Use Case**: Convert text to speech
- **Features**: Multiple voices, SSML support

### Recommendations AI
- **Type**: Recommendation Engine
- **Use Case**: Product recommendations
- **Features**: Personalization, real-time

### Cloud AI Platform
- **Type**: ML Training and Prediction
- **Use Case**: Custom ML models
- **Features**: Distributed training, hyperparameter tuning

---

## Analytics Services

### BigQuery
- **Type**: Serverless Data Warehouse
- **Use Case**: Analytics, BI, ML
- **Features**: SQL queries, ML integration, GIS, streaming

### Cloud Dataflow
- **Type**: Stream and Batch Processing
- **Use Case**: ETL/ELT, real-time analytics
- **Features**: Apache Beam, auto-scaling, exactly-once

### Cloud Dataproc
- **Type**: Managed Hadoop/Spark
- **Use Case**: Big data processing
- **Features**: Spark, Hadoop, Hive, Presto

### Cloud Pub/Sub
- **Type**: Messaging
- **Use Case**: Event streaming, async messaging
- **Features**: At-least-once delivery, real-time

### Cloud Data Fusion
- **Type**: ETL/ELT
- **Use Case**: Data integration
- **Features**: Visual pipeline builder, 150+ connectors

### Looker
- **Type**: Business Intelligence
- **Use Case**: Data visualization, dashboards
- **Features**: LookML, embedded analytics

### Data Catalog
- **Type**: Metadata Management
- **Use Case**: Data discovery and governance
- **Features**: Tagging, search, lineage

---

## DevOps & Developer Tools

### Cloud Build
- **Type**: CI/CD
- **Use Case**: Build, test, deploy
- **Features**: Serverless, parallel, caching
- **Integration**: GitHub, Bitbucket, Cloud Deploy

### Cloud Deploy
- **Type**: Continuous Delivery
- **Use Case**: Automate deployments
- **Features**: Canary, blue/green, custom targets

### Artifact Registry
- **Type**: Package Management
- **Use Case**: Store build artifacts
- **Features**: Docker, Maven, npm, Python

### Cloud Code
- **Type**: IDE Extension
- **Use Case**: Develop cloud-native apps
- **Support**: VS Code, IntelliJ, Cloud Shell

### Cloud Shell
- **Type**: Cloud Development Environment
- **Use Case**: Manage resources from browser
- **Features**: 5GB home directory, pre-installed tools

### Deployment Manager
- **Type**: Infrastructure as Code
- **Use Case**: Deploy GCP resources
- **Features**: YAML templates, Jinja2

### Terraform on GCP
- **Type**: Multi-cloud IaC
- **Use Case**: Infrastructure provisioning
- **Features**: Google provider, modules

---

## IoT Services

### Cloud IoT Core
- **Status**: Deprecated (migrated to partner solutions)
- **Alternative**: Pub/Sub, Cloud Run for IoT workloads

### Pub/Sub for IoT
- **Type**: Event Streaming
- **Use Case**: Ingest IoT telemetry
- **Features**: At-least-once, real-time, global

---

## Management & Governance

### Cloud Monitoring
- **Type**: Observability
- **Use Case**: Metrics, alerts, dashboards
- **Features**: SLI/SLO, uptime checks, custom metrics

### Cloud Logging
- **Type**: Centralized Logging
- **Use Case**: Log management and analysis
- **Features**: Log-based metrics, export, sinks

### Cloud Trace
- **Type**: Distributed Tracing
- **Use Case**: Performance analysis
- **Features**: Latency analysis, trace sampling

### Cloud Profiler
- **Type**: Continuous Profiling
- **Use Case**: CPU and memory profiling
- **Features**: Production profiling, low overhead

### Cloud Audit Logs
- **Type**: Audit Logging
- **Use Case**: Compliance, security
- **Features**: Admin activity, data access, system events

### Organization Policy
- **Type**: Governance
- **Use Case**: Enforce constraints
- **Features**: Service constraints, resource constraints

### Cloud Asset Inventory
- **Type**: Asset Management
- **Use Case**: Track all resources
- **Features**: Feed, export, search

### Recommender
- **Type**: Optimization
- **Use Case**: Cost and performance recommendations
- **Features**: VM rightsizing, committed use, IP addresses

---

## Services Comparison: GCP vs AWS vs Azure

| Category | GCP | AWS | Azure |
|----------|-----|-----|-------|
| Compute | Compute Engine | EC2 | Virtual Machines |
| Containers | GKE | EKS | AKS |
| Serverless | Cloud Run | Lambda | Functions |
| Object Storage | Cloud Storage | S3 | Blob Storage |
| Relational DB | Cloud SQL | RDS | Azure SQL |
| NoSQL | Firestore | DynamoDB | Cosmos DB |
| Data Warehouse | BigQuery | Redshift | Synapse |
| CDN | Cloud CDN | CloudFront | Front Door |
| DNS | Cloud DNS | Route 53 | Azure DNS |
| IAM | Cloud IAM | IAM | Azure AD |
| Monitoring | Cloud Monitoring | CloudWatch | Azure Monitor |
| IaC | Deployment Manager | CloudFormation | ARM/Bicep |
| ML | Vertex AI | SageMaker | Azure ML |
