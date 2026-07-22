List<int> twoSum(List<int> nums, int target) {
  final numMap = <int, int>{};

  for (var i = 0; i < nums.length; i++) {
    final complement = target - nums[i];
    if (numMap.containsKey(complement)) {
      return [numMap[complement]!, i];
    }
    numMap[nums[i]] = i;
  }

  return [];
}

void main() {
  final nums = [2, 7, 11, 15];
  final target = 9;
  print('Indices: ${twoSum(nums, target)}');
}