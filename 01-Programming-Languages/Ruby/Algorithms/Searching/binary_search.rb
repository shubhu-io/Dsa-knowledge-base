def binary_search(arr, target)
  left = 0
  right = arr.length - 1

  while left <= right
    mid = left + (right - left) / 2

    if arr[mid] == target
      return mid
    elsif arr[mid] < target
      left = mid + 1
    else
      right = mid - 1
    end
  end

  -1
end

arr = [2, 3, 4, 10, 40]
target = 10
result = binary_search(arr, target)

if result == -1
  puts "Element not found"
else
  puts "Element found at index #{result}"
end