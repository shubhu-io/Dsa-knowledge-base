# Computer Vision Interview Questions

## Table of Contents

1. [Image Processing](#image-processing)
2. [Feature Detection](#feature-detection)
3. [Deep Learning for Vision](#deep-learning-for-vision)
4. [Object Detection](#object-detection)
5. [Image Segmentation](#image-segmentation)
6. [Advanced Topics](#advanced-topics)

---

## Image Processing

### 1. What is the difference between erosion and dilation?

**Answer:**

| Operation | Effect | Use Case |
|-----------|--------|----------|
| **Erosion** | Shrinks bright regions, removes noise | Remove small objects |
| **Dilation** | Expands bright regions, fills gaps | Connect nearby objects |

```python
import cv2
import numpy as np

# Erosion - removes white pixels from boundaries
kernel = np.ones((5,5), np.uint8)
eroded = cv2.erode(image, kernel, iterations=1)

# Dilation - adds white pixels to boundaries
dilated = cv2.dilate(image, kernel, iterations=1)

# Opening - erosion followed by dilation (removes noise)
opening = cv2.morphologyEx(image, cv2.MORPH_OPEN, kernel)

# Closing - dilation followed by erosion (fills gaps)
closing = cv2.morphologyEx(image, cv2.MORPH_CLOSE, kernel)
```

### 2. Explain the Canny edge detection algorithm

**Answer:**

```python
def canny_edge_detection(image, low_threshold=50, high_threshold=150):
    # 1. Gaussian blur to reduce noise
    blurred = cv2.GaussianBlur(image, (5, 5), 1.4)
    
    # 2. Compute gradients (Sobel)
    grad_x = cv2.Sobel(blurred, cv2.CV_64F, 1, 0, ksize=3)
    grad_y = cv2.Sobel(blurred, cv2.CV_64F, 0, 1, ksize=3)
    
    # 3. Compute gradient magnitude and direction
    magnitude = np.sqrt(grad_x**2 + grad_y**2)
    direction = np.arctan2(grad_y, grad_x)
    
    # 4. Non-maximum suppression
    # Thin edges by keeping only local maxima
    
    # 5. Double thresholding
    # Strong edges (above high), weak edges (between), non-edges (below low)
    
    # 6. Edge tracking by hysteresis
    # Connect weak edges to strong edges
    
    # Using OpenCV (combines all steps)
    edges = cv2.Canny(image, low_threshold, high_threshold)
    
    return edges
```

**Steps:**
1. Noise reduction (Gaussian blur)
2. Gradient computation (Sobel)
3. Non-maximum suppression
4. Double thresholding
5. Edge tracking by hysteresis

### 3. What is histogram equalization?

**Answer:**
Redistributes pixel intensities to enhance contrast.

```python
import cv2
import numpy as np

def histogram_equalization(image):
    # Convert to grayscale
    if len(image.shape) == 3:
        gray = cv2.cvtColor(image, cv2.COLOR_RGB2GRAY)
    else:
        gray = image
    
    # Compute histogram
    hist = np.zeros(256)
    for pixel in gray.flatten():
        hist[pixel] += 1
    
    # Compute CDF
    cdf = hist.cumsum()
    cdf_normalized = cdf / cdf.max()
    
    # Apply equalization
    equalized = np.zeros_like(gray)
    for i in range(256):
        equalized[gray == i] = np.round(cdf_normalized[i] * 255)
    
    return equalized.astype(np.uint8)

# Using OpenCV
equalized = cv2.equalizeHist(gray)

# CLAHE (Adaptive histogram equalization)
clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8,8))
clahe_equalized = clahe.apply(gray)
```

**When to use:**
- Low contrast images
- Medical imaging
- Before feature extraction

---

## Feature Detection

### 1. Compare SIFT, SURF, and ORB

**Answer:**

| Feature | SIFT | SURF | ORB |
|---------|------|------|-----|
| **Speed** | Slow | Medium | Fast |
| **Descriptor** | 128-dim | 64-dim | 256-bit binary |
| **Invariance** | Scale, rotation | Scale, rotation | Rotation |
| **Patent** | Expired | Patented | Free |
| **Use Case** | Accuracy critical | Balanced | Real-time |

```python
import cv2

# SIFT
sift = cv2.SIFT_create()
keypoints, descriptors = sift.detectAndCompute(gray, None)

# SURF (if available)
# surf = cv2.SURF_create()
# keypoints, descriptors = surf.detectAndCompute(gray, None)

# ORB
orb = cv2.ORB_create(nfeatures=1000)
keypoints, descriptors = orb.detectAndCompute(gray, None)
```

### 2. How does feature matching work?

**Answer:**

```python
import cv2

def match_features(desc1, desc2, method='bf'):
    if method == 'bf':
        # Brute-force matcher
        bf = cv2.BFMatcher(cv2.NORM_L2, crossCheck=False)
        
        # KNN matching
        matches = bf.knnMatch(desc1, desc2, k=2)
        
        # Lowe's ratio test
        good_matches = []
        for m, n in matches:
            if m.distance < 0.75 * n.distance:
                good_matches.append(m)
        
        return good_matches
    
    elif method == 'flann':
        # FLANN-based matcher (faster for large datasets)
        FLANN_INDEX_KDTREE = 1
        index_params = dict(algorithm=FLANN_INDEX_KDTREE, trees=5)
        search_params = dict(checks=50)
        
        flann = cv2.FlannBasedMatcher(index_params, search_params)
        matches = flann.knnMatch(desc1, desc2, k=2)
        
        # Apply ratio test
        good_matches = [m for m, n in matches if m.distance < 0.7 * n.distance]
        
        return good_matches
```

### 3. What is homography?

**Answer:**
A transformation that maps points from one plane to another.

```python
import cv2
import numpy as np

def compute_homography(pts1, pts2):
    # Find homography matrix
    H, mask = cv2.findHomography(pts1, pts2, cv2.RANSAC, 5.0)
    return H, mask

def warp_image(image, H, output_shape):
    return cv2.warpPerspective(image, H, output_shape)

# Applications:
# - Image stitching
# - Document scanning
# - Augmented reality
# - Perspective correction

# Example: Image stitching
def stitch_images(img1, img2):
    # Detect features
    sift = cv2.SIFT_create()
    kp1, des1 = sift.detectAndCompute(cv2.cvtColor(img1, cv2.COLOR_RGB2GRAY), None)
    kp2, des2 = sift.detectAndCompute(cv2.cvtColor(img2, cv2.COLOR_RGB2GRAY), None)
    
    # Match features
    bf = cv2.BFMatcher()
    matches = bf.knnMatch(des1, des2, k=2)
    good_matches = [m for m, n in matches if m.distance < 0.7 * n.distance]
    
    # Compute homography
    pts1 = np.float32([kp1[m.queryIdx].pt for m in good_matches]).reshape(-1, 1, 2)
    pts2 = np.float32([kp2[m.trainIdx].pt for m in good_matches]).reshape(-1, 1, 2)
    
    H, mask = cv2.findHomography(pts1, pts2, cv2.RANSAC)
    
    # Warp and stitch
    result = cv2.warpPerspective(img1, H, (img2.shape[1] + img1.shape[1], img2.shape[0]))
    result[0:img2.shape[0], 0:img2.shape[1]] = img2
    
    return result
```

---

## Deep Learning for Vision

### 1. Why use CNNs instead of fully connected networks for images?

**Answer:**

| Aspect | CNN | Fully Connected |
|--------|-----|-----------------|
| **Parameters** | Few (shared weights) | Many (no weight sharing) |
| **Spatial Invariance** | Yes | No |
| **Translation Invariance** | Yes | No |
| **Memory** | Efficient | Inefficient |
| **Overfitting** | Less prone | More prone |

```python
# Fully connected for 224x224x3 image with 1000 outputs
# Parameters: 224 * 224 * 3 * 1000 = 150,528,000

# CNN (ResNet-50)
# Parameters: ~25,500,000 (much fewer!)

import torch.nn as nn

# Example CNN
class SimpleCNN(nn.Module):
    def __init__(self):
        super().__init__()
        self.conv1 = nn.Conv2d(3, 32, 3, padding=1)  # 3*32*3 + 32 = 320 params
        self.pool = nn.MaxPool2d(2, 2)
        self.conv2 = nn.Conv2d(32, 64, 3, padding=1)  # 32*64*3 + 64 = 18,496 params
        self.fc = nn.Linear(64 * 56 * 56, 10)
```

### 2. What is transfer learning and when to use it?

**Answer:**

```python
from torchvision import models
import torch.nn as nn

def transfer_learning_example(num_classes, strategy='feature_extraction'):
    # Load pre-trained model
    model = models.resnet50(pretrained=True)
    
    if strategy == 'feature_extraction':
        # Freeze all layers
        for param in model.parameters():
            param.requires_grad = False
        
        # Replace final layer
        model.fc = nn.Linear(model.fc.in_features, num_classes)
        
    elif strategy == 'fine_tuning':
        # Unfreeze all layers
        for param in model.parameters():
            param.requires_grad = True
        
        # Replace final layer
        model.fc = nn.Linear(model.fc.in_features, num_classes)
        
        # Use smaller learning rate
        optimizer = torch.optim.Adam(model.parameters(), lr=1e-4)
    
    return model

# When to use transfer learning:
# 1. Small dataset (< 1000 samples)
# 2. Similar domain to pre-trained model
# 3. Limited computational resources
# 4. Need good performance quickly
```

### 3. Explain data augmentation techniques

**Answer:**

```python
import torchvision.transforms as T

# Geometric augmentations
geometric_transforms = T.Compose([
    T.RandomHorizontalFlip(p=0.5),
    T.RandomVerticalFlip(p=0.1),
    T.RandomRotation(15),
    T.RandomResizedCrop(224, scale=(0.8, 1.0)),
    T.RandomAffine(degrees=0, translate=(0.1, 0.1))
])

# Color augmentations
color_transforms = T.Compose([
    T.ColorJitter(brightness=0.2, contrast=0.2, saturation=0.2, hue=0.1),
    T.RandomGrayscale(p=0.2),
    T.RandomAutocontrast(p=0.2)
])

# Advanced augmentations
# - Cutout: Random rectangular regions masked
# - Mixup: Blend two images
# - CutMix: Cut and paste patches between images
# - RandAugment: Random combination of augmentations

# Example Mixup
def mixup(image1, image2, label1, label2, alpha=0.2):
    lam = np.random.beta(alpha, alpha)
    mixed_image = lam * image1 + (1 - lam) * image2
    return mixed_image, label1, label2, lam
```

---

## Object Detection

### 1. Compare one-stage vs two-stage detectors

**Answer:**

| Aspect | One-Stage (YOLO, SSD) | Two-Stage (R-CNN) |
|--------|----------------------|-------------------|
| **Speed** | Faster | Slower |
| **Accuracy** | Lower | Higher |
| **Small Objects** | Struggles | Better |
| **Training** | Easier | More complex |
| **Use Case** | Real-time | Accuracy critical |

```python
# One-Stage (YOLO-like)
class OneStageDetector:
    def __init__(self):
        # Single network predicts boxes and classes directly
        pass

# Two-Stage (R-CNN-like)
class TwoStageDetector:
    def __init__(self):
        # Stage 1: Region proposals
        # Stage 2: Classification and refinement
        pass
```

### 2. What is Non-Maximum Suppression (NMS)?

**Answer:**
Removes overlapping bounding boxes, keeping only the best one.

```python
def non_max_suppression(boxes, scores, iou_threshold=0.5):
    # Sort by score
    indices = scores.argsort()[::-1]
    keep = []
    
    while len(indices) > 0:
        current = indices[0]
        keep.append(current)
        
        # Compute IoU with remaining boxes
        ious = compute_iou(boxes[current], boxes[indices[1:]])
        
        # Remove boxes with high IoU
        indices = indices[1:][ious < iou_threshold]
    
    return keep

def compute_iou(box1, boxes):
    x1 = np.maximum(box1[0], boxes[:, 0])
    y1 = np.maximum(box1[1], boxes[:, 1])
    x2 = np.minimum(box1[2], boxes[:, 2])
    y2 = np.minimum(box1[3], boxes[:, 3])
    
    intersection = np.maximum(0, x2 - x1) * np.maximum(0, y2 - y1)
    
    box1_area = (box1[2] - box1[0]) * (box1[3] - box1[1])
    boxes_area = (boxes[:, 2] - boxes[:, 0]) * (boxes[:, 3] - boxes[:, 1])
    
    union = box1_area + boxes_area - intersection
    
    return intersection / union
```

### 3. What is anchor box?

**Answer:**
Pre-defined bounding box shapes used to predict object locations.

```python
# Anchor boxes for different scales
anchor_boxes = {
    'small': [(10, 13), (16, 30), (33, 23)],
    'medium': [(30, 61), (62, 45), (59, 119)],
    'large': [(116, 90), (156, 198), (373, 326)]
}

# Feature map predicts offsets from anchor boxes
# Final box = anchor + predicted offset

# Anchor generation (k-means on training data)
def generate_anchors(boxes, num_clusters=9):
    from sklearn.cluster import KMeans
    
    # Compute widths and heights
    wh = np.array([[b[2]-b[0], b[3]-b[1]] for b in boxes])
    
    # K-means clustering
    kmeans = KMeans(n_clusters=num_clusters, random_state=42)
    kmeans.fit(wh)
    
    return kmeans.cluster_centers_
```

---

## Image Segmentation

### 1. Compare semantic, instance, and panoptic segmentation

**Answer:**

| Type | Output | Use Case |
|------|--------|----------|
| **Semantic** | Label per pixel (all same class = same label) | Road segmentation |
| **Instance** | Separate label per instance | Object detection |
| **Panoptic** | Semantic + Instance combined | Scene understanding |

```python
# Semantic: All "car" pixels have same label
# Instance: Each car has unique label
# Panoptic: Combines both (stuff = semantic, things = instance)

# Example outputs
semantic = [[0, 0, 1, 1, 1],  # 0=road, 1=car
            [0, 0, 1, 1, 1]]

instance = [[0, 0, 1, 1, 2],  # 0=road, 1=car1, 2=car2
            [0, 0, 1, 1, 2]]

panoptic = [[0, 0, 1, 2, 2],  # Stuff (road) + Things (car1, car2)
            [0, 0, 1, 2, 2]]
```

### 2. What is the Dice coefficient?

**Answer:**
Measures overlap between predicted and ground truth masks.

```python
def dice_coefficient(pred_mask, true_mask, smooth=1):
    intersection = np.sum(pred_mask & true_mask)
    return (2 * intersection + smooth) / (np.sum(pred_mask) + np.sum(true_mask) + smooth)

def dice_loss(pred_mask, true_mask):
    return 1 - dice_coefficient(pred_mask, true_mask)

# Dice vs IoU
# Dice = 2 * Intersection / (Pred + Truth)
# IoU = Intersection / Union
# Dice = 2 * IoU / (1 + IoU)
```

### 3. Explain U-Net architecture

**Answer:**

```python
import torch
import torch.nn as nn

class UNet(nn.Module):
    def __init__(self, in_channels=1, out_channels=1):
        super().__init__()
        
        # Encoder (contracting path)
        self.enc1 = self._block(in_channels, 64)
        self.enc2 = self._block(64, 128)
        self.enc3 = self._block(128, 256)
        self.enc4 = self._block(256, 512)
        
        self.pool = nn.MaxPool2d(2, 2)
        
        # Bottleneck
        self.bottleneck = self._block(512, 1024)
        
        # Decoder (expanding path)
        self.upconv4 = nn.ConvTranspose2d(1024, 512, 2, stride=2)
        self.dec4 = self._block(1024, 512)
        self.upconv3 = nn.ConvTranspose2d(512, 256, 2, stride=2)
        self.dec3 = self._block(512, 256)
        self.upconv2 = nn.ConvTranspose2d(256, 128, 2, stride=2)
        self.dec2 = self._block(256, 128)
        self.upconv1 = nn.ConvTranspose2d(128, 64, 2, stride=2)
        self.dec1 = self._block(128, 64)
        
        self.final = nn.Conv2d(64, out_channels, 1)
    
    def _block(self, in_ch, out_ch):
        return nn.Sequential(
            nn.Conv2d(in_ch, out_ch, 3, padding=1),
            nn.BatchNorm2d(out_ch),
            nn.ReLU(inplace=True),
            nn.Conv2d(out_ch, out_ch, 3, padding=1),
            nn.BatchNorm2d(out_ch),
            nn.ReLU(inplace=True)
        )
    
    def forward(self, x):
        # Encoder
        e1 = self.enc1(x)
        e2 = self.enc2(self.pool(e1))
        e3 = self.enc3(self.pool(e2))
        e4 = self.enc4(self.pool(e3))
        
        # Bottleneck
        b = self.bottleneck(self.pool(e4))
        
        # Decoder with skip connections
        d4 = self.dec4(torch.cat([self.upconv4(b), e4], dim=1))
        d3 = self.dec3(torch.cat([self.upconv3(d4), e3], dim=1))
        d2 = self.dec2(torch.cat([self.upconv2(d3), e2], dim=1))
        d1 = self.dec1(torch.cat([self.upconv1(d2), e1], dim=1))
        
        return self.final(d1)
```

**Key features:**
- Symmetric encoder-decoder
- Skip connections preserve spatial info
- Good for biomedical segmentation
- Works with small datasets

---

## Advanced Topics

### 1. What is self-supervised learning for vision?

**Answer:**
Learning representations without labeled data.

```python
# Contrastive Learning (SimCLR)
class SimCLR(nn.Module):
    def __init__(self, backbone):
        super().__init__()
        self.backbone = backbone
        self.projector = nn.Sequential(
            nn.Linear(2048, 2048),
            nn.ReLU(),
            nn.Linear(2048, 128)
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

# Other methods:
# - BYOL (Bootstrap Your Own Latent)
# - MoCo (Momentum Contrast)
# - DINO (Self-distillation)
```

### 2. Explain Vision Transformers (ViT)

**Answer:**

```python
import torch
import torch.nn as nn

class ViT(nn.Module):
    def __init__(self, img_size=224, patch_size=16, num_classes=1000,
                 embed_dim=768, depth=12, heads=12):
        super().__init__()
        self.patch_size = patch_size
        num_patches = (img_size // patch_size) ** 2
        
        # Patch embedding
        self.patch_embed = nn.Conv2d(3, embed_dim, kernel_size=patch_size, stride=patch_size)
        
        # CLS token and position embedding
        self.cls_token = nn.Parameter(torch.randn(1, 1, embed_dim))
        self.pos_embed = nn.Parameter(torch.randn(1, num_patches + 1, embed_dim))
        
        # Transformer
        encoder_layer = nn.TransformerEncoderLayer(d_model=embed_dim, nhead=heads, dim_feedforward=embed_dim*4)
        self.transformer = nn.TransformerEncoder(encoder_layer, num_layers=depth)
        
        # Classification head
        self.head = nn.Linear(embed_dim, num_classes)
    
    def forward(self, x):
        B = x.shape[0]
        
        # Patch embedding
        x = self.patch_embed(x).flatten(2).transpose(1, 2)
        
        # Add CLS token
        cls_tokens = self.cls_token.expand(B, -1, -1)
        x = torch.cat([cls_tokens, x], dim=1)
        
        # Add position embedding
        x = x + self.pos_embed
        
        # Transformer
        x = self.transformer(x)
        
        # Classification
        x = x[:, 0]  # CLS token
        return self.head(x)
```

**Key differences from CNNs:**
- No inductive bias (locality, translation invariance)
- Requires more data
- Global attention from first layer
- More interpretable (attention maps)

### 3. What are the challenges in medical image analysis?

**Answer:**

| Challenge | Description | Solution |
|-----------|-------------|----------|
| **Small datasets** | Limited labeled data | Transfer learning, augmentation |
| **Class imbalance** | Rare diseases underrepresented | Oversampling, focal loss |
| **3D volumes** | Large data, memory issues | 3D U-Net, patch-based |
| **Annotation cost** | Expert time expensive | Semi-supervised, active learning |
| **Domain shift** | Different scanners/formats | Domain adaptation |
| **Interpretability** | Need to explain decisions | Attention maps, Grad-CAM |

```python
# Example: Handling class imbalance in medical imaging
def weighted_cross_entropy(num_classes, class_weights):
    return nn.CrossEntropyLoss(weight=torch.FloatTensor(class_weights))

# Focal loss for imbalanced datasets
class FocalLoss(nn.Module):
    def __init__(self, alpha=0.25, gamma=2.0):
        super().__init__()
        self.alpha = alpha
        self.gamma = gamma
    
    def forward(self, inputs, targets):
        ce_loss = nn.functional.cross_entropy(inputs, targets, reduction='none')
        pt = torch.exp(-ce_loss)
        focal_loss = self.alpha * (1 - pt) ** self.gamma * ce_loss
        return focal_loss.mean()
```

---

## Quick Reference

| Concept | Key Point |
|---------|-----------|
| Erosion | Shrinks bright regions |
| Dilation | Expands bright regions |
| Canny | Multi-stage edge detection |
| Histogram Equalization | Contrast enhancement |
| SIFT | Scale-invariant features |
| Homography | Plane-to-plane mapping |
| NMS | Remove duplicate detections |
| Anchor Boxes | Pre-defined box shapes |
| Dice Coefficient | Segmentation metric |
| U-Net | Skip-connection segmentation |
| ViT | Patch-based attention |
| SimCLR | Contrastive learning |
