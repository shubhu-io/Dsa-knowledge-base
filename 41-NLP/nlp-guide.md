# NLP Complete Guide

## Table of Contents

1. [Text Preprocessing](#text-preprocessing)
2. [Classical NLP](#classical-nlp)
3. [Word Embeddings](#word-embeddings)
4. [Sequence Models](#sequence-models)
5. [Transformers](#transformers)
6. [Language Models](#language-models)

---

## Text Preprocessing

### Tokenization

```python
import nltk
from nltk.tokenize import word_tokenize, sent_tokenize
import re

class TextPreprocessor:
    def __init__(self):
        self.stop_words = set(nltk.corpus.stopwords.words('english'))
    
    def basic_tokenize(self, text):
        return word_tokenize(text.lower())
    
    def sentence_tokenize(self, text):
        return sent_tokenize(text)
    
    def clean_text(self, text):
        # Lowercase
        text = text.lower()
        # Remove special characters
        text = re.sub(r'[^a-zA-Z0-9\s]', '', text)
        # Remove extra whitespace
        text = re.sub(r'\s+', ' ', text).strip()
        return text
    
    def remove_stopwords(self, tokens):
        return [t for t in tokens if t not in self.stop_words]
    
    def preprocess(self, text):
        tokens = self.basic_tokenize(text)
        tokens = self.remove_stopwords(tokens)
        return tokens

# spaCy tokenization
import spacy
nlp = spacy.load('en_core_web_sm')

def spacy_tokenize(text):
    doc = nlp(text)
    return [(token.text, token.pos_, token.dep_) for token in doc]
```

### Stemming and Lemmatization

```python
from nltk.stem import PorterStemmer, WordNetLemmatizer

class StemmerLemmatizer:
    def __init__(self):
        self.stemmer = PorterStemmer()
        self.lemmatizer = WordNetLemmatizer()
    
    def stem(self, tokens):
        return [self.stemmer.stem(token) for token in tokens]
    
    def lemmatize(self, tokens, pos='n'):
        return [self.lemmatizer.lemmatize(token, pos) for token in tokens]
    
    def compare(self, word):
        return {
            'original': word,
            'stemmed': self.stemmer.stem(word),
            'lemmatized': self.lemmatizer.lemmatize(word)
        }

# Examples
sl = StemmerLemmatizer()
print(sl.compare('running'))  # {'original': 'running', 'stemmed': 'run', 'lemmatized': 'running'}
print(sl.compare('better'))   # {'original': 'better', 'stemmed': 'better', 'lemmatized': 'good'}
```

### Text Normalization

```python
class TextNormalizer:
    def __init__(self):
        import unicodedata
    
    def remove_accents(self, text):
        import unicodedata
        nfkd = unicodedata.normalize('NFKD', text)
        return ''.join(c for c in nfkd if not unicodedata.combining(c))
    
    def expand_contractions(self, text):
        contractions = {
            "can't": "cannot",
            "won't": "will not",
            "n't": " not",
            "'re": " are",
            "'s": " is",
            "'d": " would",
            "'ll": " will",
            "'t": " not",
            "'ve": " have",
            "'m": " am"
        }
        for contraction, expansion in contractions.items():
            text = text.replace(contraction, expansion)
        return text
    
    def normalize_unicode(self, text):
        import unicodedata
        return unicodedata.normalize('NFKD', text)
```

---

## Classical NLP

### Bag of Words (BoW)

```python
from sklearn.feature_extraction.text import CountVectorizer
import numpy as np

class BagOfWords:
    def __init__(self):
        self.vectorizer = CountVectorizer()
        self.vocabulary = {}
    
    def fit(self, documents):
        self.vectorizer.fit(documents)
        self.vocabulary = {word: idx for idx, word in enumerate(self.vectorizer.get_feature_names_out())}
        return self
    
    def transform(self, documents):
        return self.vectorizer.transform(documents).toarray()
    
    def fit_transform(self, documents):
        return self.vectorizer.fit_transform(documents).toarray()

# Usage
documents = [
    "The cat sat on the mat",
    "The dog sat on the log",
    "The cat and the dog are friends"
]

bow = BagOfWords()
X = bow.fit_transform(documents)
print(f"Vocabulary: {bow.vocabulary}")
print(f"Matrix shape: {X.shape}")
```

### TF-IDF

```python
from sklearn.feature_extraction.text import TfidfVectorizer
import numpy as np

class TFIDF:
    def __init__(self, max_features=None):
        self.vectorizer = TfidfVectorizer(max_features=max_features)
        self.idf = None
    
    def fit(self, documents):
        self.vectorizer.fit(documents)
        self.idf = self.vectorizer.idf_
        return self
    
    def transform(self, documents):
        return self.vectorizer.transform(documents).toarray()
    
    def get_top_terms(self, document, n=5):
        vector = self.vectorizer.transform([document]).toarray()[0]
        feature_names = self.vectorizer.get_feature_names_out()
        top_indices = vector.argsort()[-n:][::-1]
        return [(feature_names[i], vector[i]) for i in top_indices]

# Usage
tfidf = TFIDF()
X = tfidf.fit_transform(documents)
print(f"TF-IDF shape: {X.shape}")
```

### N-grams

```python
from sklearn.feature_extraction.text import CountVectorizer

class NgramAnalyzer:
    def __init__(self, n_range=(1, 2)):
        self.vectorizer = CountVectorizer(ngram_range=n_range)
    
    def fit_transform(self, documents):
        return self.vectorizer.fit_transform(documents)
    
    def get_ngrams(self, document):
        vector = self.vectorizer.transform([document]).toarray()[0]
        feature_names = self.vectorizer.get_feature_names_out()
        return [(ngram, count) for ngram, count in zip(feature_names, vector) if count > 0]

# Usage
ngrams = NgramAnalyzer(n_range=(1, 3))
X = ngrams.fit_transform(documents)
print(f"Features: {ngrams.vectorizer.get_feature_names_out()[:20]}")
```

---

## Word Embeddings

### Word2Vec

```python
from gensim.models import Word2Vec
import numpy as np

class Word2VecEmbedding:
    def __init__(self, vector_size=100, window=5, min_count=1):
        self.model = Word2Vec(
            vector_size=vector_size,
            window=window,
            min_count=min_count,
            workers=4
        )
    
    def train(self, sentences):
        self.model.build_vocab(sentences)
        self.model.train(sentences, total_examples=self.model.corpus_count, epochs=10)
    
    def get_vector(self, word):
        if word in self.model.wv:
            return self.model.wv[word]
        return None
    
    def most_similar(self, word, topn=5):
        return self.model.wv.most_similar(word, topn=topn)
    
    def document_vector(self, doc):
        words = doc.split()
        word_vectors = [self.model.wv[w] for w in words if w in self.model.wv]
        if word_vectors:
            return np.mean(word_vectors, axis=0)
        return np.zeros(self.model.vector_size)

# Usage
sentences = [
    ["the", "cat", "sat", "on", "the", "mat"],
    ["the", "dog", "sat", "on", "the", "log"],
    ["cats", "and", "dogs", "are", "friends"]
]

w2v = Word2VecEmbedding()
w2v.train(sentences)
print(w2v.most_similar("cat"))
```

### GloVe

```python
import numpy as np

class GloVeEmbedding:
    def __init__(self, glove_path):
        self.embeddings = self.load_glove(glove_path)
    
    def load_glove(self, path):
        embeddings_index = {}
        with open(path, encoding='utf-8') as f:
            for line in f:
                values = line.split()
                word = values[0]
                vector = np.asarray(values[1:], dtype='float32')
                embeddings_index[word] = vector
        return embeddings_index
    
    def get_vector(self, word):
        return self.embeddings.get(word, None)
    
    def document_vector(self, doc):
        words = doc.split()
        word_vectors = [self.embeddings[w] for w in words if w in self.embeddings]
        if word_vectors:
            return np.mean(word_vectors, axis=0)
        return None

# Usage
# glove = GloVeEmbedding('glove.6B.100d.txt')
# print(glove.get_vector('python'))
```

### FastText

```python
from gensim.models import FastText

class FastTextEmbedding:
    def __init__(self, vector_size=100, window=5, min_count=1):
        self.model = FastText(
            vector_size=vector_size,
            window=window,
            min_count=min_count,
            workers=4
        )
    
    def train(self, sentences):
        self.model.build_vocab(sentences)
        self.model.train(sentences, total_examples=self.model.corpus_count, epochs=10)
    
    def get_vector(self, word):
        return self.model.wv[word]
    
    def get_subword_vector(self, word):
        # FastText can generate vectors for OOV words
        return self.model.wv[word]

# Usage
ft = FastTextEmbedding()
ft.train(sentences)
# Can handle out-of-vocabulary words!
print(ft.get_vector("unfamiliarword"))
```

---

## Sequence Models

### LSTM for Text Classification

```python
import torch
import torch.nn as nn

class LSTMClassifier(nn.Module):
    def __init__(self, vocab_size, embed_dim, hidden_dim, output_dim, n_layers, dropout):
        super().__init__()
        self.embedding = nn.Embedding(vocab_size, embed_dim)
        self.lstm = nn.LSTM(embed_dim, hidden_dim, num_layers=n_layers, 
                           batch_first=True, dropout=dropout, bidirectional=True)
        self.fc = nn.Linear(hidden_dim * 2, output_dim)
        self.dropout = nn.Dropout(dropout)
    
    def forward(self, text):
        embedded = self.dropout(self.embedding(text))
        output, (hidden, cell) = self.lstm(embedded)
        
        # Concatenate final forward and backward hidden states
        hidden = torch.cat((hidden[-2,:,:], hidden[-1,:,:]), dim=1)
        
        return self.fc(self.dropout(hidden))

# Usage
vocab_size = 10000
embed_dim = 300
hidden_dim = 256
output_dim = 2
n_layers = 2
dropout = 0.5

model = LSTMClassifier(vocab_size, embed_dim, hidden_dim, output_dim, n_layers, dropout)
```

### Bidirectional LSTM

```python
class BiLSTM(nn.Module):
    def __init__(self, vocab_size, embed_dim, hidden_dim, output_dim):
        super().__init__()
        self.embedding = nn.Embedding(vocab_size, embed_dim)
        self.bilstm = nn.LSTM(embed_dim, hidden_dim, num_layers=2, 
                             batch_first=True, bidirectional=True)
        self.attention = nn.Linear(hidden_dim * 2, 1)
        self.fc = nn.Linear(hidden_dim * 2, output_dim)
    
    def forward(self, text):
        embedded = self.embedding(text)
        output, _ = self.bilstm(embedded)
        
        # Attention
        attn_weights = torch.softmax(self.attention(output), dim=1)
        context = torch.sum(attn_weights * output, dim=1)
        
        return self.fc(context)
```

---

## Transformers

### Self-Attention

```python
import torch
import torch.nn as nn
import math

class SelfAttention(nn.Module):
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
        
        q = self.queries(x).reshape(N, seq_length, self.heads, self.head_dim).transpose(1, 2)
        k = self.keys(x).reshape(N, seq_length, self.heads, self.head_dim).transpose(1, 2)
        v = self.values(x).reshape(N, seq_length, self.heads, self.head_dim).transpose(1, 2)
        
        energy = torch.einsum("nhq,nhk->nhqk", [q, k])
        
        if mask is not None:
            energy = energy.masked_fill(mask == 0, float("-1e20"))
        
        attention = torch.softmax(energy / math.sqrt(self.head_dim), dim=-1)
        out = torch.einsum("nhqk,nhk->nhq", [attention, v])
        
        out = out.transpose(1, 2).reshape(N, seq_length, self.embed_size)
        return self.fc_out(out)
```

### Transformer Block

```python
class TransformerBlock(nn.Module):
    def __init__(self, embed_size, heads, dropout, forward_expansion):
        super().__init__()
        self.attention = SelfAttention(embed_size, heads)
        self.norm1 = nn.LayerNorm(embed_size)
        self.norm2 = nn.LayerNorm(embed_size)
        
        self.feed_forward = nn.Sequential(
            nn.Linear(embed_size, forward_expansion * embed_size),
            nn.GELU(),
            nn.Linear(forward_expansion * embed_size, embed_size)
        )
        
        self.dropout = nn.Dropout(dropout)
    
    def forward(self, x, mask=None):
        attention = self.attention(x, mask)
        x = self.dropout(self.norm1(attention + x))
        forward = self.feed_forward(x)
        out = self.dropout(self.norm2(forward + x))
        return out
```

---

## Language Models

### GPT-style Decoder

```python
class GPT(nn.Module):
    def __init__(self, vocab_size, embed_size, num_layers, heads, forward_expansion, dropout, max_length):
        super().__init__()
        self.embed_size = embed_size
        self.word_embedding = nn.Embedding(vocab_size, embed_size)
        self.position_embedding = nn.Embedding(max_length, embed_size)
        
        self.layers = nn.ModuleList([
            TransformerBlock(embed_size, heads, dropout, forward_expansion)
            for _ in range(num_layers)
        ])
        
        self.fc_out = nn.Linear(embed_size, vocab_size)
        self.dropout = nn.Dropout(dropout)
    
    def forward(self, x, mask=None):
        N, seq_length = x.shape
        positions = torch.arange(0, seq_length).expand(N, seq_length).to(x.device)
        
        x = self.dropout(self.word_embedding(x) + self.position_embedding(positions))
        
        for layer in self.layers:
            x = layer(x, mask)
        
        return self.fc_out(x)

# Usage
model = GPT(vocab_size=50000, embed_size=768, num_layers=12, heads=12, 
            forward_expansion=4, dropout=0.1, max_length=512)
```

### Using Pre-trained Models

```python
from transformers import pipeline

# Sentiment analysis
classifier = pipeline('sentiment-analysis')
result = classifier('I love this product!')
print(result)

# Text generation
generator = pipeline('text-generation', model='gpt2')
text = generator('The future of AI is', max_length=50)
print(text)

# Named Entity Recognition
ner = pipeline('ner')
entities = ner('Apple Inc. is based in Cupertino, California')
print(entities)

# Question Answering
qa = pipeline('question-answering')
result = qa(question='What is the capital of France?', context='Paris is the capital of France.')
print(result)

# Summarization
summarizer = pipeline('summarization')
summary = summarizer('Long text here...', max_length=150)
print(summary)
```

---

## Summary

| Component | Purpose | Key Models |
|-----------|---------|------------|
| Tokenization | Split text | Word, Subword, Character |
| Embeddings | Word representation | Word2Vec, GloVe, BERT |
| Classical | Feature extraction | BoW, TF-IDF, N-grams |
| Sequence Models | Sequential processing | LSTM, GRU, BiLSTM |
| Transformers | Self-attention | BERT, GPT, T5 |
| Language Models | Text generation/prediction | GPT, BERT, T5 |
