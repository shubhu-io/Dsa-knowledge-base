# AI Algorithms

## Table of Contents

1. [Search Algorithms](#search-algorithms)
2. [Graph Algorithms](#graph-algorithms)
3. [Optimization Algorithms](#optimization-algorithms)
4. [Probabilistic Algorithms](#probabilistic-algorithms)
5. [Game Theory](#game-theory)
6. [Planning Algorithms](#planning-algorithms)

---

## Search Algorithms

### Uninformed Search

#### Breadth-First Search (BFS)

```python
from collections import deque

def bfs(graph, start, goal):
    queue = deque([(start, [start])])
    visited = set()
    
    while queue:
        node, path = queue.popleft()
        
        if node == goal:
            return path
        
        if node not in visited:
            visited.add(node)
            for neighbor in graph[node]:
                queue.append((neighbor, path + [neighbor]))
    
    return None

# Example usage
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

#### Depth-First Search (DFS)

```python
def dfs(graph, start, goal, visited=None):
    if visited is None:
        visited = set()
    
    if start == goal:
        return [start]
    
    visited.add(start)
    for neighbor in graph[start]:
        if neighbor not in visited:
            path = dfs(graph, neighbor, goal, visited.copy())
            if path:
                return [start] + path
    
    return None

# Iterative DFS
def dfs_iterative(graph, start, goal):
    stack = [(start, [start])]
    visited = set()
    
    while stack:
        node, path = stack.pop()
        
        if node == goal:
            return path
        
        if node not in visited:
            visited.add(node)
            for neighbor in graph[node]:
                stack.append((neighbor, path + [neighbor]))
    
    return None
```

#### Uniform Cost Search

```python
import heapq

def uniform_cost_search(graph, start, goal, cost_func):
    priority_queue = [(0, start, [start])]
    visited = set()
    
    while priority_queue:
        cost, node, path = heapq.heappop(priority_queue)
        
        if node == goal:
            return path, cost
        
        if node not in visited:
            visited.add(node)
            for neighbor in graph[node]:
                new_cost = cost + cost_func(node, neighbor)
                heapq.heappush(priority_queue, (new_cost, neighbor, path + [neighbor]))
    
    return None, float('inf')
```

### Informed Search

#### A* Algorithm

```python
import heapq

def a_star(graph, start, goal, heuristic):
    priority_queue = [(0 + heuristic(start, goal), 0, start, [start])]
    visited = set()
    g_scores = {start: 0}
    
    while priority_queue:
        f_score, g_score, node, path = heapq.heappop(priority_queue)
        
        if node == goal:
            return path, g_score
        
        if node not in visited:
            visited.add(node)
            for neighbor in graph[node]:
                new_g_score = g_score + graph[node][neighbor]
                
                if neighbor not in g_scores or new_g_score < g_scores[neighbor]:
                    g_scores[neighbor] = new_g_score
                    f_score = new_g_score + heuristic(neighbor, goal)
                    heapq.heappush(priority_queue, (f_score, new_g_score, neighbor, path + [neighbor]))
    
    return None, float('inf')

def manhattan_distance(node, goal):
    return abs(node[0] - goal[0]) + abs(node[1] - goal[1])
```

#### Greedy Best-First Search

```python
def greedy_best_first(graph, start, goal, heuristic):
    priority_queue = [(heuristic(start, goal), start, [start])]
    visited = set()
    
    while priority_queue:
        _, node, path = heapq.heappop(priority_queue)
        
        if node == goal:
            return path
        
        if node not in visited:
            visited.add(node)
            for neighbor in graph[node]:
                h = heuristic(neighbor, goal)
                heapq.heappush(priority_queue, (h, neighbor, path + [neighbor]))
    
    return None
```

---

## Graph Algorithms

### Minimax

```python
def minimax(node, depth, maximizing_player, get_children, evaluate, is_terminal):
    if depth == 0 or is_terminal(node):
        return evaluate(node)
    
    if maximizing_player:
        value = float('-inf')
        for child in get_children(node):
            value = max(value, minimax(child, depth-1, False, get_children, evaluate, is_terminal))
        return value
    else:
        value = float('inf')
        for child in get_children(node):
            value = min(value, minimax(child, depth-1, True, get_children, evaluate, is_terminal))
        return value
```

### Alpha-Beta Pruning

```python
def alpha_beta(node, depth, alpha, beta, maximizing_player, get_children, evaluate, is_terminal):
    if depth == 0 or is_terminal(node):
        return evaluate(node)
    
    if maximizing_player:
        value = float('-inf')
        for child in get_children(node):
            value = max(value, alpha_beta(child, depth-1, alpha, beta, False, get_children, evaluate, is_terminal))
            alpha = max(alpha, value)
            if alpha >= beta:
                break  # Beta cutoff
        return value
    else:
        value = float('inf')
        for child in get_children(node):
            value = min(value, alpha_beta(child, depth-1, alpha, beta, True, get_children, evaluate, is_terminal))
            beta = min(beta, value)
            if alpha >= beta:
                break  # Alpha cutoff
        return value
```

### Monte Carlo Tree Search (MCTS)

```python
import random
import math

class MCTSNode:
    def __init__(self, state, parent=None, action=None):
        self.state = state
        self.parent = parent
        self.action = action
        self.children = []
        self.wins = 0
        self.visits = 0
        self.untried_actions = get_legal_actions(state)
    
    def uct_value(self, exploration=1.41):
        if self.visits == 0:
            return float('inf')
        return (self.wins / self.visits) + exploration * math.sqrt(math.log(self.parent.visits) / self.visits)
    
    def best_child(self):
        return max(self.children, key=lambda c: c.uct_value())

def mcts(state, iterations=1000):
    root = MCTSNode(state)
    
    for _ in range(iterations):
        node = root
        
        # Selection
        while node.untried_actions == [] and node.children != []:
            node = node.best_child()
        
        # Expansion
        if node.untried_actions:
            action = random.choice(node.untried_actions)
            next_state = simulate(node.state, action)
            node = MCTSNode(next_state, parent=node, action=action)
        
        # Simulation
        result = simulate_game(node.state)
        
        # Backpropagation
        while node is not None:
            node.visits += 1
            node.wins += result
            node = node.parent
    
    return root.best_child()
```

---

## Optimization Algorithms

### Genetic Algorithm

```python
import random
import numpy as np

class GeneticAlgorithm:
    def __init__(self, fitness_func, population_size=100, genes=10):
        self.fitness_func = fitness_func
        self.population_size = population_size
        self.genes = genes
        self.population = self.initialize_population()
    
    def initialize_population(self):
        return [np.random.rand(self.genes) for _ in range(self.population_size)]
    
    def evaluate_population(self):
        return [self.fitness_func(ind) for ind in self.population]
    
    def selection(self, fitness_scores):
        total = sum(fitness_scores)
        probabilities = [f/total for f in fitness_scores]
        indices = np.random.choice(self.population_size, self.population_size, p=probabilities)
        return [self.population[i] for i in indices]
    
    def crossover(self, parent1, parent2):
        point = random.randint(1, self.genes-1)
        child = np.concatenate([parent1[:point], parent2[point:]])
        return child
    
    def mutate(self, individual, mutation_rate=0.1):
        for i in range(self.genes):
            if random.random() < mutation_rate:
                individual[i] += random.gauss(0, 0.1)
        return individual
    
    def evolve(self, generations=100):
        for gen in range(generations):
            fitness = self.evaluate_population()
            self.population = self.selection(fitness)
            
            new_population = []
            while len(new_population) < self.population_size:
                parent1, parent2 = random.sample(self.population, 2)
                child = self.crossover(parent1, parent2)
                child = self.mutate(child)
                new_population.append(child)
            
            self.population = new_population
        
        fitness = self.evaluate_population()
        return self.population[np.argmax(fitness)]
```

### Simulated Annealing

```python
import random
import math

class SimulatedAnnealing:
    def __init__(self, objective_func, initial_temp=1000, cooling_rate=0.95):
        self.objective = objective_func
        self.temp = initial_temp
        self.cooling_rate = cooling_rate
    
    def get_neighbor(self, solution):
        neighbor = solution.copy()
        idx = random.randint(0, len(neighbor)-1)
        neighbor[idx] += random.gauss(0, 0.1)
        return neighbor
    
    def accept_probability(self, current_cost, neighbor_cost):
        if neighbor_cost < current_cost:
            return 1.0
        return math.exp((current_cost - neighbor_cost) / self.temp)
    
    def optimize(self, initial_solution, iterations=10000):
        current = initial_solution
        current_cost = self.objective(current)
        best = current
        best_cost = current_cost
        
        for _ in range(iterations):
            neighbor = self.get_neighbor(current)
            neighbor_cost = self.objective(neighbor)
            
            if random.random() < self.accept_probability(current_cost, neighbor_cost):
                current = neighbor
                current_cost = neighbor_cost
                
                if current_cost < best_cost:
                    best = current
                    best_cost = current_cost
            
            self.temp *= self.cooling_rate
        
        return best, best_cost
```

### Particle Swarm Optimization

```python
import numpy as np

class ParticleSwarmOptimization:
    def __init__(self, objective_func, n_particles=30, dimensions=10):
        self.objective = objective_func
        self.n_particles = n_particles
        self.dimensions = dimensions
        
        self.positions = np.random.rand(n_particles, dimensions)
        self.velocities = np.random.rand(n_particles, dimensions) * 0.1
        
        self.personal_best_pos = self.positions.copy()
        self.personal_best_fit = np.array([self.objective(p) for p in self.positions])
        
        self.global_best_pos = self.positions[np.argmin(self.personal_best_fit)]
        self.global_best_fit = np.min(self.personal_best_fit)
    
    def update(self, w=0.5, c1=1.5, c2=1.5):
        r1 = np.random.rand(self.n_particles, self.dimensions)
        r2 = np.random.rand(self.n_particles, self.dimensions)
        
        cognitive = c1 * r1 * (self.personal_best_pos - self.positions)
        social = c2 * r2 * (self.global_best_pos - self.positions)
        
        self.velocities = w * self.velocities + cognitive + social
        self.positions += self.velocities
        
        for i in range(self.n_particles):
            fit = self.objective(self.positions[i])
            if fit < self.personal_best_fit[i]:
                self.personal_best_pos[i] = self.positions[i].copy()
                self.personal_best_fit[i] = fit
                
                if fit < self.global_best_fit:
                    self.global_best_pos = self.positions[i].copy()
                    self.global_best_fit = fit
    
    def optimize(self, iterations=100):
        for _ in range(iterations):
            self.update()
        return self.global_best_pos, self.global_best_fit
```

---

## Probabilistic Algorithms

### Bayesian Inference

```python
import numpy as np
from scipy import stats

class BayesianInference:
    def __init__(self, prior, likelihood):
        self.prior = prior
        self.likelihood = likelihood
    
    def update(self, evidence):
        posterior = self.prior * self.likelihood(evidence)
        posterior /= np.sum(posterior)
        self.prior = posterior
        return posterior
    
    def predict(self, x):
        return np.sum(self.prior * self.likelihood(x))
```

### Hidden Markov Models

```python
import numpy as np

class HiddenMarkovModel:
    def __init__(self, states, observations):
        self.states = states
        self.observations = observations
        self.n_states = len(states)
        self.n_obs = len(observations)
        
        self.start_prob = np.zeros(self.n_states)
        self.trans_prob = np.zeros((self.n_states, self.n_states))
        self.emit_prob = np.zeros((self.n_states, self.n_obs))
    
    def forward(self, obs_seq):
        T = len(obs_seq)
        alpha = np.zeros((T, self.n_states))
        
        # Initialization
        obs_idx = self.observations.index(obs_seq[0])
        alpha[0] = self.start_prob * self.emit_prob[:, obs_idx]
        
        # Induction
        for t in range(1, T):
            obs_idx = self.observations.index(obs_seq[t])
            for j in range(self.n_states):
                alpha[t, j] = np.sum(alpha[t-1] * self.trans_prob[:, j]) * self.emit_prob[j, obs_idx]
        
        return alpha
    
    def viterbi(self, obs_seq):
        T = len(obs_seq)
        delta = np.zeros((T, self.n_states))
        psi = np.zeros((T, self.n_states), dtype=int)
        
        obs_idx = self.observations.index(obs_seq[0])
        delta[0] = self.start_prob * self.emit_prob[:, obs_idx]
        
        for t in range(1, T):
            obs_idx = self.observations.index(obs_seq[t])
            for j in range(self.n_states):
                delta[t, j] = np.max(delta[t-1] * self.trans_prob[:, j]) * self.emit_prob[j, obs_idx]
                psi[t, j] = np.argmax(delta[t-1] * self.trans_prob[:, j])
        
        # Backtracking
        states = np.zeros(T, dtype=int)
        states[T-1] = np.argmax(delta[T-1])
        for t in range(T-2, -1, -1):
            states[t] = psi[t+1, states[t+1]]
        
        return [self.states[s] for s in states]
```

---

## Game Theory

### Nash Equilibrium Finder

```python
import numpy as np
from scipy.optimize import linprog

def find_nash_equilibrium(payoff_matrix):
    n_strategies = payoff_matrix.shape[0]
    
    # Linear programming formulation
    c = np.zeros(n_strategies + 1)
    c[-1] = -1  # Maximize minimum payoff
    
    A_ub = np.hstack([-payoff_matrix.T, np.ones((n_strategies, 1))])
    b_ub = np.zeros(n_strategies)
    
    A_eq = np.ones((1, n_strategies + 1))
    A_eq[0, -1] = 0
    b_eq = [1]
    
    bounds = [(0, None)] * n_strategies + [(None, None)]
    
    result = linprog(c, A_ub=A_ub, b_ub=b_ub, A_eq=A_eq, b_eq=b_eq, bounds=bounds)
    
    return result.x[:n_strategies], -result.fun
```

---

## Planning Algorithms

### STRIPS Planner

```python
class STRIPSPlanner:
    def __init__(self):
        self.actions = []
        self.initial_state = set()
        self.goal_state = set()
    
    def add_action(self, name, preconditions, add_effects, del_effects):
        self.actions.append({
            'name': name,
            'preconditions': set(preconditions),
            'add': set(add_effects),
            'del': set(del_effects)
        })
    
    def is_applicable(self, action, state):
        return action['preconditions'].issubset(state)
    
    def apply_action(self, action, state):
        if not self.is_applicable(action, state):
            return None
        return (state - action['del']) | action['add']
    
    def forward_search(self):
        frontier = [(self.initial_state, [])]
        visited = set()
        
        while frontier:
            state, plan = frontier.pop(0)
            
            if self.goal_state.issubset(state):
                return plan
            
            state_key = frozenset(state)
            if state_key in visited:
                continue
            visited.add(state_key)
            
            for action in self.actions:
                if self.is_applicable(action, state):
                    new_state = self.apply_action(action, state)
                    frontier.append((new_state, plan + [action['name']]))
        
        return None
```

### Hierarchical Task Network (HTN)

```python
class HTNPlanner:
    def __init__(self):
        self.methods = {}
        self.primitive_actions = {}
    
    def add_method(self, task, subtasks):
        if task not in self.methods:
            self.methods[task] = []
        self.methods[task].append(subtasks)
    
    def add_primitive_action(self, name, preconditions, effects):
        self.primitive_actions[name] = {
            'preconditions': preconditions,
            'effects': effects
        }
    
    def decompose(self, task, state):
        if task in self.primitive_actions:
            return [task]
        
        if task not in self.methods:
            return None
        
        for method in self.methods[task]:
            plan = []
            current_state = state.copy()
            valid = True
            
            for subtask in method:
                subplan = self.decompose(subtask, current_state)
                if subplan is None:
                    valid = False
                    break
                plan.extend(subplan)
                
                for action in subplan:
                    effects = self.primitive_actions[action]['effects']
                    current_state = current_state.union(effects)
            
            if valid:
                return plan
        
        return None
```

---

## Summary Table

| Algorithm | Type | Use Case |
|-----------|------|----------|
| BFS | Uninformed Search | Shortest path |
| DFS | Uninformed Search | Maze solving |
| A* | Informed Search | Pathfinding |
| Minimax | Game Theory | Game AI |
| Alpha-Beta | Game Theory | Game optimization |
| Genetic Algorithm | Optimization | Combinatorial problems |
| Simulated Annealing | Optimization | Continuous optimization |
| MCTS | Search | Game playing |
| Viterbi | Probabilistic | Sequence labeling |
| Forward Search | Planning | Task planning |
