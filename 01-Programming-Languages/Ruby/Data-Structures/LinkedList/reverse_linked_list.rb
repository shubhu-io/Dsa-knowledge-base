=begin
Problem: Reverse Linked List
Description: Reverse a singly linked list in-place.

Approach:
- Use three pointers: prev, curr, next
- Point current node's next to prev, then advance

Time Complexity: O(n)
Space Complexity: O(1)

Example:
Input:  1 -> 2 -> 3 -> 4 -> 5
Output: 5 -> 4 -> 3 -> 2 -> 1
=end

class ListNode
  attr_accessor :val, :next

  def initialize(val = 0, nxt = nil)
    @val = val
    @next = nxt
  end
end

def reverse_list(head)
  prev = nil
  curr = head
  while curr
    nxt = curr.next
    curr.next = prev
    prev = curr
    curr = nxt
  end
  prev
end

def print_list(head)
  vals = []
  while head
    vals << head.val
    head = head.next
  end
  puts vals.join(' -> ')
end

head = ListNode.new(1, ListNode.new(2, ListNode.new(3, ListNode.new(4, ListNode.new(5)))))
puts "Original: "
print_list(head)
reversed = reverse_list(head)
puts "Reversed: "
print_list(reversed)
