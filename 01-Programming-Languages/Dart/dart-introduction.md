# Dart Introduction

## Why Learn Dart?
Dart is a client-optimized language developed by Google for building fast apps on any platform. It's the language behind Flutter, Google's UI toolkit for building natively compiled applications.

## Key Features
- **Flutter**: Primary language for cross-platform mobile/web/desktop
- **Strong Typing**: Static type system with type inference
- **Null Safety**: Sound null safety since Dart 2.12
- **AOT/JIT Compilation**: Ahead-of-time and just-in-time compilation
- **Async/Await**: Built-in async support
- **Hot Reload**: Instant code changes during development
- **Cross-Platform**: iOS, Android, Web, Windows, macOS, Linux
- **Package Manager**: pub.dev ecosystem

## Getting Started

### Installation
1. Install Flutter SDK (includes Dart)
2. Or install Dart standalone from dart.dev
3. Verify: `dart --version`

### First Program
```dart
void main() {
  print('Hello, World!');
}
```

Save as `hello.dart` and run with `dart hello.dart`

## Basic Syntax

### Variables and Data Types
```dart
// Variables (type inference)
var name = 'Alice';
var age = 30;
var height = 5.5;
var isStudent = true;

// Explicit types
String cityName = 'New York';
int population = 8000000;
double area = 783.8;

// Constants (compile-time)
const pi = 3.14159;
const maxRetry = 3;

// Final (runtime constant)
final currentTime = DateTime.now();

// String interpolation
var greeting = 'Hello, $name!';
var calculation = '1 + 1 = ${1 + 1}';

// Multi-line strings
var paragraph = '''
This is a
multi-line string
''';
```

### Input/Output
```dart
// Output
print('Hello, World!');
print('Name: $name, Age: $age');

// Input
import 'dart:io';
print('Enter your name: ');
var name = stdin.readLineSync();
```

### Control Flow
```dart
// If-else
if (age >= 18) {
  print('Adult');
} else if (age >= 13) {
  print('Teenager');
} else {
  print('Child');
}

// Ternary operator
var status = age >= 18 ? 'Adult' : 'Minor';

// Switch
switch (day) {
  case 'Monday':
    print('Start of week');
    break;
  case 'Friday':
    print('Almost weekend');
    break;
  default:
    print('Midweek');
}

// Switch expression (Dart 3+)
var result = switch (day) {
  'Monday' => 'Start of week',
  'Friday' => 'Almost weekend',
  _ => 'Midweek',
};

// For loop
for (var i = 0; i < 5; i++) {
  print(i);
}

// For-in loop
var numbers = [1, 2, 3, 4, 5];
for (var number in numbers) {
  print(number);
}

// While loop
var count = 5;
while (count > 0) {
  count--;
}

// Do-while
do {
  print(count);
  count++;
} while (count < 5);
```

### Functions
```dart
// Basic function
int add(int a, int b) {
  return a + b;
}

// Arrow syntax
int multiply(int a, int b) => a * b;

// Default parameters
String greet(String name, [String greeting = 'Hello']) {
  return '$greeting, $name!';
}

// Named parameters
String createPerson({required String name, required int age, String? email}) {
  return '$name, $age${email != null ? ', $email' : ''}';
}

// Usage
createPerson(name: 'Alice', age: 30);
createPerson(name: 'Bob', age: 25, email: 'bob@example.com');

// First-class functions
var numbers = [1, 2, 3, 4, 5];
var doubled = numbers.map((n) => n * 2).toList();
var evens = numbers.where((n) => n % 2 == 0).toList();
var sum = numbers.reduce((a, b) => a + b);

// Closures
Function makeCounter() {
  var count = 0;
  return () => count++;
}
```

### Null Safety
```dart
// Nullable types
String? nullableName = null;
int? nullableAge;

// Non-nullable (default)
String name = 'Alice';
int age = 30;

// Null check
if (nullableName != null) {
  print(nullableName.toUpperCase());
}

// Null-aware operators
var displayName = nullableName ?? 'Unknown';
var length = nullableName?.length ?? 0;

// Late variables
late String description;
description = 'This is initialized later';

// Null assertion (use cautiously)
var length = nullableName!.length;
```

### Classes
```dart
// Basic class
class Person {
  String name;
  int age;

  Person(this.name, this.age);

  String greet() => 'Hello, I\'m $name';
}

// Named constructors
class Person {
  String name;
  int age;

  Person(this.name, this.age);
  Person.anonymous() : name = 'Anonymous', age = 0;
  Person.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        age = map['age'];
}

// Inheritance
class Student extends Person {
  String grade;

  Student(String name, int age, this.grade) : super(name, age);

  @override
  String greet() => '${super.greet()}, and I\'m a student';
}

// Abstract class
abstract class Shape {
  double area();
  double perimeter();

  String describe() => 'Area: ${area()}, Perimeter: ${perimeter()}';
}

class Circle extends Shape {
  double radius;

  Circle(this.radius);

  @override
  double area() => 3.14159 * radius * radius;

  @override
  double perimeter() => 2 * 3.14159 * radius;
}

// Mixins
mixin Greetable {
  String get name;
  String greet() => 'Hello, I\'m $name';
}

mixin Loggable {
  void log(String message) {
    print('[${DateTime.now()}] $message');
  }
}

class User with Greetable, Loggable {
  @override
  String name;
  User(this.name);
}
```

### Enums
```dart
// Basic enum
enum Direction { north, south, east, west }

// Enhanced enums (Dart 2.17+)
enum Color {
  red(0xFF0000),
  green(0x00FF00),
  blue(0x0000FF);

  final int hex;
  const Color(this.hex);
}

// Pattern matching
var direction = Direction.north;
switch (direction) {
  case Direction.north:
    print('Going up');
    break;
  case Direction.south:
    print('Going down');
    break;
  default:
    print('Going sideways');
}
```

### Collections
```dart
// Lists
var numbers = [1, 2, 3, 4, 5];
numbers.add(6);
numbers.removeAt(0);
numbers[0]; // Access

// Unmodifiable
var immutable = List.unmodifiable([1, 2, 3]);

// Maps
var person = {
  'name': 'Alice',
  'age': 30,
  'email': 'alice@example.com'
};

person['name']; // Access
person['phone'] = '123-456-7890'; // Add/Update

// Sets
var uniqueNumbers = {1, 2, 3, 4, 5};
uniqueNumbers.add(6);

// Collection operations
var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

var doubled = numbers.map((n) => n * 2).toList();
var evens = numbers.where((n) => n % 2 == 0).toList();
var sum = numbers.reduce((a, b) => a + b);
var any = numbers.any((n) => n > 5);
var every = numbers.every((n) => n > 0);
var sorted = numbers.toList()..sort();
var found = numbers.firstWhere((n) => n > 3);

// Spread operator
var list1 = [1, 2, 3];
var list2 = [4, 5, 6];
var combined = [...list1, ...list2];

// Collection if
var include = true;
var list = [
  1,
  2,
  if (include) 3,
  4,
];

// Collection for
var list = [for (var i = 0; i < 5; i++) i * 2];
```

### Generics
```dart
// Generic class
class Stack<T> {
  final List<T> _items = [];

  void push(T item) => _items.add(item);
  T pop() => _items.removeLast();
  bool get isEmpty => _items.isEmpty;
}

// Generic function
T first<T>(List<T> list) => list.first;

// Generic constraint
T max<T extends num>(T a, T b) => a > b ? a : b;

// Usage
var intStack = Stack<int>();
var stringStack = Stack<String>();
```

### Async/Await
```dart
// Future
Future<String> fetchData() async {
  await Future.delayed(Duration(seconds: 2));
  return 'Data loaded';
}

// Async/await
Future<void> loadData() async {
  try {
    var data = await fetchData();
    print(data);
  } catch (e) {
    print('Error: $e');
  }
}

// Parallel execution
Future<void> loadAll() async {
  var results = await Future.wait([
    fetchData1(),
    fetchData2(),
    fetchData3(),
  ]);
}

// Stream
Stream<int> countStream() async* {
  for (var i = 0; i < 5; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}

// Listen to stream
countStream().listen((value) {
  print(value);
});
```

### Exceptions
```dart
// Try-catch
try {
  var result = 10 ~/ 0;
} on IntegerDivisionByZeroException {
  print('Division by zero');
} catch (e) {
  print('Error: $e');
} finally {
  print('Always runs');
}

// Custom exceptions
class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);

  @override
  String toString() => 'ValidationException: $message';
}

// Throw
void validateAge(int age) {
  if (age < 0) {
    throw ValidationException('Age must be positive');
  }
}
```

### Libraries and Imports
```dart
// Import library
import 'dart:io';
import 'dart:async';

// Import package
import 'package:http/http.dart' as http;

// Import with prefix
import 'package:my_package/my_package.dart' as my;

// Deferred loading
import 'package:heavy/heavy.dart' deferred as heavy;

// Export
export 'src/models/user.dart';
export 'src/services/api.dart';
```

## Best Practices
1. Use null safety features
2. Prefer `final` over `var` when possible
3. Use named parameters for clarity
4. Write documentation comments (///)
5. Follow Effective Dart guidelines
6. Use lints package for static analysis
7. Write tests with `dart test`

## Common Pitfalls
- Not handling null values properly
- Using `dynamic` when types are known
- Forgetting to await futures
- Not using const constructors
- Ignoring lint warnings
- Not handling exceptions