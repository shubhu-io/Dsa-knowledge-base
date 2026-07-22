# Dart Basics Tutorial

## Variables and Constants

```dart
void main() {
  // Variables (type inference)
  var name = 'Alice';
  var age = 30;
  
  // Explicit types
  String city = 'New York';
  double height = 5.5;
  
  // Constants (compile-time)
  const pi = 3.14159;
  
  // Final (runtime constant)
  final currentTime = DateTime.now();
  
  // String interpolation
  var greeting = 'Hello, $name!';
  var calculation = '1 + 1 = ${1 + 1}';
}
```

## Data Types

- **int**: Integer numbers
- **double**: Decimal numbers
- **String**: Text
- **bool**: True/False
- **List**: Ordered collection
- **Map**: Key-value pairs
- **Set**: Unique values

## Control Flow

### If-Else
```dart
if (age >= 18) {
  print('Adult');
} else if (age >= 13) {
  print('Teenager');
} else {
  print('Child');
}
```

### Switch
```dart
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
```

### For Loop
```dart
for (var i = 0; i < 5; i++) {
  print(i);
}

// For-in loop
for (var number in [1, 2, 3]) {
  print(number);
}
```

## Functions

```dart
// Basic function
int add(int a, int b) {
  return a + b;
}

// Arrow syntax
int multiply(int a, int b) => a * b;

// Named parameters
String createPerson({required String name, required int age}) {
  return '$name, $age';
}

// First-class functions
var numbers = [1, 2, 3, 4, 5];
var doubled = numbers.map((n) => n * 2).toList();
```

## Null Safety

```dart
// Nullable types
String? nullableName = null;

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
```

## Classes

```dart
// Basic class
class Person {
  String name;
  int age;
  
  Person(this.name, this.age);
  
  String greet() => 'Hello, I\'m $name';
}

// Inheritance
class Student extends Person {
  String grade;
  
  Student(String name, int age, this.grade) : super(name, age);
  
  @override
  String greet() => '${super.greet()}, and I\'m a student';
}
```

## Enums

```dart
// Enhanced enums
enum Color {
  red(0xFF0000),
  green(0x00FF00),
  blue(0x0000FF);
  
  final int hex;
  const Color(this.hex);
}
```

## Collections

```dart
// Lists
var numbers = [1, 2, 3, 4, 5];
numbers.add(6);

// Maps
var person = {'name': 'Alice', 'age': 30};

// Spread operator
var combined = [...numbers, 6, 7, 8];

// Collection if
var include = true;
var list = [1, 2, if (include) 3, 4];
```

## Async/Await

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
```

## Best Practices

1. Use null safety features
2. Prefer `final` over `var` when possible
3. Use named parameters for clarity
4. Write documentation comments (///)
5. Follow Effective Dart guidelines