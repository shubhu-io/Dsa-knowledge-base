public class LinkedList {
    private Node head;
    
    private static class Node {
        int value;
        Node next;
        
        Node(int value) {
            this.value = value;
            this.next = null;
        }
    }
    
    public void append(int value) {
        Node newNode = new Node(value);
        
        if (head == null) {
            head = newNode;
            return;
        }
        
        Node current = head;
        while (current.next != null) {
            current = current.next;
        }
        current.next = newNode;
    }
    
    public void prepend(int value) {
        Node newNode = new Node(value);
        newNode.next = head;
        head = newNode;
    }
    
    public void delete(int value) {
        if (head == null) return;
        
        if (head.value == value) {
            head = head.next;
            return;
        }
        
        Node current = head;
        while (current.next != null && current.next.value != value) {
            current = current.next;
        }
        
        if (current.next != null) {
            current.next = current.next.next;
        }
    }
    
    public void display() {
        Node current = head;
        while (current != null) {
            System.out.print(current.value + " -> ");
            current = current.next;
        }
        System.out.println("null");
    }
    
    public static void main(String[] args) {
        LinkedList list = new LinkedList();
        list.append(1);
        list.append(2);
        list.append(3);
        list.prepend(0);
        
        System.out.println("List:");
        list.display();
        
        list.delete(2);
        System.out.println("After deleting 2:");
        list.display();
    }
}