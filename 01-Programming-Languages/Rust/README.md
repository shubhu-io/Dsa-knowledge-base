# Rust Programming Language

## Overview
Rust is a systems programming language focused on safety, performance, and concurrency. It achieves memory safety without garbage collection through its ownership system, making it ideal for systems programming, web assembly, command-line tools, and performance-critical applications.

## Learning Path
1. **Basics**: Start with Rust syntax, ownership, and borrowing rules
2. **Data Structures**: Explore built-in data structures and collections
3. **Algorithms**: Implement common algorithms using Rust's powerful type system
4. **OOP**: Learn Rust's trait-based approach to polymorphism (no classes)
5. **Concurrency**: Master Rust's fearless concurrency with ownership guarantees

## Key Features
- **Memory safety**: Ownership system prevents null pointers, dangling references, and data races
- **Zero-cost abstractions**: High-level features with low-level performance
- **Fearless concurrency**: Compile-time guarantees prevent data races
- **Rich type system**: Enums, pattern matching, and algebraic data types
- **Trait-based polymorphism**: Interfaces without inheritance
- **Pattern matching**: Exhaustive matching with destructuring
- **Cargo package manager**: Excellent tooling for dependency management and building

## Folder Structure
- `Basics/`: Rust syntax, ownership, borrowing, lifetimes, traits
- `Data-Structures/`: Vectors, hash maps, strings, and custom structures
- `Algorithms/`: Algorithm implementations organized by category
- `OOP/`: Trait-based polymorphism and composition patterns

## Getting Started
```bash
# Install Rust via rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Verify installation
rustc --version
cargo --version

# Create a new project
cargo new my_project
cd my_project

# Build and run
cargo build
cargo run

# Run tests
cargo test

# Format code
cargo fmt

# Check for common mistakes
cargo clippy
```

## Related Topics
- [[../00-Getting-Started/README|Getting Started]]
- [[../02-Data-Structures/README|Data Structures]]
- [[../14-Algorithms/README|Algorithms]]
- [The Rust Programming Language Book](https://doc.rust-lang.org/book/)