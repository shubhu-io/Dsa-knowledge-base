<?php
class Stack {
    private $items;

    public function __construct() {
        $this->items = [];
    }

    public function push($item) {
        $this->items[] = $item;
    }

    public function pop() {
        if ($this->isEmpty()) {
            return null;
        }
        return array_pop($this->items);
    }

    public function peek() {
        if ($this->isEmpty()) {
            return null;
        }
        return end($this->items);
    }

    public function isEmpty() {
        return empty($this->items);
    }

    public function size() {
        return count($this->items);
    }
}

$stack = new Stack();
$stack->push(1);
$stack->push(2);
$stack->push(3);

echo "Stack size: " . $stack->size() . "\n";
echo "Popped: " . $stack->pop() . "\n";
echo "Top: " . $stack->peek() . "\n";
?>