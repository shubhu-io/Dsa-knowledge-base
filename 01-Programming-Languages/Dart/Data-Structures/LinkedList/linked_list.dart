class Node {
  int value;
  Node? next;

  Node(this.value) : next = null;
}

class LinkedList {
  Node? head;

  void append(int value) {
    final newNode = Node(value);
    if (head == null) {
      head = newNode;
      return;
    }

    var current = head!;
    while (current.next != null) {
      current = current.next!;
    }
    current.next = newNode;
  }

  void prepend(int value) {
    final newNode = Node(value);
    newNode.next = head;
    head = newNode;
  }

  void delete(int value) {
    if (head == null) return;

    if (head!.value == value) {
      head = head!.next;
      return;
    }

    var current = head!;
    while (current.next != null && current.next!.value != value) {
      current = current.next!;
    }
    if (current.next != null) {
      current.next = current.next!.next;
    }
  }

  void display() {
    var current = head;
    while (current != null) {
      stdout.write('${current.value} -> ');
      current = current.next;
    }
    print('null');
  }
}

void main() {
  final list = LinkedList();
  list.append(1);
  list.append(2);
  list.append(3);
  list.prepend(0);

  print('List:');
  list.display();

  list.delete(2);
  print('After deleting 2:');
  list.display();
}