# TypeScript Programming Language

## Overview
TypeScript is a strongly typed programming language that builds on JavaScript, adding optional static typing and class-based object-oriented programming. Developed and maintained by Microsoft, TypeScript compiles to plain JavaScript and is designed for developing large-scale applications.

## Learning Path
1. **Basics**: Start with TypeScript syntax, types, and interfaces
2. **Data Structures**: Explore typed collections and data structures
3. **Algorithms**: Implement common algorithms with type safety
4. **OOP**: Master TypeScript's full OOP features including classes, generics, and decorators
5. **Advanced**: Learn utility types, mapped types, and declaration files

## Key Features
- **Static typing**: Catch errors at compile time rather than runtime
- **Type inference**: Automatic type deduction when types aren't explicitly specified
- **Interfaces and type aliases**: Define contracts for objects and functions
- **Generics**: Write reusable, type-safe code
- **Decorators**: Meta-programming syntax for modifying classes and members
- **Enum**: Named set of constants
- **Utility types**: Built-in types for common type transformations
- **Backwards compatibility**: Compiles to plain JavaScript

## Folder Structure
- `Basics/`: TypeScript syntax, types, interfaces, generics
- `Data-Structures/`: Typed arrays, maps, sets, and custom structures
- `Algorithms/`: Algorithm implementations with proper typing
- `OOP/`: Classes, interfaces, abstract classes, decorators, and patterns

## Getting Started
```bash
# Install TypeScript
npm install -g typescript

# Verify installation
tsc --version

# Create a TypeScript file
echo 'let message: string = "Hello, TypeScript!"; console.log(message);' > hello.ts

# Compile to JavaScript
tsc hello.ts

# Run the compiled JavaScript
node hello.js

# Initialize a TypeScript project
tsc --init

# Watch for changes
tsc --watch
```

## Related Topics
- [[../00-Getting-Started/README|Getting Started]]
- [[../05-JavaScript/README|JavaScript]]
- [[../02-Data-Structures/README|Data Structures]]
- [[../14-Algorithms/README|Algorithms]]
- [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/)