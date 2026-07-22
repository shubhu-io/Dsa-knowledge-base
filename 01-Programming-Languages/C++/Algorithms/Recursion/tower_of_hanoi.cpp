/*
Problem: Tower of Hanoi
Solve the Tower of Hanoi puzzle for n disks.

Approach:
- Recursively move n-1 disks, move largest, then move n-1 disks

Time Complexity: O(2^n)
Space Complexity: O(n)

Example:
Input: n = 3
Output: Move 1 from A to C ...
*/

#include <iostream>
using namespace std;

void tower_of_hanoi(int n, char from, char to, char aux)
{
    if (n == 1)
    {
        cout << "Move disk 1 from " << from << " to " << to << endl;
        return;
    }
    tower_of_hanoi(n - 1, from, aux, to);
    cout << "Move disk " << n << " from " << from << " to " << to << endl;
    tower_of_hanoi(n - 1, aux, to, from);
}

int main()
{
    int n = 3;
    tower_of_hanoi(n, 'A', 'C', 'B');
    return 0;
}
