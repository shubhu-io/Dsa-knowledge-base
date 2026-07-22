# Swift Object-Oriented Programming

## Overview

Swift supports both object-oriented and protocol-oriented programming. Its unique approach emphasizes value types (structs and enums) over reference types (classes), making it safer for concurrent programming. Protocol-oriented programming (POP) is Swift's distinctive paradigm, enabling composition over inheritance.

## Classes

```swift
class Person {
    let name: String
    var age: Int

    // Designated initializer
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }

    // Convenience initializer
    convenience init(name: String) {
        self.init(name: name, age: 0)
    }

    func describe() -> String {
        "\(name), age \(age)"
    }

    deinit {
        print("\(name) deallocated")
    }
}
```

## Structs (Value Types)

```swift
struct Point {
    let x: Double
    let y: Double

    // Memberwise initializer (auto-generated)
    func distanceTo(_ other: Point) -> Double {
        let dx = x - other.x
        let dy = y - other.y
        return (dx * dx + dy * dy).squareRoot()
    }

    static let zero = Point(x: 0, y: 0)
}

// Value semantics - copied on assignment
var p1 = Point(x: 1, y: 2)
var p2 = p1  // Independent copy
// p1.x = 5  // Would NOT affect p2

// Mutating methods
struct MutablePoint {
    var x: Double
    var y: Double

    mutating func moveBy(dx: Double, dy: Double) {
        x += dx
        y += dy
    }
}
```

## Protocols

```swift
// Protocol definition
protocol Drawable {
    func draw()
    var color: String { get set }
}

// Protocol with default implementation
extension Drawable {
    func drawWithBorder() {
        print("Border:")
        draw()
    }
}

// Protocol inheritance
protocol Shape: Drawable {
    func area() -> Double
    func perimeter() -> Double
}

// Protocol composition
func render(_ item: Drawable & CustomStringConvertible) {
    print(item.description)
    item.draw()
}

// Protocol with associated types
protocol Container {
    associatedtype Item
    mutating func push(_ item: Item)
    mutating func pop() -> Item?
    var count: Int { get }
}
```

## Extensions

```swift
// Extend existing types
extension Int {
    var squared: Int { self * self }
    var isEven: Bool { self % 2 == 0 }

    func times(_ action: () -> Void) {
        for _ in 0..<self { action() }
    }
}

// Protocol conformance via extension
extension Point: Equatable {
    static func == (lhs: Point, rhs: Point) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
}

extension Point: CustomStringConvertible {
    var description: String {
        "(\(x), \(y))"
    }
}

// Conditional extension
extension Array where Element: Numeric {
    func sum() -> Element {
        reduce(0, +)
    }
}
```

## Inheritance

```swift
// Base class
open class Vehicle {
    let make: String
    let model: String
    var mileage: Double = 0

    init(make: String, model: String) {
        self.make = make
        self.model = model
    }

    func drive(km: Double) {
        mileage += km
    }

    func describe() -> String {
        "\(make) \(model)"
    }
}

// Subclass
class ElectricCar: Vehicle {
    var batteryLevel: Double = 100.0

    override func drive(km: Double) {
        super.drive(km: km)
        batteryLevel -= km * 0.1
    }

    override func describe() -> String {
        "\(super.describe()) (Battery: \(batteryLevel)%)"
    }
}
```

## Value vs Reference Types

```swift
// Value type (struct) - independent copies
struct温度 {
    var celsius: Double

    var fahrenheit: Double {
        get { celsius * 9 / 5 + 32 }
        set { celsius = (newValue - 32) * 5 / 9 }
    }
}

var temp1 =温度(celsius: 20)
var temp2 = temp1   // Copy
temp2.celsius = 30
print(temp1.celsius)  // 20 (unchanged)

// Reference type (class) - shared reference
class Temperature {
    var celsius: Double

    init(celsius: Double) {
        self.celsius = celsius
    }

    var fahrenheit: Double {
        get { celsius * 9 / 5 + 32 }
        set { celsius = (newValue - 32) * 5 / 9 }
    }
}

let tempA = Temperature(celsius: 20)
let tempB = tempA   // Same instance
tempB.celsius = 30
print(tempA.celsius)  // 30 (same instance)
```

## ARC (Automatic Reference Counting)

```swift
// Strong reference - default, keeps object alive
class StrongExample {
    var name: String
    init(name: String) { self.name = name }
}

var strong1: StrongExample? = StrongExample(name: "Alice")
var strong2 = strong1  // Reference count = 2
strong1 = nil          // Reference count = 1
strong2 = nil          // Reference count = 0, deallocated

// Weak reference - doesn't increase reference count, becomes nil
class Parent {
    var child: Child?
}

class Child {
    weak var parent: Parent?  // Prevents retain cycle
    deinit { print("Child deallocated") }
}

// Unowned reference - like weak, but never nil (dangerous if deallocated)
class Tenant {
    unowned var landlord: Landlord  // Must outlive landlord
}
```

## Protocol-Oriented Programming

```swift
// Protocol with extensions for shared behavior
protocol Identifiable {
    var id: String { get }
}

extension Identifiable {
    var id: String { UUID().uuidString }
}

// Protocol with associated types
protocol Repository {
    associatedtype Item
    func fetch(id: String) -> Item?
    func save(_ item: Item)
    func delete(id: String)
}

// Protocol for view models
protocol ViewModelProtocol: ObservableObject {
    associatedtype State
    var state: State { get }
    func update()
}

// Protocol-oriented design
protocol Loggable {
    var logTag: String { get }
}

extension Loggable {
    var logTag: String { String(describing: self) }

    func log(_ message: String) {
        print("[\(logTag)] \(message)")
    }
}

struct UserService: Loggable {
    func fetchUser() {
        log("Fetching user...")
    }
}
```

## Enumerations

```swift
// Basic enum
enum Direction {
    case north, south, east, west

    var opposite: Direction {
        switch self {
        case .north: return .south
        case .south: return .north
        case .east: return .west
        case .west: return .east
        }
    }
}

// Enum with raw values
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

// Enum with associated values
enum NetworkResult {
    case success(data: Data)
    case failure(error: Error)
    case loading(progress: Double)
}

// Exhaustive pattern matching
func handleResult(_ result: NetworkResult) {
    switch result {
    case .success(let data):
        print("Received \(data.count) bytes")
    case .failure(let error):
        print("Error: \(error)")
    case .loading(let progress):
        print("Loading: \(Int(progress * 100))%")
    }
}

// Enum with computed properties
enum Planet: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune

    var name: String {
        switch self {
        case .mercury: return "Mercury"
        case .venus: return "Venus"
        case .earth: return "Earth"
        case .mars: return "Mars"
        case .jupiter: return "Jupiter"
        case .saturn: return "Saturn"
        case .uranus: return "Uranus"
        case .neptune: return "Neptune"
        }
    }

    var massKg: Double {
        switch self {
        case .earth: return 5.972e24
        case .mars: return 6.417e23
        // ... other planets
        default: return 0
        }
    }
}
```

## Generics

```swift
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

    func peek() -> Element? { items.last }
}

// Generic function with constraints
func findIndex<T: Equatable>(of value: T, in array: [T]) -> Int? {
    for (index, item) in array.enumerated() {
        if item == value { return index }
    }
    return nil
}

// Generic protocol
protocol Cacheable {
    associatedtype Key: Hashable
    associatedtype Value

    func get(_ key: Key) -> Value?
    func set(_ key: Key, value: Value)
}

// Using opaque types (some)
func makeCollection() -> some Collection<Int> {
    [1, 2, 3, 4, 5]
}

// Using existential types (any)
func process(_ item: any Drawable) {
    item.draw()
}
```

## Access Control

```swift
// public - accessible from anywhere
public class PublicClass {
    public var publicProp = "Visible everywhere"
    internal var internalProp = "Visible in same module"
    fileprivate var filePrivateProp = "Visible in same file"
    private var privateProp = "Visible only in this declaration"
}

// open - can be subclassed/overridden (classes only)
open class OpenClass {
    open func canOverride() -> String { "Overridable" }
    public func cannotOverride() -> String { "Not overridable" }
}

// private(set) - publicly readable, privately writable
class Counter {
    private(set) var count = 0

    func increment() {
        count += 1
    }
}
```

## See Also

- [[README]] - Swift overview
- [[Basics/syntax]] - Core language features
- [[Algorithms/String/string_algorithms]] - String algorithm implementations
- [[02-Data-Structures]] - Data structure implementations
