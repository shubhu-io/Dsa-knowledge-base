// Problem: Valid Parentheses
// Description: Check if a string of brackets is properly closed and nested.
//
// Approach:
// - Use a stack to track opening brackets
// - Match closing brackets with the top of the stack
//
// Time Complexity: O(n)
// Space Complexity: O(n)
//
// Example:
// Input: "()[]{}"
// Output: true
// Input: "(]"
// Output: false

object ValidParentheses {
  def isValid(s: String): Boolean = {
    val stack = scala.collection.mutable.Stack[Char]()
    val pairs = Map('(' -> ')', '{' -> '}', '[' -> ']')
    for (ch <- s) {
      if (pairs.contains(ch)) {
        stack.push(ch)
      } else {
        if (stack.isEmpty) return false
        val top = stack.pop()
        if (pairs(top) != ch) return false
      }
    }
    stack.isEmpty
  }

  def main(args: Array[String]): Unit = {
    val testCases = Seq("()[]{}", "(]", "([)]", "{[]}", "")
    for (s <- testCases) {
      println(s""""$s" -> ${isValid(s)}""")
    }
  }
}
