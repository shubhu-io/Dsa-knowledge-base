/*
Problem: Queue Using Stacks
Description: Implement a FIFO queue using two stacks (push, pop, peek, empty).

Approach:
- Use two lists as stacks (input, output)
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
  List<int> _input = [];
  List<int> _output = [];

  void push(int x) { _input.add(x); }

  int pop() {
    if (_output.isEmpty) _transfer();
    return _output.removeLast();
  }

  int peek() {
    if (_output.isEmpty) _transfer();
    return _output.last;
  }

  bool empty() => _input.isEmpty && _output.isEmpty;

  void _transfer() {
    while (_input.isNotEmpty) {
      _output.add(_input.removeLast());
    }
  }
}

void main() {
  MyQueue q = MyQueue();
  q.push(1);
  q.push(2);
  print('Peek: ${q.peek()}');
  print('Pop: ${q.pop()}');
  print('Empty: ${q.empty()}');
  print('Pop: ${q.pop()}');
  print('Empty: ${q.empty()}');
}
