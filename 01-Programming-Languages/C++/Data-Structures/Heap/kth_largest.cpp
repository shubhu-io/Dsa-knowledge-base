/*
Problem: Kth Largest Element (Min-Heap)
Find the kth largest element in an array using a min-heap of size k.

Approach:
- Maintain min-heap of size k, insert elements, keep smallest of top k

Time Complexity: O(n log k)
Space Complexity: O(k)

Example:
Input: [3, 2, 1, 5, 6, 4], k = 2
Output: 5
*/

#include <iostream>
#include <vector>
#include <queue>
using namespace std;

int find_kth_largest(const vector<int>& nums, int k)
{
    priority_queue<int, vector<int>, greater<int>> min_heap;
    for (int num : nums)
    {
        min_heap.push(num);
        if ((int)min_heap.size() > k)
            min_heap.pop();
    }
    return min_heap.top();
}

int main()
{
    vector<int> arr = {3, 2, 1, 5, 6, 4};
    int k = 2;
    cout << "Kth largest (k=" << k << "): " << find_kth_largest(arr, k) << endl;
    return 0;
}
