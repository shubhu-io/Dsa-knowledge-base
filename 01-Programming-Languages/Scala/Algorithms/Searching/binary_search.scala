object BinarySearch {
  def binarySearch(arr: Array[Int], target: Int): Int = {
    var left = 0
    var right = arr.length - 1

    while (left <= right) {
      val mid = left + (right - left) / 2

      if (arr(mid) == target) {
        return mid
      } else if (arr(mid) < target) {
        left = mid + 1
      } else {
        right = mid - 1
      }
    }

    -1
  }

  def main(args: Array[String]): Unit = {
    val arr = Array(2, 3, 4, 10, 40)
    val target = 10
    val result = binarySearch(arr, target)

    if (result == -1) {
      println("Element not found")
    } else {
      println(s"Element found at index $result")
    }
  }
}