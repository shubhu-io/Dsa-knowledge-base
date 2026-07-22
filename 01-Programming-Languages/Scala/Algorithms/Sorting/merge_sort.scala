object MergeSort {
  def mergeSort(arr: Array[Int]): Array[Int] = {
    if (arr.length <= 1) return arr

    val mid = arr.length / 2
    val left = mergeSort(arr.slice(0, mid))
    val right = mergeSort(arr.slice(mid, arr.length))

    merge(left, right)
  }

  def merge(left: Array[Int], right: Array[Int]): Array[Int] = {
    var result = Array[Int]()
    var i = 0
    var j = 0

    while (i < left.length && j < right.length) {
      if (left(i) <= right(j)) {
        result = result :+ left(i)
        i += 1
      } else {
        result = result :+ right(j)
        j += 1
      }
    }

    result ++ left.slice(i, left.length) ++ right.slice(j, right.length)
  }

  def main(args: Array[String]): Unit = {
    val arr = Array(38, 27, 43, 3, 9, 82, 10)
    println(s"Original: ${arr.mkString(", ")}")
    println(s"Sorted: ${mergeSort(arr).mkString(", ")}")
  }
}