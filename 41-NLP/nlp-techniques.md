# NLP Techniques

## Table of Contents

1. [Text Classification](#text-classification)
2. [Named Entity Recognition](#named-entity-recognition)
3. [Sentiment Analysis](#sentiment-analysis)
4. [Text Similarity](#text-similarity)
5. [Topic Modeling](#topic-modeling)
6. [Information Extraction](#information-extraction)

---

## Text Classification

### Traditional Approach

```python
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB
from sklearn.linear_model import LogisticRegression
from sklearn.svm import LinearSVC
from sklearn.pipeline import Pipeline
from sklearn.model_selection import cross_val_score
import numpy as np

class TextClassifier:
    def __init__(self, method='tfidf_logistic'):
        self.method = method
        self.pipeline = self._create_pipeline()
    
    def _create_pipeline(self):
        if self.method == 'tfidf_nb':
            return Pipeline([
                ('tfidf', TfidfVectorizer(max_features=10000, ngram_range=(1, 2))),
                ('clf', MultinomialNB(alpha=0.1))
            ])
        elif self.method == 'tfidf_logistic':
            return Pipeline([
                ('tfidf', TfidfVectorizer(max_features=10000, ngram_range=(1, 2))),
                ('clf', LogisticRegression(max_iter=1000, C=1.0))
            ])
        elif self.method == 'tfidf_svm':
            return Pipeline([
                ('tfidf', TfidfVectorizer(max_features=10000, ngram_range=(1, 2))),
                ('clf', LinearSVC(C=1.0))
            ])
    
    def train(self, texts, labels):
        self.pipeline.fit(texts, labels)
    
    def predict(self, texts):
        return self.pipeline.predict(texts)
    
    def evaluate(self, texts, labels, cv=5):
        scores = cross_val_score(self.pipeline, texts, labels, cv=cv, scoring='accuracy')
        return scores.mean(), scores.std()
```

### Deep Learning Approach

```python
import torch
import torch.nn as nn
from torch.utils.data import Dataset, DataLoader

class TextDataset(Dataset):
    def __init__(self, texts, labels, tokenizer, max_length=512):
        self.texts = texts
        self.labels = labels
        self.tokenizer = tokenizer
        self.max_length = max_length
    
    def __len__(self):
        return len(self.texts)
    
    def __getitem__(self, idx):
        encoding = self.tokenizer(
            self.texts[idx],
            max_length=self.max_length,
            padding='max_length',
            truncation=True,
            return_tensors='pt'
        )
        return {
            'input_ids': encoding['input_ids'].squeeze(),
            'attention_mask': encoding['attention_mask'].squeeze(),
            'label': torch.tensor(self.labels[idx], dtype=torch.long)
        }

class BertClassifier(nn.Module):
    def __init__(self, bert_model, num_classes, dropout=0.3):
        super().__init__()
        self.bert = bert_model
        self.dropout = nn.Dropout(dropout)
        self.classifier = nn.Linear(self.bert.config.hidden_size, num_classes)
    
    def forward(self, input_ids, attention_mask):
        outputs = self.bert(input_ids=input_ids, attention_mask=attention_mask)
        pooled_output = outputs.pooler_output
        return self.classifier(self.dropout(pooled_output))

# Usage
from transformers import BertTokenizer, BertModel

tokenizer = BertTokenizer.from_pretrained('bert-base-uncased')
bert_model = BertModel.from_pretrained('bert-base-uncased')
model = BertClassifier(bert_model, num_classes=2)
```

---

## Named Entity Recognition

### CRF-based NER

```python
import torch
import torch.nn as nn

class CRF(nn.Module):
    def __init__(self, num_tags):
        super().__init__()
        self.num_tags = num_tags
        self.transitions = nn.Parameter(torch.randn(num_tags, num_tags))
    
    def forward(self, emissions, tags, mask):
        # Compute forward pass
        score = self._forward_algorithm(emissions, mask)
        # Compute gold score
        gold_score = self._score_sentence(emissions, tags, mask)
        return score - gold_score
    
    def _forward_algorithm(self, emissions, mask):
        batch_size, seq_len, num_tags = emissions.shape
        
        # Initialize
        score = emissions[:, 0]
        
        for t in range(1, seq_len):
            broadcast_score = score.unsqueeze(2)
            broadcast_emissions = emissions[:, t].unsqueeze(1)
            next_score = broadcast_score + self.transitions + broadcast_emissions
            next_score = torch.logsumexp(next_score, dim=1)
            
            # Apply mask
            score = torch.where(mask[:, t].unsqueeze(1).bool(), next_score, score)
        
        return torch.logsumexp(score, dim=1)
    
    def _score_sentence(self, emissions, tags, mask):
        batch_size, seq_len, num_tags = emissions.shape
        
        score = emissions[:, 0].gather(1, tags[:, 0].unsqueeze(1)).squeeze(1)
        
        for t in range(1, seq_len):
            score += self.transitions[tags[:, t-1], tags[:, t]] * mask[:, t]
            score += emissions[:, t].gather(1, tags[:, t].unsqueeze(1)).squeeze(1) * mask[:, t]
        
        return score

class BiLSTMCRF(nn.Module):
    def __init__(self, vocab_size, embed_dim, hidden_dim, num_tags):
        super().__init__()
        self.embedding = nn.Embedding(vocab_size, embed_dim)
        self.lstm = nn.LSTM(embed_dim, hidden_dim // 2, num_layers=2, 
                           batch_first=True, bidirectional=True)
        self.hidden2tag = nn.Linear(hidden_dim, num_tags)
        self.crf = CRF(num_tags)
    
    def forward(self, x, tags=None, mask=None):
        embedded = self.embedding(x)
        lstm_out, _ = self.lstm(embedded)
        emissions = self.hidden2tag(lstm_out)
        
        if tags is not None:
            # Training
            loss = -self.crf(emissions, tags, mask)
            return loss
        else:
            # Inference
            return self.crf.viterbi_decode(emissions)
```

### Transformer-based NER

```python
from transformers import BertForTokenClassification, BertTokenizer
import torch

class BertNER:
    def __init__(self, num_labels):
        self.tokenizer = BertTokenizer.from_pretrained('bert-base-uncased')
        self.model = BertForTokenClassification.from_pretrained(
            'bert-base-uncased', num_labels=num_labels
        )
    
    def tokenize_and_align_labels(self, text, labels):
        tokenized = self.tokenizer(
            text,
            is_split_into_words=True,
            return_offsets_mapping=True,
            padding=True,
            truncation=True,
            max_length=512
        )
        
        word_ids = tokenized.word_ids()
        label_all_tokens = True
        previous_word_idx = None
        label_ids = []
        
        for word_idx in word_ids:
            if word_idx is None:
                label_ids.append(-100)
            elif word_idx != previous_word_idx:
                label_ids.append(labels[word_idx])
            else:
                label_ids.append(labels[word_idx] if label_all_tokens else -100)
            previous_word_idx = word_idx
        
        tokenized['labels'] = label_ids
        return tokenized
    
    def predict(self, text):
        inputs = self.tokenizer(text, return_tensors='pt')
        outputs = self.model(**inputs)
        predictions = torch.argmax(outputs.logits, dim=2)
        return predictions
```

---

## Sentiment Analysis

### Aspect-Based Sentiment Analysis

```python
class AspectSentimentAnalyzer:
    def __init__(self):
        self.aspects = ['food', 'service', 'ambiance', 'price']
    
    def extract_aspects(self, text):
        import re
        aspects = {}
        for aspect in self.aspects:
            if re.search(rf'\b{aspect}\b', text.lower()):
                aspects[aspect] = True
        return aspects
    
    def analyze_sentiment(self, text, aspect):
        # Simple rule-based approach
        positive_words = ['good', 'great', 'excellent', 'amazing', 'love']
        negative_words = ['bad', 'terrible', 'awful', 'hate', 'poor']
        
        words = text.lower().split()
        pos_count = sum(1 for w in words if w in positive_words)
        neg_count = sum(1 for w in words if w in negative_words)
        
        if pos_count > neg_count:
            return 'positive'
        elif neg_count > pos_count:
            return 'negative'
        else:
            return 'neutral'
    
    def analyze(self, text):
        aspects = self.extract_aspects(text)
        results = {}
        for aspect in aspects:
            results[aspect] = self.analyze_sentiment(text, aspect)
        return results

# Usage
analyzer = AspectSentimentAnalyzer()
text = "The food was great but the service was terrible"
print(analyzer.analyze(text))
# {'food': 'positive', 'service': 'negative'}
```

### Sentiment with Transformers

```python
from transformers import pipeline

class TransformerSentiment:
    def __init__(self, model_name='nlptown/bert-base-multilingual-uncased-sentiment'):
        self.classifier = pipeline('sentiment-analysis', model=model_name)
    
    def analyze(self, text):
        result = self.classifier(text)[0]
        return {
            'label': result['label'],
            'score': result['score']
        }
    
    def batch_analyze(self, texts):
        results = self.classifier(texts)
        return [{'text': text, **result} for text, result in zip(texts, results)]

# Usage
sentiment = TransformerSentiment()
print(sentiment.analyze("This product is amazing!"))
```

---

## Text Similarity

### Cosine Similarity

```python
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer

class TextSimilarity:
    def __init__(self):
        self.vectorizer = TfidfVectorizer()
    
    def cosine_similarity(self, text1, text2):
        tfidf_matrix = self.vectorizer.fit_transform([text1, text2])
        similarity = (tfidf_matrix * tfidf_matrix.T).toarray()[0, 1]
        return similarity
    
    def batch_similarity(self, texts):
        tfidf_matrix = self.vectorizer.fit_transform(texts)
        similarity_matrix = (tfidf_matrix * tfidf_matrix.T).toarray()
        return similarity_matrix

# Usage
similarity = TextSimilarity()
text1 = "The cat sat on the mat"
text2 = "A cat was sitting on the mat"
print(similarity.cosine_similarity(text1, text2))
```

### Sentence Embeddings

```python
from sentence_transformers import SentenceTransformer
import numpy as np

class SentenceSimilarity:
    def __init__(self, model_name='all-MiniLM-L6-v2'):
        self.model = SentenceTransformer(model_name)
    
    def get_embedding(self, text):
        return self.model.encode(text)
    
    def similarity(self, text1, text2):
        emb1 = self.get_embedding(text1)
        emb2 = self.get_embedding(text2)
        return np.dot(emb1, emb2) / (np.linalg.norm(emb1) * np.linalg.norm(emb2))
    
    def find_most_similar(self, query, candidates):
        query_emb = self.get_embedding(query)
        candidate_embs = self.get_embedding(candidates)
        
        similarities = np.dot(candidate_embs, query_emb) / (
            np.linalg.norm(candidate_embs, axis=1) * np.linalg.norm(query_emb)
        )
        
        return sorted(zip(candidates, similarities), key=lambda x: x[1], reverse=True)

# Usage
similarity = SentenceSimilarity()
print(similarity.similarity("How are you?", "How do you do?"))
```

---

## Topic Modeling

### Latent Dirichlet Allocation (LDA)

```python
from sklearn.decomposition import LatentDirichletAllocation
from sklearn.feature_extraction.text import CountVectorizer
import numpy as np

class LDATopicModel:
    def __init__(self, n_topics=10):
        self.vectorizer = CountVectorizer(max_features=10000, stop_words='english')
        self.lda = LatentDirichletAllocation(
            n_components=n_topics,
            random_state=42,
            max_iter=20
        )
    
    def fit(self, documents):
        doc_term_matrix = self.vectorizer.fit_transform(documents)
        self.lda.fit(doc_term_matrix)
        return self
    
    def get_topics(self, n_words=10):
        feature_names = self.vectorizer.get_feature_names_out()
        topics = []
        for topic_idx, topic in enumerate(self.lda.components_):
            top_words = [feature_names[i] for i in topic.argsort()[:-n_words-1:-1]]
            topics.append((topic_idx, top_words))
        return topics
    
    def transform(self, documents):
        doc_term_matrix = self.vectorizer.transform(documents)
        return self.lda.transform(doc_term_matrix)

# Usage
documents = [
    "Machine learning is a subset of artificial intelligence",
    "Deep learning uses neural networks with many layers",
    "Natural language processing deals with text and speech",
    "Computer vision analyzes images and videos"
]

lda = LDATopicModel(n_topics=2)
lda.fit(documents)
print(lda.get_topics())
```

### Non-negative Matrix Factorization (NMF)

```python
from sklearn.decomposition import NMF
from sklearn.feature_extraction.text import TfidfVectorizer

class NMFTopicModel:
    def __init__(self, n_topics=10):
        self.vectorizer = TfidfVectorizer(max_features=10000, stop_words='english')
        self.nmf = NMF(n_components=n_topics, random_state=42)
    
    def fit(self, documents):
        tfidf_matrix = self.vectorizer.fit_transform(documents)
        self.nmf.fit(tfidf_matrix)
        return self
    
    def get_topics(self, n_words=10):
        feature_names = self.vectorizer.get_feature_names_out()
        topics = []
        for topic_idx, topic in enumerate(self.nmf.components_):
            top_words = [feature_names[i] for i in topic.argsort()[:-n_words-1:-1]]
            topics.append((topic_idx, top_words))
        return topics

# Usage
nmf = NMFTopicModel(n_topics=2)
nmf.fit(documents)
print(nmf.get_topics())
```

---

## Information Extraction

### Relation Extraction

```python
class RelationExtractor:
    def __init__(self):
        self.relation_patterns = {
            'works_for': r'(\w+)\s+works?\s+for\s+(\w+)',
            'located_in': r'(\w+)\s+is\s+located\s+in\s+(\w+)',
            'born_in': r'(\w+)\s+was\s+born\s+in\s+(\w+)'
        }
    
    def extract_relations(self, text):
        import re
        relations = []
        for relation, pattern in self.relation_patterns.items():
            matches = re.findall(pattern, text, re.IGNORECASE)
            for match in matches:
                relations.append({
                    'relation': relation,
                    'subject': match[0],
                    'object': match[1]
                })
        return relations

# Usage
extractor = RelationExtractor()
text = "John works for Google and was born in New York"
print(extractor.extract_relations(text))
```

### Coreference Resolution

```python
class CoreferenceResolver:
    def __init__(self):
        self.pronouns = ['he', 'she', 'it', 'they', 'him', 'her', 'them']
    
    def resolve(self, text, entities):
        # Simple heuristic-based resolution
        sentences = text.split('.')
        resolved = []
        
        for sentence in sentences:
            for pronoun in self.pronouns:
                if pronoun in sentence.lower():
                    # Find the most recent entity
                    for entity in reversed(entities):
                        if entity.lower() in sentence.lower():
                            sentence = sentence.replace(pronoun, entity)
                            break
            resolved.append(sentence)
        
        return '. '.join(resolved)

# Usage
resolver = CoreferenceResolver()
text = "John went to the store. He bought milk."
entities = ["John", "store"]
print(resolver.resolve(text, entities))
```

---

## Summary

| Technique | Purpose | Best For |
|-----------|---------|----------|
| Text Classification | Categorize text | Spam detection, topic routing |
| NER | Extract entities | Information extraction |
| Sentiment Analysis | Opinion mining | Reviews, social media |
| Text Similarity | Compare texts | Search, deduplication |
| Topic Modeling | Discover themes | Document analysis |
| Relation Extraction | Find relationships | Knowledge graphs |
