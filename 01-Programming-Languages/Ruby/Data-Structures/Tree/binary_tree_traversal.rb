=begin
Problem: Binary Tree Traversals
Description: Perform inorder, preorder, and postorder traversals on a binary tree.

Approach:
- Inorder: left -> root -> right
- Preorder: root -> left -> right
- Postorder: left -> right -> root

Time Complexity: O(n)
Space Complexity: O(n)

Example:
Input:  Tree: 1 -> (2, 3) where 2 -> (4, 5)
Output:
  Inorder:   [4, 2, 5, 1, 3]
  Preorder:  [1, 2, 4, 5, 3]
  Postorder: [4, 5, 2, 3, 1]
=end

class TreeNode
  attr_accessor :val, :left, :right

  def initialize(val = 0, left = nil, right = nil)
    @val = val
    @left = left
    @right = right
  end
end

def inorder(root, result = [])
  return result if root.nil?
  inorder(root.left, result)
  result << root.val
  inorder(root.right, result)
  result
end

def preorder(root, result = [])
  return result if root.nil?
  result << root.val
  preorder(root.left, result)
  preorder(root.right, result)
  result
end

def postorder(root, result = [])
  return result if root.nil?
  postorder(root.left, result)
  postorder(root.right, result)
  result << root.val
  result
end

root = TreeNode.new(1,
  TreeNode.new(2, TreeNode.new(4), TreeNode.new(5)),
  TreeNode.new(3)
)

puts "Inorder:   #{inorder(root).join(' ')}"
puts "Preorder:  #{preorder(root).join(' ')}"
puts "Postorder: #{postorder(root).join(' ')}"
