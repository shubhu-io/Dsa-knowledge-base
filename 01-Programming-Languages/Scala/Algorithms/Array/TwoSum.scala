// Problem: Two Sum
// Description: Find two indices in an array whose values sum to a target.
//
// Approach:
// - Use a hash map to store seen values and their indices
// - For each element, check if complement (target - element) exists
//
// Time Complexity: O(n)
// Space Complexity: O(n)
//
// Example:
// Input: nums = Array(2, 7, 11, 15), target = 9
// Output: Array(0, 1)

object TwoSum {
  def twoSum(nums: Array[Int], target: Int): Array[Int] = {
    val seen = scala.collection.mutable.Map[Int, Int]()
    for (i <- nums.indices) {
      val complement = target - nums(i)
      if (seen.contains(complement)) {
        return Array(seen(complement), i)
      }
      seen(nums(i)) = i
    }
    Array(-1, -1)
  }

  def main(args: Array[String]): Unit = {
    val nums = Array(2, 7, 11, 15)
    val target = 9
    val result = twoSum(nums, target)
    println(s"nums: ${nums.mkString(", ")}")
    println(s"target: $target -> indices: ${result(0)}, ${result(1)}")
  }
}
