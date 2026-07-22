class Node {
    var value: Int
    var next: Node?
    
    init(value: Int) {
        self.value = value
        self.next = nil
    }
}

class LinkedList {
    var head: Node?
    
    func append(_ value: Int) {
        let newNode = Node(value: value)
        
        guard let head = head else {
            self.head = newNode
            return
        }
        
        var current = head
        while let next = current.next {
            current = next
        }
        current.next = newNode
    }
    
    func prepend(_ value: Int) {
        let newNode = Node(value: value)
        newNode.next = head
        head = newNode
    }
    
    func delete(_ value: Int) {
        guard let head = head else { return }
        
        if head.value == value {
            self.head = head.next
            return
        }
        
        var current = head
        while let next = current.next, next.value != value {
            current = next
        }
        
        if let next = current.next {
            current.next = next.next
        }
    }
    
    func display() {
        var current = head
        while let node = current {
            print("\(node.value) -> ", terminator: "")
            current = node.next
        }
        print("nil")
    }
}

let list = LinkedList()
list.append(1)
list.append(2)
list.append(3)
list.prepend(0)

print("List:")
list.display()

list.delete(2)
print("After deleting 2:")
list.display()