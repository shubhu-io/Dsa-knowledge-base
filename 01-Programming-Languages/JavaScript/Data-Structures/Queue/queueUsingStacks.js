/*
Problem: Queue Using Stacks
Description: Implement a FIFO queue using two stacks. Enqueue and dequeue operations.

Approach:
- Use two stacks: one for enqueue, one for dequeue
- When dequeue stack is empty, transfer all elements from enqueue stack

Time Complexity: O(1) amortized per operation
Space Complexity: O(n)

Example:
Input: enqueue(1), enqueue(2), dequeue(), enqueue(3), dequeue(), dequeue()
Output: 1, 2, 3
*/

class QueueUsingStacks {
  constructor() {
    this.inStack = [];
    this.outStack = [];
  }

  enqueue(val) {
    this.inStack.push(val);
  }

  dequeue() {
    if (this.outStack.length === 0) {
      while (this.inStack.length > 0) {
        this.outStack.push(this.inStack.pop());
      }
    }
    return this.outStack.pop();
  }

  peek() {
    if (this.outStack.length === 0) {
      while (this.inStack.length > 0) {
        this.outStack.push(this.inStack.pop());
      }
    }
    return this.outStack[this.outStack.length - 1];
  }

  empty() {
    return this.inStack.length === 0 && this.outStack.length === 0;
  }
}

const q = new QueueUsingStacks();
q.enqueue(1);
q.enqueue(2);
console.log('dequeue:', q.dequeue());
q.enqueue(3);
console.log('dequeue:', q.dequeue());
console.log('dequeue:', q.dequeue());
console.log('empty:', q.empty());
