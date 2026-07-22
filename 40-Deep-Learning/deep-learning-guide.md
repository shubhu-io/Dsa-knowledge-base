# Deep Learning Complete Guide

## Table of Contents

1. [Neural Network Fundamentals](#neural-network-fundamentals)
2. [Activation Functions](#activation-functions)
3. [Backpropagation](#backpropagation)
4. [Building Blocks](#building-blocks)
5. [Loss Functions](#loss-functions)
6. [Optimizers](#optimizers)

---

## Neural Network Fundamentals

### Perceptron

```python
import numpy as np

class Perceptron:
    def __init__(self, n_inputs, learning_rate=0.1):
        self.weights = np.random.randn(n_inputs) * 0.01
        self.bias = 0
        self.lr = learning_rate
    
    def sigmoid(self, z):
        return 1 / (1 + np.exp(-np.clip(z, -500, 500)))
    
    def predict(self, X):
        z = np.dot(X, self.weights) + self.bias
        return self.sigmoid(z)
    
    def train(self, X, y, epochs=100):
        for _ in range(epochs):
            for xi, target in zip(X, y):
                pred = self.predict(xi)
                error = target - pred
                
                self.weights += self.lr * error * xi
                self.bias += self.lr * error
```

### Multi-Layer Perceptron (MLP)

```python
import torch
import torch.nn as nn

class MLP(nn.Module):
    def __init__(self, input_size, hidden_size, output_size):
        super().__init__()
        self.layer1 = nn.Linear(input_size, hidden_size)
        self.relu = nn.ReLU()
        self.layer2 = nn.Linear(hidden_size, output_size)
        self.sigmoid = nn.Sigmoid()
    
    def forward(self, x):
        x = self.layer1(x)
        x = self.relu(x)
        x = self.layer2(x)
        x = self.sigmoid(x)
        return x

# Training loop
model = MLP(784, 128, 10)
criterion = nn.CrossEntropyLoss()
optimizer = torch.optim.Adam(model.parameters(), lr=0.001)

for epoch in range(100):
    for batch_x, batch_y in train_loader:
        optimizer.zero_grad()
        output = model(batch_x)
        loss = criterion(output, batch_y)
        loss.backward()
        optimizer.step()
```

---

## Activation Functions

```python
import torch
import torch.nn.functional as F
import numpy as np

class ActivationFunctions:
    def sigmoid(self, x):
        return 1 / (1 + np.exp(-x))
    
    def tanh(self, x):
        return np.tanh(x)
    
    def relu(self, x):
        return np.maximum(0, x)
    
    def leaky_relu(self, x, alpha=0.01):
        return np.where(x > 0, x, alpha * x)
    
    def softmax(self, x):
        exp_x = np.exp(x - np.max(x))
        return exp_x / exp_x.sum(axis=-1, keepdims=True)
    
    def gelu(self, x):
        return 0.5 * x * (1 + np.tanh(np.sqrt(2/np.pi) * (x + 0.044715 * x**3)))
    
    def swish(self, x):
        return x * self.sigmoid(x)

# Comparison table
"""
| Function | Range | Pros | Cons | Use Case |
|----------|-------|------|------|----------|
| Sigmoid | (0,1) | Probabilistic output | Vanishing gradients | Binary output |
| Tanh | (-1,1) | Zero-centered | Vanishing gradients | Hidden layers |
| ReLU | [0,∞) | Fast, no vanishing | Dead neurons | Default choice |
| Leaky ReLU | (-∞,∞) | No dead neurons | Extra parameter | When ReLU fails |
| GELU | (-∞,∞) | Smooth, non-monotonic | Computationally expensive | Transformers |
| Swish | (-∞,∞) | Smooth, self-gated | Computationally expensive | Deep networks |
"""
```

---

## Backpropagation

```python
import numpy as np

class NeuralNetwork:
    def __init__(self, layers):
        self.layers = layers
        self.weights = []
        self.biases = []
        
        for i in range(len(layers) - 1):
            w = np.random.randn(layers[i], layers[i+1]) * np.sqrt(2.0 / layers[i])
            b = np.zeros((1, layers[i+1]))
            self.weights.append(w)
            self.biases.append(b)
    
    def relu(self, z):
        return np.maximum(0, z)
    
    def relu_derivative(self, z):
        return z > 0
    
    def softmax(self, z):
        exp_z = np.exp(z - np.max(z, axis=1, keepdims=True))
        return exp_z / np.sum(exp_z, axis=1, keepdims=True)
    
    def forward(self, X):
        self.activations = [X]
        self.z_values = []
        
        for i in range(len(self.weights)):
            z = np.dot(self.activations[-1], self.weights[i]) + self.biases[i]
            self.z_values.append(z)
            
            if i == len(self.weights) - 1:
                a = self.softmax(z)
            else:
                a = self.relu(z)
            
            self.activations.append(a)
        
        return self.activations[-1]
    
    def backward(self, X, y, output):
        m = X.shape[0]
        self.dW = []
        self.db = []
        
        # Output layer error
        delta = output - y
        
        for i in range(len(self.weights) - 1, -1, -1):
            dW = np.dot(self.activations[i].T, delta) / m
            db = np.sum(delta, axis=0, keepdims=True) / m
            
            self.dW.insert(0, dW)
            self.db.insert(0, db)
            
            if i > 0:
                delta = np.dot(delta, self.weights[i].T) * self.relu_derivative(self.z_values[i-1])
    
    def update(self, lr=0.01):
        for i in range(len(self.weights)):
            self.weights[i] -= lr * self.dW[i]
            self.biases[i] -= lr * self.db[i]
```

---

## Building Blocks

### Batch Normalization

```python
import torch
import torch.nn as nn

class BatchNormLayer(nn.Module):
    def __init__(self, num_features, eps=1e-5, momentum=0.1):
        super().__init__()
        self.gamma = nn.Parameter(torch.ones(num_features))
        self.beta = nn.Parameter(torch.zeros(num_features))
        self.eps = eps
        self.momentum = momentum
        
        self.running_mean = torch.zeros(num_features)
        self.running_var = torch.ones(num_features)
    
    def forward(self, x):
        if self.training:
            mean = x.mean(dim=0)
            var = x.var(dim=0, unbiased=False)
            
            self.running_mean = (1 - self.momentum) * self.running_mean + self.momentum * mean
            self.running_var = (1 - self.momentum) * self.running_var + self.momentum * var
        else:
            mean = self.running_mean
            var = self.running_var
        
        x_norm = (x - mean) / torch.sqrt(var + self.eps)
        return self.gamma * x_norm + self.beta
```

### Dropout

```python
class DropoutLayer:
    def __init__(self, p=0.5):
        self.p = p
        self.training = True
    
    def __call__(self, x):
        if not self.training:
            return x
        
        mask = (np.random.rand(*x.shape) > self.p).astype(float)
        return x * mask / (1 - self.p)

# PyTorch dropout
dropout = nn.Dropout(p=0.5)
x = torch.randn(32, 128)
x_dropped = dropout(x)
```

### Residual Connections

```python
class ResidualBlock(nn.Module):
    def __init__(self, in_channels, out_channels, stride=1):
        super().__init__()
        self.conv1 = nn.Conv2d(in_channels, out_channels, 3, stride=stride, padding=1)
        self.bn1 = nn.BatchNorm2d(out_channels)
        self.conv2 = nn.Conv2d(out_channels, out_channels, 3, padding=1)
        self.bn2 = nn.BatchNorm2d(out_channels)
        
        self.shortcut = nn.Sequential()
        if stride != 1 or in_channels != out_channels:
            self.shortcut = nn.Sequential(
                nn.Conv2d(in_channels, out_channels, 1, stride=stride),
                nn.BatchNorm2d(out_channels)
            )
    
    def forward(self, x):
        out = torch.relu(self.bn1(self.conv1(x)))
        out = self.bn2(self.conv2(out))
        out += self.shortcut(x)
        out = torch.relu(out)
        return out
```

---

## Loss Functions

```python
import torch
import torch.nn as nn
import numpy as np

class LossFunctions:
    def mse_loss(self, y_pred, y_true):
        return np.mean((y_pred - y_true) ** 2)
    
    def cross_entropy_loss(self, y_pred, y_true):
        m = y_true.shape[0]
        log_likelihood = -np.log(y_pred[range(m), y_true] + 1e-8)
        return np.sum(log_likelihood) / m
    
    def binary_cross_entropy(self, y_pred, y_true):
        return -np.mean(y_true * np.log(y_pred + 1e-8) + (1 - y_true) * np.log(1 - y_pred + 1e-8))
    
    def focal_loss(self, y_pred, y_true, gamma=2.0, alpha=0.25):
        bce = -y_true * np.log(y_pred + 1e-8) - (1 - y_true) * np.log(1 - y_pred + 1e-8)
        focal = alpha * (1 - y_pred) ** gamma * bce
        return np.mean(focal)

# PyTorch losses
criterion_mse = nn.MSELoss()
criterion_ce = nn.CrossEntropyLoss()
criterion_bce = nn.BCELoss()
```

---

## Optimizers

```python
class SGD:
    def __init__(self, params, lr=0.01, momentum=0.9):
        self.params = params
        self.lr = lr
        self.momentum = momentum
        self.velocities = [np.zeros_like(p) for p in params]
    
    def step(self, grads):
        for i, (param, grad) in enumerate(zip(self.params, grads)):
            self.velocities[i] = self.momentum * self.velocities[i] + self.lr * grad
            param -= self.velocities[i]

class Adam:
    def __init__(self, params, lr=0.001, beta1=0.9, beta2=0.999, eps=1e-8):
        self.params = params
        self.lr = lr
        self.beta1 = beta1
        self.beta2 = beta2
        self.eps = eps
        self.m = [np.zeros_like(p) for p in params]
        self.v = [np.zeros_like(p) for p in params]
        self.t = 0
    
    def step(self, grads):
        self.t += 1
        for i, (param, grad) in enumerate(zip(self.params, grads)):
            self.m[i] = self.beta1 * self.m[i] + (1 - self.beta1) * grad
            self.v[i] = self.beta2 * self.v[i] + (1 - self.beta2) * grad**2
            
            m_hat = self.m[i] / (1 - self.beta1**self.t)
            v_hat = self.v[i] / (1 - self.beta2**self.t)
            
            param -= self.lr * m_hat / (np.sqrt(v_hat) + self.eps)

# PyTorch optimizers
optimizer_sgd = torch.optim.SGD(model.parameters(), lr=0.01, momentum=0.9)
optimizer_adam = torch.optim.Adam(model.parameters(), lr=0.001)
optimizer_adamw = torch.optim.AdamW(model.parameters(), lr=0.001, weight_decay=0.01)
```

---

## Summary

| Component | Purpose | Common Choices |
|-----------|---------|----------------|
| Activation | Non-linearity | ReLU, GELU, Swish |
| Normalization | Stabilize training | BatchNorm, LayerNorm |
| Regularization | Prevent overfitting | Dropout, Weight decay |
| Loss | Objective function | CrossEntropy, MSE |
| Optimizer | Update weights | Adam, AdamW, SGD |
| Learning Rate | Step size | Cosine annealing, Warmup |
