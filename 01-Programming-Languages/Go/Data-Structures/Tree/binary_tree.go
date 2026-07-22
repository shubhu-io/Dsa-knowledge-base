package main

import "fmt"

type TreeNode struct {
    Value int
    Left  *TreeNode
    Right *TreeNode
}

func (t *TreeNode) Insert(value int) *TreeNode {
    if t == nil {
        return &TreeNode{Value: value}
    }
    
    if value < t.Value {
        t.Left = t.Left.Insert(value)
    } else if value > t.Value {
        t.Right = t.Right.Insert(value)
    }
    
    return t
}

func (t *TreeNode) Inorder() {
    if t != nil {
        t.Left.Inorder()
        fmt.Printf("%d ", t.Value)
        t.Right.Inorder()
    }
}

func (t *TreeNode) Preorder() {
    if t != nil {
        fmt.Printf("%d ", t.Value)
        t.Left.Preorder()
        t.Right.Preorder()
    }
}

func (t *TreeNode) Postorder() {
    if t != nil {
        t.Left.Postorder()
        t.Right.Postorder()
        fmt.Printf("%d ", t.Value)
    }
}

func (t *TreeNode) Search(value int) bool {
    if t == nil {
        return false
    }
    
    if value == t.Value {
        return true
    } else if value < t.Value {
        return t.Left.Search(value)
    } else {
        return t.Right.Search(value)
    }
}

func main() {
    var root *TreeNode
    values := []int{50, 30, 70, 20, 40, 60, 80}
    
    for _, v := range values {
        root = root.Insert(v)
    }
    
    fmt.Print("Inorder: ")
    root.Inorder()
    fmt.Println()
    
    fmt.Print("Preorder: ")
    root.Preorder()
    fmt.Println()
    
    fmt.Print("Postorder: ")
    root.Postorder()
    fmt.Println()
    
    fmt.Println("Search 40:", root.Search(40))
    fmt.Println("Search 90:", root.Search(90))
}