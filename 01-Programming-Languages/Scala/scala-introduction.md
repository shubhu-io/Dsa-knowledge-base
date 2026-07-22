# Scala Introduction

## Why Learn Scala?
Scala is a hybrid functional/object-oriented language that runs on the JVM. It combines the best of OOP and functional programming with strong static typing.

## Key Features
- **Hybrid Language**: OOP + Functional programming
- **JVM Based**: Interoperable with Java
- **Strong Typing**: Advanced type system
- **Pattern Matching**: Powerful case analysis
- **Immutability**: Default immutable values
- **Concurrency**: Akka actors, Futures
- **Concise Syntax**: Less boilerplate than Java
- **Spark/Big Data**: Industry standard for data processing

## Getting Started

### Installation
1. Install via sdkman: `curl -fL "https://github.com/sbt/sbt/releases/download/v1.9.7/sbt-1.9.7.tgz" | tar xz`
2. Or download from scala-lang.org
3. Verify: `scala -version`

### First Program
```scala
object Hello extends App {
  println("Hello, World!")
}
```

Save as `hello.scala` and run with `scala hello.scala`

## Basic Syntax

### Variables and Data Types
```scala
// Immutable (val)
val name: String = "Alice"
val age: Int = 30

// Mutable (var)
var score: Int = 100
score = 150

// Type inference
val pi = 3.14159  // inferred as Double
val isStudent = true  // inferred as Boolean

// String interpolation
val greeting = s"Hello, $name!"
val calculation = s"1 + 1 = ${1 + 1}"

// Multi-line strings
val paragraph = s"""
  |This is a
  |multi-line string
  |with $name
""".stripMargin
```

### Input/Output
```scala
// Output
println("Hello, World!")
print("No newline")
printf("Name: %s, Age: %d%n", name, age)

// Input
import scala.io.StdIn
val input = StdIn.readLine("Enter your name: ")
```

### Control Flow
```scala
// If-else (expression)
val category = if (age >= 18) "Adult" else "Minor"

// If with blocks
val status = if (age >= 18) {
  println("Adult")
  "adult"
} else {
  println("Minor")
  "minor"
}

// Match expression
day match {
  case "Monday" => println("Start of week")
  case "Friday" => println("Almost weekend")
  case "Saturday" | "Sunday" => println("Weekend")
  case _ => println("Midweek")
}

// For loop
for (i <- 0 until 5) {
  println(i)
}

// Range with step
for (i <- 0 to 10 by 2) {
  println(i)
}

// While loop
var count = 5
while (count > 0) {
  count -= 1
}

// Do-while
do {
  println(count)
  count += 1
} while (count < 5)

// For comprehension
val numbers = List(1, 2, 3, 4, 5)
val doubled = for {
  n <- numbers
  if n % 2 == 0
} yield n * 2
```

### Functions
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

// Named arguments
greet(name = "Alice", greeting = "Hi")

// Variadic arguments
def sum(numbers: Int*): Int = {
  numbers.sum
}

// Higher-order function
def operate(a: Int, b: Int, op: (Int, Int) => Int): Int = {
  op(a, b)
}

operate(5, 3, _ + _)  // 8

// Recursive function
def factorial(n: Int): BigInt = {
  if (n <= 1) 1 else n * factorial(n - 1)
}

// Tail recursive
import scala.annotation.tailrec
def factorial(n: Int): BigInt = {
  @tailrec
  def loop(n: Int, acc: BigInt): BigInt = {
    if (n <= 1) acc else loop(n - 1, n * acc)
  }
  loop(n, 1)
}

// Partial functions
val isEven: PartialFunction[Int, String] = {
  case n if n % 2 == 0 => s"$n is even"
}

// Function composition
val addOne: Int => Int = _ + 1
val double: Int => Int = _ * 2
val addOneThenDouble = double compose addOne
```

### Classes
```scala
// Basic class
class Person(val name: String, var age: Int) {
  def greet(): String = s"Hello, I'm $name"
}

// Primary constructor
class Person(val name: String, val age: Int) {
  require(age >= 0, "Age must be non-negative")

  // Auxiliary constructor
  def this(name: String) = this(name, 0)

  override def toString: String = s"$name, $age years old"
}

// Inheritance
class Student(name: String, age: Int, val grade: String) 
  extends Person(name, age) {
  
  override def greet(): String = {
    s"${super.greet()}, and I'm a student"
  }
}

// Abstract class
abstract class Shape {
  def area(): Double
  def perimeter(): Double

  def describe(): String = {
    s"Area: ${area()}, Perimeter: ${perimeter()}"
  }
}

class Circle(val radius: Double) extends Shape {
  def area(): Double = math.Pi * radius * radius
  def perimeter(): Double = 2 * math.Pi * radius
}

// Traits (like interfaces)
trait Drawable {
  def draw(): Unit
}

trait Resizable {
  def resize(factor: Double): Unit
}

class Rectangle(val width: Double, val height: Double) 
  extends Shape with Drawable with Resizable {
  
  def area(): Double = width * height
  def perimeter(): Double = 2 * (width + height)
  def draw(): Unit = println(s"Drawing rectangle ${width}x$height")
  def resize(factor: Double): Unit = {
    // resize logic
  }
}
```

### Case Classes
```scala
// Immutable data classes
case class Person(name: String, age: Int)

// Auto-generated methods
val alice = Person("Alice", 30)
val bob = Person("Bob", 25)

// Equality (structural)
alice == bob  // false
alice == Person("Alice", 30)  // true

// Copy
val olderAlice = alice.copy(age = 31)

// Pattern matching
alice match {
  case Person("Alice", age) => s"Alice is $age"
  case Person(name, age) => s"$name is $age"
}

// Extractors
val Person(name, age) = alice
```

### Sealed Classes and Enums
```scala
// Sealed class hierarchy
sealed trait Result
case class Success(data: String) extends Result
case class Error(message: String) extends Result
case object Loading extends Result

// Pattern matching
def handleResult(result: Result): String = result match {
  case Success(data) => s"Data: $data"
  case Error(msg) => s"Error: $msg"
  case Loading => "Loading..."
}

// Enum (Scala 3)
enum Color:
  case Red, Green, Blue
```

### Collections
```scala
// Immutable collections
val list = List(1, 2, 3, 4, 5)
val vector = Vector(1, 2, 3, 4, 5)
val set = Set(1, 2, 3)
val map = Map("Alice" -> 30, "Bob" -> 25)

// Mutable collections
import scala.collection.mutable
val mutableList = mutable.ListBuffer(1, 2, 3)
mutableList += 4
mutableList.remove(0)

// Collection operations
val numbers = List(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)

// Map
val doubled = numbers.map(_ * 2)

// FlatMap
val nested = List(List(1, 2), List(3, 4))
val flat = nested.flatMap(identity)

// Filter
val evens = numbers.filter(_ % 2 == 0)

// Reduce
val sum = numbers.reduce(_ + _)

// Fold
val product = numbers.foldLeft(1)(_ * _)

// Chain operations
val result = numbers
  .filter(_ % 2 == 0)
  .map(_ * _)
  .sum

// Grouping
val grouped = numbers.groupBy(if (_ % 2 == 0) "even" else "odd")

// Partition
val (evens, odds) = numbers.partition(_ % 2 == 0)
```

### Pattern Matching
```scala
// Basic matching
x match {
  case 0 => "zero"
  case 1 => "one"
  case _ => "other"
}

// Guards
x match {
  case n if n > 0 => "positive"
  case n if n < 0 => "negative"
  case _ => "zero"
}

// Destructuring
case class Person(name: String, age: Int)
person match {
  case Person("Alice", age) => s"Alice is $age"
  case Person(name, _) => s"Someone named $name"
}

// Type matching
def describe(x: Any): String = x match {
  case i: Int => s"Integer: $i"
  case s: String => s"String: $s"
  case list: List[_] => s"List of ${list.size} elements"
  case _ => "Unknown"
}

// Regex matching
val Email = """(\w+)@(\w+)\.(\w+)""".r
"alice@example.com" match {
  case Email(user, domain, tld) => s"$user at $domain.$tld"
}
```

### Futures and Concurrency
```scala
import scala.concurrent.Future
import scala.concurrent.ExecutionContext.Implicits.global

// Future
val future: Future[String] = Future {
  "Result from async computation"
}

future.onComplete {
  case scala.util.Success(result) => println(s"Got: $result")
  case scala.util.Failure(e) => println(s"Error: ${e.getMessage}")
}

// For comprehension with futures
val userFuture: Future[User] = fetchUser(id)
val ordersFuture: Future[List[Order]] = fetchOrders(id)

val result: Future[(User, List[Order])] = for {
  user <- userFuture
  orders <- ordersFuture
} yield (user, orders)

// Await result
import scala.concurrent.Await
import scala.concurrent.duration._
val result = Await.result(future, 5.seconds)
```

### Implicit Parameters
```scala
// Implicit value
implicit val ordering: Ordering[Int] = Ordering.Int

// Implicit parameter
def sorted[T](list: List[T])(implicit ord: Ordering[T]): List[T] = {
  list.sorted
}

// Using implicitly
def max[T](list: List[T])(implicit ord: Ordering[T]): T = {
  list.max(ord)
}

// Context bounds
def max[T: Ordering](list: List[T]): T = {
  list.max
}
```

### Option and Try
```scala
// Option (nullable safety)
val maybeName: Option[String] = Some("Alice")
val noName: Option[String] = None

// Pattern matching
maybeName match {
  case Some(name) => println(s"Name: $name")
  case None => println("No name")
}

// Option operations
val length = maybeName.map(_.length)
val upper = maybeName.map(_.toUpperCase)
val result = maybeName.getOrElse("Unknown")

// For comprehension
val result = for {
  name <- maybeName
  upper = name.toUpperCase
} yield upper

// Try (exception safety)
import scala.util.Try

val result: Try[Int] = Try {
  "123".toInt
}

result match {
  case scala.util.Success(value) => println(s"Value: $value")
  case scala.util.Failure(e) => println(s"Error: ${e.getMessage}")
}

// Try operations
val doubled = result.map(_ * 2)
val recovered = result.recover { case e: NumberFormatException => 0 }
```

## Best Practices
1. Prefer `val` over `var`
2. Use case classes for immutable data
3. Leverage pattern matching
4. Use Option instead of null
5. Use for comprehensions for monadic operations
6. Write tail-recursive functions when possible
7. Use traits for mixins and composition

## Common Pitfalls
- Null pointer exceptions (use Option instead)
- Mutability issues with var
- Not handling exceptions properly
- Overusing type annotations
- Ignoring performance implications of immutable collections
- Not using tail recursion for recursive algorithms