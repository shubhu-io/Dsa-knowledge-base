// Problem: Palindrome Check
// Description: Check if a given string is a palindrome.
//
// Approach:
// - Use two pointers: one from start, one from end
// - Compare characters moving inward
//
// Time Complexity: O(n)
// Space Complexity: O(1)
//
// Example:
// Input: "racecar"
// Output: true
// Input: "hello"
// Output: false

object Palindrome {
  def isPalindrome(s: String): Boolean = {
    var left = 0; var right = s.length - 1
    while (left < right) {
      if (s(left) != s(right)) return false
      left += 1; right -= 1
    }
    true
  }

  def main(args: Array[String]): Unit = {
    val testCases = Seq("racecar", "hello", "madam", "a", "")
    for (s <- testCases) {
      println(s""""$s" -> ${isPalindrome(s)}""")
    }
  }
}
