=begin
Problem: Hash Map Implementation
Description: Implement a simple hash map with put, get, and delete operations.

Approach:
- Use an array of buckets; each bucket stores key-value pairs
- Handle collisions via separate chaining

Time Complexity: O(1) average, O(n) worst
Space Complexity: O(n)

Example:
Input:  put("name", "Alice"), get("name"), delete("name"), get("name")
Output: "Alice", nil
=end

class HashMap
  def initialize(capacity = 16)
    @capacity = capacity
    @buckets = Array.new(capacity) { [] }
  end

  def put(key, value)
    idx = hash(key)
    @buckets[idx].each do |pair|
      if pair[0] == key
        pair[1] = value
        return
      end
    end
    @buckets[idx] << [key, value]
  end

  def get(key)
    idx = hash(key)
    @buckets[idx].each { |k, v| return v if k == key }
    nil
  end

  def delete(key)
    idx = hash(key)
    @buckets[idx].reject! { |k, _| k == key }
  end

  private

  def hash(key)
    key.hash % @capacity
  end
end

map = HashMap.new
map.put("name", "Alice")
map.put("age", 25)
puts "Get name: #{map.get('name')}"
puts "Get age: #{map.get('age')}"
map.delete("name")
puts "Get name after delete: #{map.get('name').inspect}"
