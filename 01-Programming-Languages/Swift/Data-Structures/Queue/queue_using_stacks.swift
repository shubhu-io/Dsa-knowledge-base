/*
Problem: Queue Using Stacks
Description: Implement a FIFO queue using two stacks (push, pop, peek, empty).

Approach:
- Use two arrays as stacks (input, output)
- On push: add to input stack
- On pop/peek: if output is empty, transfer all from input to output
- This ensures oldest element is on top of output

Time Complexity: O(1) amortized per operation
Space Complexity: O(n)

Example:
Input: push(1), push(2), peek(), pop(), empty()
Output: 1, 1, false
*/

class MyQueue {
    private var input = [Int]()
    private var output = [Int]()

    func push(_ x: Int) { input.append(x) }

    func pop() -> Int {
        if output.isEmpty { transfer() }
        return output.removeLast()
    }

    func peek() -> Int {
        if output.isEmpty { transfer() }
        return output.last!
    }

    func empty() -> Bool { input.isEmpty && output.isEmpty }

    private func transfer() {
        while !input.isEmpty { output.append(input.removeLast()) }
    }
}

let q = MyQueue()
q.push(1)
q.push(2)
print("Peek: \(q.peek())")
print("Pop: \(q.pop())")
print("Empty: \(q.empty())")
print("Pop: \(q.pop())")
print("Empty: \(q.empty())")
