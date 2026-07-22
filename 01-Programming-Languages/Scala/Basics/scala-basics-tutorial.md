# Scala Basics Tutorial

## Variables and Constants

```scala
// Immutable (val)
val name: String = "Alice"
val age: Int = 30

// Mutable (var)
var score: Int = 100
score = 150

// Type inference
val pi = 3.14159  // inferred as Double

// String interpolation
val greeting = s"Hello, $name!"
val calculation = s"1 + 1 = ${1 + 1}"
```

## Data Types

- **Int**: Integer numbers
- **Double/Float**: Decimal numbers
- **String**: Text
- **Boolean**: True/False
- **List**: Immutable collection
- **Array**: Mutable collection
- **Map**: Key-value pairs

## Control Flow

### If-Else
```scala
if (age >= 18) {
  println("Adult")
} else {
  println("Minor")
}

// As expression
val category = if (age >= 18) "Adult" else "Minor"
```

### Match
```scala
day match {
  case "Monday" => println("Start of week")
  case "Friday" => println("Almost weekend")
  case "Saturday" | "Sunday" => println("Weekend")
  case _ => println("Midweek")
}
```

### For Loop
```scala
for (i <- 0 until 5) {
  println(i)
}

// With guard
for (i <- 0 to 10 if i % 2 == 0) {
  println(i)
}
```

## Functions

```scala
// Basic function
def add(a: Int, b: Int): Int = {
  a + b
}

// Single expression
def multiply(a: Int, b: Int) = a * b

// Default parameters
def greet(name: String, greeting: String = "Hello"): String = {
  s"$greeting, $name!"
}

// Higher-order function
def operate(a: Int, b: Int, op: (Int, Int) => Int): Int = {
  op(a, b)
}
```

## Case Classes

```scala
// Immutable data classes
case class Person(name: String, age: Int)

// Auto-generated methods
val alice = Person("Alice", 30)
val bob = alice.copy(age = 31)

// Pattern matching
alice match {
  case Person("Alice", age) => s"Alice is $age"
  case Person(name, age) => s"$name is $age"
}
```

## Traits

```scala
trait Drawable {
  def draw(): Unit
}

trait Resizable {
  def resize(factor: Double): Unit
}

class Rectangle(val width: Double, val height: Double) 
  extends Shape with Drawable with Resizable {
  
  def area(): Double = width * height
  def draw(): Unit = println(s"Drawing rectangle ${width}x$height")
  def resize(factor: Double): Unit = {}
}
```

## Collections

```scala
// List
val numbers = List(1, 2, 3, 4, 5)

// Operations
val doubled = numbers.map(_ * 2)
val evens = numbers.filter(_ % 2 == 0)
val sum = numbers.reduce(_ + _)

// For comprehension
val result = for {
  n <- numbers
  if n % 2 == 0
} yield n * 2
```

## Pattern Matching

```scala
x match {
  case 0 => "zero"
  case 1 => "one"
  case n if n > 0 => "positive"
  case _ => "other"
}

// Type matching
def describe(x: Any): String = x match {
  case i: Int => s"Integer: $i"
  case s: String => s"String: $s"
  case _ => "Unknown"
}
```

## Best Practices

1. Prefer `val` over `var`
2. Use case classes for immutable data
3. Leverage pattern matching
4. Use for comprehensions for monadic operations
5. Write tail-recursive functions when possible