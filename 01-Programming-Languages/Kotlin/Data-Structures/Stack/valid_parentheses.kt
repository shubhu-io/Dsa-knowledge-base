/*
 * Problem: Determine if a string of brackets is valid.
 * Approach: Use a stack to match opening and closing brackets.
 * Time Complexity: O(n)
 * Space Complexity: O(n)
 * Example: Input: "({[]})" -> Output: true, "([)]" -> Output: false
 */

fun isValid(s: String): Boolean {
    val stack = ArrayDeque<Char>()
    for (c in s) {
        when (c) {
            '(', '{', '[' -> stack.push(c)
            else -> {
                if (stack.isEmpty()) return false
                val top = stack.pop()
                if ((c == ')' && top != '(') ||
                    (c == '}' && top != '{') ||
                    (c == ']' && top != '[')) return false
            }
        }
    }
    return stack.isEmpty()
}

fun main() {
    println(isValid("({[]})"))
    println(isValid("([)]"))
}
