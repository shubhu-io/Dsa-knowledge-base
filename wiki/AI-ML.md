# AI, Machine Learning & Deep Learning

## Overview

Artificial Intelligence (AI) is the broad field of creating intelligent machines. Machine Learning (ML) is a subset of AI that enables systems to learn from data. Deep Learning (DL) is a subset of ML using neural networks with many layers.

## Key Concepts

### AI vs ML vs Deep Learning Hierarchy

```
┌──────────────────────────────────────────────┐
│              Artificial Intelligence          │
│  ┌────────────────────────────────────────┐  │
│  │          Machine Learning              │  │
│  │  ┌──────────────────────────────────┐  │  │
│  │  │        Deep Learning             │  │  │
│  │  │  ┌────────┐ ┌────────┐ ┌──────┐ │  │  │
│  │  │  │  CNNs  │ │  RNNs  │ │ GANs │ │  │  │
│  │  │  └────────┘ └────────┘ └──────┘ │  │  │
│  │  └──────────────────────────────────┘  │  │
│  └────────────────────────────────────────┘  │
└──────────────────────────────────────────────┘
```

### Types of Machine Learning

| Type | Input | Goal | Examples |
|------|-------|------|----------|
| **Supervised** | Labeled data | Predict outcomes | Classification, Regression |
| **Unsupervised** | Unlabeled data | Find patterns | Clustering, Dimensionality Reduction |
| **Semi-supervised** | Mixed data | Combine both | Self-training |
| **Reinforcement** | Reward signal | Maximize reward | Game AI, Robotics |

## Common ML Algorithms

| Algorithm | Type | Use Case | Pros | Cons |
|-----------|------|----------|------|------|
| Linear Regression | Supervised | Price prediction | Simple, interpretable | Assumes linearity |
| Logistic Regression | Supervised | Binary classification | Probabilistic output | Limited to linear boundaries |
| Decision Trees | Supervised | Classification/Regression | Interpretable | Overfitting risk |
| Random Forest | Supervised | Classification/Regression | Robust, handles missing data | Less interpretable |
| SVM | Supervised | Classification | Effective in high dimensions | Slow on large datasets |
| K-Means | Unsupervised | Clustering | Simple, scalable | Must specify K |
| KNN | Supervised | Classification | Non-parametric | Computationally expensive |
| Neural Networks | Both | Complex patterns | Universal approximator | Black box, data hungry |

## Neural Network Basics

```
Input Layer    Hidden Layers    Output Layer
  ┌───┐
  │ x1│──┐
  └───┘  │    ┌───┐
  ┌───┐  ├───▶│ h1│──┐
  │ x2│──┤    └───┘  │    ┌───┐
  └───┘  │    ┌───┐  ├───▶│ y1│
  ┌───┐  ├───▶│ h2│──┤    └───┘
  │ x3│──┤    └───┘  │
  └───┘  │    ┌───┐  │
  ┌───┐  └───▶│ h3│──┘
  │ x4│──┘    └───┘
  └───┘
```

### Activation Functions

| Function | Formula | Range | Use Case |
|----------|---------|-------|----------|
| Sigmoid | 1 / (1 + e^(-x)) | (0, 1) | Binary classification output |
| Tanh | (e^x - e^-x) / (e^x + e^-x) | (-1, 1) | Hidden layers |
| ReLU | max(0, x) | [0, ∞) | Most hidden layers |
| Leaky ReLU | max(0.01x, x) | (-∞, ∞) | Avoiding dead neurons |
| Softmax | e^xi / Σe^xj | (0, 1), sums to 1 | Multi-class output |

## Python sklearn Example

```python
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, confusion_matrix
import numpy as np

# Load dataset
iris = load_iris()
X, y = iris.data, iris.target

# Split data
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

# Scale features
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Train model
model = RandomForestClassifier(
    n_estimators=100,
    max_depth=5,
    random_state=42
)
model.fit(X_train_scaled, y_train)

# Cross-validation
cv_scores = cross_val_score(model, X_train_scaled, y_train, cv=5)
print(f"CV Accuracy: {cv_scores.mean():.4f} (+/- {cv_scores.std():.4f})")

# Evaluate
y_pred = model.predict(X_test_scaled)
print("\nClassification Report:")
print(classification_report(y_test, y_pred, target_names=iris.target_names))

# Feature importance
importances = model.feature_importances_
for name, imp in sorted(zip(iris.feature_names, importances), key=lambda x: -x[1]):
    print(f"{name}: {imp:.4f}")
```

## Deep Learning Framework Comparison

| Framework | Language | Best For | Learning Curve |
|-----------|----------|----------|----------------|
| PyTorch | Python | Research, flexibility | Moderate |
| TensorFlow | Python | Production, deployment | Steep |
| JAX | Python | High-performance research | Steep |
| Keras | Python | Beginners, quick prototyping | Easy |

## Common Interview Questions

1. **What is the bias-variance tradeoff?** High bias = underfitting (too simple); high variance = overfitting (too complex). The goal is to find the balance.

2. **Explain gradient descent.** Optimization algorithm that iteratively adjusts parameters in the direction of steepest decrease of the loss function, controlled by learning rate.

3. **What is regularization and why is it used?** Techniques (L1, L2, dropout) that prevent overfitting by adding constraints or penalties to the model.

4. **Explain precision vs recall.** Precision = TP/(TP+FP) — how many selected are relevant. Recall = TP/(TP+FN) — how many relevant are selected.

5. **What is transfer learning?** Using a pre-trained model on a new but related task, reducing training time and data requirements.

## See Also

- [[Resources]]
- [[Cheat-Sheets]]
- [[Web-Development]]

> Full content: [38-AI](../38-AI/), [39-Machine-Learning](../39-Machine-Learning/), [40-Deep-Learning](../40-Deep-Learning/)
