# MLOps Tools Comparison

## Overview

This guide compares popular MLOps tools across different categories to help you build the right stack for your needs.

## Tool Categories

```
MLOps Tool Landscape
+------------------------------------------------------------------+
|                                                                    |
|  Experiment Tracking    |  MLflow, W&B, Neptune, DVC             |
|                                                                    |
|  Model Registry        |  MLflow, SageMaker, Vertex AI           |
|                                                                    |
|  Pipeline Orchestration |  Airflow, Kubeflow, Prefect, Dagster   |
|                                                                    |
|  Feature Store         |  Feast, Tecton, Hopsworks               |
|                                                                    |
|  Model Serving         |  Seldon, BentoML, TorchServe, TF Serving|
|                                                                    |
|  Monitoring            |  Evidently, WhyLabs, Arize              |
|                                                                    |
|  Data Versioning       |  DVC, LakeFS, Delta Lake                 |
|                                                                    |
|  Infrastructure        |  Kubernetes, Docker, Terraform           |
|                                                                    |
+------------------------------------------------------------------+
```

## Experiment Tracking

### MLflow vs Weights & Biases vs Neptune

| Feature | MLflow | Weights & Biases | Neptune |
|---------|--------|------------------|---------|
| Open Source | Yes | Partial | No |
| Self-hosted | Yes | Yes | No |
| Experiment Tracking | Yes | Yes | Yes |
| Model Registry | Yes | Yes | Yes |
| Data Versioning | Yes (DVC) | Yes | No |
| Visualization | Basic | Advanced | Advanced |
| Collaboration | Limited | Excellent | Excellent |
| Integration | Excellent | Excellent | Good |
| Pricing | Free | Freemium | Paid |

### MLflow

```python
import mlflow

# Track experiment
with mlflow.start_run(run_name="baseline_model"):
    # Log parameters
    mlflow.log_param("learning_rate", 0.01)
    mlflow.log_param("epochs", 100)
    mlflow.log_param("batch_size", 32)

    # Train model
    model = train_model()

    # Log metrics
    mlflow.log_metric("accuracy", 0.92)
    mlflow.log_metric("loss", 0.08)

    # Log model
    mlflow.pytorch.log_model(model, "model")

    # Log artifacts
    mlflow.log_artifact("confusion_matrix.png")

# Register model
model_uri = "runs:/{run_id}/model"
mlflow.register_model(model_uri, "my_model")
```

### Weights & Biases

```python
import wandb

# Initialize run
wandb.init(project="my_project", name="baseline_model")

# Log configuration
wandb.config.update({
    "learning_rate": 0.01,
    "epochs": 100,
    "batch_size": 32
})

# Train model
for epoch in range(100):
    train_loss = train_one_epoch()
    val_loss = validate()

    # Log metrics
    wandb.log({
        "train_loss": train_loss,
        "val_loss": val_loss,
        "epoch": epoch
    })

# Log model
wandb.save("model.pt")

# Finish run
wandb.finish()
```

---

## Pipeline Orchestration

### Apache Airflow vs Kubeflow vs Prefect vs Dagster

| Feature | Airflow | Kubeflow | Prefect | Dagster |
|---------|---------|----------|---------|---------|
| Primary Use | Workflow orchestration | ML pipelines | Workflow orchestration | Data orchestration |
| Language | Python | Python | Python | Python |
| UI | Yes | Yes | Yes | Yes |
| Cloud Native | No | Yes (K8s) | Yes | Yes |
| ML Specific | No | Yes | No | Partial |
| Learning Curve | Medium | High | Low | Medium |
| Scalability | Good | Excellent | Good | Good |
| Community | Large | Growing | Growing | Growing |

### Apache Airflow

```python
from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime

with DAG(
    'ml_pipeline',
    start_date=datetime(2024, 1, 1),
    schedule_interval='@daily',
    catchup=False
) as dag:

    def preprocess(**context):
        # Data preprocessing logic
        pass

    def train(**context):
        # Model training logic
        pass

    def evaluate(**context):
        # Model evaluation logic
        pass

    preprocess_task = PythonOperator(
        task_id='preprocess',
        python_callable=preprocess
    )

    train_task = PythonOperator(
        task_id='train',
        python_callable=train
    )

    evaluate_task = PythonOperator(
        task_id='evaluate',
        python_callable=evaluate
    )

    preprocess_task >> train_task >> evaluate_task
```

### Kubeflow Pipelines

```python
from kfp import dsl
from kfp.components import load_component_from_file

@dsl.pipeline(
    name='ML Training Pipeline',
    description='End-to-end ML pipeline'
)
def ml_pipeline():
    # Load components
    preprocess_op = load_component_from_file('preprocess.yaml')
    train_op = load_component_from_file('train.yaml')
    evaluate_op = load_component_from_file('evaluate.yaml')

    # Define pipeline
    preprocess_task = preprocess_op()
    train_task = train_op(preprocess_task.outputs['features'])
    evaluate_task = evaluate_op(train_task.outputs['model'])

# Compile pipeline
from kfp.compiler import Compiler
Compiler().compile(ml_pipeline, 'pipeline.yaml')
```

---

## Feature Store

### Feast vs Tecton vs Hopsworks

| Feature | Feast | Tecton | Hopsworks |
|---------|-------|--------|-----------|
| Open Source | Yes | No | Yes |
| Managed Service | No | Yes | Yes |
| Real-time Features | Yes | Yes | Yes |
| Batch Features | Yes | Yes | Yes |
| Feature Serving | Yes | Yes | Yes |
| Integration | Good | Excellent | Good |
| Pricing | Free | Enterprise | Freemium |

### Feast

```python
from feast import FeatureStore, Entity, Feature, ValueType
from feast import FileSource, RequestSource
from feast.feature_service import FeatureService

# Define entity
driver = Entity(
    name="driver_id",
    value_type=ValueType.INT64,
    description="Driver identifier"
)

# Define features
driver_stats = FeatureView(
    name="driver_stats",
    entities=["driver_id"],
    ttl=timedelta(days=1),
    features=[
        Feature(name="avg_daily_trips", value_type=ValueType.INT64),
        Feature(name="total_distance", value_type=ValueType.FLOAT),
        Feature(name="avg_rating", value_type=ValueType.FLOAT),
    ],
    online=True,
    source=FileSource(path="data/driver_stats.parquet")
)

# Create feature service
driver_features_service = FeatureService(
    name="driver_features",
    features=[driver_stats]
)

# Get features for training
store = FeatureStore(repo_path=".")
training_df = store.get_historical_features(
    entity_df=entity_df,
    features=[
        "driver_stats:avg_daily_trips",
        "driver_stats:total_distance",
        "driver_stats:avg_rating"
    ]
).to_df()

# Get features for serving
feature_vector = store.get_online_features(
    features=[
        "driver_stats:avg_daily_trips",
        "driver_stats:total_distance",
        "driver_stats:avg_rating"
    ],
    entity_rows=[{"driver_id": 123}]
).to_dict()
```

---

## Model Serving

### Seldon Core vs BentoML vs TorchServe vs TF Serving

| Feature | Seldon Core | BentoML | TorchServe | TF Serving |
|---------|-------------|---------|------------|------------|
| Framework Support | Any | Any | PyTorch | TensorFlow |
| Kubernetes | Yes | Yes | Yes | Yes |
| REST API | Yes | Yes | Yes | Yes |
| gRPC | Yes | Yes | Yes | Yes |
| A/B Testing | Yes | Yes | No | No |
| Canary | Yes | Yes | No | No |
| Model Optimization | Limited | Yes | Yes | Yes |
| Learning Curve | High | Low | Medium | Medium |

### Seldon Core

```python
# seldon_deployment.yaml
apiVersion: machinelearning.seldon.io/v1
kind: SeldonDeployment
metadata:
  name: churn-model
spec:
  predictors:
  - name: default
    replicas: 3
    graph:
      name: classifier
      implementation: SKLEARN_SERVER
      modelUri: gs://my-bucket/models/churn-model
      children: []
    componentSpecs:
    - spec:
        containers:
        - name: classifier
          resources:
            requests:
              memory: "1Gi"
              cpu: "500m"
            limits:
              memory: "2Gi"
              cpu: "1000m"
```

### BentoML

```python
# service.py
import bentoml
from bentoml.io import JSON, NumpyNdarray

# Load model
model_runner = bentoml.sklearn.get("churn_model:latest").to_runner()
svc = bentoml.Service("churn_classifier", runners=[model_runner])

@svc.api(input=JSON(), output=JSON())
async def predict(input_data):
    features = input_data["features"]
    prediction = await model_runner.predict.run(features)
    return {"prediction": prediction.tolist()}

# Build and deploy
# $ bentoml build
# $ bentoml containerize churn_classifier
# $ docker run -p 3000:3000 churn_classifier:latest
```

---

## Data Versioning

### DVC vs LakeFS vs Delta Lake

| Feature | DVC | LakeFS | Delta Lake |
|---------|-----|--------|------------|
| Open Source | Yes | Yes | Yes |
| Git Integration | Yes | Yes | No |
| Data Versioning | Yes | Yes | Yes |
| Branching | Yes | Yes | Yes |
| Merge Support | Limited | Yes | Limited |
| Storage Backend | S3, GCS, Azure | S3, GCS, Azure | S3, GCS, Azure |
| Learning Curve | Low | Medium | Medium |
| Best For | ML Projects | Data Lakes | Spark Workloads |

### DVC

```bash
# Initialize DVC
dvc init

# Track data files
dvc add data/training_data.csv

# Push to remote storage
dvc push

# Pull specific version
git checkout v1.0
dvc pull

# Compare data versions
dvc diff v1.0 v2.0
```

---

## Monitoring

### Evidently vs WhyLabs vs Arize

| Feature | Evidently | WhyLabs | Arize |
|---------|-----------|---------|-------|
| Open Source | Yes | No | No |
| Self-hosted | Yes | No | No |
| Data Drift | Yes | Yes | Yes |
| Model Performance | Yes | Yes | Yes |
| Custom Metrics | Yes | Yes | Yes |
| Integration | Good | Excellent | Excellent |
| Pricing | Free | Paid | Paid |

### Evidently

```python
from evidently import ColumnMapping
from evidently.report import Report
from evidently.metric_preset import (
    DataDriftPreset,
    TargetDriftPreset,
    ClassificationQualityPreset
)

# Create column mapping
column_mapping = ColumnMapping(
    target='actual',
    prediction='predicted',
    numerical_features=['feature1', 'feature2'],
    categorical_features=['category']
)

# Create report
report = Report(metrics=[
    DataDriftPreset(),
    TargetDriftPreset(),
    ClassificationQualityPreset()
])

# Run report
report.run(
    reference_data=reference_df,
    current_data=current_df,
    column_mapping=column_mapping
)

# Save report
report.save_html("drift_report.html")

# Get results as dictionary
results = report.as_dict()
```

---

## Recommended Stacks

### Startup / Small Team

```
Experiment Tracking: MLflow (self-hosted)
Pipeline: Prefect
Feature Store: Feast (file-based)
Serving: FastAPI + Docker
Monitoring: Evidently
Version Control: Git + DVC
```

### Mid-size Company

```
Experiment Tracking: Weights & Biases
Pipeline: Airflow
Feature Store: Feast (Redis backend)
Serving: Seldon Core
Monitoring: WhyLabs
Version Control: Git + DVC
Infrastructure: Kubernetes
```

### Enterprise

```
Experiment Tracking: MLflow (enterprise) + W&B
Pipeline: Kubeflow
Feature Store: Tecton
Serving: Seldon Core + KServe
Monitoring: Arize + Custom
Version Control: Git + LakeFS
Infrastructure: Kubernetes + Terraform
```

---

## Tool Selection Criteria

1. **Team Size**: Smaller teams need simpler tools
2. **Budget**: Open source vs commercial solutions
3. **Scale**: Number of models, data volume, prediction volume
4. **Infrastructure**: Cloud vs on-premise, Kubernetes availability
5. **ML Frameworks**: TensorFlow, PyTorch, Scikit-learn support
6. **Integration**: Existing infrastructure and workflows
7. **Support**: Community vs enterprise support
8. **Learning Curve**: Time to adopt and be productive
