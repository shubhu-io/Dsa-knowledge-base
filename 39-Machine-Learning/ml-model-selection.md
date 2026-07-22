# Model Selection Guide

## Table of Contents

1. [Model Comparison](#model-comparison)
2. [Evaluation Metrics](#evaluation-metrics)
3. [Cross-Validation](#cross-validation)
4. [Hyperparameter Tuning](#hyperparameter-tuning)
5. [Model Selection Strategies](#model-selection-strategies)

---

## Model Comparison

### Supervised Learning Models

| Model | Type | Pros | Cons | Use Case |
|-------|------|------|------|----------|
| Linear Regression | Regression | Simple, interpretable | Assumes linearity | Baseline, linear relationships |
| Logistic Regression | Classification | Probabilistic output | Linear decision boundary | Binary classification |
| Decision Trees | Both | Interpretable, handles non-linear | Overfitting | Exploratory analysis |
| Random Forest | Both | Robust, feature importance | Less interpretable | General purpose |
| Gradient Boosting | Both | High accuracy | Computationally expensive | Competitions |
| SVM | Both | Effective in high dimensions | Slow on large data | Text classification |
| KNN | Both | No training phase | Slow prediction | Small datasets |
| Naive Bayes | Classification | Fast, works with small data | Independence assumption | Text classification |

### Implementation Comparison

```python
from sklearn.linear_model import LogisticRegression, LinearRegression
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
from sklearn.svm import SVC
from sklearn.neighbors import KNeighborsClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.tree import DecisionTreeClassifier
from sklearn.model_selection import cross_val_score
import numpy as np

class ModelComparison:
    def __init__(self):
        self.models = {
            'Logistic Regression': LogisticRegression(max_iter=1000),
            'Decision Tree': DecisionTreeClassifier(),
            'Random Forest': RandomForestClassifier(n_estimators=100),
            'Gradient Boosting': GradientBoostingClassifier(),
            'SVM': SVC(),
            'KNN': KNeighborsClassifier(),
            'Naive Bayes': GaussianNB()
        }
        self.results = {}
    
    def compare(self, X, y, cv=5, scoring='accuracy'):
        for name, model in self.models.items():
            scores = cross_val_score(model, X, y, cv=cv, scoring=scoring)
            self.results[name] = {
                'mean': scores.mean(),
                'std': scores.std(),
                'scores': scores
            }
        
        return self.results
    
    def rank_models(self):
        return sorted(self.results.items(), key=lambda x: x[1]['mean'], reverse=True)
    
    def get_best_model(self):
        best_name = max(self.results, key=lambda k: self.results[k]['mean'])
        return best_name, self.models[best_name]
```

---

## Evaluation Metrics

### Classification Metrics

```python
from sklearn.metrics import (
    accuracy_score, precision_score, recall_score, f1_score,
    roc_auc_score, confusion_matrix, classification_report,
    log_loss, matthews_corrcoef
)
import numpy as np

class ClassificationMetrics:
    def __init__(self, y_true, y_pred, y_prob=None):
        self.y_true = y_true
        self.y_pred = y_pred
        self.y_prob = y_prob
    
    def accuracy(self):
        return accuracy_score(self.y_true, self.y_pred)
    
    def precision(self, average='weighted'):
        return precision_score(self.y_true, self.y_pred, average=average)
    
    def recall(self, average='weighted'):
        return recall_score(self.y_true, self.y_pred, average=average)
    
    def f1(self, average='weighted'):
        return f1_score(self.y_true, self.y_pred, average=average)
    
    def roc_auc(self):
        if self.y_prob is not None:
            return roc_auc_score(self.y_true, self.y_prob)
        return None
    
    def mcc(self):
        return matthews_corrcoef(self.y_true, self.y_pred)
    
    def logloss(self):
        if self.y_prob is not None:
            return log_loss(self.y_true, self.y_prob)
        return None
    
    def confusion_mat(self):
        return confusion_matrix(self.y_true, self.y_pred)
    
    def full_report(self):
        return classification_report(self.y_true, self.y_pred)
    
    def all_metrics(self):
        metrics = {
            'accuracy': self.accuracy(),
            'precision': self.precision(),
            'recall': self.recall(),
            'f1': self.f1(),
            'mcc': self.mcc()
        }
        if self.y_prob is not None:
            metrics['roc_auc'] = self.roc_auc()
            metrics['logloss'] = self.logloss()
        return metrics
```

### Regression Metrics

```python
from sklearn.metrics import (
    mean_squared_error, mean_absolute_error, r2_score,
    mean_absolute_percentage_error
)
import numpy as np

class RegressionMetrics:
    def __init__(self, y_true, y_pred):
        self.y_true = np.array(y_true)
        self.y_pred = np.array(y_pred)
    
    def mse(self):
        return mean_squared_error(self.y_true, self.y_pred)
    
    def rmse(self):
        return np.sqrt(self.mse())
    
    def mae(self):
        return mean_absolute_error(self.y_true, self.y_pred)
    
    def r2(self):
        return r2_score(self.y_true, self.y_pred)
    
    def adjusted_r2(self, n_features):
        n = len(self.y_true)
        return 1 - (1 - self.r2()) * (n - 1) / (n - n_features - 1)
    
    def mape(self):
        return mean_absolute_percentage_error(self.y_true, self.y_pred)
    
    def all_metrics(self):
        return {
            'mse': self.mse(),
            'rmse': self.rmse(),
            'mae': self.mae(),
            'r2': self.r2(),
            'mape': self.mape()
        }
```

### Metric Selection Guide

| Problem Type | Primary Metric | Secondary Metric |
|--------------|----------------|------------------|
| Binary Classification | F1-score, AUC-ROC | Accuracy, Precision |
| Multi-class Classification | F1-score (macro) | Accuracy, Log-loss |
| Imbalanced Classification | AUC-PR, F1 | Recall, Precision |
| Regression | RMSE, MAE | R², MAPE |
| Ranking | NDCG, MAP | Precision@k |
| Clustering | Silhouette, ARI | DB Index |

---

## Cross-Validation

### Standard Cross-Validation

```python
from sklearn.model_selection import (
    KFold, StratifiedKFold, TimeSeriesSplit,
    cross_val_score, cross_validate
)
import numpy as np

class CrossValidator:
    def __init__(self, model, X, y):
        self.model = model
        self.X = X
        self.y = y
    
    def kfold(self, n_splits=5, shuffle=True, random_state=42):
        kf = KFold(n_splits=n_splits, shuffle=shuffle, random_state=random_state)
        scores = cross_val_score(self.model, self.X, self.y, cv=kf, scoring='accuracy')
        return scores.mean(), scores.std()
    
    def stratified_kfold(self, n_splits=5, shuffle=True, random_state=42):
        skf = StratifiedKFold(n_splits=n_splits, shuffle=shuffle, random_state=random_state)
        scores = cross_val_score(self.model, self.X, self.y, cv=skf, scoring='accuracy')
        return scores.mean(), scores.std()
    
    def time_series_split(self, n_splits=5):
        tscv = TimeSeriesSplit(n_splits=n_splits)
        scores = cross_val_score(self.model, self.X, self.y, cv=tscv, scoring='accuracy')
        return scores.mean(), scores.std()
    
    def nested_cv(self, inner_cv=5, outer_cv=5):
        outer_scores = []
        
        outer_cv_obj = KFold(n_splits=outer_cv, shuffle=True, random_state=42)
        
        for train_idx, test_idx in outer_cv_obj.split(self.X):
            X_train, X_test = self.X[train_idx], self.X[test_idx]
            y_train, y_test = self.y[train_idx], self.y[test_idx]
            
            inner_cv_obj = KFold(n_splits=inner_cv, shuffle=True, random_state=42)
            scores = cross_val_score(self.model, X_train, y_train, cv=inner_cv_obj)
            
            self.model.fit(X_train, y_train)
            outer_scores.append(self.model.score(X_test, y_test))
        
        return np.mean(outer_scores), np.std(outer_scores)
```

### Cross-Validation Strategies

```python
from sklearn.model_selection import GroupKFold, LeaveOneGroupOut
import numpy as np

class AdvancedCV:
    def __init__(self, X, y, groups=None):
        self.X = X
        self.y = y
        self.groups = groups
    
    def group_kfold(self, n_splits=5):
        """For grouped data (e.g., multiple samples per subject)"""
        gkf = GroupKFold(n_splits=n_splits)
        scores = []
        
        for train_idx, test_idx in gkf.split(self.X, self.y, self.groups):
            self.model.fit(self.X[train_idx], self.y[train_idx])
            score = self.model.score(self.X[test_idx], self.y[test_idx])
            scores.append(score)
        
        return np.mean(scores), np.std(scores)
    
    def leave_one_group_out(self):
        """Leave-one-group-out cross-validation"""
        logo = LeaveOneGroupOut()
        scores = []
        
        for train_idx, test_idx in logo.split(self.X, self.y, self.groups):
            self.model.fit(self.X[train_idx], self.y[train_idx])
            score = self.model.score(self.X[test_idx], self.y[test_idx])
            scores.append(score)
        
        return np.mean(scores), np.std(scores)
```

---

## Hyperparameter Tuning

### Grid Search

```python
from sklearn.model_selection import GridSearchCV
from sklearn.ensemble import RandomForestClassifier
import numpy as np

class GridSearchTuner:
    def __init__(self, model, param_grid, cv=5):
        self.model = model
        self.param_grid = param_grid
        self.cv = cv
        self.grid_search = None
    
    def tune(self, X, y, scoring='accuracy'):
        self.grid_search = GridSearchCV(
            self.model,
            self.param_grid,
            cv=self.cv,
            scoring=scoring,
            n_jobs=-1,
            verbose=1,
            return_train_score=True
        )
        
        self.grid_search.fit(X, y)
        
        return {
            'best_params': self.grid_search.best_params_,
            'best_score': self.grid_search.best_score_,
            'best_estimator': self.grid_search.best_estimator_
        }
    
    def get_results_df(self):
        import pandas as pd
        return pd.DataFrame(self.grid_search.cv_results_)
```

### Random Search

```python
from sklearn.model_selection import RandomizedSearchCV
from scipy.stats import randint, uniform

class RandomSearchTuner:
    def __init__(self, model, param_distributions, n_iter=100, cv=5):
        self.model = model
        self.param_distributions = param_distributions
        self.n_iter = n_iter
        self.cv = cv
        self.random_search = None
    
    def tune(self, X, y, scoring='accuracy'):
        self.random_search = RandomizedSearchCV(
            self.model,
            self.param_distributions,
            n_iter=self.n_iter,
            cv=self.cv,
            scoring=scoring,
            n_jobs=-1,
            verbose=1,
            random_state=42
        )
        
        self.random_search.fit(X, y)
        
        return {
            'best_params': self.random_search.best_params_,
            'best_score': self.random_search.best_score_,
            'best_estimator': self.random_search.best_estimator_
        }
```

### Bayesian Optimization

```python
import optuna
from sklearn.model_selection import cross_val_score
from sklearn.ensemble import RandomForestClassifier
import numpy as np

class BayesianTuner:
    def __init__(self, X, y, cv=5):
        self.X = X
        self.y = y
        self.cv = cv
        self.best_params = None
        self.best_score = None
    
    def objective(self, trial):
        params = {
            'n_estimators': trial.suggest_int('n_estimators', 50, 500),
            'max_depth': trial.suggest_int('max_depth', 3, 20),
            'min_samples_split': trial.suggest_int('min_samples_split', 2, 20),
            'min_samples_leaf': trial.suggest_int('min_samples_leaf', 1, 10),
            'max_features': trial.suggest_categorical('max_features', ['sqrt', 'log2', None])
        }
        
        model = RandomForestClassifier(**params, random_state=42)
        scores = cross_val_score(model, self.X, self.y, cv=self.cv, scoring='accuracy')
        
        return scores.mean()
    
    def tune(self, n_trials=100):
        study = optuna.create_study(direction='maximize')
        study.optimize(self.objective, n_trials=n_trials, show_progress_bar=True)
        
        self.best_params = study.best_params
        self.best_score = study.best_value
        
        return study.best_params, study.best_value
    
    def plot_optimization_history(self):
        optuna.visualization.plot_optimization_history(study)
    
    def plot_param_importances(self):
        optuna.visualization.plot_param_importances(study)
```

---

## Model Selection Strategies

### Decision Flowchart

```
Start
  │
  ├── Is it classification or regression?
  │     ├── Classification
  │     │     ├── How much data? (< 1000 → SVM/KNN, > 1000 → Tree/GBM)
  │     │     ├── Need interpretability? (Yes → Decision Tree, No → Ensemble)
  │     │     └── High dimensional? (Yes → Linear SVM, No → RF/GBM)
  │     │
  │     └── Regression
  │           ├── Linear relationship? (Yes → Linear Reg, No → Tree/GBM)
  │           ├── Need interpretability? (Yes → Linear/Tree, No → Ensemble)
  │           └── Many features? (Yes → Regularized, No → Any)
  │
  └── Data characteristics
        ├── Missing values? (Tree-based handle better)
        ├── Categorical features? (CatBoost, LightGBM)
        └── Time series? (ARIMA, LSTM, Prophet)
```

### Model Selection Framework

```python
class ModelSelector:
    def __init__(self, X, y, task='classification'):
        self.X = X
        self.y = y
        self.task = task
        self.candidates = []
    
    def get_candidates(self):
        if self.task == 'classification':
            self.candidates = [
                ('Logistic Regression', LogisticRegression(max_iter=1000)),
                ('Random Forest', RandomForestClassifier(n_estimators=100)),
                ('Gradient Boosting', GradientBoostingClassifier()),
                ('XGBoost', xgb.XGBClassifier(use_label_encoder=False, eval_metric='logloss')),
                ('LightGBM', lgb.LGBMClassifier(verbose=-1))
            ]
        else:
            self.candidates = [
                ('Linear Regression', LinearRegression()),
                ('Random Forest', RandomForestRegressor(n_estimators=100)),
                ('Gradient Boosting', GradientBoostingRegressor()),
                ('XGBoost', xgb.XGBRegressor()),
                ('LightGBM', lgb.LGBMRegressor(verbose=-1))
            ]
        return self.candidates
    
    def evaluate_all(self, cv=5):
        results = {}
        for name, model in self.candidates:
            scores = cross_val_score(model, self.X, self.y, cv=cv, scoring='accuracy')
            results[name] = {'mean': scores.mean(), 'std': scores.std()}
        return results
    
    def select_best(self, cv=5, metric='accuracy'):
        results = self.evaluate_all(cv)
        best_name = max(results, key=lambda k: results[k]['mean'])
        
        # Retrain best model on full data
        best_model = dict(self.candidates)[best_name]
        best_model.fit(self.X, self.y)
        
        return best_name, best_model, results
```

### Baseline Models

```python
class BaselineModels:
    def __init__(self):
        pass
    
    def dummy_classifier(self, X, y, strategy='most_frequent'):
        from sklearn.dummy import DummyClassifier
        dummy = DummyClassifier(strategy=strategy)
        scores = cross_val_score(dummy, X, y, cv=5)
        return scores.mean()
    
    def dummy_regressor(self, X, y, strategy='mean'):
        from sklearn.dummy import DummyRegressor
        dummy = DummyRegressor(strategy=strategy)
        scores = cross_val_score(dummy, X, y, cv=5, scoring='r2')
        return scores.mean()
    
    def majority_class_baseline(self, y):
        from collections import Counter
        majority_class = Counter(y).most_common(1)[0][0]
        accuracy = (y == majority_class).mean()
        return accuracy, majority_class
```

---

## Summary

| Strategy | When to Use | Pros | Cons |
|----------|-------------|------|------|
| Grid Search | Small parameter space | Exhaustive | Slow |
| Random Search | Large parameter space | Efficient | May miss optimum |
| Bayesian | Expensive models | Smart exploration | Complex setup |
| Nested CV | Unbiased evaluation | No data leakage | Computationally expensive |

### Best Practices

1. **Start simple** - Baseline first, complex models second
2. **Use appropriate metrics** - Match metric to business goal
3. **Cross-validate** - Never evaluate on test set during tuning
4. **Consider constraints** - Training time, inference time, interpretability
5. **Ensemble** - Combine multiple strong models
6. **Validate assumptions** - Check data distribution, feature relationships
