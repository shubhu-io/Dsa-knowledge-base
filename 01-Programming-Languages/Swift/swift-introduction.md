# Swift Introduction

## Why Learn Swift?
Swift is a modern, safe, and fast programming language developed by Apple for iOS, macOS, watchOS, and tvOS development. It's also gaining traction for server-side development.

## Key Features
- **Safety**: Type safety and memory safety
- **Performance**: Compiled language with optimizations
- **Modern Syntax**: Clean, expressive code
- **Protocol-Oriented**: Composition over inheritance
- **Playgrounds**: Interactive learning environment
- **Memory Management**: Automatic Reference Counting (ARC)
- **Cross-Platform**: iOS, macOS, Linux, Windows
- **Open Source**: Active community contributions

## Getting Started

### Installation
1. Install Xcode from Mac App Store (includes Swift)
2. Or install Swift.org for Linux/Windows
3. Verify: `swift --version`

### First Program
```swift
print("Hello, World!")
```

Save as `hello.swift` and run with `swift hello.swift`

## Basic Syntax

### Variables and Data Types
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

// Type inference
let pi = 3.14159  // inferred as Double

// String interpolation
let greeting = "Hello, \(name)!"

// Multi-line strings
let paragraph = """
    This is a
    multi-line string
    """
```

### Input/Output
```swift
// Output
print("Hello, World!")
print("Name: \(name), Age: \(age)")

// Input
print("Enter your name: ")
if let input = readLine() {
    print("Hello, \(input)!")
}
```

### Control Flow
```swift
// If-else
if age >= 18 {
    print("Adult")
} else {
    print("Minor")
}

// Guard statement
func processAge(_ age: Int) {
    guard age >= 0 else {
        print("Invalid age")
        return
    }
    print("Age is \(age)")
}

// For loop
for i in 0..<5 {
    print(i)
}

// Range-based
for i in 1...10 {
    print(i)
}

// While loop
var count = 5
while count > 0 {
    count -= 1
}

// Repeat-while (do-while)
repeat {
    print(count)
    count += 1
} while count < 5

// Switch
switch day {
case "Monday":
    print("Start of week")
case "Friday":
    print("Almost weekend")
case let d where d.contains("day"):
    print("Some day")
default:
    print("Midweek")
}
```

### Optionals
```swift
// Optional declaration
var name: String? = nil

// Unwrapping
// 1. If-let
if let unwrappedName = name {
    print(unwrappedName)
}

// 2. Guard-let
func greet(_ name: String?) {
    guard let name = name else {
        print("No name")
        return
    }
    print("Hello, \(name)")
}

// 3. Force unwrap (use cautiously)
let forcedName = name!

// 4. Nil coalescing
let displayName = name ?? "Unknown"

// 5. Optional chaining
let uppercased = name?.uppercased()
```

### Functions
```swift
// Basic function
func add(a: Int, b: Int) -> Int {
    return a + b
}

// Single expression
func multiply(a: Int, b: Int) -> Int {
    a * b
}

// External parameter names
func greet(person name: String) {
    print("Hello, \(name)")
}
greet(person: "Alice")

// Default parameters
func power(base: Int, exponent: Int = 2) -> Int {
    return Int(pow(Double(base), Double(exponent)))
}

// Variadic parameters
func sum(_ numbers: Int...) -> Int {
    numbers.reduce(0, +)
}

// In-out parameters
func swap(_ a: inout Int, _ b: inout Int) {
    let temp = a
    a = b
    b = temp
}

// Tuple return
func minMax(array: [Int]) -> (min: Int, max: Int)? {
    guard let min = array.min(), let max = array.max() else {
        return nil
    }
    return (min, max)
}
```

### Closures
```swift
// Basic closure
let greet = { (name: String) -> String in
    return "Hello, \(name)"
}

// Trailing closure
let numbers = [1, 2, 3, 4, 5]
let doubled = numbers.map { $0 * 2 }

// Sorting
let sorted = numbers.sorted { $0 < $1 }

// Capturing values
func makeCounter() -> () -> Int {
    var count = 0
    return {
        count += 1
        return count
    }
}
```

### Classes and Structures
```swift
// Structure
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
        return "Hello, I'm \(name)"
    }

    deinit {
        print("\(name) is being deallocated")
    }
}

// Inheritance
class Student: Person {
    var grade: String

    init(name: String, age: Int, grade: String) {
        self.grade = grade
        super.init(name: name, age: age)
    }

    override func greet() -> String {
        return "\(super.greet()), and I'm a student"
    }
}
```

### Protocols
```swift
// Protocol definition
protocol Drawable {
    func draw()
    var color: String { get set }
}

// Protocol extension
extension Drawable {
    func draw() {
        print("Drawing with \(color)")
    }
}

// Conformance
struct Circle: Drawable {
    var color: String
    var radius: Double
}

// Protocol inheritance
protocol Shape: Drawable {
    func area() -> Double
}

// Generic constraint
func drawAll<T: Drawable>(_ items: [T]) {
    items.forEach { $0.draw() }
}
```

### Enums
```swift
// Basic enum
enum Direction {
    case north, south, east, west
}

// Associated values
enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}

// Raw values
enum Planet: Int {
    case mercury = 1, venus, earth, mars
}

// Usage
let earth = Planet.earth
if let rawValue = Planet(rawValue: 3) {
    print(rawValue)
}

// Pattern matching
switch barcode {
case .upc(let system, let manufacturer, let product, let check):
    print("UPC: \(system)-\(manufacturer)-\(product)-\(check)")
case .qrCode(let code):
    print("QR: \(code)")
}
```

### Error Handling
```swift
// Error type
enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

// Throwing function
func fetchData(from urlString: String) throws -> Data {
    guard let url = URL(string: urlString) else {
        throw NetworkError.invalidURL
    }
    // Fetch data...
    return Data()
}

// Do-catch
do {
    let data = try fetchData(from: "https://example.com")
    print(data)
} catch NetworkError.invalidURL {
    print("Invalid URL")
} catch {
    print("Error: \(error)")
}

// Try?
let data = try? fetchData(from: "https://example.com")

// Try!
let forcedData = try! fetchData(from: "https://example.com")
```

### Extensions
```swift
// Extend existing type
extension String {
    var isPalindrome: Bool {
        let cleaned = self.lowercased().filter { $0.isLetter }
        return cleaned == String(cleaned.reversed())
    }
}

// Protocol conformance via extension
extension Circle: CustomStringConvertible {
    var description: String {
        return "Circle with radius \(radius)"
    }
}
```

### Generics
```swift
// Generic function
func swapTwo<T>(_ a: inout T, _ b: inout T) {
    let temp = a
    a = b
    b = temp
}

// Generic struct
struct Stack<Element> {
    private var items: [Element] = []

    mutating func push(_ item: Element) {
        items.append(item)
    }

    mutating func pop() -> Element? {
        items.popLast()
    }
}

// Generic constraint
func findIndex<T: Equatable>(of value: T, in array: [T]) -> Int? {
    for (index, item) in array.enumerated() {
        if item == value {
            return index
        }
    }
    return nil
}
```

## Best Practices
1. Use `let` over `var` when possible
2. Prefer value types (structs) over reference types (classes)
3. Use optionals safely with guard-let
4. Follow naming conventions (camelCase)
5. Use extensions to organize code
6. Write protocol-oriented code
7. Use meaningful variable names

## Common Pitfalls
- Force unwrapping optionals
- Retain cycles with closures
- Confusing `==` with `===`
- Not handling errors properly
- Overusing classes instead of structs