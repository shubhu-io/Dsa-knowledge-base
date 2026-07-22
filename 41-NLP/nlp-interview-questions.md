# NLP Interview Questions

## Table of Contents

1. [Text Processing](#text-processing)
2. [Embeddings](#embeddings)
3. [Transformers](#transformers)
4. [Language Models](#language-models)
5. [Applications](#applications)
6. [Advanced Topics](#advanced-topics)

---

## Text Processing

### 1. What is the difference between stemming and lemmatization?

**Answer:**

| Aspect | Stemming | Lemmatization |
|--------|----------|---------------|
| **Method** | Rule-based truncation | Dictionary-based |
| **Result** | May not be valid word | Always valid word |
| **Speed** | Faster | Slower |
| **Example** | "running" → "run" | "better" → "good" |

```python
from nltk.stem import PorterStemmer, WordNetLemmatizer

stemmer = PorterStemmer()
lemmatizer = WordNetLemmatizer()

# Stemming examples
print(stemmer.stem("running"))   # run
print(stemmer.stem("better"))    # better (unchanged)

# Lemmatization examples
print(lemmatizer.lemmatize("running", pos='v'))  # run
print(lemmatizer.lemmatize("better", pos='a'))   # good
```

### 2. Explain TF-IDF and when to use it

**Answer:**
TF-IDF (Term Frequency-Inverse Document Frequency) weights words by importance.

```
TF(t,d) = (count of t in d) / (total terms in d)
IDF(t) = log(N / df(t))
TF-IDF = TF × IDF
```

```python
from sklearn.feature_extraction.text import TfidfVectorizer

# When to use:
# - Document classification
# - Information retrieval
# - Feature extraction for ML models
# - Keyword extraction

# When NOT to use:
# - When word order matters
# - When semantic similarity is needed
# - For very short texts

vectorizer = TfidfVectorizer(max_features=10000, ngram_range=(1, 2))
tfidf_matrix = vectorizer.fit_transform(documents)
```

### 3. How do you handle out-of-vocabulary (OOV) words?

**Answer:**

```python
# 1. Subword tokenization (BPE, WordPiece)
from transformers import BertTokenizer
tokenizer = BertTokenizer.from_pretrained('bert-base-uncased')
# Handles OOV by breaking into subwords

# 2. Character-level embeddings
class CharEmbedding(nn.Module):
    def __init__(self, vocab_size, embed_dim):
        super().__init__()
        self.char_embedding = nn.Embedding(vocab_size, embed_dim)
    
    def forward(self, x):
        return self.char_embedding(x)

# 3. Hash-based embeddings
from sklearn.feature_extraction import FeatureHasher
hasher = FeatureHasher(n_features=2**16)

# 4. FastText (subword information)
from gensim.models import FastText
# Can generate vectors for unseen words using character n-grams
```

---

## Embeddings

### 1. Compare Word2Vec, GloVe, and FastText

**Answer:**

| Aspect | Word2Vec | GloVe | FastText |
|--------|----------|-------|----------|
| **Training** | Predict context | Matrix factorization | Predict context + subwords |
| **OOV Handling** | No | No | Yes (subword) |
| **Semantic** | Good | Good | Better for rare words |
| **Speed** | Fast | Fast | Slower |

```python
# Word2Vec - Local context
from gensim.models import Word2Vec
model = Word2Vec(sentences, vector_size=100, window=5)

# GloVe - Global statistics
# Pre-trained, load from file
import numpy as np
def load_glove(path):
    embeddings = {}
    with open(path) as f:
        for line in f:
            word, vec = line.split(maxsplit=1)
            embeddings[word] = np.fromstring(vec, sep=' ')
    return embeddings

# FastText - Subword information
from gensim.models import FastText
model = FastText(sentences, vector_size=100, min_n=3, max_n=6)
```

### 2. How do you create document embeddings?

**Answer:**

```python
import numpy as np
from sentence_transformers import SentenceTransformer

# Method 1: Average word embeddings
def doc_embedding_avg(text, word_embeddings):
    words = text.split()
    word_vecs = [word_embeddings[w] for w in words if w in word_embeddings]
    return np.mean(word_vecs, axis=0) if word_vecs else np.zeros(100)

# Method 2: TF-IDF weighted average
def doc_embedding_tfidf(text, tfidf_vectorizer, word_embeddings):
    tfidf = tfidf_vectorizer.transform([text]).toarray()[0]
    words = text.split()
    vec = np.zeros(100)
    for i, word in enumerate(words):
        if word in word_embeddings:
            vec += tfidf[i] * word_embeddings[word]
    return vec

# Method 3: Sentence Transformers (recommended)
model = SentenceTransformer('all-MiniLM-L6-v2')
doc_embedding = model.encode("This is a document.")

# Method 4: Doc2Vec
from gensim.models.doc2vec import Doc2Vec, TaggedDocument
documents = [TaggedDocument(doc.split(), [i]) for i, doc in enumerate(texts)]
model = Doc2Vec(documents, vector_size=100, window=5, min_count=1)
```

---

## Transformers

### 1. Explain the attention mechanism

**Answer:**

```python
import torch
import torch.nn as nn
import math

class SelfAttention(nn.Module):
    def __init__(self, embed_size, heads):
        super().__init__()
        self.heads = heads
        self.head_dim = embed_size // heads
        
        self.queries = nn.Linear(embed_size, embed_size)
        self.keys = nn.Linear(embed_size, embed_size)
        self.values = nn.Linear(embed_size, embed_size)
        self.fc_out = nn.Linear(embed_size, embed_size)
    
    def forward(self, x, mask=None):
        N, seq_length, _ = x.shape
        
        # Linear projections
        Q = self.queries(x).reshape(N, seq_length, self.heads, self.head_dim).transpose(1, 2)
        K = self.keys(x).reshape(N, seq_length, self.heads, self.head_dim).transpose(1, 2)
        V = self.values(x).reshape(N, seq_length, self.heads, self.head_dim).transpose(1, 2)
        
        # Scaled dot-product attention
        energy = torch.einsum("nhq,nhk->nhqk", [Q, K])
        
        if mask is not None:
            energy = energy.masked_fill(mask == 0, float("-1e20"))
        
        attention = torch.softmax(energy / math.sqrt(self.head_dim), dim=-1)
        
        # Apply attention to values
        out = torch.einsum("nhqk,nhk->nhq", [attention, V])
        out = out.transpose(1, 2).reshape(N, seq_length, -1)
        
        return self.fc_out(out)
```

**Key points:**
- Queries, Keys, Values are linear projections
- Attention scores = QK^T / √d_k
- Multi-head allows attending to different positions
- Complexity: O(n² × d)

### 2. What is the difference between BERT and GPT?

**Answer:**

| Aspect | BERT | GPT |
|--------|------|-----|
| **Architecture** | Encoder-only | Decoder-only |
| **Training** | MLM + NSP | Next token prediction |
| **Direction** | Bidirectional | Unidirectional (left-to-right) |
| **Use Case** | Understanding | Generation |
| **Fine-tuning** | Classification, NER, QA | Text completion, generation |

```python
# BERT - Understanding tasks
from transformers import BertForSequenceClassification
model = BertForSequenceClassification.from_pretrained('bert-base-uncased', num_labels=2)

# GPT - Generation tasks
from transformers import GPT2LMHeadModel
model = GPT2LMHeadModel.from_pretrained('gpt2')
```

### 3. Explain positional encoding

**Answer:**
Transformers have no inherent notion of word order, so positional encoding adds position information.

```python
import torch
import math

class PositionalEncoding(nn.Module):
    def __init__(self, embed_size, max_length=5000):
        super().__init__()
        pe = torch.zeros(max_length, embed_size)
        position = torch.arange(0, max_length, dtype=torch.float).unsqueeze(1)
        div_term = torch.exp(torch.arange(0, embed_size, 2).float() * (-math.log(10000.0) / embed_size))
        
        pe[:, 0::2] = torch.sin(position * div_term)
        pe[:, 1::2] = torch.cos(position * div_term)
        
        pe = pe.unsqueeze(0)
        self.register_buffer('pe', pe)
    
    def forward(self, x):
        return x + self.pe[:, :x.size(1)]
```

**Types:**
- **Absolute**: Fixed sinusoidal (original Transformer)
- **Learned**: Trainable embeddings (BERT, GPT)
- **Relative**: Encode relative positions (ALiBi)
- **Rotary (RoPE)**: Rotate embeddings (modern LLMs)

---

## Language Models

### 1. What is masked language modeling?

**Answer:**
BERT's pre-training objective: randomly mask tokens and predict them.

```python
from transformers import BertForMaskedLM, BertTokenizer

tokenizer = BertTokenizer.from_pretrained('bert-base-uncased')
model = BertForMaskedLM.from_pretrained('bert-base-uncased')

text = "The capital of France is [MASK]."
inputs = tokenizer(text, return_tensors='pt')
outputs = model(**inputs)
predictions = outputs.logits

# Get prediction for masked token
masked_index = torch.where(inputs['input_ids'] == tokenizer.mask_token_id)[1]
predicted_token = tokenizer.decode(predictions[0, masked_index].argmax(-1))
print(f"Predicted: {predicted_token}")  # Paris
```

### 2. Explain perplexity

**Answer:**
Perplexity measures how well a probability model predicts a sample.

```
PPL = exp(-1/N × Σ log P(w_i | w_1, ..., w_{i-1}))
```

- Lower perplexity = better model
- Measures uncertainty in predictions
- Useful for comparing language models

```python
import torch

def calculate_perplexity(model, tokenizer, text):
    inputs = tokenizer(text, return_tensors='pt')
    with torch.no_grad():
        outputs = model(**inputs, labels=inputs['input_ids'])
        loss = outputs.loss
    return torch.exp(loss).item()
```

### 3. What is temperature in text generation?

**Answer:**
Temperature controls randomness in sampling.

```python
# Temperature scaling
def temperature_scale(logits, temperature):
    return logits / temperature

# Low temperature (e.g., 0.2): More deterministic, less creative
# Medium temperature (e.g., 0.7): Balanced
# High temperature (e.g., 1.5): More random, more creative

from transformers import pipeline

generator = pipeline('text-generation', model='gpt2')

# Low temperature - more focused
text_low = generator("The cat", temperature=0.2, max_length=50)

# High temperature - more diverse
text_high = generator("The cat", temperature=1.5, max_length=50)
```

---

## Applications

### 1. How do you build a named entity recognition system?

**Answer:**

```python
# Method 1: Rule-based
import spacy
nlp = spacy.load('en_core_web_sm')

def extract_entities(text):
    doc = nlp(text)
    return [(ent.text, ent.label_) for ent in doc.ents]

# Method 2: Transformer-based
from transformers import pipeline

ner = pipeline('ner', aggregation_strategy='simple')
entities = ner("Apple Inc. is based in Cupertino, California")

# Method 3: Custom NER with fine-tuning
from transformers import BertForTokenClassification, BertTokenizer

model = BertForTokenClassification.from_pretrained(
    'bert-base-uncased', 
    num_labels=9  # CoNLL-2003 has 9 tags
)
```

### 2. How do you handle imbalanced text classification?

**Answer:**

```python
from sklearn.utils.class_weight import compute_class_weight
import torch

# 1. Class weights
weights = compute_class_weight('balanced', classes=np.unique(y_train), y=y_train)
class_weights = torch.FloatTensor(weights)
criterion = torch.nn.CrossEntropyLoss(weight=class_weights)

# 2. Oversampling minority class
from imblearn.over_sampling import SMOTE
smote = SMOTE(random_state=42)
X_resampled, y_resampled = smote.fit_resample(X, y)

# 3. Focal loss
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

# 4. Data augmentation
# - Synonym replacement
# - Random insertion/deletion
# - Back translation
```

---

## Advanced Topics

### 1. What is retrieval-augmented generation (RAG)?

**Answer:**
Combines retrieval (finding relevant documents) with generation (producing answers).

```python
from sentence_transformers import SentenceTransformer
import numpy as np

class RAGSystem:
    def __init__(self):
        self.encoder = SentenceTransformer('all-MiniLM-L6-v2')
        self.generator = pipeline('text-generation', model='gpt2')
        self.documents = []
        self.doc_embeddings = None
    
    def index_documents(self, documents):
        self.documents = documents
        self.doc_embeddings = self.encoder.encode(documents)
    
    def retrieve(self, query, top_k=3):
        query_emb = self.encoder.encode([query])
        similarities = np.dot(self.doc_embeddings, query_emb.T).flatten()
        top_indices = np.argsort(similarities)[-top_k:][::-1]
        return [self.documents[i] for i in top_indices]
    
    def generate(self, query, top_k=3):
        retrieved = self.retrieve(query, top_k)
        context = '\n'.join(retrieved)
        prompt = f"Context: {context}\n\nQuestion: {query}\n\nAnswer:"
        return self.generator(prompt, max_length=200)[0]['generated_text']
```

### 2. Explain parameter-efficient fine-tuning (PEFT)

**Answer:**
Methods to fine-tune large models with few trainable parameters.

```python
from peft import LoraConfig, get_peft_model

# LoRA (Low-Rank Adaptation)
config = LoraConfig(
    r=8,  # Rank
    lora_alpha=32,
    target_modules=["query", "value"],
    lora_dropout=0.1,
    bias="none",
)

model = get_peft_model(model, config)
print(f"Trainable parameters: {model.print_trainable_parameters()}")

# Other PEFT methods:
# - Prefix Tuning
# - Prompt Tuning
# - Adapter Layers
# - BitFit
```

### 3. What is chain-of-thought prompting?

**Answer:**
Prompting technique that encourages step-by-step reasoning.

```python
# Standard prompt
standard = "Q: Roger has 5 tennis balls. He buys 2 more cans of 3 each. How many does he have now?"

# Chain-of-thought prompt
cot = """Q: Roger has 5 tennis balls. He buys 2 more cans of 3 each. How many does he have now?
A: Let's think step by step.
Roger started with 5 balls.
2 cans of 3 balls = 6 balls.
5 + 6 = 11.
The answer is 11.

Q: The cafeteria had 23 apples. They used 20 for lunch and bought 6 more. How many apples do they have?
A: Let's think step by step."""

# Zero-shot CoT
zero_shot_cot = "Q: ... Let's think step by step."
```

---

## Quick Reference

| Concept | Key Point |
|---------|-----------|
| TF-IDF | Term importance weighting |
| Word2Vec | Local context embeddings |
| BERT | Bidirectional encoder |
| GPT | Autoregressive decoder |
| Attention | QK^T/√d_k softmax |
| Temperature | Controls generation randomness |
| Perplexity | Model uncertainty measure |
| RAG | Retrieval + Generation |
| LoRA | Low-rank fine-tuning |
| CoT | Step-by-step reasoning |
