# Scala Object-Oriented Programming

## Overview

Scala is a hybrid language that fully integrates OOP and functional programming. Every value is an object, every operation is a method call. Scala provides classes, traits (interfaces with implementation), abstract classes, case classes (immutable data carriers), companion objects, mixins, and variance annotations. Scala 3 introduces significant simplifications while maintaining full backward compatibility.

## Classes

```scala
// Basic class with constructor parameters
class User(val name: String, val email: String) {
  // val makes parameter a public getter; var adds a setter
  private var _age: Int = 0

  def age: Int = _age
  def age_=(newAge: Int): Unit = {
    require(newAge >= 0, "Age must be non-negative")
    _age = newAge
  }

  override def toString: String = s"$name <$email>"
}

val user = User("Alice", "alice@test.com")
println(user)       // "Alice <alice@test.com>"
user.age = 30       // Uses the setter
```

## Case Classes

```scala
// Case classes: immutable data carriers with automatic:
// - equals/hashCode/toString
// - copy method
// - pattern matching support
// - companion object with apply
case class Point(x: Double, y: Double)
case class Person(name: String, age: Int)

val p = Point(3.0, 4.0)
val p2 = Point(3.0, 4.0)
p == p2               // true (structural equality)
val p3 = p.copy(x = 5.0)  // Point(5.0, 4.0)

// Case class with default values
case class Config(
  host: String = "localhost",
  port: Int = 8080,
  debug: Boolean = false
)
val config = Config(port = 3000)  // Config(localhost,3000,false)
```

## Traits

```scala
// Traits: interfaces + optional implementation
// Can be mixed into any class
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

// Traits with default implementations
trait Logger {
  def log(message: String): Unit = println(s"[LOG] $message")
  def logError(message: String): Unit = println(s"[ERROR] $message")
}

// Mixing in traits
class Circle(val radius: Double) extends Shape with Drawable with Resizable with Logger {
  override def draw(): String = s"Drawing circle with radius $radius"
}

class Rectangle(val width: Double, val height: Double) extends Shape with Drawable with PrettyPrint {
  override def prettyPrint: String = s"Rectangle($width x $height)"
}
```

## Abstract Classes

```scala
// Abstract classes can have constructor parameters (traits cannot)
abstract class Animal(val name: String) {
  def speak(): String
  def greet(): String = s"$name says: ${speak()}"
}

class Dog(name: String) extends Animal(name) {
  override def speak(): String = "Woof!"
}

class Cat(name: String) extends Animal(name) {
  override def speak(): String = "Meow!"
}

val animals: List[Animal] = List(new Dog("Rex"), new Cat("Whiskers"))
animals.foreach(a => println(a.greet()))
```

## Companion Objects

```scala
// Companion objects share the same name and have access to private members
class User private (val name: String, val email: String) {
  private var _loginCount: Int = 0
  def login(): Unit = _loginCount += 1
  def loginCount: Int = _loginCount
}

object User {
  // Factory methods (apply)
  def apply(name: String, email: String): User = new User(name, email)

  // Companion has access to private constructor
  def fromEmail(email: String): User = {
    val name = email.split("@").head
    new User(name, email)
  }

  // Constants
  val MAX_NAME_LENGTH = 50
}

// Usage (no 'new' keyword thanks to apply)
val user = User("Alice", "alice@test.com")
val user2 = User.fromEmail("bob@example.com")
```

## Mixins and Linearization

```scala
// Scala resolves the diamond problem through linearization
trait A {
  def method: String = "A"
}
trait B extends A {
  override def method: String = "B"
}
trait C extends A {
  override def method: String = "C"
}

// Linearization order: D -> C -> B -> A -> AnyRef -> Any
class D extends B with C {
  override def method: String = "D"
}

val d = new D
d.method  // "D" (rightmost wins in linearization)
```

## Variance

```scala
// Covariance (+T): Container[Cat] is a subtype of Container[Animal]
class CovariantContainer[+T](val value: T)
val catContainer: CovariantContainer[Cat] = new CovariantContainer(new Cat("Whiskers"))
val animalContainer: CovariantContainer[Animal] = catContainer  // OK

// Contravariance (-T): Consumer[Animal] is a subtype of Consumer[Cat]
trait Consumer[-T] {
  def consume(item: T): Unit
}
class AnimalConsumer extends Consumer[Animal] {
  def consume(item: Animal): Unit = println(s"Consuming ${item.name}")
}
val catConsumer: Consumer[Cat] = new AnimalConsumer  // OK

// Invariance (default): Container[T] is only Container[T]
class MutableContainer[T](var value: T)
```

## Implicit Conversions and Using

```scala
// Implicit parameters (Scala 2)
implicit val ordering: Ordering[Int] = Ordering.Int
def findMax[T](list: List[T])(implicit ord: Ordering[T]): T = list.max(ord)

// Using (Scala 3)
def findMax[T](list: List[T])(using ord: Ordering[T]): T = list.max(ord)

// Extension methods (Scala 3)
extension (s: String) {
  def isPalindrome: Boolean = s == s.reverse
  def wordCount: Int = s.split("\\s+").length
  def truncate(maxLen: Int): String =
    if (s.length > maxLen) s.take(maxLen) + "..." else s
}

"racecar".isPalindrome    // true
"Hello World".wordCount   // 2
"Long text here".truncate(8)  // "Long te..."

// Given instances (Scala 3)
given Ordering[Int] = Ordering.Int
given [T](using ord: Ordering[T]): Ordering[List[T]] with
  override def compare(x: List[T], y: List[T]): Int =
    x.zip(y).foldLeft(0) { case (0, (a, b)) => ord.compare(a, b); case (c, _) => c }
```

## For-Comprehensions and Monads

```scala
// For-comprehensions work with any type that has map/flatMap/withFilter
case class Try[+T](value: Option[T]) {
  def map[U](f: T => U): Try[U] = value.map(f) match {
    case Some(v) => Try(Some(v))
    case None => Try(None)
  }
  def flatMap[U](f: T => Try[U]): Try[U] = value match {
    case Some(v) => f(v)
    case None => Try(None)
  }
  def withFilter(p: T => Boolean): Try[T] = value.filter(p) match {
    case Some(v) => Try(Some(v))
    case None => Try(None)
  }
}
object Try {
  def apply[T](value: => T): Try[T] =
    try { Try(Some(value)) } catch { case _: Exception => Try(None) }
}

// For-comprehension with Try
val result = for {
  a <- Try("10".toInt)
  b <- Try("20".toInt)
} yield a + b
// Try(Some(30))
```

## Pattern Matching with OOP

```scala
// Sealed traits enable exhaustive pattern matching
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

def describe(shape: Shape): String = shape match {
  case Circle(r) if r > 10 => s"Large circle (r=$r)"
  case Circle(r)           => s"Circle (r=$r)"
  case Rectangle(w, h) if w == h => s"Square ($w)"
  case Rectangle(w, h)    => s"Rectangle ($w x $h)"
  case t: Triangle        => s"Triangle (a=${t.a}, b=${t.b}, c=${t.c})"
}
```

## Demo

```scala
// Complete demo: Shape hierarchy with traits, case classes, pattern matching
sealed trait Shape {
  def area: Double
  def perimeter: Double
  def describe: String
}

case class Circle(radius: Double) extends Shape {
  override def area: Double = Math.PI * radius * radius
  override def perimeter: Double = 2 * Math.PI * radius
  override def describe: String = f"Circle(r=$radius%.2f, area=$area%.2f)"
}

case class Rectangle(width: Double, height: Double) extends Shape {
  override def area: Double = width * height
  override def perimeter: Double = 2 * (width + height)
  override def describe: String = f"Rectangle($width%.2f x $height%.2f, area=$area%.2f)"
}

object Shape {
  def fromDimensions(width: Double, height: Double): Shape =
    if (width == height) Rectangle(width, height)
    else Rectangle(width, height)

  def circleFromArea(area: Double): Circle =
    Circle(Math.sqrt(area / Math.PI))
}

// Usage
val shapes: List[Shape] = List(Circle(5), Rectangle(4, 6), Circle(3))
shapes.foreach(s => println(s.describe))

// Pattern matching
val totalArea = shapes.map {
  case Circle(r)          => s"Circle area: ${Math.PI * r * r}"
  case Rectangle(w, h)    => s"Rectangle area: ${w * h}"
}
totalArea.foreach(println)
```

## See Also

- [[Scala/README|Scala Overview]]
- [[Scala/Basics/syntax|Scala Syntax]]
- [[Scala/OOP/classes|Scala Classes (code)]]
