struct Stack {
    items: Vec<i32>,
}

impl Stack {
    fn new() -> Self {
        Stack { items: Vec::new() }
    }

    fn push(&mut self, item: i32) {
        self.items.push(item);
    }

    fn pop(&mut self) -> Option<i32> {
        self.items.pop()
    }

    fn peek(&self) -> Option<&i32> {
        self.items.last()
    }

    fn is_empty(&self) -> bool {
        self.items.is_empty()
    }

    fn size(&self) -> usize {
        self.items.len()
    }
}

fn main() {
    let mut stack = Stack::new();
    
    stack.push(1);
    stack.push(2);
    stack.push(3);

    println!("Stack size: {}", stack.size());

    if let Some(item) = stack.pop() {
        println!("Popped: {}", item);
    }

    if let Some(item) = stack.peek() {
        println!("Top: {}", item);
    }
}