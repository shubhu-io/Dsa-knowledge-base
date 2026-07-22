# NLP Applications

## Table of Contents

1. [Machine Translation](#machine-translation)
2. [Text Summarization](#text-summarization)
3. [Question Answering](#question-answering)
4. [Chatbots](#chatbots)
5. [Text Generation](#text-generation)
6. [Speech Processing](#speech-processing)

---

## Machine Translation

### Seq2Seq Model

```python
import torch
import torch.nn as nn

class Encoder(nn.Module):
    def __init__(self, input_size, embed_size, hidden_size, num_layers, dropout):
        super().__init__()
        self.embedding = nn.Embedding(input_size, embed_size)
        self.rnn = nn.LSTM(embed_size, hidden_size, num_layers, 
                          batch_first=True, bidirectional=True, dropout=dropout)
        self.fc_hidden = nn.Linear(hidden_size * 2, hidden_size)
    
    def forward(self, x):
        embedded = self.embedding(x)
        outputs, (hidden, cell) = self.rnn(embedded)
        
        # Combine bidirectional states
        hidden = torch.cat((hidden[-2,:,:], hidden[-1,:,:]), dim=1)
        hidden = torch.tanh(self.fc_hidden(hidden))
        
        return outputs, hidden.unsqueeze(0), cell

class Decoder(nn.Module):
    def __init__(self, output_size, embed_size, hidden_size, num_layers, dropout):
        super().__init__()
        self.embedding = nn.Embedding(output_size, embed_size)
        self.rnn = nn.LSTM(hidden_size + embed_size, hidden_size, num_layers,
                          batch_first=True, dropout=dropout)
        self.attention = nn.Linear(hidden_size * 3, hidden_size)
        self.fc_out = nn.Linear(hidden_size * 3 + embed_size, output_size)
        self.dropout = nn.Dropout(dropout)
    
    def forward(self, x, hidden, cell, encoder_outputs):
        x = x.unsqueeze(1)
        embedded = self.dropout(self.embedding(x))
        
        # Attention
        hidden_expanded = hidden[-1].unsqueeze(1).repeat(1, encoder_outputs.shape[1], 1)
        attention_input = torch.cat((hidden_expanded, encoder_outputs), dim=2)
        attention_weights = torch.softmax(self.attention(attention_input), dim=1)
        
        context = torch.sum(attention_weights * encoder_outputs, dim=1).unsqueeze(1)
        rnn_input = torch.cat((embedded, context), dim=2)
        
        output, (hidden, cell) = self.rnn(rnn_input, hidden, cell)
        
        prediction = self.fc_out(torch.cat((output.squeeze(1), context.squeeze(1), embedded.squeeze(1)), dim=1))
        return prediction, hidden, cell

class Seq2Seq(nn.Module):
    def __init__(self, encoder, decoder, device):
        super().__init__()
        self.encoder = encoder
        self.decoder = decoder
        self.device = device
    
    def forward(self, source, target, teacher_forcing_ratio=0.5):
        batch_size = source.shape[0]
        target_len = target.shape[1]
        target_vocab_size = self.decoder.fc_out.out_features
        
        outputs = torch.zeros(batch_size, target_len, target_vocab_size).to(self.device)
        
        encoder_outputs, hidden, cell = self.encoder(source)
        x = target[:, 0]
        
        for t in range(1, target_len):
            output, hidden, cell = self.decoder(x, hidden, cell, encoder_outputs)
            outputs[:, t, :] = output
            
            teacher_force = torch.rand(1).item() < teacher_forcing_ratio
            top1 = output.argmax(1)
            x = target[:, t] if teacher_force else top1
        
        return outputs
```

### Using Pre-trained Translation

```python
from transformers import MarianMTModel, MarianTokenizer

class Translator:
    def __init__(self, model_name='Helsinki-NLP/opus-mt-en-fr'):
        self.tokenizer = MarianTokenizer.from_pretrained(model_name)
        self.model = MarianMTModel.from_pretrained(model_name)
    
    def translate(self, text):
        inputs = self.tokenizer(text, return_tensors='pt', padding=True)
        translated = self.model.generate(**inputs)
        return self.tokenizer.batch_decode(translated, skip_special_tokens=True)
    
    def batch_translate(self, texts):
        inputs = self.tokenizer(texts, return_tensors='pt', padding=True, truncation=True)
        translated = self.model.generate(**inputs)
        return self.tokenizer.batch_decode(translated, skip_special_tokens=True)

# Usage
translator = Translator()
print(translator.translate("Hello, how are you?"))
```

---

## Text Summarization

### Extractive Summarization

```python
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

class ExtractiveSummarizer:
    def __init__(self):
        self.vectorizer = TfidfVectorizer()
    
    def summarize(self, text, num_sentences=3):
        sentences = text.split('. ')
        if len(sentences) <= num_sentences:
            return text
        
        # Compute TF-IDF matrix
        tfidf_matrix = self.vectorizer.fit_transform(sentences)
        
        # Compute sentence scores based on similarity to document centroid
        centroid = tfidf_matrix.mean(axis=0).A1
        scores = []
        
        for i in range(len(sentences)):
            sentence_vec = tfidf_matrix[i].toarray().flatten()
            score = cosine_similarity([sentence_vec], [centroid])[0][0]
            scores.append(score)
        
        # Select top sentences
        ranked_sentences = np.argsort(scores)[::-1][:num_sentences]
        selected = [sentences[i] for i in sorted(ranked_sentences)]
        
        return '. '.join(selected) + '.'

# Usage
summarizer = ExtractiveSummarizer()
text = """Natural language processing is a subfield of linguistics, computer science, 
and artificial intelligence concerned with the interactions between computers and human language. 
The goal is to enable computers to understand, interpret, and generate human language in a valuable way. 
NLP combines computational linguistics with statistical, machine learning, and deep learning models. 
These technologies enable computers to process human language in the form of text or voice data. 
They can understand its full meaning, complete with the speaker's intent and sentiment."""
print(summarizer.summarize(text, num_sentences=2))
```

### Abstractive Summarization

```python
from transformers import pipeline

class AbstractiveSummarizer:
    def __init__(self, model_name='facebook/bart-large-cnn'):
        self.summarizer = pipeline('summarization', model=model_name)
    
    def summarize(self, text, max_length=150, min_length=40):
        summary = self.summarizer(text, max_length=max_length, min_length=min_length)
        return summary[0]['summary_text']
    
    def batch_summarize(self, texts, max_length=150):
        return self.summarizer(texts, max_length=max_length)

# Usage
summarizer = AbstractiveSummarizer()
text = """Long article text here..."""
print(summarizer.summarize(text))
```

---

## Question Answering

### Extractive QA

```python
from transformers import pipeline

class QuestionAnswerer:
    def __init__(self, model_name='deepset/roberta-base-squad2'):
        self.qa_pipeline = pipeline('question-answering', model=model_name)
    
    def answer(self, question, context):
        result = self.qa_pipeline(question=question, context=context)
        return {
            'answer': result['answer'],
            'score': result['score'],
            'start': result['start'],
            'end': result['end']
        }
    
    def batch_answer(self, questions, contexts):
        inputs = [{'question': q, 'context': c} for q, c in zip(questions, contexts)]
        return self.qa_pipeline(inputs)

# Usage
qa = QuestionAnswerer()
context = """Python is a high-level programming language. It was created by Guido van Rossum 
and first released in 1991. Python emphasizes code readability with its notable use of indentation."""
print(qa.answer("Who created Python?", context))
```

### Retrieval-Augmented QA

```python
import numpy as np
from sentence_transformers import SentenceTransformer

class RAGSystem:
    def __init__(self):
        self.encoder = SentenceTransformer('all-MiniLM-L6-v2')
        self.qa_pipeline = pipeline('question-answering', model='deepset/roberta-base-squad2')
        self.documents = []
        self.doc_embeddings = None
    
    def add_documents(self, documents):
        self.documents.extend(documents)
        self.doc_embeddings = self.encoder.encode(self.documents)
    
    def retrieve(self, query, top_k=3):
        query_embedding = self.encoder.encode([query])
        similarities = np.dot(self.doc_embeddings, query_embedding.T).flatten()
        top_indices = np.argsort(similarities)[-top_k:][::-1]
        return [self.documents[i] for i in top_indices]
    
    def answer(self, question):
        relevant_docs = self.retrieve(question)
        context = ' '.join(relevant_docs)
        
        result = self.qa_pipeline(question=question, context=context)
        return {
            'answer': result['answer'],
            'score': result['score'],
            'context': context
        }

# Usage
rag = RAGSystem()
rag.add_documents([
    "Python was created by Guido van Rossum.",
    "Python was first released in 1991.",
    "Python emphasizes code readability."
])
print(rag.answer("When was Python released?"))
```

---

## Chatbots

### Rule-based Chatbot

```python
import re

class RuleBasedChatbot:
    def __init__(self):
        self.patterns = {
            'greeting': {
                'pattern': r'\b(hello|hi|hey|greetings)\b',
                'responses': ['Hello!', 'Hi there!', 'Hey! How can I help?']
            },
            'goodbye': {
                'pattern': r'\b(bye|goodbye|see you|farewell)\b',
                'responses': ['Goodbye!', 'See you later!', 'Take care!']
            },
            'name': {
                'pattern': r'\b(your name|who are you|what are you)\b',
                'responses': ['I am a chatbot.', 'I am your virtual assistant.']
            },
            'help': {
                'pattern': r'\b(help|assist|support)\b',
                'responses': ['I can help you with questions.', 'How can I assist you?']
            }
        }
    
    def get_response(self, user_input):
        user_input = user_input.lower()
        
        for intent, data in self.patterns.items():
            if re.search(data['pattern'], user_input):
                import random
                return random.choice(data['responses'])
        
        return "I'm not sure I understand. Can you rephrase?"

# Usage
chatbot = RuleBasedChatbot()
print(chatbot.get_response("Hello!"))
print(chatbot.get_response("What is your name?"))
```

### Transformer-based Chatbot

```python
from transformers import pipeline

class TransformerChatbot:
    def __init__(self, model_name='microsoft/DialoGPT-medium'):
        self.generator = pipeline('text-generation', model=model_name)
        self.conversation_history = []
    
    def respond(self, user_input):
        self.conversation_history.append(user_input)
        
        # Create prompt from conversation history
        prompt = ' '.join(self.conversation_history[-5:])  # Last 5 exchanges
        
        response = self.generator(
            prompt,
            max_length=100,
            num_return_sequences=1,
            no_repeat_ngram_size=2,
            do_sample=True,
            top_k=50,
            top_p=0.95
        )
        
        bot_response = response[0]['generated_text'].split(user_input)[-1].strip()
        self.conversation_history.append(bot_response)
        
        return bot_response
    
    def clear_history(self):
        self.conversation_history = []

# Usage
chatbot = TransformerChatbot()
print(chatbot.respond("Hello, how are you?"))
```

---

## Text Generation

### GPT-style Generation

```python
from transformers import GPT2LMHeadModel, GPT2Tokenizer

class TextGenerator:
    def __init__(self, model_name='gpt2'):
        self.tokenizer = GPT2Tokenizer.from_pretrained(model_name)
        self.model = GPT2LMHeadModel.from_pretrained(model_name)
    
    def generate(self, prompt, max_length=100, temperature=0.7, top_k=50, top_p=0.9):
        inputs = self.tokenizer.encode(prompt, return_tensors='pt')
        
        outputs = self.model.generate(
            inputs,
            max_length=max_length,
            temperature=temperature,
            top_k=top_k,
            top_p=top_p,
            do_sample=True,
            num_return_sequences=1
        )
        
        return self.tokenizer.decode(outputs[0], skip_special_tokens=True)
    
    def generate_batch(self, prompts, max_length=100):
        inputs = self.tokenizer(prompts, return_tensors='pt', padding=True, truncation=True)
        outputs = self.model.generate(**inputs, max_length=max_length)
        return self.tokenizer.batch_decode(outputs, skip_special_tokens=True)

# Usage
generator = TextGenerator()
print(generator.generate("The future of artificial intelligence is"))
```

### Creative Writing

```python
class CreativeWriter:
    def __init__(self):
        from transformers import pipeline
        self.generator = pipeline('text-generation', model='gpt2-medium')
    
    def write_story(self, prompt, max_length=500):
        return self.generator(
            prompt,
            max_length=max_length,
            temperature=0.8,
            top_p=0.9,
            num_return_sequences=1
        )[0]['generated_text']
    
    def write_poem(self, theme, style='rhyming'):
        prompt = f"Write a {style} poem about {theme}:\n"
        return self.generator(
            prompt,
            max_length=200,
            temperature=0.9
        )[0]['generated_text']

# Usage
writer = CreativeWriter()
print(writer.write_story("Once upon a time in a land far away"))
```

---

## Speech Processing

### Speech-to-Text

```python
import whisper

class SpeechToText:
    def __init__(self, model_size='base'):
        self.model = whisper.load_model(model_size)
    
    def transcribe(self, audio_path):
        result = self.model.transcribe(audio_path)
        return {
            'text': result['text'],
            'language': result['language'],
            'segments': result['segments']
        }
    
    def transcribe_with_timestamps(self, audio_path):
        result = self.model.transcribe(audio_path, word_timestamps=True)
        return result

# Usage
stt = SpeechToText()
# result = stt.transcribe('audio.wav')
# print(result['text'])
```

### Text-to-Speech

```python
from transformers import pipeline

class TextToSpeech:
    def __init__(self):
        self.tts = pipeline('text-to-speech', model='facebook/mms-tts-eng')
    
    def synthesize(self, text):
        return self.tts(text)

# Usage
tts = TextToSpeech()
# audio = tts.synthesize("Hello, this is a test.")
```

---

## Summary

| Application | Key Models | Use Cases |
|-------------|------------|-----------|
| Translation | Seq2Seq, Transformer | Localization, multilingual apps |
| Summarization | BART, T5, GPT | Document summarization, news |
| QA | BERT, RoBERTa | Search, customer support |
| Chatbots | DialoGPT, BlenderBot | Customer service, entertainment |
| Text Generation | GPT, BLOOM | Content creation, coding |
| Speech | Whisper, Wav2Vec | Transcription, voice assistants |
