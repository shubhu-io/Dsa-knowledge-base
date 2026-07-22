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

#include <iostream>
#include <stack>
#include <string>
using namespace std;

bool is_valid(const string& s)
{
    stack<char> st;
    for (char c : s)
    {
        if (c == '(' || c == '{' || c == '[')
            st.push(c);
        else
        {
            if (st.empty()) return false;
            char top = st.top(); st.pop();
            if ((c == ')' && top != '(') ||
                (c == '}' && top != '{') ||
                (c == ']' && top != '['))
                return false;
        }
    }
    return st.empty();
}

int main()
{
    string s = "({[]})";
    cout << s << " -> " << boolalpha << is_valid(s) << endl;
    return 0;
}
