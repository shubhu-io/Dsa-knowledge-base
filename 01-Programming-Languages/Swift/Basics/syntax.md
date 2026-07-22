# Swift Syntax

## Overview

Swift combines modern language features with safety and performance. This guide covers the core syntax and features you need to write idiomatic Swift.

## Constants and Variables

```swift
// let - immutable (constant)
let name = "Swift"           // Type inferred as String
let age: Int = 25            // Explicit type
let pi = 3.14159             // Double by default

// var - mutable (variable)
var counter = 0
counter = 1                  // Allowed because var

// Type annotations
let label: String = "Hello"
let width: Double = 100.0
let isReady: Bool = true

// Multiple declarations
let (x, y) = (10, 20)
```

## Optionals

Swift's most distinctive feature for handling missing values:

```swift
// Optional declaration
var middleName: String? = nil  // Can hold String or nil

// Unwrapping optionals
let nameLength = middleName?.count   // Returns Int? (nil if middleName is nil)

// Force unwrap (dangerous - crashes if nil)
// let length = middleName!.count    // Avoid this!

// if let - safe unwrapping
if let name = middleName {
    print("Middle name: \(name)")
} else {
    print("No middle name")
}

// guard let - early exit
func greet(middleName: String?) {
    guard let name = middleName else {
        print("No middle name provided")
        return
    }
    print("Hello, \(name)!")
}

// nil coalescing operator (??) - provide default
let displayName = middleName ?? "N/A"

// Optional chaining
struct Address {
    var city: String
}

struct Person {
    var address: Address?
}

let person = Person(address: Address(city: "Portland"))
let city = person.address?.city ?? "Unknown"

// Optional map
let numbers: [Int?] = [1, nil, 3, nil, 5]
let doubled = numbers.compactMap { $0?.multiplied(by: 2) }  // [2, 6, 10]
```

## Data Types

```swift
// Basic types
let integer: Int = 42
let double: Double = 3.14
let float: Float = 3.14
let string: String = "Hello"
let bool: Bool = true

// Type inference
let inferredInt = 42          // Int
let inferredDouble = 3.14     // Double

// Type aliases
typealias AudioSample = UInt16
let sample: AudioSample = 32767

// Tuples
let httpStatus = (200, "OK")
print(httpStatus.0)           // 200
print(httpStatus.1)           // "OK"

// Named tuple components
let httpStatusNamed = (code: 200, message: "OK")
print(httpStatusNamed.code)   // 200
```

## Collections

```swift
// Array
var numbers = [1, 2, 3, 4, 5]
var names: [String] = ["Alice", "Bob"]
var emptyArray: [Int] = []

numbers.append(6)
numbers.insert(0, at: 0)
numbers.remove(at: 0)
numbers.contains(3)           // true

// Set (unordered, unique)
var fruits: Set<String> = ["Apple", "Banana", "Cherry"]
fruits.insert("Date")
fruits.contains("Apple")     // true

// Set operations
let setA: Set = [1, 2, 3]
let setB: Set = [2, 3, 4]
setA.union(setB)              // {1, 2, 3, 4}
setA.intersection(setB)      // {2, 3}
setA.subtracting(setB)       // {1}

// Dictionary
var ages: [String: Int] = ["Alice": 30, "Bob": 25]
ages["Charlie"] = 35
ages["Alice"]                 // 30 (optional)
ages.removeValue(forKey: "Bob")

// Dictionary with default
let defaultValue = ages["Unknown", default: 0]
```

## Control Flow

```swift
// if/else
if temperature > 30 {
    print("Hot!")
} else if temperature > 20 {
    print("Warm")
} else {
    print("Cold")
}

// switch (exhaustive, no fallthrough by default)
let grade = "A"
switch grade {
case "A":
    print("Excellent")
case "B":
    print("Good")
case "C":
    print("Average")
default:
    print("Other")
}

// Pattern matching in switch
let point = (1, 1)
switch point {
case (0, 0):
    print("Origin")
case (_, 0):
    print("On x-axis")
case (0, _):
    print("On y-axis")
case (-2...2, -2...2):
    print("Inside 2x2 box")
default:
    print("Outside")
}

// for-in loop
for i in 1...5 {
    print(i)
}

// where clause
for i in 1...10 where i % 2 == 0 {
    print(i)  // Only even numbers
}

// while
var n = 5
while n > 0 {
    print(n)
    n -= 1
}

// repeat-while (do-while)
repeat {
    print(n)
    n += 1
} while n < 5
```

## Functions

```swift
// Basic function
func greet(name: String) -> String {
    return "Hello, \(name)!"
}

// Single expression (implicit return)
func double(_ x: Int) -> Int { x * 2 }

// Multiple return values
func minMax(array: [Int]) -> (min: Int, max: Int)? {
    guard let min = array.min(), let max = array.max() else {
        return nil
    }
    return (min, max)
}

// Variadic parameters
func average(_ numbers: Double...) -> Double {
    let total = numbers.reduce(0, +)
    return total / Double(numbers.count)
}

// Inout parameters
func swapValues(_ a: inout Int, _ b: inout Int) {
    let temp = a
    a = b
    b = temp
}

// Default parameters
func power(_ base: Int, exponent: Int = 2) -> Int {
    var result = 1
    for _ in 0..<exponent {
        result *= base
    }
    return result
}

// Usage
print(greet(name: "World"))
print(double(5))
print(average(1, 2, 3, 4, 5))

var x = 10, y = 20
swapValues(&x, &y)
print(power(3))          // 9
print(power(2, exponent: 10))  // 1024
```

## Closures

```swift
// Full closure syntax
let multiply = { (a: Int, b: Int) -> Int in
    return a * b
}

// Shorthand argument names ($0, $1)
let sorted = [3, 1, 4, 1, 5].sorted { $0 < $1 }

// Trailing closure syntax
let doubled = [1, 2, 3].map { $0 * 2 }

// Multiple trailing closures
UIView.animate(withDuration: 0.3, animations: {
    view.alpha = 0
}, completion: { _ in
    view.removeFromSuperview()
})

// Closure as function parameter
func perform(_ operation: (Int, Int) -> Int, on a: Int, and b: Int) -> Int {
    return operation(a, b)
}

let result = perform(+, on: 5, and: 3)  // 8
let sum = perform({ $0 + $1 }, on: 10, and: 20)  // 30

// @escaping closures
func fetch(completion: @escaping (String) -> Void) {
    DispatchQueue.global().async {
        completion("Data loaded")
    }
}
```

## Structs vs Classes

```swift
// Struct (value type)
struct Point {
    let x: Double
    let y: Double

    func distanceTo(_ other: Point) -> Double {
        let dx = x - other.x
        let dy = y - other.y
        return (dx * dx + dy * dy).squareRoot()
    }
}

// Class (reference type)
class Person {
    let name: String
    var age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }

    func birthday() {
        age += 1
    }
}

// Struct: copied on assignment
var p1 = Point(x: 1, y: 2)
var p2 = p1  // Copy
// p2.x = 5  // Would create independent copy

// Class: shared reference
let person1 = Person(name: "Alice", age: 30)
let person2 = person1  // Same instance
person2.age = 31       // person1.age is also 31
```

## Protocols

```swift
// Protocol definition
protocol Describable {
    var description: String { get }
    func describe()
}

// Protocol with default implementation
extension Describable {
    func describe() {
        print(description)
    }
}

// Protocol with multiple requirements
protocol Drawable: Describable {
    func draw()
    func area() -> Double
}

// Protocol composition
func render(_ item: Drawable & Describable) {
    item.draw()
    item.describe()
}
```

## Generics

```swift
// Generic function
func findIndex<T: Equatable>(of value: T, in array: [T]) -> Int? {
    for (index, item) in array.enumerated() {
        if item == value {
            return index
        }
    }
    return nil
}

// Generic struct
struct Stack<Element> {
    private var items: [Element] = []

    var count: Int { items.count }
    var isEmpty: Bool { items.isEmpty }

    mutating func push(_ item: Element) {
        items.append(item)
    }

    mutating func pop() -> Element? {
        items.popLast()
    }

    func peek() -> Element? {
        items.last
    }
}

// Generic with constraints
func largest<T: Comparable>(_ a: T, _ b: T) -> T {
    a >= b ? a : b
}

// Usage
var intStack = Stack<Int>()
intStack.push(1)
intStack.push(2)
print(intStack.pop())  // Optional(2)

print(largest(10, 20))  // 20
print(largest("abc", "xyz"))  // "xyz"
```

## Error Handling

```swift
enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingFailed(String)
    case serverError(statusCode: Int)
}

func fetchData(from urlString: String) throws -> Data {
    guard let url = URL(string: urlString) else {
        throw NetworkError.invalidURL
    }
    // In real code, use URLSession
    guard let data = try? Data(contentsOf: url) else {
        throw NetworkError.noData
    }
    return data
}

// do-catch
do {
    let data = try fetchData(from: "https://example.com")
    print("Received \(data.count) bytes")
} catch NetworkError.invalidURL {
    print("Invalid URL")
} catch NetworkError.serverError(let code) {
    print("Server error: \(code)")
} catch {
    print("Unexpected error: \(error)")
}

// try? (converts to optional)
let data = try? fetchData(from: "https://example.com")

// try! (force unwrap - crashes on error)
// let data = try! fetchData(from: "https://example.com")
```

## Property Wrappers

```swift
@propertyWrapper
struct Clamped<Value: Comparable> {
    private var value: Value
    private let range: ClosedRange<Value>

    init(wrappedValue: Value, _ range: ClosedRange<Value>) {
        self.range = range
        self.value = min(max(wrappedValue, range.lowerBound), range.upperBound)
    }

    var wrappedValue: Value {
        get { value }
        set { value = min(max(newValue, range.lowerBound), range.upperBound) }
    }
}

@propertyWrapper
struct Trimmed {
    private var value: String

    init(wrappedValue: String) {
        self.value = wrappedValue.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var wrappedValue: String {
        get { value }
        set { value = newValue.trimmingCharacters(in: .whitespacesAndNewlines) }
    }

    var projectedValue: String {
        value.lowercased()
    }
}

struct UserSettings {
    @Clamped(0...100) var volume: Int = 50
    @Clamped(1...16) var brightness: Int = 8
    @Trimmed var username: String = "  Alice  "
}

let settings = UserSettings()
print(settings.volume)           // 50
print(settings.username)         // "Alice"
print(settings.$username)        // "alice" (projected value)
```

## Result Builders

```swift
@resultBuilder
struct ArrayBuilder {
    static func buildBlock(_ components: Int...) -> [Int] {
        components
    }

    static func buildOptional(_ component: [Int]?) -> [Int] {
        component ?? []
    }

    static func buildEither(first component: [Int]) -> [Int] {
        component
    }

    static func buildEither(second component: [Int]) -> [Int] {
        component
    }
}

@ArrayBuilder
func makeArray(includeExtra: Bool) -> [Int] {
    1
    2
    3
    if includeExtra {
        4
        5
    }
}

print(makeArray(includeExtra: true))   // [1, 2, 3, 4, 5]
print(makeArray(includeExtra: false))  // [1, 2, 3]
```

## Extensions

```swift
// Extend existing types
extension String {
    var isPalindrome: Bool {
        let cleaned = self.lowercased().filter { $0.isLetter }
        return cleaned == String(cleaned.reversed())
    }

    func wordCount() -> Int {
        self.split(separator: " ").count
    }
}

extension Int {
    var squared: Int { self * self }
    var isEven: Bool { self % 2 == 0 }

    func times(_ action: () -> Void) {
        for _ in 0..<self {
            action()
        }
    }
}

// Usage
print("Racecar".isPalindrome)     // true
print("Hello World".wordCount())  // 2
print(5.squared)                  // 25
3.times { print("Hello!") }       // Prints 3 times
```

## Optional Pattern Matching

```swift
// Optional in arrays
let numbers: [Int?] = [1, nil, 3, nil, 5]

// compactMap removes nils
let validNumbers = numbers.compactMap { $0 }  // [1, 3, 5]

// Optional in dictionaries
let responses = ["Alice": 200, "Bob": 404, "Charlie": nil]
for (name, code) in responses {
    switch code {
    case .some(let code) where code == 200:
        print("\(name) succeeded")
    case .some(let code):
        print("\(name) got \(code)")
    case .none:
        print("\(name) had no response")
    }
}
```

## Type Casting

```swift
class MediaItem {
    var name: String
    init(name: String) { self.name = name }
}

class Movie: MediaItem {
    var director: String
    init(name: String, director: String) {
        self.director = director
        super.init(name: name)
    }
}

class Song: MediaItem {
    var artist: String
    init(name: String, artist: String) {
        self.artist = artist
        super.init(name: name)
    }
}

let library: [MediaItem] = [
    Movie(name: "Alien", director: "Scott"),
    Song(name: "Bohemian Rhapsody", artist: "Queen")
]

// is - type check
for item in library {
    if item is Movie {
        print("\(item.name) is a movie")
    }
}

// as? - conditional downcast
for item in library {
    if let movie = item as? Movie {
        print("\(movie.name) directed by \(movie.director)")
    }
}

// as! - forced downcast (crashes if wrong)
// let movie = library[0] as! Movie
```

## See Also

- [[README]] - Swift overview
- [[OOP/oop]] - Object-oriented and protocol-oriented programming in Swift
- [[Algorithms/String/string_algorithms]] - String algorithm implementations
- [[02-Data-Structures]] - Data structure implementations
