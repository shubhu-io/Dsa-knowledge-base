# Apache Spark for Data Engineering

This document covers using Apache Spark for large-scale data processing.

## What is Apache Spark?

Apache Spark is a unified analytics engine for large-scale data processing. It provides an interface for programming entire clusters with implicit data parallelism and fault tolerance.

## Key Features

### Core Features
- **Speed**: In-memory computing for fast processing
- **Ease of Use**: High-level APIs in Python, Scala, Java, SQL
- **Generality**: Batch processing, streaming, ML, graph processing
- **Fault Tolerance**: Automatic recovery from failures

### Components
- **Spark Core**: Base engine for large-scale data processing
- **Spark SQL**: Structured data processing
- **Spark Streaming**: Real-time stream processing
- **MLlib**: Machine learning library
- **GraphX**: Graph processing

## Spark Architecture

### Cluster Components
1. **Driver**: Main program that creates SparkContext
2. **Executors**: Worker nodes that execute tasks
3. **Cluster Manager**: Allocates resources (YARN, Mesos, Kubernetes)

### Data Abstractions
- **RDD**: Resilient Distributed Dataset (low-level)
- **DataFrame**: Distributed collection of data (SQL-like)
- **Dataset**: Type-safe DataFrame (Scala/Java)

## Basic Operations

### Creating SparkSession
```python
from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("DataEngineering") \
    .config("spark.some.config.option", "some-value") \
    .getOrCreate()
```

### Reading Data
```python
# Read CSV
df = spark.read.csv("data.csv", header=True, inferSchema=True)

# Read JSON
df = spark.read.json("data.json")

# Read Parquet
df = spark.read.parquet("data.parquet")

# Read from database
df = spark.read.format("jdbc") \
    .option("url", "jdbc:postgresql://localhost:5432/mydb") \
    .option("dbtable", "users") \
    .option("user", "postgres") \
    .option("password", "password") \
    .load()
```

### Basic Transformations
```python
# Select columns
df.select("name", "age").show()

# Filter rows
df.filter(df.age > 25).show()

# Add new column
df.withColumn("age_plus_10", df.age + 10).show()

# Rename column
df.withColumnRenamed("age", "years").show()

# Drop column
df.drop("age").show()
```

### Aggregations
```python
from pyspark.sql.functions import col, avg, sum, count

# Group by and aggregate
df.groupBy("department") \
  .agg(
      avg("salary").alias("avg_salary"),
      count("id").alias("employee_count")
  ) \
  .show()

# Window functions
from pyspark.sql.window import Window
from pyspark.sql.functions import row_number

windowSpec = Window.partitionBy("department").orderBy(col("salary").desc())
df.withColumn("rank", row_number().over(windowSpec)).show()
```

## Data Processing Patterns

### ETL Pipeline
```python
# Extract
raw_df = spark.read.csv("raw_data.csv", header=True)

# Transform
transformed_df = raw_df \
    .filter(col("status").isin("active", "pending")) \
    .withColumn("processed_date", current_date()) \
    .withColumn("amount", col("amount").cast("double")) \
    .dropDuplicates(["id"])

# Load
transformed_df.write \
    .mode("overwrite") \
    .partitionBy("processed_date") \
    .parquet("processed_data/")
```

### Data Quality Checks
```python
from pyspark.sql.functions import col, count, when

# Check for nulls
null_counts = df.select([
    count(when(col(c).isNull(), c)).alias(c) for c in df.columns
])

# Check for duplicates
duplicate_count = df.count() - df.dropDuplicates().count()

# Validate data types
df.schema.fields  # Check column types
```

### Handling Late Data (Streaming)
```python
from pyspark.sql.streaming import StreamingQuery

# Read stream
stream_df = spark.readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", "localhost:9092") \
    .option("subscribe", "topic1") \
    .load()

# Process stream
processed_df = stream_df \
    .selectExpr("CAST(value AS STRING)") \
    .groupBy(window("timestamp", "10 minutes")) \
    .count()

# Write stream
query = processed_df.writeStream \
    .outputMode("update") \
    .format("console") \
    .start()
```

## Performance Optimization

### Partitioning
```python
# Repartition by column
df = df.repartition(100, "department")

# Coalesce to reduce partitions
df = df.coalesce(10)

# Check number of partitions
print(df.rdd.getNumPartitions())
```

### Caching
```python
# Cache DataFrame in memory
df.cache()  # or df.persist()

# Use cache for repeated operations
df.filter(col("status") == "active").count()  # First call
df.filter(col("status") == "active").show()   # Uses cache

# Unpersist when done
df.unpersist()
```

### Broadcast Join
```python
from pyspark.sql.functions import broadcast

# Broadcast small DataFrame for join
result = large_df.join(broadcast(small_df), "key")
```

### File Format Optimization
```python
# Use Parquet for columnar storage
df.write.parquet("output.parquet", compression="snappy")

# Use ORC for Hive-compatible storage
df.write.orc("output.orc")

# Partition output
df.write \
    .partitionBy("year", "month") \
    .parquet("output/")
```

## Spark SQL

### Creating Temp Views
```python
# Create temporary view
df.createOrReplaceTempView("users")

# SQL queries
result = spark.sql("""
    SELECT department, AVG(salary) as avg_salary
    FROM users
    WHERE age > 25
    GROUP BY department
    ORDER BY avg_salary DESC
""")
```

### UDFs (User Defined Functions)
```python
from pyspark.sql.functions import udf
from pyspark.sql.types import StringType

# Define UDF
@udf(returnType=StringType())
def categorize_age(age):
    if age < 25:
        return "Young"
    elif age < 40:
        return "Middle"
    else:
        return "Senior"

# Use UDF
df.withColumn("age_category", categorize_age(df.age)).show()
```

## Real-World Example

### Data Pipeline with Spark
```python
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *

# Initialize Spark
spark = SparkSession.builder \
    .appName("ETL Pipeline") \
    .config("spark.sql.shuffle.partitions", "200") \
    .getOrCreate()

# Extract
raw_data = spark.read \
    .option("header", "true") \
    .csv("s3://data-lake/raw/sales/")

# Validate
valid_data = raw_data.filter(
    col("amount").isNotNull() & 
    (col("amount") > 0) &
    col("date").isNotNull()
)

# Transform
transformed_data = valid_data \
    .withColumn("year", year(col("date"))) \
    .withColumn("month", month(col("date"))) \
    .withColumn("profit", col("amount") - col("cost")) \
    .withColumn("category", 
        when(col("amount") > 1000, "High")
        .when(col("amount") > 100, "Medium")
        .otherwise("Low")
    )

# Aggregate
summary = transformed_data \
    .groupBy("year", "month", "category") \
    .agg(
        sum("amount").alias("total_sales"),
        sum("profit").alias("total_profit"),
        count("id").alias("transaction_count")
    )

# Load
summary.write \
    .mode("overwrite") \
    .partitionBy("year", "month") \
    .parquet("s3://data-lake/processed/sales_summary/")

spark.stop()
```

## Common Pitfalls

### Performance Issues
1. **Too many small files**: Use coalesce or repartition
2. **Skewed data**: Use salting or broadcast joins
3. **Too many shuffle operations**: Minimize shuffles
4. **Not caching**: Cache frequently accessed DataFrames

### Memory Issues
1. **Collecting too much data**: Use take() instead of collect()
2. **Large broadcasts**: Split large broadcast joins
3. **Cartesian joins**: Avoid cross joins

## Best Practices

### Code Organization
1. Use meaningful variable names
2. Comment complex transformations
3. Break code into functions
4. Use configuration files

### Testing
1. Test with small datasets first
2. Validate output schema
3. Check data quality metrics
4. Monitor performance

### Production Deployment
1. Use cluster manager (YARN/Kubernetes)
2. Configure resources properly
3. Set up monitoring and alerting
4. Implement error handling

## See Also

- [[data-engineering-guide]]
- [[data-engineering-tools]]
- [[data-pipelines]]
- [[data-warehouse]]
