# Hadoop Ecosystem Guide

This document covers the Hadoop ecosystem and its components for big data processing.

## What is Hadoop?

Apache Hadoop is an open-source framework for distributed storage and processing of large datasets across clusters of computers.

## Core Components

### 1. Hadoop Distributed File System (HDFS)
Distributed file system for storing large files across multiple machines.

**Key Features:**
- **Block Storage**: Files split into 128MB blocks
- **Replication**: Default 3x replication for fault tolerance
- **Write-Once-Read-Many**: Optimized for batch processing

**HDFS Architecture:**
```
┌─────────────────┐
│     Client      │
└────────┬────────┘
         │
┌────────▼────────┐
│   NameNode      │  (Master - metadata)
│   (1 per cluster)│
└────────┬────────┘
         │
┌────────▼────────┐
│   DataNodes     │  (Slaves - actual data)
│   (Many nodes)  │
└─────────────────┘
```

### 2. MapReduce
Programming model for processing large datasets in parallel.

**Map Phase:**
```python
def mapper(document):
    for word in document.split():
        yield (word, 1)
```

**Reduce Phase:**
```python
def reducer(word, counts):
    yield (word, sum(counts))
```

### 3. YARN (Yet Another Resource Negotiator)
Resource management layer for scheduling and managing cluster resources.

**Components:**
- **ResourceManager**: Master daemon
- **NodeManager**: Per-node agent
- **ApplicationMaster**: Per-application process

## Hadoop Ecosystem Tools

### Data Processing
| Tool | Purpose | Use Case |
|------|---------|----------|
| **MapReduce** | Batch processing | Large-scale data processing |
| **Spark** | In-memory processing | Fast analytics, ML |
| **Flink** | Stream processing | Real-time analytics |
| **Hive** | SQL interface | Data warehousing |
| **Pig** | Scripting language | ETL pipelines |

### Data Storage
| Tool | Purpose | Use Case |
|------|---------|----------|
| **HBase** | NoSQL database | Random read/write |
| **Cassandra** | Distributed database | High availability |
| **Kudu** | Columnar storage | Fast analytics |
| **Kafka** | Message queue | Event streaming |

### Data Management
| Tool | Purpose | Use Case |
|------|---------|----------|
| **ZooKeeper** | Coordination | Cluster management |
| **Oozie** | Workflow scheduler | Job orchestration |
| **Airflow** | Workflow scheduler | Complex pipelines |
| **NiFi** | Data flow | Data integration |

## HDFS Operations

### Basic Commands
```bash
# List files
hdfs dfs -ls /user/hadoop

# Copy file to HDFS
hdfs dfs -put localfile.txt /user/hadoop/

# Copy file from HDFS
hdfs dfs -get /user/hadoop/remotefile.txt .

# View file contents
hdfs dfs -cat /user/hadoop/file.txt

# Create directory
hdfs dfs -mkdir /user/hadoop/newdir

# Remove file
hdfs dfs -rm /user/hadoop/file.txt

# Check disk usage
hdfs dfs -du -h /user/hadoop/
```

### File Operations
```bash
# Check file size
hdfs dfs -stat %s /user/hadoop/file.txt

# Copy files within HDFS
hdfs dfs -cp /user/hadoop/source.txt /user/hadoop/dest.txt

# Move files
hdfs dfs -mv /user/hadoop/source.txt /user/hadoop/dest.txt

# Change permissions
hdfs dfs -chmod 755 /user/hadoop/file.txt

# Change owner
hdfs dfs -chown hadoop:hadoop /user/hadoop/file.txt
```

## MapReduce Programming

### Java MapReduce Example
```java
public class WordCount {
    
    public static class TokenizerMapper 
        extends Mapper<Object, Text, Text, IntWritable> {
        
        private final static IntWritable one = new IntWritable(1);
        private Text word = new Text();
        
        public void map(Object key, Text value, Context context) 
            throws IOException, InterruptedException {
            StringTokenizer itr = new StringTokenizer(value.toString());
            while (itr.hasMoreTokens()) {
                word.set(itr.nextToken());
                context.write(word, one);
            }
        }
    }
    
    public static class IntSumReducer 
        extends Reducer<Text, IntWritable, Text, IntWritable> {
        
        private IntWritable result = new IntWritable();
        
        public void reduce(Text key, Iterable<IntWritable> values, Context context) 
            throws IOException, InterruptedException {
            int sum = 0;
            for (IntWritable val : values) {
                sum += val.get();
            }
            result.set(sum);
            context.write(key, result);
        }
    }
    
    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf, "word count");
        job.setJarByClass(WordCount.class);
        job.setMapperClass(TokenizerMapper.class);
        job.setCombinerClass(IntSumReducer.class);
        job.setReducerClass(IntSumReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}
```

### Python MapReduce Example (Hadoop Streaming)
```python
# Mapper
#!/usr/bin/env python
import sys

for line in sys.stdin:
    line = line.strip()
    words = line.split()
    for word in words:
        print(f'{word}\t1')

# Reducer
#!/usr/bin/env python
import sys
from collections import defaultdict

word_counts = defaultdict(int)

for line in sys.stdin:
    line = line.strip()
    word, count = line.split('\t')
    word_counts[word] += int(count)

for word, count in word_counts.items():
    print(f'{word}\t{count}')
```

## Apache Hive

### Creating Tables
```sql
-- Create external table
CREATE EXTERNAL TABLE users (
    id INT,
    name STRING,
    email STRING,
    age INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/hadoop/data/users';

-- Create managed table
CREATE TABLE user_stats (
    age_group STRING,
    user_count BIGINT
)
STORED AS ORC;
```

### Querying Data
```sql
-- Simple query
SELECT * FROM users WHERE age > 25;

-- Aggregation
SELECT age_group, COUNT(*) as user_count
FROM (
    SELECT CASE 
        WHEN age < 25 THEN 'young'
        WHEN age < 40 THEN 'middle'
        ELSE 'senior'
    END as age_group
    FROM users
) t
GROUP BY age_group;

-- Join tables
SELECT u.name, o.total_amount
FROM users u
JOIN orders o ON u.id = o.user_id;
```

### Hive Optimization
```sql
-- Partitioning
CREATE TABLE orders (
    id INT,
    user_id INT,
    amount DOUBLE
)
PARTITIONED BY (year INT, month INT)
STORED AS ORC;

-- Bucketing
CREATE TABLE users (
    id INT,
    name STRING,
    email STRING
)
CLUSTERED BY (id) INTO 256 BUCKETS
STORED AS ORC;

-- Enable vectorization
SET hive.vectorized.execution.enabled = true;
SET hive.vectorized.execution.reduce.enabled = true;
```

## Apache Spark on Hadoop

### Spark with HDFS
```python
from pyspark.sql import SparkSession

# Initialize Spark with Hadoop
spark = SparkSession.builder \
    .appName("HDFS Example") \
    .config("spark.hadoop.fs.defaultFS", "hdfs://namenode:8020") \
    .getOrCreate()

# Read from HDFS
df = spark.read.csv("hdfs:///user/hadoop/data/file.csv", header=True)

# Write to HDFS
df.write.parquet("hdfs:///user/hadoop/output/")
```

### Spark SQL with Hive
```python
# Enable Hive support
spark = SparkSession.builder \
    .appName("Spark Hive Example") \
    .enableHiveSupport() \
    .getOrCreate()

# Query Hive tables
spark.sql("SELECT * FROM mydb.users WHERE age > 25").show()

# Write to Hive table
df.write.saveAsTable("mydb.new_table")
```

## Cluster Management

### Hadoop Configuration
```xml
<!-- core-site.xml -->
<property>
    <name>fs.defaultFS</name>
    <value>hdfs://namenode:8020</value>
</property>

<!-- hdfs-site.xml -->
<property>
    <name>dfs.replication</name>
    <value>3</value>
</property>

<property>
    <name>dfs.blocksize</name>
    <value>134217728</value> <!-- 128MB -->
</property>

<!-- yarn-site.xml -->
<property>
    <name>yarn.nodemanager.resource.memory-mb</name>
    <value>8192</value>
</property>
```

### Monitoring
```bash
# Check HDFS status
hdfs dfsadmin -report

# Check NameNode status
hdfs haadmin -getServiceState nn1

# Check DataNode status
hdfs dfsadmin -printTopology

# YARN status
yarn node -list
yarn application -list
```

## Best Practices

### Data Storage
1. **Use appropriate file formats**: ORC/Parquet for analytics
2. **Partition data**: By date, category, etc.
3. **Compress data**: Snappy, Gzip, LZO
4. **Optimize block size**: Match your workload

### Performance Tuning
1. **Use combiners**: Reduce data transfer in MapReduce
2. **Tune memory settings**: For MapReduce and YARN
3. **Use data locality**: Process data where it's stored
4. **Avoid small files**: Use HAR or sequence files

### Security
1. **Enable Kerberos**: Authentication
2. **Use Sentry/Ranger**: Authorization
3. **Enable encryption**: At rest and in transit
4. **Audit access**: Log all data access

## Common Use Cases

### Data Warehousing
- Store structured data in Hive
- Run analytical queries
- Generate reports

### Log Processing
- Collect logs in HDFS
- Process with Spark/MapReduce
- Analyze patterns

### Machine Learning
- Store training data in HDFS
- Use Spark MLlib for ML
- Deploy models

## See Also

- [[bigdata-guide]]
- [[bigdata-technologies]]
- [[bigdata-architecture]]
- [[bigdata-interview-questions]]
