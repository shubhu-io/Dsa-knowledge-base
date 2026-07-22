# Kotlin Basics Tutorial

## Variables and Constants

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

// String templates
val greeting = "Hello, $name!"
val calculation = "1 + 1 = ${1 + 1}"
```

## Data Types

- **Int**: Integer numbers
- **Double/Float**: Decimal numbers
- **String**: Text
- **Boolean**: True/False
- **List**: Immutable collection
- **MutableList**: Mutable collection
- **Map**: Key-value pairs

## Control Flow

### If-Else
```kotlin
if (age >= 18) {
    println("Adult")
} else {
    println("Minor")
}

// As expression
val category = if (age >= 18) "Adult" else "Minor"
```

### When
```kotlin
when (day) {
    "Monday" -> println("Start of week")
    "Friday" -> println("Almost weekend")
    in listOf("Saturday", "Sunday") -> println("Weekend")
    else -> println("Midweek")
}
```

### For Loop
```kotlin
for (i in 0..5) {
    println(i)
}

// With step
for (i in 0..10 step 2) {
    println(i)
}
```

## Functions

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

// Extension function
fun String.isPalindrome(): Boolean {
    return this == this.reversed()
}
```

## Null Safety

```kotlin
// Nullable types
var name: String? = null

// Safe call
val length = name?.length

// Elvis operator
val length = name?.length ?: 0

// Not-null assertion
val length = name!!.length

// Let
name?.let {
    println("Name is $it")
}
```

## Classes

```kotlin
// Basic class
class Person(val name: String, var age: Int) {
    fun greet() = "Hello, I'm $name"
}

// Inheritance
open class Animal(val name: String) {
    open fun speak() = println("$name makes a sound")
}

class Dog(name: String) : Animal(name) {
    override fun speak() = println("$name barks")
}

// Data class
data class Point(val x: Int, val y: Int)
```

## Collections

```kotlin
// List
val numbers = listOf(1, 2, 3, 4, 5)

// Mutable list
val mutableList = mutableListOf(1, 2, 3)
mutableList.add(4)

// Map
val map = mapOf("Alice" to 30, "Bob" to 25)

// Operations
val evens = numbers.filter { it % 2 == 0 }
val doubled = numbers.map { it * 2 }
val sum = numbers.reduce { acc, i -> acc + i }
```

## Coroutines

```kotlin
import kotlinx.coroutines.*

suspend fun fetchData(): String {
    delay(1000)
    return "Data"
}

fun main() = runBlocking {
    val data = fetchData()
    println(data)
}
```

## Best Practices

1. Prefer `val` over `var`
2. Use null safety features
3. Leverage data classes
4. Use extension functions wisely
5. Embrace functional programming