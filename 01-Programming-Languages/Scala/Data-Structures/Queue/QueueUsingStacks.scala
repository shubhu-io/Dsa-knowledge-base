// Problem: Queue Using Stacks
// Description: Implement a FIFO queue using two stacks.
//
// Approach:
// - Use two stacks: one for enqueue, one for dequeue
// - On dequeue, transfer elements from enqueue stack to dequeue stack if empty
//
// Time Complexity: O(1) amortized
// Space Complexity: O(n)
//
// Example:
// Input: enqueue(1), enqueue(2), dequeue(), enqueue(3), dequeue(), dequeue()
// Output: 1, 2, 3

object QueueUsingStacks {
  class Queue {
    private val inStack = scala.collection.mutable.Stack[Int]()
    private val outStack = scala.collection.mutable.Stack[Int]()

    def enqueue(x: Int): Unit = {
      inStack.push(x)
    }

    def dequeue(): Int = {
      if (outStack.isEmpty) {
        while (inStack.nonEmpty) {
          outStack.push(inStack.pop())
        }
      }
      outStack.pop()
    }

    def isEmpty: Boolean = inStack.isEmpty && outStack.isEmpty
  }

  def main(args: Array[String]): Unit = {
    val q = new Queue
    q.enqueue(1)
    q.enqueue(2)
    println(s"Dequeued: ${q.dequeue()}")
    q.enqueue(3)
    println(s"Dequeued: ${q.dequeue()}")
    println(s"Dequeued: ${q.dequeue()}")
  }
}
