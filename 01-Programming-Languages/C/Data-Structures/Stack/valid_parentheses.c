/*
Problem: Valid Parentheses
Check if a string of parentheses (), {}, [] is valid and properly closed.

Approach:
- Use a stack to match opening/closing brackets

Time Complexity: O(n)
Space Complexity: O(n)

Example:
Input: "({[]})"
Output: true
*/

#include <stdio.h>
#include <string.h>
#include <stdbool.h>

#define MAX 100

bool is_valid(char *s)
{
    char stack[MAX];
    int top = -1;
    for (int i = 0; s[i]; i++)
    {
        if (s[i] == '(' || s[i] == '{' || s[i] == '[')
            stack[++top] = s[i];
        else
        {
            if (top == -1) return false;
            char c = stack[top--];
            if ((s[i] == ')' && c != '(') ||
                (s[i] == '}' && c != '{') ||
                (s[i] == ']' && c != '['))
                return false;
        }
    }
    return top == -1;
}

int main()
{
    char s[] = "({[]})";
    printf("%s -> %s\n", s, is_valid(s) ? "true" : "false");
    return 0;
}
