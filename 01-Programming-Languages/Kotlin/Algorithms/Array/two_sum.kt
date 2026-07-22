/*
 * Problem: Find two indices in an array that sum to a target.
 * Approach: Use a HashMap to store complements.
 * Time Complexity: O(n)
 * Space Complexity: O(n)
 * Example: Input: nums = [2, 7, 11, 15], target = 9 -> Output: [0, 1]
 */

fun twoSum(nums: IntArray, target: Int): IntArray {
    val map = mutableMapOf<Int, Int>()
    for ((i, num) in nums.withIndex()) {
        val complement = target - num
        if (complement in map) return intArrayOf(map[complement]!!, i)
        map[num] = i
    }
    return intArrayOf(-1, -1)
}

fun main() {
    val nums = intArrayOf(2, 7, 11, 15)
    val result = twoSum(nums, 9)
    println(result.joinToString(" "))
}
