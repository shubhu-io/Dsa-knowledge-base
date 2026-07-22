# Object-Oriented Programming in Go

## Overview
Go takes a different approach to object-oriented programming compared to traditional OOP languages. It doesn't have classes, inheritance, or constructors. Instead, Go uses interfaces, struct embedding, and composition to achieve similar goals while emphasizing simplicity and explicit behavior.

## Key Differences from Traditional OOP

| Feature | Traditional OOP | Go |
|---------|----------------|-----|
| Classes | Yes | No (use structs) |
| Inheritance | Yes | No (use composition) |
| Constructors | Yes | No (use factory functions) |
| Destructors | Yes (finalizers) | No (use defer/cleanup) |
| Polymorphism | Via inheritance | Via interfaces |
| Encapsulation | Access modifiers | Package-level visibility |

## Structs as Data Types
Go structs are like classes without methods attached by default:

```go
// Struct definition
type Person struct {
    Name    string
    Age     int
    private string  // Unexported field
}

// Constructor-like function (factory pattern)
func NewPerson(name string, age int) *Person {
    return &Person{Name: name, Age: age}
}

// Method with value receiver (doesn't modify)
func (p Person) Greet() string {
    return "Hello, I'm " + p.Name
}

// Method with pointer receiver (can modify)
func (p *Person) HaveBirthday() {
    p.Age++
}
```

## Interfaces as Contracts
Interfaces define behavior implicitly - any type that implements the methods satisfies the interface:

```go
// Interface definition
type Animal interface {
    Speak() string
    Move() string
}

// Implementation (implicit - no "implements" keyword)
type Dog struct {
    Name string
}

func (d Dog) Speak() string {
    return "Woof!"
}

func (d Dog) Move() string {
    return "Runs on four legs"
}

// Another implementation
type Cat struct {
    Name string
}

func (c Cat) Speak() string {
    return "Meow!"
}

func (c Cat) Move() string {
    return "Sneaks silently"
}

// Function accepting interface
func DescribeAnimal(a Animal) {
    fmt.Printf("Sound: %s, Movement: %s\n", a.Speak(), a.Move())
}
```

## Struct Embedding (Composition)
Go achieves code reuse through struct embedding rather than inheritance:

```go
// Base "type" (not really a base class)
type Animal struct {
    Name string
}

func (a Animal) Speak() string {
    return "..."
}

// Embedded struct
type Dog struct {
    Animal  // Embedded field
    Breed   string
}

func main() {
    d := Dog{
        Animal: Animal{Name: "Rex"},
        Breed:  "German Shepherd",
    }
    
    // Promoted methods - can call directly
    fmt.Println(d.Speak())  // From Animal
    fmt.Println(d.Name)     // Promoted field
    
    // Explicit access
    fmt.Println(d.Animal.Speak())
}
```

## Duck Typing
Go uses structural typing - if it quacks like a duck, it's a duck:

```go
type Quacker interface {
    Quack() string
}

type Duck struct{}
func (d Duck) Quack() string { return "Quack!" }

type Person struct{}
func (p Person) Quack() string { return "I'm quacking like a duck!" }

func MakeItQuack(q Quacker) {
    fmt.Println(q.Quack())
}

func main() {
    MakeItQuack(Duck{})    // Works
    MakeItQuack(Person{})  // Also works!
}
```

## Composition Over Inheritance
Go strongly favors composition:

```go
// Instead of inheritance, compose behaviors
type Logger struct{}
func (l Logger) Log(msg string) { fmt.Println("LOG:", msg) }

type Authenticator struct{}
func (a Authenticator) Authenticate(user string) bool { return user != "" }

// Compose into a service
type UserService struct {
    Logger        // Embedded
    Authenticator // Embedded
    users         map[string]string
}

func (s *UserService) Login(user, pass string) error {
    s.Log("Attempting login for " + user)  // Promoted method
    if !s.Authenticate(user) {
        return errors.New("auth failed")
    }
    return nil
}
```

## Benefits of Go's Approach
1. **Explicit dependencies**: No hidden inheritance chains
2. **Simple composition**: Easy to understand and refactor
3. **Implicit interfaces**: Loose coupling between packages
4. **No diamond problem**: Composition avoids multiple inheritance issues
5. **Easy to test**: Simple to mock interfaces

## Common Patterns

### Interface Segregation
```go
// Small, focused interfaces
type Reader interface {
    Read(p []byte) (n int, err error)
}

type Writer interface {
    Write(p []byte) (n int, err error)
}

// Compose larger interfaces
type ReadWriter interface {
    Reader
    Writer
}
```

### Builder Pattern
```go
type Server struct {
    host string
    port int
    tls  bool
}

type ServerBuilder struct {
    server Server
}

func NewServerBuilder() *ServerBuilder {
    return &ServerBuilder{server: Server{host: "localhost", port: 8080}}
}

func (b *ServerBuilder) Host(h string) *ServerBuilder {
    b.server.host = h
    return b
}

func (b *ServerBuilder) Port(p int) *ServerBuilder {
    b.server.port = p
    return b
}

func (b *ServerBuilder) Build() *Server {
    return &b.server
}

// Usage
server := NewServerBuilder().
    Host("example.com").
    Port(443).
    Build()
```

## Example: Shape Hierarchy
See `oop.go` for a complete example demonstrating Go's composition approach to shapes.

## See Also
- [[syntax.md|Go Syntax]]
- [[../Algorithms/String/string_algorithms.go|String Algorithms]]
- [Effective Go: Objects](https://go.dev/doc/effective_go#objects)
- [Go Wiki: Interface embedded](https://go.dev/wiki/InterfaceEmbedding)