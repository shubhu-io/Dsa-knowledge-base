# Advanced Machine Learning Guide

## Table of Contents

1. [Ensemble Methods](#ensemble-methods)
2. [Advanced Regularization](#advanced-regularization)
3. [Model Interpretability](#model-interpretability)
4. [AutoML](#automl)
5. [Advanced Techniques](#advanced-techniques)

---

## Ensemble Methods

### Bagging (Bootstrap Aggregating)

```python
from sklearn.ensemble import BaggingClassifier, RandomForestClassifier
from sklearn.tree import DecisionTreeClassifier
import numpy as np

class BaggingEnsemble:
    def __init__(self, base_estimator, n_estimators=10):
        self.base_estimator = base_estimator
        self.n_estimators = n_estimators
        self.estimators = []
        self.features_indices = []
    
    def fit(self, X, y):
        n_samples, n_features = X.shape
        
        for _ in range(self.n_estimators):
            # Bootstrap sampling
            indices = np.random.choice(n_samples, n_samples, replace=True)
            X_bootstrap = X[indices]
            y_bootstrap = y[indices]
            
            # Random feature subset
            feature_indices = np.random.choice(n_features, int(np.sqrt(n_features)), replace=False)
            X_subset = X_bootstrap[:, feature_indices]
            
            # Train estimator
            estimator = clone(self.base_estimator)
            estimator.fit(X_subset, y_bootstrap)
            
            self.estimators.append(estimator)
            self.features_indices.append(feature_indices)
    
    def predict(self, X):
        predictions = []
        for estimator, features in zip(self.estimators, self.features_indices):
            X_subset = X[:, features]
            predictions.append(estimator.predict(X_subset))
        
        # Majority voting
        return np.apply_along_axis(lambda x: np.bincount(x).argmax(), 0, predictions)

# Using scikit-learn
bagging = BaggingClassifier(
    base_estimator=DecisionTreeClassifier(),
    n_estimators=100,
    max_samples=0.8,
    max_features=0.8,
    random_state=42
)
```

### Random Forest

```python
from sklearn.ensemble import RandomForestClassifier, RandomForestRegressor
from sklearn.model_selection import cross_val_score
import numpy as np

class AdvancedRandomForest:
    def __init__(self, n_estimators=100, max_depth=None, min_samples_split=2):
        self.n_estimators = n_estimators
        self.max_depth = max_depth
        self.min_samples_split = min_samples_split
        self.estimators = []
        self.feature_importances_ = None
    
    def fit(self, X, y):
        n_samples, n_features = X.shape
        self.feature_importances_ = np.zeros(n_features)
        
        for _ in range(self.n_estimators):
            # Bootstrap sampling
            indices = np.random.choice(n_samples, n_samples, replace=True)
            X_bootstrap, y_bootstrap = X[indices], y[indices]
            
            # Train tree with random feature selection
            tree = DecisionTreeClassifier(
                max_depth=self.max_depth,
                min_samples_split=self.min_samples_split,
                max_features='sqrt'
            )
            tree.fit(X_bootstrap, y_bootstrap)
            self.estimators.append(tree)
            
            # Accumulate feature importances
            self.feature_importances_ += tree.feature_importances_
        
        self.feature_importances_ /= self.n_estimators
    
    def predict(self, X):
        predictions = np.array([est.predict(X) for est in self.estimators])
        return np.apply_along_axis(lambda x: np.bincount(x).argmax(), 0, predictions)
    
    def feature_importance(self, feature_names=None):
        if feature_names is None:
            feature_names = [f"feature_{i}" for i in range(len(self.feature_importances_))]
        
        importance_dict = dict(zip(feature_names, self.feature_importances_))
        return sorted(importance_dict.items(), key=lambda x: x[1], reverse=True)
```

### Gradient Boosting

```python
import numpy as np
from sklearn.tree import DecisionTreeRegressor

class GradientBoostingRegressor:
    def __init__(self, n_estimators=100, learning_rate=0.1, max_depth=3):
        self.n_estimators = n_estimators
        self.learning_rate = learning_rate
        self.max_depth = max_depth
        self.estimators = []
        self.initial_prediction = None
    
    def fit(self, X, y):
        # Initial prediction (mean)
        self.initial_prediction = np.mean(y)
        predictions = np.full(len(y), self.initial_prediction)
        
        for _ in range(self.n_estimators):
            # Compute residuals (negative gradient)
            residuals = y - predictions
            
            # Fit tree to residuals
            tree = DecisionTreeRegressor(max_depth=self.max_depth)
            tree.fit(X, residuals)
            self.estimators.append(tree)
            
            # Update predictions
            update = tree.predict(X)
            predictions += self.learning_rate * update
    
    def predict(self, X):
        predictions = np.full(X.shape[0], self.initial_prediction)
        for tree in self.estimators:
            predictions += self.learning_rate * tree.predict(X)
        return predictions
```

### XGBoost

```python
import xgboost as xgb
from sklearn.model_selection import GridSearchCV
import numpy as np

class XGBoostPipeline:
    def __init__(self):
        self.model = None
        self.best_params = None
    
    def train(self, X_train, y_train, X_val=None, y_val=None):
        params = {
            'max_depth': 6,
            'learning_rate': 0.1,
            'n_estimators': 1000,
            'min_child_weight': 1,
            'subsample': 0.8,
            'colsample_bytree': 0.8,
            'objective': 'binary:logistic',
            'eval_metric': 'logloss'
        }
        
        self.model = xgb.XGBClassifier(**params)
        
        eval_set = [(X_train, y_train)]
        if X_val is not None:
            eval_set.append((X_val, y_val))
        
        self.model.fit(
            X_train, y_train,
            eval_set=eval_set,
            early_stopping_rounds=50,
            verbose=False
        )
        
        return self.model
    
    def hyperparameter_tuning(self, X, y):
        param_grid = {
            'max_depth': [3, 6, 9],
            'learning_rate': [0.01, 0.1, 0.3],
            'n_estimators': [100, 500, 1000],
            'min_child_weight': [1, 3, 5],
            'subsample': [0.7, 0.8, 0.9],
            'colsample_bytree': [0.7, 0.8, 0.9]
        }
        
        grid_search = GridSearchCV(
            xgb.XGBClassifier(),
            param_grid,
            cv=5,
            scoring='accuracy',
            n_jobs=-1,
            verbose=1
        )
        
        grid_search.fit(X, y)
        self.best_params = grid_search.best_params_
        
        return grid_search.best_estimator_
```

---

## Advanced Regularization

### Elastic Net

```python
from sklearn.linear_model import ElasticNet, ElasticNetCV
import numpy as np

class ElasticNetModel:
    def __init__(self, l1_ratio=0.5, alpha=1.0):
        self.model = ElasticNet(l1_ratio=l1_ratio, alpha=alpha)
    
    def fit(self, X, y):
        self.model.fit(X, y)
        return self
    
    def predict(self, X):
        return self.model.predict(X)
    
    def cross_validate_alpha(self, X, y, alphas=None):
        if alphas is None:
            alphas = np.logspace(-4, 4, 100)
        
        cv_model = ElasticNetCV(
            l1_ratio=[0.1, 0.5, 0.7, 0.9, 0.95, 1],
            alphas=alphas,
            cv=5,
            random_state=42
        )
        cv_model.fit(X, y)
        
        return cv_model.alpha_, cv_model.l1_ratio_, cv_model
```

### Bayesian Ridge Regression

```python
from sklearn.linear_model import BayesianRidge
import numpy as np

class BayesianRegression:
    def __init__(self):
        self.model = BayesianRidge()
    
    def fit(self, X, y):
        self.model.fit(X, y)
        return self
    
    def predict_with_uncertainty(self, X):
        mean, std = self.model.predict(X, return_std=True)
        return mean, std
    
    def get_posterior(self):
        return self.model.coef_, self.model.sigma_
```

---

## Model Interpretability

### SHAP (SHapley Additive exPlanations)

```python
import shap
import numpy as np
from sklearn.ensemble import RandomForestClassifier

class SHAPExplainer:
    def __init__(self, model, X_train):
        self.model = model
        self.explainer = shap.TreeExplainer(model)
        self.shap_values = None
    
    def compute_shap_values(self, X):
        self.shap_values = self.explainer.shap_values(X)
        return self.shap_values
    
    def summary_plot(self, X):
        shap.summary_plot(self.shap_values, X)
    
    def dependence_plot(self, feature_idx, X):
        shap.dependence_plot(feature_idx, self.shap_values, X)
    
    def force_plot(self, X_instance):
        shap.force_plot(
            self.explainer.expected_value,
            self.shap_values[0],
            X_instance
        )

# Example usage
X_train, X_test = np.random.rand(100, 10), np.random.rand(20, 10)
y_train = (X_train.sum(axis=1) > 5).astype(int)

model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X_train, y_train)

explainer = SHAPExplainer(model, X_train)
shap_values = explainer.compute_shap_values(X_test)
explainer.summary_plot(X_test)
```

### LIME (Local Interpretable Model-agnostic Explanations)

```python
import lime
import lime.lime_tabular
import numpy as np

class LIMEExplainer:
    def __init__(self, model, X_train, feature_names=None):
        self.model = model
        self.explainer = lime.lime_tabular.LimeTabularExplainer(
            X_train,
            feature_names=feature_names,
            mode='classification'
        )
    
    def explain_instance(self, X_instance, num_features=10):
        explanation = self.explainer.explain_instance(
            X_instance,
            self.model.predict_proba,
            num_features=num_features
        )
        return explanation
    
    def show_in_notebook(self, X_instance):
        explanation = self.explain_instance(X_instance)
        explanation.show_in_notebook()
```

### Permutation Feature Importance

```python
from sklearn.inspection import permutation_importance
import numpy as np

class PermutationImportance:
    def __init__(self, model, X_val, y_val):
        self.model = model
        self.X_val = X_val
        self.y_val = y_val
        self.importances = None
    
    def compute(self, n_repeats=10):
        result = permutation_importance(
            self.model, self.X_val, self.y_val,
            n_repeats=n_repeats, random_state=42
        )
        
        self.importances = {
            'mean': result.importances_mean,
            'std': result.importances_std
        }
        return self.importances
    
    def get_top_features(self, feature_names, n=10):
        if self.importances is None:
            self.compute()
        
        indices = np.argsort(self.importances['mean'])[::-1][:n]
        return [(feature_names[i], self.importances['mean'][i]) for i in indices]
```

---

## AutoML

### Automated Model Selection

```python
from sklearn.model_selection import cross_val_score
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
from sklearn.svm import SVC
from sklearn.neighbors import KNeighborsClassifier
import numpy as np

class AutoMLSelector:
    def __init__(self):
        self.models = {
            'logistic': LogisticRegression(max_iter=1000),
            'random_forest': RandomForestClassifier(n_estimators=100),
            'gradient_boosting': GradientBoostingClassifier(),
            'svm': SVC(),
            'knn': KNeighborsClassifier()
        }
        self.results = {}
    
    def evaluate_models(self, X, y, cv=5):
        for name, model in self.models.items():
            scores = cross_val_score(model, X, y, cv=cv, scoring='accuracy')
            self.results[name] = {
                'mean': scores.mean(),
                'std': scores.std(),
                'scores': scores
            }
        
        return self.results
    
    def get_best_model(self):
        best_name = max(self.results, key=lambda k: self.results[k]['mean'])
        return best_name, self.models[best_name], self.results[best_name]
    
    def compare_models(self):
        return sorted(self.results.items(), key=lambda x: x[1]['mean'], reverse=True)
```

### Automated Hyperparameter Tuning

```python
import optuna
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import cross_val_score

class AutoTuner:
    def __init__(self, X, y):
        self.X = X
        self.y = y
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
        scores = cross_val_score(model, self.X, self.y, cv=5, scoring='accuracy')
        
        return scores.mean()
    
    def optimize(self, n_trials=100):
        study = optuna.create_study(direction='maximize')
        study.optimize(self.objective, n_trials=n_trials)
        
        self.best_params = study.best_params
        self.best_score = study.best_value
        
        return study.best_params, study.best_value
```

---

## Advanced Techniques

### Stacking

```python
from sklearn.model_selection import cross_val_predict
from sklearn.linear_model import LogisticRegression
import numpy as np

class StackingEnsemble:
    def __init__(self, base_models, meta_model):
        self.base_models = base_models
        self.meta_model = meta_model
        self.base_predictions = None
    
    def fit(self, X, y):
        # Generate base model predictions using cross-validation
        self.base_predictions = np.zeros((len(X), len(self.base_models)))
        
        for i, model in enumerate(self.base_models):
            self.base_predictions[:, i] = cross_val_predict(model, X, y, cv=5)
            model.fit(X, y)  # Refit on full data
        
        # Train meta-model on base predictions
        self.meta_model.fit(self.base_predictions, y)
        
        return self
    
    def predict(self, X):
        # Get base model predictions
        base_preds = np.zeros((len(X), len(self.base_models)))
        for i, model in enumerate(self.base_models):
            base_preds[:, i] = model.predict(X)
        
        # Meta-model prediction
        return self.meta_model.predict(base_preds)
```

### Blending

```python
import numpy as np
from sklearn.model_selection import train_test_split

class BlendingEnsemble:
    def __init__(self, base_models, meta_model, test_size=0.2):
        self.base_models = base_models
        self.meta_model = meta_model
        self.test_size = test_size
        self.base_predictions = None
    
    def fit(self, X, y):
        # Split data
        X_train, X_blend, y_train, y_blend = train_test_split(
            X, y, test_size=self.test_size, random_state=42
        )
        
        # Train base models and generate blending predictions
        self.base_predictions = np.zeros((len(X_blend), len(self.base_models)))
        
        for i, model in enumerate(self.base_models):
            model.fit(X_train, y_train)
            self.base_predictions[:, i] = model.predict_proba(X_blend)[:, 1]
        
        # Train meta-model
        self.meta_model.fit(self.base_predictions, y_blend)
        
        # Retrain base models on full data
        for model in self.base_models:
            model.fit(X, y)
        
        return self
    
    def predict(self, X):
        base_preds = np.zeros((len(X), len(self.base_models)))
        for i, model in enumerate(self.base_models):
            base_preds[:, i] = model.predict_proba(X)[:, 1]
        
        return self.meta_model.predict(base_preds)
```

---

## Summary

| Technique | Purpose | Key Benefit |
|-----------|---------|-------------|
| Random Forest | Reduce variance | Robust to overfitting |
| Gradient Boosting | Reduce bias | High accuracy |
| XGBoost | Optimized boosting | Speed and performance |
| SHAP | Model interpretation | Feature importance |
| LIME | Local explanations | Instance-level insights |
| AutoML | Automation | Faster development |
| Stacking | Combine models | Better performance |
