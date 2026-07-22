# Swift Basics Tutorial

## Variables and Constants

```swift
// Constants (immutable)
let name = "Alice"
let age = 30

// Variables (mutable)
var score = 100
score = 150

// Type annotations
let height: Double = 5.5
let isStudent: Bool = true

// String interpolation
let greeting = "Hello, \(name)!"
```

## Data Types

- **Int**: Integer numbers
- **Double/Float**: Decimal numbers
- **String**: Text
- **Bool**: True/False
- **Array**: Ordered collection
- **Dictionary**: Key-value pairs
- **Set**: Unique values

## Control Flow

### If-Else
```swift
if age >= 18 {
    print("Adult")
} else {
    print("Minor")
}
```

### Guard
```swift
func processAge(_ age: Int) {
    guard age >= 0 else {
        print("Invalid age")
        return
    }
    print("Age is \(age)")
}
```

### For Loop
```swift
for i in 0..<5 {
    print(i)
}
```

### Switch
```swift
switch day {
case "Monday":
    print("Start of week")
case "Friday":
    print("Almost weekend")
default:
    print("Midweek")
}
```

## Functions

```swift
// Basic function
func add(a: Int, b: Int) -> Int {
    return a + b
}

// Single expression
func multiply(a: Int, b: Int) -> Int {
    a * b
}

// Default parameters
func greet(name: String, greeting: String = "Hello") -> String {
    "\(greeting), \(name)!"
}
```

## Optionals

```swift
var name: String? = nil

// If-let
if let unwrappedName = name {
    print(unwrappedName)
}

// Guard-let
func greet(_ name: String?) {
    guard let name = name else {
        print("No name")
        return
    }
    print("Hello, \(name)")
}

// Nil coalescing
let displayName = name ?? "Unknown"
```

## Classes and Structs

```swift
// Struct
struct Point {
    var x: Double
    var y: Double
    
    func distance(to other: Point) -> Double {
        let dx = x - other.x
        let dy = y - other.y
        return sqrt(dx * dx + dy * dy)
    }
}

// Class
class Person {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    func greet() -> String {
        "Hello, I'm \(name)"
    }
}
```

## Protocols

```swift
protocol Drawable {
    func draw()
}

struct Circle: Drawable {
    var radius: Double
    
    func draw() {
        print("Drawing circle with radius \(radius)")
    }
}
```

## Error Handling

```swift
enum NetworkError: Error {
    case invalidURL
    case noData
}

func fetchData() throws -> Data {
    // Implementation
    throw NetworkError.invalidURL
}

do {
    let data = try fetchData()
} catch NetworkError.invalidURL {
    print("Invalid URL")
} catch {
    print("Error: \(error)")
}
```

## Best Practices

1. Use `let` over `var` when possible
2. Prefer value types (structs) over reference types (classes)
3. Use optionals safely with guard-let
4. Follow naming conventions (camelCase)