=begin
Problem: Merge Two Sorted Lists
Description: Merge two sorted linked lists into one sorted linked list.

Approach:
- Use a dummy head node for easy result building
- Compare heads of both lists, append the smaller one

Time Complexity: O(n + m)
Space Complexity: O(1)

Example:
Input:  l1 = 1 -> 2 -> 4, l2 = 1 -> 3 -> 4
Output: 1 -> 1 -> 2 -> 3 -> 4 -> 4
=end

class ListNode
  attr_accessor :val, :next

  def initialize(val = 0, nxt = nil)
    @val = val
    @next = nxt
  end
end

def merge_two_lists(l1, l2)
  dummy = ListNode.new
  tail = dummy
  while l1 && l2
    if l1.val <= l2.val
      tail.next = l1
      l1 = l1.next
    else
      tail.next = l2
      l2 = l2.next
    end
    tail = tail.next
  end
  tail.next = l1 || l2
  dummy.next
end

def print_list(head)
  vals = []
  while head
    vals << head.val
    head = head.next
  end
  puts vals.join(' -> ')
end

l1 = ListNode.new(1, ListNode.new(2, ListNode.new(4)))
l2 = ListNode.new(1, ListNode.new(3, ListNode.new(4)))
puts "Merged: "
print_list(merge_two_lists(l1, l2))
