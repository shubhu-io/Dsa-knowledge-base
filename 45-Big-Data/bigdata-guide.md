# Big Data Comprehensive Guide

## Table of Contents

1. [Introduction](#introduction)
2. [Big Data Fundamentals](#big-data-fundamentals)
3. [Distributed Systems](#distributed-systems)
4. [MapReduce Paradigm](#mapreduce-paradigm)
5. [Apache Spark](#apache-spark)
6. [Data Lakes](#data-lakes)
7. [Best Practices](#best-practices)

---

## Introduction

Big Data is characterized by the 5 Vs: Volume, Velocity, Variety, Veracity, and Value. This guide covers the fundamentals of big data processing and analytics.

### Why Big Data Matters

```
Traditional Data Processing:
- Single machine limitations
- Hours to process gigabytes
- Limited scalability

Big Data Processing:
- Distributed across hundreds/thousands of machines
- Process petabytes in minutes
- Near-linear scalability
```

---

## Big Data Fundamentals

### Data Storage Models

```
┌─────────────────────────────────────────────────────────────┐
│                   Data Storage Comparison                     │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  RDBMS:           Row-oriented storage                       │
│  ┌───┬───┬───┐                                             │
│  │ A │ 1 │ X │  Good for: OLTP, point queries              │
│  ├───┼───┼───┤  Bad for: Analytics, aggregations            │
│  │ B │ 2 │ Y │                                             │
│  ├───┼───┼───┤                                             │
│  │ C │ 3 │ Z │                                             │
│  └───┴───┴───┘                                             │
│                                                               │
│  Columnar:        Column-oriented storage                    │
│  ┌───┬───┬───┐                                             │
│  │ A │ B │ C │  Good for: Analytics, aggregations          │
│  ├───┼───┼───┤  Bad for: Point queries, transactions       │
│  │ 1 │ 2 │ 3 │                                             │
│  ├───┼───┼───┤                                             │
│  │ X │ Y │ Z │                                             │
│  └───┴───┴───┘                                             │
│                                                               │
│  Key-Value:       Simple key-value pairs                     │
│  ┌───────┬───────┐                                         │
│  │ key1  │ val1  │  Good for: High throughput, caching     │
│  ├───────┼───────┤  Bad for: Complex queries               │
│  │ key2  │ val2  │                                         │
│  ├───────┼───────┤                                         │
│  │ key3  │ val3  │                                         │
│  └───────┴───────┘                                         │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

### CAP Theorem

```
┌─────────────────────────────────────────────────────────────┐
│                       CAP Theorem                            │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│                    Consistency                                │
│                        /\\                                    │
│                       /  \\                                   │
│                      /    \\                                  │
│                     / CA   \\                                 │
│                    /  (RDBMS)\\                               │
│                   /            \\                              │
│                  /              \\                             │
│   Availability /────────────────\\ Partition                  │
│               /                  \\ Tolerance                 │
│              /    AP              \\                          │
│             /  (Cassandra)         \\                         │
│            /                        \\                        │
│           /           CP             \\                       │
│          /        (HBase)             \\                      │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

- **Consistency**: All nodes see the same data at the same time
- **Availability**: Every request receives a response
- **Partition Tolerance**: System continues despite network failures

---

## Distributed Systems

### HDFS (Hadoop Distributed File System)

```
┌─────────────────────────────────────────────────────────────┐
│                    HDFS Architecture                          │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                  NameNode                            │   │
│  │  - Metadata management                               │   │
│  │  - Block placement                                   │   │
│  │  - Client access                                     │   │
│  └─────────────────────────────────────────────────────┘   │
│           │              │              │                    │
│           v              v              v                    │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐       │
│  │  DataNode 1  │ │  DataNode 2  │ │  DataNode 3  │       │
│  │  ┌────┐┌────┐│ │  ┌────┐┌────┐│ │  ┌────┐┌────┐│       │
│  │  │Blk1││Blk2││ │  │Blk2││Blk3││ │  │Blk3││Blk1││       │
│  │  └────┘└────┘│ │  └────┘└────┘│ │  └────┘└────┘│       │
│  └──────────────┘ └──────────────┘ └──────────────┘       │
│                                                               │
│  Block Size: 128MB (default)                                 │
│  Replication Factor: 3 (default)                             │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

```bash
# HDFS Commands
hdfs dfs -mkdir /user/data
hdfs dfs -put localfile.csv /user/data/
hdfs dfs -ls /user/data/
hdfs dfs -get /user/data/file.csv localfile.csv
hdfs dfs -cat /user/data/file.csv
```

### YARN (Yet Another Resource Negotiator)

```
┌─────────────────────────────────────────────────────────────┐
│                    YARN Architecture                          │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              ResourceManager (RM)                    │   │
│  │  - Scheduler: Allocates resources                    │   │
│  │  - ApplicationsManager: Manages applications         │   │
│  └─────────────────────────────────────────────────────┘   │
│           │              │              │                    │
│           v              v              v                    │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐       │
│  │  NodeManager │ │  NodeManager │ │  NodeManager │       │
│  │  ┌────────┐  │ │  ┌────────┐  │ │  ┌────────┐  │       │
│  │  │Container│  │ │  │Container│  │ │  │Container│  │       │
│  │  │ ┌────┐ │  │ │  │ ┌────┐ │  │ │  │ ┌────┐ │  │       │
│  │  │ │ AM │ │  │ │  │ │ AM │ │  │ │  │ │ AM │ │  │       │
│  │  │ └────┘ │  │ │  │ └────┘ │  │ │  │ └────┘ │  │       │
│  │  └────────┘  │ │  └────────┘  │ │  └────────┘  │       │
│  └──────────────┘ └──────────────┘ └──────────────┘       │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

---

## MapReduce Paradigm

### MapReduce Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    MapReduce Flow                             │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  Input Split 1 ──▶ ┌─────────┐ ──▶ ┌─────────┐            │
│                    │   Map   │     │  Shuffle │            │
│  Input Split 2 ──▶ │  Phase  │     │  & Sort  │            │
│                    └─────────┘     └────┬────┘            │
│  Input Split 3 ──▶ ┌─────────┐         │                   │
│                    │   Map   │         │                   │
│                    │  Phase  │         │                   │
│                    └─────────┘         │                   │
│                                        v                   │
│  ┌─────────────────────────────────────────────────────┐  │
│  │                   Reduce Phase                        │  │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐            │  │
│  │  │Reduce 1 │  │Reduce 2 │  │Reduce 3 │            │  │
│  │  └────┬────┘  └────┬────┘  └────┬────┘            │  │
│  └───────┼────────────┼────────────┼──────────────────┘  │
│          v            v            v                      │
│  ┌─────────────────────────────────────────────────────┐  │
│  │                    Output                            │  │
│  └─────────────────────────────────────────────────────┘  │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

### Word Count Example

```python
# Python MapReduce implementation
from collections import defaultdict
from multiprocessing import Pool

def mapper(document):
    """Map function: emit (word, 1) pairs."""
    word_counts = defaultdict(int)
    for word in document.split():
        word_counts[word.lower()] += 1
    return list(word_counts.items())

def reducer(word_counts):
    """Reduce function: sum counts for each word."""
    total = defaultdict(int)
    for word, count in word_counts:
        total[word] += count
    return total

# Sample data
documents = [
    "Hello world hello",
    "Big data is big",
    "Hello big data"
]

# Map phase
with Pool() as pool:
    mapped = pool.map(mapper, documents)

# Shuffle phase
shuffled = defaultdict(list)
for doc_results in mapped:
    for word, count in doc_results:
        shuffled[word].append((word, count))

# Reduce phase
with Pool() as pool:
    reduced = pool.map(reducer, shuffled.items())

# Combine results
final_counts = defaultdict(int)
for result in reduced:
    for word, count in result.items():
        final_counts[word] += count

print(dict(final_counts))
```

### Hadoop MapReduce (Java)

```java
// Mapper class
public class WordCountMapper extends Mapper<LongWritable, Text, Text, IntWritable> {
    private final static IntWritable one = new IntWritable(1);
    private Text word = new Text();

    public void map(LongWritable key, Text value, Context context)
            throws IOException, InterruptedException {
        String[] tokens = value.toString().split("\\s+");
        for (String token : tokens) {
            word.set(token.toLowerCase());
            context.write(word, one);
        }
    }
}

// Reducer class
public class WordCountReducer extends Reducer<Text, IntWritable, Text, IntWritable> {
    public void reduce(Text key, Iterable<IntWritable> values, Context context)
            throws IOException, InterruptedException {
        int sum = 0;
        for (IntWritable val : values) {
            sum += val.get();
        }
        context.write(key, new IntWritable(sum));
    }
}
```

---

## Apache Spark

### Spark Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Spark Architecture                         │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              Driver Program                         │   │
│  │  ┌─────────────────────────────────────────────┐   │   │
│  │  │              SparkContext                     │   │   │
│  │  └─────────────────────────────────────────────┘   │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                    │
│                          v                                    │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              Cluster Manager                        │   │
│  │  (YARN, Mesos, Kubernetes, Standalone)             │   │
│  └─────────────────────────────────────────────────────┘   │
│           │              │              │                    │
│           v              v              v                    │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐       │
│  │   Executor   │ │   Executor   │ │   Executor   │       │
│  │  ┌────────┐  │ │  ┌────────┐  │ │  ┌────────┐  │       │
│  │  │  Task  │  │ │  │  Task  │  │ │  │  Task  │  │       │
│  │  └────────┘  │ │  └────────┘  │ │  └────────┘  │       │
│  │  ┌────────┐  │ │  ┌────────┐  │ │  ┌────────┐  │       │
│  │  │  Task  │  │ │  │  Task  │  │ │  │  Task  │  │       │
│  │  └────────┘  │ │  └────────┘  │ │  └────────┘  │       │
│  └──────────────┘ └──────────────┘ └──────────────┘       │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

### Spark RDD/DataFrame Operations

```python
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *

spark = SparkSession.builder \
    .appName("SparkExamples") \
    .getOrCreate()

# Create DataFrame
data = [
    ("Alice", 28, "Engineering"),
    ("Bob", 35, "Marketing"),
    ("Charlie", 42, "Engineering"),
    ("Diana", 31, "Marketing")
]
df = spark.createDataFrame(data, ["name", "age", "department"])

# Basic operations
df.show()
df.printSchema()
df.describe().show()

# Transformations
result = df \
    .filter(col("age") > 30) \
    .groupBy("department") \
    .agg(
        count("*").alias("count"),
        avg("age").alias("avg_age"),
        max("age").alias("max_age")
    ) \
    .orderBy(col("count").desc())

result.show()

# SQL operations
df.createOrReplaceTempView("employees")
spark.sql("""
    SELECT department, COUNT(*) as count
    FROM employees
    WHERE age > 30
    GROUP BY department
    ORDER BY count DESC
""").show()
```

### Spark Streaming

```python
from pyspark.sql import SparkSession
from pyspark.sql.functions import *

spark = SparkSession.builder \
    .appName("SparkStreaming") \
    .getOrCreate()

# Read from Kafka
df = spark.readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", "localhost:9092") \
    .option("subscribe", "events") \
    .load()

# Process streaming data
parsed = df.select(
    from_json(col("value").cast("string"), schema).alias("data")
).select("data.*")

# Windowed aggregation
windowed_counts = parsed \
    .withWatermark("timestamp", "10 minutes") \
    .groupBy(
        window("timestamp", "5 minutes"),
        "event_type"
    ) \
    .count()

# Write output
query = windowed_counts.writeStream \
    .outputMode("update") \
    .format("console") \
    .start()

query.awaitTermination()
```

---

## Data Lakes

### Data Lake Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Data Lake Architecture                     │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  [Raw Zone]                                                  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  - Raw, unprocessed data                            │   │
│  │  - Original format preserved                        │   │
│  │  - Schema-on-read                                   │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                    │
│                          v                                    │
│  [Cleaned Zone]                                               │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  - Validated data                                   │   │
│  │  - Schema enforced                                  │   │
│  │  - Duplicates removed                               │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                    │
│                          v                                    │
│  [Curated Zone]                                               │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  - Business-ready data                              │   │
│  │  - Enriched with dimensions                         │   │
│  │  - Optimized for queries                            │   │
│  └─────────────────────────────────────────────────────┘   │
│                          │                                    │
│                          v                                    │
│  [Serving Zone]                                               │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  - Data marts                                       │   │
│  │  - Aggregated views                                 │   │
│  │  - ML feature stores                                │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

### Data Lake vs Data Warehouse vs Data Lakehouse

| Aspect | Data Lake | Data Warehouse | Data Lakehouse |
|--------|-----------|----------------|----------------|
| Data Type | All types | Structured | All types |
| Schema | Schema-on-read | Schema-on-write | Both |
| Users | Data engineers | Analysts | All |
| Cost | Low | High | Medium |
| Performance | Variable | Optimized | Good |
| ACID | No | Yes | Yes |
| Example | S3 | Snowflake | Delta Lake |

---

## Best Practices

### 1. Data Partitioning

```python
# Partition data by date for efficient queries
df.write \
    .partitionBy("year", "month", "day") \
    .parquet("s3://data-lake/events/")

# Query only specific partitions
spark.read.parquet("s3://data-lake/events/year=2024/month=01/")
```

### 2. File Format Optimization

```python
# Use Parquet for analytics
df.write.parquet("data.parquet", compression="snappy")

# Use Delta Lake for ACID transactions
df.write.format("delta").save("data.delta")

# Optimize file sizes (aim for 128MB-1GB per file)
df.coalesce(100).write.parquet("data.parquet")
```

### 3. Caching Strategy

```python
# Cache frequently accessed data
df.cache()  # or df.persist(StorageLevel.MEMORY_AND_DISK)

# Use broadcast for small tables
from pyspark.sql.functions import broadcast
result = large_df.join(broadcast(small_df), "key")

# Cache computed results
result.cache()
result.count()  # Materialize cache
```

### 4. Resource Management

```python
# Configure Spark properly
spark = SparkSession.builder \
    .appName("OptimizedJob") \
    .config("spark.executor.memory", "8g") \
    .config("spark.executor.cores", "4") \
    .config("spark.driver.memory", "4g") \
    .config("spark.sql.shuffle.partitions", "200") \
    .getOrCreate()
```

### 5. Data Quality

```python
# Validate data at ingestion
from pyspark.sql import DataFrame

def validate_dataframe(df: DataFrame, rules: dict) -> bool:
    """Validate DataFrame against rules."""
    for column, rule in rules.items():
        if rule == "not_null":
            assert df.filter(col(column).isNull()).count() == 0
        elif rule == "unique":
            assert df.count() == df.select(column).distinct().count()
    return True
```

---

## Summary

Key takeaways:

1. **Understand the 5 Vs** - Volume, Velocity, Variety, Veracity, Value
2. **Master distributed computing** - HDFS, YARN, MapReduce
3. **Learn Apache Spark** - The de facto standard for big data processing
4. **Design proper data lakes** - Raw, cleaned, curated zones
5. **Optimize for performance** - Partitioning, caching, file formats
6. **Ensure data quality** - Validation, monitoring, governance
