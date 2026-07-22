# Computer Vision Techniques

## Table of Contents

1. [Image Preprocessing](#image-preprocessing)
2. [Feature Extraction](#feature-extraction)
3. [Object Detection](#object-detection)
4. [Image Segmentation](#image-segmentation)
5. [Image Generation](#image-generation)
6. [Video Analysis](#video-analysis)

---

## Image Preprocessing

### Data Augmentation

```python
import torchvision.transforms as T
import albumentations as A
from albumentations.pytorch import ToTensorV2
import cv2

class ImageAugmentation:
    def __init__(self):
        self.torchvision_transform = T.Compose([
            T.RandomResizedCrop(224, scale=(0.8, 1.0)),
            T.RandomHorizontalFlip(p=0.5),
            T.RandomVerticalFlip(p=0.1),
            T.RandomRotation(15),
            T.ColorJitter(brightness=0.2, contrast=0.2, saturation=0.2, hue=0.1),
            T.RandomAffine(degrees=0, translate=(0.1, 0.1), scale=(0.9, 1.1)),
            T.ToTensor(),
            T.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
            T.RandomErasing(p=0.2)
        ])
        
        # Albumentations (more flexible)
        self.albumentations_transform = A.Compose([
            A.RandomResizedCrop(224, 224, scale=(0.8, 1.0)),
            A.HorizontalFlip(p=0.5),
            A.ShiftScaleRotate(shift_limit=0.1, scale_limit=0.1, rotate_limit=15, p=0.5),
            A.ColorJitter(brightness=0.2, contrast=0.2, saturation=0.2, hue=0.1, p=0.5),
            A.GaussNoise(var_limit=(10.0, 50.0), p=0.3),
            A.Blur(blur_limit=3, p=0.3),
            A.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
            ToTensorV2()
        ])
    
    def apply_torchvision(self, image):
        return self.torchvision_transform(image)
    
    def apply_albumentations(self, image):
        return self.albumentations_transform(image=image)['image']

# CutMix and Mixup
def cutmix(image1, image2, label1, label2, alpha=1.0):
    lam = np.random.beta(alpha, alpha)
    bbx1, bby1, bbx2, bby2 = rand_bbox(image1.shape, lam)
    
    image1[:, bbx1:bbx2, bby1:bby2] = image2[:, bbx1:bbx2, bby1:bby2]
    lam = 1 - ((bbx2 - bbx1) * (bby2 - bby1) / (image1.shape[-1] * image1.shape[-2]))
    
    return image1, label1, label2, lam

def mixup(image1, image2, label1, label2, alpha=0.2):
    lam = np.random.beta(alpha, alpha)
    mixed_image = lam * image1 + (1 - lam) * image2
    return mixed_image, label1, label2, lam
```

### Normalization

```python
class ImageNormalization:
    def __init__(self, method='imagenet'):
        self.stats = {
            'imagenet': {'mean': [0.485, 0.456, 0.406], 'std': [0.229, 0.224, 0.225]},
            'cifar10': {'mean': [0.4914, 0.4822, 0.4465], 'std': [0.2470, 0.2435, 0.2616]},
            'medical': {'mean': [0.5], 'std': [0.5]}
        }
        self.mean = np.array(self.stats[method]['mean'])
        self.std = np.array(self.stats[method]['std'])
    
    def normalize(self, image):
        return (image - self.mean) / self.std
    
    def denormalize(self, image):
        return image * self.std + self.mean
    
    def min_max_normalize(self, image):
        return (image - image.min()) / (image.max() - image.min())
```

---

## Feature Extraction

### HOG Features

```python
import cv2
import numpy as np

class HOGFeatures:
    def __init__(self):
        self.hog = cv2.HOGDescriptor()
    
    def compute(self, image):
        gray = cv2.cvtColor(image, cv2.COLOR_RGB2GRAY) if len(image.shape) == 3 else image
        gray = cv2.resize(gray, (128, 128))
        return self.hog.compute(gray)
    
    def visualize(self, image):
        gray = cv2.cvtColor(image, cv2.COLOR_RGB2GRAY) if len(image.shape) == 3 else image
        gray = cv2.resize(gray, (128, 128))
        
        hog = cv2.HOGDescriptor()
        hog_features, hog_image = hog.compute(gray, winStride=(8,8), padding=(3,3), visualGradient=True)
        
        return hog_features, hog_image
```

### LBP Features

```python
class LBPFeatures:
    def __init__(self):
        pass
    
    def compute_lbp(self, image):
        gray = cv2.cvtColor(image, cv2.COLOR_RGB2GRAY) if len(image.shape) == 3 else image
        rows, cols = gray.shape
        
        lbp = np.zeros_like(gray)
        for i in range(1, rows-1):
            for j in range(1, cols-1):
                center = gray[i, j]
                code = 0
                code |= (gray[i-1, j-1] >= center) << 7
                code |= (gray[i-1, j] >= center) << 6
                code |= (gray[i-1, j+1] >= center) << 5
                code |= (gray[i, j+1] >= center) << 4
                code |= (gray[i+1, j+1] >= center) << 3
                code |= (gray[i+1, j] >= center) << 2
                code |= (gray[i+1, j-1] >= center) << 1
                code |= (gray[i, j-1] >= center) << 0
                lbp[i, j] = code
        
        return lbp
    
    def lbp_histogram(self, lbp, num_regions=8):
        h, w = lbp.shape
        region_h, region_w = h // num_regions, w // num_regions
        hist = []
        
        for i in range(num_regions):
            for j in range(num_regions):
                region = lbp[i*region_h:(i+1)*region_h, j*region_w:(j+1)*region_w]
                hist.extend(np.histogram(region, bins=256, range=(0, 256))[0])
        
        return np.array(hist) / np.sum(hist)
```

### SIFT Features

```python
class SIFTFeatures:
    def __init__(self):
        self.sift = cv2.SIFT_create()
    
    def detect_and_compute(self, image):
        gray = cv2.cvtColor(image, cv2.COLOR_RGB2GRAY) if len(image.shape) == 3 else image
        keypoints, descriptors = self.sift.detectAndCompute(gray, None)
        return keypoints, descriptors
    
    def visualize_keypoints(self, image, keypoints):
        return cv2.drawKeypoints(image, keypoints, None, flags=cv2.DRAW_MATCHES_FLAGS_DRAW_RICH_KEYPOINTS)
```

---

## Object Detection

### YOLO Implementation

```python
import torch
import torch.nn as nn

class YOLOBlock(nn.Module):
    def __init__(self, in_channels, out_channels):
        super().__init__()
        self.conv = nn.Sequential(
            nn.Conv2d(in_channels, out_channels, 1),
            nn.BatchNorm2d(out_channels),
            nn.LeakyReLU(0.1),
            nn.Conv2d(out_channels, out_channels * 2, 3, padding=1),
            nn.BatchNorm2d(out_channels * 2),
            nn.LeakyReLU(0.1)
        )
    
    def forward(self, x):
        return self.conv(x)

class YOLOv3(nn.Module):
    def __init__(self, num_classes=80):
        super().__init__()
        self.num_classes = num_classes
        
        # Backbone
        self.backbone = nn.Sequential(
            YOLOBlock(3, 32),
            nn.MaxPool2d(2, 2),
            YOLOBlock(32, 64),
            nn.MaxPool2d(2, 2),
            YOLOBlock(64, 128),
            nn.MaxPool2d(2, 2),
            YOLOBlock(128, 256),
            nn.MaxPool2d(2, 2),
            YOLOBlock(256, 512)
        )
        
        # Detection heads
        self.detect_small = nn.Conv2d(512, (5 + num_classes) * 3, 1)
        self.detect_medium = nn.Conv2d(256, (5 + num_classes) * 3, 1)
        self.detect_large = nn.Conv2d(128, (5 + num_classes) * 3, 1)
    
    def forward(self, x):
        features = self.backbone(x)
        
        # Multi-scale detection
        small = self.detect_small(features)
        # ... (simplified)
        
        return small
```

### Faster R-CNN

```python
class RegionProposalNetwork(nn.Module):
    def __init__(self, in_channels, num_anchors=9):
        super().__init__()
        self.conv = nn.Conv2d(in_channels, 256, 3, padding=1)
        self.cls_score = nn.Conv2d(256, num_anchors * 2, 1)
        self.bbox_pred = nn.Conv2d(256, num_anchors * 4, 1)
    
    def forward(self, x):
        x = torch.relu(self.conv(x))
        
        # Classification (object/not object)
        cls = self.cls_score(x)
        
        # Bounding box regression
        bbox = self.bbox_pred(x)
        
        return cls, bbox

class ROI pooling
class ROIPooling(nn.Module):
    def __init__(self, output_size):
        super().__init__()
        self.output_size = output_size
    
    def forward(self, features, rois):
        # Simplified ROI pooling
        pooled = []
        for roi in rois:
            x1, y1, x2, y2 = roi.int()
            roi_feature = features[:, :, y1:y2, x1:x2]
            roi_pooled = nn.functional.adaptive_max_pool2d(roi_feature, self.output_size)
            pooled.append(roi_pooled)
        return torch.cat(pooled, dim=0)
```

### SSD (Single Shot Detector)

```python
class SSD(nn.Module):
    def __init__(self, num_classes=21):
        super().__init__()
        self.num_classes = num_classes
        
        # Base network (VGG16 modified)
        self.base = self._create_vgg_base()
        
        # Extra layers
        self.extra_layers = nn.ModuleList([
            nn.Conv2d(1024, 256, 1),
            nn.Conv2d(256, 512, 3, stride=2, padding=1),
            nn.Conv2d(512, 128, 1),
            nn.Conv2d(128, 256, 3, stride=2, padding=1)
        ])
        
        # Detection heads
        self.detection_heads = nn.ModuleList([
            nn.Conv2d(512, num_classes * 4, 3, padding=1),
            nn.Conv2d(1024, num_classes * 4, 3, padding=1),
            nn.Conv2d(512, num_classes * 4, 3, padding=1),
            nn.Conv2d(256, num_classes * 4, 3, padding=1)
        ])
    
    def _create_vgg_base(self):
        return nn.Sequential(
            nn.Conv2d(3, 64, 3, padding=1),
            nn.ReLU(),
            nn.Conv2d(64, 64, 3, padding=1),
            nn.ReLU(),
            nn.MaxPool2d(2, 2),
            # ... VGG layers
        )
    
    def forward(self, x):
        features = []
        x = self.base(x)
        features.append(x)
        
        for extra in self.extra_layers:
            x = extra(x)
            features.append(x)
        
        detections = []
        for feature, head in zip(features, self.detection_heads):
            detection = head(feature)
            detections.append(detection)
        
        return detections
```

---

## Image Segmentation

### Semantic Segmentation

```python
class UNet(nn.Module):
    def __init__(self, in_channels=1, out_channels=1):
        super().__init__()
        
        # Encoder
        self.enc1 = self._block(in_channels, 64)
        self.enc2 = self._block(64, 128)
        self.enc3 = self._block(128, 256)
        self.enc4 = self._block(256, 512)
        
        self.pool = nn.MaxPool2d(2, 2)
        
        # Bottleneck
        self.bottleneck = self._block(512, 1024)
        
        # Decoder
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

### Instance Segmentation

```python
class MaskRCNN(nn.Module):
    def __init__(self, num_classes):
        super().__init__()
        
        # Backbone
        self.backbone = self._create_resnet_backbone()
        
        # Region Proposal Network
        self.rpn = RegionProposalNetwork(256)
        
        # ROI Head
        self.roi_head = ROIHead(num_classes)
    
    def _create_resnet_backbone(self):
        from torchvision import models
        resnet = models.resnet50(pretrained=True)
        return nn.Sequential(*list(resnet.children())[:-2])
    
    def forward(self, images, targets=None):
        features = self.backbone(images)
        
        # RPN
        rpn_logits, rpn_bbox = self.rpn(features)
        
        # Proposals
        proposals = self.rpn.generate_proposals(rpn_logits, rpn_bbox)
        
        # ROI Head
        if self.training:
            return self.roi_head(features, proposals, targets)
        else:
            return self.roi_head(features, proposals)
```

---

## Image Generation

### GAN

```python
class Generator(nn.Module):
    def __init__(self, latent_dim=100, img_channels=3):
        super().__init__()
        self.main = nn.Sequential(
            nn.ConvTranspose2d(latent_dim, 512, 4, 1, 0, bias=False),
            nn.BatchNorm2d(512),
            nn.ReLU(True),
            nn.ConvTranspose2d(512, 256, 4, 2, 1, bias=False),
            nn.BatchNorm2d(256),
            nn.ReLU(True),
            nn.ConvTranspose2d(256, 128, 4, 2, 1, bias=False),
            nn.BatchNorm2d(128),
            nn.ReLU(True),
            nn.ConvTranspose2d(128, img_channels, 4, 2, 1, bias=False),
            nn.Tanh()
        )
    
    def forward(self, z):
        return self.main(z.view(z.size(0), -1, 1, 1))

class Discriminator(nn.Module):
    def __init__(self, img_channels=3):
        super().__init__()
        self.main = nn.Sequential(
            nn.Conv2d(img_channels, 128, 4, 2, 1, bias=False),
            nn.LeakyReLU(0.2, inplace=True),
            nn.Conv2d(128, 256, 4, 2, 1, bias=False),
            nn.BatchNorm2d(256),
            nn.LeakyReLU(0.2, inplace=True),
            nn.Conv2d(256, 512, 4, 2, 1, bias=False),
            nn.BatchNorm2d(512),
            nn.LeakyReLU(0.2, inplace=True),
            nn.Conv2d(512, 1, 4, 1, 0, bias=False),
            nn.Sigmoid()
        )
    
    def forward(self, x):
        return self.main(x).view(-1, 1)
```

### Diffusion Models

```python
class DiffusionModel(nn.Module):
    def __init__(self, img_size=64, timesteps=1000):
        super().__init__()
        self.timesteps = timesteps
        
        # Simple forward diffusion
        self.betas = torch.linspace(1e-4, 0.02, timesteps)
        self.alphas = 1.0 - self.betas
        self.alpha_cumprod = torch.cumprod(self.alphas, dim=0)
    
    def q_sample(self, x_start, t, noise=None):
        if noise is None:
            noise = torch.randn_like(x_start)
        
        sqrt_alpha_cumprod = torch.sqrt(self.alpha_cumprod[t])
        sqrt_one_minus_alpha_cumprod = torch.sqrt(1 - self.alpha_cumprod[t])
        
        return sqrt_alpha_cumprod * x_start + sqrt_one_minus_alpha_cumprod * noise
    
    def p_sample(self, x, t, t_index):
        # Simplified reverse process
        betas_t = self.betas[t]
        sqrt_one_minus_alphas_cumprod_t = torch.sqrt(1 - self.alpha_cumprod[t])
        sqrt_recip_alphas_t = torch.sqrt(1.0 / self.alphas[t])
        
        model_mean = sqrt_recip_alphas_t * (x - betas_t * self.model(x, t) / sqrt_one_minus_alphas_cumprod_t)
        
        if t_index == 0:
            return model_mean
        else:
            noise = torch.randn_like(x)
            return model_mean + torch.sqrt(betas_t) * noise
```

---

## Video Analysis

### Optical Flow

```python
class OpticalFlow:
    def __init__(self):
        self.lk_params = dict(winSize=(15, 15), maxLevel=2,
                             criteria=(cv2.TERM_CRITERIA_EPS | cv2.TERM_CRITERIA_COUNT, 10, 0.03))
    
    def lucas_kanade(self, prev_frame, curr_frame, prev_points):
        prev_gray = cv2.cvtColor(prev_frame, cv2.COLOR_RGB2GRAY)
        curr_gray = cv2.cvtColor(curr_frame, cv2.COLOR_RGB2GRAY)
        
        next_points, status, error = cv2.calcOpticalFlowPyrLK(
            prev_gray, curr_gray, prev_points, None, **self.lk_params
        )
        
        return next_points, status
    
    def dense_optical_flow(self, prev_frame, curr_frame):
        prev_gray = cv2.cvtColor(prev_frame, cv2.COLOR_RGB2GRAY)
        curr_gray = cv2.cvtColor(curr_frame, cv2.COLOR_RGB2GRAY)
        
        flow = cv2.calcOpticalFlowFarneback(prev_gray, curr_gray, None, 0.5, 3, 15, 3, 5, 1.2, 0)
        
        return flow
```

### Video Feature Extraction

```python
class VideoFeatureExtractor:
    def __init__(self):
        self.frame_interval = 10  # Extract every 10th frame
    
    def extract_frames(self, video_path):
        cap = cv2.VideoCapture(video_path)
        frames = []
        
        frame_count = 0
        while cap.isOpened():
            ret, frame = cap.read()
            if not ret:
                break
            
            if frame_count % self.frame_interval == 0:
                frames.append(frame)
            
            frame_count += 1
        
        cap.release()
        return frames
    
    def extract_features(self, frames, model):
        features = []
        transform = T.Compose([
            T.ToPILImage(),
            T.Resize((224, 224)),
            T.ToTensor(),
            T.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
        ])
        
        with torch.no_grad():
            for frame in frames:
                frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
                tensor = transform(frame_rgb).unsqueeze(0)
                feature = model(tensor)
                features.append(feature.squeeze().numpy())
        
        return np.array(features)
```

---

## Summary

| Technique | Purpose | Key Methods |
|-----------|---------|-------------|
| Preprocessing | Data preparation | Augmentation, normalization |
| Feature Extraction | Image description | HOG, SIFT, LBP |
| Object Detection | Locate objects | YOLO, R-CNN, SSD |
| Segmentation | Pixel classification | U-Net, Mask R-CNN |
| Generation | Create images | GAN, Diffusion |
| Video Analysis | Motion understanding | Optical flow, tracking |
