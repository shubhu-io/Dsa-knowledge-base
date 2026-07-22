# Dart Syntax

## Overview

Dart is a modern, object-oriented language with strong typing and null safety. This guide covers the core syntax and features you need to write idiomatic Dart.

## Variables and Types

```dart
// Type inference
var name = 'Dart';          // String
var age = 25;               // int
var pi = 3.14;              // double
var isReady = true;         // bool

// Explicit types
String label = 'Hello';
int count = 10;
double temperature = 98.6;
bool isActive = true;

// Late variables (initialized on first use)
late String description;
description = 'This is initialized later';

// Final and const
final String finalName = 'Cannot change';  // Runtime constant
const String constName = 'Compile-time constant';  // Compile-time constant
const int maxRetries = 3;  // You can use const for compile-time constants

// Dynamic type
dynamic anything = 'Can be any type';
anything = 42;  // Allowed
```

## Null Safety

Dart's sound null safety eliminates null reference errors:

```dart
// Non-nullable (cannot be null)
String name = 'Alice';
// name = null;  // Compile error

// Nullable (can be null)
String? nullableName = 'Alice';
nullableName = null;  // Allowed

// Null-aware operators
print(nullableName?.length);      // null if nullableName is null
print(nullableName ?? 'Default'); // 'Default' if null

// Null assertion (!) - throws if null
// print(nullableName!.length);  // Dangerous: throws if null

// If null assignment
String ??= 'Default value';

// Null-aware cascade
nullableName?.toLowerCase();

// Late nullable
late String? lazyNullable;
lazyNullable = 'Assigned later';
```

## Collections

```dart
// List (ordered, allows duplicates)
var numbers = [1, 2, 3, 4, 5];
var names = <String>['Alice', 'Bob'];
var emptyList = <int>[];

// Spread operator
var combined = [0, ...numbers, 6];  // [0, 1, 2, 3, 4, 5, 6]

// Null-aware spread
var nullableList = null;
var safeList = [1, ...?nullableList, 2];  // [1, 2]

// List comprehension
var evens = [for (var i = 0; i < 10; i++) if (i.isEven) i];  // [0, 2, 4, 6, 8]

// Set (unordered, unique)
var fruits = {'Apple', 'Banana', 'Cherry'};
var emptySet = <String>{};

// Set operations
var setA = {1, 2, 3};
var setB = {2, 3, 4};
print(setA.union(setB));        // {1, 2, 3, 4}
print(setA.intersection(setB)); // {2, 3}
print(setA.difference(setB));   // {1}

// Map (key-value pairs)
var ages = {'Alice': 30, 'Bob': 25};
var emptyMap = <String, int>{};

ages['Charlie'] = 35;
print(ages['Alice']);  // 30
ages.remove('Bob');

// Map from iterable
var mapFromList = Map.fromIterable(
  numbers,
  key: (item) => 'num_$item',
  value: (item) => item * 10,
);
```

## Functions

```dart
// Basic function
String greet(String name) {
  return 'Hello, $name!';
}

// Expression body (single expression)
String greetShort(String name) => 'Hello, $name!';

// Optional positional parameters
String describe(String name, [int? age, String? city]) {
  var result = name;
  if (age != null) result += ', age $age';
  if (city != null) result += ', from $city';
  return result;
}

// Named parameters
void createUser({
  required String name,
  required String email,
  int age = 0,
  String? phone,
}) {
  print('Creating user: $name, $email, age $age');
}

// Arrow functions
var double = (int x) => x * 2;
var add = (int a, int b) => a + b;

// Higher-order functions
void numbers.forEach((n) => print(n));
var doubled = numbers.map((n) => n * 2).toList();
var evens = numbers.where((n) => n.isEven).toList();
var sum = numbers.reduce((a, b) => a + b);

// Tear-off (function reference)
var names = ['Charlie', 'Alice', 'Bob'];
names.sort();  // Uses default comparator
names.sort((a, b) => a.compareTo(b));  // Explicit comparator
```

## Control Flow

```dart
// if/else
if (temperature > 30) {
  print('Hot!');
} else if (temperature > 20) {
  print('Warm');
} else {
  print('Cold');
}

// switch expression (Dart 3+)
String describeAnimal(String type) => switch (type) {
  'cat' => 'Meow',
  'dog' => 'Woof',
  'bird' => 'Tweet',
  _ => 'Unknown',
};

// Traditional switch
switch (grade) {
  case 'A':
    print('Excellent');
    break;
  case 'B':
    print('Good');
    break;
  default:
    print('Other');
}

// for loop
for (var i = 0; i < 5; i++) {
  print(i);
}

// for-in loop
for (var name in names) {
  print(name);
}

// forEach
numbers.forEach((n) => print(n));

// while
while (count > 0) {
  count--;
}

// do-while
do {
  count++;
} while (count < 5);

// assert (debug mode only)
assert(age >= 0, 'Age cannot be negative');
```

## Classes and Objects

```dart
// Basic class
class Person {
  String name;
  int age;

  // Constructor
  Person(this.name, this.age);

  // Named constructor
  Person.guest() : name = 'Guest', age = 0;

  // Factory constructor
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(json['name'] as String, json['age'] as int);
  }

  // Method
  String greet() => 'Hello, $name!';

  // Getter
  bool get isAdult => age >= 18;

  // Setter
  set birthday() => age++;
}

// Using classes
var person = Person('Alice', 30);
print(person.greet());
print(person.isAdult);
```

## Inheritance

```dart
// Base class
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
  double area();
  double perimeter();

  void describe() {
    print('Area: ${area()}, Perimeter: ${perimeter()}');
  }
}

class Circle extends Shape {
  final double radius;

  Circle(this.radius);

  @override
  double area() => 3.14159 * radius * radius;

  @override
  double perimeter() => 2 * 3.14159 * radius;
}
```

## Async/Await

```dart
// Future
Future<String> fetchData() async {
  await Future.delayed(Duration(seconds: 1));
  return 'Data loaded';
}

// Using async/await
void loadData() async {
  try {
    var data = await fetchData();
    print(data);
  } catch (e) {
    print('Error: $e');
  }
}

// Future chaining
fetchData()
  .then((data) => print(data))
  .catchError((e) => print('Error: $e'));

// Stream
Stream<int> countStream() async* {
  for (var i = 1; i <= 5; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}

// Using streams
void listenToStream() async {
  await for (var value in countStream()) {
    print(value);
  }
}

// Future.wait - parallel execution
var results = await Future.wait([
  fetchData(),
  fetchData(),
  fetchData(),
]);
```

## Mixins

```dart
// Mixin definition
mixin Swimmable {
  void swim() => print('Swimming');
}

mixin Flyable {
  void fly() => print('Flying');
}

mixin Walkable {
  void walk() => print('Walking');
}

// Using mixins
class Duck extends Animal with Swimmable, Flyable, Walkable {
  Duck(String name) : super(name);
}

// Mixin with constraints
mixin Singable on Animal {
  void sing() => print('$name is singing');
}

class Bird extends Animal with Singable {
  Bird(String name) : super(name);
}
```

## Extension Methods

```dart
// Extension on existing type
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
}

// Extension on custom type
extension PointExtension on Point {
  double distanceTo(Point other) {
    var dx = x - other.x;
    var dy = y - other.y;
    return (dx * dx + dy * dy).sqrt();
  }
}

// Usage
print('Racecar'.isPalindrome);  // true
print('Hello World'.wordCount);  // 2
print('hello'.capitalize());  // 'Hello'
```

## Operators

```dart
// Arithmetic operators
var sum = 5 + 3;    // 8
var diff = 10 - 4;  // 6
var product = 2 * 3; // 6
var quotient = 10 / 3; // 3.333...
var mod = 10 % 3;   // 1

// Comparison operators
print(5 == 5);  // true
print(5 != 3);  // true
print(5 > 3);   // true
print(5 < 3);   // false

// Logical operators
print(true && false);  // false
print(true || false);  // true
print(!true);          // false

// Type test operators
print('hello' is String);    // true
print('hello' is! int);      // true

// Cascade notation
var button = Button()
  ..color = Colors.blue
  ..text = 'Click me'
  ..onPressed = () => print('Clicked');

// Spread operator (in collections)
var list = [1, 2, ...?[3, 4]];
```

## Cascades

```dart
// Cascade allows chaining operations on same object
var paint = Paint()
  ..color = Colors.blue
  ..strokeCap = StrokeCap.round
  ..strokeWidth = 5.0
  ..style = PaintingStyle.stroke;

// Null-aware cascade
button?..color = Colors.red..text = 'Updated';

// Method cascades
var list = [1, 2, 3]
  ..add(4)
  ..addAll([5, 6])
  ..sort();
```

## Isolates (Concurrency)

```dart
import 'dart:isolate';

// Basic isolate
void isolateFunction(message) {
  print('Running in isolate: $message');
  Isolate.exit('Result from isolate');
}

// Using compute-like pattern
Future<String> heavyComputation() async {
  var receivePort = ReceivePort();
  await Isolate.spawn(
    (SendPort sendPort) {
      // Heavy computation here
      var result = 'computed result';
      sendPort.send(result);
    },
    receivePort.sendPort,
  );
  return await receivePort.first;
}

// Using Isolate.run (Dart 2.19+)
var result = await Isolate.run(() {
  // Heavy computation
  return 'result from isolate';
});
```

## Try/Catch/Finally

```dart
try {
  var data = await fetchData();
  print(data);
} on FormatException catch (e) {
  print('Format error: ${e.message}');
} on TimeoutException {
  print('Request timed out');
} catch (e, stackTrace) {
  print('Error: $e');
  print('Stack: $stackTrace');
} finally {
  print('Cleanup code runs always');
}

// Try with finally
try {
  var file = File('data.txt');
  var content = await file.readAsString();
} finally {
  print('Operation completed');
}
```

## Records (Dart 3+)

```dart
// Record types
(String, int) getUserInfo() => ('Alice', 30);

var (name, age) = getUserInfo();  // Pattern matching
print('$name is $age years old');

// Named fields
({String name, int age, String email}) createUser() {
  return (name: 'Bob', age: 25, email: 'bob@example.com');
}

var user = createUser();
print(user.name);  // Bob

// Switch with records
switch ((statusCode, message)) {
  case (200, var msg):
    print('Success: $msg');
  case (404, _):
    print('Not found');
  case (>= 500, _):
    print('Server error');
}
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
  earth(mass: 5.976e+24, radius: 6.37814e6);

  final double mass;
  final double radius;

  const Planet({required this.mass, required this.radius});

  double get surfaceGravity => 6.67300E-11 * mass / (radius * radius);
}
```

## Pattern Matching (Dart 3+)

```dart
// Destructuring
var (x, y) = (10, 20);
print('$x, $y');

// Switch expressions with patterns
String describe(dynamic value) => switch (value) {
  int n when n > 0 => 'Positive: $n',
  int n when n < 0 => 'Negative: $n',
  0 => 'Zero',
  String s => 'String: $s',
  _ => 'Other',
};

// Guard clauses
void process(dynamic value) {
  switch (value) {
    case int n when n > 100:
      print('Large number: $n');
    case String s when s.length > 5:
      print('Long string: $s');
    default:
      print('Default case');
  }
}
```

## See Also

- [[README]] - Dart overview and Flutter connection
- [[OOP/oop]] - Object-oriented programming in Dart
- [[Algorithms/String/string_algorithms]] - String algorithm implementations
- [[02-Data-Structures]] - Data structure implementations
