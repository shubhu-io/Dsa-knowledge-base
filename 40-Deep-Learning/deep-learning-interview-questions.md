# Deep Learning Interview Questions

## Table of Contents

1. [Fundamentals](#fundamentals)
2. [Architectures](#architectures)
3. [Training](#training)
4. [Optimization](#optimization)
5. [Advanced Topics](#advanced-topics)
6. [Practical Questions](#practical-questions)

---

## Fundamentals

### 1. What is the vanishing gradient problem?

**Answer:**
Gradients become very small during backpropagation, making early layers learn very slowly or stop learning.

**Causes:**
- Sigmoid/Tanh activation functions (gradients < 1)
- Deep networks with many layers
- Poor weight initialization

**Solutions:**
```python
# 1. ReLU activation
nn.ReLU()  # Gradient is either 0 or 1

# 2. Batch Normalization
nn.BatchNorm2d(num_features)

# 3. Residual connections
class ResBlock(nn.Module):
    def forward(self, x):
        return x + self.conv2(self.conv1(x))

# 4. Proper initialization
nn.init.kaiming_normal_(layer.weight)
```

### 2. Explain the difference between BatchNorm and LayerNorm

**Answer:**

| Aspect | BatchNorm | LayerNorm |
|--------|-----------|-----------|
| **Normalization** | Across batch dimension | Across feature dimension |
| **Batch Size** | Depends on batch size | Independent of batch size |
| **Sequence Models** | Can be tricky | Preferred for transformers |
| **Inference** | Uses running stats | Uses current batch stats |
| **Implementation** | Normalize per channel | Normalize per sample |

```python
# BatchNorm - normalizes across batch
nn.BatchNorm2d(64)  # For CNNs

# LayerNorm - normalizes across features
nn.LayerNorm(768)  # For transformers
```

### 3. Why do we use activation functions?

**Answer:**
Without activation functions, neural networks would be linear models regardless of depth.

```python
# Without activation: y = W2(W1x + b1) + b2 = W'x + b' (still linear!)

# With non-linear activation: y = σ(W2·σ(W1x + b1) + b2) (non-linear)

# Comparison of activations
"""
| Activation | Output Range | Gradient | Use Case |
|------------|--------------|----------|----------|
| Sigmoid | (0, 1) | (0, 0.25] | Output layer (binary) |
| Tanh | (-1, 1) | (0, 1] | Hidden layers |
| ReLU | [0, ∞) | {0, 1} | Default choice |
| Leaky ReLU | (-∞, ∞) | {α, 1} | When ReLU fails |
| GELU | (-∞, ∞) | Smooth | Transformers |
"""
```

### 4. What is the role of bias in neural networks?

**Answer:**
Bias allows the activation function to shift left or right, enabling the model to fit data that doesn't pass through the origin.

```python
# Without bias: y = Wx (always passes through origin)
# With bias: y = Wx + b (can shift)

# Example: learning OR gate
# Without bias, cannot represent OR (always gives 0 for input [0,0])
```

---

## Architectures

### 1. Explain the attention mechanism in transformers

**Answer:**

```python
import torch
import torch.nn as nn
import math

class MultiHeadAttention(nn.Module):
    def __init__(self, embed_size, heads):
        super().__init__()
        self.embed_size = embed_size
        self.heads = heads
        self.head_dim = embed_size // heads
        
        self.queries = nn.Linear(embed_size, embed_size)
        self.keys = nn.Linear(embed_size, embed_size)
        self.values = nn.Linear(embed_size, embed_size)
        self.fc_out = nn.Linear(embed_size, embed_size)
    
    def forward(self, x, mask=None):
        N, seq_length, _ = x.shape
        
        # Split into heads
        q = self.queries(x).reshape(N, seq_length, self.heads, self.head_dim).transpose(1, 2)
        k = self.keys(x).reshape(N, seq_length, self.heads, self.head_dim).transpose(1, 2)
        v = self.values(x).reshape(N, seq_length, self.heads, self.head_dim).transpose(1, 2)
        
        # Attention scores
        energy = torch.einsum("nhq,nhk->nhqk", [q, k])
        attention = torch.softmax(energy / math.sqrt(self.head_dim), dim=-1)
        
        # Apply attention to values
        out = torch.einsum("nhqk,nhk->nhq", [attention, v])
        out = out.transpose(1, 2).reshape(N, seq_length, self.embed_size)
        
        return self.fc_out(out)
```

**Key points:**
- Query, Key, Value projection
- Scaled dot-product attention: `softmax(QK^T / √d_k)V`
- Multi-head allows attending to different positions
- Self-attention: Q, K, V come from same input

### 2. Compare CNN vs Transformer for image classification

**Answer:**

| Aspect | CNN | Transformer (ViT) |
|--------|-----|-------------------|
| **Inductive Bias** | Locality, translation invariance | None (learns from data) |
| **Data Requirement** | Less data needed | More data needed |
| **Computational Cost** | Lower for small images | Higher, but parallelizable |
| **Long-range Dependencies** | Limited by receptive field | Global from first layer |
| **Interpretability** | Filter visualization | Attention maps |

### 3. What is the difference between encoder and decoder in transformers?

**Answer:**

```python
# Encoder: Processes input sequence
class TransformerEncoder(nn.Module):
    def __init__(self, embed_size, heads, num_layers):
        super().__init__()
        self.layers = nn.ModuleList([
            TransformerBlock(embed_size, heads) for _ in range(num_layers)
        ])
        self.norm = nn.LayerNorm(embed_size)
    
    def forward(self, x, mask=None):
        for layer in self.layers:
            x = layer(x, mask)
        return self.norm(x)

# Decoder: Generates output sequence (autoregressive)
class TransformerDecoder(nn.Module):
    def __init__(self, embed_size, heads, num_layers):
        super().__init__()
        self.layers = nn.ModuleList([
            DecoderBlock(embed_size, heads) for _ in range(num_layers)
        ])
        self.norm = nn.LayerNorm(embed_size)
    
    def forward(self, x, encoder_out, src_mask=None, tgt_mask=None):
        for layer in self.layers:
            x = layer(x, encoder_out, src_mask, tgt_mask)
        return self.norm(x)
```

**Use cases:**
- Encoder-only: BERT (classification, embeddings)
- Decoder-only: GPT (text generation)
- Encoder-decoder: T5, BART (translation, summarization)

---

## Training

### 1. How do you handle overfitting in deep learning?

**Answer:**

```python
# 1. Regularization
class RegularizedModel(nn.Module):
    def __init__(self):
        super().__init__()
        self.dropout = nn.Dropout(0.5)
        # Weight decay in optimizer
        self.optimizer = Adam(model.parameters(), weight_decay=1e-4)

# 2. Data augmentation
transform = T.Compose([
    T.RandomHorizontalFlip(),
    T.RandomRotation(10),
    T.ColorJitter(brightness=0.2),
    T.RandomErasing()
])

# 3. Early stopping
class EarlyStopping:
    def __init__(self, patience=10):
        self.patience = patience
        self.counter = 0
        self.best_loss = float('inf')
    
    def __call__(self, val_loss):
        if val_loss < self.best_loss:
            self.best_loss = val_loss
            self.counter = 0
            return False
        else:
            self.counter += 1
            return self.counter >= self.patience

# 4. Label smoothing
criterion = nn.CrossEntropyLoss(label_smoothing=0.1)

# 5. Reduce model complexity
# Fewer layers, fewer parameters
```

### 2. Explain learning rate warmup

**Answer:**
Start with small learning rate, gradually increase to target, then decay.

```python
class WarmupScheduler:
    def __init__(self, optimizer, warmup_steps, total_steps):
        self.optimizer = optimizer
        self.warmup_steps = warmup_steps
        self.total_steps = total_steps
        self.current_step = 0
    
    def step(self):
        self.current_step += 1
        lr = self.get_lr()
        for group in self.optimizer.param_groups:
            group['lr'] = lr
    
    def get_lr(self):
        if self.current_step < self.warmup_steps:
            return self.base_lr * self.current_step / self.warmup_steps
        else:
            progress = (self.current_step - self.warmup_steps) / (self.total_steps - self.warmup_steps)
            return self.base_lr * 0.5 * (1 + math.cos(math.pi * progress))

# PyTorch one-cycle policy
scheduler = torch.optim.lr_scheduler.OneCycleLR(
    optimizer,
    max_lr=0.01,
    epochs=100,
    steps_per_epoch=len(train_loader)
)
```

**Why warmup?**
- Large gradients at start can cause instability
- Adam optimizer estimates need time to stabilize
- Prevents divergence in early training

### 3. What is gradient clipping and why is it used?

**Answer:**

```python
# Clip by norm
torch.nn.utils.clip_grad_norm_(model.parameters(), max_norm=1.0)

# Clip by value
torch.nn.utils.clip_grad_value_(model.parameters(), clip_value=0.5)

# In training loop
loss.backward()
torch.nn.utils.clip_grad_norm_(model.parameters(), max_norm=1.0)
optimizer.step()
```

**When to use:**
- Training RNNs/LSTMs (exploding gradients)
- Transformer training
- Large batch sizes
- High learning rates

---

## Optimization

### 1. Compare Adam vs SGD with momentum

**Answer:**

| Aspect | Adam | SGD + Momentum |
|--------|------|----------------|
| **Adaptive LR** | Yes (per-parameter) | No (global) |
| **Memory** | Higher (2m states) | Lower (1m states) |
| **Generalization** | Often worse | Often better |
| **Convergence** | Faster initially | Slower but better final |
| **Hyperparameters** | Less sensitive | More sensitive |

```python
# Adam: Good default, fast convergence
optimizer = torch.optim.Adam(model.parameters(), lr=0.001)

# SGD + Momentum: Better generalization
optimizer = torch.optim.SGD(model.parameters(), lr=0.1, momentum=0.9, weight_decay=1e-4)

# AdamW: Adam with decoupled weight decay
optimizer = torch.optim.AdamW(model.parameters(), lr=0.001, weight_decay=0.01)
```

### 2. What is the difference between batch, mini-batch, and stochastic gradient descent?

**Answer:**

```python
# Batch GD: Uses all data
for epoch in range(epochs):
    optimizer.zero_grad()
    output = model(all_data)
    loss = criterion(output, all_labels)
    loss.backward()
    optimizer.step()

# Mini-batch GD: Uses subsets
for epoch in range(epochs):
    for batch_x, batch_y in dataloader:
        optimizer.zero_grad()
        output = model(batch_x)
        loss = criterion(output, batch_y)
        loss.backward()
        optimizer.step()

# SGD: Batch size = 1
for epoch in range(epochs):
    for x, y in dataset:
        optimizer.zero_grad()
        output = model(x.unsqueeze(0))
        loss = criterion(output, y.unsqueeze(0))
        loss.backward()
        optimizer.step()
```

| Method | Pros | Cons |
|--------|------|------|
| Batch GD | Stable, converges to exact minimum | Slow, high memory |
| Mini-batch | Good trade-off, GPU friendly | Noise can help generalization |
| SGD | Fast updates, regularization | Very noisy, hard to converge |

### 3. Explain learning rate schedules

**Answer:**

```python
import torch.optim as optim

# Step decay
scheduler = optim.lr_scheduler.StepLR(optimizer, step_size=30, gamma=0.1)

# Exponential decay
scheduler = optim.lr_scheduler.ExponentialLR(optimizer, gamma=0.95)

# Cosine annealing
scheduler = optim.lr_scheduler.CosineAnnealingLR(optimizer, T_max=100)

# Cosine annealing with warm restarts
scheduler = optim.lr_scheduler.CosineAnnealingWarmRestarts(optimizer, T_0=10)

# Reduce on plateau
scheduler = optim.lr_scheduler.ReduceLROnPlateau(optimizer, mode='min', patience=5)

# Custom schedule
def custom_schedule(epoch):
    if epoch < 10:
        return 0.001
    elif epoch < 50:
        return 0.0001
    else:
        return 0.00001

scheduler = optim.lr_scheduler.LambdaLR(optimizer, lr_lambda=custom_schedule)
```

---

## Advanced Topics

### 1. What is transfer learning?

**Answer:**

```python
import torch.nn as nn
from torchvision import models

# Load pre-trained model
model = models.resnet50(pretrained=True)

# Freeze early layers
for param in list(model.parameters())[:-10]:
    param.requires_grad = False

# Replace final layer
num_features = model.fc.in_features
model.fc = nn.Linear(num_features, num_classes)

# Fine-tune
optimizer = torch.optim.Adam(filter(lambda p: p.requires_grad, model.parameters()), lr=0.001)
```

**Strategies:**
1. **Feature extraction**: Freeze all, train new head
2. **Fine-tuning**: Unfreeze some layers, train with small LR
3. **Full fine-tuning**: Train all layers (needs lots of data)

### 2. What is knowledge distillation?

**Answer:**
Train a smaller model (student) to mimic a larger model (teacher).

```python
class DistillationLoss(nn.Module):
    def __init__(self, temperature=3.0, alpha=0.7):
        super().__init__()
        self.temperature = temperature
        self.alpha = alpha
        self.ce_loss = nn.CrossEntropyLoss()
        self.kl_loss = nn.KLDivLoss(reduction='batchmean')
    
    def forward(self, student_logits, teacher_logits, labels):
        # Soft loss (distillation)
        soft_student = nn.functional.log_softmax(student_logits / self.temperature, dim=1)
        soft_teacher = nn.functional.softmax(teacher_logits / self.temperature, dim=1)
        distill_loss = self.kl_loss(soft_student, soft_teacher) * (self.temperature ** 2)
        
        # Hard loss (standard)
        hard_loss = self.ce_loss(student_logits, labels)
        
        return self.alpha * distill_loss + (1 - self.alpha) * hard_loss
```

### 3. What is contrastive learning?

**Answer:**
Learn representations by pulling similar pairs together and pushing dissimilar pairs apart.

```python
class SimCLR(nn.Module):
    def __init__(self, backbone, projection_dim=128):
        super().__init__()
        self.backbone = backbone
        self.projector = nn.Sequential(
            nn.Linear(2048, 2048),
            nn.ReLU(),
            nn.Linear(2048, projection_dim)
        )
    
    def nt_xent_loss(self, z_i, z_j, temperature=0.5):
        batch_size = z_i.shape[0]
        z = torch.cat([z_i, z_j], dim=0)
        z = nn.functional.normalize(z, dim=1)
        
        sim = torch.mm(z, z.T) / temperature
        sim_ij = torch.diag(sim, batch_size)
        sim_ji = torch.diag(sim, -batch_size)
        
        positives = torch.cat([sim_ij, sim_ji], dim=0)
        negatives = sim[~torch.eye(2*batch_size, dtype=bool)].reshape(2*batch_size, -1)
        
        logits = torch.cat([positives.unsqueeze(1), negatives], dim=1)
        labels = torch.zeros(2*batch_size, dtype=torch.long)
        
        return nn.functional.cross_entropy(logits, labels)
```

---

## Practical Questions

### 1. How do you debug a neural network that isn't learning?

**Answer:**

```python
# Checklist:
# 1. Check data pipeline
print(f"Input shape: {x.shape}")
print(f"Labels: {torch.unique(y)}")
print(f"Label distribution: {torch.bincount(y)}")

# 2. Overfit small batch first
small_batch = next(iter(train_loader))
for _ in range(100):
    loss = criterion(model(small_batch[0]), small_batch[1])
    loss.backward()
    optimizer.step()
# Should achieve ~0 loss

# 3. Check gradients
for name, param in model.named_parameters():
    if param.grad is not None:
        print(f"{name}: grad norm = {param.grad.norm().item()}")

# 4. Monitor metrics
print(f"Loss: {loss.item()}")
print(f"Predictions range: [{output.min().item()}, {output.max().item()}]")
print(f"Accuracy: {(output.argmax(1) == y).float().mean().item()}")
```

### 2. How do you choose batch size?

**Answer:**

| Batch Size | Pros | Cons |
|------------|------|------|
| Small (16-32) | Better generalization, less memory | Slower training, noisy gradients |
| Medium (64-256) | Good balance | Moderate memory |
| Large (512+) | Faster training, stable gradients | May generalize worse, high memory |

**Guidelines:**
- Start with 32, increase until GPU memory fills
- For transformers: often 256-512
- For CNNs: often 64-128
- Scale learning rate with batch size (linear scaling rule)

### 3. How do you deploy a deep learning model?

**Answer:**

```python
# 1. Export model
import torch
torch.save(model.state_dict(), 'model.pth')

# 2. ONNX export
dummy_input = torch.randn(1, 3, 224, 224)
torch.onnx.export(model, dummy_input, "model.onnx")

# 3. TorchScript
scripted_model = torch.jit.script(model)
scripted_model.save("model.pt")

# 4. Serving with Flask
from flask import Flask, request, jsonify
import torch

app = Flask(__name__)
model = load_model()

@app.route('/predict', methods=['POST'])
def predict():
    data = request.json
    tensor = torch.tensor(data['input']).float()
    with torch.no_grad():
        output = model(tensor)
    return jsonify({'prediction': output.tolist()})
```

---

## Quick Reference

| Concept | Key Point |
|---------|-----------|
| Vanishing Gradient | Use ReLU, BatchNorm, ResNets |
| Overfitting | Dropout, data augmentation, early stopping |
| Underfitting | More capacity, longer training |
| Learning Rate | Most important hyperparameter |
| Batch Size | Balance speed and generalization |
| Transfer Learning | Use pre-trained models |
| Mixed Precision | Faster training, less memory |
