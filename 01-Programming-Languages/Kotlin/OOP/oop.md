# Kotlin Object-Oriented Programming

## Overview

Kotlin is a hybrid language that supports both object-oriented and functional programming. Its OOP model builds on Java's foundation with significant improvements including data classes, sealed classes, object declarations, and companion objects. Kotlin enforces immutability by default and provides powerful abstraction mechanisms.

## Classes and Constructors

```kotlin
// Primary constructor
class Person(val name: String, var age: Int) {
    // Initializer block
    init {
        require(age >= 0) { "Age cannot be negative" }
    }

    // Secondary constructor
    constructor(name: String) : this(name, 0)

    // Custom getter
    val isAdult: Boolean get() = age >= 18
}

// Property with custom getter/setter
class Temperature {
    var celsius: Double = 0.0
        set(value) {
            field = value  // 'field' keyword for backing field
            fahrenheit = value * 9 / 5 + 32
        }
    var fahrenheit: Double = 32.0
        private set

    constructor(celsius: Double) {
        this.celsius = celsius
    }
}
```

## Inheritance

Kotlin classes are `final` by default. Use `open` to allow inheritance:

```kotlin
open class Animal(val name: String) {
    open fun sound(): String = "..."

    fun describe() = "$name says ${sound()}"
}

class Dog(name: String) : Animal(name) {
    override fun sound() = "Woof!"
}

class Cat(name: String) : Animal(name) {
    override fun sound() = "Meow!"
}

// Abstract class
abstract class Shape {
    abstract fun area(): Double
    abstract fun perimeter(): Double

    fun describe() = "Area: ${area()}, Perimeter: ${perimeter()}"
}
```

## Interfaces

Interfaces in Kotlin can contain abstract and default implementations:

```kotlin
interface Drawable {
    fun draw()

    // Default implementation
    fun drawWithBorder() {
        println("Drawing border...")
        draw()
        println("Border drawn.")
    }
}

interface Resizable {
    var scale: Double

    fun resize(factor: Double) {
        scale *= factor
    }
}

// Implementing multiple interfaces
class Circle(var radius: Double) : Drawable, Resizable {
    override var scale: Double = 1.0

    override fun draw() {
        println("Drawing circle with radius ${radius * scale}")
    }
}

// Interface with property
interface Identifiable {
    val id: String
}

class User(override val id: String, val name: String) : Identifiable
```

## Abstract Classes vs Interfaces

```kotlin
// Abstract class - can have constructors, state
abstract class Vehicle(val make: String) {
    abstract val fuelType: String
    var mileage: Double = 0.0
        protected set

    fun drive(km: Double) {
        mileage += km
    }
}

// Interface - no constructors, can have property declarations
interface Insurable {
    val insuranceRate: Double
    fun calculatePremium(): Double
}

class Car(make: String) : Vehicle(make), Insurable {
    override val fuelType = "Gasoline"
    override val insuranceRate = 0.05

    override fun calculatePremium() = mileage * insuranceRate
}
```

## Data Classes

Data classes automatically generate useful methods:

```kotlin
data class Coordinate(val x: Double, val y: Double)
data class User(val name: String, val email: String, val age: Int)

fun dataClassDemo() {
    val user = User("Alice", "alice@example.com", 30)

    // toString() - "User(name=Alice, email=alice@example.com, age=30)"
    println(user)

    // equals() - structural equality
    val user2 = User("Alice", "alice@example.com", 30)
    println(user == user2)  // true

    // copy() - create modified copy
    val user3 = user.copy(name = "Bob", age = 25)
    println(user3)

    // destructuring
    val (name, email, age) = user
    println("$name, $email, $age")

    // componentN() functions
    println(user.component1())  // "Alice"
    println(user.component2())  // "alice@example.com"
}

// Data class with defaults
data class Config(
    val host: String = "localhost",
    val port: Int = 8080,
    val debug: Boolean = false
)
```

## Sealed Classes and Interfaces

Restricted hierarchies for representing fixed sets of types:

```kotlin
// Sealed class - all subclasses in the same module
sealed class NetworkResult<out T> {
    data class Success<T>(val data: T) : NetworkResult<T>()
    data class Error(val code: Int, val message: String) : NetworkResult<Nothing>()
    data object Loading : NetworkResult<Nothing>()
}

// Sealed interface (Kotlin 1.5+)
sealed interface Shape {
    val area: Double
}

data class Circle(val radius: Double) : Shape {
    override val area: Double = Math.PI * radius * radius
}

data class Rectangle(val width: Double, val height: Double) : Shape {
    override val area: Double = width * height
}

// Exhaustive when expression - no else needed
fun describe(shape: Shape): String = when (shape) {
    is Circle -> "Circle with radius ${shape.radius}"
    is Rectangle -> "Rectangle ${shape.width}x${shape.height}"
}
```

## Object Declarations (Singletons)

```kotlin
// Singleton - thread-safe, lazy initialization
object DatabaseConfig {
    val host = "localhost"
    val port = 5432
    fun connect() = println("Connecting to $host:$port")
}

// Usage (no instantiation needed)
DatabaseConfig.connect()

// Object expression (anonymous object)
val comparator = object : Comparator<String> {
    override fun compare(a: String, b: String): Int = a.length - b.length
}

// Object implementing multiple interfaces
interface Logger {
    fun log(message: String)
}

interface MetricsCollector {
    fun recordMetric(name: String, value: Double)
}

object MonitoringService : Logger, MetricsCollector {
    override fun log(message: String) = println("[LOG] $message")
    override fun recordMetric(name: String, value: Double) =
        println("[METRIC] $name = $value")
}
```

## Companion Objects

Static-like members attached to a class:

```kotlin
class User private constructor(val name: String, val email: String) {
    companion object {
        private var instanceCount = 0

        fun create(name: String, email: String): User {
            instanceCount++
            return User(name, email)
        }

        fun getInstanceCount() = instanceCount

        // Factory with operator
        operator fun invoke(name: String, email: String) = create(name, email)
    }
}

// Usage
val user1 = User.create("Alice", "alice@example.com")
val user2 = User("Bob", "bob@example.com")  // Uses invoke operator
println(User.getInstanceCount())  // 2

// Named companion object
class MyClass {
    companion object Factory {
        fun create(): MyClass = MyClass()
    }
}

// Extending companion objects
fun MyClass.Companion.fromConfig(config: Map<String, String>): MyClass {
    // Factory method using config
    return MyClass.create()
}
```

## Visibility Modifiers

```kotlin
open class AccessControl {
    public val publicProp = "Visible everywhere"

    protected open val protectedProp = "Visible in subclasses"

    internal val internalProp = "Visible in same module"

    private val privateProp = "Visible only in this class"

    fun demo() {
        println(publicProp)
        println(protectedProp)
        println(internalProp)
        println(privateProp)  // All accessible here
    }
}

class Subclass : AccessControl() {
    override val protectedProp = "Overridden"

    fun show() {
        println(publicProp)      // OK
        println(protectedProp)   // OK - overridden in subclass
        println(internalProp)    // OK - same module
        // println(privateProp)  // Error - not visible
    }
}
```

## Extension Functions and Properties

```kotlin
// Extension function
fun String.isEmail(): Boolean = matches(Regex("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$"))

// Extension property
val String.wordCount: Int
    get() = split("\\s+".toRegex()).size

// Nullable extension
fun String?.orDefault(default: String = "N/A"): String = this ?: default

// Usage
println("test@example.com".isEmail())  // true
println("Hello World".wordCount)       // 2
println(null.orDefault())              // "N/A"
```

## Enum Classes

```kotlin
enum class Direction(val dx: Int, val dy: Int) {
    NORTH(0, 1),
    SOUTH(0, -1),
    EAST(1, 0),
    WEST(-1, 0);

    fun opposite(): Direction = when (this) {
        NORTH -> SOUTH
        SOUTH -> NORTH
        EAST -> WEST
        WEST -> EAST
    }
}

// Enum with abstract method
enum class Color(val rgb: Int) {
    RED(0xFF0000) {
        override fun description() = "The color red"
    },
    GREEN(0x00FF00) {
        override fun description() = "The color green"
    },
    BLUE(0x0000FF) {
        override fun description() = "The color blue"
    };

    abstract fun description(): String
}
```

## Value Classes

Type-safe wrappers without runtime overhead:

```kotlin
@JvmInline
value class Email(val value: String) {
    init {
        require(value.contains("@")) { "Invalid email" }
    }
}

@JvmInline
value class Meters(val value: Double) {
    fun toFeet(): Double = value * 3.28084
}

// Usage - no object allocation at runtime
fun sendEmail(email: Email) {
    println("Sending to ${email.value}")
}

fun main() {
    val email = Email("user@example.com")
    sendEmail(email)

    val distance = Meters(100.0)
    println("${distance.value}m = ${distance.toFeet()}ft")
}
```

## See Also

- [[README]] - Kotlin overview
- [[Basics/syntax]] - Core language features
- [[Algorithms/String/string_algorithms]] - String algorithm implementations
- [[02-Data-Structures]] - Data structure implementations
