class Stack<T> {
    private items: T[] = [];

    push(item: T): void {
        this.items.push(item);
    }

    pop(): T | undefined {
        return this.items.pop();
    }

    peek(): T | undefined {
        return this.items[this.items.length - 1];
    }

    isEmpty(): boolean {
        return this.items.length === 0;
    }

    size(): number {
        return this.items.length;
    }
}

const stack = new Stack<number>();
stack.push(1);
stack.push(2);
stack.push(3);

console.log("Stack size:", stack.size());
console.log("Popped:", stack.pop());
console.log("Top:", stack.peek());