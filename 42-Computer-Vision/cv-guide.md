# Computer Vision Complete Guide

## Table of Contents

1. [Image Basics](#image-basics)
2. [Image Processing](#image-processing)
3. [Feature Detection](#feature-detection)
4. [Classical CV Algorithms](#classical-cv-algorithms)
5. [Deep Learning for Vision](#deep-learning-for-vision)
6. [Modern Architectures](#modern-architectures)

---

## Image Basics

### Image as Data

```python
import numpy as np
from PIL import Image
import cv2

class ImageBasics:
    def load_image(self, path):
        # PIL
        img_pil = Image.open(path)
        
        # OpenCV
        img_cv2 = cv2.imread(path)
        
        # Convert to numpy
        img_np = np.array(img_pil)
        
        return img_np
    
    def image_info(self, img):
        return {
            'shape': img.shape,
            'dtype': img.dtype,
            'min': img.min(),
            'max': img.max(),
            'size': img.size
        }
    
    def color_conversions(self, img):
        # RGB to Grayscale
        gray = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY)
        
        # RGB to HSV
        hsv = cv2.cvtColor(img, cv2.COLOR_RGB2HSV)
        
        # RGB to BGR (OpenCV)
        bgr = cv2.cvtColor(img, cv2.COLOR_RGB2BGR)
        
        return gray, hsv, bgr
    
    def channel_operations(self, img):
        # Split channels
        r, g, b = cv2.split(img)
        
        # Merge channels
        merged = cv2.merge([r, g, b])
        
        # Access single channel
        red_channel = img[:, :, 0]
        
        return r, g, b, merged
```

### Image Operations

```python
class ImageOperations:
    def resize(self, img, width, height):
        return cv2.resize(img, (width, height), interpolation=cv2.INTER_LINEAR)
    
    def crop(self, img, x, y, w, h):
        return img[y:y+h, x:x+w]
    
    def rotate(self, img, angle, center=None):
        h, w = img.shape[:2]
        if center is None:
            center = (w // 2, h // 2)
        
        M = cv2.getRotationMatrix2D(center, angle, 1.0)
        return cv2.warpAffine(img, M, (w, h))
    
    def flip(self, img, direction='horizontal'):
        if direction == 'horizontal':
            return cv2.flip(img, 1)
        elif direction == 'vertical':
            return cv2.flip(img, 0)
        else:
            return cv2.flip(img, -1)
    
    def translate(self, img, x, y):
        M = np.float32([[1, 0, x], [0, 1, y]])
        h, w = img.shape[:2]
        return cv2.warpAffine(img, M, (w, h))
```

---

## Image Processing

### Filtering

```python
class ImageFiltering:
    def gaussian_blur(self, img, kernel_size=5):
        return cv2.GaussianBlur(img, (kernel_size, kernel_size), 0)
    
    def median_blur(self, img, kernel_size=5):
        return cv2.medianBlur(img, kernel_size)
    
    def bilateral_filter(self, img, d=9, sigma_color=75, sigma_space=75):
        return cv2.bilateralFilter(img, d, sigma_color, sigma_space)
    
    def sharpen(self, img):
        kernel = np.array([[-1, -1, -1],
                          [-1,  9, -1],
                          [-1, -1, -1]])
        return cv2.filter2D(img, -1, kernel)
    
    def edge_detection(self, img, method='canny'):
        gray = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY)
        
        if method == 'sobel':
            sobelx = cv2.Sobel(gray, cv2.CV_64F, 1, 0, ksize=5)
            sobely = cv2.Sobel(gray, cv2.CV_64F, 0, 1, ksize=5)
            return cv2.magnitude(sobelx, sobely)
        elif method == 'laplacian':
            return cv2.Laplacian(gray, cv2.CV_64F)
        elif method == 'canny':
            return cv2.Canny(gray, 100, 200)
```

### Morphological Operations

```python
class MorphologicalOps:
    def __init__(self, kernel_size=5):
        self.kernel = np.ones((kernel_size, kernel_size), np.uint8)
    
    def erosion(self, img, iterations=1):
        return cv2.erode(img, self.kernel, iterations=iterations)
    
    def dilation(self, img, iterations=1):
        return cv2.dilate(img, self.kernel, iterations=iterations)
    
    def opening(self, img):
        return cv2.morphologyEx(img, cv2.MORPH_OPEN, self.kernel)
    
    def closing(self, img):
        return cv2.morphologyEx(img, cv2.MORPH_CLOSE, self.kernel)
    
    def gradient(self, img):
        return cv2.morphologyEx(img, cv2.MORPH_GRADIENT, self.kernel)
```

### Color Space Operations

```python
class ColorOperations:
    def histogram_equalization(self, img):
        if len(img.shape) == 3:
            # Convert to YUV
            yuv = cv2.cvtColor(img, cv2.COLOR_RGB2YUV)
            yuv[:,:,0] = cv2.equalizeHist(yuv[:,:,0])
            return cv2.cvtColor(yuv, cv2.COLOR_YUV2RGB)
        else:
            return cv2.equalizeHist(img)
    
    def color_thresholding(self, img, lower, upper, color_space='hsv'):
        if color_space == 'hsv':
            hsv = cv2.cvtColor(img, cv2.COLOR_RGB2HSV)
            mask = cv2.inRange(hsv, lower, upper)
        elif color_space == 'rgb':
            mask = cv2.inRange(img, lower, upper)
        return mask
    
    def color_transfer(self, source, target):
        # Transfer color statistics
        source_lab = cv2.cvtColor(source, cv2.COLOR_RGB2LAB).astype(np.float32)
        target_lab = cv2.cvtColor(target, cv2.COLOR_RGB2LAB).astype(np.float32)
        
        for i in range(3):
            src_mean, src_std = source_lab[:,:,i].mean(), source_lab[:,:,i].std()
            tgt_mean, tgt_std = target_lab[:,:,i].mean(), target_lab[:,:,i].std()
            
            target_lab[:,:,i] = (target_lab[:,:,i] - tgt_mean) * (src_std / tgt_std) + src_mean
        
        return cv2.cvtColor(target_lab.astype(np.uint8), cv2.COLOR_LAB2RGB)
```

---

## Feature Detection

### Corner Detection

```python
class CornerDetection:
    def harris_corners(self, img, block_size=2, ksize=3, k=0.04):
        gray = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY).astype(np.float32)
        harris = cv2.cornerHarris(gray, block_size, ksize, k)
        harris = cv2.dilate(harris, None)
        
        # Threshold
        corner_img = img.copy()
        corner_img[harris > 0.01 * harris.max()] = [255, 0, 0]
        
        return corner_img, harris
    
    def shi_tomasi(self, img, max_corners=100, quality=0.01, min_distance=10):
        gray = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY)
        corners = cv2.goodFeaturesToTrack(gray, max_corners, quality, min_distance)
        
        if corners is not None:
            corner_img = img.copy()
            for corner in corners:
                x, y = corner.ravel()
                cv2.circle(corner_img, (int(x), int(y)), 5, (0, 255, 0), -1)
            return corner_img, corners
        return img, None
```

### Feature Matching

```python
class FeatureMatching:
    def __init__(self):
        self.sift = cv2.SIFT_create()
        self.orb = cv2.ORB_create()
    
    def detect_and_compute(self, img, method='sift'):
        gray = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY)
        
        if method == 'sift':
            keypoints, descriptors = self.sift.detectAndCompute(gray, None)
        elif method == 'orb':
            keypoints, descriptors = self.orb.detectAndCompute(gray, None)
        
        return keypoints, descriptors
    
    def match_features(self, desc1, desc2, method='bf'):
        if method == 'bf':
            bf = cv2.BFMatcher()
            matches = bf.knnMatch(desc1, desc2, k=2)
            
            # Lowe's ratio test
            good_matches = []
            for m, n in matches:
                if m.distance < 0.75 * n.distance:
                    good_matches.append(m)
            
            return good_matches
        elif method == 'flann':
            FLANN_INDEX_KDTREE = 1
            index_params = dict(algorithm=FLANN_INDEX_KDTREE, trees=5)
            search_params = dict(checks=50)
            flann = cv2.FlannBasedMatcher(index_params, search_params)
            return flann.knnMatch(desc1, desc2, k=2)
```

---

## Classical CV Algorithms

### Thresholding

```python
class Thresholding:
    def global_threshold(self, img, threshold=127):
        _, binary = cv2.threshold(img, threshold, 255, cv2.THRESH_BINARY)
        return binary
    
    def adaptive_threshold(self, img):
        gray = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY) if len(img.shape) == 3 else img
        return cv2.adaptiveThreshold(gray, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C,
                                     cv2.THRESH_BINARY, 11, 2)
    
    def otsu_threshold(self, img):
        gray = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY) if len(img.shape) == 3 else img
        _, binary = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
        return binary
```

### Contour Detection

```python
class ContourDetection:
    def find_contours(self, img):
        gray = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY) if len(img.shape) == 3 else img
        _, binary = cv2.threshold(gray, 127, 255, cv2.THRESH_BINARY)
        contours, hierarchy = cv2.findContours(binary, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
        return contours, hierarchy
    
    def draw_contours(self, img, contours):
        contour_img = img.copy()
        cv2.drawContours(contour_img, contours, -1, (0, 255, 0), 2)
        return contour_img
    
    def filter_contours(self, contours, min_area=100, max_area=10000):
        filtered = []
        for cnt in contours:
            area = cv2.contourArea(cnt)
            if min_area < area < max_area:
                filtered.append(cnt)
        return filtered
    
    def contour_features(self, contour):
        return {
            'area': cv2.contourArea(contour),
            'perimeter': cv2.arcLength(contour, True),
            'bounding_rect': cv2.boundingRect(contour),
            'centroid': self._get_centroid(contour),
            'circularity': 4 * np.pi * cv2.contourArea(contour) / (cv2.arcLength(contour, True) ** 2)
        }
    
    def _get_centroid(self, contour):
        M = cv2.moments(contour)
        if M['m00'] != 0:
            cx = int(M['m10'] / M['m00'])
            cy = int(M['m01'] / M['m00'])
            return (cx, cy)
        return None
```

### Hough Transform

```python
class HoughTransform:
    def detect_lines(self, img):
        gray = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY) if len(img.shape) == 3 else img
        edges = cv2.Canny(gray, 50, 150)
        lines = cv2.HoughLinesP(edges, 1, np.pi/180, threshold=80,
                                minLineLength=100, maxLineGap=10)
        return lines
    
    def detect_circles(self, img):
        gray = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY) if len(img.shape) == 3 else img
        gray = cv2.medianBlur(gray, 5)
        circles = cv2.HoughCircles(gray, cv2.HOUGH_GRADIENT, dp=1, minDist=50,
                                   param1=100, param2=30, minRadius=10, maxRadius=100)
        return circles
    
    def draw_lines(self, img, lines):
        line_img = img.copy()
        if lines is not None:
            for line in lines:
                x1, y1, x2, y2 = line[0]
                cv2.line(line_img, (x1, y1), (x2, y2), (0, 255, 0), 2)
        return line_img
```

---

## Deep Learning for Vision

### CNN Basics

```python
import torch
import torch.nn as nn

class SimpleCNN(nn.Module):
    def __init__(self, num_classes=10):
        super().__init__()
        self.features = nn.Sequential(
            nn.Conv2d(3, 32, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.MaxPool2d(2, 2),
            nn.Conv2d(32, 64, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.MaxPool2d(2, 2),
            nn.Conv2d(64, 128, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.MaxPool2d(2, 2)
        )
        self.classifier = nn.Sequential(
            nn.Flatten(),
            nn.Linear(128 * 4 * 4, 256),
            nn.ReLU(),
            nn.Dropout(0.5),
            nn.Linear(256, num_classes)
        )
    
    def forward(self, x):
        x = self.features(x)
        x = self.classifier(x)
        return x

# Transfer learning
from torchvision import models

def create_transfer_model(num_classes, pretrained=True):
    model = models.resnet50(pretrained=pretrained)
    
    # Freeze early layers
    for param in list(model.parameters())[:-10]:
        param.requires_grad = False
    
    # Replace final layer
    num_features = model.fc.in_features
    model.fc = nn.Linear(num_features, num_classes)
    
    return model
```

---

## Modern Architectures

### Vision Transformer (ViT)

```python
class PatchEmbedding(nn.Module):
    def __init__(self, img_size=224, patch_size=16, in_channels=3, embed_dim=768):
        super().__init__()
        self.num_patches = (img_size // patch_size) ** 2
        self.proj = nn.Conv2d(in_channels, embed_dim, kernel_size=patch_size, stride=patch_size)
        self.cls_token = nn.Parameter(torch.randn(1, 1, embed_dim))
        self.pos_embed = nn.Parameter(torch.randn(1, self.num_patches + 1, embed_dim))
    
    def forward(self, x):
        B = x.shape[0]
        x = self.proj(x).flatten(2).transpose(1, 2)
        
        cls_tokens = self.cls_token.expand(B, -1, -1)
        x = torch.cat([cls_tokens, x], dim=1)
        x = x + self.pos_embed
        
        return x

class ViT(nn.Module):
    def __init__(self, img_size=224, patch_size=16, num_classes=1000,
                 embed_dim=768, depth=12, heads=12):
        super().__init__()
        self.patch_embed = PatchEmbedding(img_size, patch_size, 3, embed_dim)
        
        encoder_layer = nn.TransformerEncoderLayer(d_model=embed_dim, nhead=heads, dim_feedforward=embed_dim*4)
        self.transformer = nn.TransformerEncoder(encoder_layer, num_layers=depth)
        
        self.head = nn.Linear(embed_dim, num_classes)
    
    def forward(self, x):
        x = self.patch_embed(x)
        x = self.transformer(x)
        x = x[:, 0]  # CLS token
        return self.head(x)
```

---

## Summary

| Component | Purpose | Key Methods |
|-----------|---------|-------------|
| Image Processing | Enhancement | Filtering, thresholding |
| Feature Detection | Key points | Harris, SIFT, ORB |
| Edge Detection | Boundaries | Canny, Sobel |
| Contour Detection | Shape analysis | findContours |
| CNNs | Image understanding | ResNet, EfficientNet |
| ViT | Patch-based attention | ViT, DeiT |
| Object Detection | Locate objects | YOLO, R-CNN |
| Segmentation | Pixel classification | U-Net, Mask R-CNN |
