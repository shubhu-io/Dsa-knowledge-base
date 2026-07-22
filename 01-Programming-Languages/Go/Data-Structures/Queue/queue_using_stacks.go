/*
Problem: Queue Using Stacks
Implement a FIFO queue using two stacks.

Approach:
- Use two stacks: one for pushing, one for popping
- On pop/peek, if the pop stack is empty, transfer all elements from push stack
- This ensures FIFO order

Time Complexity: O(1) amortized per operation
Space Complexity: O(n)

Example:
Input: push(1), push(2), peek(), pop(), empty()
Output: 1, 1, false
*/

package main

import "fmt"

type MyQueue struct {
	in  []int
	out []int
}

func Constructor() MyQueue {
	return MyQueue{}
}

func (q *MyQueue) Push(x int) {
	q.in = append(q.in, x)
}

func (q *MyQueue) transfer() {
	if len(q.out) == 0 {
		for len(q.in) > 0 {
			n := len(q.in)
			q.out = append(q.out, q.in[n-1])
			q.in = q.in[:n-1]
		}
	}
}

func (q *MyQueue) Pop() int {
	q.transfer()
	n := len(q.out)
	val := q.out[n-1]
	q.out = q.out[:n-1]
	return val
}

func (q *MyQueue) Peek() int {
	q.transfer()
	return q.out[len(q.out)-1]
}

func (q *MyQueue) Empty() bool {
	return len(q.in) == 0 && len(q.out) == 0
}

func main() {
	q := Constructor()
	q.Push(1)
	q.Push(2)
	fmt.Println("Peek:", q.Peek())
	fmt.Println("Pop:", q.Pop())
	fmt.Println("Empty:", q.Empty())
}
