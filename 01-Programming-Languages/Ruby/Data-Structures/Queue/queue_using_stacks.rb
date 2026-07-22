=begin
Problem: Implement Queue Using Stacks
Description: Implement a FIFO queue using two stacks.

Approach:
- Use two stacks: one for input, one for output
- On pop/peek, if output is empty, transfer all from input to output

Time Complexity: O(1) amortized per operation
Space Complexity: O(n)

Example:
Input:  enqueue(1), enqueue(2), peek(), dequeue(), empty()
Output: 1, 1, false
=end

class MyQueue
  def initialize
    @in = []
    @out = []
  end

  def enqueue(x)
    @in.push(x)
  end

  def dequeue
    transfer
    @out.pop
  end

  def peek
    transfer
    @out.last
  end

  def empty?
    @in.empty? && @out.empty?
  end

  private

  def transfer
    if @out.empty?
      @out.push(@in.pop) until @in.empty?
    end
  end
end

q = MyQueue.new
q.enqueue(1)
q.enqueue(2)
puts "Peek: #{q.peek}"
puts "Dequeue: #{q.dequeue}"
puts "Empty: #{q.empty?}"
puts "Dequeue: #{q.dequeue}"
puts "Empty: #{q.empty?}"
