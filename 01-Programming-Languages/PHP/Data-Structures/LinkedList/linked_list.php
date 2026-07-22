<?php
class Node {
    public $value;
    public $next;

    public function __construct($value) {
        $this->value = $value;
        $this->next = null;
    }
}

class LinkedList {
    private $head;

    public function __construct() {
        $this->head = null;
    }

    public function append($value) {
        $newNode = new Node($value);

        if ($this->head === null) {
            $this->head = $newNode;
            return;
        }

        $current = $this->head;
        while ($current->next !== null) {
            $current = $current->next;
        }
        $current->next = $newNode;
    }

    public function prepend($value) {
        $newNode = new Node($value);
        $newNode->next = $this->head;
        $this->head = $newNode;
    }

    public function delete($value) {
        if ($this->head === null) {
            return;
        }

        if ($this->head->value === $value) {
            $this->head = $this->head->next;
            return;
        }

        $current = $this->head;
        while ($current->next !== null && $current->next->value !== $value) {
            $current = $current->next;
        }

        if ($current->next !== null) {
            $current->next = $current->next->next;
        }
    }

    public function display() {
        $current = $this->head;
        while ($current !== null) {
            echo $current->value . " -> ";
            $current = $current->next;
        }
        echo "null\n";
    }
}

$list = new LinkedList();
$list->append(1);
$list->append(2);
$list->append(3);
$list->prepend(0);

echo "List:\n";
$list->display();

$list->delete(2);
echo "After deleting 2:\n";
$list->display();
?>