# Scala Syntax

## Overview

Scala combines object-oriented and functional programming in a concise, high-level language. It runs on the JVM and provides advanced type inference, pattern matching, case classes, traits, and immutable collections as first-class citizens. Scala 3 (Dotty) introduces significant syntax simplifications while maintaining full backward compatibility.

## Variables and Values

```scala
// vals are immutable (preferred), vars are mutable
val name = "Alice"          // Inferred as String
var count = 0               // Inferred as Int

// Explicit types
val pi: Double = 3.14159
val active: Boolean = true
val greeting: String = "Hello, Scala"

// Lazy evaluation
lazy val expensive = computeValue()  // Evaluated on first access

// String interpolation
val age = 30
println(s"$name is $age years old")          // "Alice is 30 years old"
println(s"Next year: ${age + 1}")            // "Next year: 31"
println(raw"Line1\nLine2")                   // No escape processing
```

## Collections

```scala
// Immutable collections (default, preferred)
val numbers = List(1, 2, 3, 4, 5)
val names = Vector("Alice", "Bob", "Carol")
val lookup = Map("a" -> 1, "b" -> 2, "c" -> 3)
val unique = Set(1, 2, 2, 3)              // Set(1, 2, 3)

// Mutable alternatives
import scala.collection.mutable
val buffer = mutable.ListBuffer(1, 2, 3)
buffer += 4
val hashMap = mutable.Map("x" -> 10)

// Functional operations
val result = numbers
  .filter(_ % 2 == 0)      // 2, 4
  .map(_ * 10)              // 20, 40
  .reduce(_ + _)            // 60

// Higher-order functions
numbers.foreach(println)
val doubled = numbers.map(_ * 2)
val sum = numbers.foldLeft(0)(_ + _)

// Tuple (fixed-size heterogeneous)
val person = ("Alice", 30, true)
person._1  // "Alice"
person._2  // 30
// Destructuring
val (n, a, _) = person
```

## Case Classes and Pattern Matching

```scala
// Case classes: immutable data carriers with automatic equals/hashCode/toString
case class Point(x: Double, y: Double)
case class Person(name: String, age: Int)

val p = Point(3.0, 4.0)
val p2 = Point(3.0, 4.0)
p == p2  // true (structural equality)

// Pattern matching
def describe(x: Any): String = x match {
  case Point(x, y)           => s"Point at ($x, $y)"
  case Person(name, age)     => s"$name is $age years old"
  case n: Int if n > 0       => s"Positive integer: $n"
  case s: String             => s"String of length ${s.length}"
  case List(head, _*)        => s"Non-empty list starting with $head"
  case _                     => "Unknown"
}

// Sealed traits for exhaustive matching
sealed trait Shape
case class Circle(radius: Double) extends Shape
case class Rectangle(width: Double, height: Double) extends Shape
case class Triangle(a: Double, b: Double, c: Double) extends Shape

def area(shape: Shape): Double = shape match {
  case Circle(r)          => Math.PI * r * r
  case Rectangle(w, h)    => w * h
  case Triangle(a, b, c)  =>
    val s = (a + b + c) / 2
    Math.sqrt(s * (s - a) * (s - b) * (s - c))
}
```

## Traits

```scala
// Traits: interfaces + implementation (no constructor parameters)
trait Drawable {
  def draw(): String
}

trait Resizable {
  var scale: Double = 1.0
  def resize(factor: Double): Unit = { scale *= factor }
}

trait PrettyPrint {
  def prettyPrint: String = toString
}

// Mixing in traits
class Circle(val radius: Double) extends Shape with Drawable with Resizable {
  override def draw(): String = s"Drawing circle with radius $radius"
}

// Abstract classes (can have constructor parameters)
abstract class Animal(val name: String) {
  def speak(): String
}

class Dog(name: String) extends Animal(name) {
  override def speak(): String = "Woof!"
}
```

## For-Comprehensions

```scala
// Syntactic sugar for map/flatMap/for/yield
val result = for {
  x <- List(1, 2, 3)
  y <- List(10, 20, 30)
  if x % 2 == 1
} yield x + y
// List(11, 21, 31, 13, 23, 33)

// Equivalent to:
List(1, 2, 3)
  .filter(_ % 2 == 1)
  .flatMap(x => List(10, 20, 30).map(y => x + y))

// Nested iteration
val coords = for {
  x <- 1 to 3
  y <- 1 to 3
  if x != y
} yield (x, y)

// With Option (monadic)
def findUser(id: Int): Option[String] = if (id > 0) Some("Alice") else None
def findEmail(user: String): Option[String] = if (user.nonEmpty) Some("a@test.com") else None

val email = for {
  user <- findUser(1)
  email <- findEmail(user)
} yield email  // Some("a@test.com")
```

## Option and Either

```scala
// Option: Safe null handling
val name: Option[String] = Some("Alice")
val missing: Option[String] = None

val length = name.map(_.length)         // Some(5)
val upper = name.getOrElse("N/A")       // "Alice"
val value = name.getOrElse("N/A")       // "Alice"

// Pattern matching with Option
name match {
  case Some(n) => println(s"Found: $n")
  case None    => println("Not found")
}

// Either: Error handling without exceptions
def divide(a: Int, b: Int): Either[String, Int] =
  if (b == 0) Left("Division by zero")
  else Right(a / b)

divide(10, 2) match {
  case Right(result) => s"Result: $result"
  case Left(error)   => s"Error: $error"
}

// For-comprehension with Either
val computation = for {
  a <- Right(10)
  b <- Right(5)
  c <- Right(2)
} yield (a + b) * c  // Right(30)
```

## Implicits and Using

```scala
// Implicit parameters (Scala 2)
implicit val ordering: Ordering[Int] = Ordering.Int

def findMax[T](list: List[T])(implicit ord: Ordering[T]): T =
  list.max(ord)

findMax(List(3, 1, 4, 1, 5))  // 5 (Ordering[Int] passed implicitly)

// Using (Scala 3 replacement for implicit)
def findMax[T](list: List[T])(using ord: Ordering[T]): T =
  list.max(ord)

// Extension methods (Scala 3)
extension (s: String) {
  def isPalindrome: Boolean = s == s.reverse
  def wordCount: Int = s.split("\\s+").length
}

"racecar".isPalindrome  // true
"Hello World".wordCount // 2

// Given instances (Scala 3 replacement for implicit vals)
given Ordering[Int] = Ordering.Int
given [T](using ord: Ordering[T]): Ordering[Option[T]] with
  override def compare(x: Option[T], y: Option[T]): Int = (x, y) match
    case (Some(a), Some(b)) => ord.compare(a, b)
    case (None, Some(_))    => -1
    case (Some(_), None)    => 1
    case (None, None)       => 0
```

## Higher-Order Functions

```scala
// Functions as first-class values
val add: (Int, Int) => Int = (a, b) => a + b
val multiply = (a: Int, b: Int) => a * b

// Currying
def addCurried(a: Int)(b: Int): Int = a + b
val addFive = addCurried(5) _    // Int => Int
addFive(3)  // 8

// Composition
val compose = andThen(_ + 1)(_ * 2)  // _ * 2, then + 1

// Partial application
def log(level: String, message: String): Unit = println(s"[$level] $message")
val errorLog = log("ERROR", _: String)
errorLog("Something went wrong")

// Method syntax (more idiomatic)
def sum(nums: Int*): Int = nums.sum
sum(1, 2, 3, 4)  // 10
```

## Demo

```scala
// Complete demo: String analysis with pattern matching and functional style
object StringAnalyzer {
  def analyze(str: String): Map[String, Any] = Map(
    "length" -> str.length,
    "wordCount" -> str.split("\\s+").length,
    "charFrequency" -> str.toLowerCase.groupBy(identity).view.mapValues(_.length).toMap,
    "reversed" -> str.reverse,
    "isPalindrome" -> str.toLowerCase.filter(_.isLetterOrDigit) ==
                      str.toLowerCase.filter(_.isLetterOrDigit).reverse,
    "containsNumber" -> str.exists(_.isDigit),
    "titleCase" -> str.split("\\s+").map(_.capitalize).mkString(" ")
  )

  def main(args: Array[String]): Unit = {
    val text = "Hello World from Scala"
    val result = analyze(text)
    result.foreach { case (key, value) => println(s"$key: $value") }
  }
}
```

## See Also

- [[Scala/README|Scala Overview]]
- [[Scala/Basics/scala-basics-tutorial|Scala Basics Tutorial]]
- [[Scala/OOP/oop|Scala Object-Oriented Programming]]
- [[Scala/Algorithms/String/string_algorithms|String Algorithms in Scala]]
