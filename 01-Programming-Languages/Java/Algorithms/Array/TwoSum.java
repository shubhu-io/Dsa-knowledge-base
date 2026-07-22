/*
 * Problem: Find two indices in an array that sum to a target.
 * Approach: Use a HashMap to store complements.
 * Time Complexity: O(n)
 * Space Complexity: O(n)
 * Example: Input: nums = [2, 7, 11, 15], target = 9 -> Output: [0, 1]
 */

import java.util.*;

public class TwoSum {
    public static int[] twoSum(int[] nums, int target) {
        Map<Integer, Integer> map = new HashMap<>();
        for (int i = 0; i < nums.length; i++) {
            int complement = target - nums[i];
            if (map.containsKey(complement)) {
                return new int[]{map.get(complement), i};
            }
            map.put(nums[i], i);
        }
        return new int[]{-1, -1};
    }

    public static void main(String[] args) {
        int[] nums = {2, 7, 11, 15};
        int target = 9;
        int[] result = twoSum(nums, target);
        System.out.println(Arrays.toString(result));
    }
}
