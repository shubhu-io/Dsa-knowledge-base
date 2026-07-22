/*
Problem: Palindrome Check
Check if a given string is a palindrome (reads same forwards and backwards).

Approach:
- Two-pointer technique from both ends

Time Complexity: O(n)
Space Complexity: O(1)

Example:
Input: "racecar"
Output: 1 (true)
*/

#include <stdio.h>
#include <string.h>
#include <stdbool.h>

bool is_palindrome(char str[])
{
    int left = 0, right = strlen(str) - 1;
    while (left < right)
        if (str[left++] != str[right--])
            return false;
    return true;
}

int main()
{
    char str[] = "racecar";
    printf("%s -> %s\n", str, is_palindrome(str) ? "true" : "false");
    return 0;
}
