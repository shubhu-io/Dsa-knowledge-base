fun twoSum(nums: IntArray, target: Int): Pair<Int, Int>? {
    val numMap = mutableMapOf<Int, Int>()

    for ((i, num) in nums.withIndex()) {
        val complement = target - num
        numMap[complement]?.let { index ->
            return Pair(index, i)
        }
        numMap[num] = i
    }

    return null
}

fun main() {
    val nums = intArrayOf(2, 7, 11, 15)
    val target = 9

    when (val result = twoSum(nums, target)) {
        is Pair -> println("Indices: (${result.first}, ${result.second})")
        else -> println("No solution found")
    }
}