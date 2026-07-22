# C++ Programming Language

## Overview

C++ is a high-performance, compiled language created by Bjarne Stroustrup in 1979 as "C with Classes." It combines C's low-level capabilities with powerful abstractions including classes, templates, the Standard Template Library (STL), and modern features like move semantics and concepts.

## Key Features

- **Multi-Paradigm**: Procedural, object-oriented, generic, and functional programming
- **Zero-Cost Abstractions**: High-level features compile to code as efficient as hand-written C
- **STL**: Containers, algorithms, iterators, and function objects
- **RAII**: Resource management via constructors/destructors — no garbage collector needed
- **Templates**: Compile-time generics enabling type-safe, highly optimized code
- **Move Semantics**: Efficient transfer of resources without unnecessary copies

## Directory Structure

- `Basics/` — Syntax, references, smart pointers, lambdas, move semantics
- `Algorithms/` — Algorithm implementations using STL and custom code
- `Data-Structures/` — Data structure implementations in C++
- `OOP/` — Classes, virtual functions, templates, RAII, operator overloading

## Recommended Learning Path

1. Start with the [Introduction](cpp-introduction.md) for setup and motivation
2. Work through `Basics/` for core C++ syntax and modern features
3. Study `Data-Structures/` for STL container implementations
4. Practice with `Algorithms/` for sorting, searching, and string problems
5. Explore `OOP/` for class design, virtual functions, and RAII

## C++ vs Other Languages

| Feature | C++ | C | Java | Python |
|---------|-----|---|------|--------|
| OOP | Native (classes, virtual) | Simulated | Native | Native |
| Memory Mgmt | RAII + smart ptrs | Manual `malloc/free` | GC | GC |
| Generics | Templates | N/A | Generics (erased) | Duck typing |
| Compile-time | `constexpr`, templates | Preprocessor | Annotation processing | N/A |
| Performance | Very high | Very high | High | Low |
| Compilation | Native binary | Native binary | Bytecode (JVM) | Interpreted |

## Resources

- [C++ Reference](https://en.cppreference.com/) — Comprehensive language reference
- [Compiler Explorer](https://godbolt.org/) — See generated assembly in real time
- [C++ Core Guidelines](https://isocpp.github.io/CppCoreGuidelines/) — Modern best practices
