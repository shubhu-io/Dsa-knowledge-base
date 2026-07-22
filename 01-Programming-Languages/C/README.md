# C Programming Language

## Overview

C is a general-purpose, procedural programming language developed by Dennis Ritchie in 1972 at Bell Labs. It provides low-level access to memory and is the foundation for many modern languages including C++, Java, Python, and JavaScript.

## Key Features

- **Low-level Memory Access**: Direct pointer manipulation and manual memory management
- **Minimal Runtime**: Compiled to native machine code with minimal overhead
- **Portability**: Runs on virtually every platform with a C compiler
- **Foundation Language**: Basis for C++, C#, Java, Go, Rust, and more
- **Systems Programming**: Used for OS kernels, drivers, embedded systems, and firmware

## Directory Structure

- `Basics/` — Variables, data types, control flow, functions, pointers
- `Algorithms/` — Algorithm implementations in C
- `Data-Structures/` — Data structure implementations in C
- `OOP/` — Simulating object-oriented patterns in C using structs and function pointers

## Recommended Learning Path

1. Start with the [Introduction](c-introduction.md) for setup and motivation
2. Work through `Basics/` for core C syntax and concepts
3. Study `Data-Structures/` for linked lists, trees, hash tables
4. Practice with `Algorithms/` for sorting, searching, and string problems
5. Explore `OOP/` to see how C simulates object-oriented design

## C vs Other Languages

| Feature | C | C++ | Java | Python |
|---------|---|-----|------|--------|
| Memory Management | Manual (`malloc`/`free`) | Manual + RAII + smart pointers | Automatic (GC) | Automatic (GC) |
| OOP | Simulated via structs | Native classes/virtual | Native classes/interfaces | Native classes |
| Type System | Weak static | Strong static | Strong static | Dynamic |
| Compilation | Native binary | Native binary | Bytecode (JVM) | Interpreted |
| Performance | Very high | Very high | High | Low |

## Resources

- [The C Programming Language](https://en.wikipedia.org/wiki/The_C_Programming_Language) — K&R, the definitive reference
- [Learn C](https://www.learn-c.org/) — Interactive tutorials
- [Compiler Explorer](https://godbolt.org/) — See generated assembly in real time
