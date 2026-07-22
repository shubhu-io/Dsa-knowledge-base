=begin
Problem: Breadth-First Search (BFS)
Description: Traverse a graph level by level using a queue.

Approach:
- Use a queue to process nodes FIFO
- Track visited nodes to avoid cycles

Time Complexity: O(V + E)
Space Complexity: O(V)

Example:
Input:  adjacency list: 0=>[1,2], 1=>[0,3,4], 2=>[0], 3=>[1], 4=>[1], start = 0
Output: [0, 1, 2, 3, 4]
=end

def bfs(graph, start)
  visited = Array.new(graph.length, false)
  queue = [start]
  visited[start] = true
  result = []
  until queue.empty?
    node = queue.shift
    result << node
    graph[node].each do |neighbor|
      unless visited[neighbor]
        visited[neighbor] = true
        queue << neighbor
      end
    end
  end
  result
end

graph = [
  [1, 2],
  [0, 3, 4],
  [0],
  [1],
  [1]
]

puts "BFS starting from 0: #{bfs(graph, 0).join(' ')}"
