class Node(val value: Int) {
    var next: Node? = null
}

class LinkedList {
    var head: Node? = null

    fun append(value: Int) {
        val newNode = Node(value)
        if (head == null) {
            head = newNode
            return
        }

        var current = head!!
        while (current.next != null) {
            current = current.next!!
        }
        current.next = newNode
    }

    fun prepend(value: Int) {
        val newNode = Node(value)
        newNode.next = head
        head = newNode
    }

    fun delete(value: Int) {
        if (head?.value == value) {
            head = head?.next
            return
        }

        var current = head
        while (current?.next != null && current.next?.value != value) {
            current = current.next
        }
        current?.next = current?.next?.next
    }

    fun display() {
        var current = head
        while (current != null) {
            print("${current.value} -> ")
            current = current.next
        }
        println("null")
    }
}

fun main() {
    val list = LinkedList()
    list.append(1)
    list.append(2)
    list.append(3)
    list.prepend(0)

    println("List:")
    list.display()

    list.delete(2)
    println("After deleting 2:")
    list.display()
}