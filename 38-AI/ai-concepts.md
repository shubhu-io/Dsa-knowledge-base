# AI Core Concepts

## Table of Contents

1. [Intelligence Definitions](#intelligence-definitions)
2. [Problem Types](#problem-types)
3. [Representation](#representation)
4. [Reasoning](#reasoning)
5. [Decision Making](#decision-making)
6. [Learning Types](#learning-types)

---

## Intelligence Definitions

### Strong vs Weak AI

**Weak AI (Narrow AI):**
- Designed for specific tasks
- No consciousness or understanding
- Examples: Chess engines, recommendation systems, virtual assistants

**Strong AI (AGI):**
- General intelligence across domains
- Consciousness and self-awareness
- Human-level reasoning and learning

### Measuring Intelligence

```python
class IntelligenceTest:
    def __init__(self):
        self.metrics = {
            'learning_rate': 0,
            'problem_solving': 0,
            'adaptability': 0,
            'creativity': 0
        }
    
    def evaluate(self, agent, tasks):
        scores = []
        for task in tasks:
            score = agent.solve(task)
            scores.append(score)
        
        self.metrics['problem_solving'] = sum(scores) / len(scores)
        self.metrics['learning_rate'] = self.calculate_learning_rate(scores)
        
        return self.metrics
    
    def calculate_learning_rate(self, scores):
        if len(scores) < 2:
            return 0
        improvements = [scores[i] - scores[i-1] for i in range(1, len(scores))]
        return sum(improvements) / len(improvements)
```

---

## Problem Types

### Classification

```python
from sklearn.ensemble import RandomForestClassifier
from sklearn.datasets import make_classification
from sklearn.model_selection import train_test_split

# Generate sample data
X, y = make_classification(n_samples=1000, n_features=10, random_state=42)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

# Classification model
clf = RandomForestClassifier(n_estimators=100)
clf.fit(X_train, y_train)
accuracy = clf.score(X_test, y_test)
print(f"Classification Accuracy: {accuracy:.2f}")
```

**Problem Types:**
- Binary classification (spam/not spam)
- Multi-class classification (digit recognition)
- Multi-label classification (tagging)

### Regression

```python
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error
import numpy as np

# Sample regression problem
X = np.random.rand(100, 1) * 10
y = 2 * X + 1 + np.random.randn(100, 1) * 0.5

model = LinearRegression()
model.fit(X, y)
predictions = model.predict(X)
mse = mean_squared_error(y, predictions)
print(f"MSE: {mse:.2f}, Coefficient: {model.coef_[0][0]:.2f}")
```

### Clustering

```python
from sklearn.cluster import KMeans
from sklearn.datasets import make_blobs

# Generate clustered data
X, _ = make_blobs(n_samples=300, centers=4, random_state=42)

kmeans = KMeans(n_clusters=4, random_state=42)
labels = kmeans.fit_predict(X)
centroids = kmeans.cluster_centers_

print(f"Cluster Centers:\n{centroids}")
```

### Optimization

```python
import numpy as np

def genetic_algorithm(population_size, generations, fitness_func):
    population = np.random.rand(population_size, 10)
    
    for gen in range(generations):
        fitness = np.array([fitness_func(ind) for ind in population])
        
        # Selection
        elite_idx = fitness.argsort()[-population_size//2:]
        elites = population[elite_idx]
        
        # Crossover and mutation
        new_population = []
        while len(new_population) < population_size:
            parent1, parent2 = elites[np.random.choice(len(elites), 2, replace=False)]
            crossover_point = np.random.randint(0, 10)
            child = np.concatenate([parent1[:crossover_point], parent2[crossover_point:]])
            
            if np.random.random() < 0.1:  # Mutation
                mutation_idx = np.random.randint(0, 10)
                child[mutation_idx] = np.random.random()
            
            new_population.append(child)
        
        population = np.array(new_population)
    
    return population[np.argmax([fitness_func(ind) for ind in population])]
```

---

## Representation

### Knowledge Representation Schemes

```python
class KnowledgeRepresentation:
    def __init__(self):
        self.frames = {}
        self.rules = []
        self.semantic_net = {}
    
    def create_frame(self, name, slots):
        self.frames[name] = {
            'slots': slots,
            'values': {},
            'inheritance': []
        }
    
    def add_rule(self, IF_conditions, THEN_action):
        self.rules.append({
            'IF': IF_conditions,
            'THEN': THEN_action,
            'strength': 1.0
        })
    
    def infer(self, facts):
        conclusions = []
        for rule in self.rules:
            if all(condition(facts) for condition in rule['IF']):
                conclusions.append(rule['THEN'])
        return conclusions
```

### Frame-Based Representation

```python
class Frame:
    def __init__(self, name):
        self.name = name
        self.slots = {}
    
    def add_slot(self, slot_name, value, type='default'):
        self.slots[slot_name] = {
            'value': value,
            'type': type,
            'constraints': []
        }
    
    def add_constraint(self, slot_name, constraint):
        if slot_name in self.slots:
            self.slots[slot_name]['constraints'].append(constraint)
    
    def fill_slot(self, slot_name, value):
        if slot_name in self.slots:
            for constraint in self.slots[slot_name]['constraints']:
                if not constraint(value):
                    raise ValueError(f"Constraint violated for {slot_name}")
            self.slots[slot_name]['value'] = value
```

### Semantic Network

```python
class SemanticNetwork:
    def __init__(self):
        self.nodes = {}
        self.edges = []
    
    def add_node(self, name, attributes=None):
        self.nodes[name] = attributes or {}
    
    def add_edge(self, from_node, to_node, relation):
        self.edges.append((from_node, to_node, relation))
    
    def is_a(self, child, parent):
        for from_node, to_node, relation in self.edges:
            if from_node == child and to_node == parent and relation == 'is_a':
                return True
            if from_node == child and relation == 'is_a':
                return self.is_a(to_node, parent)
        return False
```

---

## Reasoning

### Deductive Reasoning

```python
class DeductiveReasoner:
    def __init__(self, axioms):
        self.axioms = axioms
        self.known_facts = set(axioms)
    
    def apply_rule(self, rule):
        premises, conclusion = rule
        if all(p in self.known_facts for p in premises):
            self.known_facts.add(conclusion)
            return True
        return False
    
    def forward_chain(self, rules):
        new_facts = True
        while new_facts:
            new_facts = False
            for rule in rules:
                if self.apply_rule(rule):
                    new_facts = True
```

### Inductive Reasoning

```python
def inductive_generalization(specific_cases):
    patterns = {}
    for case in specific_cases:
        for attribute, value in case.items():
            if attribute not in patterns:
                patterns[attribute] = set()
            patterns[attribute].add(value)
    
    # Find common patterns
    common_patterns = {}
    for attr, values in patterns.items():
        if len(values) == 1:
            common_patterns[attr] = values.pop()
    
    return common_patterns

# Example
cases = [
    {'color': 'red', 'shape': 'circle', 'size': 'large'},
    {'color': 'red', 'shape': 'circle', 'size': 'small'},
    {'color': 'red', 'shape': 'circle', 'size': 'medium'}
]

pattern = inductive_generalization(cases)
print(f"Induced Pattern: {pattern}")  # {'color': 'red', 'shape': 'circle'}
```

### Abductive Reasoning

```python
class AbductiveReasoner:
    def __init__(self, hypotheses):
        self.hypotheses = hypotheses
    
    def find_best_explanation(self, observation, likelihoods):
        scores = {}
        for hypothesis in self.hypotheses:
            score = likelihoods.get((observation, hypothesis), 0)
            prior = self.prior_probability(hypothesis)
            scores[hypothesis] = score * prior
        
        return max(scores.items(), key=lambda x: x[1])
    
    def prior_probability(self, hypothesis):
        # Simplified - would use actual probability distribution
        return 1.0 / len(self.hypotheses)
```

---

## Decision Making

### Decision Trees

```python
class DecisionNode:
    def __init__(self, feature=None, threshold=None, left=None, right=None, value=None):
        self.feature = feature
        self.threshold = threshold
        self.left = left
        self.right = right
        self.value = value

def build_decision_tree(X, y, depth=0, max_depth=5):
    if depth >= max_depth or len(set(y)) == 1:
        return DecisionNode(value=max(set(y), key=list(y).count))
    
    best_feature, best_threshold = find_best_split(X, y)
    
    left_mask = X[:, best_feature] <= best_threshold
    right_mask = ~left_mask
    
    left = build_decision_tree(X[left_mask], y[left_mask], depth + 1, max_depth)
    right = build_decision_tree(X[right_mask], y[right_mask], depth + 1, max_depth)
    
    return DecisionNode(best_feature, best_threshold, left, right)

def find_best_split(X, y):
    best_gini = float('inf')
    best_feature, best_threshold = None, None
    
    for feature in range(X.shape[1]):
        thresholds = np.unique(X[:, feature])
        for threshold in thresholds:
            left_mask = X[:, feature] <= threshold
            right_mask = ~left_mask
            
            if sum(left_mask) == 0 or sum(right_mask) == 0:
                continue
            
            gini = calculate_gini(y[left_mask], y[right_mask])
            if gini < best_gini:
                best_gini = gini
                best_feature = feature
                best_threshold = threshold
    
    return best_feature, best_threshold
```

### Utility Theory

```python
class UtilityFunction:
    def __init__(self):
        self.utilities = {}
    
    def set_utility(self, state, utility):
        self.utilities[state] = utility
    
    def expected_utility(self, action, outcomes):
        total = 0
        for outcome, probability in outcomes:
            utility = self.utilities.get(outcome, 0)
            total += probability * utility
        return total
    
    def choose_action(self, actions):
        best_action = None
        best_utility = float('-inf')
        
        for action in actions:
            utility = self.expected_utility(action, action.outcomes)
            if utility > best_utility:
                best_utility = utility
                best_action = action
        
        return best_action
```

---

## Learning Types

### Supervised Learning

```python
class SupervisedLearner:
    def __init__(self, model):
        self.model = model
        self.training_data = []
    
    def add_example(self, features, label):
        self.training_data.append((features, label))
    
    def train(self):
        X = [x[0] for x in self.training_data]
        y = [x[1] for x in self.training_data]
        self.model.fit(X, y)
    
    def predict(self, features):
        return self.model.predict([features])[0]
```

### Unsupervised Learning

```python
class UnsupervisedLearner:
    def __init__(self, model):
        self.model = model
    
    def fit(self, data):
        self.model.fit(data)
    
    def predict(self, data):
        return self.model.predict(data)
    
    def get_clusters(self, data):
        labels = self.predict(data)
        clusters = {}
        for i, label in enumerate(labels):
            if label not in clusters:
                clusters[label] = []
            clusters[label].append(data[i])
        return clusters
```

### Semi-Supervised Learning

```python
class SemiSupervisedLearner:
    def __init__(self, labeled_data, unlabeled_data):
        self.labeled_data = labeled_data
        self.unlabeled_data = unlabeled_data
    
    def self_training(self, classifier, threshold=0.9):
        classifier.fit([x[0] for x in self.labeled_data], 
                      [x[1] for x in self.labeled_data])
        
        while self.unlabeled_data:
            predictions = classifier.predict_proba([x[0] for x in self.unlabeled_data])
            
            confident = [(i, pred) for i, pred in enumerate(predictions) 
                        if max(pred) > threshold]
            
            if not confident:
                break
            
            for idx, pred in confident:
                self.labeled_data.append((self.unlabeled_data[idx], np.argmax(pred)))
                del self.unlabeled_data[idx]
            
            classifier.fit([x[0] for x in self.labeled_data], 
                          [x[1] for x in self.labeled_data])
        
        return classifier
```

---

## Summary Table

| Concept | Description | Use Case |
|---------|-------------|----------|
| Classification | Assign categories | Spam detection |
| Regression | Predict continuous values | Price prediction |
| Clustering | Group similar items | Customer segmentation |
| Optimization | Find best solution | Resource allocation |
| Reasoning | Draw conclusions | Expert systems |
| Planning | Achieve goals | Robotics |
| Learning | Improve from data | All ML applications |
