# Deep Learning with PyTorch

This document covers deep learning concepts and implementation using PyTorch.

## Introduction to PyTorch

### What is PyTorch?
PyTorch is an open-source machine learning library based on the Torch library. It's used for applications such as computer vision and natural language processing.

### Key Features
- **Dynamic Computation Graph**: Define and modify graphs on-the-fly
- **Pythonic Interface**: Natural Python control flow
- **GPU Acceleration**: Seamless CUDA support
- **Rich Ecosystem**: TorchVision, TorchText, TorchAudio

## Installation and Setup

### Installation
```bash
# Install PyTorch
pip install torch torchvision torchaudio

# For CUDA support
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
```

### Basic Imports
```python
import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import DataLoader, Dataset
import torchvision.transforms as transforms
```

## Tensors

### Creating Tensors
```python
# From Python list
x = torch.tensor([1, 2, 3])

# Random tensor
x = torch.rand(3, 4)

# Zeros/Ones
x = torch.zeros(3, 4)
x = torch.ones(3, 4)

# From NumPy
import numpy as np
np_array = np.array([1, 2, 3])
tensor = torch.from_numpy(np_array)
```

### Tensor Operations
```python
# Basic operations
y = x + 1
y = x * 2
y = torch.mm(x, x.T)  # Matrix multiplication

# Reshape
x = torch.randn(4, 4)
y = x.view(16)  # Flatten
y = x.view(2, 8)  # Reshape

# Indexing
y = x[0, :]  # First row
y = x[:, 0]  # First column
```

## Neural Networks

### Defining a Model
```python
class SimpleNN(nn.Module):
    def __init__(self, input_size, hidden_size, num_classes):
        super(SimpleNN, self).__init__()
        self.fc1 = nn.Linear(input_size, hidden_size)
        self.relu = nn.ReLU()
        self.fc2 = nn.Linear(hidden_size, num_classes)
    
    def forward(self, x):
        out = self.fc1(x)
        out = self.relu(out)
        out = self.fc2(out)
        return out

# Create model
model = SimpleNN(input_size=784, hidden_size=128, num_classes=10)
```

### Training Loop
```python
# Loss and optimizer
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(model.parameters(), lr=0.001)

# Training
for epoch in range(num_epochs):
    for i, (images, labels) in enumerate(train_loader):
        # Forward pass
        outputs = model(images)
        loss = criterion(outputs, labels)
        
        # Backward pass and optimize
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
        
        if (i+1) % 100 == 0:
            print(f'Epoch [{epoch+1}/{num_epochs}], Step [{i+1}/{len(train_loader)}], Loss: {loss.item():.4f}')
```

## Convolutional Neural Networks (CNNs)

### CNN Architecture
```python
class CNN(nn.Module):
    def __init__(self, num_classes=10):
        super(CNN, self).__init__()
        self.conv1 = nn.Conv2d(1, 32, kernel_size=3, padding=1)
        self.conv2 = nn.Conv2d(32, 64, kernel_size=3, padding=1)
        self.pool = nn.MaxPool2d(2, 2)
        self.fc1 = nn.Linear(64 * 7 * 7, 128)
        self.fc2 = nn.Linear(128, num_classes)
        self.relu = nn.ReLU()
    
    def forward(self, x):
        x = self.pool(self.relu(self.conv1(x)))
        x = self.pool(self.relu(self.conv2(x)))
        x = x.view(-1, 64 * 7 * 7)
        x = self.relu(self.fc1(x))
        x = self.fc2(x)
        return x
```

### Transfer Learning
```python
import torchvision.models as models

# Load pre-trained model
model = models.resnet18(pretrained=True)

# Replace final layer
num_features = model.fc.in_features
model.fc = nn.Linear(num_features, num_classes)

# Freeze early layers
for param in model.parameters():
    param.requires_grad = False

# Only train new layer
model.fc.requires_grad_(True)
```

## Recurrent Neural Networks (RNNs)

### LSTM Model
```python
class LSTM(nn.Module):
    def __init__(self, input_size, hidden_size, num_layers, num_classes):
        super(LSTM, self).__init__()
        self.hidden_size = hidden_size
        self.num_layers = num_layers
        self.lstm = nn.LSTM(input_size, hidden_size, num_layers, batch_first=True)
        self.fc = nn.Linear(hidden_size, num_classes)
    
    def forward(self, x):
        # Initialize hidden state
        h0 = torch.zeros(self.num_layers, x.size(0), self.hidden_size).to(device)
        c0 = torch.zeros(self.num_layers, x.size(0), self.hidden_size).to(device)
        
        # Forward propagate LSTM
        out, _ = self.lstm(x, (h0, c0))
        
        # Decode the hidden state of the last time step
        out = self.fc(out[:, -1, :])
        return out
```

## Data Loading

### Custom Dataset
```python
class CustomDataset(Dataset):
    def __init__(self, data, labels, transform=None):
        self.data = data
        self.labels = labels
        self.transform = transform
    
    def __len__(self):
        return len(self.data)
    
    def __getitem__(self, idx):
        sample = self.data[idx]
        label = self.labels[idx]
        
        if self.transform:
            sample = self.transform(sample)
        
        return sample, label
```

### DataLoader
```python
# Create dataset
train_dataset = CustomDataset(train_data, train_labels, transform=transforms.ToTensor())

# Create data loader
train_loader = DataLoader(
    dataset=train_dataset,
    batch_size=32,
    shuffle=True,
    num_workers=4
)
```

## Model Evaluation

### Evaluation Loop
```python
model.eval()  # Set to evaluation mode
with torch.no_grad():  # Disable gradient computation
    correct = 0
    total = 0
    for images, labels in test_loader:
        outputs = model(images)
        _, predicted = torch.max(outputs.data, 1)
        total += labels.size(0)
        correct += (predicted == labels).sum().item()
    
    print(f'Accuracy: {100 * correct / total}%')
```

### Confusion Matrix
```python
from sklearn.metrics import confusion_matrix
import numpy as np

all_preds = []
all_labels = []

model.eval()
with torch.no_grad():
    for images, labels in test_loader:
        outputs = model(images)
        _, predicted = torch.max(outputs, 1)
        all_preds.extend(predicted.cpu().numpy())
        all_labels.extend(labels.cpu().numpy())

cm = confusion_matrix(all_labels, all_preds)
print(cm)
```

## GPU Acceleration

### Moving to GPU
```python
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
print(f'Using device: {device}')

# Move model to GPU
model = model.to(device)

# Move data to GPU
for images, labels in train_loader:
    images = images.to(device)
    labels = labels.to(device)
    # Training step...
```

## Saving and Loading Models

### Save Model
```python
# Save entire model
torch.save(model, 'model.pth')

# Save state dict (recommended)
torch.save(model.state_dict(), 'model_state_dict.pth')
```

### Load Model
```python
# Load entire model
model = torch.load('model.pth')

# Load state dict
model = SimpleNN(input_size=784, hidden_size=128, num_classes=10)
model.load_state_dict(torch.load('model_state_dict.pth'))
model.eval()
```

## Hyperparameter Tuning

### Common Hyperparameters
- **Learning Rate**: 0.001, 0.0001
- **Batch Size**: 32, 64, 128
- **Hidden Size**: 64, 128, 256
- **Number of Layers**: 2, 3, 4

### Learning Rate Scheduling
```python
# StepLR scheduler
scheduler = optim.lr_scheduler.StepLR(optimizer, step_size=10, gamma=0.1)

# For each epoch
for epoch in range(num_epochs):
    train(...)
    scheduler.step()
```

## Best Practices

### Code Organization
1. Use separate files for model, dataset, training
2. Use configuration files for hyperparameters
3. Log experiments with TensorBoard or W&B
4. Version control your code

### Training Tips
1. Start with simple models
2. Monitor training and validation loss
3. Use data augmentation
4. Apply regularization (dropout, weight decay)
5. Early stopping to prevent overfitting

### Common Pitfalls
1. **Data leakage**: Ensure no test data in training
2. **Overfitting**: Monitor validation metrics
3. **Gradient vanishing/exploding**: Use proper initialization
4. **Incorrect preprocessing**: Match training/inference preprocessing

## Resources

### Official Resources
- [PyTorch Documentation](https://pytorch.org/docs/stable/)
- [PyTorch Tutorials](https://pytorch.org/tutorials/)
- [PyTorch Examples](https://github.com/pytorch/examples)

### Learning Materials
- **Deep Learning with PyTorch** (book by Eli Stevens)
- **fast.ai courses** (practical deep learning)
- **PyTorch Lightning** (high-level training framework)

## See Also

- [[deep-learning-guide]]
- [[deep-learning-architectures]]
- [[deep-learning-training]]
- [[deep-learning-interview-questions]]
