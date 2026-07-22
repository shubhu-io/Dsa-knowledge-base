=begin
Problem: Graph Adjacency List
Description: Implement a graph with add_edge, print_graph, and bfs traversal using an adjacency list.

Approach:
- Use a hash mapping vertices to lists of neighbors
- add_edge adds connection in both directions

Time Complexity: O(V + E) for traversal
Space Complexity: O(V + E)

Example:
Input:  vertices: [0,1,2,3], edges: [0-1, 0-2, 1-2, 2-3]
Output: adjacency list representation
=end

class Graph
  def initialize
    @adj_list = {}
  end

  def add_vertex(v)
    @adj_list[v] ||= []
  end

  def add_edge(v1, v2)
    add_vertex(v1)
    add_vertex(v2)
    @adj_list[v1] << v2
    @adj_list[v2] << v1
  end

  def print_graph
    @adj_list.each { |v, neighbors| puts "#{v} -> #{neighbors.join(', ')}" }
  end

  def bfs(start)
    visited = Set.new
    queue = [start]
    visited.add(start)
    result = []
    until queue.empty?
      node = queue.shift
      result << node
      @adj_list[node].each do |neighbor|
        unless visited.include?(neighbor)
          visited.add(neighbor)
          queue << neighbor
        end
      end
    end
    result
  end
end

require 'set'

g = Graph.new
g.add_edge(0, 1)
g.add_edge(0, 2)
g.add_edge(1, 2)
g.add_edge(2, 3)

puts "Adjacency List:"
g.print_graph

puts "BFS from 0: #{g.bfs(0).join(' ')}"
