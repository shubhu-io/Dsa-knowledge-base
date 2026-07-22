/*
Problem: Graph Adjacency List
Represent a graph using an adjacency list and implement add/remove edge and display operations.

Approach:
- Use a HashMap mapping each vertex to a vector of neighbors
- Provide functions to add/remove edges and display the graph

Time Complexity: O(1) add edge, O(V+E) display
Space Complexity: O(V+E)

Example:
Input: add_edge(0,1), add_edge(0,2), add_edge(1,2), add_edge(2,3)
Output: 0: [1, 2], 1: [0, 2], 2: [0, 1, 3], 3: [2]
*/

use std::collections::HashMap;

struct Graph {
    vertices: HashMap<i32, Vec<i32>>,
}

impl Graph {
    fn new() -> Self {
        Graph { vertices: HashMap::new() }
    }

    fn add_edge(&mut self, u: i32, v: i32) {
        self.vertices.entry(u).or_insert(Vec::new()).push(v);
        self.vertices.entry(v).or_insert(Vec::new()).push(u);
    }

    fn remove_edge(&mut self, u: i32, v: i32) {
        if let Some(list) = self.vertices.get_mut(&u) {
            list.retain(|&x| x != v);
        }
        if let Some(list) = self.vertices.get_mut(&v) {
            list.retain(|&x| x != u);
        }
    }

    fn display(&self) {
        let mut keys: Vec<&i32> = self.vertices.keys().collect();
        keys.sort();
        for key in keys {
            println!("{}: {:?}", key, self.vertices[key]);
        }
    }
}

fn main() {
    let mut g = Graph::new();
    g.add_edge(0, 1);
    g.add_edge(0, 2);
    g.add_edge(1, 2);
    g.add_edge(2, 3);
    g.display();
}
