# Computer Vision Applications

## Table of Contents

1. [Image Classification](#image-classification)
2. [Object Detection](#object-detection)
3. [Image Segmentation](#image-segmentation)
4. [Face Recognition](#face-recognition)
5. [Medical Imaging](#medical-imaging)
6. [Autonomous Vehicles](#autonomous-vehicles)

---

## Image Classification

### ImageNet Models

```python
import torch
import torch.nn as nn
from torchvision import models, transforms

class ImageClassifier:
    def __init__(self, num_classes=1000, model_name='resnet50'):
        self.model = self._load_model(model_name, num_classes)
        self.transform = transforms.Compose([
            transforms.Resize(256),
            transforms.CenterCrop(224),
            transforms.ToTensor(),
            transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
        ])
    
    def _load_model(self, model_name, num_classes):
        if model_name == 'resnet50':
            model = models.resnet50(pretrained=True)
            model.fc = nn.Linear(model.fc.in_features, num_classes)
        elif model_name == 'efficientnet':
            model = models.efficientnet_b0(pretrained=True)
            model.classifier[1] = nn.Linear(model.classifier[1].in_features, num_classes)
        elif model_name == 'vit':
            model = models.vit_b_16(pretrained=True)
            model.heads = nn.Linear(model.heads.head.in_features, num_classes)
        return model
    
    def predict(self, image):
        tensor = self.transform(image).unsqueeze(0)
        with torch.no_grad():
            output = self.model(tensor)
            probabilities = torch.softmax(output, dim=1)
            predicted_class = torch.argmax(probabilities, dim=1)
        return predicted_class.item(), probabilities[0].tolist()

# Usage
classifier = ImageClassifier(num_classes=10)
# class_id, probs = classifier.predict(image)
```

### Fine-tuning for Custom Dataset

```python
from torch.utils.data import DataLoader, Dataset
from torchvision import transforms

class CustomDataset(Dataset):
    def __init__(self, image_paths, labels, transform=None):
        self.image_paths = image_paths
        self.labels = labels
        self.transform = transform
    
    def __len__(self):
        return len(self.image_paths)
    
    def __getitem__(self, idx):
        from PIL import Image
        image = Image.open(self.image_paths[idx]).convert('RGB')
        label = self.labels[idx]
        
        if self.transform:
            image = self.transform(image)
        
        return image, label

def train_custom_classifier(data_dir, num_classes, epochs=10):
    # Data transforms
    train_transform = transforms.Compose([
        transforms.RandomResizedCrop(224),
        transforms.RandomHorizontalFlip(),
        transforms.ToTensor(),
        transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
    ])
    
    # Load pre-trained model
    model = models.resnet50(pretrained=True)
    
    # Freeze early layers
    for param in list(model.parameters())[:-20]:
        param.requires_grad = False
    
    # Replace final layer
    model.fc = nn.Linear(model.fc.in_features, num_classes)
    
    # Training setup
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    model = model.to(device)
    criterion = nn.CrossEntropyLoss()
    optimizer = torch.optim.Adam(filter(lambda p: p.requires_grad, model.parameters()), lr=0.001)
    
    # Training loop
    for epoch in range(epochs):
        model.train()
        running_loss = 0.0
        correct = 0
        total = 0
        
        for images, labels in train_loader:
            images, labels = images.to(device), labels.to(device)
            
            optimizer.zero_grad()
            outputs = model(images)
            loss = criterion(outputs, labels)
            loss.backward()
            optimizer.step()
            
            running_loss += loss.item()
            _, predicted = outputs.max(1)
            total += labels.size(0)
            correct += predicted.eq(labels).sum().item()
        
        print(f"Epoch {epoch+1}/{epochs}, Loss: {running_loss/len(train_loader):.4f}, Acc: {100.*correct/total:.2f}%")
    
    return model
```

---

## Object Detection

### YOLOv5 Implementation

```python
import torch
from pathlib import Path

class YOLODetector:
    def __init__(self, model_path='yolov5s.pt'):
        self.model = torch.hub.load('ultralytics/yolov5', 'yolov5s', pretrained=True)
        self.model.conf = 0.25  # Confidence threshold
        self.model.iou = 0.45   # NMS IoU threshold
    
    def detect(self, image, classes=None):
        results = self.model(image)
        
        detections = []
        for *xyxy, conf, cls in results.xyxy[0]:
            detections.append({
                'bbox': [int(x) for x in xyxy],
                'confidence': float(conf),
                'class': int(cls),
                'name': results.names[int(cls)]
            })
        
        return detections
    
    def detect_batch(self, images):
        results = self.model(images)
        return results
    
    def visualize(self, image, detections, output_path=None):
        results = self.model(image)
        return results.render()[0]

# Usage
detector = YOLODetector()
# detections = detector.detect(image)
# for det in detections:
#     print(f"{det['name']}: {det['confidence']:.2f}")
```

### Custom Object Detection Training

```python
def train_yolo_custom(dataset_yaml, epochs=100):
    import subprocess
    
    # Using YOLOv5
    cmd = [
        'python', 'train.py',
        '--img', '640',
        '--batch', '16',
        '--epochs', str(epochs),
        '--data', dataset_yaml,
        '--weights', 'yolov5s.pt',
        '--name', 'custom_model'
    ]
    
    subprocess.run(cmd)

# Dataset YAML structure
"""
train: ./data/train/images
val: ./data/val/images

nc: 3  # number of classes
names: ['cat', 'dog', 'bird']  # class names
"""
```

---

## Image Segmentation

### Semantic Segmentation

```python
class SemanticSegmentation:
    def __init__(self, num_classes=21):
        self.model = self._create_model(num_classes)
        self.transform = transforms.Compose([
            transforms.ToTensor(),
            transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
        ])
    
    def _create_model(self, num_classes):
        # Use pre-trained DeepLabV3
        model = models.segmentation.deeplabv3_resnet50(pretrained=True)
        model.classifier[4] = nn.Conv2d(256, num_classes, 1)
        return model
    
    def predict(self, image):
        tensor = self.transform(image).unsqueeze(0)
        
        with torch.no_grad():
            output = self.model(tensor)['out']
            prediction = torch.argmax(output.squeeze(), dim=0)
        
        return prediction.numpy()
    
    def visualize(self, image, mask, alpha=0.5):
        # Create color map
        colors = np.random.randint(0, 255, (21, 3))
        
        # Apply mask
        colored_mask = colors[mask]
        overlay = (image * (1 - alpha) + colored_mask * alpha).astype(np.uint8)
        
        return overlay

# Usage
segmentor = SemanticSegmentation(num_classes=21)
# mask = segmentor.predict(image)
# overlay = segmentor.visualize(image, mask)
```

### Panoptic Segmentation

```python
class PanopticSegmentation:
    def __init__(self):
        self.model = models.segmentation.maskrcnn_resnet50_fpn(pretrained=True)
    
    def predict(self, image):
        tensor = transforms.ToTensor()(image).unsqueeze(0)
        
        with torch.no_grad():
            predictions = self.model(tensor)
        
        return {
            'boxes': predictions[0]['boxes'].numpy(),
            'labels': predictions[0]['labels'].numpy(),
            'scores': predictions[0]['scores'].numpy(),
            'masks': predictions[0]['masks'].numpy()
        }
    
    def visualize(self, image, predictions, threshold=0.5):
        vis_image = image.copy()
        
        for i, (box, label, score, mask) in enumerate(zip(
            predictions['boxes'],
            predictions['labels'],
            predictions['scores'],
            predictions['masks']
        )):
            if score > threshold:
                # Draw bounding box
                x1, y1, x2, y2 = box.astype(int)
                cv2.rectangle(vis_image, (x1, y1), (x2, y2), (0, 255, 0), 2)
                
                # Apply mask
                mask = mask[0] > 0.5
                vis_image[mask] = vis_image[mask] * 0.5 + np.array([255, 0, 0]) * 0.5
        
        return vis_image
```

---

## Face Recognition

### Face Detection

```python
import cv2

class FaceDetector:
    def __init__(self, method='mtcnn'):
        if method == 'haar':
            self.detector = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')
        elif method == 'dnn':
            self.detector = cv2.dnn.readNetFromCaffe(
                'deploy.prototxt',
                'res10_300x300_ssd_iter_140000.caffemodel'
            )
    
    def detect_haar(self, image):
        gray = cv2.cvtColor(image, cv2.COLOR_RGB2GRAY)
        faces = self.detector.detectMultiScale(gray, 1.3, 5)
        return faces
    
    def detect_dnn(self, image, confidence=0.5):
        blob = cv2.dnn.blobFromImage(image, 1.0, (300, 300), (104, 177, 123))
        self.detector.setInput(blob)
        detections = self.detector.forward()
        
        faces = []
        for i in range(detections.shape[2]):
            confidence = detections[0, 0, i, 2]
            if confidence > 0.5:
                box = detections[0, 0, i, 3:7] * np.array([image.shape[1], image.shape[0], image.shape[1], image.shape[0]])
                faces.append(box.astype(int))
        
        return faces
```

### Face Recognition

```python
class FaceRecognizer:
    def __init__(self):
        from facenet_pytorch import MTCNN, InceptionResnetV1
        self.mtcnn = MTCNN(keep_all=True)
        self.resnet = InceptionResnetV1(pretrained='vggface2').eval()
        self.known_faces = {}
    
    def register_face(self, name, image):
        face_tensor = self.mtcnn(image)
        if face_tensor is not None:
            embedding = self.resnet(face_tensor.unsqueeze(0))
            self.known_faces[name] = embedding.detach().numpy()
    
    def recognize(self, image, threshold=0.8):
        face_tensor = self.mtcnn(image)
        if face_tensor is None:
            return None
        
        embedding = self.resnet(face_tensor.unsqueeze(0))
        
        best_match = None
        best_score = -1
        
        for name, known_embedding in self.known_faces.items():
            score = torch.nn.functional.cosine_similarity(embedding, torch.tensor(known_embedding))
            if score > best_score and score > threshold:
                best_score = score
                best_match = name
        
        return best_match, best_score.item()

# Usage
recognizer = FaceRecognizer()
recognizer.register_face("John", john_image)
# name, confidence = recognizer.recognize(test_image)
```

### Face Alignment

```python
class FaceAligner:
    def __init__(self, desired_left_eye=(0.35, 0.35), desired_output_size=256):
        self.desired_left_eye = desired_left_eye
        self.desired_output_size = desired_output_size
    
    def align(self, image, landmarks):
        # Compute angle between eyes
        left_eye = landmarks['left_eye']
        right_eye = landmarks['right_eye']
        
        dY = right_eye[1] - left_eye[1]
        dX = right_eye[0] - left_eye[0]
        angle = np.degrees(np.arctan2(dY, dX))
        
        # Compute center between eyes
        center = ((left_eye[0] + right_eye[0]) // 2,
                  (left_eye[1] + right_eye[1]) // 2)
        
        # Get rotation matrix
        M = cv2.getRotationMatrix2D(center, angle, 1.0)
        
        # Perform rotation
        rotated = cv2.warpAffine(image, M, (image.shape[1], image.shape[0]),
                                 flags=cv2.INTER_CUBIC)
        
        return rotated
```

---

## Medical Imaging

### X-ray Analysis

```python
class ChestXrayAnalyzer:
    def __init__(self, num_classes=14):
        self.model = models.resnet50(pretrained=False)
        self.model.fc = nn.Linear(self.model.fc.in_features, num_classes)
        self.transform = transforms.Compose([
            transforms.Resize((224, 224)),
            transforms.ToTensor(),
            transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
        ])
        
        self.labels = ['Atelectasis', 'Cardiomegaly', 'Effusion', 'Infiltration',
                       'Mass', 'Nodule', 'Pneumonia', 'Pneumothorax',
                       'Consolidation', 'Edema', 'Emphysema', 'Fibrosis',
                       'Pleural', 'Hernia']
    
    def analyze(self, image):
        tensor = self.transform(image).unsqueeze(0)
        
        with torch.no_grad():
            output = self.model(tensor)
            probabilities = torch.sigmoid(output)
        
        results = {}
        for label, prob in zip(self.labels, probabilities[0]):
            results[label] = prob.item()
        
        return results
    
    def get_findings(self, results, threshold=0.5):
        findings = []
        for label, prob in results.items():
            if prob > threshold:
                findings.append({'condition': label, 'probability': prob})
        return sorted(findings, key=lambda x: x['probability'], reverse=True)

# Usage
analyzer = ChestXrayAnalyzer()
# results = analyzer.analyze(xray_image)
# findings = analyzer.get_findings(results)
```

### Segmentation for Medical Imaging

```python
class MedicalSegmentation:
    def __init__(self, in_channels=1, num_classes=2):
        self.model = UNet(in_channels, num_classes)
        self.transform = transforms.Compose([
            transforms.ToTensor(),
            transforms.Normalize([0.5], [0.5])
        ])
    
    def segment(self, image):
        tensor = self.transform(image).unsqueeze(0)
        
        with torch.no_grad():
            output = self.model(tensor)
            mask = torch.argmax(output.squeeze(), dim=0)
        
        return mask.numpy()
    
    def calculate_metrics(self, pred_mask, true_mask):
        # Dice coefficient
        intersection = np.sum(pred_mask & true_mask)
        dice = 2 * intersection / (np.sum(pred_mask) + np.sum(true_mask))
        
        # IoU
        union = np.sum(pred_mask | true_mask)
        iou = intersection / union
        
        # Accuracy
        accuracy = np.mean(pred_mask == true_mask)
        
        return {'dice': dice, 'iou': iou, 'accuracy': accuracy}
```

---

## Autonomous Vehicles

### Lane Detection

```python
class LaneDetector:
    def __init__(self):
        self.model = self._create_model()
    
    def _create_model(self):
        model = nn.Sequential(
            nn.Conv2d(3, 32, 3, padding=1),
            nn.ReLU(),
            nn.MaxPool2d(2, 2),
            nn.Conv2d(32, 64, 3, padding=1),
            nn.ReLU(),
            nn.MaxPool2d(2, 2),
            nn.Conv2d(64, 128, 3, padding=1),
            nn.ReLU(),
            nn.Upsample(scale_factor=4),
            nn.Conv2d(128, 1, 1),
            nn.Sigmoid()
        )
        return model
    
    def detect(self, image):
        tensor = transforms.ToTensor()(image).unsqueeze(0)
        
        with torch.no_grad():
            mask = self.model(tensor)
        
        return mask.squeeze().numpy()
    
    def fit_lines(self, mask):
        # Hough transform on mask
        mask_uint8 = (mask * 255).astype(np.uint8)
        lines = cv2.HoughLinesP(mask_uint8, 1, np.pi/180, 50, minLineLength=50, maxLineGap=10)
        return lines
```

### Depth Estimation

```python
class DepthEstimator:
    def __init__(self):
        self.model = models.dpt_large(pretrained=True)
        self.transform = transforms.Compose([
            transforms.Resize((384, 384)),
            transforms.ToTensor(),
            transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
        ])
    
    def estimate(self, image):
        tensor = self.transform(image).unsqueeze(0)
        
        with torch.no_grad():
            depth = self.model(tensor)
        
        depth = depth.squeeze().numpy()
        depth = cv2.resize(depth, (image.shape[1], image.shape[0]))
        
        return depth
    
    def visualize_depth(self, depth):
        depth_normalized = (depth - depth.min()) / (depth.max() - depth.min())
        depth_colored = cv2.applyColorMap((depth_normalized * 255).astype(np.uint8), cv2.COLORMAP_PLASMA)
        return depth_colored
```

---

## Summary

| Application | Key Models | Use Cases |
|-------------|------------|-----------|
| Image Classification | ResNet, EfficientNet, ViT | Scene recognition, product categorization |
| Object Detection | YOLO, R-CNN, SSD | Surveillance, retail, autonomous driving |
| Image Segmentation | U-Net, Mask R-CNN | Medical imaging, satellite imagery |
| Face Recognition | FaceNet, ArcFace | Security, authentication |
| Medical Imaging | 3D U-Net, nnU-Net | Diagnosis, treatment planning |
| Autonomous Vehicles | Various | Lane detection, depth estimation |
