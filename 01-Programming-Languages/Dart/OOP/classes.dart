/// Shape Hierarchy in Dart OOP
///
/// Demonstrates: abstract classes, mixins, interfaces, generics,
/// extension methods, enums, and sealed classes.

import 'dart:math';

// ============================================================
// Abstract Base Class
// ============================================================

/// Abstract base class for all shapes
abstract class Shape {
  String get name;
  String get color;

  double area();
  double perimeter();

  void draw() {
    print('Drawing $name (color: $color)');
  }

  void describe() {
    print('$name - Area: ${area().toStringAsFixed(2)}, '
        'Perimeter: ${perimeter().toStringAsFixed(2)}, Color: $color');
  }

  @override
  String toString() => '$name (area: ${area().toStringAsFixed(2)})';
}

// ============================================================
// Mixins for Reusable Behavior
// ============================================================

/// Mixin for shapes that can be scaled
mixin Scalable {
  double scale(double factor) => factor;
}

/// Mixin for shapes that contain points
mixin Containable {
  bool containsPoint(double x, double y) => false;
}

/// Mixin for shapes that can be rotated
mixin Rotatable {
  double rotate(double angle) => angle;
}

// ============================================================
// Concrete Shape Classes
// ============================================================

/// Circle class implementing Shape with mixins
class Circle extends Shape with Scalable, Containable {
  final double radius;
  final String _color;

  Circle(this.radius, {String color = 'red'})
      : _color = color {
    assert(radius > 0, 'Radius must be positive');
  }

  @override
  String get name => 'Circle';

  @override
  String get color => _color;

  @override
  double area() => pi * radius * radius;

  @override
  double perimeter() => 2 * pi * radius;

  @override
  bool containsPoint(double x, double y) {
    return (x * x + y * y) <= (radius * radius);
  }

  /// Factory method to create unit circle
  factory Circle.unit({String color = 'red'}) => Circle(1.0, color: color);

  /// Factory method to create circle from diameter
  factory Circle.fromDiameter(double diameter, {String color = 'red'}) =>
      Circle(diameter / 2, color: color);
}

/// Rectangle class
class Rectangle extends Shape with Scalable, Containable {
  final double width;
  final double height;
  final String _color;

  Rectangle(this.width, this.height, {String color = 'blue'})
      : _color = color {
    assert(width > 0 && height > 0, 'Dimensions must be positive');
  }

  @override
  String get name => 'Rectangle';

  @override
  String get color => _color;

  @override
  double area() => width * height;

  @override
  double perimeter() => 2 * (width + height);

  bool get isSquare => width == height;

  @override
  bool containsPoint(double x, double y) {
    return x >= 0 && x <= width && y >= 0 && y <= height;
  }

  /// Create a square
  factory Rectangle.square(double side, {String color = 'green'}) =>
      Rectangle(side, side, color: color);
}

/// Square class extending Rectangle
class Square extends Rectangle {
  Square(double side, {String color = 'green'})
      : super(side, side, color: color);

  double get side => width;

  @override
  String get name => 'Square';

  @override
  void draw() {
    print('Drawing square: side=$side, color=$color');
  }
}

/// Triangle class using Heron's formula
class Triangle extends Shape with Scalable {
  final double a, b, c;
  final String _color;

  Triangle(this.a, this.b, this.c, {String color = 'yellow'})
      : _color = color {
    assert(a > 0 && b > 0 && c > 0, 'Sides must be positive');
    assert(a + b > c && b + c > a && a + c > b, 'Invalid triangle sides');
  }

  @override
  String get name => 'Triangle';

  @override
  String get color => _color;

  @override
  double area() {
    var s = (a + b + c) / 2;
    return sqrt(s * (s - a) * (s - b) * (s - c)); // Heron's formula
  }

  @override
  double perimeter() => a + b + c;

  /// Factory for equilateral triangle
  factory Triangle.equilateral(double side, {String color = 'white'}) =>
      Triangle(side, side, side, color: color);

  /// Factory for right triangle
  factory Triangle.right(double a, double b, {String color = 'white'}) {
    var c = sqrt(a * a + b * b);
    return Triangle(a, b, c, color: color);
  }
}

// ============================================================
// Interface Implementation
// ============================================================

/// Abstract interface for drawable objects
abstract class Drawable {
  void draw();
  String get description;
}

/// Interface for measurable objects
abstract class Measurable {
  double area();
  double perimeter();
}

/// Class implementing multiple interfaces
class ShapeAdapter implements Drawable, Measurable {
  final Shape _shape;

  ShapeAdapter(this._shape);

  @override
  void draw() => _shape.draw();

  @override
  String get description => _shape.toString();

  @override
  double area() => _shape.area();

  @override
  double perimeter() => _shape.perimeter();
}

// ============================================================
// Generic Collection
// ============================================================

/// Generic container for shapes with constraints
class ShapeCollection<T extends Shape> {
  final List<T> _shapes = [];

  void add(T shape) => _shapes.add(shape);

  void addAll(List<T> shapes) => _shapes.addAll(shapes);

  int get length => _shapes.length;

  bool get isEmpty => _shapes.isEmpty;

  T? get largest {
    if (_shapes.isEmpty) return null;
    return _shapes.reduce((a, b) => a.area() > b.area() ? a : b);
  }

  T? get smallest {
    if (_shapes.isEmpty) return null;
    return _shapes.reduce((a, b) => a.area() < b.area() ? a : b);
  }

  double totalArea() => _shapes.fold(0, (sum, shape) => sum + shape.area());

  List<T> sortedByArea() => List<T>.from(_shapes)
    ..sort((a, b) => b.area().compareTo(a.area()));

  List<T> filterByColor(String color) =>
      _shapes.where((s) => s.color == color).toList();

  void describeAll() {
    for (var shape in _shapes) {
      shape.describe();
    }
  }
}

// ============================================================
// Extension Methods
// ============================================================

/// Extension on Shape
extension ShapeExtension on Shape {
  bool get isLarge => area() > 100;
  bool get isSmall => area() < 10;

  Shape scaled(double factor) {
    if (this is Circle) {
      return Circle((this as Circle).radius * factor, color: color);
    } else if (this is Rectangle) {
      var rect = this as Rectangle;
      return Rectangle(rect.width * factor, rect.height * factor, color: color);
    } else if (this is Triangle) {
      var tri = this as Triangle;
      return Triangle(
        tri.a * factor,
        tri.b * factor,
        tri.c * factor,
        color: color,
      );
    }
    return this;
  }
}

/// Extension on collections of shapes
extension ShapeListExtension<T extends Shape> on List<T> {
  double totalArea() => fold(0, (sum, shape) => sum + shape.area());

  T? get largestOrNull =>
      isEmpty ? null : reduce((a, b) => a.area() > b.area() ? a : b);

  Map<String, int> countByColor() {
    var counts = <String, int>{};
    for (var shape in this) {
      counts[shape.color] = (counts[shape.color] ?? 0) + 1;
    }
    return counts;
  }
}

// ============================================================
// Sealed Class Pattern
// ============================================================

/// Sealed class for shape operations
sealed class ShapeOperation {
  const ShapeOperation();
}

class CalculateArea extends ShapeOperation {
  final Shape shape;
  const CalculateArea(this.shape);
}

class CalculatePerimeter extends ShapeOperation {
  final Shape shape;
  const CalculatePerimeter(this.shape);
}

class CompareShapes extends ShapeOperation {
  final Shape shape1;
  final Shape shape2;
  const CompareShapes(this.shape1, this.shape2);
}

/// Process shape operations using pattern matching
String processOperation(ShapeOperation operation) {
  return switch (operation) {
    CalculateArea(:final shape) =>
      'Area: ${shape.area().toStringAsFixed(2)}',
    CalculatePerimeter(:final shape) =>
      'Perimeter: ${shape.perimeter().toStringAsFixed(2)}',
    CompareShapes(:final shape1, :final shape2) =>
      shape1.area() > shape2.area()
          ? '${shape1.name} is larger'
          : shape2.area() > shape1.area()
              ? '${shape2.name} is larger'
              : 'Both have equal area',
  };
}

// ============================================================
// Enum for Shape Types
// ============================================================

enum ShapeType {
  circle('Circle'),
  rectangle('Rectangle'),
  square('Square'),
  triangle('Triangle');

  final String displayName;
  const ShapeType(this.displayName);

  bool get isRound => this == ShapeType.circle;
  bool get hasFourSides =>
      this == ShapeType.rectangle || this == ShapeType.square;
}

// ============================================================
// Factory Pattern
// ============================================================

/// Factory for creating shapes
class ShapeFactory {
  static Shape createCircle(double radius, {String color = 'red'}) {
    return Circle(radius, color: color);
  }

  static Shape createRectangle(double width, double height,
      {String color = 'blue'}) {
    if (width == height) {
      return Square(width, color: color);
    }
    return Rectangle(width, height, color: color);
  }

  static Shape createTriangle(double a, double b, double c,
      {String color = 'yellow'}) {
    return Triangle(a, b, c, color: color);
  }

  /// Create shape from map (simulating JSON deserialization)
  static Shape fromMap(Map<String, dynamic> map) {
    var type = map['type'] as String;
    var color = map['color'] as String? ?? 'default';

    switch (type) {
      case 'circle':
        return Circle(map['radius'] as double, color: color);
      case 'rectangle':
        return Rectangle(
          map['width'] as double,
          map['height'] as double,
          color: color,
        );
      case 'triangle':
        return Triangle(
          map['a'] as double,
          map['b'] as double,
          map['c'] as double,
          color: color,
        );
      default:
        throw ArgumentError('Unknown shape type: $type');
    }
  }
}

// ============================================================
// Demo / Main
// ============================================================

void main() {
  print('=== Dart OOP Classes Demo ===\n');

  // Create shapes
  var circle = Circle(5.0, color: 'crimson');
  var rectangle = Rectangle(4.0, 6.0, color: 'navy');
  var square = Square(3.0, color: 'emerald');
  var triangle = Triangle.equilateral(4.0, color: 'gold');
  var rightTriangle = Triangle.right(3.0, 4.0, color: 'silver');

  // Draw all shapes
  print('--- Drawing Shapes ---');
  var shapes = [circle, rectangle, square, triangle, rightTriangle];
  for (var shape in shapes) {
    shape.draw();
  }

  // Print report
  print('\n--- Shape Report ---');
  for (var shape in shapes) {
    shape.describe();
  }

  // Generic collection
  print('\n--- Generic Collection ---');
  var collection = ShapeCollection<Shape>();
  collection.addAll(shapes);
  print('Total area: ${collection.totalArea().toStringAsFixed(2)}');
  print('Largest: ${collection.largest}');
  print('Smallest: ${collection.smallest}');

  // Count by color
  print('\n--- Count by Color ---');
  var colorCounts = shapes.map((s) => s.color).fold<Map<String, int>>(
    {},
    (map, color) => map..[color] = (map[color] ?? 0) + 1,
  );
  colorCounts.forEach((color, count) {
    print('  $color: $count');
  });

  // Extension methods
  print('\n--- Extension Methods ---');
  print('Circle is large: ${circle.isLarge}');
  print('Square is small: ${square.isSmall}');

  // Scale using extension
  var scaledCircle = circle.scaled(2.0) as Circle;
  print('Scaled circle radius: ${scaledCircle.radius}');

  // Sealed class operations
  print('\n--- Sealed Class Operations ---');
  var ops = [
    CalculateArea(circle),
    CalculatePerimeter(rectangle),
    CompareShapes(circle, rectangle),
  ];
  for (var op in ops) {
    print('  ${processOperation(op)}');
  }

  // Factory pattern
  print('\n--- Factory Pattern ---');
  var factoryCircle = ShapeFactory.createCircle(7.0, color: 'purple');
  var factoryRect = ShapeFactory.createRectangle(5.0, 5.0, color: 'orange');
  print('Factory circle: ${factoryCircle.describe()}');
  print('Factory rect (actually square): ${factoryRect.describe()}');

  // From map (JSON deserialization)
  var mapShape = ShapeFactory.fromMap({
    'type': 'circle',
    'radius': 10.0,
    'color': 'teal',
  });
  print('From map: ${mapShape.describe()}');

  // Interface implementation
  print('\n--- Interface Implementation ---');
  var adapter = ShapeAdapter(circle);
  adapter.draw();
  print('Adapter description: ${adapter.description}');
  print('Adapter area: ${adapter.area().toStringAsFixed(2)}');

  // Enum usage
  print('\n--- Enum Usage ---');
  for (var type in ShapeType.values) {
    print('  ${type.displayName} - isRound: ${type.isRound}, '
        'hasFourSides: ${type.hasFourSides}');
  }

  // Point containment
  print('\n--- Point Containment ---');
  var point = Point(2.0, 2.0);
  print('Circle contains (2,2): ${circle.containsPoint(point.x, point.y)}');
  print('Rectangle contains (2,2): ${rectangle.containsPoint(point.x, point.y)}');
  print('Square contains (2,2): ${square.containsPoint(point.x, point.y)}');
}

// Simple Point class for containment demo
class Point {
  final double x, y;
  const Point(this.x, this.y);
}
