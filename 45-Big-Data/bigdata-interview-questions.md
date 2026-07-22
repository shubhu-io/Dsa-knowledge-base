# Big Data Interview Questions

## Overview

This guide covers common big data interview questions, from fundamentals to advanced topics, with detailed answers and examples.

## Question Categories

```
Big Data Interview Topics
+------------------------------------------------------------------+
|                                                                    |
|  Fundamentals     |  Hadoop, MapReduce, HDFS                     |
|                                                                    |
|  Apache Spark     |  RDDs, DataFrames, Optimization              |
|                                                                    |
|  Streaming        |  Kafka, Flink, Real-time Processing          |
|                                                                    |
|  Data Modeling     |  Data Lakes, Warehouses, Schemas            |
|                                                                    |
|  Architecture     |  Lambda, Kappa, Data Mesh                    |
|                                                                    |
|  Optimization     |  Performance Tuning, Scaling                 |
|                                                                    |
+------------------------------------------------------------------+
```

---

## Fundamentals

### Q1: What is Big Data?

**Answer:**
Big Data refers to datasets that are too large or complex to be processed by traditional data processing applications. It is characterized by the 5 Vs:

- **Volume**: Terabytes to petabytes of data
- **Velocity**: High-speed data generation (real-time or near real-time)
- **Variety**: Structured, semi-structured, and unstructured data
- **Veracity**: Data quality and trustworthiness
- **Value**: Business insights that can be extracted

### Q2: Explain HDFS and its architecture

**Answer:**
HDFS (Hadoop Distributed File System) is a distributed file system designed to run on commodity hardware.

```
HDFS Architecture:
- NameNode: Manages metadata and file system namespace
- DataNodes: Store actual data blocks
- Block Size: 128MB (default)
- Replication Factor: 3 (default)
```

```bash
# HDFS commands
hdfs dfs -put file.csv /data/
hdfs dfs -get /data/file.csv localfile.csv
hdfs dfs -ls /data/
```

### Q3: What is MapReduce?

**Answer:**
MapReduce is a programming model for processing large datasets in parallel across a Hadoop cluster.

```
MapReduce Flow:
1. Map Phase: Split input and process in parallel
2. Shuffle Phase: Group by key
3. Reduce Phase: Aggregate results
```

```python
# Word Count Example
def mapper(document):
    for word in document.split():
        yield (word.lower(), 1)

def reducer(word, counts):
    yield (word, sum(counts))
```

### Q4: Difference between HDFS and S3?

**Answer:**

| Feature | HDFS | S3 |
|---------|------|-----|
| Type | Distributed File System | Object Storage |
| Access | Block-level | Object-level |
| Consistency | Strong | Eventual |
| Cost | Hardware + maintenance | Pay-per-use |
| Scalability | Limited by cluster | Virtually unlimited |
| Use Case | Hadoop workloads | General storage |

---

## Apache Spark

### Q5: What is Spark and why is it faster than MapReduce?

**Answer:**
Apache Spark is a unified analytics engine for large-scale data processing.

**Speed Factors:**
1. **In-memory processing**: Keeps data in memory between operations
2. **Lazy evaluation**: Optimizes execution plan before running
3. **DAG execution**: Reduces disk I/O
4. **Caching**: Persists intermediate results

```
MapReduce: Read -> Map -> Write -> Read -> Reduce -> Write
Spark: Read -> Map -> Reduce -> Write (in-memory pipeline)
```

### Q6: Explain RDD, DataFrame, and Dataset

**Answer:**

| Feature | RDD | DataFrame | Dataset |
|---------|-----|-----------|---------|
| Type Safety | Yes | No | Yes |
| Optimization | None | Catalyst | Catalyst |
| API | Functional | SQL-like | SQL-like |
| Language | Scala/Python | All | Scala/Java |
| Use Case | Low-level | Analytics | Type-safe analytics |

```python
# RDD
rdd = sc.parallelize([1, 2, 3, 4])
result = rdd.map(lambda x: x * 2).filter(lambda x: x > 4)

# DataFrame
df = spark.read.parquet("data.parquet")
result = df.filter(df.age > 30).groupBy("department").count()
```

### Q7: What is partitioning in Spark?

**Answer:**
Partitioning determines how data is distributed across cluster nodes.

```python
# Repartition (shuffle)
df = df.repartition(100, "key")

# Coalesce (no shuffle, reduce partitions)
df = df.coalesce(10)

# Partition by column
df.write.partitionBy("year", "month").parquet("output/")
```

**Best Practices:**
- Aim for 128MB-1GB per partition
- Use partitioning for frequently filtered columns
- Avoid small files (small partition problem)

### Q8: Explain Spark Shuffle

**Answer:**
Shuffle is the process of redistributing data across partitions, typically during wide transformations.

```
Wide Transformations (cause shuffle):
- groupByKey / reduceByKey
- join
- distinct
- repartition

Narrow Transformations (no shuffle):
- map / flatMap
- filter
- union
```

**Optimization:**
```python
# Use reduceByKey instead of groupByKey
rdd.reduceByKey(lambda a, b: a + b)  # Better
rdd.groupByKey().mapValues(sum)      # Worse

# Broadcast small datasets for joins
from pyspark.sql.functions import broadcast
result = large_df.join(broadcast(small_df), "key")
```

---

## Streaming

### Q9: Explain Apache Kafka architecture

**Answer:**
Kafka is a distributed event streaming platform.

```
Kafka Components:
- Broker: Server that stores and serves data
- Topic: Logical channel for messages
- Partition: Physical division of a topic
- Consumer Group: Set of consumers sharing work
- ZooKeeper: Cluster coordination (legacy)
```

```python
# Producer
producer.send('topic', key='key', value='value')

# Consumer
consumer = KafkaConsumer('topic', group_id='group')
for message in consumer:
    process(message.value)
```

### Q10: Difference between Kafka and RabbitMQ?

**Answer:**

| Feature | Kafka | RabbitMQ |
|---------|-------|----------|
| Type | Event Streaming | Message Queue |
| Retention | Configurable | Until consumed |
| Order | Within partition | Queue-level |
| Throughput | Very high | Medium |
| Use Case | Event sourcing | Task queues |

### Q11: What is exactly-once semantics?

**Answer:**
Exactly-once semantics ensures each message is processed exactly once, despite failures.

**Implementation:**
```python
# Kafka Transactions
producer = KafkaProducer(enable_idempotence=True)

with producer.transaction():
    producer.send('topic', value='message')
    producer.send_offsets_to_transaction(offsets, group_id)
```

**Flink Checkpointing:**
```java
env.enableCheckpointing(5000);
env.getCheckpointConfig().setCheckpointingMode(CheckpointingMode.EXACTLY_ONCE);
```

---

## Data Modeling

### Q12: Data Lake vs Data Warehouse?

**Answer:**

| Aspect | Data Lake | Data Warehouse |
|--------|-----------|----------------|
| Data | All types | Structured |
| Schema | Schema-on-read | Schema-on-write |
| Users | Engineers | Analysts |
| Cost | Low | High |
| Flexibility | High | Low |
| Performance | Variable | Optimized |

### Q13: What is a Star Schema?

**Answer:**
Star Schema is a dimensional modeling technique with a central fact table surrounded by dimension tables.

```sql
-- Fact Table
CREATE TABLE fact_sales (
    sale_id INT,
    date_key INT,
    product_key INT,
    customer_key INT,
    quantity INT,
    amount DECIMAL(10,2)
);

-- Dimension Tables
CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    date DATE,
    month VARCHAR(20),
    year INT
);
```

### Q14: Explain SCD (Slowly Changing Dimensions)

**Answer:**
SCD handles changes in dimension attributes over time.

```
Type 1: Overwrite (no history)
Type 2: Add new row (full history)
Type 3: Add new column (limited history)
```

```sql
-- SCD Type 2 Example
UPDATE dim_customer
SET end_date = CURRENT_DATE, is_current = FALSE
WHERE customer_id = 123 AND is_current = TRUE;

INSERT INTO dim_customer (customer_id, name, start_date, end_date, is_current)
VALUES (123, 'New Name', CURRENT_DATE, NULL, TRUE);
```

---

## Architecture

### Q15: Lambda vs Kappa Architecture?

**Answer:**

| Aspect | Lambda | Kappa |
|--------|--------|-------|
| Layers | Batch + Speed | Streaming only |
| Complexity | High | Medium |
| Codebases | Two | One |
| Latency | Low | Low |
| Use Case | Mixed workloads | Stream-first |

### Q16: What is Data Mesh?

**Answer:**
Data Mesh is a decentralized, domain-oriented approach to data architecture.

**Four Principles:**
1. Domain Ownership
2. Data as a Product
3. Self-serve Platform
4. Federated Governance

---

## Optimization

### Q17: How to optimize Spark jobs?

**Answer:**

```python
# 1. Avoid shuffle
df.reduceByKey(lambda a, b: a + b)  # Better than groupByKey

# 2. Cache frequently used data
df.cache()
df.count()  # Materialize cache

# 3. Use broadcast joins for small tables
from pyspark.sql.functions import broadcast
large_df.join(broadcast(small_df), "key")

# 4. Tune partition count
spark.conf.set("spark.sql.shuffle.partitions", "200")

# 5. Use efficient file formats
df.write.parquet("output/", compression="snappy")
```

### Q18: How to handle data skew?

**Answer:**
Data skew occurs when some partitions have significantly more data.

**Solutions:**
1. **Salting**: Add random prefix to keys
2. **Broadcast joins**: Avoid shuffle for small tables
3. **Custom partitioning**: Distribute data evenly

```python
# Salting example
import random
salt = random.randint(0, 9)
df.withColumn("salted_key", concat(col("key"), lit(f"_{salt}")))
```

### Q19: Explain caching strategies

**Answer:**

```python
# Cache levels
from pyspark import StorageLevel

df.persist(StorageLevel.MEMORY_ONLY)      # Memory only
df.persist(StorageLevel.MEMORY_AND_DISK)  # Memory + disk
df.persist(StorageLevel.DISK_ONLY)        # Disk only

# Unpersist when done
df.unpersist()
```

---

## Coding Questions

### Q20: Write a word count program in Spark

**Answer:**
```python
from pyspark.sql import SparkSession
from pyspark.sql.functions import *

spark = SparkSession.builder.appName("WordCount").getOrCreate()

# Read text file
text_df = spark.read.text("input.txt")

# Word count
word_counts = text_df \
    .select(explode(split(col("value"), " ")).alias("word")) \
    .groupBy("word") \
    .count() \
    .orderBy(col("count").desc())

word_counts.show()
```

### Q21: Find the top N records per group

**Answer:**
```python
from pyspark.sql.window import Window
from pyspark.sql.functions import row_number, rank

windowSpec = Window.partitionBy("department").orderBy(col("salary").desc())

df.withColumn("rank", rank().over(windowSpec)) \
    .filter(col("rank") <= 5) \
    .show()
```

### Q22: Handle late arriving data in streaming

**Answer:**
```python
# Flink watermarking
data_stream \
    .assign_timestamps_and_watermarks(
        WatermarkStrategy.for_bounded_out_of_orderness(Duration.of_seconds(5))
    ) \
    .key_by(lambda event: event.key) \
    .window(TumblingEventTimeWindows.of(Time.minutes(5))) \
    .allowed_lateness(Time.minutes(1)) \
    .side_output_late_data(late_output_tag) \
    .process(MyWindowFunction)
```

---

## System Design

### Q23: Design a real-time analytics system

**Answer:**
```
Architecture:
1. Data Sources → Kafka (ingestion)
2. Kafka → Flink (processing)
3. Flink → Redis (real-time aggregation)
4. Flink → ClickHouse (historical storage)
5. Redis/ClickHouse → Grafana (visualization)
```

### Q24: Design a data pipeline for E-commerce

**Answer:**
```
Components:
1. CDC from MySQL → Debezium → Kafka
2. Kafka → Spark Streaming (enrichment)
3. Spark → Delta Lake (storage)
4. Delta Lake → dbt (transformation)
5. dbt → Snowflake (warehouse)
6. Snowflake → Tableau (analytics)
```

---

## Behavioral Questions

### Q25: Describe a challenging big data problem you solved

**Framework:**
1. **Situation**: Context and requirements
2. **Task**: Specific challenge
3. **Action**: Your approach and tools
4. **Result**: Outcome and learnings

### Q26: How do you ensure data quality?

**Answer:**
1. **Validation**: Great Expectations, dbt tests
2. **Monitoring**: Data quality metrics, alerts
3. **Testing**: Unit tests for transformations
4. **Documentation**: Data contracts, schemas
5. **Governance**: Access control, audit logs

---

## Quick Reference

### Key Formulas

```
HDFS Storage: Data Size × Replication Factor
Spark Partitions: Total Data / Target Partition Size
Kafka Partitions: Throughput Required / Throughput per Partition
```

### Common Commands

```bash
# HDFS
hdfs dfs -put /get /ls /cat /rm

# Spark
spark-submit --master yarn --executor-memory 8g

# Kafka
kafka-topics.sh --create --topic my-topic --partitions 3
```

---

## Preparation Tips

1. **Practice coding**: LeetCode, HackerRank for algorithms
2. **Build projects**: End-to-end pipelines
3. **Understand tradeoffs**: When to use which technology
4. **Know the ecosystem**: Hadoop, Spark, Kafka, Flink
5. **System design**: Practice designing large-scale systems
6. **Behavioral**: Prepare STAR method answers
