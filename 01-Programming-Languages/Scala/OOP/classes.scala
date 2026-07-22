/**
 * Shape Hierarchy in Scala
 *
 * Demonstrates Scala OOP: traits, case classes, abstract classes,
 * companion objects, pattern matching, and mixins.
 *
 * Run: scala classes.scala
 */

// ============================================================
// Traits: Interfaces + implementation
// ============================================================
trait Drawable {
  def draw(): String
}

trait Resizable {
  def resize(factor: Double): Unit
}

trait PrettyPrint {
  def prettyPrint: String
}

// ============================================================
// Abstract class: Common shape behavior
// ============================================================
abstract class Shape(val color: String = "black") extends Drawable with PrettyPrint {
  def area: Double
  def perimeter: Double
  def typeName: String

  def describe: String =
    f"$typeName [$color]: area=$area%.2f, perimeter=$perimeter%.2f"

  override def prettyPrint: String = describe

  // Compare shapes by area
  def compareArea(other: Shape): Int = this.area.compareTo(other.area)
}

// ============================================================
// Case classes: Immutable data carriers
// ============================================================
case class Circle(
  radius: Double,
  color: String = "black"
) extends Shape(color) with Resizable {

  override def area: Double = Math.PI * radius * radius
  override def perimeter: Double = 2 * Math.PI * radius
  override def typeName: String = "Circle"

  override def draw(): String =
    s"Drawing circle r=$radius [color=$color]"

  override def resize(factor: Double): Unit =
    // Case classes are immutable, so this creates a new copy
    // For mutability, use a regular class with var
    println(s"Cannot resize immutable case class. Use copy() instead.")

  def resized(factor: Double): Circle = copy(radius = radius * factor)
}

case class Rectangle(
  width: Double,
  height: Double,
  color: String = "black"
) extends Shape(color) with Resizable {

  override def area: Double = width * height
  override def perimeter: Double = 2 * (width + height)
  override def typeName: String =
    if (width == height) "Square" else "Rectangle"

  override def draw(): String =
    s"Drawing rectangle ${width}x$height [color=$color]"

  override def resize(factor: Double): Unit =
    println(s"Cannot resize immutable case class. Use copy() instead.")

  def resized(factor: Double): Rectangle = copy(width = width * factor, height = height * factor)
}

case class Triangle(
  a: Double,
  b: Double,
  c: Double,
  color: String = "black"
) extends Shape(color) {

  override def area: Double = {
    val s = (a + b + c) / 2
    Math.sqrt(s * (s - a) * (s - b) * (s - c))
  }

  override def perimeter: Double = a + b + c
  override def typeName: String = "Triangle"

  override def draw(): String =
    s"Drawing triangle ($a, $b, $c) [color=$color]"
}

// ============================================================
// Companion object: Factory methods and constants
// ============================================================
object Shape {
  // Factory methods
  def circle(radius: Double, color: String = "black"): Circle =
    Circle(radius, color)

  def rectangle(width: Double, height: Double, color: String = "black"): Rectangle =
    Rectangle(width, height, color)

  def square(side: Double, color: String = "black"): Rectangle =
    Rectangle(side, side, color)

  def triangle(a: Double, b: Double, c: Double, color: String = "black"): Triangle =
    Triangle(a, b, c, color)

  // Validate triangle sides
  def isValidTriangle(a: Double, b: Double, c: Double): Boolean =
    a + b > c && a + c > b && b + c > a

  // Constants
  val PI: Double = Math.PI
}

// ============================================================
// Shape collection with functional operations
// ============================================================
class ShapeCollection(shapes: List[Shape] = List.empty) {
  def add(shape: Shape): ShapeCollection =
    new ShapeCollection(shapes :+ shape)

  def sortedByArea: List[Shape] = shapes.sortBy(_.area)

  def totalArea: Double = shapes.map(_.area).sum

  def filterByType[T <: Shape](implicit manifest: scala.reflect.ClassTag[T]): List[Shape] =
    shapes.filter(_.isInstanceOf[T])

  def largest: Option[Shape] = shapes.maxByOption(_.area)
  def smallest: Option[Shape] = shapes.minByOption(_.area)

  def count: Int = shapes.size
  def all: List[Shape] = shapes
}

// ============================================================
// Pattern matching with sealed traits
// ============================================================
sealed trait ShapeCategory
case object SmallShape extends ShapeCategory   // area < 10
case object MediumShape extends ShapeCategory  // 10 <= area < 50
case object LargeShape extends ShapeCategory   // area >= 50

def categorize(shape: Shape): ShapeCategory =
  shape.area match {
    case a if a < 10  => SmallShape
    case a if a < 50  => MediumShape
    case _            => LargeShape
  }

// ============================================================
// Demo
// ============================================================
object ShapeDemo extends App {
  println("=== Scala Shape Hierarchy ===\n")

  // Create shapes using companion object
  val shapes = List(
    Shape.circle(5, "red"),
    Shape.rectangle(4, 6, "blue"),
    Shape.square(3, "green"),
    Shape.triangle(3, 4, 5, "orange")
  )

  // Display all shapes
  println("All Shapes:")
  println("-" * 60)
  shapes.foreach(s => println(s"  ${s.describe}"))

  // Pattern matching
  println("\nDrawing shapes:")
  shapes.foreach { shape =>
    shape match {
      case Circle(r, c) if r > 4  => println(s"  Large circle! ${shape.draw()}")
      case Circle(r, c)           => println(s"  ${shape.draw()}")
      case Rectangle(w, h, c)     => println(s"  ${shape.draw()}")
      case t: Triangle            => println(s"  ${shape.draw()}")
    }
  }

  // Functional operations
  println("\nSorted by area (ascending):")
  shapes.sortBy(_.area).foreach(s =>
    println(f"  ${s.typeName}: ${s.area}%.2f")
  )

  // Collection
  val collection = shapes.foldLeft(new ShapeCollection())(_.add(_))
  println(s"\nTotal shapes: ${collection.count}")
  println(f"Total area: ${collection.totalArea}%.2f")

  // Categorize
  println("\nShape categories:")
  shapes.foreach { shape =>
    val category = categorize(shape)
    println(s"  ${shape.typeName}: $category")
  }

  // Resizing (creates new copy for case classes)
  println("\nResizing:")
  val original = Shape.circle(5)
  val resized = original.resized(2)
  println(f"  Original: r=${original.radius}%,.2f, area=${original.area}%.2f")
  println(f"  Resized:  r=${resized.radius}%,.2f, area=${resized.area}%.2f")

  // Pattern matching with copy
  println("\nCase class pattern matching:")
  val Circle(r, c) = Shape.circle(10, "red")
  println(s"  Extracted: radius=$r, color=$c")
}
