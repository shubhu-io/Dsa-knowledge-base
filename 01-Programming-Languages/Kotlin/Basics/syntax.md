# Kotlin Syntax

## Overview

Kotlin combines object-oriented and functional programming with a concise, expressive syntax. This guide covers the core language features you need to write idiomatic Kotlin.

## Variable Declarations

```kotlin
// val - immutable reference (read-only, like final in Java)
val name = "Kotlin"        // Type inferred as String
val age: Int = 25          // Explicit type

// var - mutable reference
var counter = 0
counter = 1                // Allowed because var is mutable

// Constants (compile-time)
const val MAX_SIZE = 100
```

## Null Safety

Kotlin's type system distinguishes between nullable and non-nullable types:

```kotlin
// Non-nullable (cannot hold null)
var nonNull: String = "hello"
// nonNull = null          // Compile error

// Nullable (can hold null)
var nullable: String? = "hello"
nullable = null             // Allowed

// Safe call operator (?.)
val length = nullable?.length   // Returns Int? (null if nullable is null)

// Elvis operator (?:) - provides default value
val len = nullable?.length ?: 0  // Returns 0 if nullable is null

// Non-null assertion (!!) - throws NPE if null
// val len2 = nullable!!.length  // Dangerous: throws NPE

// Safe casting (as?)
val obj: Any = "Hello"
val str: String? = obj as? String     // "Hello"
val num: Int? = obj as? Int           // null

// Let block for null-safe operations
nullable?.let {
    println("Value is $it, length is ${it.length}")
} ?: println("Value was null")
```

## Data Classes

Concise syntax for classes that hold data:

```kotlin
data class User(
    val name: String,
    val age: Int,
    val email: String? = null  // Default parameter
)

val user = User("Alice", 30)
val copy = user.copy(age = 31)  // Copy with modification

// Destructuring
val (name, age, email) = user
println("$name is $age years old")  // Alice is 30 years old

// Auto-generated: equals(), hashCode(), toString(), copy(), componentN()
```

## Sealed Classes

Restricted class hierarchies for representing fixed sets of types:

```kotlin
sealed class Result<out T> {
    data class Success<T>(val data: T) : Result<T>()
    data class Error(val exception: Throwable) : Result<Nothing>()
    data object Loading : Result<Nothing>()
}

fun handleResult(result: Result<String>) = when (result) {
    is Result.Success -> println("Data: ${result.data}")
    is Result.Error -> println("Error: ${result.exception.message}")
    is Result.Loading -> println("Loading...")
    // No else needed - compiler knows all cases are covered
}
```

## Extension Functions

Add functions to existing classes without modifying them:

```kotlin
// Extension function on String
fun String.removeSpaces(): String = this.replace(" ", "")

// Extension property
val String.isPalindrome: Boolean
    get() = this.equals(this.reversed(), ignoreCase = true)

// Usage
println("hello world".removeSpaces())    // "helloworld"
println("Racecar".isPalindrome)          // true

// Nullable extension
fun String?.orDefault(default: String = "N/A"): String = this ?: default
```

## Lambdas and Higher-Order Functions

```kotlin
// Lambda syntax
val square = { x: Int -> x * x }
val add = { a: Int, b: Int -> a + b }

// Function type
val multiply: (Int, Int) -> Int = { a, b -> a * b }

// Higher-order function
fun <T> List<T>.customFilter(predicate: (T) -> Boolean): List<T> {
    val result = mutableListOf<T>()
    for (item in this) {
        if (predicate(item)) result.add(item)
    }
    return result
}

// Usage
val numbers = listOf(1, 2, 3, 4, 5, 6)
val evens = numbers.customFilter { it % 2 == 0 }  // [2, 4, 6]

// SAM conversion (Single Abstract Method)
val runnable = Runnable { println("Running!") }
val comparator = Comparator<String> { a, b -> a.length - b.length }
```

## Scope Functions

Kotlin provides five scope functions for executing blocks within the context of an object:

```kotlin
data class Person(var name: String, var age: Int, var email: String)

// let - null-safe calls and transformations; 'it' refers to the object
val result = person?.let {
    println("Processing ${it.name}")
    it.email  // Returns last expression
}

// run - executes block and returns result; 'this' refers to the object
val greeting = Person("Alice", 30, "alice@example.com").run {
    "Hello, $name! You are $age years old."  // 'this' is Person
}

// with - groups multiple operations on an object; 'this' refers to the object
with(person) {
    println("Name: $name")
    println("Age: $age")
    println("Email: $email")
}

// apply - configure objects during creation; 'this' refers to the object
val person = Person("", 0, "").apply {
    name = "Bob"
    age = 25
    email = "bob@example.com"
}

// also - side effects; 'it' refers to the object
val numbers = mutableListOf(1, 2, 3).also {
    println("List contains: $it")
    it.add(4)
}
```

## Coroutines

Lightweight threads for asynchronous programming:

```kotlin
import kotlinx.coroutines.*

// Sequential suspend function
suspend fun fetchData(): String {
    delay(1000)  // Non-blocking delay
    return "Data loaded"
}

// Launching coroutines
fun main() = runBlocking {
    // Sequential
    val data = fetchData()
    println(data)

    // Concurrent
    val deferred1 = async { fetchData() }
    val deferred2 = async { fetchData() }
    println("${deferred1.await()} and ${deferred2.await()}")

    // Launch fire-and-forget
    launch {
        println("Background task running")
    }
}

// Coroutine scope and structured concurrency
viewModelScope.launch {
    try {
        val result = withContext(Dispatchers.IO) {
            repository.getData()
        }
        _uiState.value = UiState.Success(result)
    } catch (e: Exception) {
        _uiState.value = UiState.Error(e.message ?: "Unknown error")
    }
}
```

## Destructuring Declarations

```kotlin
// Data class destructuring
data class Point(val x: Int, val y: Int)
val point = Point(10, 20)
val (x, y) = point

// Map iteration
val map = mapOf("a" to 1, "b" to 2)
for ((key, value) in map) {
    println("$key -> $value")
}

// Function returning multiple values via data class
data class Result(val sum: Int, val average: Double)

fun calculateStats(numbers: List<Int>): Result {
    return Result(numbers.sum(), numbers.average())
}

val (sum, avg) = calculateStats(listOf(1, 2, 3, 4, 5))
```

## Ranges and Progressions

```kotlin
// Int ranges
for (i in 1..10) print("$i ")       // 1 2 3 4 5 6 7 8 9 10
for (i in 1 until 10) print("$i ")  // 1 2 3 4 5 6 7 8 9
for (i in 10 downTo 1 step 2) print("$i ")  // 10 8 6 4 2

// Char ranges
for (c in 'a'..'f') print("$c ")    // a b c d e f

// Range checks
val age = 25
if (age in 18..65) println("Working age")

// Collection operations with ranges
val evens = (1..100).filter { it % 2 == 0 }
```

## Collections

```kotlin
// Immutable collections
val list = listOf(1, 2, 3)
val set = setOf(1, 2, 3)
val map = mapOf("a" to 1, "b" to 2)

// Mutable collections
val mutableList = mutableListOf(1, 2, 3)
val mutableSet = mutableSetOf(1, 2, 3)
val mutableMap = mutableMapOf("a" to 1, "b" to 2)

// Functional operations
val result = listOf(1, 2, 3, 4, 5)
    .filter { it % 2 == 0 }       // [2, 4]
    .map { it * it }              // [4, 16]
    .fold(0) { acc, i -> acc + i } // 20

// Lazy evaluation
val lazyList = (1..1_000_000).asSequence()
    .filter { it % 2 == 0 }
    .map { it * it }
    .take(5)
    .toList()
```

## Companion Objects

Static-like members in Kotlin:

```kotlin
class MyClass private constructor(val value: Int) {
    companion object {
        const val TAG = "MyClass"
        fun create(value: Int): MyClass = MyClass(value)
    }
}

println(MyClass.TAG)           // "MyClass"
val obj = MyClass.create(42)
```

## Type Aliases

```kotlin
typealias Predicate<T> = (T) -> Boolean
typealias UserMap = Map<String, User>

fun <T> filterWithPredicate(list: List<T>, predicate: Predicate<T>): List<T> {
    return list.filter(predicate)
}
```

## See Also

- [[README]] - Kotlin overview
- [[OOP/oop]] - Object-oriented programming in Kotlin
- [[Algorithms/String/string_algorithms]] - String algorithm implementations
- [[02-Data-Structures]] - Data structure implementations
