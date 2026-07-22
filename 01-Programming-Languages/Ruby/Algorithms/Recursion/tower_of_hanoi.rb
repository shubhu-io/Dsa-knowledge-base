=begin
Problem: Tower of Hanoi
Description: Move n disks from source peg to destination peg using an auxiliary peg.

Approach:
- Move n-1 disks from source to auxiliary
- Move nth disk from source to destination
- Move n-1 disks from auxiliary to destination

Time Complexity: O(2^n)
Space Complexity: O(n) (recursion stack)

Example:
Input:  n = 3, source = 'A', dest = 'C', aux = 'B'
Output: sequence of moves
=end

def tower_of_hanoi(n, source, dest, aux)
  if n == 1
    puts "Move disk 1 from #{source} to #{dest}"
    return
  end
  tower_of_hanoi(n - 1, source, aux, dest)
  puts "Move disk #{n} from #{source} to #{dest}"
  tower_of_hanoi(n - 1, aux, dest, source)
end

tower_of_hanoi(3, 'A', 'C', 'B')
