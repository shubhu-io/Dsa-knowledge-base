/*
 * Problem: Determine if a string of brackets is valid.
 * Approach: Use a stack to match opening and closing brackets.
 * Time Complexity: O(n)
 * Space Complexity: O(n)
 * Example: Input: "({[]})" -> Output: true, "([)]" -> Output: false
 */

import java.util.*;

public class ValidParentheses {
    public static boolean isValid(String s) {
        Deque<Character> stack = new ArrayDeque<>();
        for (char c : s.toCharArray()) {
            if (c == '(' || c == '{' || c == '[') {
                stack.push(c);
            } else {
                if (stack.isEmpty()) return false;
                char top = stack.pop();
                if ((c == ')' && top != '(') ||
                    (c == '}' && top != '{') ||
                    (c == ']' && top != '[')) return false;
            }
        }
        return stack.isEmpty();
    }

    public static void main(String[] args) {
        System.out.println(isValid("({[]})"));
        System.out.println(isValid("([)]"));
    }
}
