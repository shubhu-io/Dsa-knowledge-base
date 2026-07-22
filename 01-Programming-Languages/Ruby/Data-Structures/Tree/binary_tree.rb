class TreeNode
  attr_accessor :value, :left, :right

  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end
end

class BinaryTree
  def initialize
    @root = nil
  end

  def insert(value)
    new_node = TreeNode.new(value)

    if @root.nil?
      @root = new_node
      return
    end

    current = @root
    loop do
      if value < current.value
        if current.left.nil?
          current.left = new_node
          return
        end
        current = current.left
      elsif value > current.value
        if current.right.nil?
          current.right = new_node
          return
        end
        current = current.right
      else
        return # Duplicate
      end
    end
  end

  def inorder(node = @root)
    return if node.nil?

    inorder(node.left)
    print "#{node.value} "
    inorder(node.right)
  end

  def search(value)
    current = @root
    while current
      if value == current.value
        return true
      elsif value < current.value
        current = current.left
      else
        current = current.right
      end
    end
    false
  end
end

tree = BinaryTree.new
[50, 30, 70, 20, 40, 60, 80].each { |v| tree.insert(v) }

print "Inorder: "
tree.inorder
puts

puts "Search 40: #{tree.search(40)}"
puts "Search 90: #{tree.search(90)}"