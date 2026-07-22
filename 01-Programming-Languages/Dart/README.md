# Dart

## Overview

Dart is a client-optimized programming language developed by Google for building fast apps on any platform. It is the language behind Flutter, Google's UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.

## Key Features

- **Null Safety**: Sound null safety eliminates null reference errors at compile time.
- **AOT and JIT Compilation**: Ahead-of-time compilation for production, just-in-time for development.
- **Strong Typing**: Static type system with type inference.
- **Asynchronous Programming**: First-class support with async/await, Futures, and Streams.
- **Mixins**: Reuse code across multiple class hierarchies.
- **Extension Methods**: Add functionality to existing types without modifying them.
- **Isolates**: Memory-efficient concurrent execution without shared memory.

## Flutter Connection

Dart is the primary language for Flutter development:

| Component | Purpose |
|-----------|---------|
| Flutter Framework | UI toolkit for building cross-platform apps |
| Dart SDK | Core language and libraries |
| pub.dev | Package repository for Dart and Flutter |
| Dart VM | Runtime for development and server-side |

```dart
// Flutter widget in Dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Hello Dart')),
        body: Center(child: Text('Welcome to Dart!')),
      ),
    );
  }
}
```

## Project Structure

| Folder | Contents |
|--------|----------|
| `Basics/` | Core language syntax and features |
| `Algorithms/` | Algorithm implementations |
| `OOP/` | Object-oriented programming concepts |

## Resources

- [Dart Documentation](https://dart.dev/guides)
- [Dart API Reference](https://api.dart.dev/)
- [Flutter Documentation](https://flutter.dev/docs)
- [DartPad](https://dartpad.dev/)

See also: [[00-Getting-Started]] | [[Basics/syntax]] | [[OOP/oop]]
