<?php

/*
Problem: Implement Queue Using Stacks
Description: Implement a FIFO queue using two stacks (push, pop, peek, empty).

Approach:
- Use two stacks: one for input, one for output
- On pop/peek, if output is empty, transfer all elements from input to output
- This reverses order, making the oldest element accessible first

Time Complexity: O(1) amortized per operation
Space Complexity: O(n)

Example:
Input:  enqueue(1), enqueue(2), peek(), dequeue(), empty()
Output: 1, 1, false
*/

class MyQueue {
    private array $in;
    private array $out;

    public function __construct() {
        $this->in = [];
        $this->out = [];
    }

    public function enqueue($x): void {
        $this->in[] = $x;
    }

    private function transfer(): void {
        if (empty($this->out)) {
            while (!empty($this->in)) {
                $this->out[] = array_pop($this->in);
            }
        }
    }

    public function dequeue() {
        $this->transfer();
        return array_pop($this->out);
    }

    public function peek() {
        $this->transfer();
        return end($this->out);
    }

    public function empty(): bool {
        return empty($this->in) && empty($this->out);
    }
}

$q = new MyQueue();
$q->enqueue(1);
$q->enqueue(2);
echo "Peek: " . $q->peek() . "\n";
echo "Dequeue: " . $q->dequeue() . "\n";
echo "Empty: " . ($q->empty() ? "true" : "false") . "\n";
echo "Dequeue: " . $q->dequeue() . "\n";
echo "Empty: " . ($q->empty() ? "true" : "false") . "\n";
