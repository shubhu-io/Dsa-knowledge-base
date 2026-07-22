# Dart Object-Oriented Programming

## Overview

Dart is a pure object-oriented language where every variable is an object and every operation is a method call. Its OOP model includes classes, interfaces (every class is an interface), abstract classes, mixins, and extension methods. With sound null safety, Dart provides compile-time guarantees about object references.

## Classes and Constructors

```dart
class Person {
  String name;
  int age;

  // Default constructor
  Person(this.name, this.age);

  // Named constructors
  Person.guest() : name = 'Guest', age = 0;

  Person.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        age = json['age'] as int;

  // Factory constructor
  factory Person.create(String name) {
    if (name.isEmpty) return Person.guest();
    return Person(name, 0);
  }

  // Initializer list
  Person.withDefaultAge(this.name, [int age = 18]) : age = age;

  // Method
  String greet() => 'Hello, $name!';

  // Getter
  bool get isAdult => age >= 18;

  // Setter
  set birthday() => age++;

  @override
  String toString() => 'Person($name, $age)';
}
```

## Inheritance

```dart
// Base class (all classes can be extended unless marked final/sealed)
class Animal {
  String name;

  Animal(this.name);

  void sound() => print('...');

  @override
  String toString() => '$name the animal';
}

// Subclass
class Dog extends Animal {
  Dog(String name) : super(name);

  @override
  void sound() => print('Woof!');
}

// Abstract class
abstract class Shape {
  String get name;

  double area();
  double perimeter();

  void describe() {
    print('$name - Area: ${area()}, Perimeter: ${perimeter()}');
  }

  @override
  String toString() => '$name (area: ${area()})';
}

class Circle extends Shape {
  final double radius;

  Circle(this.radius);

  @override
  String get name => 'Circle';

  @override
  double area() => 3.14159 * radius * radius;

  @override
  double perimeter() => 2 * 3.14159 * radius;
}
```

## Interfaces (Every Class is an Interface)

In Dart, every class implicitly defines an interface. You can implement any class without inheriting its implementation:

```dart
class Logger {
  void log(String message) => print('[LOG] $message');
}

// Implementing an interface (must override all methods)
class FileLogger implements Logger {
  @override
  void log(String message) {
    // Write to file instead
    print('[FILE] $message');
  }
}

// Abstract class as interface
abstract class Repository<T> {
  Future<T?> findById(String id);
  Future<List<T>> findAll();
  Future<void> save(T item);
  Future<void> delete(String id);
}

// Implementing interface
class UserRepository implements Repository<User> {
  final List<User> _users = [];

  @override
  Future<User?> findById(String id) async {
    return _users.firstWhere((u) => u.id == id, orElse: () => null);
  }

  @override
  Future<List<User>> findAll() async => List.unmodifiable(_users);

  @override
  Future<void> save(User item) async {
    _users.add(item);
  }

  @override
  Future<void> delete(String id) async {
    _users.removeWhere((u) => u.id == id);
  }
}
```

## Mixins

Mixins allow code reuse across multiple class hierarchies:

```dart
// Mixin definition
mixin Swimmable {
  void swim() => print('Swimming');
  bool get canSwim => true;
}

mixin Flyable {
  void fly() => print('Flying');
  bool get canFly => true;
}

mixin Walkable {
  void walk() => print('Walking');
  bool get canWalk => true;
}

// Using mixins
class Duck extends Animal with Swimmable, Flyable, Walkable {
  Duck(String name) : super(name);
}

class Penguin extends Animal with Swimmable, Walkable {
  Penguin(String name) : super(name);
}

// Mixin with constraints (can only be used on specific classes)
mixin Singable on Animal {
  void sing() => print('$name is singing');
}

class Bird extends Animal with Singable {
  Bird(String name) : super(name);
}

// Mixin with on clause
mixin Validator<T> on State<T> {
  String? validate(String value) {
    if (value.isEmpty) return 'Required';
    return null;
  }
}
```

## Extension Methods

Add functionality to existing types without modifying them:

```dart
// Extension on String
extension StringExtension on String {
  bool get isPalindrome {
    var cleaned = toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    return cleaned == cleaned.split('').reversed.join('');
  }

  int get wordCount => split(RegExp(r'\s+')).length;

  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String camelCase() {
    return split(RegExp(r'[_\s-]+'))
        .map((word) => word.capitalize())
        .join();
  }
}

// Extension on int
extension IntExtension on int {
  bool get isEven => this % 2 == 0;
  bool get isOdd => this % 2 != 0;

  int get squared => this * this;

  void times(void Function() action) {
    for (var i = 0; i < this; i++) {
      action();
    }
  }
}

// Extension on custom type
extension PointExtension on Point {
  double distanceTo(Point other) {
    var dx = x - other.x;
    var dy = y - other.y;
    return (dx * dx + dy * dy).sqrt();
  }

  Point midpoint(Point other) {
    return Point((x + other.x) / 2, (y + other.y) / 2);
  }
}

// Usage
print('racecar'.isPalindrome);  // true
print(5.squared);  // 25
print('hello world'.wordCount);  // 2
```

## Generics

```dart
// Generic class
class Box<T> {
  T? _value;

  T? get value => _value;
  set value(T? value) => _value = value;

  bool get isEmpty => _value == null;
}

// Generic with constraints
class Cache<K extends Object, V> {
  final Map<K, V> _map = {};

  V? get(K key) => _map[key];
  void set(K key, V value) => _map[key] = value;
  void remove(K key) => _map.remove(key);
  bool containsKey(K key) => _map.containsKey(key);
}

// Generic function
T findFirst<T>(List<T> list, bool Function(T) predicate) {
  for (var item in list) {
    if (predicate(item)) return item;
  }
  throw StateError('No element found');
}

// Generic mixin
mixin RepositoryMixin<T> {
  final List<T> _items = [];

  void add(T item) => _items.add(item);
  void remove(T item) => _items.remove(item);
  List<T> findAll() => List.unmodifiable(_items);
}

// Usage
var box = Box<int>();
box.value = 42;

var cache = Cache<String, User>();
cache.set('user1', User('Alice', 'alice@example.com'));

var numbers = [1, 2, 3, 4, 5];
var first = findFirst<int>(numbers, (n) => n > 3);
print(first);  // 4
```

## Enums

```dart
// Basic enum
enum Color { red, green, blue }

var c = Color.red;
print(c.name);  // 'red'
print(c.index);  // 0

// Enhanced enums (Dart 2.17+)
enum Planet {
  mercury(mass: 3.303e+23, radius: 2.4397e6),
  venus(mass: 4.869e+24, radius: 6.0518e6),
  earth(mass: 5.976e+24, radius: 6.37814e6),
  mars(mass: 6.421e+23, radius: 3.3972e6);

  final double mass;
  final double radius;

  const Planet({required this.mass, required this.radius});

  double get surfaceGravity => 6.67300E-11 * mass / (radius * radius);

  double surfaceWeight(double otherMass) => otherMass * surfaceGravity;
}

// Enum with methods
enum HttpStatus {
  ok(200, 'OK'),
  notFound(404, 'Not Found'),
  serverError(500, 'Internal Server Error');

  final int code;
  final String message;

  const HttpStatus(this.code, this.message);

  bool get isSuccess => code >= 200 && code < 300;
  bool get isError => code >= 400;
}
```

## Abstract Classes vs Interfaces

```dart
// Abstract class - provides partial implementation
abstract class Vehicle {
  String get make;
  String get model;
  double _mileage = 0;

  double get mileage => _mileage;

  void drive(double km) {
    _mileage += km;
  }

  String describe() => '$make $model';
}

// Interface - all classes are interfaces in Dart
class Engine {
  void start() => print('Engine started');
}

// Implementing multiple "interfaces"
class Car extends Vehicle implements Engine {
  @override
  String get make => 'Toyota';

  @override
  String get model => 'Camry';

  @override
  void start() => print('Car started');
}

// Abstract class as interface
abstract class Serializable {
  Map<String, dynamic> toJson();
  factory Serializable.fromJson(Map<String, dynamic> json) =>
      throw UnimplementedError();
}

class UserModel implements Serializable {
  final String name;
  final String email;

  UserModel(this.name, this.email);

  @override
  Map<String, dynamic> toJson() => {'name': name, 'email': email};

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(json['name'] as String, json['email'] as String);
  }
}
```

## Visibility

```dart
class AccessControl {
  String publicProp = 'Visible everywhere';
  String _privateProp = 'Visible only in this file';

  // Private by underscore prefix - file-level privacy
  void demo() {
    print(publicProp);
    print(_privateProp);  // Accessible here
  }
}

// Separate file cannot access _privateProp
// class Subclass extends AccessControl {
//   void show() {
//     print(publicProp);      // OK
//     // print(_privateProp);  // Error - not visible
//   }
// }
```

## Sealed Classes (Dart 3+)

```dart
// Sealed class - restricted hierarchy
sealed class Shape {
  double get area;
}

class Circle extends Shape {
  final double radius;
  Circle(this.radius);

  @override
  double get area => 3.14159 * radius * radius;
}

class Rectangle extends Shape {
  final double width, height;
  Rectangle(this.width, this.height);

  @override
  double get area => width * height;
}

// Exhaustive pattern matching
String describeShape(Shape shape) => switch (shape) {
  Circle(:var radius) => 'Circle with radius $radius',
  Rectangle(:var width, :var height) => 'Rectangle ${width}x$height',
};
```

## Final and Sealed Classes

```dart
// Final class - cannot be extended
final class ImmutablePoint {
  final double x, y;
  const ImmutablePoint(this.x, this.y);
}

// Sealed class - restricted inheritance
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Error<T> extends Result<T> {
  final String message;
  const Error(this.message);
}

// Pattern matching with sealed classes
String handleResult(Result<int> result) => switch (result) {
  Success(:final data) => 'Data: $data',
  Error(:final message) => 'Error: $message',
};
```

## See Also

- [[README]] - Dart overview and Flutter connection
- [[Basics/syntax]] - Core language features
- [[Algorithms/String/string_algorithms]] - String algorithm implementations
- [[02-Data-Structures]] - Data structure implementations
