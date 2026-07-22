# Data Pipelines Design and Implementation

## Overview

Data pipelines are automated workflows that move and transform data from source systems to target destinations. This guide covers pipeline architecture, patterns, and implementation.

## Pipeline Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    Data Pipeline Architecture                     │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐  │
│  │  Source  │───▶│ Extract  │───▶│  Stage   │───▶│  Load    │  │
│  │ Systems │    │          │    │          │    │          │  │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘  │
│       │              │               │               │           │
│       v              v               v               v           │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐  │
│  │ Database │    │ Validate │    │ Transform│    │  Target  │  │
│  │ API      │    │ Clean    │    │ Enrich   │    │  System  │  │
│  │ Files    │    │ Dedup    │    │ Aggregate│    │          │  │
│  │ Streams  │    │ Schema   │    │ Join     │    │          │  │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘  │
│                                                                   │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │                    Orchestration Layer                       ││
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐      ││
│  │  │ Airflow │  │ Prefect │  │ Dagster │  │ Custom  │      ││
│  │  └─────────┘  └─────────┘  └─────────┘  └─────────┘      ││
│  └─────────────────────────────────────────────────────────────┘│
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

## Pipeline Patterns

### 1. Batch Processing Pipeline

```python
# batch_pipeline.py
from datetime import datetime, timedelta
import logging

logger = logging.getLogger(__name__)

class BatchPipeline:
    def __init__(self, config):
        self.config = config
        self.extractor = None
        self.transformer = None
        self.loader = None

    def run(self, execution_date=None):
        """Execute batch pipeline."""
        if execution_date is None:
            execution_date = datetime.now().date()

        logger.info(f"Starting batch pipeline for {execution_date}")

        try:
            # Extract
            raw_data = self.extract(execution_date)
            logger.info(f"Extracted {len(raw_data)} records")

            # Validate
            validated_data = self.validate(raw_data)
            logger.info(f"Validated {len(validated_data)} records")

            # Transform
            transformed_data = self.transform(validated_data)
            logger.info(f"Transformed to {len(transformed_data)} records")

            # Load
            self.load(transformed_data)
            logger.info("Pipeline completed successfully")

            return {
                "status": "success",
                "execution_date": execution_date,
                "records_processed": len(transformed_data)
            }

        except Exception as e:
            logger.error(f"Pipeline failed: {e}")
            raise

    def extract(self, execution_date):
        """Extract data from source."""
        # Implementation depends on source
        pass

    def validate(self, data):
        """Validate data quality."""
        # Run validation checks
        pass

    def transform(self, data):
        """Transform data."""
        # Apply transformations
        pass

    def load(self, data):
        """Load data to target."""
        # Write to target system
        pass
```

### 2. Streaming Pipeline

```python
# streaming_pipeline.py
from kafka import KafkaConsumer, KafkaProducer
import json

class StreamingPipeline:
    def __init__(self, config):
        self.consumer = KafkaConsumer(
            config['input_topic'],
            bootstrap_servers=config['bootstrap_servers'],
            value_deserializer=lambda m: json.loads(m.decode('utf-8')),
            group_id=config['consumer_group']
        )

        self.producer = KafkaProducer(
            bootstrap_servers=config['bootstrap_servers'],
            value_serializer=lambda v: json.dumps(v).encode('utf-8')
        )

    def process_stream(self):
        """Process streaming data."""
        for message in self.consumer:
            try:
                # Process message
                processed = self.process_message(message.value)

                # Send to output topic
                self.producer.send(
                    self.config['output_topic'],
                    value=processed
                )

            except Exception as e:
                logger.error(f"Error processing message: {e}")
                # Send to dead letter queue
                self.producer.send(
                    f"{self.config['input_topic']}.dlq",
                    value=message.value
                )

    def process_message(self, message):
        """Process individual message."""
        # Apply transformations
        return {
            "processed_at": datetime.now().isoformat(),
            "data": message
        }
```

### 3. Micro-batch Pipeline

```python
# microbatch_pipeline.py
from pyspark.sql import SparkSession
from pyspark.sql.functions import window, count, sum

class MicroBatchPipeline:
    def __init__(self, config):
        self.spark = SparkSession.builder \
            .appName("MicroBatchPipeline") \
            .getOrCreate()

        self.config = config

    def run_streaming(self):
        """Execute micro-batch streaming."""
        # Read from Kafka
        raw_stream = self.spark.readStream \
            .format("kafka") \
            .option("kafka.bootstrap.servers", self.config['bootstrap_servers']) \
            .option("subscribe", self.config['input_topic']) \
            .load()

        # Process in micro-batches
        processed_stream = raw_stream \
            .selectExpr("CAST(value AS STRING)") \
            .selectExpr("from_json(value, 'schema').*") \
            .withWatermark("event_time", "10 minutes") \
            .groupBy(
                window("event_time", "5 minutes"),
                "category"
            ) \
            .agg(
                count("*").alias("event_count"),
                sum("amount").alias("total_amount")
            )

        # Write to output
        query = processed_stream.writeStream \
            .outputMode("update") \
            .format("console") \
            .trigger(processingTime="30 seconds") \
            .start()

        query.awaitTermination()
```

---

## Pipeline Components

### 1. Extractor

```python
# extractors.py
import pandas as pd
from sqlalchemy import create_engine
import requests

class DatabaseExtractor:
    def __init__(self, connection_string):
        self.engine = create_engine(connection_string)

    def extract_incremental(self, query, watermark_column, last_watermark):
        """Extract new records since last watermark."""
        full_query = f"""
        {query}
        WHERE {watermark_column} > '{last_watermark}'
        """
        return pd.read_sql(full_query, self.engine)

    def extract_full(self, query):
        """Extract all records."""
        return pd.read_sql(query, self.engine)

class APIExtractor:
    def __init__(self, base_url, headers=None):
        self.base_url = base_url
        self.headers = headers or {}

    def extract_paginated(self, endpoint, page_size=100):
        """Extract data with pagination."""
        all_data = []
        page = 1

        while True:
            response = requests.get(
                f"{self.base_url}/{endpoint}",
                params={"page": page, "page_size": page_size},
                headers=self.headers
            )
            data = response.json()

            if not data:
                break

            all_data.extend(data)
            page += 1

        return pd.DataFrame(all_data)

class FileExtractor:
    def __init__(self, base_path):
        self.base_path = base_path

    def extract_csv(self, filename):
        """Extract CSV file."""
        return pd.read_csv(f"{self.base_path}/{filename}")

    def extract_parquet(self, filename):
        """Extract Parquet file."""
        return pd.read_parquet(f"{self.base_path}/{filename}")

    def extract_partitioned(self, pattern, date_range):
        """Extract partitioned files."""
        all_data = []
        for date in date_range:
            filepath = f"{self.base_path}/{pattern.format(date=date)}"
            try:
                df = pd.read_parquet(filepath)
                all_data.append(df)
            except FileNotFoundError:
                continue
        return pd.concat(all_data, ignore_index=True)
```

### 2. Transformer

```python
# transformers.py
import pandas as pd
import numpy as np

class DataTransformer:
    def __init__(self, rules):
        self.rules = rules

    def apply_rules(self, df):
        """Apply transformation rules."""
        for rule in self.rules:
            df = self.apply_rule(df, rule)
        return df

    def apply_rule(self, df, rule):
        """Apply single transformation rule."""
        rule_type = rule['type']

        if rule_type == 'rename':
            df = df.rename(columns=rule['mapping'])
        elif rule_type == 'filter':
            df = df.query(rule['condition'])
        elif rule_type == 'cast':
            df[rule['column']] = df[rule['column']].astype(rule['dtype'])
        elif rule_type == 'fill_na':
            df[rule['column']] = df[rule['column']].fillna(rule['value'])
        elif rule_type == 'deduplicate':
            df = df.drop_duplicates(subset=rule['columns'], keep=rule.get('keep', 'first'))
        elif rule_type == 'aggregate':
            df = df.groupby(rule['group_by']).agg(rule['aggregations']).reset_index()

        return df

    def create_features(self, df, feature_definitions):
        """Create new features."""
        for feature in feature_definitions:
            if feature['type'] == 'derived':
                df[feature['name']] = df.eval(feature['expression'])
            elif feature['type'] == 'temporal':
                df[feature['name']] = pd.to_datetime(df[feature['column']])
                if feature.get('extract') == 'hour':
                    df[feature['name']] = df[feature['name']].dt.hour
                elif feature.get('extract') == 'dayofweek':
                    df[feature['name']] = df[feature['name']].dt.dayofweek
        return df
```

### 3. Loader

```python
# loaders.py
import pandas as pd
from sqlalchemy import create_engine

class DatabaseLoader:
    def __init__(self, connection_string):
        self.engine = create_engine(connection_string)

    def load_full(self, df, table_name):
        """Full load - replace entire table."""
        df.to_sql(table_name, self.engine, if_exists='replace', index=False)

    def load_incremental(self, df, table_name, key_columns):
        """Incremental load - insert new records."""
        # Get existing keys
        existing_query = f"SELECT {', '.join(key_columns)} FROM {table_name}"
        existing_df = pd.read_sql(existing_query, self.engine)

        # Find new records
        new_records = df.merge(
            existing_df,
            on=key_columns,
            how='left',
            indicator=True
        ).query('_merge == "left_only"').drop('_merge', axis=1)

        # Insert new records
        if len(new_records) > 0:
            new_records.to_sql(table_name, self.engine, if_exists='append', index=False)

        return len(new_records)

    def load_upsert(self, df, table_name, key_columns):
        """Upsert - insert or update records."""
        # Implementation depends on database
        # Example for PostgreSQL using ON CONFLICT
        pass

class CloudStorageLoader:
    def __init__(self, bucket_name, prefix):
        self.bucket_name = bucket_name
        self.prefix = prefix

    def load_parquet(self, df, filename, partition_columns=None):
        """Load as partitioned Parquet files."""
        path = f"s3://{self.bucket_name}/{self.prefix}/{filename}"
        df.to_parquet(
            path,
            partition_cols=partition_columns,
            index=False
        )

    def load_csv(self, df, filename):
        """Load as CSV file."""
        path = f"s3://{self.bucket_name}/{self.prefix}/{filename}"
        df.to_csv(path, index=False)
```

---

## Pipeline Orchestration

### Apache Airflow DAG

```python
# dags/etl_pipeline.py
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.amazon.aws.transfers.s3_to_redshift import S3ToRedshiftOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'data_engineering',
    'depends_on_past': False,
    'start_date': datetime(2024, 1, 1),
    'email_on_failure': True,
    'email_on_retry': False,
    'retries': 3,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG(
    'daily_etl_pipeline',
    default_args=default_args,
    schedule_interval='0 2 * * *',
    catchup=False,
    tags=['etl', 'daily']
)

def extract_data(**context):
    """Extract data from source systems."""
    from extractors import DatabaseExtractor

    extractor = DatabaseExtractor('postgresql://user:pass@host/db')
    df = extractor.extract_incremental(
        query="SELECT * FROM orders",
        watermark_column='updated_at',
        last_watermark=context['prev_execution_date_success']
    )

    # Save to staging
    df.to_parquet(f"s3://staging/orders/{context['ds']}/data.parquet")
    return len(df)

def validate_data(**context):
    """Validate extracted data."""
    import pandas as pd

    df = pd.read_parquet(f"s3://staging/orders/{context['ds']}/data.parquet")

    # Run validations
    assert len(df) > 0, "No data extracted"
    assert df['order_id'].is_unique, "Duplicate order IDs"
    assert df['amount'].min() >= 0, "Negative amounts found"

    return True

def transform_data(**context):
    """Transform data."""
    import pandas as pd
    from transformers import DataTransformer

    df = pd.read_parquet(f"s3://staging/orders/{context['ds']}/data.parquet")

    transformer = DataTransformer([
        {'type': 'deduplicate', 'columns': ['order_id']},
        {'type': 'fill_na', 'column': 'discount', 'value': 0},
        {'type': 'cast', 'column': 'amount', 'dtype': 'float64'}
    ])

    transformed_df = transformer.apply_rules(df)

    # Save transformed data
    transformed_df.to_parquet(f"s3://processed/orders/{context['ds']}/data.parquet")
    return len(transformed_df)

def load_data(**context):
    """Load data to data warehouse."""
    # Load to Redshift
    load_task = S3ToRedshiftOperator(
        task_id='load_to_redshift',
        schema='public',
        table='orders',
        s3_bucket='processed',
        s3_key=f"orders/{context['ds']}/data.parquet",
        copy_options=['FORMAT AS PARQUET'],
        dag=dag
    )
    return load_task.execute(context)

# Define tasks
extract = PythonOperator(
    task_id='extract',
    python_callable=extract_data,
    dag=dag
)

validate = PythonOperator(
    task_id='validate',
    python_callable=validate_data,
    dag=dag
)

transform = PythonOperator(
    task_id='transform',
    python_callable=transform_data,
    dag=dag
)

load = PythonOperator(
    task_id='load',
    python_callable=load_data,
    dag=dag
)

# Set dependencies
extract >> validate >> transform >> load
```

---

## Error Handling and Recovery

### Retry Logic

```python
from functools import wraps
import time
import logging

logger = logging.getLogger(__name__)

def retry_on_failure(max_retries=3, delay=1, backoff=2):
    """Decorator for retry logic."""
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            retries = 0
            while retries < max_retries:
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    retries += 1
                    if retries == max_retries:
                        raise
                    wait_time = delay * (backoff ** (retries - 1))
                    logger.warning(f"Retry {retries}/{max_retries} after {wait_time}s: {e}")
                    time.sleep(wait_time)
        return wrapper
    return decorator

# Usage
@retry_on_failure(max_retries=3, delay=1)
def extract_data():
    """Extract data with automatic retry."""
    pass
```

### Dead Letter Queue

```python
class DeadLetterQueue:
    def __init__(self, kafka_producer, topic):
        self.producer = kafka_producer
        self.topic = f"{topic}.dlq"

    def send(self, message, error):
        """Send failed message to DLQ."""
        dlq_message = {
            "original_message": message,
            "error": str(error),
            "timestamp": datetime.now().isoformat(),
            "retry_count": message.get("retry_count", 0) + 1
        }
        self.producer.send(self.topic, value=dlq_message)
```

---

## Monitoring and Alerting

```python
# monitoring.py
from prometheus_client import Counter, Histogram, Gauge
import time

# Metrics
pipeline_runs = Counter('pipeline_runs_total', 'Total pipeline runs', ['pipeline', 'status'])
pipeline_duration = Histogram('pipeline_duration_seconds', 'Pipeline duration', ['pipeline'])
records_processed = Counter('records_processed_total', 'Total records processed', ['pipeline'])
pipeline_errors = Counter('pipeline_errors_total', 'Total pipeline errors', ['pipeline', 'error_type'])

class PipelineMonitor:
    def __init__(self, pipeline_name):
        self.pipeline_name = pipeline_name
        self.start_time = None

    def __enter__(self):
        self.start_time = time.time()
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        duration = time.time() - self.start_time
        pipeline_duration.labels(pipeline=self.pipeline_name).observe(duration)

        if exc_type is None:
            pipeline_runs.labels(pipeline=self.pipeline_name, status='success').inc()
        else:
            pipeline_runs.labels(pipeline=self.pipeline_name, status='failure').inc()
            pipeline_errors.labels(pipeline=self.pipeline_name, error_type=exc_type.__name__).inc()

        return False

# Usage
with PipelineMonitor("daily_etl"):
    run_pipeline()
```

---

## Summary

Key points:

1. **Choose the right pattern** - Batch, streaming, or micro-batch based on requirements
2. **Design for failure** - Implement retry logic, dead letter queues, and idempotency
3. **Monitor everything** - Track pipeline health, duration, and record counts
4. **Use orchestration** - Airflow, Prefect, or Dagster for complex workflows
5. **Validate data quality** - Check data at each pipeline stage
6. **Document pipelines** - Clear documentation for maintenance and debugging
