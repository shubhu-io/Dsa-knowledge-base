object TwoSum {
  import scala.collection.mutable

  def twoSum(nums: Array[Int], target: Int): Option[(Int, Int)] = {
    val numMap = mutable.Map[Int, Int]()

    for ((num, i) <- nums.zipWithIndex) {
      val complement = target - num
      numMap.get(complement) match {
        case Some(index) => return Some((index, i))
        case None => numMap(num) = i
      }
    }

    None
  }

  def main(args: Array[String]): Unit = {
    val nums = Array(2, 7, 11, 15)
    val target = 9

    twoSum(nums, target) match {
      case Some((i, j)) => println(s"Indices: ($i, $j)")
      case None => println("No solution found")
    }
  }
}