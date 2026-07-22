/*
Problem: Palindrome Check
Check if a given string is a palindrome (reads same forwards and backwards).

Approach:
- Two-pointer technique from both ends

Time Complexity: O(n)
Space Complexity: O(1)

Example:
Input: "racecar"
Output: true
*/

#include <iostream>
#include <string>
using namespace std;

bool is_palindrome(const string& str)
{
    int left = 0, right = str.length() - 1;
    while (left < right)
        if (str[left++] != str[right--])
            return false;
    return true;
}

int main()
{
    string str = "racecar";
    cout << str << " -> " << boolalpha << is_palindrome(str) << endl;
    return 0;
}
