/*
Problem: Queue Using Stacks
Implement a queue using two stacks.

Approach:
- Use two stacks to simulate FIFO: push to in-stack, pop/peek from out-stack

Time Complexity: O(1) amortized per operation
Space Complexity: O(n)

Example:
enqueue(1), enqueue(2), dequeue() -> 1, enqueue(3), dequeue() -> 2
*/

#include <iostream>
#include <stack>
using namespace std;

class Queue
{
    stack<int> in, out;
public:
    void enqueue(int val)
    {
        in.push(val);
    }

    int dequeue()
    {
        if (out.empty())
            while (!in.empty())
            {
                out.push(in.top());
                in.pop();
            }
        int val = out.top();
        out.pop();
        return val;
    }
};

int main()
{
    Queue q;
    q.enqueue(1);
    q.enqueue(2);
    cout << "Dequeue: " << q.dequeue() << endl;
    q.enqueue(3);
    cout << "Dequeue: " << q.dequeue() << endl;
    cout << "Dequeue: " << q.dequeue() << endl;
    return 0;
}
