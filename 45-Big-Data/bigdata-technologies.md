# Big Data Technologies Overview

## Overview

This guide provides a comprehensive overview of big data technologies, their use cases, and how they fit into the big data ecosystem.

## Technology Landscape

```
Big Data Technology Stack
+------------------------------------------------------------------+
|                                                                    |
|  Orchestration    |  Airflow, Oozie, Luigi, Azkaban              |
|                                                                    |
|  Processing       |  MapReduce, Spark, Flink, Storm              |
|                                                                    |
|  Storage          |  HDFS, S3, GCS, Cassandra, HBase            |
|                                                                    |
|  SQL on Hadoop    |  Hive, Impala, Presto, Drill                 |
|                                                                    |
|  Streaming        |  Kafka, Kinesis, Pulsar, Flink               |
|                                                                    |
|  NoSQL            |  Cassandra, HBase, MongoDB, Redis            |
|                                                                    |
|  Workflow         |  Airflow, Prefect, Dagster                   |
|                                                                    |
+------------------------------------------------------------------+
```

---

## Apache Hadoop Ecosystem

### Core Components

| Component | Purpose | Description |
|-----------|---------|-------------|
| HDFS | Storage | Distributed file system |
| YARN | Resource Management | Job scheduling and cluster management |
| MapReduce | Processing | Batch processing framework |
| Common | Utilities | Shared libraries and tools |

### Hadoop Ecosystem Tools

```
┌─────────────────────────────────────────────────────────────┐
│                 Hadoop Ecosystem                              │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                    HDFS                              │   │
│  │              (Distributed Storage)                   │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                    │
│       ┌──────────────────┼──────────────────┐               │
│       v                  v                  v               │
│  ┌─────────┐       ┌─────────┐       ┌─────────┐         │
│  │  Hive   │       │  HBase  │       │   S3    │         │
│  │ (SQL)   │       │ (NoSQL) │       │(Object) │         │
│  └─────────┘       └─────────┘       └─────────┘         │
│       │                  │                  │               │
│       v                  v                  v               │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                    YARN                              │   │
│  │           (Resource Management)                      │   │
│  └─────────────────────────────────────────────────────┘   │
│       │                  │                  │               │
│       v                  v                  v               │
│  ┌─────────┐       ┌─────────┐       ┌─────────┐         │
│  │  Spark  │       │ MapReduce│      │  Flink  │         │
│  │(Compute)│       │(Batch)  │       │(Stream) │         │
│  └─────────┘       └─────────┘       └─────────┘         │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

### HDFS Commands

```bash
# File operations
hdfs dfs -mkdir /user/data
hdfs dfs -put localfile.csv /user/data/
hdfs dfs -get /user/data/file.csv localcopy.csv
hdfs dfs -ls /user/data/
hdfs dfs -cat /user/data/file.csv
hdfs dfs -rm /user/data/file.csv

# Directory operations
hdfs dfs -mkdir -p /user/data/subdir
hdfs dfs -mv /user/data/file.csv /user/data/subdir/
hdfs dfs -cp /user/data/file.csv /user/data/backup/

# Information
hdfs dfs -du -h /user/data/
hdfs dfs -df -h /
hdfs dfsadmin -report
```

---

## Apache Spark

### Spark Components

```
┌─────────────────────────────────────────────────────────────┐
│                    Spark Ecosystem                            │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                    Spark Core                        │   │
│  │  - RDD (Resilient Distributed Dataset)              │   │
│  │  - Task scheduling                                  │   │
│  │  - Memory management                                │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                    │
│       ┌──────────────────┼──────────────────┐               │
│       v                  v                  v               │
│  ┌─────────┐       ┌─────────┐       ┌─────────┐         │
│  │ Spark   │       │ Spark   │       │ Spark   │         │
│  │  SQL    │       │Streaming│       │  MLlib  │         │
│  │         │       │         │       │         │         │
│  │DataFrame│       │ Structured│     │ Machine │         │
│  │Dataset  │       │ Streaming│      │ Learning│         │
│  └─────────┘       └─────────┘       └─────────┘         │
│                                                               │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                    GraphX                            │   │
│  │              (Graph Processing)                      │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

### Spark Examples

```python
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.ml.feature import VectorAssembler
from pyspark.ml.classification import RandomForestClassifier

spark = SparkSession.builder \
    .appName("SparkExamples") \
    .getOrCreate()

# DataFrame operations
df = spark.read.parquet("s3://bucket/data/")

# Aggregations
result = df.groupBy("category") \
    .agg(
        count("*").alias("count"),
        sum("amount").alias("total"),
        avg("amount").alias("average")
    )

# Window functions
from pyspark.sql.window import Window
windowSpec = Window.partitionBy("category").orderBy("date")
df.withColumn("running_total", sum("amount").over(windowSpec))

# Machine Learning
assembler = VectorAssembler(
    inputCols=["feature1", "feature2", "feature3"],
    outputCol="features"
)
df_ml = assembler.transform(df)

rf = RandomForestClassifier(
    featuresCol="features",
    labelCol="label",
    numTrees=100
)
model = rf.fit(df_ml)
predictions = model.transform(df_ml)
```

---

## Apache Kafka

### Kafka Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Kafka Architecture                         │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                   Brokers                            │   │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐            │   │
│  │  │Broker 1 │  │Broker 2 │  │Broker 3 │            │   │
│  │  │         │  │         │  │         │            │   │
│  │  │Topic A  │  │Topic A  │  │Topic A  │            │   │
│  │  │P0 P1 P2 │  │P1 P2 P3 │  │P2 P3 P0 │            │   │
│  │  │         │  │         │  │         │            │   │
│  │  │Topic B  │  │Topic B  │  │Topic B  │            │   │
│  │  │P0 P1    │  │P1 P2    │  │P2 P0    │            │   │
│  │  └─────────┘  └─────────┘  └─────────┘            │   │
│  └─────────────────────────────────────────────────────┘   │
│           │              │              │                    │
│           v              v              v                    │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐       │
│  │  Producer 1  │ │  Producer 2  │ │  Producer 3  │       │
│  └──────────────┘ └──────────────┘ └──────────────┘       │
│                                                               │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐       │
│  │  Consumer    │ │  Consumer    │ │  Consumer    │       │
│  │  Group 1     │ │  Group 2     │ │  Group 1     │       │
│  └──────────────┘ └──────────────┘ └──────────────┘       │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

### Kafka Examples

```python
from kafka import KafkaProducer, KafkaConsumer
import json

# Producer
producer = KafkaProducer(
    bootstrap_servers=['localhost:9092'],
    value_serializer=lambda v: json.dumps(v).encode('utf-8'),
    key_serializer=lambda k: k.encode('utf-8')
)

# Send message
producer.send('topic-name', key='key1', value={'data': 'value'})
producer.flush()

# Consumer
consumer = KafkaConsumer(
    'topic-name',
    bootstrap_servers=['localhost:9092'],
    group_id='my-group',
    auto_offset_reset='earliest',
    value_deserializer=lambda m: json.loads(m.decode('utf-8'))
)

for message in consumer:
    print(f"Key: {message.key}, Value: {message.value}")
```

---

## Apache Cassandra

### Cassandra Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                 Cassandra Ring Architecture                   │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│                    ┌─────────┐                                │
│                    │ Node 1  │                                │
│                    │ vnodes  │                                │
│                    │ [0-10]  │                                │
│                    └────┬────┘                                │
│           ┌─────────────┼─────────────┐                      │
│           v             v             v                      │
│     ┌─────────┐   ┌─────────┐   ┌─────────┐               │
│     │ Node 2  │   │ Node 3  │   │ Node 4  │               │
│     │ vnodes  │   │ vnodes  │   │ vnodes  │               │
│     │ [11-20] │   │ [21-30] │   │ [31-40] │               │
│     └─────────┘   └─────────┘   └─────────┘               │
│                                                               │
│  Partitioning: Consistent Hashing                            │
│  Replication: Configurable per keyspace                      │
│  Consistency: Tunable (ONE, QUORUM, ALL)                     │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

### CQL Examples

```sql
-- Create keyspace
CREATE KEYSPACE mykeyspace
WITH replication = {
    'class': 'SimpleStrategy',
    'replication_factor': 3
};

-- Create table
CREATE TABLE mykeyspace.users (
    user_id UUID PRIMARY KEY,
    name TEXT,
    email TEXT,
    created_at TIMESTAMP
);

-- Insert data
INSERT INTO mykeyspace.users (user_id, name, email)
VALUES (uuid(), 'John Doe', 'john@example.com');

-- Query data
SELECT * FROM mykeyspace.users WHERE user_id = ?;

-- Create index
CREATE INDEX idx_email ON mykeyspace.users (email);
```

---

## Apache Flink

### Flink Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Flink Architecture                         │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              JobManager (Master)                     │   │
│  │  - Job scheduling                                    │   │
│  │  - Checkpoint coordination                           │   │
│  │  - Failure recovery                                  │   │
│  └─────────────────────────────────────────────────────┘   │
│           │              │              │                    │
│           v              v              v                    │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐       │
│  │ TaskManager  │ │ TaskManager  │ │ TaskManager  │       │
│  │  ┌────────┐  │ │  ┌────────┐  │ │  ┌────────┐  │       │
│  │  │ Task   │  │ │  │ Task   │  │ │  │ Task   │  │       │
│  │  │ Slot 1 │  │ │  │ Slot 1 │  │ │  │ Slot 1 │  │       │
│  │  ├────────┤  │ │  ├────────┤  │ │  ├────────┤  │       │
│  │  │ Task   │  │ │  │ Task   │  │ │  │ Task   │  │       │
│  │  │ Slot 2 │  │ │  │ Slot 2 │  │ │  │ Slot 2 │  │       │
│  │  └────────┘  │ │  └────────┘  │ │  └────────┘  │       │
│  └──────────────┘ └──────────────┘ └──────────────┘       │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

### Flink Example

```java
// Flink Word Count
public class WordCount {
    public static void main(String[] args) throws Exception {
        StreamExecutionEnvironment env =
            StreamExecutionEnvironment.getExecutionEnvironment();

        DataStream<String> text = env.socketTextStream("localhost", 9999);

        DataStream<Tuple2<String, Integer>> counts = text
            .flatMap(new Tokenizer())
            .keyBy(0)
            .sum(1);

        counts.print();
        env.execute("Streaming WordCount");
    }

    public static class Tokenizer
            implements FlatMapFunction<String, Tuple2<String, Integer>> {
        @Override
        public void flatMap(String value, Collector<Tuple2<String, Integer>> out) {
            String[] tokens = value.toLowerCase().split("\\s+");
            for (String token : tokens) {
                if (token.length() > 0) {
                    out.collect(new Tuple2<>(token, 1));
                }
            }
        }
    }
}
```

---

## Apache Hive

### Hive Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Hive Architecture                          │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                    HQL Query                         │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                    │
│                          v                                    │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                    Parser                            │   │
│  │  - Syntax validation                                 │   │
│  │  - Semantic analysis                                 │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                    │
│                          v                                    │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                    Optimizer                          │   │
│  │  - Query optimization                                │   │
│  │  - Partition pruning                                 │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                    │
│                          v                                    │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                    Execution                          │   │
│  │  - MapReduce / Tez / Spark                           │   │
│  │  - Physical plan generation                          │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                    │
│                          v                                    │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                    HDFS / S3                          │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

### Hive Examples

```sql
-- Create table
CREATE TABLE users (
    user_id INT,
    name STRING,
    email STRING,
    created_at TIMESTAMP
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS PARQUET;

-- Load data
LOAD DATA INPATH '/user/data/users.csv' INTO TABLE users;

-- Query
SELECT name, COUNT(*) as cnt
FROM users
GROUP BY name
ORDER BY cnt DESC;

-- Create partitioned table
CREATE TABLE events (
    event_id BIGINT,
    event_type STRING,
    event_date DATE
)
PARTITIONED BY (year INT, month INT)
STORED AS PARQUET;

-- Add partition
ALTER TABLE events ADD PARTITION (year=2024, month=1);
```

---

## Technology Comparison

### Batch Processing

| Feature | MapReduce | Spark | Tez |
|---------|-----------|-------|-----|
| Speed | Slow | Fast | Medium |
| Ease of Use | Difficult | Easy | Medium |
| Memory | Disk-based | In-memory | Disk-based |
| Fault Tolerance | Good | Good | Good |
| Best For | Legacy systems | General use | Hive optimization |

### Stream Processing

| Feature | Storm | Flink | Kafka Streams |
|---------|-------|-------|---------------|
| Latency | Low | Low | Low |
| Throughput | High | High | High |
| State Management | Limited | Excellent | Good |
| Exactly-Once | No | Yes | Yes |
| Ease of Use | Difficult | Medium | Easy |

### NoSQL Databases

| Feature | Cassandra | HBase | MongoDB |
|---------|-----------|-------|---------|
| Data Model | Column-family | Column-family | Document |
| Write Path | Append-only | WAL + MemStore | Journal |
| Read Path | LSM-tree | LSM-tree | B-tree |
| Consistency | Tunable | Strong | Strong |
| Best For | High write throughput | Random read/write | Flexible schema |

---

## Tool Selection Guide

### Use Case Decision Tree

```
What's your primary use case?
│
├── Batch Processing
│   ├── Small data (< 1TB) → Spark
│   ├── Large data (> 1TB) → Spark + HDFS
│   └── Legacy system → MapReduce
│
├── Stream Processing
│   ├── Simple streaming → Kafka Streams
│   ├── Complex event processing → Flink
│   └── Low-latency → Storm
│
├── Storage
│   ├── Structured data → HBase / Cassandra
│   ├── Unstructured data → HDFS / S3
│   └── Key-value → Redis / Cassandra
│
└── SQL Analytics
    ├── Interactive queries → Presto / Impala
    ├── Batch SQL → Hive
    └── Real-time SQL → Spark SQL
```

---

## Summary

Key points:

1. **Hadoop ecosystem** provides the foundation for big data
2. **Spark** is the de facto standard for batch and stream processing
3. **Kafka** is the standard for event streaming
4. **Cassandra/HBase** for NoSQL requirements
5. **Choose based on use case** - No one-size-fits-all solution
6. **Consider managed services** - Cloud offerings reduce operational overhead
