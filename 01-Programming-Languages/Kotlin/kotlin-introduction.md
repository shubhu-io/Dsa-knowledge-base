# Kotlin Introduction

## Why Learn Kotlin?
Kotlin is a modern, concise, and safe programming language that runs on the JVM. It's the preferred language for Android development and is fully interoperable with Java.

## Key Features
- **Concise**: Less boilerplate code
- **Null Safety**: Built-in null checks
- **Coroutines**: Simplified asynchronous programming
- **Interoperable**: Works seamlessly with Java
- **Smart Casts**: Automatic type casting
- **Extension Functions**: Add functionality to existing classes
- **Data Classes**: Auto-generated equals, hashCode, toString
- **Official Android**: Google's preferred language

## Getting Started

### Installation
1. Install IntelliJ IDEA or Android Studio
2. Kotlin plugin included by default
3. Or use Kotlin Playground: play.kotlinlang.org

### First Program
```kotlin
fun main() {
    println("Hello, World!")
}
```

Save as `hello.kt` and run with `kotlinc hello.kt -include-runtime -d hello.jar && java -jar hello.jar`

## Basic Syntax

### Variables and Data Types
```kotlin
// Immutable (val)
val name = "Alice"
val age = 30

// Mutable (var)
var score = 100
score = 150

// Type annotations
val height: Double = 5.5
val isStudent: Boolean = true

// Type inference
val pi = 3.14159  // inferred as Double

// String templates
val greeting = "Hello, $name!"
val calculation = "1 + 1 = ${1 + 1}"

// Multi-line strings
val paragraph = """
    This is a
    multi-line string
"""
```

### Input/Output
```kotlin
// Output
println("Hello, World!")
println("Name: $name, Age: $age")

// Input
print("Enter your name: ")
val input = readLine()
println("Hello, $input!")
```

### Control Flow
```kotlin
// If-else (expression)
val category = if (age >= 18) "Adult" else "Minor"

// If with blocks
if (age >= 18) {
    println("Adult")
} else {
    println("Minor")
}

// When (like switch)
when (day) {
    "Monday" -> println("Start of week")
    "Friday" -> println("Almost weekend")
    in listOf("Saturday", "Sunday") -> println("Weekend")
    else -> println("Midweek")
}

// For loop
for (i in 0..5) {
    println(i)
}

// Until (exclusive)
for (i in 0 until 5) {
    println(i)
}

// While loop
var count = 5
while (count > 0) {
    count--
}

// Do-while
do {
    println(count)
    count++
} while (count < 5)

// Range
for (i in 1..10 step 2) {
    println(i)  // 1, 3, 5, 7, 9
}

// Iterate collection
val numbers = listOf(1, 2, 3, 4, 5)
for (number in numbers) {
    println(number)
}
```

### Functions
```kotlin
// Basic function
fun add(a: Int, b: Int): Int {
    return a + b
}

// Single expression
fun multiply(a: Int, b: Int) = a * b

// Default parameters
fun greet(name: String, greeting: String = "Hello") {
    println("$greeting, $name!")
}

// Named arguments
greet(name = "Alice", greeting = "Hi")

// Vararg
fun sum(vararg numbers: Int): Int {
    return numbers.sum()
}

// Extension function
fun String.isPalindrome(): Boolean {
    return this == this.reversed()
}

// Higher-order function
fun operate(a: Int, b: Int, operation: (Int, Int) -> Int): Int {
    return operation(a, b)
}

// Usage
val result = operate(5, 3) { a, b -> a + b }
```

### Null Safety
```kotlin
// Nullable types
var name: String? = null

// Safe call operator
val length = name?.length

// Elvis operator
val length = name?.length ?: 0

// Not-null assertion (use cautiously)
val length = name!!.length

// Safe casting
val number: Any = 42
val intNumber = number as? Int

// Let for null checks
name?.let {
    println("Name is $it")
}

// Check and act
if (name != null) {
    println(name.length)  // Smart cast
}
```

### Classes
```kotlin
// Basic class
class Person {
    var name: String = ""
    var age: Int = 0

    fun greet() {
        println("Hello, I'm $name")
    }
}

// Primary constructor
class Person(val name: String, var age: Int) {
    init {
        require(age >= 0) { "Age must be non-negative" }
    }

    fun greet() {
        println("Hello, I'm $name")
    }
}

// Secondary constructor
class Person(val name: String) {
    var age: Int = 0

    constructor(name: String, age: Int) : this(name) {
        this.age = age
    }
}

// Inheritance (open keyword)
open class Animal(val name: String) {
    open fun speak() {
        println("$name makes a sound")
    }
}

class Dog(name: String) : Animal(name) {
    override fun speak() {
        println("$name barks")
    }
}

// Abstract class
abstract class Shape {
    abstract fun area(): Double
    abstract fun perimeter(): Double

    fun describe() {
        println("Area: ${area()}, Perimeter: ${perimeter()}")
    }
}

class Circle(val radius: Double) : Shape() {
    override fun area() = Math.PI * radius * radius
    override fun perimeter() = 2 * Math.PI * radius
}
```

### Data Classes
```kotlin
// Auto-generates equals, hashCode, toString, copy
data class Person(val name: String, val age: Int)

// Usage
val person = Person("Alice", 30)
val copied = person.copy(age = 31)
val (name, age) = person  // Destructuring

// Equality
val person1 = Person("Alice", 30)
val person2 = Person("Alice", 30)
println(person1 == person2)  // true
```

### Sealed Classes
```kotlin
// Restricted class hierarchy
sealed class Result {
    data class Success(val data: String) : Result()
    data class Error(val message: String) : Result()
    object Loading : Result()
}

// Exhaustive when
fun handleResult(result: Result) = when (result) {
    is Result.Success -> println("Data: ${result.data}")
    is Result.Error -> println("Error: ${result.message}")
    is Result.Loading -> println("Loading...")
}
```

### Collections
```kotlin
// Immutable collections
val list = listOf(1, 2, 3, 4, 5)
val set = setOf(1, 2, 3)
val map = mapOf("Alice" to 30, "Bob" to 25)

// Mutable collections
val mutableList = mutableListOf(1, 2, 3)
mutableList.add(4)

val mutableMap = mutableMapOf("Alice" to 30)
mutableMap["Bob"] = 25

// Collection operations
val numbers = listOf(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)

// Filter
val evens = numbers.filter { it % 2 == 0 }

// Map
val doubled = numbers.map { it * 2 }

// Reduce
val sum = numbers.reduce { acc, i -> acc + i }

// Fold
val product = numbers.fold(1) { acc, i -> acc * i }

// Chaining
val result = numbers
    .filter { it % 2 == 0 }
    .map { it * it }
    .sum()

// Grouping
val grouped = numbers.groupBy { if (it % 2 == 0) "even" else "odd" }
```

### Coroutines
```kotlin
// Suspend function
suspend fun fetchData(): String {
    delay(1000)  // Non-blocking delay
    return "Data"
}

// Coroutine scope
fun main() = runBlocking {
    val data = fetchData()
    println(data)
}

// Launch multiple coroutines
fun main() = runBlocking {
    val job1 = launch {
        delay(1000)
        println("Job 1")
    }
    val job2 = launch {
        delay(500)
        println("Job 2")
    }
    joinAll(job1, job2)
}

// Async/Await
fun main() = runBlocking {
    val deferred1 = async { fetchData() }
    val deferred2 = async { fetchData() }
    val data = deferred1.await() + deferred2.await()
    println(data)
}
```

### Extension Functions and Properties
```kotlin
// Extension function
fun String.isPalindrome(): Boolean {
    return this == this.reversed()
}

// Extension property
val String.firstChar: Char
    get() = this[0]

// Usage
println("racecar".isPalindrome())  // true
println("Hello".firstChar)  // H
```

### DSL Building
```kotlin
// HTML DSL
fun html(block: HTML.() -> Unit): HTML {
    val html = HTML()
    html.block()
    return html
}

class HTML {
    fun body(block: Body.() -> Unit) {
        // Implementation
    }
}

// Usage
val page = html {
    body {
        // Build HTML
    }
}
```

## Best Practices
1. Prefer `val` over `var`
2. Use extension functions wisely
3. Leverage null safety features
4. Use data classes for data holders
5. Embrace functional programming
6. Use coroutines for async operations
7. Follow Kotlin coding conventions

## Common Pitfalls
- Using `!!` operator carelessly
- Confusing `==` with `===`
- Not handling nullability properly
- Overusing extension functions
- Ignoring coroutine scope and context
- Using `lateinit` when lazy initialization is better