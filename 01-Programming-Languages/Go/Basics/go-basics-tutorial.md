# Go Basics Tutorial

## Variables and Constants

```go
package main

import "fmt"

func main() {
    // Variable declarations
    var name string = "Alice"
    var age int = 30
    
    // Short declaration
    score := 100
    
    // Constants
    const Pi = 3.14159
    
    fmt.Printf("Name: %s, Age: %d, Score: %d\n", name, age, score)
}
```

## Data Types

- **Integer**: `int`, `int8`, `int16`, `int32`, `int64`
- **Float**: `float32`, `float64`
- **String**: `string`
- **Boolean**: `bool`
- **Complex**: `complex64`, `complex128`

## Control Flow

### If-Else
```go
if age >= 18 {
    fmt.Println("Adult")
} else {
    fmt.Println("Minor")
}
```

### For Loop
```go
for i := 0; i < 5; i++ {
    fmt.Println(i)
}
```

### Switch
```go
switch day {
case "Monday":
    fmt.Println("Start of week")
case "Friday":
    fmt.Println("Almost weekend")
default:
    fmt.Println("Midweek")
}
```

## Functions

```go
// Basic function
func add(a, b int) int {
    return a + b
}

// Multiple return values
func divide(a, b float64) (float64, error) {
    if b == 0 {
        return 0, errors.New("division by zero")
    }
    return a / b, nil
}
```

## Arrays and Slices

```go
// Arrays (fixed size)
var arr [5]int = [5]int{1, 2, 3, 4, 5}

// Slices (dynamic)
slice := []int{1, 2, 3, 4, 5}
slice = append(slice, 6)
```

## Maps

```go
ages := map[string]int{
    "Alice": 30,
    "Bob":   25,
}

// Add/update
ages["Charlie"] = 35

// Delete
delete(ages, "Bob")
```

## Structs

```go
type Person struct {
    Name string
    Age  int
}

func (p Person) Greet() string {
    return "Hello, " + p.Name
}
```

## Error Handling

```go
result, err := someFunction()
if err != nil {
    log.Fatal(err)
}
```

## Best Practices

1. Keep functions short and focused
2. Handle errors explicitly
3. Use goroutines for concurrency
4. Prefer composition over inheritance
5. Use gofmt for consistent formatting