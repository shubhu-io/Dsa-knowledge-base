# AI Interview Questions

## Table of Contents

1. [Conceptual Questions](#conceptual-questions)
2. [Algorithm Questions](#algorithm-questions)
3. [Coding Questions](#coding-questions)
4. [System Design](#system-design)
5. [Ethics and Safety](#ethics-and-safety)
6. [Advanced Topics](#advanced-topics)

---

## Conceptual Questions

### 1. What is Artificial Intelligence?

**Answer:**
AI is the simulation of human intelligence by machines. It encompasses:
- **Perception**: Understanding sensory input
- **Reasoning**: Drawing conclusions from data
- **Learning**: Improving from experience
- **Language**: Understanding and generating text
- **Planning**: Achieving goals through action sequences

### 2. Difference between AI, ML, and Deep Learning?

```
AI (Artificial Intelligence)
├── ML (Machine Learning)
│   ├── Supervised Learning
│   ├── Unsupervised Learning
│   └── Reinforcement Learning
└── DL (Deep Learning)
    ├── CNNs
    ├── RNNs
    └── Transformers
```

- **AI**: Broad field of creating intelligent systems
- **ML**: Subset of AI that learns from data
- **DL**: Subset of ML using neural networks with multiple layers

### 3. What are the types of Machine Learning?

| Type | Description | Example |
|------|-------------|---------|
| Supervised | Labeled training data | Spam detection |
| Unsupervised | No labels, find patterns | Customer segmentation |
| Semi-supervised | Mix of labeled and unlabeled | Medical image analysis |
| Reinforcement | Learning through rewards | Game playing |

### 4. Explain the Bias-Variance Tradeoff

```python
import numpy as np
from sklearn.model_selection import cross_val_score
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import PolynomialFeatures

def bias_variance_analysis(X, y, degrees):
    results = []
    for degree in degrees:
        poly = PolynomialFeatures(degree)
        X_poly = poly.fit_transform(X)
        
        model = LinearRegression()
        scores = cross_val_score(model, X_poly, y, cv=5, scoring='neg_mean_squared_error')
        
        bias = -np.mean(scores)
        variance = np.var(scores)
        results.append((degree, bias, variance))
    
    return results
```

**Tradeoff:**
- High bias → Underfitting (too simple model)
- High variance → Overfitting (too complex model)
- Goal: Find the sweet spot

### 5. What is Overfitting and How to Prevent It?

**Overfitting:** Model performs well on training data but poorly on new data.

**Prevention techniques:**
1. Cross-validation
2. Regularization (L1/L2)
3. Dropout
4. Early stopping
5. Data augmentation
6. Feature selection

---

## Algorithm Questions

### 1. Implement A* Search

```python
import heapq

def a_star(graph, start, goal, heuristic):
    """
    A* search algorithm.
    
    Args:
        graph: Dict of node -> {neighbor: cost}
        start: Start node
        goal: Goal node
        heuristic: Function estimating cost to goal
    
    Returns:
        Tuple of (path, total_cost) or (None, float('inf'))
    """
    open_set = [(0, start)]
    came_from = {}
    g_score = {start: 0}
    f_score = {start: heuristic(start, goal)}
    
    while open_set:
        _, current = heapq.heappop(open_set)
        
        if current == goal:
            return reconstruct_path(came_from, current), g_score[current]
        
        for neighbor, cost in graph[current].items():
            tentative_g = g_score[current] + cost
            
            if tentative_g < g_score.get(neighbor, float('inf')):
                came_from[neighbor] = current
                g_score[neighbor] = tentative_g
                f_score[neighbor] = tentative_g + heuristic(neighbor, goal)
                heapq.heappush(open_set, (f_score[neighbor], neighbor))
    
    return None, float('inf')

def reconstruct_path(came_from, current):
    path = [current]
    while current in came_from:
        current = came_from[current]
        path.append(current)
    return path[::-1]

# Example
graph = {
    'A': {'B': 1, 'C': 3},
    'B': {'A': 1, 'D': 1, 'E': 5},
    'C': {'A': 3, 'F': 2},
    'D': {'B': 1},
    'E': {'B': 5, 'F': 1},
    'F': {'C': 2, 'E': 1}
}

path, cost = a_star(graph, 'A', 'F', lambda n, g: 0)
print(f"Path: {path}, Cost: {cost}")
```

### 2. Implement Minimax with Alpha-Beta Pruning

```python
def minimax_alpha_beta(state, depth, alpha, beta, maximizing, game):
    if depth == 0 or game.is_terminal(state):
        return game.evaluate(state)
    
    if maximizing:
        value = float('-inf')
        for action in game.get_actions(state):
            child = game.apply_action(state, action)
            value = max(value, minimax_alpha_beta(child, depth-1, alpha, beta, False, game))
            alpha = max(alpha, value)
            if alpha >= beta:
                break
        return value
    else:
        value = float('inf')
        for action in game.get_actions(state):
            child = game.apply_action(state, action)
            value = min(value, minimax_alpha_beta(child, depth-1, alpha, beta, True, game))
            beta = min(beta, value)
            if alpha >= beta:
                break
        return value
```

### 3. Implement a Genetic Algorithm

```python
import random
import numpy as np

def genetic_algorithm(fitness_func, n_genes=10, pop_size=100, generations=100):
    # Initialize population
    population = [np.random.rand(n_genes) for _ in range(pop_size)]
    
    for gen in range(generations):
        # Evaluate fitness
        fitness = [fitness_func(ind) for ind in population]
        
        # Selection (tournament)
        new_pop = []
        for _ in range(pop_size):
            tournament = random.sample(list(zip(population, fitness)), 3)
            winner = max(tournament, key=lambda x: x[1])[0]
            new_pop.append(winner)
        
        # Crossover
        offspring = []
        for i in range(0, pop_size, 2):
            p1, p2 = new_pop[i], new_pop[i+1]
            point = random.randint(1, n_genes-1)
            child1 = np.concatenate([p1[:point], p2[point:]])
            child2 = np.concatenate([p2[:point], p1[point:]])
            offspring.extend([child1, child2])
        
        # Mutation
        for ind in offspring:
            if random.random() < 0.1:  # 10% mutation rate
                idx = random.randint(0, n_genes-1)
                ind[idx] += random.gauss(0, 0.1)
        
        population = offspring
    
    # Return best
    fitness = [fitness_func(ind) for ind in population]
    return population[np.argmax(fitness)]
```

---

## Coding Questions

### 1. Breadth-First Search Implementation

```python
from collections import deque

def bfs(graph, start, goal):
    """
    BFS to find shortest path in unweighted graph.
    Time: O(V + E), Space: O(V)
    """
    if start == goal:
        return [start]
    
    queue = deque([(start, [start])])
    visited = {start}
    
    while queue:
        node, path = queue.popleft()
        
        for neighbor in graph[node]:
            if neighbor == goal:
                return path + [neighbor]
            
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append((neighbor, path + [neighbor]))
    
    return None

# Test
graph = {
    'A': ['B', 'C'],
    'B': ['A', 'D', 'E'],
    'C': ['A', 'F'],
    'D': ['B'],
    'E': ['B', 'F'],
    'F': ['C', 'E']
}
print(bfs(graph, 'A', 'F'))  # ['A', 'C', 'F']
```

### 2. Constraint Satisfaction Problem

```python
class CSP:
    def __init__(self, variables, domains, constraints):
        self.variables = variables
        self.domains = {v: list(d) for v, d in domains.items()}
        self.constraints = constraints
    
    def is_consistent(self, var, value, assignment):
        for other_var, other_val in assignment.items():
            if (var, other_var) in self.constraints:
                if not self.constraints[(var, other_var)](value, other_val):
                    return False
            if (other_var, var) in self.constraints:
                if not self.constraints[(other_var, var)](other_val, value):
                    return False
        return True
    
    def backtracking(self, assignment={}):
        if len(assignment) == len(self.variables):
            return assignment
        
        var = self.select_unassigned(assignment)
        for value in self.domains[var]:
            if self.is_consistent(var, value, assignment):
                assignment[var] = value
                result = self.backtracking(assignment)
                if result:
                    return result
                del assignment[var]
        return None
    
    def select_unassigned(self, assignment):
        # MRV heuristic
        unassigned = [v for v in self.variables if v not in assignment]
        return min(unassigned, key=lambda v: len([d for d in self.domains[v] 
                                                   if self.is_consistent(v, d, assignment)]))
```

### 3. Implement Q-Learning

```python
import numpy as np
import random

class QLearningAgent:
    def __init__(self, state_size, action_size, lr=0.1, gamma=0.99, epsilon=0.1):
        self.q_table = np.zeros((state_size, action_size))
        self.lr = lr
        self.gamma = gamma
        self.epsilon = epsilon
        self.action_size = action_size
    
    def choose_action(self, state):
        if random.random() < self.epsilon:
            return random.randint(0, self.action_size - 1)
        return np.argmax(self.q_table[state])
    
    def update(self, state, action, reward, next_state, done):
        if done:
            target = reward
        else:
            target = reward + self.gamma * np.max(self.q_table[next_state])
        
        self.q_table[state, action] += self.lr * (target - self.q_table[state, action])
    
    def train(self, env, episodes=1000):
        for episode in range(episodes):
            state = env.reset()
            total_reward = 0
            
            while True:
                action = self.choose_action(state)
                next_state, reward, done, _ = env.step(action)
                self.update(state, action, reward, next_state, done)
                
                state = next_state
                total_reward += reward
                
                if done:
                    break
            
            if episode % 100 == 0:
                print(f"Episode {episode}, Reward: {total_reward}")
```

---

## System Design

### 1. Design a Recommendation System

**Components:**
```
┌─────────────────┐
│   User Service  │
├─────────────────┤
│ • User profiles │
│ • Preferences   │
│ • History       │
└────────┬────────┘
         │
┌────────▼────────┐
│  Data Pipeline  │
├─────────────────┤
│ • Event logging │
│ • Feature store │
│ • Model training│
└────────┬────────┘
         │
┌────────▼────────┐
│  ML Models      │
├─────────────────┤
│ • Collaborative │
│ • Content-based │
│ • Hybrid        │
└────────┬────────┘
         │
┌────────▼────────┐
│  Serving Layer  │
├─────────────────┤
│ • API Gateway   │
│ • Model serving │
│ • Caching       │
└─────────────────┘
```

**Implementation considerations:**
- Cold start problem
- Scalability (billions of items)
- Real-time vs batch recommendations
- A/B testing framework

### 2. Design a Fraud Detection System

**Key components:**
1. **Feature engineering**: Transaction patterns, user behavior
2. **Model training**: Ensemble methods, anomaly detection
3. **Real-time scoring**: Low latency predictions
4. **Alert system**: Threshold-based notifications
5. **Feedback loop**: Analyst reviews improve model

---

## Ethics and Safety

### 1. What is Algorithmic Bias?

**Answer:**
Systematic and repeatable errors in computer systems creating unfair outcomes.

**Sources:**
- Biased training data
- Proxy variables for protected attributes
- Feedback loops amplifying bias

**Mitigation:**
- Diverse and representative data
- Fairness metrics (demographic parity, equalized odds)
- Regular auditing
- Bias-aware algorithms

### 2. Explain AI Explainability

**Importance:**
- Trust and transparency
- Regulatory compliance
- Debugging and improvement
- Ethical accountability

**Methods:**
- LIME (Local Interpretable Model-agnostic Explanations)
- SHAP (SHapley Additive exPlanations)
- Attention visualization
- Decision tree approximations

---

## Advanced Topics

### 1. What is Transfer Learning?

**Answer:**
Using knowledge from one task to improve performance on a related task.

```python
# Example: Transfer learning with ResNet
import torch
import torch.nn as nn
from torchvision import models

def create_transfer_model(num_classes):
    # Load pre-trained ResNet
    model = models.resnet50(pretrained=True)
    
    # Freeze early layers
    for param in list(model.parameters())[:-10]:
        param.requires_grad = False
    
    # Replace final layer
    num_features = model.fc.in_features
    model.fc = nn.Linear(num_features, num_classes)
    
    return model
```

### 2. What is Few-Shot Learning?

**Answer:**
Learning from very few labeled examples per class.

**Approaches:**
- Siamese networks
- Prototypical networks
- MAML (Model-Agnostic Meta-Learning)

### 3. What is Neural Architecture Search (NAS)?

**Answer:**
Automated design of neural network architectures.

**Methods:**
- Reinforcement learning-based
- Evolutionary algorithms
- Differentiable architecture search (DARTS)

---

## Quick Reference

| Concept | Key Point |
|---------|-----------|
| A* Search | Optimal, uses heuristic |
| Minimax | Game tree search |
| Alpha-Beta | Prunes minimax tree |
| Genetic Algorithm | Evolutionary optimization |
| Q-Learning | Model-free reinforcement learning |
| CSP | Backtracking with constraints |
| BFS/DFS | Graph traversal |
| MCTS | Simulation-based search |
