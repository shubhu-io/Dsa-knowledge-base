class Stack
  def initialize
    @items = []
  end

  def push(item)
    @items.push(item)
  end

  def pop
    @items.pop
  end

  def peek
    @items.last
  end

  def empty?
    @items.empty?
  end

  def size
    @items.length
  end
end

stack = Stack.new
stack.push(1)
stack.push(2)
stack.push(3)

puts "Stack size: #{stack.size}"
puts "Popped: #{stack.pop}"
puts "Top: #{stack.peek}"