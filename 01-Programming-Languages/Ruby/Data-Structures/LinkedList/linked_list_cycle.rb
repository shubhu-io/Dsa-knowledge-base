=begin
Problem: Linked List Cycle Detection
Description: Determine if a linked list has a cycle using Floyd's Tortoise and Hare.

Approach:
- Slow pointer moves one step, fast moves two steps
- If they meet, a cycle exists

Time Complexity: O(n)
Space Complexity: O(1)

Example:
Input:  3 -> 2 -> 0 -> -4 (cycle back to index 1)
Output: true
=end

class ListNode
  attr_accessor :val, :next

  def initialize(val = 0, nxt = nil)
    @val = val
    @next = nxt
  end
end

def has_cycle?(head)
  slow = head
  fast = head
  while fast && fast.next
    slow = slow.next
    fast = fast.next.next
    return true if slow == fast
  end
  false
end

# No cycle
head = ListNode.new(1, ListNode.new(2))
puts "Has cycle (no cycle): #{has_cycle?(head)}"

# With cycle
node1 = ListNode.new(3)
node2 = ListNode.new(2)
node3 = ListNode.new(0)
node4 = ListNode.new(-4)
node1.next = node2
node2.next = node3
node3.next = node4
node4.next = node2
puts "Has cycle (cycle): #{has_cycle?(node1)}"
