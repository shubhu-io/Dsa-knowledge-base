# Rust Introduction

## Why Learn Rust?
Rust is a systems programming language focused on safety, performance, and concurrency. It guarantees memory safety without garbage collection.

## Key Features
- **Memory Safety**: Ownership system prevents data races
- **Zero-Cost Abstractions**: High-level features with low-level performance
- **Concurrency**: Fearless concurrency with safety guarantees
- **Pattern Matching**: Powerful match expressions
- **Type Inference**: Smart compiler infers types
- **Cargo**: Excellent package manager and build system
- **No Garbage Collector**: Predictable performance
- **Growing Ecosystem**: Increasing adoption in industry

## Getting Started

### Installation
1. Install via rustup: `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
2. Verify: `rustc --version`

### First Program
```rust
fn main() {
    println!("Hello, World!");
}
```

Save as `main.rs` and run with `rustc main.rs && ./main`

## Basic Syntax

### Variables and Data Types
```rust
// Immutable by default
let name = "Alice";
let age = 30;

// Mutable
let mut score = 100;
score = 150;

// Type annotations
let height: f64 = 5.5;
let is_student: bool = true;

// Constants
const PI: f64 = 3.14159;

// Shadowing
let x = 5;
let x = x + 1;  // x is now 6
```

### Input/Output
```rust
// Output
println!("Hello, World!");
println!("Name: {}, Age: {}", name, age);

// Input
use std::io;
let mut input = String::new();
io::stdin().read_line(&mut input).expect("Failed to read");
```

### Control Flow
```rust
// If-else (no parentheses needed)
if age >= 18 {
    println!("Adult");
} else {
    println!("Minor");
}

// If as expression
let category = if age >= 18 { "adult" } else { "minor" };

// For loop
for i in 0..5 {
    println!("{}", i);
}

// While loop
while count > 0 {
    count -= 1;
}

// Loop (infinite)
loop {
    if done { break; }
}

// Match (like switch)
match day {
    "Monday" => println!("Start of week"),
    "Friday" => println!("Almost weekend"),
    _ => println!("Midweek"),
}
```

### Functions
```rust
// Basic function
fn add(a: i32, b: i32) -> i32 {
    a + b  // No semicolon = return value
}

// Expression vs statement
fn square(x: i32) -> i32 {
    x * x  // Expression (returns value)
}

// Multiple return values
fn swap(a: i32, b: i32) -> (i32, i32) {
    (b, a)
}

// Functions are first-class
fn apply(f: fn(i32) -> i32, x: i32) -> i32 {
    f(x)
}
```

### Ownership and Borrowing
```rust
// Ownership
let s1 = String::from("hello");
let s2 = s1;  // s1 is moved, no longer valid

// Borrowing (immutable)
let s3 = String::from("hello");
let len = calculate_length(&s3);  // Borrow

// Borrowing (mutable)
let mut s4 = String::from("hello");
change(&mut s4);

fn calculate_length(s: &String) -> usize {
    s.len()
}

fn change(s: &mut String) {
    s.push_str(", world");
}
```

### Structs
```rust
// Struct definition
struct Person {
    name: String,
    age: u32,
}

// Implementation
impl Person {
    // Constructor
    fn new(name: &str, age: u32) -> Self {
        Person {
            name: String::from(name),
            age,
        }
    }

    // Method
    fn greet(&self) -> String {
        format!("Hello, {}", self.name)
    }

    // Mutable method
    fn birthday(&mut self) {
        self.age += 1;
    }
}

// Tuple struct
struct Color(u8, u8, u8);

// Unit struct
struct Unit;
```

### Enums and Pattern Matching
```rust
enum Direction {
    Up,
    Down,
    Left,
    Right,
}

enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(u8, u8, u8),
}

// Pattern matching
match msg {
    Message::Quit => println!("Quit"),
    Message::Move { x, y } => println!("Move to ({}, {})", x, y),
    Message::Write(text) => println!("Write: {}", text),
    Message::ChangeColor(r, g, b) => println!("Color: ({}, {}, {})", r, g, b),
}
```

### Collections
```rust
// Vector
let mut numbers = vec![1, 2, 3, 4, 5];
numbers.push(6);

// String
let mut name = String::from("Hello");
name.push_str(" World");

// Hash Map
use std::collections::HashMap;
let mut scores = HashMap::new();
scores.insert("Alice", 100);
scores.insert("Bob", 85);

// Access
if let Some(score) = scores.get("Alice") {
    println!("Alice's score: {}", score);
}
```

### Error Handling
```rust
// Result type
fn divide(a: f64, b: f64) -> Result<f64, String> {
    if b == 0.0 {
        Err(String::from("Division by zero"))
    } else {
        Ok(a / b)
    }
}

// Handling results
match divide(10.0, 2.0) {
    Ok(result) => println!("Result: {}", result),
    Err(e) => println!("Error: {}", e),
}

// Question mark operator
fn read_file(path: &str) -> Result<String, io::Error> {
    let content = fs::read_to_string(path)?;
    Ok(content)
}
```

### Traits
```rust
trait Summary {
    fn summarize(&self) -> String;

    // Default implementation
    fn preview(&self) -> String {
        format!("{}...", &self.summarize()[..20])
    }
}

struct Article {
    title: String,
    content: String,
}

impl Summary for Article {
    fn summarize(&self) -> String {
        format!("{}: {}", self.title, self.content)
    }
}
```

### Lifetimes
```rust
// Lifetime annotations
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() { x } else { y }
}

// Struct with lifetime
struct Excerpt<'a> {
    text: &'a str,
}
```

## Best Practices
1. Embrace the ownership system
2. Use `clippy` for linting
3. Write tests with `cargo test`
4. Use `unwrap()` sparingly in production
5. Prefer `&str` over `&String` in function arguments
6. Use `Option` and `Result` for nullable/ Fallible operations

## Common Pitfalls
- Fighting the borrow checker
- Cloning when borrowing would suffice
- Not using `?` for error propagation
- Overusing `unwrap()` in production code
- Ignoring lifetime elision rules