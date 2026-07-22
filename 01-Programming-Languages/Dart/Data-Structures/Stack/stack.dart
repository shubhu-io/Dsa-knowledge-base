class Stack<T> {
  final List<T> _items = [];

  void push(T item) => _items.add(item);

  T? pop() => _items.isEmpty ? null : _items.removeLast();

  T? peek() => _items.isEmpty ? null : _items.last;

  bool get isEmpty => _items.isEmpty;

  int get size => _items.length;
}

void main() {
  final stack = Stack<int>();
  stack.push(1);
  stack.push(2);
  stack.push(3);

  print('Stack size: ${stack.size}');
  print('Popped: ${stack.pop()}');
  print('Top: ${stack.peek()}');
}