# Go Syntax

## Overview
Go has a clean, minimal syntax designed for simplicity and readability. This guide covers the essential syntax elements including variables, types, control structures, concurrency primitives, and error handling.

## Variables and Types

### Variable Declaration
```go
// Explicit type declaration
var name string = "Alice"
var age int = 30

// Type inference
var city = "New York"  // string inferred
var population = 8000000  // int inferred

// Short variable declaration (only inside functions)
count := 0
message := "Hello, Go!"

// Multiple declarations
var (
    x int = 1
    y int = 2
    z int = 3
)

// Constants
const Pi = 3.14159
const (
    StatusOK = 200
    NotFound = 404
)
```

### Basic Types
```go
// Boolean
var isActive bool = true

// Numeric types
var i int = 42          // Platform-dependent (32 or 64 bit)
var i32 int32 = 100     // 32-bit integer
var i64 int64 = 100000  // 64-bit integer
var u uint = 42         // Unsigned integer
var f32 float32 = 3.14  // 32-bit float
var f64 float64 = 3.14  // 64-bit float
var c complex128 = complex(1, 2)  // Complex number

// String
var s string = "Hello, World!"
rawString := `This is a
multi-line raw string`

// Byte (alias for uint8)
var b byte = 'A'

// Rune (alias for int32, represents Unicode code point)
var r rune = '€'
```

### Arrays, Slices, and Maps
```go
// Arrays (fixed size)
var arr [5]int = [5]int{1, 2, 3, 4, 5}
arr2 := [...]int{1, 2, 3}  // Compiler counts elements

// Slices (dynamic arrays)
slice := []int{1, 2, 3, 4, 5}
slice2 := make([]int, 5)      // Length 5, capacity 5
slice3 := make([]int, 0, 10) // Length 0, capacity 10

// Maps (key-value pairs)
m := map[string]int{
    "Alice": 25,
    "Bob":   30,
}
m2 := make(map[string]int)  // Empty map
```

### Structs
```go
// Struct definition
type Person struct {
    Name string
    Age  int
    City string
}

// Creating instances
p1 := Person{Name: "Alice", Age: 30, City: "New York"}
p2 := Person{}  // Zero values
p2.Name = "Bob" // Field access

// Struct methods
func (p Person) Greet() string {
    return "Hello, my name is " + p.Name
}

// Pointer receiver (can modify struct)
func (p *Person) HaveBirthday() {
    p.Age++
}

// Anonymous structs
point := struct {
    X, Y int
}{X: 1, Y: 2}
```

### Interfaces
```go
// Interface definition
type Shape interface {
    Area() float64
    Perimeter() float64
}

// Implementation (implicit)
type Circle struct {
    Radius float64
}

func (c Circle) Area() float64 {
    return math.Pi * c.Radius * c.Radius
}

func (c Circle) Perimeter() float64 {
    return 2 * math.Pi * c.Radius
}

// Interface as parameter
func PrintShapeInfo(s Shape) {
    fmt.Printf("Area: %.2f, Perimeter: %.2f\n", s.Area(), s.Perimeter())
}
```

## Concurrency

### Goroutines
```go
// Starting a goroutine
go func() {
    fmt.Println("Hello from goroutine")
}()

// Using WaitGroup
var wg sync.WaitGroup
for i := 0; i < 3; i++ {
    wg.Add(1)
    go func(id int) {
        defer wg.Done()
        fmt.Printf("Worker %d starting\n", id)
    }(i)
}
wg.Wait()
```

### Channels
```go
// Unbuffered channel
ch := make(chan int)
go func() {
    ch <- 42  // Send
}()
value := <-ch  // Receive

// Buffered channel
buffered := make(chan string, 10)
buffered <- "Hello"

// Channel directions
func producer(ch chan<- int) {  // Send-only
    ch <- 42
}
func consumer(ch <-chan int) {  // Receive-only
    val := <-ch
}

// Select statement
select {
case msg := <-ch1:
    fmt.Println("Received from ch1:", msg)
case ch2 <- "hello":
    fmt.Println("Sent to ch2")
case <-time.After(time.Second):
    fmt.Println("Timeout")
}
```

## Error Handling
```go
// Error interface
type error interface {
    Error() string
}

// Creating errors
err := errors.New("something went wrong")
err := fmt.Errorf("invalid value: %d", value)

// Checking errors
result, err := someFunction()
if err != nil {
    log.Fatal(err)
}

// Custom error types
type ValidationError struct {
    Field   string
    Message string
}

func (e *ValidationError) Error() string {
    return fmt.Sprintf("validation error on field '%s': %s", e.Field, e.Message)
}

// Error wrapping (Go 1.13+)
wrappedErr := fmt.Errorf("operation failed: %w", originalErr)
errors.Is(wrappedErr, originalErr)  // true
errors.As(wrappedErr, &target)      // Unwrap
```

## Defer, Panic, and Recover
```go
// Defer (executes when surrounding function returns)
func readFile(filename string) error {
    file, err := os.Open(filename)
    if err != nil {
        return err
    }
    defer file.Close()  // Always executed
    // Process file...
}

// Multiple defers (LIFO order)
func multipleDefers() {
    defer fmt.Println("First")
    defer fmt.Println("Second")
    defer fmt.Println("Third")
    // Output: Third, Second, First
}

// Panic (runtime error)
func divide(a, b int) int {
    if b == 0 {
        panic("division by zero")
    }
    return a / b
}

// Recover (catch panic)
func safeDivide(a, b int) (result int, err error) {
    defer func() {
        if r := recover(); r != nil {
            err = fmt.Errorf("recovered from panic: %v", r)
        }
    }()
    return a / b, nil
}
```

## Packages and Modules
```go
// Package declaration (must be first line)
package main

// Import statements
import (
    "fmt"
    "math"
    "os"
    "strings"
)

// Import with alias
import (
    m "math"
    path "path/filepath"
)

// Import only for side effects
import _ "github.com/lib/pq"

// Main function (entry point)
func main() {
    fmt.Println("Hello, World!")
}

// Exported names (start with capital letter)
func ExportedFunc() {}  // Public
func unexportedFunc() {}  // Private

// Init function (runs before main)
func init() {
    // Initialization code
}
```

## Go Modules
```bash
# Initialize a new module
go mod init example.com/project

# Add dependencies
go get github.com/pkg/errors

# Tidy dependencies (add missing, remove unused)
go mod tidy

# Download dependencies
go mod download

# Vendor dependencies
go mod vendor

# View module graph
go mod graph
```

```go
// Module file (go.mod)
module example.com/project

go 1.21

require (
    github.com/pkg/errors v0.9.1
    github.com/stretchr/testify v1.8.4
)

require (
    github.com/davecgh/go-spew v1.1.1 // indirect
    github.com/pmezard/go-difflib v1.0.0 // indirect
)
```

## Example: Complete Go Program
```go
package main

import (
    "errors"
    "fmt"
    "strings"
)

// Custom error type
type ValidationError struct {
    Field   string
    Message string
}

func (e *ValidationError) Error() string {
    return fmt.Sprintf("validation error on '%s': %s", e.Field, e.Message)
}

// Interface
type Validator interface {
    Validate() error
}

// Struct implementing interface
type User struct {
    Name  string
    Email string
    Age   int
}

func (u User) Validate() error {
    if u.Name == "" {
        return &ValidationError{Field: "name", Message: "required"}
    }
    if !strings.Contains(u.Email, "@") {
        return &ValidationError{Field: "email", Message: "invalid format"}
    }
    if u.Age < 0 || u.Age > 150 {
        return &ValidationError{Field: "age", Message: "out of range"}
    }
    return nil
}

// Function with error handling
func processUser(u Validator) error {
    if err := u.Validate(); err != nil {
        var ve *ValidationError
        if errors.As(err, &ve) {
            return fmt.Errorf("validation failed: %w", err)
        }
        return fmt.Errorf("unexpected error: %w", err)
    }
    fmt.Println("User is valid")
    return nil
}

func main() {
    user := User{Name: "Alice", Email: "alice@example.com", Age: 30}
    if err := processUser(user); err != nil {
        fmt.Println("Error:", err)
    }
}
```

## See Also
- [[../00-Getting-Started/README|Getting Started]]
- [[oop.md|OOP in Go]]
- [[../Algorithms/String/string_algorithms.go|String Algorithms]]
- [Effective Go](https://go.dev/doc/effective_go)
- [Go Documentation](https://go.dev/doc/)