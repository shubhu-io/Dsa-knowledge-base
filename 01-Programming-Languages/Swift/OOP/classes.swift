import Foundation

// ============================================================
// Shape Hierarchy in Swift - Protocol-Oriented Approach
// ============================================================

// MARK: - Protocols

/// Base protocol for anything that can be drawn
protocol Drawable {
    func draw()
    var description: String { get }
}

/// Protocol for measurable shapes
protocol Measurable: Drawable {
    func area() -> Double
    func perimeter() -> Double
}

/// Protocol for shapes that can be transformed
protocol Transformable {
    func scaled(by factor: Double) -> Self
    func translated(dx: Double, dy: Double) -> Self
}

/// Protocol for shapes that contain points
protocol ShapeContainable {
    func contains(point: Point) -> Bool
}

// MARK: - Data Types

/// Value type representing a 2D point
struct Point: Equatable, CustomStringConvertible {
    let x: Double
    let y: Double

    var description: String { "(\(x), \(y))" }

    func distanceTo(_ other: Point) -> Double {
        let dx = x - other.x
        let dy = y - other.y
        return (dx * dx + dy * dy).squareRoot()
    }

    static let zero = Point(x: 0, y: 0)
}

/// Value type representing a rectangle (axis-aligned)
struct Rect: Equatable {
    let origin: Point
    let size: Size

    struct Size: Equatable {
        let width: Double
        let height: Double
    }

    var minX: Double { origin.x }
    var minY: Double { origin.y }
    var maxX: Double { origin.x + size.width }
    var maxY: Double { origin.y + size.height }
    var centerX: Double { origin.x + size.width / 2 }
    var centerY: Double { origin.y + size.height / 2 }
}

// MARK: - Struct-Based Shapes (Value Types)

/// Circle as a value type
struct Circle: Measurable, Transformable, ShapeContainable {
    let center: Point
    let radius: Double
    var color: String

    init(center: Point = .zero, radius: Double, color: String = "red") {
        precondition(radius > 0, "Radius must be positive")
        self.center = center
        self.radius = radius
        self.color = color
    }

    // Measurable
    var description: String {
        "Circle(center: \(center), radius: \(radius), color: \(color))"
    }

    func draw() {
        print("Drawing circle: center=\(center), radius=\(radius)")
    }

    func area() -> Double {
        Double.pi * radius * radius
    }

    func perimeter() -> Double {
        2 * Double.pi * radius
    }

    // Transformable
    func scaled(by factor: Double) -> Circle {
        Circle(center: center, radius: radius * factor, color: color)
    }

    func translated(dx: Double, dy: Double) -> Circle {
        Circle(
            center: Point(x: center.x + dx, y: center.y + dy),
            radius: radius,
            color: color
        )
    }

    // ShapeContainable
    func contains(point: Point) -> Bool {
        center.distanceTo(point) <= radius
    }
}

/// Rectangle as a value type
struct Rectangle: Measurable, Transformable, ShapeContainable {
    let origin: Point
    let width: Double
    let height: Double
    var color: String

    init(origin: Point = .zero, width: Double, height: Double, color: String = "blue") {
        precondition(width > 0 && height > 0, "Dimensions must be positive")
        self.origin = origin
        self.width = width
        self.height = height
        self.color = color
    }

    var description: String {
        "Rectangle(origin: \(origin), \(width)x\(height), color: \(color))"
    }

    func draw() {
        print("Drawing rectangle: \(width)x\(height) at \(origin)")
    }

    func area() -> Double { width * height }

    func perimeter() -> Double { 2 * (width + height) }

    func isSquare() -> Bool { width == height }

    func scaled(by factor: Double) -> Rectangle {
        Rectangle(
            origin: origin,
            width: width * factor,
            height: height * factor,
            color: color
        )
    }

    func translated(dx: Double, dy: Double) -> Rectangle {
        Rectangle(
            origin: Point(x: origin.x + dx, y: origin.y + dy),
            width: width,
            height: height,
            color: color
        )
    }

    func contains(point: Point) -> Bool {
        point.x >= origin.x && point.x <= origin.x + width &&
        point.y >= origin.y && point.y <= origin.y + height
    }
}

/// Square - specialized rectangle
struct Square: Measurable, Transformable, ShapeContainable {
    let origin: Point
    let side: Double
    var color: String

    init(origin: Point = .zero, side: Double, color: String = "green") {
        self.origin = origin
        self.side = side
        self.color = color
    }

    var description: String {
        "Square(origin: \(origin), side: \(side), color: \(color))"
    }

    func draw() {
        print("Drawing square: side=\(side) at \(origin)")
    }

    func area() -> Double { side * side }
    func perimeter() -> Double { 4 * side }

    func scaled(by factor: Double) -> Square {
        Square(origin: origin, side: side * factor, color: color)
    }

    func translated(dx: Double, dy: Double) -> Square {
        Square(
            origin: Point(x: origin.x + dx, y: origin.y + dy),
            side: side,
            color: color
        )
    }

    func contains(point: Point) -> Bool {
        point.x >= origin.x && point.x <= origin.x + side &&
        point.y >= origin.y && point.y <= origin.y + side
    }
}

/// Triangle as a value type
struct Triangle: Measurable, Transformable {
    let a: Point
    let b: Point
    let c: Point
    var color: String

    init(a: Point, b: Point, c: Point, color: String = "yellow") {
        self.a = a
        self.b = b
        self.c = c
        self.color = color
    }

    var description: String {
        "Triangle(\(a), \(b), \(c), color: \(color))"
    }

    func draw() {
        print("Drawing triangle: \(a) -> \(b) -> \(c)")
    }

    func area() -> Double {
        abs((a.x * (b.y - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y)) / 2)
    }

    func perimeter() -> Double {
        a.distanceTo(b) + b.distanceTo(c) + c.distanceTo(a)
    }

    func scaled(by factor: Double) -> Triangle {
        Triangle(
            a: Point(x: a.x * factor, y: a.y * factor),
            b: Point(x: b.x * factor, y: b.y * factor),
            c: Point(x: c.x * factor, y: c.y * factor),
            color: color
        )
    }

    func translated(dx: Double, dy: Double) -> Triangle {
        Triangle(
            a: Point(x: a.x + dx, y: a.y + dy),
            b: Point(x: b.x + dx, y: b.y + dy),
            c: Point(x: c.x + dx, y: c.y + dy),
            color: color
        )
    }

    /// Factory method for equilateral triangle
    static func equilateral(side: Double, center: Point = .zero, color: String = "white") -> Triangle {
        let height = side * sqrt(3) / 2
        let a = Point(x: center.x, y: center.y + height / 3)
        let b = Point(x: center.x - side / 2, y: center.y - height / 3)
        let c = Point(x: center.x + side / 2, y: center.y - height / 3)
        return Triangle(a: a, b: b, c: c, color: color)
    }
}

// MARK: - Class-Based Shape (Reference Type)

/// Example of a class-based shape (reference type)
/// for comparison with struct-based approach
class DrawableShape: Measurable {
    let name: String
    var color: String

    init(name: String, color: String = "black") {
        self.name = name
        self.color = color
    }

    var description: String { "\(name) (color: \(color))" }
    func draw() { print("Drawing \(name)") }
    func area() -> Double { 0 }
    func perimeter() -> Double { 0 }
}

// MARK: - Protocol Extensions

extension Drawable {
    func drawWithLabel() {
        print("[\(description)]")
        draw()
    }
}

extension Measurable {
    func describe() -> String {
        "\(description) - Area: \(String(format: "%.2f", area())), Perimeter: \(String(format: "%.2f", perimeter()))"
    }
}

// MARK: - Collection Extensions

extension Collection where Element: Measurable {
    func totalArea() -> Double {
        reduce(0) { $0 + $1.area() }
    }

    func largestShape() -> Element? {
        max(by: { $0.area() < $1.area() })
    }

    func sortedByArea() -> [Element] {
        sorted { $0.area() > $1.area() }
    }
}

// MARK: - Generic Shape Container

/// Generic container for any Measurable type
struct ShapeCollection<T: Measurable> {
    private var shapes: [T] = []

    mutating func add(_ shape: T) {
        shapes.append(shape)
    }

    var count: Int { shapes.count }
    var isEmpty: Bool { shapes.isEmpty }

    func totalArea() -> Double {
        shapes.reduce(0) { $0 + $1.area() }
    }

    func filter(by predicate: (T) -> Bool) -> [T] {
        shapes.filter(predicate)
    }
}

// MARK: - Factory Pattern

struct ShapeFactory {
    enum ShapeType {
        case circle(radius: Double)
        case rectangle(width: Double, height: Double)
        case square(side: Double)
        case triangle(a: Point, b: Point, c: Point)
    }

    static func create(type: ShapeType, color: String = "default") -> any Measurable {
        switch type {
        case .circle(let radius):
            return Circle(radius: radius, color: color)
        case .rectangle(let width, let height):
            return Rectangle(width: width, height: height, color: color)
        case .square(let side):
            return Square(side: side, color: color)
        case .triangle(let a, let b, let c):
            return Triangle(a: a, b: b, c: c, color: color)
        }
    }
}

// MARK: - Demo / Main

print("=== Swift OOP Classes Demo ===\n")

// Create shapes
let circle = Circle(center: Point(x: 5, y: 5), radius: 3, color: "crimson")
let rectangle = Rectangle(width: 4, height: 6, color: "navy")
let square = Square(side: 3, color: "emerald")
let triangle = Triangle(
    a: Point(x: 0, y: 0),
    b: Point(x: 4, y: 0),
    c: Point(x: 2, y: 3),
    color: "gold"
)

let shapes: [any Measurable] = [circle, rectangle, square, triangle]

// Draw all shapes
print("--- Drawing Shapes ---")
shapes.forEach { shape in
    shape.draw()
}

// Print report
print("\n--- Shape Report ---")
shapes.forEach { shape in
    print("  \(shape.describe())")
}

let totalArea = shapes.totalArea()
print("  Total area: \(String(format: "%.2f", totalArea))")

// Value semantics demo
print("\n--- Value Semantics ---")
var circle1 = circle
let circle2 = circle1
// circle1.color = "purple"  // Would create independent copy
print("Circle 1: \(circle1)")
print("Circle 2: \(circle2)")

// Transform demo
print("\n--- Transformations ---")
let scaledCircle = circle.scaled(by: 2)
print("Original circle: radius=\(circle.radius)")
print("Scaled circle: radius=\(scaledCircle.radius)")

let movedRect = rectangle.translated(dx: 10, dy: 5)
print("Original rect origin: \(rectangle.origin)")
print("Moved rect origin: \(movedRect.origin)")

// Factory pattern
print("\n--- Factory Pattern ---")
let factoryCircle = ShapeFactory.create(type: .circle(radius: 5), color: "red")
let factoryRect = ShapeFactory.create(type: .rectangle(width: 10, height: 20), color: "blue")
print("Factory circle: \(factoryCircle.describe())")
print("Factory rect: \(factoryRect.describe())")

// Generic collection
print("\n--- Generic Collection ---")
var collection = ShapeCollection<Circle>()
collection.add(Circle(radius: 1))
collection.add(Circle(radius: 2))
collection.add(Circle(radius: 3))
print("Collection count: \(collection.count)")
print("Total area: \(String(format: "%.2f", collection.totalArea()))")

// Protocol extension
print("\n--- Protocol Extension ---")
print(circle.drawWithLabel())  // Uses extension

// Equilateral triangle
print("\n--- Equilateral Triangle ---")
let equiTriangle = Triangle.equilateral(side: 4, color: "purple")
print("Equilateral triangle: \(equiTriangle.describe())")

// Shape containment
print("\n--- Shape Containment ---")
let testPoint = Point(x: 2, y: 2)
print("Circle contains \(testPoint): \(circle.contains(point: testPoint))")
print("Rectangle contains \(testPoint): \(rectangle.contains(point: testPoint))")
print("Square contains \(testPoint): \(square.contains(point: testPoint))")
