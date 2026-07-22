=begin
Problem: Merge Sort
Description: Sort an array using the divide-and-conquer merge sort algorithm.

Approach:
- Divide array into two halves recursively until single elements
- Merge sorted halves by comparing elements sequentially

Time Complexity: O(n log n)
Space Complexity: O(n)

Example:
Input:  [38, 27, 43, 3, 9, 82, 10]
Output: [3, 9, 10, 27, 38, 43, 82]
=end

def merge_sort(arr)
  return arr if arr.length <= 1
  mid = arr.length / 2
  left = merge_sort(arr[0...mid])
  right = merge_sort(arr[mid..])
  merge(left, right)
end

def merge(left, right)
  result = []
  i = j = 0
  while i < left.length && j < right.length
    if left[i] <= right[j]
      result << left[i]
      i += 1
    else
      result << right[j]
      j += 1
    end
  end
  result.concat(left[i..]).concat(right[j..])
end

arr = [38, 27, 43, 3, 9, 82, 10]
puts "Original: #{arr.join(', ')}"
sorted = merge_sort(arr)
puts "Sorted:   #{sorted.join(', ')}"
