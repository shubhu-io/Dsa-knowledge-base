# Go Introduction

## Why Learn Go?
Go (Golang) is a statically typed, compiled language designed at Google. It's known for simplicity, performance, and excellent concurrency support.

## Key Features
- **Simple Syntax**: Clean, minimalistic design
- **Fast Compilation**: Quick build times
- **Garbage Collection**: Automatic memory management
- **Concurrency**: Goroutines and channels for parallelism
- **Static Typing**: Type safety with type inference
- **Standard Library**: Rich built-in packages
- **Cross-Platform**: Compiles to multiple OS/architectures
- **Strong Community**: Backed by Google

## Getting Started

### Installation
1. Download from golang.org
2. Install and set GOPATH
3. Verify: `go version`

### First Program
```go
package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
}
```

Save as `hello.go` and run with `go run hello.go`

## Basic Syntax

### Variables and Data Types
```go
// Variable declarations
var name string = "Alice"
var age int = 30
var height float64 = 5.5
var isStudent bool = true

// Short declaration
score := 100

// Constants
const Pi = 3.14159
```

### Input/Output
```go
// Output
fmt.Println("Hello, World!")
fmt.Printf("Name: %s, Age: %d\n", name, age)

// Input
var input string
fmt.Scan(&input)
```

### Control Flow
```go
// If-else
if age >= 18 {
    fmt.Println("Adult")
} else {
    fmt.Println("Minor")
}

// For loop (only loop in Go)
for i := 0; i < 5; i++ {
    fmt.Println(i)
}

// Range-based for
for index, value := range slice {
    fmt.Println(index, value)
}

// Switch
switch day {
case "Monday":
    fmt.Println("Start of week")
case "Friday":
    fmt.Println("Almost weekend")
default:
    fmt.Println("Midweek")
}
```

### Functions
```go
// Basic function
func add(a, b int) int {
    return a + b
}

// Multiple return values
func swap(a, b int) (int, int) {
    return b, a
}

// Named return values
func divide(a, b float64) (result float64, err error) {
    if b == 0 {
        err = errors.New("division by zero")
        return
    }
    result = a / b
    return
}
```

### Arrays and Slices
```go
// Arrays (fixed size)
var arr [5]int = [5]int{1, 2, 3, 4, 5}

// Slices (dynamic size)
slice := []int{1, 2, 3, 4, 5}
slice = append(slice, 6)

// Make slice with capacity
numbers := make([]int, 5, 10)
```

### Maps
```go
// Map declaration
ages := map[string]int{
    "Alice": 30,
    "Bob":   25,
}

// Add/update
ages["Charlie"] = 35

// Check existence
age, exists := ages["Alice"]

// Delete
delete(ages, "Bob")
```

### Structs
```go
type Person struct {
    Name string
    Age  int
}

// Method
func (p Person) Greet() string {
    return "Hello, " + p.Name
}

// Pointer receiver
func (p *Person) Birthday() {
    p.Age++
}
```

### Pointers
```go
x := 42
p := &x    // Pointer to x
fmt.Println(*p)  // Dereference
*p = 100    // Modify through pointer
```

### Error Handling
```go
result, err := someFunction()
if err != nil {
    log.Fatal(err)
}

// Custom errors
type ValidationError struct {
    Field   string
    Message string
}

func (e *ValidationError) Error() string {
    return e.Field + ": " + e.Message
}
```

### Goroutines and Channels
```go
// Goroutine
go func() {
    fmt.Println("Running in background")
}()

// Channel
ch := make(chan int)
go func() {
    ch <- 42  // Send
}()
value := <-ch  // Receive

// Buffered channel
buffered := make(chan string, 10)
```

### Interfaces
```go
type Writer interface {
    Write([]byte) (int, error)
}

// Implementation (implicit)
type File struct {
    Name string
}

func (f File) Write(data []byte) (int, error) {
    // Write to file
    return len(data), nil
}
```

## Best Practices
1. Keep it simple - favor readability over cleverness
2. Use meaningful variable names
3. Handle errors explicitly
4. Use goroutines for concurrency
5. Prefer composition over inheritance
6. Use gofmt for consistent formatting

## Common Pitfalls
- Forgetting to check errors
- Not closing resources (files, connections)
- Race conditions with goroutines
- Slice initialization with `make`
- Interface satisfaction is implicit