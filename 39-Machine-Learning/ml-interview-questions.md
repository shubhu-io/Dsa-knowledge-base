# Advanced ML Interview Questions

## Table of Contents

1. [Ensemble Methods](#ensemble-methods)
2. [Feature Engineering](#feature-engineering)
3. [Model Selection](#model-selection)
4. [Advanced Concepts](#advanced-concepts)
5. [Practical Questions](#practical-questions)

---

## Ensemble Methods

### 1. Explain the difference between Bagging and Boosting

**Answer:**

| Aspect | Bagging | Boosting |
|--------|---------|----------|
| **Training** | Parallel, independent | Sequential, each corrects previous |
| **Data Sampling** | Bootstrap with replacement | Weighted, focus on errors |
| **Voting** | Average/Majority | Weighted average |
| **Bias/Variance** | Reduces variance | Reduces bias |
| **Overfitting** | Less prone | More prone |
| **Example** | Random Forest | XGBoost, AdaBoost |

```python
# Bagging - Random Forest
from sklearn.ensemble import RandomForestClassifier
rf = RandomForestClassifier(n_estimators=100, random_state=42)

# Boosting - XGBoost
import xgboost as xgb
xgb_model = xgb.XGBClassifier(n_estimators=100, learning_rate=0.1)
```

### 2. How does XGBoost handle missing values?

**Answer:**
- XGBoost learns the best direction (left/right) to send missing values at each split
- No need for imputation before training
- During training, it considers missing values as a separate category
- Handles both training and test data missing values

```python
import xgboost as xgb
import numpy as np

# XGBoost handles missing values natively
X_train = np.array([[1, np.nan], [2, 3], [np.nan, 4], [5, 6]])
y_train = np.array([0, 1, 0, 1])

model = xgb.XGBClassifier()
model.fit(X_train, y_train)
# No imputation needed!
```

### 3. What is the out-of-bag (OOB) score in Random Forest?

**Answer:**
- Each tree is trained on ~63.2% of data (bootstrap sample)
- Remaining ~36.8% is "out-of-bag" data
- OOB score uses these out-of-bag samples for validation
- No separate validation set needed

```python
from sklearn.ensemble import RandomForestClassifier

# OOB score calculation
rf = RandomForestClassifier(n_estimators=100, oob_score=True, random_state=42)
rf.fit(X_train, y_train)
print(f"OOB Score: {rf.oob_score_}")
```

---

## Feature Engineering

### 1. How do you handle high cardinality categorical features?

**Answer:**

| Method | Description | Use Case |
|--------|-------------|----------|
| **Target Encoding** | Replace with target mean | When target correlates with category |
| **Frequency Encoding** | Replace with frequency | When frequency matters |
| **Hash Encoding** | Hash categories to fixed space | Many categories |
| **Leave-One-Out** | Avoid leakage | Small datasets |
| **Binary Encoding** | Binary representation | Medium cardinality |

```python
import pandas as pd
import numpy as np

def target_encode(train, test, col, target, alpha=1.0):
    global_mean = train[target].mean()
    
    # Calculate mean target for each category
    means = train.groupby(col)[target].agg(['mean', 'count'])
    
    # Bayesian smoothing
    smooth = (means['count'] * means['mean'] + alpha * global_mean) / (means['count'] + alpha)
    
    train[col + '_encoded'] = train[col].map(smooth)
    test[col + '_encoded'] = test[col].map(smooth)
    
    return train, test
```

### 2. Explain the difference between L1 and L2 regularization

**Answer:**

| Aspect | L1 (Lasso) | L2 (Ridge) |
|--------|------------|------------|
| **Penalty** | Sum of absolute weights | Sum of squared weights |
| **Sparsity** | Creates sparse solutions | Shrinks all weights |
| **Feature Selection** | Yes | No |
| **Multicollinearity** | Selects one feature | Keeps all features |
| **Solution** | May not have unique solution | Always unique solution |

```python
from sklearn.linear_model import Lasso, Ridge

# L1 Regularization (Lasso) - creates sparsity
lasso = Lasso(alpha=0.1)
lasso.fit(X_train, y_train)
print(f"Non-zero features: {np.sum(lasso.coef_ != 0)}")

# L2 Regularization (Ridge) - shrinks all coefficients
ridge = Ridge(alpha=0.1)
ridge.fit(X_train, y_train)
print(f"All coefficients: {ridge.coef_}")
```

### 3. When would you use feature hashing?

**Answer:**
- High cardinality categorical features
- Text features with large vocabulary
- Memory constraints
- Online learning scenarios

```python
from sklearn.feature_extraction import FeatureHasher

# Feature hashing for text
hasher = FeatureHasher(n_features=2**10, input_type='dict')
texts = [{"word1": 1, "word2": 1}, {"word2": 1, "word3": 1}]
hashed = hasher.transform(texts).toarray()
```

---

## Model Selection

### 1. How do you choose between XGBoost, LightGBM, and CatBoost?

**Answer:**

| Model | Speed | Categorical | Accuracy | Use Case |
|-------|-------|-------------|----------|----------|
| **XGBoost** | Medium | No | High | General purpose, competitions |
| **LightGBM** | Fast | Yes | High | Large datasets |
| **CatBoost** | Medium | Yes | High | Categorical features |

```python
# XGBoost - Best for competitions
import xgboost as xgb
xgb_model = xgb.XGBClassifier(
    n_estimators=1000,
    learning_rate=0.01,
    max_depth=6,
    subsample=0.8,
    colsample_bytree=0.8
)

# LightGBM - Best for large datasets
import lightgbm as lgb
lgb_model = lgb.LGBMClassifier(
    n_estimators=1000,
    learning_rate=0.01,
    num_leaves=31,
    feature_fraction=0.8,
    bagging_fraction=0.8
)

# CatBoost - Best for categorical features
import catboost as cb
cb_model = cb.CatBoostClassifier(
    iterations=1000,
    learning_rate=0.01,
    depth=6,
    verbose=0
)
```

### 2. How do you detect and handle model overfitting?

**Answer:**

**Detection Methods:**
```python
from sklearn.model_selection import learning_curve, validation_curve
import numpy as np

def plot_learning_curve(model, X, y):
    train_sizes, train_scores, val_scores = learning_curve(
        model, X, y, cv=5, n_jobs=-1,
        train_sizes=np.linspace(0.1, 1.0, 10)
    )
    
    train_mean = np.mean(train_scores, axis=1)
    train_std = np.std(train_scores, axis=1)
    val_mean = np.mean(val_scores, axis=1)
    val_std = np.std(val_scores, axis=1)
    
    # Large gap = overfitting
    return train_mean, val_mean
```

**Handling Overfitting:**
1. Regularization (L1/L2)
2. Cross-validation
3. Early stopping
4. Reduce model complexity
5. More training data
6. Feature selection
7. Dropout (neural networks)

### 3. Explain the bias-variance tradeoff

**Answer:**

```
Total Error = Bias² + Variance + Irreducible Error

High Bias (Underfitting):
- Model too simple
- High training error
- High validation error
- Solution: More complex model, more features

High Variance (Overfitting):
- Model too complex
- Low training error
- High validation error
- Solution: Regularization, more data, simpler model
```

```python
from sklearn.model_selection import cross_val_score
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import PolynomialFeatures
from sklearn.linear_model import LinearRegression

def bias_variance_analysis(X, y):
    degrees = [1, 3, 5, 10, 15]
    train_scores = []
    val_scores = []
    
    for degree in degrees:
        model = make_pipeline(
            PolynomialFeatures(degree),
            LinearRegression()
        )
        
        train_score = cross_val_score(model, X, y, cv=5, scoring='r2')
        val_score = cross_val_score(model, X, y, cv=5, scoring='r2')
        
        train_scores.append(train_score.mean())
        val_scores.append(val_score.mean())
    
    return degrees, train_scores, val_scores
```

---

## Advanced Concepts

### 1. What is stacking and how does it work?

**Answer:**
Stacking combines multiple models using a meta-learner:

```python
from sklearn.model_selection import cross_val_predict
from sklearn.linear_model import LogisticRegression
import numpy as np

class StackingClassifier:
    def __init__(self, base_models, meta_model):
        self.base_models = base_models
        self.meta_model = meta_model
    
    def fit(self, X, y):
        # Generate base model predictions
        meta_features = np.zeros((len(X), len(self.base_models)))
        
        for i, model in enumerate(self.base_models):
            meta_features[:, i] = cross_val_predict(model, X, y, cv=5, method='predict_proba')[:, 1]
            model.fit(X, y)  # Refit on full data
        
        # Train meta-model
        self.meta_model.fit(meta_features, y)
        return self
    
    def predict(self, X):
        meta_features = np.zeros((len(X), len(self.base_models)))
        for i, model in enumerate(self.base_models):
            meta_features[:, i] = model.predict_proba(X)[:, 1]
        
        return self.meta_model.predict(meta_features)
```

### 2. Explain SHAP values

**Answer:**
SHAP (SHapley Additive exPlanations) uses game theory to explain predictions:

```python
import shap
import xgboost as xgb

# Train model
model = xgb.XGBClassifier()
model.fit(X_train, y_train)

# Create SHAP explainer
explainer = shap.TreeExplainer(model)
shap_values = explainer.shap_values(X_test)

# Global feature importance
shap.summary_plot(shap_values, X_test)

# Local explanation for single prediction
shap.force_plot(explainer.expected_value, shap_values[0], X_test[0])
```

**Key Properties:**
1. **Local accuracy**: Explanation matches model prediction
2. **Missingness**: No features = no explanation
3. **Consistency**: If feature importance increases, attribution increases

### 3. What is quantile regression?

**Answer:**
Predicts specific quantiles (e.g., median, 90th percentile) instead of mean:

```python
from sklearn.ensemble import GradientBoostingRegressor
import numpy as np

# Quantile regression for prediction intervals
model_low = GradientBoostingRegressor(loss='quantile', alpha=0.1)
model_med = GradientBoostingRegressor(loss='quantile', alpha=0.5)
model_high = GradientBoostingRegressor(loss='quantile', alpha=0.9)

model_low.fit(X_train, y_train)
model_med.fit(X_train, y_train)
model_high.fit(X_train, y_train)

# Prediction interval
pred_low = model_low.predict(X_test)
pred_med = model_med.predict(X_test)
pred_high = model_high.predict(X_test)
```

---

## Practical Questions

### 1. Design a churn prediction system

**Answer:**

```python
# Pipeline
from sklearn.pipeline import Pipeline
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.ensemble import GradientBoostingClassifier
from sklearn.model_selection import train_test_split
import pandas as pd

# Feature engineering
def create_features(df):
    # Recency features
    df['days_since_last_activity'] = (pd.Timestamp.now() - df['last_activity']).dt.days
    
    # Frequency features
    df['avg_monthly_usage'] = df['total_usage'] / df['months_active']
    
    # Monetary features
    df['avg_monthly_spend'] = df['total_spend'] / df['months_active']
    
    return df

# Build pipeline
numerical_features = ['days_since_last_activity', 'avg_monthly_usage', 'avg_monthly_spend']
categorical_features = ['plan_type', 'payment_method']

preprocessor = ColumnTransformer([
    ('num', StandardScaler(), numerical_features),
    ('cat', OneHotEncoder(handle_unknown='ignore'), categorical_features)
])

pipeline = Pipeline([
    ('preprocessor', preprocessor),
    ('classifier', GradientBoostingClassifier(random_state=42))
])

# Train and evaluate
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
pipeline.fit(X_train, y_train)
score = pipeline.score(X_test, y_test)
```

### 2. Handle imbalanced dataset

**Answer:**

```python
from imblearn.over_sampling import SMOTE
from imblearn.under_sampling import RandomUnderSampler
from imblearn.pipeline import Pipeline as ImbPipeline
from sklearn.ensemble import RandomForestClassifier

# Method 1: SMOTE + Undersampling
resampling_pipeline = ImbPipeline([
    ('under', RandomUnderSampler(sampling_strategy=0.5)),
    ('smote', SMOTE(sampling_strategy=1.0)),
    ('classifier', RandomForestClassifier(random_state=42))
])

# Method 2: Class weights
from sklearn.utils.class_weight import compute_class_weight
weights = compute_class_weight('balanced', classes=np.unique(y_train), y=y_train)
class_weights = dict(zip(np.unique(y_train), weights))

# Method 3: Cost-sensitive learning
model = RandomForestClassifier(class_weight='balanced', random_state=42)

# Method 4: Threshold adjustment
from sklearn.metrics import precision_recall_curve
precision, recall, thresholds = precision_recall_curve(y_val, y_prob)
f1_scores = 2 * (precision * recall) / (precision + recall)
optimal_threshold = thresholds[np.argmax(f1_scores)]
```

### 3. Feature importance comparison

**Answer:**

```python
from sklearn.inspection import permutation_importance
import shap
import numpy as np

def compare_feature_importance(model, X, y, feature_names):
    results = {}
    
    # 1. Built-in importance (tree-based)
    if hasattr(model, 'feature_importances_'):
        results['built_in'] = dict(zip(feature_names, model.feature_importances_))
    
    # 2. Permutation importance
    perm_importance = permutation_importance(model, X, y, n_repeats=10, random_state=42)
    results['permutation'] = dict(zip(feature_names, perm_importance.importances_mean))
    
    # 3. SHAP values
    explainer = shap.TreeExplainer(model)
    shap_values = explainer.shap_values(X)
    results['shap'] = dict(zip(feature_names, np.abs(shap_values).mean(axis=0)))
    
    return results
```

---

## Quick Reference

| Concept | Key Point |
|---------|-----------|
| Bagging | Reduce variance, parallel training |
| Boosting | Reduce bias, sequential training |
| XGBoost | Gradient boosting with regularization |
| LightGBM | Fast, histogram-based, leaf-wise growth |
| CatBoost | Handles categorical features natively |
| Stacking | Combine models with meta-learner |
| SHAP | Game-theoretic model explanations |
| Target Encoding | Replace category with target mean |
