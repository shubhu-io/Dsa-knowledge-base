# MLOps Comprehensive Guide

## Table of Contents

1. [Introduction](#introduction)
2. [MLOps Principles](#mlops-principles)
3. [Data Management](#data-management)
4. [Model Development](#model-development)
5. [Model Deployment](#model-deployment)
6. [Monitoring and Observability](#monitoring-and-observability)
7. [Governance and Compliance](#governance-and-compliance)
8. [Team Structure](#team-structure)

---

## Introduction

MLOps is the practice of applying DevOps principles to machine learning systems. It encompasses the entire lifecycle of ML models from data collection to production monitoring.

### Why MLOps Matters

```
Without MLOps:
Data Scientist -> Manual Export -> Manual Deploy -> Hope for the Best
     (weeks)        (days)           (days)            (uncertain)

With MLOps:
Data Scientist -> Automated Pipeline -> Tested Deploy -> Continuous Monitoring
     (hours)         (minutes)           (minutes)        (real-time)
```

### MLOps Maturity Levels

| Level | Name | Characteristics |
|-------|------|-----------------|
| 0 | Manual Process | Manual training, manual deployment, no tracking |
| 1 | ML Pipeline Automation | Automated training, basic CI/CD |
| 2 | CI/CD Pipeline Automation | Full CI/CD, automated testing, version control |
| 3 | Full MLOps | End-to-end automation, monitoring, retraining triggers |

---

## MLOps Principles

### 1. Reproducibility

Every experiment and model must be reproducible.

```python
# Bad: Non-reproducible
model = RandomForestClassifier()
model.fit(X_train, y_train)

# Good: Reproducible
import mlflow
import numpy as np

np.random.seed(42)
mlflow.set_experiment("customer_churn_prediction")

with mlflow.start_run():
    mlflow.log_param("model_type", "RandomForest")
    mlflow.log_param("n_estimators", 100)
    mlflow.log_param("random_state", 42)

    model = RandomForestClassifier(n_estimators=100, random_state=42)
    model.fit(X_train, y_train)

    accuracy = model.score(X_test, y_test)
    mlflow.log_metric("accuracy", accuracy)
    mlflow.sklearn.log_model(model, "model")
```

### 2. Version Control

Track everything: code, data, models, configurations.

```yaml
# .dvc/config
[core]
    remote = myremote
    autostage = true

# Data versioning with DVC
# $ dvc add data/training_data.csv
# $ dvc push
```

### 3. Automation

Automate repetitive tasks to reduce human error.

```yaml
# GitHub Actions MLOps Pipeline
name: MLOps Pipeline
on:
  push:
    branches: [main]
  schedule:
    - cron: '0 2 * * 1'  # Weekly retrain

jobs:
  train:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.10'
      - name: Install dependencies
        run: pip install -r requirements.txt
      - name: Run training
        run: python src/train.py
      - name: Evaluate model
        run: python src/evaluate.py
      - name: Deploy if metrics pass
        run: python src/deploy.py
        if: success()
```

### 4. Monitoring

Continuous monitoring of model and system health.

### 5. Collaboration

Enable seamless collaboration between data scientists, engineers, and operations.

---

## Data Management

### Data Versioning

```python
import dvc.api

# Get data version
data_url = dvc.api.get_url(
    path='data/training_data.csv',
    repo='https://github.com/example/repo',
    rev='v1.0'
)

# Load versioned data
import pandas as pd
df = pd.read_csv(data_url)
```

### Data Validation

```python
import great_expectations as ge

# Create expectations for data quality
df = ge.read_csv("data/training_data.csv")

# Define expectations
df.expect_column_values_to_not_be_null("user_id")
df.expect_column_values_to_be_unique("user_id")
df.expect_column_values_to_be_between("age", 0, 150)
df.expect_column_values_to_match_regex("email", r"^[\w\.-]+@[\w\.-]+\.\w+$")

# Validate
results = df.validate()
print(results)
```

### Feature Store

```python
from feast import FeatureStore, Entity, Feature, ValueType
from feast import FileSource
from datetime import datetime

# Define entity
customer = Entity(
    name="customer_id",
    value_type=ValueType.INT64,
    description="Customer identifier"
)

# Define features
customer_features = [
    Feature(name="avg_transaction_amount", value_type=ValueType.FLOAT),
    Feature(name="transaction_count_30d", value_type=ValueType.INT64),
    Feature(name="days_since_last_purchase", value_type=ValueType.INT64),
]

# Define data source
batch_source = FileSource(
    path="data/customer_features.parquet",
    event_timestamp_column="event_timestamp"
)

# Register feature view
customer_feature_view = FeatureView(
    name="customer_features",
    entities=["customer_id"],
    ttl=timedelta(days=1),
    features=customer_features,
    online=True,
    batch_source=batch_source
)
```

---

## Model Development

### Experiment Tracking

```python
import mlflow
from mlflow.tracking import MlflowClient

# Set tracking URI
mlflow.set_tracking_uri("http://localhost:5000")
mlflow.set_experiment("churn_prediction")

# Track experiment
with mlflow.start_run(run_name="rf_baseline"):
    # Log parameters
    mlflow.log_param("model_type", "RandomForest")
    mlflow.log_param("n_estimators", 100)
    mlflow.log_param("max_depth", 10)
    mlflow.log_param("features", "standard")

    # Train model
    from sklearn.ensemble import RandomForestClassifier
    from sklearn.metrics import accuracy_score, f1_score

    model = RandomForestClassifier(n_estimators=100, max_depth=10)
    model.fit(X_train, y_train)
    y_pred = model.predict(X_test)

    # Log metrics
    mlflow.log_metric("accuracy", accuracy_score(y_test, y_pred))
    mlflow.log_metric("f1_score", f1_score(y_test, y_pred))

    # Log model
    mlflow.sklearn.log_model(model, "model")

    # Log artifacts
    mlflow.log_artifact("confusion_matrix.png")
    mlflow.log_artifact("feature_importance.png")

    print(f"Run ID: {mlflow.active_run().info.run_id}")
```

### Model Comparison

```python
# Compare experiments
client = MlflowClient()
experiments = client.get_experiment_by_name("churn_prediction")

runs = client.search_runs(
    experiment_ids=[experiments.experiment_id],
    order_by=["metrics.accuracy DESC"],
    max_results=5
)

for run in runs:
    print(f"Run: {run.info.run_name}")
    print(f"  Accuracy: {run.data.metrics['accuracy']:.4f}")
    print(f"  F1 Score: {run.data.metrics['f1_score']:.4f}")
    print(f"  Model: {run.data.params['model_type']}")
    print()
```

---

## Model Deployment

### Deployment Strategies

```
Blue-Green Deployment:
  Blue (Prod)  <--> Router <--> Users
  Green (New)  <--------/

Canary Deployment:
  Current Model (95%) <--> Users
  New Model (5%)      <--> Users

Shadow Deployment:
  Current Model (100%) <--> Users
  Shadow Model         <--> Copy of requests
```

### REST API Deployment

```python
from fastapi import FastAPI
from pydantic import BaseModel
import mlflow
import numpy as np

app = FastAPI()

# Load model
model = mlflow.sklearn.load_model("models:/churn_model/Production")

class PredictionRequest(BaseModel):
    features: list[float]

class PredictionResponse(BaseModel):
    prediction: int
    probability: float

@app.post("/predict", response_model=PredictionResponse)
async def predict(request: PredictionRequest):
    features = np.array(request.features).reshape(1, -1)
    prediction = model.predict(features)[0]
    probability = model.predict_proba(features)[0].max()

    return PredictionResponse(
        prediction=int(prediction),
        probability=float(probability)
    )

@app.get("/health")
async def health():
    return {"status": "healthy", "model_version": "1.0"}
```

### Docker Deployment

```dockerfile
FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

---

## Monitoring and Observability

### Model Performance Monitoring

```python
from evidently import ColumnMapping
from evidently.report import Report
from evidently.metric_preset import (
    DataDriftPreset,
    TargetDriftPreset,
    ClassificationPreset
)

# Create monitoring report
column_mapping = ColumnMapping(
    target='actual',
    prediction='predicted',
    numerical_features=['feature1', 'feature2'],
    categorical_features=['feature3']
)

report = Report(metrics=[
    DataDriftPreset(),
    TargetDriftPreset(),
    ClassificationPreset()
])

report.run(
    reference_data=train_data,
    current_data=production_data,
    column_mapping=column_mapping
)

report.save_html("monitoring_report.html")
```

### Data Drift Detection

```python
from scipy import stats
import numpy as np

def detect_drift(reference_data, current_data, threshold=0.05):
    """Detect data drift using KS test."""
    drift_results = {}

    for column in reference_data.columns:
        if reference_data[column].dtype in ['float64', 'int64']:
            stat, p_value = stats.ks_2samp(
                reference_data[column].dropna(),
                current_data[column].dropna()
            )
            drift_results[column] = {
                'statistic': stat,
                'p_value': p_value,
                'drifted': p_value < threshold
            }

    return drift_results
```

### Alerting Configuration

```yaml
# alerting_config.yaml
alerts:
  model_performance:
    metric: accuracy
    threshold: 0.85
    comparison: less_than
    notification:
      - email: ml-team@company.com
      - slack: "#ml-alerts"

  data_drift:
    metric: drift_score
    threshold: 0.3
    comparison: greater_than
    notification:
      - email: ml-team@company.com
      - slack: "#ml-alerts"

  latency:
    metric: p99_latency_ms
    threshold: 100
    comparison: greater_than
    notification:
      - email: platform-team@company.com
      - slack: "#platform-alerts"
```

---

## Governance and Compliance

### Model Registry

```python
import mlflow

# Register model
model_uri = "runs:/<run_id>/model"
result = mlflow.register_model(model_uri, "churn_model")

# Transition model stage
client = MlflowClient()
client.transition_model_version_stage(
    name="churn_model",
    version=1,
    stage="Production"
)

# Add model description
client.update_model_version(
    name="churn_model",
    version=1,
    description="Churn prediction model v1.0 - Trained on 2024 Q1 data"
)
```

### Audit Logging

```python
import logging
from datetime import datetime

# Configure audit logging
audit_logger = logging.getLogger("audit")
audit_logger.setLevel(logging.INFO)

handler = logging.FileHandler("audit.log")
audit_logger.addHandler(handler)

def log_model_access(user, model_name, action):
    audit_logger.info(
        f"{datetime.utcnow().isoformat()} | "
        f"User: {user} | "
        f"Model: {model_name} | "
        f"Action: {action}"
    )

# Usage
log_model_access("data_scientist_1", "churn_model", "predict")
log_model_access("ml_engineer_1", "churn_model", "deploy")
```

---

## Team Structure

### RACI Matrix

| Activity | Data Scientist | ML Engineer | DevOps | Product Owner |
|----------|---------------|-------------|--------|---------------|
| Data Collection | R | C | I | A |
| Feature Engineering | R | C | I | A |
| Model Development | R | C | I | A |
| Model Testing | C | R | A | I |
| Deployment | I | R | A | I |
| Monitoring | C | R | A | I |

### Key Roles

- **Data Scientist**: Model development, experimentation, feature engineering
- **ML Engineer**: Pipeline automation, model serving, infrastructure
- **DevOps Engineer**: CI/CD, infrastructure, monitoring
- **Product Owner**: Requirements, priorities, business alignment

---

## Summary

MLOps is essential for scaling machine learning in production. Key takeaways:

1. Start with experiment tracking and version control
2. Automate training and deployment pipelines
3. Monitor model performance and data quality continuously
4. Establish clear governance and audit trails
5. Foster collaboration between teams
