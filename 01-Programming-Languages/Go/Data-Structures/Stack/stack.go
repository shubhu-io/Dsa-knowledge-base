package main

import "fmt"

type Stack struct {
    items []int
}

func (s *Stack) Push(item int) {
    s.items = append(s.items, item)
}

func (s *Stack) Pop() (int, bool) {
    if len(s.items) == 0 {
        return 0, false
    }
    
    item := s.items[len(s.items)-1]
    s.items = s.items[:len(s.items)-1]
    return item, true
}

func (s *Stack) Peek() (int, bool) {
    if len(s.items) == 0 {
        return 0, false
    }
    return s.items[len(s.items)-1], true
}

func (s *Stack) IsEmpty() bool {
    return len(s.items) == 0
}

func (s *Stack) Size() int {
    return len(s.items)
}

func main() {
    stack := &Stack{}
    
    stack.Push(1)
    stack.Push(2)
    stack.Push(3)
    
    fmt.Println("Stack size:", stack.Size())
    
    if item, ok := stack.Pop(); ok {
        fmt.Println("Popped:", item)
    }
    
    if item, ok := stack.Peek(); ok {
        fmt.Println("Top:", item)
    }
}