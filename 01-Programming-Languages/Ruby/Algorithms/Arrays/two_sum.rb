def two_sum(nums, target)
  num_map = {}

  nums.each_with_index do |num, i|
    complement = target - num
    if num_map.key?(complement)
      return [num_map[complement], i]
    end
    num_map[num] = i
  end

  nil
end

nums = [2, 7, 11, 15]
target = 9
result = two_sum(nums, target)
puts "Indices: #{result}"