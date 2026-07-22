# Big Data Architecture Patterns

## Overview

This guide covers common big data architecture patterns, their use cases, and implementation considerations.

## Architecture Patterns

```
Big Data Architecture Patterns
+------------------------------------------------------------------+
|                                                                    |
|  1. Lambda Architecture                                            |
|  2. Kappa Architecture                                            |
|  3. Data Lake Architecture                                        |
|  4. Data Mesh Architecture                                        |
|  5. Real-time Analytics Architecture                              |
|                                                                    |
+------------------------------------------------------------------+
```

---

## 1. Lambda Architecture

### Overview

Lambda Architecture processes data in both batch and real-time streams, combining the benefits of both approaches.

```
┌─────────────────────────────────────────────────────────────────┐
│                    Lambda Architecture                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│                        [Data Sources]                             │
│                             │                                     │
│                             v                                     │
│                      ┌─────────────┐                             │
│                      │   Master    │                             │
│                      │   Dataset   │                             │
│                      └──────┬──────┘                             │
│                             │                                     │
│              ┌──────────────┴──────────────┐                    │
│              v                              v                    │
│      ┌───────────────┐            ┌───────────────┐            │
│      │  Batch Layer  │            │ Speed Layer   │            │
│      │               │            │               │            │
│      │ - MapReduce   │            │ - Storm       │            │
│      │ - Spark       │            │ - Flink       │            │
│      │ - Hive        │            │ - Kafka       │            │
│      │               │            │               │            │
│      │ - Complete    │            │ - Real-time   │            │
│      │   recompute   │            │   processing  │            │
│      └───────┬───────┘            └───────┬───────┘            │
│              │                              │                    │
│              v                              v                    │
│      ┌───────────────┐            ┌───────────────┐            │
│      │   Batch       │            │    Serving    │            │
│      │   Views       │            │    Views      │            │
│      └───────┬───────┘            └───────┬───────┘            │
│              │                              │                    │
│              └──────────────┬──────────────┘                    │
│                             v                                     │
│                      ┌─────────────┐                             │
│                      │   Query     │                             │
│                      │   Layer     │                             │
│                      └─────────────┘                             │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

### Implementation

```python
# Lambda Architecture Implementation

class LambdaArchitecture:
    def __init__(self):
        self.batch_layer = BatchLayer()
        self.speed_layer = SpeedLayer()
        self.serving_layer = ServingLayer()

    def ingest(self, data):
        """Ingest data to both layers."""
        self.batch_layer.store(data)
        self.speed_layer.process(data)

    def query(self, query_params):
        """Query combining batch and real-time views."""
        batch_view = self.batch_layer.query(query_params)
        real_time_view = self.speed_layer.query(query_params)
        return self.merge(batch_view, real_time_view)

    def merge(self, batch_view, real_time_view):
        """Merge batch and real-time views."""
        # Combine results, real-time takes precedence
        merged = batch_view.copy()
        for key, value in real_time_view.items():
            merged[key] = value
        return merged


class BatchLayer:
    def __init__(self):
        self.hdfs_path = "/data/batch"

    def store(self, data):
        """Store raw data in HDFS."""
        pass

    def query(self, params):
        """Compute batch view."""
        # Run Spark job to compute view
        pass


class SpeedLayer:
    def __init__(self):
        self.cache = {}

    def process(self, data):
        """Process real-time data."""
        # Update real-time view
        pass

    def query(self, params):
        """Query real-time view."""
        return self.cache.get(params['key'], {})
```

### Pros and Cons

| Pros | Cons |
|------|------|
| Comprehensive view | Complex to implement |
| Real-time + batch | Two codebases to maintain |
| Fault tolerant | Operational overhead |
| Scalable | Consistency challenges |

---

## 2. Kappa Architecture

### Overview

Kappa Architecture simplifies Lambda by using only streaming for all processing.

```
┌─────────────────────────────────────────────────────────────────┐
│                    Kappa Architecture                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│                        [Data Sources]                             │
│                             │                                     │
│                             v                                     │
│                      ┌─────────────┐                             │
│                      │    Event    │                             │
│                      │    Log      │                             │
│                      │  (Kafka)    │                             │
│                      └──────┬──────┘                             │
│                             │                                     │
│                             v                                     │
│                      ┌─────────────┐                             │
│                      │  Streaming  │                             │
│                      │  Processor  │                             │
│                      │   (Flink)   │                             │
│                      └──────┬──────┘                             │
│                             │                                     │
│              ┌──────────────┴──────────────┐                    │
│              v                              v                    │
│      ┌───────────────┐            ┌───────────────┐            │
│      │  Real-time    │            │    Batch      │            │
│      │  View         │            │    View       │            │
│      │               │            │  (replay)     │            │
│      └───────┬───────┘            └───────┬───────┘            │
│              │                              │                    │
│              └──────────────┬──────────────┘                    │
│                             v                                     │
│                      ┌─────────────┐                             │
│                      │   Query     │                             │
│                      │   Layer     │                             │
│                      └─────────────┘                             │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

### Implementation

```python
# Kappa Architecture Implementation

class KappaArchitecture:
    def __init__(self):
        self.event_log = KafkaEventLog()
        self.processor = FlinkProcessor()
        self.views = ViewManager()

    def ingest(self, event):
        """Ingest event to log."""
        self.event_log.append(event)

    def process(self):
        """Process events and update views."""
        for event in self.event_log.consume():
            view_updates = self.processor.process(event)
            self.views.update(view_updates)

    def rebuild_view(self, view_name, from_offset=0):
        """Rebuild view by replaying log."""
        self.views.reset(view_name)
        for event in self.event_log.consume(from_offset):
            view_updates = self.processor.process(event)
            self.views.update(view_updates)

    def query(self, view_name, params):
        """Query view."""
        return self.views.query(view_name, params)
```

### Pros and Cons

| Pros | Cons |
|------|------|
| Simpler than Lambda | Limited to stream-capable workloads |
| Single codebase | Replay can be expensive |
| Easier to maintain | Requires robust event log |
| Consistent processing | Complex state management |

---

## 3. Data Lake Architecture

### Overview

Data Lake Architecture provides centralized storage for all data types with layered processing.

```
┌─────────────────────────────────────────────────────────────────┐
│                    Data Lake Architecture                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  [Sources]                                                       │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐           │
│  │  OLTP   │  │  IoT    │  │  Logs   │  │ External│           │
│  └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘           │
│       │            │            │            │                   │
│       v            v            v            v                   │
│  ┌─────────────────────────────────────────────────┐            │
│  │              Ingestion Layer                     │            │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐        │            │
│  │  │  Batch  │  │ Stream  │  │  CDC    │        │            │
│  │  └─────────┘  └─────────┘  └─────────┘        │            │
│  └─────────────────────────────────────────────────┘            │
│                          │                                       │
│                          v                                       │
│  ┌─────────────────────────────────────────────────┐            │
│  │              Storage Layers                      │            │
│  │  ┌─────────────────────────────────────────┐   │            │
│  │  │  Raw Zone (Bronze)                      │   │            │
│  │  │  - Original format                      │   │            │
│  │  │  - Immutable                            │   │            │
│  │  └─────────────────────────────────────────┘   │            │
│  │  ┌─────────────────────────────────────────┐   │            │
│  │  │  Curated Zone (Silver)                  │   │            │
│  │  │  - Cleaned, validated                  │   │            │
│  │  │  - Schema enforced                     │   │            │
│  │  └─────────────────────────────────────────┘   │            │
│  │  ┌─────────────────────────────────────────┐   │            │
│  │  │  Business Zone (Gold)                   │   │            │
│  │  │  - Business-ready                      │   │            │
│  │  │  - Aggregated                          │   │            │
│  │  └─────────────────────────────────────────┘   │            │
│  └─────────────────────────────────────────────────┘            │
│                          │                                       │
│                          v                                       │
│  ┌─────────────────────────────────────────────────┐            │
│  │              Consumption Layer                   │            │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐        │            │
│  │  │Analytics│  │   ML    │  │   BI    │        │            │
│  │  └─────────┘  └─────────┘  └─────────┘        │            │
│  └─────────────────────────────────────────────────┘            │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

### Implementation

```python
# Data Lake Implementation

class DataLake:
    def __init__(self, base_path):
        self.base_path = base_path
        self.raw_path = f"{base_path}/raw"
        self.curated_path = f"{base_path}/curated"
        self.business_path = f"{base_path}/business"

    def ingest_raw(self, data, source, timestamp):
        """Ingest raw data."""
        path = f"{self.raw_path}/{source}/{timestamp}"
        data.write.parquet(path)

    def process_to_curated(self, source):
        """Process raw to curated."""
        raw_data = self.read_raw(source)
        validated = self.validate(raw_data)
        cleaned = self.clean(validated)
        self.write_curated(cleaned, source)

    def process_to_business(self, source):
        """Process curated to business."""
        curated_data = self.read_curated(source)
        aggregated = self.aggregate(curated_data)
        self.write_business(aggregated, source)

    def validate(self, data):
        """Validate data quality."""
        # Run validation rules
        return data

    def clean(self, data):
        """Clean data."""
        # Remove duplicates, handle nulls
        return data

    def aggregate(self, data):
        """Aggregate for business use."""
        # Create business aggregations
        return data
```

---

## 4. Data Mesh Architecture

### Overview

Data Mesh is a decentralized, domain-oriented approach to data architecture.

```
┌─────────────────────────────────────────────────────────────────┐
│                    Data Mesh Architecture                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌─────────────────────────────────────────────────────┐       │
│  │              Data Platform                           │       │
│  │  ┌─────────────────────────────────────────────┐   │       │
│  │  │  Self-serve Data Infrastructure              │   │       │
│  │  │  - Storage                                   │   │       │
│  │  │  - Compute                                   │   │       │
│  │  │  - Governance                                │   │       │
│  │  └─────────────────────────────────────────────┘   │       │
│  └─────────────────────────────────────────────────────┘       │
│           │              │              │                        │
│           v              v              v                        │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐           │
│  │   Domain A   │ │   Domain B   │ │   Domain C   │           │
│  │   (Sales)    │ │  (Marketing) │ │   (Finance)  │           │
│  │              │ │              │ │              │           │
│  │ ┌──────────┐ │ │ ┌──────────┐ │ │ ┌──────────┐ │           │
│  │ │  Data    │ │ │ │  Data    │ │ │ │  Data    │ │           │
│  │ │  Product │ │ │ │  Product │ │ │ │  Product │ │           │
│  │ └──────────┘ │ │ └──────────┘ │ │ └──────────┘ │           │
│  │              │ │              │ │              │           │
│  │ ┌──────────┐ │ │ ┌──────────┐ │ │ ┌──────────┐ │           │
│  │ │  Data    │ │ │ │  Data    │ │ │ │  Data    │ │           │
│  │ │  Owner   │ │ │ │  Owner   │ │ │ │  Owner   │ │           │
│  │ └──────────┘ │ │ └──────────┘ │ │ └──────────┘ │           │
│  └──────────────┘ └──────────────┘ └──────────────┘           │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

### Four Principles

1. **Domain Ownership**: Each domain owns its data
2. **Data as a Product**: Data is treated as a product
3. **Self-serve Platform**: Platform enables domain independence
4. **Federated Governance**: Global standards with local flexibility

### Implementation

```python
# Data Product Example

class DataProduct:
    def __init__(self, domain, name):
        self.domain = domain
        self.name = name
        self.sla = None
        self.schema = None
        self.owners = []

    def publish(self):
        """Publish data product."""
        # Register in data catalog
        # Set up SLA monitoring
        # Enable discovery
        pass

    def discover(self):
        """Make data discoverable."""
        # Add to catalog with metadata
        # Provide sample data
        # Document schema and quality
        pass

    def access(self, query):
        """Provide access to data."""
        # Validate permissions
        # Execute query
        # Return results
        pass

    def monitor(self):
        """Monitor data product health."""
        # Track usage
        # Monitor quality
        # Alert on SLA violations
        pass


class DataCatalog:
    def __init__(self):
        self.products = {}

    def register(self, product):
        """Register data product."""
        self.products[product.name] = product

    def discover(self, filters=None):
        """Discover data products."""
        results = list(self.products.values())
        if filters:
            results = [p for p in results if self.matches(p, filters)]
        return results

    def matches(self, product, filters):
        """Check if product matches filters."""
        for key, value in filters.items():
            if getattr(product, key, None) != value:
                return False
        return True
```

---

## 5. Real-time Analytics Architecture

### Overview

Real-time Analytics Architecture enables immediate insights from streaming data.

```
┌─────────────────────────────────────────────────────────────────┐
│                Real-time Analytics Architecture                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  [Data Sources]                                                  │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐           │
│  │  Web    │  │ Mobile  │  │  IoT    │  │  APIs  │           │
│  └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘           │
│       │            │            │            │                   │
│       v            v            v            v                   │
│  ┌─────────────────────────────────────────────────┐            │
│  │              Stream Processing                   │            │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐        │            │
│  │  │  Kafka  │  │  Flink  │  │  Redis  │        │            │
│  │  │         │  │         │  │ (Cache) │        │            │
│  │  └─────────┘  └─────────┘  └─────────┘        │            │
│  └─────────────────────────────────────────────────┘            │
│                          │                                       │
│              ┌───────────┴───────────┐                          │
│              v                       v                          │
│  ┌─────────────────┐     ┌─────────────────┐                  │
│  │  Real-time      │     │  Historical     │                  │
│  │  Aggregation    │     │  Storage        │                  │
│  │  (Flink)        │     │  (ClickHouse)   │                  │
│  └────────┬────────┘     └────────┬────────┘                  │
│           │                        │                            │
│           v                        v                            │
│  ┌─────────────────┐     ┌─────────────────┐                  │
│  │  Dashboard      │     │  BI Tools       │                  │
│  │  (Grafana)      │     │  (Tableau)      │                  │
│  └─────────────────┘     └─────────────────┘                  │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

### Implementation

```python
# Real-time Analytics Implementation

class RealTimeAnalytics:
    def __init__(self):
        self.kafka_consumer = KafkaConsumer('events')
        self.flink_processor = FlinkProcessor()
        self.redis_cache = RedisCache()
        self.clickhouse = ClickHouseClient()

    def process_stream(self):
        """Process streaming events."""
        for event in self.kafka_consumer:
            # Process event
            result = self.flink_processor.process(event)

            # Update real-time aggregation
            self.redis_cache.update_aggregation(result)

            # Store for historical analysis
            self.clickhouse.insert(result)

    def get_real_time_metrics(self, metric_name):
        """Get real-time metrics from cache."""
        return self.redis_cache.get(metric_name)

    def get_historical_metrics(self, metric_name, start_date, end_date):
        """Get historical metrics from ClickHouse."""
        query = f"""
        SELECT
            toStartOfHour(timestamp) as hour,
            avg(value) as avg_value,
            count(*) as count
        FROM metrics
        WHERE metric_name = '{metric_name}'
        AND timestamp BETWEEN '{start_date}' AND '{end_date}'
        GROUP BY hour
        ORDER BY hour
        """
        return self.clickhouse.execute(query)
```

---

## Architecture Selection Guide

### Decision Matrix

| Pattern | Complexity | Latency | Cost | Best For |
|---------|------------|---------|------|----------|
| Lambda | High | Low | High | Mixed workloads |
| Kappa | Medium | Low | Medium | Stream-first |
| Data Lake | Medium | Variable | Low | Storage-centric |
| Data Mesh | High | Variable | High | Large organizations |
| Real-time | Medium | Very Low | High | Analytics |

### When to Use Each

**Lambda Architecture:**
- Need both batch and real-time
- Existing batch systems
- Complex transformations

**Kappa Architecture:**
- Stream-first approach
- Simplified operations
- Event-driven systems

**Data Lake:**
- All data types
- Cost-effective storage
- Flexibility required

**Data Mesh:**
- Large organizations
- Multiple domains
- Decentralized ownership

**Real-time Analytics:**
- Low-latency requirements
- Live dashboards
- Operational analytics

---

## Summary

Key points:

1. **Lambda** combines batch and streaming for comprehensive views
2. **Kappa** simplifies by using only streaming
3. **Data Lake** provides flexible, cost-effective storage
4. **Data Mesh** enables domain-driven, decentralized data management
5. **Real-time Analytics** enables immediate insights from streaming data
6. **Choose based on requirements** - No single pattern fits all use cases
