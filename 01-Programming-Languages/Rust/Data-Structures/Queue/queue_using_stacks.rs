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

struct MyQueue {
    input: Vec<i32>,
    output: Vec<i32>,
}

impl MyQueue {
    fn new() -> Self {
        MyQueue { input: Vec::new(), output: Vec::new() }
    }

    fn push(&mut self, x: i32) {
        self.input.push(x);
    }

    fn transfer(&mut self) {
        if self.output.is_empty() {
            while let Some(val) = self.input.pop() {
                self.output.push(val);
            }
        }
    }

    fn pop(&mut self) -> i32 {
        self.transfer();
        self.output.pop().unwrap()
    }

    fn peek(&mut self) -> i32 {
        self.transfer();
        *self.output.last().unwrap()
    }

    fn empty(&self) -> bool {
        self.input.is_empty() && self.output.is_empty()
    }
}

fn main() {
    let mut q = MyQueue::new();
    q.push(1);
    q.push(2);
    println!("Peek: {}", q.peek());
    println!("Pop: {}", q.pop());
    println!("Empty: {}", q.empty());
}
