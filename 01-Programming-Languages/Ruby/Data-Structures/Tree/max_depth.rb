=begin
Problem: Maximum Depth of Binary Tree
Description: Find the maximum depth (height) of a binary tree.

Approach:
- Recursively compute depth of left and right subtrees
- Return 1 + max(leftDepth, rightDepth)

Time Complexity: O(n)
Space Complexity: O(n)

Example:
Input:  Tree: 3 -> (9, 20 -> (15, 7))
Output: 3
=end

class TreeNode
  attr_accessor :val, :left, :right

  def initialize(val = 0, left = nil, right = nil)
    @val = val
    @left = left
    @right = right
  end
end

def max_depth(root)
  return 0 if root.nil?
  1 + [max_depth(root.left), max_depth(root.right)].max
end

root = TreeNode.new(3,
  TreeNode.new(9),
  TreeNode.new(20, TreeNode.new(15), TreeNode.new(7))
)

puts "Max depth: #{max_depth(root)}"
