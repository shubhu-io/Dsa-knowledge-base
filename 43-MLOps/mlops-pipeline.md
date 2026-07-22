# MLOps Pipeline Design

## Overview

An MLOps pipeline automates the end-to-end machine learning lifecycle, from data ingestion to model monitoring. This guide covers pipeline architecture, implementation, and best practices.

## Pipeline Architecture

```
+------------------------------------------------------------------+
|                     MLOps Pipeline Architecture                    |
+------------------------------------------------------------------+
|                                                                    |
|  [Data Source] --> [Ingestion] --> [Validation] --> [Storage]      |
|       |               |                |               |           |
|       v               v                v               v           |
|  +--------+    +-----------+    +-----------+    +-----------+    |
|  |  APIs  |    |  Apache   |    |  Great    |    |   Data    |    |
|  |  Databases| |  Airflow  |    | Expectations| |   Lake    |    |
|  |  Files  |    |           |    |           |    |           |    |
|  +--------+    +-----------+    +-----------+    +-----------+    |
|                                                                    |
|  [Features] --> [Training] --> [Evaluation] --> [Registry]        |
|       |               |                |               |           |
|       v               v                v               v           |
|  +-----------+   +-----------+    +-----------+    +-----------+  |
|  |  Feast    |   |  Kubeflow |    |  Custom   |    |  MLflow   |  |
|  |  Feature  |   |  Training |    |  Metrics  |    |  Model    |  |
|  |  Store    |   |           |    |  Dashboard|    |  Registry |  |
|  +-----------+   +-----------+    +-----------+    +-----------+  |
|                                                                    |
|  [Deployment] --> [Serving] --> [Monitoring] --> [Retraining]     |
|       |               |                |               |           |
|       v               v                v               v           |
|  +-----------+   +-----------+    +-----------+    +-----------+  |
|  |  Docker   |   |  Seldon   |    |  Evidently|    |  Airflow  |  |
|  |  K8s      |   |  Core     |    |  Grafana  |    |  Trigger  |  |
|  |  Terraform|   |  KServe   |    |  Prometheus|   |  Pipeline |  |
|  +-----------+   +-----------+    +-----------+    +-----------+  |
|                                                                    |
+------------------------------------------------------------------+
```

## Pipeline Stages

### Stage 1: Data Ingestion

```python
# data_ingestion.py
import pandas as pd
from datetime import datetime
import logging

logger = logging.getLogger(__name__)

class DataIngestion:
    def __init__(self, config):
        self.config = config
        self.sources = config.get('sources', [])

    def ingest_from_database(self, connection_string, query):
        """Ingest data from SQL database."""
        from sqlalchemy import create_engine
        engine = create_engine(connection_string)
        df = pd.read_sql(query, engine)
        logger.info(f"Ingested {len(df)} rows from database")
        return df

    def ingest_from_api(self, endpoint, headers=None):
        """Ingest data from REST API."""
        import requests
        response = requests.get(endpoint, headers=headers)
        response.raise_for_status()
        df = pd.DataFrame(response.json())
        logger.info(f"Ingested {len(df)} rows from API")
        return df

    def ingest_from_files(self, file_path, file_type='csv'):
        """Ingest data from files."""
        if file_type == 'csv':
            df = pd.read_csv(file_path)
        elif file_type == 'parquet':
            df = pd.read_parquet(file_path)
        elif file_type == 'json':
            df = pd.read_json(file_path)
        logger.info(f"Ingested {len(df)} rows from {file_path}")
        return df

    def run(self):
        """Execute all ingestion tasks."""
        all_data = []
        for source in self.sources:
            if source['type'] == 'database':
                data = self.ingest_from_database(
                    source['connection_string'],
                    source['query']
                )
            elif source['type'] == 'api':
                data = self.ingest_from_api(
                    source['endpoint'],
                    source.get('headers')
                )
            elif source['type'] == 'file':
                data = self.ingest_from_files(
                    source['file_path'],
                    source.get('file_type', 'csv')
                )
            all_data.append(data)

        combined_data = pd.concat(all_data, ignore_index=True)
        return combined_data
```

### Stage 2: Data Validation

```python
# data_validation.py
import great_expectations as ge
from great_expectations.core import ExpectationSuite

class DataValidator:
    def __init__(self, suite_name="default_suite"):
        self.suite_name = suite_name
        self.suite = ExpectationSuite(suite_name)

    def validate_schema(self, df):
        """Validate data schema matches expectations."""
        ge_df = ge.from_pandas(df)

        expectations = [
            {"type": "expect_column_to_exist", "kwargs": {"column": "user_id"}},
            {"type": "expect_column_to_exist", "kwargs": {"column": "timestamp"}},
            {"type": "expect_column_values_to_not_be_null", "kwargs": {"column": "user_id"}},
            {"type": "expect_column_values_to_be_unique", "kwargs": {"column": "user_id"}},
            {"type": "expect_column_values_to_be_between",
             "kwargs": {"column": "age", "min_value": 0, "max_value": 150}},
        ]

        results = []
        for exp in expectations:
            result = getattr(ge_df, exp["type"])(**exp["kwargs"])
            results.append(result)

        return all(r["success"] for r in results)

    def validate_statistics(self, df, reference_stats=None):
        """Validate statistical properties of data."""
        if reference_stats is None:
            return True

        current_stats = df.describe()
        drift_detected = False

        for column, stats in reference_stats.items():
            if column in current_stats.columns:
                mean_diff = abs(current_stats[column]['mean'] - stats['mean'])
                if mean_diff > stats['std'] * 2:  # 2 sigma drift
                    drift_detected = True

        return not drift_detected

    def run(self, df):
        """Execute all validation tasks."""
        schema_valid = self.validate_schema(df)
        stats_valid = self.validate_statistics(df)

        return {
            "schema_valid": schema_valid,
            "statistics_valid": stats_valid,
            "passed": schema_valid and stats_valid
        }
```

### Stage 3: Feature Engineering

```python
# feature_engineering.py
import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler, LabelEncoder

class FeatureEngineer:
    def __init__(self, config):
        self.config = config
        self.encoders = {}
        self.scalers = {}

    def create_temporal_features(self, df, timestamp_col):
        """Extract temporal features from timestamp."""
        df['hour'] = pd.to_datetime(df[timestamp_col]).dt.hour
        df['day_of_week'] = pd.to_datetime(df[timestamp_col]).dt.dayofweek
        df['month'] = pd.to_datetime(df[timestamp_col]).dt.month
        df['is_weekend'] = df['day_of_week'].isin([5, 6]).astype(int)
        return df

    def create_aggregation_features(self, df, group_col, agg_col):
        """Create aggregation features."""
        agg_features = df.groupby(group_col).agg({
            agg_col: ['mean', 'std', 'min', 'max', 'count']
        })
        agg_features.columns = [
            f'{agg_col}_{stat}' for stat in ['mean', 'std', 'min', 'max', 'count']
        ]
        df = df.merge(agg_features, on=group_col, how='left')
        return df

    def encode_categorical(self, df, columns, method='label'):
        """Encode categorical variables."""
        for col in columns:
            if method == 'label':
                le = LabelEncoder()
                df[f'{col}_encoded'] = le.fit_transform(df[col].astype(str))
                self.encoders[col] = le
            elif method == 'onehot':
                dummies = pd.get_dummies(df[col], prefix=col)
                df = pd.concat([df, dummies], axis=1)
        return df

    def scale_features(self, df, columns):
        """Scale numerical features."""
        scaler = StandardScaler()
        df[columns] = scaler.fit_transform(df[columns])
        self.scalers['standard'] = scaler
        return df

    def run(self, df):
        """Execute all feature engineering tasks."""
        # Apply transformations based on config
        for feature_config in self.config.get('features', []):
            if feature_config['type'] == 'temporal':
                df = self.create_temporal_features(
                    df, feature_config['timestamp_col']
                )
            elif feature_config['type'] == 'aggregation':
                df = self.create_aggregation_features(
                    df, feature_config['group_col'], feature_config['agg_col']
                )
            elif feature_config['type'] == 'encoding':
                df = self.encode_categorical(
                    df, feature_config['columns'], feature_config.get('method', 'label')
                )
            elif feature_config['type'] == 'scaling':
                df = self.scale_features(df, feature_config['columns'])

        return df
```

### Stage 4: Model Training

```python
# model_training.py
import mlflow
import mlflow.sklearn
from sklearn.model_selection import cross_val_score
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
from sklearn.linear_model import LogisticRegression
import json

class ModelTrainer:
    def __init__(self, experiment_name="default_experiment"):
        mlflow.set_experiment(experiment_name)
        self.models = {
            'random_forest': RandomForestClassifier,
            'gradient_boosting': GradientBoostingClassifier,
            'logistic_regression': LogisticRegression
        }

    def train_model(self, model_name, X_train, y_train, params=None):
        """Train a single model with MLflow tracking."""
        with mlflow.start_run(run_name=f"{model_name}_training"):
            # Log parameters
            if params:
                mlflow.log_params(params)

            # Initialize and train model
            ModelClass = self.models[model_name]
            model = ModelClass(**(params or {}))
            model.fit(X_train, y_train)

            # Cross-validation
            cv_scores = cross_val_score(model, X_train, y_train, cv=5)

            # Log metrics
            mlflow.log_metric("cv_mean", cv_scores.mean())
            mlflow.log_metric("cv_std", cv_scores.std())

            # Log model
            mlflow.sklearn.log_model(model, "model")

            return {
                "model": model,
                "cv_mean": cv_scores.mean(),
                "cv_std": cv_scores.std(),
                "run_id": mlflow.active_run().info.run_id
            }

    def compare_models(self, X_train, y_train, param_grid=None):
        """Train and compare multiple models."""
        results = []

        for model_name in self.models.keys():
            params = param_grid.get(model_name, {}) if param_grid else {}
            result = self.train_model(model_name, X_train, y_train, params)
            result['model_name'] = model_name
            results.append(result)

        # Sort by CV score
        results.sort(key=lambda x: x['cv_mean'], reverse=True)
        return results

    def select_best_model(self, results):
        """Select the best model based on CV score."""
        best = results[0]
        print(f"Best model: {best['model_name']}")
        print(f"CV Score: {best['cv_mean']:.4f} (+/- {best['cv_std']:.4f})")
        return best
```

### Stage 5: Model Evaluation

```python
# model_evaluation.py
from sklearn.metrics import (
    accuracy_score, precision_score, recall_score,
    f1_score, roc_auc_score, confusion_matrix,
    classification_report
)
import matplotlib.pyplot as plt
import seaborn as sns
import json

class ModelEvaluator:
    def __init__(self, thresholds=None):
        self.thresholds = thresholds or {
            'accuracy': 0.85,
            'f1_score': 0.80,
            'auc_roc': 0.85
        }

    def evaluate_classification(self, y_true, y_pred, y_prob=None):
        """Comprehensive classification evaluation."""
        metrics = {
            'accuracy': accuracy_score(y_true, y_pred),
            'precision': precision_score(y_true, y_pred, average='weighted'),
            'recall': recall_score(y_true, y_pred, average='weighted'),
            'f1_score': f1_score(y_true, y_pred, average='weighted'),
        }

        if y_prob is not None:
            metrics['auc_roc'] = roc_auc_score(y_true, y_prob)

        return metrics

    def check_thresholds(self, metrics):
        """Check if metrics meet thresholds."""
        passed = {}
        for metric_name, threshold in self.thresholds.items():
            if metric_name in metrics:
                passed[metric_name] = metrics[metric_name] >= threshold
        return all(passed.values())

    def plot_confusion_matrix(self, y_true, y_pred, save_path=None):
        """Plot confusion matrix."""
        cm = confusion_matrix(y_true, y_pred)
        plt.figure(figsize=(8, 6))
        sns.heatmap(cm, annot=True, fmt='d', cmap='Blues')
        plt.title('Confusion Matrix')
        plt.ylabel('Actual')
        plt.xlabel('Predicted')

        if save_path:
            plt.savefig(save_path)
        plt.close()

    def generate_report(self, y_true, y_pred, y_prob=None):
        """Generate complete evaluation report."""
        metrics = self.evaluate_classification(y_true, y_pred, y_prob)
        thresholds_met = self.check_thresholds(metrics)

        report = {
            'metrics': metrics,
            'thresholds_met': thresholds_met,
            'classification_report': classification_report(y_true, y_pred)
        }

        return report
```

### Stage 6: Model Deployment

```python
# model_deployment.py
import mlflow
import docker
import subprocess

class ModelDeployer:
    def __init__(self, registry_uri, model_name):
        mlflow.set_tracking_uri(registry_uri)
        self.model_name = model_name
        self.client = mlflow.tracking.MlflowClient()

    def get_production_model(self):
        """Get the current production model."""
        versions = self.client.get_latest_versions(
            self.model_name,
            stages=["Production"]
        )
        if versions:
            return versions[0]
        return None

    def transition_to_staging(self, version):
        """Transition model to staging."""
        self.client.transition_model_version_stage(
            name=self.model_name,
            version=version,
            stage="Staging"
        )
        print(f"Model {self.model_name} v{version} moved to Staging")

    def transition_to_production(self, version):
        """Transition model to production."""
        self.client.transition_model_version_stage(
            name=self.model_name,
            version=version,
            stage="Production"
        )
        print(f"Model {self.model_name} v{version} moved to Production")

    def rollback(self, target_version):
        """Rollback to a previous version."""
        # Move current production to archived
        current = self.get_production_model()
        if current:
            self.client.transition_model_version_stage(
                name=self.model_name,
                version=current.version,
                stage="Archived"
            )

        # Move target to production
        self.transition_to_production(target_version)
        print(f"Rolled back to version {target_version}")

    def deploy_with_docker(self, model_version, image_tag):
        """Deploy model using Docker."""
        # Download model artifact
        model_uri = f"models:/{self.model_name}/{model_version}"
        local_path = mlflow.artifacts.download_artifacts(model_uri)

        # Build Docker image
        client = docker.from_env()
        image = client.images.build(
            path=".",
            tag=f"model-server:{image_tag}"
        )

        # Run container
        container = client.containers.run(
            f"model-server:{image_tag}",
            detach=True,
            ports={'8000/tcp': 8000},
            environment={
                'MODEL_PATH': local_path
            }
        )

        return container.id
```

---

## Pipeline Orchestration with Airflow

```python
# dags/ml_pipeline.py
from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'ml-team',
    'depends_on_past': False,
    'start_date': datetime(2024, 1, 1),
    'email_on_failure': True,
    'email_on_retry': False,
    'retries': 2,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG(
    'ml_pipeline',
    default_args=default_args,
    description='End-to-end ML pipeline',
    schedule_interval='@weekly',
    catchup=False
)

def ingest_data(**context):
    from data_ingestion import DataIngestion
    config = {'sources': [{'type': 'database', 'connection_string': '...'}]}
    ingester = DataIngestion(config)
    data = ingester.run()
    context['ti'].xcom_push(key='raw_data', value=data.to_json())

def validate_data(**context):
    from data_validation import DataValidator
    import pandas as pd
    raw_data = pd.read_json(context['ti'].xcom_pull(task_ids='ingest'))
    validator = DataValidator()
    results = validator.run(raw_data)
    if not results['passed']:
        raise ValueError("Data validation failed")

def engineer_features(**context):
    from feature_engineering import FeatureEngineer
    import pandas as pd
    raw_data = pd.read_json(context['ti'].xcom_pull(task_ids='ingest'))
    config = {'features': [{'type': 'temporal', 'timestamp_col': 'timestamp'}]}
    engineer = FeatureEngineer(config)
    features = engineer.run(raw_data)
    context['ti'].xcom_push(key='features', value=features.to_json())

def train_model(**context):
    from model_training import ModelTrainer
    import pandas as pd
    features = pd.read_json(context['ti'].xcom_pull(task_ids='engineer_features'))
    X = features.drop('target', axis=1)
    y = features['target']
    trainer = ModelTrainer(experiment_name='production_pipeline')
    results = trainer.compare_models(X, y)
    best = trainer.select_best_model(results)
    context['ti'].xcom_push(key='best_model', value=best['run_id'])

def evaluate_model(**context):
    from model_evaluation import ModelEvaluator
    evaluator = ModelEvaluator()
    # Load test data and evaluate
    # Check thresholds before deployment

def deploy_model(**context):
    from model_deployment import ModelDeployer
    deployer = ModelDeployer('mlflow-server', 'production_model')
    deployer.transition_to_staging(new_version)
    # After validation
    deployer.transition_to_production(new_version)

# Define tasks
ingest = PythonOperator(
    task_id='ingest',
    python_callable=ingest_data,
    dag=dag
)

validate = PythonOperator(
    task_id='validate',
    python_callable=validate_data,
    dag=dag
)

engineer = PythonOperator(
    task_id='engineer_features',
    python_callable=engineer_features,
    dag=dag
)

train = PythonOperator(
    task_id='train',
    python_callable=train_model,
    dag=dag
)

evaluate = PythonOperator(
    task_id='evaluate',
    python_callable=evaluate_model,
    dag=dag
)

deploy = PythonOperator(
    task_id='deploy',
    python_callable=deploy_model,
    dag=dag
)

# Set dependencies
ingest >> validate >> engineer >> train >> evaluate >> deploy
```

---

## Summary

MLOps pipelines automate the ML lifecycle. Key components:
- Data ingestion and validation
- Feature engineering and storage
- Model training with experiment tracking
- Model evaluation and comparison
- Deployment with versioning and rollback
- Monitoring and alerting
