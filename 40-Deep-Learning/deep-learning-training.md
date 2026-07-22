# Deep Learning Training Guide

## Table of Contents

1. [Training Loop](#training-loop)
2. [Learning Rate Scheduling](#learning-rate-scheduling)
3. [Regularization](#regularization)
4. [Data Augmentation](#data-augmentation)
5. [Mixed Precision Training](#mixed-precision-training)
6. [Distributed Training](#distributed-training)

---

## Training Loop

### Complete Training Pipeline

```python
import torch
import torch.nn as nn
from torch.utils.data import DataLoader
from tqdm import tqdm

class Trainer:
    def __init__(self, model, criterion, optimizer, device='cuda'):
        self.model = model.to(device)
        self.criterion = criterion
        self.optimizer = optimizer
        self.device = device
    
    def train_epoch(self, dataloader):
        self.model.train()
        total_loss = 0
        correct = 0
        total = 0
        
        for batch_x, batch_y in tqdm(dataloader, desc='Training'):
            batch_x, batch_y = batch_x.to(self.device), batch_y.to(self.device)
            
            self.optimizer.zero_grad()
            outputs = self.model(batch_x)
            loss = self.criterion(outputs, batch_y)
            loss.backward()
            self.optimizer.step()
            
            total_loss += loss.item()
            _, predicted = outputs.max(1)
            total += batch_y.size(0)
            correct += predicted.eq(batch_y).sum().item()
        
        return total_loss / len(dataloader), 100. * correct / total
    
    def validate(self, dataloader):
        self.model.eval()
        total_loss = 0
        correct = 0
        total = 0
        
        with torch.no_grad():
            for batch_x, batch_y in tqdm(dataloader, desc='Validation'):
                batch_x, batch_y = batch_x.to(self.device), batch_y.to(self.device)
                
                outputs = self.model(batch_x)
                loss = self.criterion(outputs, batch_y)
                
                total_loss += loss.item()
                _, predicted = outputs.max(1)
                total += batch_y.size(0)
                correct += predicted.eq(batch_y).sum().item()
        
        return total_loss / len(dataloader), 100. * correct / total
    
    def fit(self, train_loader, val_loader, epochs=100, patience=10):
        best_val_loss = float('inf')
        patience_counter = 0
        history = {'train_loss': [], 'val_loss': [], 'train_acc': [], 'val_acc': []}
        
        for epoch in range(epochs):
            train_loss, train_acc = self.train_epoch(train_loader)
            val_loss, val_acc = self.validate(val_loader)
            
            history['train_loss'].append(train_loss)
            history['val_loss'].append(val_loss)
            history['train_acc'].append(train_acc)
            history['val_acc'].append(val_acc)
            
            print(f"Epoch {epoch+1}/{epochs}")
            print(f"Train Loss: {train_loss:.4f}, Train Acc: {train_acc:.2f}%")
            print(f"Val Loss: {val_loss:.4f}, Val Acc: {val_acc:.2f}%")
            
            # Early stopping
            if val_loss < best_val_loss:
                best_val_loss = val_loss
                patience_counter = 0
                torch.save(self.model.state_dict(), 'best_model.pth')
            else:
                patience_counter += 1
                if patience_counter >= patience:
                    print(f"Early stopping at epoch {epoch+1}")
                    break
        
        return history
```

---

## Learning Rate Scheduling

### Schedulers

```python
import torch.optim as optim
import math

class LRScheduler:
    def __init__(self, optimizer):
        self.optimizer = optimizer
        self.base_lrs = [group['lr'] for group in optimizer.param_groups]
    
    def step_decay(self, epoch, drop=0.5, every=10):
        lr = self.base_lrs[0] * (drop ** (epoch // every))
        for group in self.optimizer.param_groups:
            group['lr'] = lr
    
    def cosine_annealing(self, epoch, T_max, eta_min=0):
        for i, group in enumerate(self.optimizer.param_groups):
            lr = eta_min + (self.base_lrs[i] - eta_min) * (1 + math.cos(math.pi * epoch / T_max)) / 2
            group['lr'] = lr
    
    def warmup_cosine(self, epoch, warmup_epochs, total_epochs):
        if epoch < warmup_epochs:
            lr = self.base_lrs[0] * epoch / warmup_epochs
        else:
            progress = (epoch - warmup_epochs) / (total_epochs - warmup_epochs)
            lr = self.base_lrs[0] * 0.5 * (1 + math.cos(math.pi * progress))
        
        for group in self.optimizer.param_groups:
            group['lr'] = lr

# PyTorch schedulers
optimizer = optim.Adam(model.parameters(), lr=0.001)

# Step LR
scheduler = optim.lr_scheduler.StepLR(optimizer, step_size=30, gamma=0.1)

# Cosine Annealing
scheduler = optim.lr_scheduler.CosineAnnealingLR(optimizer, T_max=100, eta_min=0)

# One Cycle Policy
scheduler = optim.lr_scheduler.OneCycleLR(optimizer, max_lr=0.01, epochs=100, steps_per_epoch=len(train_loader))
```

### Learning Rate Finder

```python
class LRFinder:
    def __init__(self, model, optimizer, criterion, device='cuda'):
        self.model = model
        self.optimizer = optimizer
        self.criterion = criterion
        self.device = device
    
    def find(self, train_loader, lr_start=1e-7, lr_end=10, num_steps=100):
        lrs = []
        losses = []
        
        # Save model state
        state_dict = {k: v.clone() for k, v in self.model.state_dict().items()}
        
        # Exponential LR increase
        lr_multiplier = (lr_end / lr_start) ** (1 / num_steps)
        lr = lr_start
        
        for i, (batch_x, batch_y) in enumerate(train_loader):
            if i >= num_steps:
                break
            
            batch_x, batch_y = batch_x.to(self.device), batch_y.to(self.device)
            
            self.optimizer.zero_grad()
            outputs = self.model(batch_x)
            loss = self.criterion(outputs, batch_y)
            loss.backward()
            self.optimizer.step()
            
            lrs.append(lr)
            losses.append(loss.item())
            
            lr *= lr_multiplier
            for group in self.optimizer.param_groups:
                group['lr'] = lr
        
        # Restore model state
        self.model.load_state_dict(state_dict)
        
        return lrs, losses
```

---

## Regularization

### Weight Decay

```python
# L2 regularization via weight decay
optimizer = optim.Adam(model.parameters(), lr=0.001, weight_decay=1e-4)

# Different weight decay for different layers
param_groups = [
    {'params': model.conv1.parameters(), 'weight_decay': 1e-4},
    {'params': model.fc.parameters(), 'weight_decay': 1e-3}
]
optimizer = optim.Adam(param_groups, lr=0.001)
```

### Dropout

```python
class RegularizedModel(nn.Module):
    def __init__(self, input_size, hidden_size, output_size, dropout_rate=0.5):
        super().__init__()
        self.layer1 = nn.Linear(input_size, hidden_size)
        self.dropout1 = nn.Dropout(dropout_rate)
        self.layer2 = nn.Linear(hidden_size, hidden_size)
        self.dropout2 = nn.Dropout(dropout_rate)
        self.layer3 = nn.Linear(hidden_size, output_size)
    
    def forward(self, x):
        x = torch.relu(self.layer1(x))
        x = self.dropout1(x)
        x = torch.relu(self.layer2(x))
        x = self.dropout2(x)
        x = self.layer3(x)
        return x

# MC Dropout for uncertainty
def predict_with_uncertainty(model, x, n_samples=100):
    model.train()  # Keep dropout active
    predictions = torch.stack([model(x) for _ in range(n_samples)])
    mean = predictions.mean(dim=0)
    std = predictions.std(dim=0)
    return mean, std
```

### Label Smoothing

```python
class LabelSmoothingLoss(nn.Module):
    def __init__(self, classes, smoothing=0.1):
        super().__init__()
        self.smoothing = smoothing
        self.classes = classes
    
    def forward(self, pred, target):
        log_probs = torch.log_softmax(pred, dim=-1)
        nll_loss = -log_probs.gather(dim=-1, index=target.unsqueeze(1)).squeeze(1)
        smooth_loss = -log_probs.mean(dim=-1)
        loss = (1 - self.smoothing) * nll_loss + self.smoothing * smooth_loss
        return loss.mean()

# PyTorch built-in
criterion = nn.CrossEntropyLoss(label_smoothing=0.1)
```

---

## Data Augmentation

### Image Augmentation

```python
import torchvision.transforms as T

train_transform = T.Compose([
    T.RandomResizedCrop(224, scale=(0.8, 1.0)),
    T.RandomHorizontalFlip(p=0.5),
    T.RandomVerticalFlip(p=0.1),
    T.RandomRotation(15),
    T.ColorJitter(brightness=0.2, contrast=0.2, saturation=0.2),
    T.RandomAffine(degrees=0, translate=(0.1, 0.1)),
    T.ToTensor(),
    T.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
    T.RandomErasing(p=0.2)
])

val_transform = T.Compose([
    T.Resize(256),
    T.CenterCrop(224),
    T.ToTensor(),
    T.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
])
```

### CutMix and Mixup

```python
import numpy as np

def cutmix(data, target, alpha=1.0):
    indices = torch.randperm(data.size(0))
    shuffled_data = data[indices]
    shuffled_target = target[indices]
    
    lam = np.random.beta(alpha, alpha)
    bbx1, bby1, bbx2, bby2 = rand_bbox(data.size(), lam)
    
    data[:, :, bbx1:bbx2, bby1:bby2] = shuffled_data[:, :, bbx1:bbx2, bby1:bby2]
    lam = 1 - ((bbx2 - bbx1) * (bby2 - bby1) / (data.size(-1) * data.size(-2)))
    
    return data, target, shuffled_target, lam

def mixup(data, target, alpha=1.0):
    indices = torch.randperm(data.size(0))
    shuffled_data = data[indices]
    shuffled_target = target[indices]
    
    lam = np.random.beta(alpha, alpha)
    mixed_data = lam * data + (1 - lam) * shuffled_data
    
    return mixed_data, target, shuffled_target, lam

def rand_bbox(size, lam):
    W, H = size[2], size[3]
    cut_rat = np.sqrt(1. - lam)
    cut_w = int(W * cut_rat)
    cut_h = int(H * cut_rat)
    
    cx = np.random.randint(W)
    cy = np.random.randint(H)
    
    bbx1 = np.clip(cx - cut_w // 2, 0, W)
    bby1 = np.clip(cy - cut_h // 2, 0, H)
    bbx2 = np.clip(cx + cut_w // 2, 0, W)
    bby2 = np.clip(cy + cut_h // 2, 0, H)
    
    return bbx1, bby1, bbx2, bby2
```

---

## Mixed Precision Training

```python
from torch.cuda.amp import autocast, GradScaler

class MixedPrecisionTrainer:
    def __init__(self, model, optimizer, criterion, device='cuda'):
        self.model = model.to(device)
        self.optimizer = optimizer
        self.criterion = criterion
        self.scaler = GradScaler()
        self.device = device
    
    def train_step(self, batch_x, batch_y):
        batch_x, batch_y = batch_x.to(self.device), batch_y.to(self.device)
        
        self.optimizer.zero_grad()
        
        with autocast():
            outputs = self.model(batch_x)
            loss = self.criterion(outputs, batch_y)
        
        self.scaler.scale(loss).backward()
        self.scaler.step(self.optimizer)
        self.scaler.update()
        
        return loss.item()

# Full training loop with mixed precision
def train_mixed_precision(model, train_loader, val_loader, epochs=100):
    criterion = nn.CrossEntropyLoss()
    optimizer = optim.AdamW(model.parameters(), lr=0.001, weight_decay=0.01)
    scaler = GradScaler()
    
    for epoch in range(epochs):
        model.train()
        for batch_x, batch_y in train_loader:
            batch_x, batch_y = batch_x.cuda(), batch_y.cuda()
            
            optimizer.zero_grad()
            
            with autocast():
                outputs = model(batch_x)
                loss = criterion(outputs, batch_y)
            
            scaler.scale(loss).backward()
            scaler.step(optimizer)
            scaler.update()
```

---

## Distributed Training

### Data Parallel

```python
import torch.nn as nn

# Simple data parallel
model = nn.DataParallel(model)

# Custom data parallel
class CustomDataParallel(nn.Module):
    def __init__(self, model, device_ids=None):
        super().__init__()
        self.model = nn.DataParallel(model, device_ids)
    
    def forward(self, x):
        return self.model(x)
```

### Distributed Data Parallel

```python
import torch.distributed as dist
from torch.nn.parallel import DistributedDataParallel as DDP

def setup(rank, world_size):
    dist.init_process_group("nccl", rank=rank, world_size=world_size)

def cleanup():
    dist.destroy_process_group()

def train_ddp(rank, world_size, model, train_loader):
    setup(rank, world_size)
    
    model = model.to(rank)
    model = DDP(model, device_ids=[rank])
    
    optimizer = optim.Adam(model.parameters(), lr=0.001)
    
    for epoch in range(100):
        model.train()
        for batch_x, batch_y in train_loader:
            batch_x, batch_y = batch_x.to(rank), batch_y.to(rank)
            
            optimizer.zero_grad()
            outputs = model(batch_x)
            loss = nn.CrossEntropyLoss()(outputs, batch_y)
            loss.backward()
            optimizer.step()
    
    cleanup()
```

---

## Summary

| Technique | Purpose | Impact |
|-----------|---------|--------|
| Learning Rate Scheduling | Optimize convergence | +1-3% accuracy |
| Weight Decay | Prevent overfitting | Regularization |
| Dropout | Prevent overfitting | Generalization |
| Label Smoothing | Better calibration | +0.5-1% accuracy |
| Data Augmentation | More training data | +2-5% accuracy |
| Mixed Precision | Faster training | 2x speed, less memory |
| Distributed Training | Scale to large datasets | Linear speedup |
