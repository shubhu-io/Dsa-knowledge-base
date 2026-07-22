/*
 * Problem: Implement a Queue using two stacks.
 * Approach: Use one stack for enqueue, another for dequeue (amortized O(1)).
 * Time Complexity: O(1) amortized per operation
 * Space Complexity: O(n)
 * Example: enqueue(1), enqueue(2), dequeue() -> 1, enqueue(3), dequeue() -> 2
 */

import java.util.*;

public class QueueUsingStacks {
    private Deque<Integer> in = new ArrayDeque<>();
    private Deque<Integer> out = new ArrayDeque<>();

    public void enqueue(int x) {
        in.push(x);
    }

    public int dequeue() {
        if (out.isEmpty()) {
            while (!in.isEmpty()) out.push(in.pop());
        }
        return out.pop();
    }

    public int peek() {
        if (out.isEmpty()) {
            while (!in.isEmpty()) out.push(in.pop());
        }
        return out.peek();
    }

    public boolean isEmpty() {
        return in.isEmpty() && out.isEmpty();
    }

    public static void main(String[] args) {
        QueueUsingStacks q = new QueueUsingStacks();
        q.enqueue(1);
        q.enqueue(2);
        System.out.println(q.dequeue());
        q.enqueue(3);
        System.out.println(q.dequeue());
        System.out.println(q.dequeue());
    }
}
