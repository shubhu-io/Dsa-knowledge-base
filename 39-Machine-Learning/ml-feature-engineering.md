# Feature Engineering Guide

## Table of Contents

1. [Feature Creation](#feature-creation)
2. [Feature Transformation](#feature-transformation)
3. [Feature Selection](#feature-selection)
4. [Advanced Techniques](#advanced-techniques)
5. [Best Practices](#best-practices)

---

## Feature Creation

### Numerical Features

```python
import pandas as pd
import numpy as np

class NumericalFeatureCreator:
    def __init__(self):
        self.feature_names = []
    
    def create_polynomial_features(self, X, degree=2):
        """Create polynomial and interaction features"""
        from sklearn.preprocessing import PolynomialFeatures
        poly = PolynomialFeatures(degree=degree, include_bias=False)
        return poly.fit_transform(X)
    
    def create_bin_features(self, X, n_bins=10):
        """Bin numerical features"""
        binned = np.zeros_like(X)
        for i in range(X.shape[1]):
            binned[:, i] = np.digitize(X[:, i], np.histogram_bin_edges(X[:, i], n_bins))
        return binned
    
    def create_log_features(self, X):
        """Apply log transformation"""
        return np.log1p(np.abs(X))
    
    def create_interaction_features(self, X):
        """Create pairwise interaction features"""
        n_features = X.shape[1]
        interactions = []
        
        for i in range(n_features):
            for j in range(i+1, n_features):
                interactions.append(X[:, i] * X[:, j])
        
        return np.column_stack([X] + interactions)
```

### Categorical Features

```python
class CategoricalFeatureCreator:
    def __init__(self):
        self.encodings = {}
    
    def target_encoding(self, X, y, alpha=1.0):
        """Encode categories using target statistics"""
        global_mean = y.mean()
        encoding = {}
        
        for category in X.unique():
            mask = X == category
            category_mean = y[mask].mean()
            category_count = mask.sum()
            
            # Bayesian smoothing
            encoding[category] = (category_count * category_mean + alpha * global_mean) / (category_count + alpha)
        
        self.encodings['target'] = encoding
        return X.map(encoding)
    
    def frequency_encoding(self, X):
        """Encode by frequency"""
        freq = X.value_counts(normalize=True)
        return X.map(freq)
    
    defWOEEncoding(self, X, y):
        """Weight of Evidence encoding"""
        df = pd.DataFrame({'feature': X, 'target': y})
        
        woedict = {}
        for category in df['feature'].unique():
            category_data = df[df['feature'] == category]
            good = (category_data['target'] == 1).sum() / (df['target'] == 1).sum()
            bad = (category_data['target'] == 0).sum() / (df['target'] == 0).sum()
            
            if good == 0 or bad == 0:
                woedict[category] = 0
            else:
                woedict[category] = np.log(good / bad)
        
        return X.map(woedict)
```

### Date/Time Features

```python
class DateTimeFeatureCreator:
    def __init__(self):
        pass
    
    def extract_features(self, df, datetime_col):
        """Extract comprehensive datetime features"""
        df = df.copy()
        dt = pd.to_datetime(df[datetime_col])
        
        df['year'] = dt.dt.year
        df['month'] = dt.dt.month
        df['day'] = dt.dt.day
        df['dayofweek'] = dt.dt.dayofweek
        df['dayofyear'] = dt.dt.dayofyear
        df['weekofyear'] = dt.dt.isocalendar().week.astype(int)
        df['quarter'] = dt.dt.quarter
        df['hour'] = dt.dt.hour
        df['minute'] = dt.dt.minute
        
        # Cyclical encoding
        df['month_sin'] = np.sin(2 * np.pi * df['month'] / 12)
        df['month_cos'] = np.cos(2 * np.pi * df['month'] / 12)
        df['day_sin'] = np.sin(2 * np.pi * df['day'] / 31)
        df['day_cos'] = np.cos(2 * np.pi * df['day'] / 31)
        
        # Is weekend/holiday
        df['is_weekend'] = df['dayofweek'].isin([5, 6]).astype(int)
        
        return df
    
    def create_lag_features(self, df, col, lags):
        """Create lag features for time series"""
        for lag in lags:
            df[f'{col}_lag_{lag}'] = df[col].shift(lag)
        return df
    
    def create_rolling_features(self, df, col, windows):
        """Create rolling window features"""
        for window in windows:
            df[f'{col}_rolling_mean_{window}'] = df[col].rolling(window).mean()
            df[f'{col}_rolling_std_{window}'] = df[col].rolling(window).std()
            df[f'{col}_rolling_min_{window}'] = df[col].rolling(window).min()
            df[f'{col}_rolling_max_{window}'] = df[col].rolling(window).max()
        return df
```

---

## Feature Transformation

### Scaling Methods

```python
from sklearn.preprocessing import StandardScaler, MinMaxScaler, RobustScaler
import numpy as np

class FeatureScaler:
    def __init__(self, method='standard'):
        self.method = method
        self.scaler = None
    
    def fit_transform(self, X):
        if self.method == 'standard':
            self.scaler = StandardScaler()
        elif self.method == 'minmax':
            self.scaler = MinMaxScaler()
        elif self.method == 'robust':
            self.scaler = RobustScaler()
        
        return self.scaler.fit_transform(X)
    
    def transform(self, X):
        return self.scaler.transform(X)
    
    def inverse_transform(self, X):
        return self.scaler.inverse_transform(X)

# Comparison table
"""
| Method | Formula | Use Case |
|--------|---------|----------|
| Standard | (x - μ) / σ | Gaussian distributed data |
| MinMax | (x - min) / (max - min) | Bounded range needed |
| Robust | (x - median) / IQR | Outlier presence |
"""
```

### Encoding Methods

```python
from sklearn.preprocessing import LabelEncoder, OneHotEncoder, OrdinalEncoder
import pandas as pd

class FeatureEncoder:
    def __init__(self):
        self.label_encoders = {}
        self.onehot_encoder = None
    
    def label_encode(self, X):
        """Label encoding for ordinal features"""
        le = LabelEncoder()
        encoded = le.fit_transform(X)
        self.label_encoders['label'] = le
        return encoded
    
    def onehot_encode(self, X, categories='auto'):
        """One-hot encoding for nominal features"""
        self.onehot_encoder = OneHotEncoder(categories=categories, sparse=False)
        return self.onehot_encoder.fit_transform(X.reshape(-1, 1) if X.ndim == 1 else X)
    
    def ordinal_encode(self, X, categories):
        """Ordinal encoding with custom order"""
        oe = OrdinalEncoder(categories=categories)
        return oe.fit_transform(X.reshape(-1, 1) if X.ndim == 1 else X)
    
    def binary_encode(self, X, n_bits):
        """Binary encoding"""
        encoded = np.zeros((len(X), n_bits))
        for i, val in enumerate(X):
            for j in range(n_bits):
                encoded[i, j] = (val >> j) & 1
        return encoded
```

### Power Transforms

```python
from sklearn.preprocessing import PowerTransformer
import numpy as np

class PowerTransformerCustom:
    def __init__(self, method='yeo-johnson'):
        self.method = method
        self.pt = PowerTransformer(method=method)
    
    def fit_transform(self, X):
        return self.pt.fit_transform(X)
    
    def transform(self, X):
        return self.pt.transform(X)

# Box-Cox (requires positive values)
# Yeo-Johnson (handles negative values)
# Log transform
# Square root transform
# Reciprocal transform
```

---

## Feature Selection

### Filter Methods

```python
from sklearn.feature_selection import SelectKBest, f_classif, mutual_info_classif
import numpy as np

class FilterFeatureSelector:
    def __init__(self, method='mutual_info'):
        self.method = method
        self.scores = None
    
    def select_features(self, X, y, k=10):
        if self.method == 'mutual_info':
            score_func = mutual_info_classif
        elif self.method == 'f_classif':
            score_func = f_classif
        
        selector = SelectKBest(score_func=score_func, k=k)
        X_selected = selector.fit_transform(X, y)
        
        self.scores = selector.scores_
        self.selected_indices = selector.get_support(indices=True)
        
        return X_selected
    
    def get_feature_scores(self, feature_names=None):
        if feature_names is None:
            feature_names = [f'feature_{i}' for i in range(len(self.scores))]
        
        return dict(zip(feature_names, self.scores))

# Correlation-based selection
def correlation_filter(X, threshold=0.95):
    """Remove highly correlated features"""
    corr_matrix = np.corrcoef(X.T)
    upper = np.triu(np.abs(corr_matrix), k=1)
    
    to_drop = set()
    for i in range(upper.shape[0]):
        for j in range(i+1, upper.shape[1]):
            if upper[i, j] > threshold:
                to_drop.add(j)
    
    return np.delete(X, list(to_drop), axis=1)
```

### Wrapper Methods

```python
from sklearn.feature_selection import RFE, RFECV
from sklearn.ensemble import RandomForestClassifier
import numpy as np

class WrapperFeatureSelector:
    def __init__(self, estimator=None):
        self.estimator = estimator or RandomForestClassifier(n_estimators=100)
    
    def recursive_feature_elimination(self, X, y, n_features=10):
        """RFE feature selection"""
        rfe = RFE(self.estimator, n_features_to_select=n_features, step=1)
        X_selected = rfe.fit_transform(X, y)
        
        self.selected_indices = rfe.get_support(indices=True)
        self.ranking = rfe.ranking_
        
        return X_selected
    
    def rfe_with_cv(self, X, y, cv=5):
        """RFE with cross-validation"""
        rfecv = RFECV(
            estimator=self.estimator,
            step=1,
            cv=cv,
            scoring='accuracy',
            min_features_to_select=1
        )
        X_selected = rfecv.fit_transform(X, y)
        
        self.selected_indices = rfecv.get_support(indices=True)
        self.optimal_features = rfecv.n_features_
        
        return X_selected
```

### Embedded Methods

```python
from sklearn.linear_model import LassoCV
from sklearn.feature_selection import SelectFromModel
import numpy as np

class EmbeddedFeatureSelector:
    def __init__(self, method='lasso'):
        self.method = method
        self.selector = None
    
    def lasso_selection(self, X, y, cv=5):
        """L1 regularization-based selection"""
        lasso = LassoCV(cv=cv, random_state=42)
        self.selector = SelectFromModel(lasso, prefit=False)
        X_selected = self.selector.fit_transform(X, y)
        
        self.selected_indices = self.selector.get_support(indices=True)
        return X_selected
    
    def tree_importance_selection(self, X, y, threshold='mean'):
        """Tree-based feature importance"""
        model = RandomForestClassifier(n_estimators=100, random_state=42)
        self.selector = SelectFromModel(model, threshold=threshold)
        X_selected = self.selector.fit_transform(X, y)
        
        self.selected_indices = self.selector.get_support(indices=True)
        return X_selected
```

---

## Advanced Techniques

### Feature Crosses

```python
class FeatureCrosses:
    def __init__(self):
        pass
    
    def create_cross_features(self, X, feature_pairs):
        """Create interaction features between specified pairs"""
        crosses = []
        for i, j in feature_pairs:
            cross = X[:, i] * X[:, j]
            crosses.append(cross)
        
        return np.column_stack([X] + crosses)
    
    def polynomial_crosses(self, X, degree=2):
        """Create all polynomial crosses up to degree"""
        from sklearn.preprocessing import PolynomialFeatures
        poly = PolynomialFeatures(degree=degree, include_bias=False, interaction_only=False)
        return poly.fit_transform(X)
    
    def hash_cross(self, X, n_bins=10):
        """Hash-based feature crossing"""
        n_features = X.shape[1]
        crosses = []
        
        for i in range(n_features):
            for j in range(i+1, n_features):
                # Simple hash crossing
                cross = (X[:, i] * 31 + X[:, j]) % n_bins
                crosses.append(cross.reshape(-1, 1))
        
        return np.column_stack([X] + crosses)
```

### Feature Hashing

```python
import numpy as np
from sklearn.feature_extraction import FeatureHasher

class FeatureHasherCustom:
    def __init__(self, n_features=2**10):
        self.n_features = n_features
        self.hasher = FeatureHasher(n_features=n_features, input_type='dict')
    
    def hash_categories(self, categories):
        """Hash categorical features"""
        dicts = []
        for cat in categories:
            dicts.append({cat: 1})
        return self.hasher.transform(dicts).toarray()
    
    def hash_text(self, texts):
        """Hash text features"""
        dicts = []
        for text in texts:
            word_counts = {}
            for word in text.split():
                word_counts[word] = word_counts.get(word, 0) + 1
            dicts.append(word_counts)
        return self.hasher.transform(dicts).toarray()
```

---

## Best Practices

### Feature Engineering Pipeline

```python
from sklearn.pipeline import Pipeline
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.impute import SimpleImputer

class FeatureEngineeringPipeline:
    def __init__(self, numerical_features, categorical_features):
        self.numerical_features = numerical_features
        self.categorical_features = categorical_features
        self.pipeline = self._create_pipeline()
    
    def _create_pipeline(self):
        numerical_pipeline = Pipeline([
            ('imputer', SimpleImputer(strategy='median')),
            ('scaler', StandardScaler())
        ])
        
        categorical_pipeline = Pipeline([
            ('imputer', SimpleImputer(strategy='most_frequent')),
            ('encoder', OneHotEncoder(handle_unknown='ignore'))
        ])
        
        return ColumnTransformer([
            ('numerical', numerical_pipeline, self.numerical_features),
            ('categorical', categorical_pipeline, self.categorical_features)
        ])
    
    def fit_transform(self, X, y=None):
        return self.pipeline.fit_transform(X, y)
    
    def transform(self, X):
        return self.pipeline.transform(X)
```

### Common Pitfalls

| Pitfall | Solution |
|---------|----------|
| Data leakage | Use time-based splits |
| Overfitting | Cross-validation |
| High cardinality | Target/frequency encoding |
| Missing values | Imputation strategies |
| Scale differences | Feature scaling |
| Multicollinearity | Remove correlated features |

### Feature Engineering Checklist

1. **Understand the data** - EDA before feature creation
2. **Handle missing values** - Appropriate imputation
3. **Encode categorical variables** - Choose right encoding
4. **Scale numerical features** - StandardScaler/MinMaxScaler
5. **Create interaction features** - Domain knowledge helps
6. **Select important features** - Remove noise
7. **Validate feature quality** - Check for leakage
8. **Document transformations** - For reproducibility
