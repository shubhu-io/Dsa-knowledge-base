# Transformers in NLP

This document covers transformer architectures and their applications in natural language processing.

## Introduction to Transformers

### What are Transformers?
Transformers are deep learning models that use self-attention mechanisms to process sequential data. They have revolutionized NLP by enabling parallel processing and capturing long-range dependencies.

### Key Innovations
- **Self-Attention**: Mechanism to weigh importance of different parts of input
- **Parallel Processing**: Unlike RNNs, processes all positions simultaneously
- **Positional Encoding**: Captures sequence order information
- **Transfer Learning**: Pre-trained models fine-tuned for specific tasks

## Architecture Overview

### Encoder-Decoder Structure
```
Input → Encoder → Context → Decoder → Output

Encoder:
- Self-attention layers
- Feed-forward neural networks
- Layer normalization

Decoder:
- Masked self-attention
- Encoder-decoder attention
- Feed-forward neural networks
```

### Self-Attention Mechanism
```python
import torch
import torch.nn as nn
import math

def scaled_dot_product_attention(Q, K, V, mask=None):
    """
    Q: Query matrix (batch_size, seq_len, d_k)
    K: Key matrix (batch_size, seq_len, d_k)
    V: Value matrix (batch_size, seq_len, d_v)
    """
    d_k = Q.size(-1)
    
    # Calculate attention scores
    scores = torch.matmul(Q, K.transpose(-2, -1)) / math.sqrt(d_k)
    
    # Apply mask if provided
    if mask is not None:
        scores = scores.masked_fill(mask == 0, -1e9)
    
    # Apply softmax
    attention_weights = torch.softmax(scores, dim=-1)
    
    # Calculate output
    output = torch.matmul(attention_weights, V)
    
    return output, attention_weights
```

## Pre-trained Models

### BERT (Bidirectional Encoder Representations from Transformers)
```python
from transformers import BertTokenizer, BertModel
import torch

# Load pre-trained model and tokenizer
tokenizer = BertTokenizer.from_pretrained('bert-base-uncased')
model = BertModel.from_pretrained('bert-base-uncased')

# Tokenize input
text = "Hello, how are you?"
encoded_input = tokenizer(text, return_tensors='pt')

# Get model output
with torch.no_grad():
    output = model(**encoded_input)

# Extract embeddings
last_hidden_state = output.last_hidden_state
```

### GPT (Generative Pre-trained Transformer)
```python
from transformers import GPT2LMHeadModel, GPT2Tokenizer

# Load model and tokenizer
tokenizer = GPT2Tokenizer.from_pretrained('gpt2')
model = GPT2LMHeadModel.from_pretrained('gpt2')

# Generate text
input_text = "Once upon a time"
input_ids = tokenizer.encode(input_text, return_tensors='pt')

# Generate
output = model.generate(
    input_ids,
    max_length=100,
    num_return_sequences=1,
    no_repeat_ngram_size=2,
    temperature=0.7
)

generated_text = tokenizer.decode(output[0], skip_special_tokens=True)
```

### T5 (Text-to-Text Transfer Transformer)
```python
from transformers import T5Tokenizer, T5ForConditionalGeneration

# Load model and tokenizer
tokenizer = T5Tokenizer.from_pretrained('t5-small')
model = T5ForConditionalGeneration.from_pretrained('t5-small')

# Translation task
input_text = "translate English to French: Hello, how are you?"
input_ids = tokenizer.encode(input_text, return_tensors='pt')

output = model.generate(input_ids, max_length=50)
translated = tokenizer.decode(output[0], skip_special_tokens=True)
```

## Fine-tuning Transformers

### Hugging Face Transformers Library
```python
from transformers import (
    AutoTokenizer, 
    AutoModelForSequenceClassification,
    TrainingArguments, 
    Trainer
)
from datasets import load_dataset

# Load dataset
dataset = load_dataset("imdb")

# Load tokenizer and model
tokenizer = AutoTokenizer.from_pretrained("bert-base-uncased")
model = AutoModelForSequenceClassification.from_pretrained(
    "bert-base-uncased", 
    num_labels=2
)

# Tokenize dataset
def tokenize_function(examples):
    return tokenizer(examples["text"], padding="max_length", truncation=True)

tokenized_datasets = dataset.map(tokenize_function, batched=True)

# Training arguments
training_args = TrainingArguments(
    output_dir="./results",
    learning_rate=2e-5,
    per_device_train_batch_size=16,
    num_train_epochs=3,
)

# Create trainer
trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=tokenized_datasets["train"],
    eval_dataset=tokenized_datasets["test"],
)

# Fine-tune
trainer.train()
```

## Attention Visualization

### Visualizing Attention Weights
```python
import matplotlib.pyplot as plt
import seaborn as sns

def visualize_attention(attention_weights, tokens):
    """Visualize attention weights as a heatmap"""
    fig, ax = plt.subplots(figsize=(10, 10))
    sns.heatmap(
        attention_weights, 
        xticklabels=tokens, 
        yticklabels=tokens,
        annot=True, 
        fmt='.2f',
        cmap='viridis'
    )
    plt.xlabel('Keys')
    plt.ylabel('Queries')
    plt.title('Attention Weights')
    plt.show()
```

## Common NLP Tasks with Transformers

### Text Classification
```python
from transformers import pipeline

# Sentiment analysis
classifier = pipeline("sentiment-analysis")
result = classifier("I love this product!")
print(result)  # [{'label': 'POSITIVE', 'score': 0.9998}]
```

### Named Entity Recognition (NER)
```python
from transformers import pipeline

ner = pipeline("ner", grouped_entities=True)
result = ner("My name is John and I work at Google.")
print(result)
# [{'entity_group': 'PER', 'word': 'John', ...}, 
#  {'entity_group': 'ORG', 'word': 'Google', ...}]
```

### Question Answering
```python
from transformers import pipeline

qa = pipeline("question-answering")
result = qa(
    question="What is the capital of France?",
    context="France is a country in Europe. Its capital is Paris."
)
print(result)  # {'answer': 'Paris', 'score': 0.9998, ...}
```

### Text Generation
```python
from transformers import pipeline

generator = pipeline("text-generation", model="gpt2")
result = generator(
    "The future of AI is",
    max_length=50,
    num_return_sequences=1
)
print(result[0]['generated_text'])
```

## Advanced Topics

### Multi-Head Attention
```python
class MultiHeadAttention(nn.Module):
    def __init__(self, d_model, num_heads):
        super().__init__()
        self.num_heads = num_heads
        self.d_model = d_model
        self.d_k = d_model // num_heads
        
        self.W_q = nn.Linear(d_model, d_model)
        self.W_k = nn.Linear(d_model, d_model)
        self.W_v = nn.Linear(d_model, d_model)
        self.W_o = nn.Linear(d_model, d_model)
    
    def forward(self, Q, K, V, mask=None):
        batch_size = Q.size(0)
        
        # Linear projections and reshape
        Q = self.W_q(Q).view(batch_size, -1, self.num_heads, self.d_k).transpose(1, 2)
        K = self.W_k(K).view(batch_size, -1, self.num_heads, self.d_k).transpose(1, 2)
        V = self.W_v(V).view(batch_size, -1, self.num_heads, self.d_k).transpose(1, 2)
        
        # Apply attention
        output, _ = scaled_dot_product_attention(Q, K, V, mask)
        
        # Concatenate heads
        output = output.transpose(1, 2).contiguous().view(batch_size, -1, self.d_model)
        
        # Final linear projection
        output = self.W_o(output)
        
        return output
```

### Positional Encoding
```python
class PositionalEncoding(nn.Module):
    def __init__(self, d_model, max_len=5000):
        super().__init__()
        pe = torch.zeros(max_len, d_model)
        position = torch.arange(0, max_len, dtype=torch.float).unsqueeze(1)
        div_term = torch.exp(torch.arange(0, d_model, 2).float() * (-math.log(10000.0) / d_model))
        
        pe[:, 0::2] = torch.sin(position * div_term)
        pe[:, 1::2] = torch.cos(position * div_term)
        pe = pe.unsqueeze(0).transpose(0, 1)
        
        self.register_buffer('pe', pe)
    
    def forward(self, x):
        return x + self.pe[:x.size(0), :]
```

## Model Optimization

### Quantization
```python
from transformers import AutoModelForSequenceClassification
import torch.quantization

# Load model
model = AutoModelForSequenceClassification.from_pretrained("bert-base-uncased")

# Quantize
quantized_model = torch.quantization.quantize_dynamic(
    model,
    {torch.nn.Linear},
    dtype=torch.qint8
)
```

### Knowledge Distillation
```python
class DistillationLoss(nn.Module):
    def __init__(self, temperature=4.0, alpha=0.5):
        super().__init__()
        self.temperature = temperature
        self.alpha = alpha
        self.kl_div = nn.KLDivLoss(reduction='batchmean')
    
    def forward(self, student_logits, teacher_logits, labels):
        # Soft targets
        soft_loss = self.kl_div(
            F.log_softmax(student_logits / self.temperature, dim=-1),
            F.softmax(teacher_logits / self.temperature, dim=-1)
        ) * (self.temperature ** 2)
        
        # Hard targets
        hard_loss = F.cross_entropy(student_logits, labels)
        
        return self.alpha * soft_loss + (1 - self.alpha) * hard_loss
```

## Best Practices

### Model Selection
1. **Task-specific**: Choose model designed for your task
2. **Size vs Performance**: Larger models aren't always better
3. **Domain**: Use domain-specific pre-training when available
4. **Resources**: Consider computational constraints

### Training Tips
1. **Learning rate scheduling**: Use warmup and decay
2. **Batch size**: Larger batches for stability
3. **Gradient accumulation**: For large models
4. **Mixed precision**: For faster training

### Deployment
1. **Model optimization**: Quantization, pruning
2. **Batching**: Process multiple inputs together
3. **Caching**: Store frequent computations
4. **Monitoring**: Track model performance

## Resources

### Official Resources
- **Hugging Face**: https://huggingface.co/
- **Transformer Papers**: Attention Is All You Need, BERT, GPT
- **Documentation**: transformers library docs

### Learning Materials
- **The Illustrated Transformer**: Visual explanation
- **Lilian Weng's Blog**: Transformer tutorials
- **Stanford CS224N**: NLP with Deep Learning

## See Also

- [[nlp-guide]]
- [[nlp-techniques]]
- [[nlp-applications]]
- [[nlp-interview-questions]]
