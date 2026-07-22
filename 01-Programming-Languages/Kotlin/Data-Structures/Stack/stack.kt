class Stack<T> {
    private val items = mutableListOf<T>()

    fun push(item: T) {
        items.add(item)
    }

    fun pop(): T? {
        return if (items.isNotEmpty()) items.removeAt(items.size - 1) else null
    }

    fun peek(): T? {
        return items.lastOrNull()
    }

    fun isEmpty(): Boolean = items.isEmpty()

    fun size(): Int = items.size
}

fun main() {
    val stack = Stack<Int>()
    stack.push(1)
    stack.push(2)
    stack.push(3)

    println("Stack size: ${stack.size()}")
    println("Popped: ${stack.pop()}")
    println("Top: ${stack.peek()}")
}