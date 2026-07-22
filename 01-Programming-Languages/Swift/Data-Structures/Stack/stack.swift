struct Stack<T> {
    private var items: [T] = []
    
    mutating func push(_ item: T) {
        items.append(item)
    }
    
    mutating func pop() -> T? {
        items.popLast()
    }
    
    func peek() -> T? {
        items.last
    }
    
    func isEmpty() -> Bool {
        items.isEmpty
    }
    
    func size() -> Int {
        items.count
    }
}

var stack = Stack<Int>()
stack.push(1)
stack.push(2)
stack.push(3)

print("Stack size: \(stack.size())")
print("Popped: \(stack.pop() ?? 0)")
print("Top: \(stack.peek() ?? 0)")