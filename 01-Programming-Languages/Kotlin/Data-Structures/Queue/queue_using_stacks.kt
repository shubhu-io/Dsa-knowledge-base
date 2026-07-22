/*
 * Problem: Implement a Queue using two stacks.
 * Approach: Use one stack for enqueue, another for dequeue (amortized O(1)).
 * Time Complexity: O(1) amortized per operation
 * Space Complexity: O(n)
 * Example: enqueue(1), enqueue(2), dequeue() -> 1, enqueue(3), dequeue() -> 2
 */

import java.util.*

class QueueUsingStacks {
    private val `in` = ArrayDeque<Int>()
    private val out = ArrayDeque<Int>()

    fun enqueue(x: Int) { `in`.push(x) }

    fun dequeue(): Int {
        if (out.isEmpty()) while (`in`.isNotEmpty()) out.push(`in`.pop())
        return out.pop()
    }

    fun peek(): Int {
        if (out.isEmpty()) while (`in`.isNotEmpty()) out.push(`in`.pop())
        return out.peek()
    }

    fun isEmpty() = `in`.isEmpty() && out.isEmpty()
}

fun main() {
    val q = QueueUsingStacks()
    q.enqueue(1); q.enqueue(2)
    println(q.dequeue())
    q.enqueue(3)
    println(q.dequeue())
    println(q.dequeue())
}
