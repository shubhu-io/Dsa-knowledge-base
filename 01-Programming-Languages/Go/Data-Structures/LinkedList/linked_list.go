package main

import "fmt"

type Node struct {
    Value int
    Next  *Node
}

type LinkedList struct {
    Head *Node
}

func (ll *LinkedList) Append(value int) {
    newNode := &Node{Value: value}
    
    if ll.Head == nil {
        ll.Head = newNode
        return
    }
    
    current := ll.Head
    for current.Next != nil {
        current = current.Next
    }
    current.Next = newNode
}

func (ll *LinkedList) Prepend(value int) {
    newNode := &Node{Value: value, Next: ll.Head}
    ll.Head = newNode
}

func (ll *LinkedList) Delete(value int) {
    if ll.Head == nil {
        return
    }
    
    if ll.Head.Value == value {
        ll.Head = ll.Head.Next
        return
    }
    
    current := ll.Head
    for current.Next != nil && current.Next.Value != value {
        current = current.Next
    }
    
    if current.Next != nil {
        current.Next = current.Next.Next
    }
}

func (ll *LinkedList) Display() {
    current := ll.Head
    for current != nil {
        fmt.Printf("%d -> ", current.Value)
        current = current.Next
    }
    fmt.Println("nil")
}

func main() {
    ll := &LinkedList{}
    ll.Append(1)
    ll.Append(2)
    ll.Append(3)
    ll.Prepend(0)
    
    fmt.Println("List:")
    ll.Display()
    
    ll.Delete(2)
    fmt.Println("After deleting 2:")
    ll.Display()
}