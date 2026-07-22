# MLOps Best Practices

## Overview

This guide covers industry-proven best practices for implementing MLOps effectively. These practices help ensure reliability, reproducibility, and scalability of ML systems.

## Core Principles

```
MLOps Best Practices Framework
+------------------------------------------------------------------+
|                                                                    |
|  1. Reproducibility    - Track everything, version everything     |
|  2. Automation         - Automate repetitive tasks                 |
|  3. Testing            - Test data, code, and models               |
|  4. Monitoring         - Track model and data health               |
|  5. Documentation      - Document processes and decisions          |
|  6. Collaboration      - Enable cross-team workflows               |
|                                                                    |
+------------------------------------------------------------------+
```

---

## 1. Version Control Best Practices

### Code Versioning

```bash
# Use Git for all code
git init
git add .
git commit -m "Initial commit: ML pipeline setup"

# Use feature branches
git checkout -b feature/new-feature
git add .
git commit -m "Add feature engineering module"
git push origin feature/new-feature

# Create PR for review
gh pr create --title "Add feature engineering" --body "Description of changes"
```

### Data Versioning

```bash
# Initialize DVC
dvc init
git add .dvc .dvcignore

# Track data files
dvc add data/training_data.csv
dvc add data/test_data.csv

# Push data to remote storage
dvc remote add -d myremote s3://my-bucket/dvc-storage
dvc push

# Pull specific version
git checkout v1.0
dvc pull
```

### Model Versioning

```python
import mlflow

# Log model with version info
with mlflow.start_run():
    mlflow.log_param("model_version", "1.0.0")
    mlflow.log_param("training_data_version", "v2.1")
    mlflow.log_param("code_commit", "abc123")

    # Train and log model
    model = train_model()
    mlflow.sklearn.log_model(
        model,
        "model",
        registered_model_name="production_model"
    )
```

---

## 2. Experiment Tracking Best Practices

### What to Track

```python
import mlflow

def track_experiment(model_name, X_train, y_train, X_test, y_test, params):
    with mlflow.start_run(run_name=f"{model_name}_run"):
        # 1. Log all parameters
        mlflow.log_params(params)

        # 2. Log data version
        mlflow.log_param("data_version", get_data_version())

        # 3. Log code version
        mlflow.log_param("git_commit", get_git_commit())

        # 4. Train model
        model = train_model(X_train, y_train, **params)

        # 5. Log training metrics
        train_pred = model.predict(X_train)
        mlflow.log_metric("train_accuracy", accuracy_score(y_train, train_pred))

        # 6. Log validation metrics
        val_pred = model.predict(X_test)
        mlflow.log_metric("val_accuracy", accuracy_score(y_test, val_pred))

        # 7. Log model artifacts
        mlflow.sklearn.log_model(model, "model")
        mlflow.log_artifact("confusion_matrix.png")
        mlflow.log_artifact("feature_importance.png")

        # 8. Log dataset info
        mlflow.log_param("train_size", len(X_train))
        mlflow.log_param("test_size", len(X_test))
        mlflow.log_param("num_features", X_train.shape[1])
```

### Experiment Organization

```python
# Organize experiments with meaningful names
mlflow.set_experiment("churn_prediction_v2")

# Use consistent naming conventions
with mlflow.start_run(run_name="rf_baseline_n100_d10"):
    # Clear, descriptive run name
    pass

# Tag runs for filtering
mlflow.set_tags({
    "team": "data_science",
    "project": "churn_prediction",
    "status": "baseline",
    "author": "john_doe"
})
```

---

## 3. Model Training Best Practices

### Data Splitting

```python
from sklearn.model_selection import train_test_split, StratifiedKFold
import numpy as np

# Set random seed for reproducibility
np.random.seed(42)

# First split: train+validation vs test
X_train_val, X_test, y_train_val, y_test = train_test_split(
    X, y, test_size=0.2, stratify=y, random_state=42
)

# Second split: train vs validation
X_train, X_val, y_train, y_val = train_test_split(
    X_train_val, y_train_val,
    test_size=0.25, stratify=y_train_val,  # 0.25 x 0.8 = 0.2
    random_state=42
)

# Cross-validation for robust evaluation
cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)
cv_scores = cross_val_score(model, X_train, y_train, cv=cv, scoring='accuracy')
```

### Hyperparameter Tuning

```python
from sklearn.model_selection import RandomizedSearchCV
from scipy.stats import randint, uniform

# Define parameter distribution
param_distributions = {
    'n_estimators': randint(50, 300),
    'max_depth': randint(3, 20),
    'min_samples_split': randint(2, 20),
    'min_samples_leaf': randint(1, 10),
    'max_features': uniform(0.1, 0.9)
}

# Randomized search with cross-validation
random_search = RandomizedSearchCV(
    RandomForestClassifier(random_state=42),
    param_distributions=param_distributions,
    n_iter=100,
    cv=5,
    scoring='accuracy',
    random_state=42,
    n_jobs=-1
)

random_search.fit(X_train, y_train)

# Log best parameters
mlflow.log_params(random_search.best_params_)
mlflow.log_metric("best_cv_score", random_search.best_score_)
```

### Early Stopping

```python
import xgboost as xgb

# Train with early stopping
dtrain = xgb.DMatrix(X_train, label=y_train)
dval = xgb.DMatrix(X_val, label=y_val)

params = {
    'objective': 'binary:logistic',
    'eval_metric': 'logloss',
    'max_depth': 6,
    'learning_rate': 0.1
}

model = xgb.train(
    params,
    dtrain,
    num_boost_round=1000,
    evals=[(dtrain, 'train'), (dval, 'val')],
    early_stopping_rounds=50,
    verbose_eval=100
)
```

---

## 4. Model Evaluation Best Practices

### Comprehensive Evaluation

```python
from sklearn.metrics import (
    accuracy_score, precision_score, recall_score,
    f1_score, roc_auc_score, confusion_matrix,
    classification_report
)

def evaluate_model_comprehensive(model, X_test, y_test, threshold=0.5):
    """Complete model evaluation."""
    y_pred = model.predict(X_test)
    y_prob = model.predict_proba(X_test)[:, 1]

    # Metrics
    metrics = {
        'accuracy': accuracy_score(y_test, y_pred),
        'precision': precision_score(y_test, y_pred),
        'recall': recall_score(y_test, y_pred),
        'f1_score': f1_score(y_test, y_pred),
        'auc_roc': roc_auc_score(y_test, y_prob)
    }

    # Confusion matrix
    cm = confusion_matrix(y_test, y_pred)

    # Classification report
    report = classification_report(y_test, y_pred, output_dict=True)

    return {
        'metrics': metrics,
        'confusion_matrix': cm,
        'classification_report': report
    }
```

### Business Metrics

```python
def calculate_business_metrics(y_true, y_pred, y_prob, cost_fp, cost_fn):
    """Calculate business-relevant metrics."""
    # Cost-sensitive metrics
    cm = confusion_matrix(y_true, y_pred)
    tn, fp, fn, tp = cm.ravel()

    total_cost = (fp * cost_fp) + (fn * cost_fn)
    cost_per_sample = total_cost / len(y_true)

    # Expected value
    expected_value = np.mean(y_prob) * 1000  # Example: average customer value

    return {
        'total_cost': total_cost,
        'cost_per_sample': cost_per_sample,
        'expected_value': expected_value,
        'net_value': expected_value - cost_per_sample
    }
```

---

## 5. Deployment Best Practices

### Containerization

```dockerfile
# Dockerfile for ML model
FROM python:3.10-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy model and code
COPY model/ ./model/
COPY src/ ./src/
COPY config/ ./config/

# Health check
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

EXPOSE 8000

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### API Design

```python
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List, Optional
import mlflow
import numpy as np

app = FastAPI()

# Load model at startup
model = None

@app.on_event("startup")
async def load_model():
    global model
    model = mlflow.sklearn.load_model("models:/production_model/Production")

class PredictionRequest(BaseModel):
    features: List[float]
    request_id: Optional[str] = None

class PredictionResponse(BaseModel):
    prediction: int
    probability: float
    model_version: str
    request_id: Optional[str] = None

@app.post("/predict", response_model=PredictionResponse)
async def predict(request: PredictionRequest):
    try:
        features = np.array(request.features).reshape(1, -1)
        prediction = model.predict(features)[0]
        probability = model.predict_proba(features)[0].max()

        return PredictionResponse(
            prediction=int(prediction),
            probability=float(probability),
            model_version="1.0.0",
            request_id=request.request_id
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/health")
async def health():
    return {"status": "healthy", "model_loaded": model is not None}
```

### Deployment Strategies

```python
# Canary deployment configuration
canary_config = {
    "strategy": "canary",
    "traffic_split": {
        "canary": 10,  # 10% traffic
        "stable": 90   # 90% traffic
    },
    "promotion_criteria": {
        "min_requests": 1000,
        "error_rate_threshold": 0.01,
        "latency_p99_ms": 100
    },
    "rollback_criteria": {
        "error_rate_threshold": 0.05,
        "latency_p99_ms": 500
    }
}
```

---

## 6. Monitoring Best Practices

### Model Performance Monitoring

```python
from evidently import ColumnMapping
from evidently.report import Report
from evidently.metric_preset import DataDriftPreset
import schedule
import time

def monitor_model_performance():
    """Run model monitoring job."""
    # Load reference and current data
    reference_data = load_reference_data()
    current_data = load_current_data()

    # Create monitoring report
    column_mapping = ColumnMapping(
        target='actual',
        prediction='predicted',
        numerical_features=['feature1', 'feature2']
    )

    report = Report(metrics=[DataDriftPreset()])
    report.run(
        reference_data=reference_data,
        current_data=current_data,
        column_mapping=column_mapping
    )

    # Check for drift
    results = report.as_dict()
    drift_detected = results['metrics'][0]['result']['dataset_drift']

    if drift_detected:
        send_alert("Data drift detected!")
        trigger_retraining()

# Schedule monitoring job
schedule.every(1).day.do(monitor_model_performance)
```

### Alert Configuration

```yaml
# alerting_rules.yaml
alerts:
  - name: model_performance_degradation
    condition: accuracy < 0.85
    severity: critical
    channels:
      - email: ml-team@company.com
      - slack: "#ml-alerts"

  - name: data_drift_detected
    condition: drift_score > 0.3
    severity: warning
    channels:
      - email: ml-team@company.com

  - name: high_latency
    condition: p99_latency > 200ms
    severity: warning
    channels:
      - email: platform-team@company.com
      - pagerduty: ml-service

  - name: error_rate_high
    condition: error_rate > 0.05
    severity: critical
    channels:
      - email: ml-team@company.com
      - pagerduty: ml-service
```

---

## 7. Testing Best Practices

### Unit Tests

```python
# test_feature_engineering.py
import pytest
import pandas as pd
from feature_engineering import FeatureEngineer

@pytest.fixture
def sample_data():
    return pd.DataFrame({
        'user_id': [1, 2, 3, 4, 5],
        'timestamp': pd.date_range('2024-01-01', periods=5),
        'amount': [100, 200, 150, 300, 250]
    })

def test_temporal_features(sample_data):
    engineer = FeatureEngineer({})
    result = engineer.create_temporal_features(sample_data, 'timestamp')

    assert 'hour' in result.columns
    assert 'day_of_week' in result.columns
    assert 'month' in result.columns
    assert result['hour'].between(0, 23).all()

def test_aggregation_features(sample_data):
    engineer = FeatureEngineer({})
    result = engineer.create_aggregation_features(sample_data, 'user_id', 'amount')

    assert 'amount_mean' in result.columns
    assert 'amount_std' in result.columns
```

### Integration Tests

```python
# test_pipeline_integration.py
import pytest
from pipeline import MLPipeline

@pytest.fixture
def pipeline():
    return MLPipeline(config_path="config/test_config.yaml")

def test_full_pipeline(pipeline):
    """Test complete pipeline execution."""
    # Run pipeline
    result = pipeline.run()

    # Verify outputs
    assert result['status'] == 'success'
    assert 'model_metrics' in result
    assert result['model_metrics']['accuracy'] > 0.8

def test_pipeline_with_invalid_data(pipeline):
    """Test pipeline handles invalid data gracefully."""
    # Provide invalid data
    result = pipeline.run(data_path="data/invalid_data.csv")

    # Should fail gracefully
    assert result['status'] == 'failed'
    assert 'error_message' in result
```

### Model Tests

```python
# test_model.py
import pytest
import numpy as np
from model import load_model, predict

@pytest.fixture
def model():
    return load_model("models:/production_model/Production")

def test_model_loads(model):
    """Test model loads correctly."""
    assert model is not None
    assert hasattr(model, 'predict')

def test_prediction_shape(model):
    """Test prediction output shape."""
    X = np.random.randn(1, 10)  # 1 sample, 10 features
    prediction = predict(model, X)

    assert prediction.shape == (1,)
    assert prediction.dtype in [np.int64, np.float64]

def test_prediction_range(model):
    """Test prediction values are in valid range."""
    X = np.random.randn(100, 10)
    predictions = predict(model, X)

    assert np.all(predictions >= 0)
    assert np.all(predictions <= 1)
```

---

## 8. Documentation Best Practices

### Model Card

```markdown
# Model Card: Customer Churn Prediction

## Model Details
- **Name**: Churn Prediction Model v2.0
- **Version**: 2.0.0
- **Type**: Binary Classification
- **Algorithm**: XGBoost
- **Last Updated**: 2024-01-15

## Training Data
- **Source**: Production database
- **Size**: 100,000 samples
- **Features**: 25 numerical, 10 categorical
- **Time Period**: 2023-01-01 to 2023-12-31

## Performance Metrics
| Metric | Value |
|--------|-------|
| Accuracy | 0.92 |
| Precision | 0.89 |
| Recall | 0.94 |
| F1 Score | 0.91 |
| AUC-ROC | 0.95 |

## Limitations
- Performance degrades for customers with < 3 months history
- Not calibrated for international customers
- Requires daily feature refresh

## Ethical Considerations
- Does not use protected attributes (race, gender, age)
- Regularly audited for fairness across demographics
```

### Pipeline Documentation

```markdown
# ML Pipeline Documentation

## Overview
This pipeline automates the end-to-end ML workflow for customer churn prediction.

## Architecture
1. **Data Ingestion**: Pulls data from PostgreSQL
2. **Validation**: Checks data quality with Great Expectations
3. **Feature Engineering**: Creates features using Feast
4. **Training**: Trains models with MLflow tracking
5. **Evaluation**: Validates model performance
6. **Deployment**: Deploys to Kubernetes with Seldon

## Schedule
- **Training**: Weekly (Sunday 2 AM UTC)
- **Monitoring**: Daily (6 AM UTC)
- **Retraining**: Triggered by drift detection

## Configuration
- Config file: `config/pipeline_config.yaml`
- Environment variables: `.env`
- Secrets: AWS Secrets Manager

## Troubleshooting
- Logs: CloudWatch Logs
- Metrics: Prometheus/Grafana
- Alerts: PagerDuty
```

---

## 9. Security Best Practices

### Secrets Management

```python
import boto3
import json

def get_secret(secret_name):
    """Retrieve secret from AWS Secrets Manager."""
    client = boto3.client('secretsmanager')
    response = client.get_secret_value(SecretId=secret_name)
    return json.loads(response['SecretString'])

# Usage
db_credentials = get_secret("ml-pipeline/db-credentials")
mlflow_token = get_secret("ml-pipeline/mlflow-token")
```

### Data Privacy

```python
import hashlib
from cryptography.fernet import Fernet

def anonymize_user_id(user_id):
    """Anonymize user ID using hashing."""
    return hashlib.sha256(str(user_id).encode()).hexdigest()

def encrypt_sensitive_data(data, key):
    """Encrypt sensitive data."""
    f = Fernet(key)
    return f.encrypt(data.encode())

def decrypt_sensitive_data(encrypted_data, key):
    """Decrypt sensitive data."""
    f = Fernet(key)
    return f.decrypt(encrypted_data).decode()
```

---

## 10. Cost Optimization

### Resource Management

```yaml
# Kubernetes resource limits
apiVersion: apps/v1
kind: Deployment
metadata:
  name: model-server
spec:
  replicas: 3
  template:
    spec:
      containers:
      - name: model
        resources:
          requests:
            memory: "1Gi"
            cpu: "500m"
            nvidia.com/gpu: 1
          limits:
            memory: "2Gi"
            cpu: "1000m"
            nvidia.com/gpu: 1
```

### Auto-scaling

```yaml
# Horizontal Pod Autoscaler
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: model-server-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: model-server
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

---

## Summary

Key best practices:

1. **Version everything** - Code, data, models, configurations
2. **Track experiments** - Log parameters, metrics, and artifacts
3. **Automate workflows** - Use pipelines for reproducibility
4. **Test thoroughly** - Unit, integration, and model tests
5. **Monitor continuously** - Track performance and data quality
6. **Document clearly** - Model cards, pipeline docs, runbooks
7. **Secure properly** - Secrets management, data privacy
8. **Optimize costs** - Resource management, auto-scaling
