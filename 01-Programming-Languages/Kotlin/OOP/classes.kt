package oop.classes

import kotlin.math.PI
import kotlin.math.sqrt

/**
 * Shape Hierarchy in Kotlin OOP
 * 
 * Demonstrates: interfaces, abstract classes, sealed classes, data classes,
 * object declarations, companion objects, inheritance, and polymorphism.
 */

// ============================================================
// Interface
// ============================================================

interface Drawable {
    fun draw()
    val description: String
}

interface Measurable {
    fun area(): Double
    fun perimeter(): Double
}

// ============================================================
// Abstract Class
// ============================================================

abstract class Shape : Drawable, Measurable {
    abstract val name: String
    var color: String = "black"
        protected set

    fun describe(): String {
        return "$name (color=$color, area=${"%.2f".format(area())}, " +
               "perimeter=${"%.2f".format(perimeter())})"
    }

    override fun toString(): String = describe()
}

// ============================================================
// Sealed Class for Shape Variants
// ============================================================

sealed class ShapeType {
    object Circle : ShapeType()
    object Square : ShapeType()
    data class Triangle(val sides: List<Double>) : ShapeType()
}

// ============================================================
// Concrete Classes
// ============================================================

class Circle(
    val radius: Double,
    color: String = "red"
) : Shape() {

    init {
        require(radius > 0) { "Radius must be positive" }
    }

    override val name = "Circle"
    override val description = "Circle with radius $radius"

    init {
        this.color = color  // Set through protected setter
    }

    override fun area(): Double = PI * radius * radius

    override fun perimeter(): Double = 2 * PI * radius

    override fun draw() {
        println("Drawing circle: radius=$radius, area=${"%.2f".format(area())}")
    }
}

class Rectangle(
    val width: Double,
    val height: Double,
    color: String = "blue"
) : Shape() {

    init {
        require(width > 0 && height > 0) { "Dimensions must be positive" }
    }

    override val name = "Rectangle"
    override val description = "Rectangle ${width}x${height}"

    init {
        this.color = color
    }

    override fun area(): Double = width * height

    override fun perimeter(): Double = 2 * (width + height)

    override fun draw() {
        println("Drawing rectangle: ${width}x${height}, area=${"%.2f".format(area())}")
    }

    // Square is a special rectangle
    fun isSquare(): Boolean = width == height
}

class Square(
    side: Double,
    color: String = "green"
) : Rectangle(side, side, color) {

    override val name = "Square"
    override val description = "Square with side $side"

    val side: Double get() = width  // Delegate to width

    override fun draw() {
        println("Drawing square: side=$side, area=${"%.2f".format(area())}")
    }
}

class Triangle(
    val a: Double,
    val b: Double,
    val c: Double,
    color: String = "yellow"
) : Shape() {

    init {
        require(a > 0 && b > 0 && c > 0) { "Sides must be positive" }
        require(a + b > c && b + c > a && a + c > b) { "Invalid triangle sides" }
    }

    override val name = "Triangle"
    override val description = "Triangle ($a, $b, $c)"

    init {
        this.color = color
    }

    override fun area(): Double {
        val s = (a + b + c) / 2
        return sqrt(s * (s - a) * (s - b) * (s - c)) // Heron's formula
    }

    override fun perimeter(): Double = a + b + c

    override fun draw() {
        println("Drawing triangle: ($a, $b, $c), area=${"%.2f".format(area())}")
    }

    companion object {
        fun equilateral(side: Double, color: String = "white"): Triangle {
            return Triangle(side, side, side, color)
        }

        fun right(a: Double, b: Double, color: String = "white"): Triangle {
            val c = sqrt(a * a + b * b)
            return Triangle(a, b, c, color)
        }
    }
}

// ============================================================
// Data Class
// ============================================================

data class Point(val x: Double, val y: Double) {
    fun distanceTo(other: Point): Double {
        val dx = this.x - other.x
        val dy = this.y - other.y
        return sqrt(dx * dx + dy * dy)
    }

    fun midpoint(other: Point): Point {
        return Point((this.x + other.x) / 2, (this.y + other.y) / 2)
    }

    companion object {
        val ORIGIN = Point(0.0, 0.0)
    }
}

// ============================================================
// Object Declaration (Singleton)
// ============================================================

object ShapeFactory {
    private var circleCount = 0
    private var rectangleCount = 0
    private var triangleCount = 0

    fun createCircle(radius: Double, color: String = "red"): Circle {
        circleCount++
        return Circle(radius, color)
    }

    fun createRectangle(width: Double, height: Double, color: String = "blue"): Rectangle {
        rectangleCount++
        return Rectangle(width, height, color)
    }

    fun createSquare(side: Double, color: String = "green"): Square {
        rectangleCount++
        return Square(side, color)
    }

    fun createTriangle(a: Double, b: Double, c: Double, color: String = "yellow"): Triangle {
        triangleCount++
        return Triangle(a, b, c, color)
    }

    fun getStats(): String {
        return "Created: $circleCount circles, $rectangleCount rectangles, $triangleCount triangles"
    }

    fun reset() {
        circleCount = 0
        rectangleCount = 0
        triangleCount = 0
    }
}

// ============================================================
// Extension Functions
// ============================================================

fun Shape.totalArea(): Double = area()

fun Collection<Shape>.largestByArea(): Shape? = maxByOrNull { it.area() }

fun Collection<Shape>.sortByArea(): List<Shape> = sortedByDescending { it.area() }

// ============================================================
// Utility Functions
// ============================================================

fun calculateTotalArea(shapes: List<Shape>): Double {
    return shapes.sumOf { it.area() }
}

fun printShapeReport(shapes: List<Shape>) {
    println("\n--- Shape Report ---")
    shapes.forEach { shape ->
        println("  ${shape.describe()}")
    }
    println("  Total area: ${"%.2f".format(calculateTotalArea(shapes))}")
    println("  Count: ${shapes.size}")
}

// ============================================================
// Demo / Main
// ============================================================

fun main() {
    println("=== Kotlin OOP Classes Demo ===\n")

    // Create shapes using factory
    val circle = ShapeFactory.createCircle(5.0, "crimson")
    val rectangle = ShapeFactory.createRectangle(4.0, 6.0, "navy")
    val square = ShapeFactory.createSquare(3.0, "emerald")
    val triangle = Triangle.equilateral(4.0, "gold")
    val rightTriangle = Triangle.right(3.0, 4.0, "silver")

    // Use the shapes
    val shapes = listOf(circle, rectangle, square, triangle, rightTriangle)

    // Draw all shapes
    println("--- Drawing Shapes ---")
    shapes.forEach { it.draw() }

    // Print report
    printShapeReport(shapes)

    // Factory stats
    println("\n--- Factory Stats ---")
    println(ShapeFactory.getStats())

    // Data class usage
    println("\n--- Data Class (Point) ---")
    val p1 = Point(1.0, 2.0)
    val p2 = Point(4.0, 6.0)
    println("P1: $p1")
    println("P2: $p2")
    println("Distance: ${"%.2f".format(p1.distanceTo(p2))}")
    println("Midpoint: ${p1.midpoint(p2)}")
    println("P1 == P2: ${p1 == p2}")

    // Extension functions
    println("\n--- Extension Functions ---")
    val largest = shapes.largestByArea()
    println("Largest shape: ${largest?.describe()}")

    val sortedShapes = shapes.sortByArea()
    println("Sorted by area:")
    sortedShapes.forEachIndexed { index, shape ->
        println("  ${index + 1}. ${shape.name}: ${"%.2f".format(shape.area())}")
    }

    // Polymorphism
    println("\n--- Polymorphism ---")
    fun printDrawable(d: Drawable) {
        println("Drawable: ${d.description}")
    }

    shapes.forEach { printDrawable(it) }

    // Sealed class usage
    println("\n--- Sealed Class ---")
    val shapeTypes = listOf(
        ShapeType.Circle,
        ShapeType.Square,
        ShapeType.Triangle(listOf(3.0, 4.0, 5.0))
    )

    shapeTypes.forEach { type ->
        when (type) {
            is ShapeType.Circle -> println("Circle type")
            is ShapeType.Square -> println("Square type")
            is ShapeType.Triangle -> println("Triangle type with sides: ${type.sides}")
        }
    }
}
