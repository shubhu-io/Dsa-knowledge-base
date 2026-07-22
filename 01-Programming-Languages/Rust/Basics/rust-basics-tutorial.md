# Rust Basics Tutorial

## Variables and Constants

```rust
fn main() {
    // Immutable by default
    let name = "Alice";
    let age = 30;
    
    // Mutable
    let mut score = 100;
    score = 150;
    
    // Type annotations
    let height: f64 = 5.5;
    
    // Constants
    const PI: f64 = 3.14159;
    
    println!("Name: {}, Age: {}, Score: {}", name, age, score);
}
```

## Data Types

- **Integer**: `i8`, `i16`, `i32`, `i64`, `i128`, `u8`, `u16`, `u32`, `u64`, `u128`
- **Float**: `f32`, `f64`
- **Boolean**: `bool`
- **Character**: `char`
- **Tuples**: `(i32, f64, char)`
- **Arrays**: `[i32; 5]`

## Control Flow

### If-Else
```rust
if age >= 18 {
    println!("Adult");
} else {
    println!("Minor");
}
```

### For Loop
```rust
for i in 0..5 {
    println!("{}", i);
}
```

### Match
```rust
match day {
    "Monday" => println!("Start of week"),
    "Friday" => println!("Almost weekend"),
    _ => println!("Midweek"),
}
```

## Functions

```rust
// Basic function
fn add(a: i32, b: i32) -> i32 {
    a + b
}

// Multiple return values
fn divide(a: f64, b: f64) -> Result<f64, String> {
    if b == 0.0 {
        Err(String::from("Division by zero"))
    } else {
        Ok(a / b)
    }
}
```

## Ownership and Borrowing

```rust
fn main() {
    // Ownership
    let s1 = String::from("hello");
    let s2 = s1;  // s1 is moved
    
    // Borrowing
    let s3 = String::from("hello");
    let len = calculate_length(&s3);
    println!("Length: {}", len);
}

fn calculate_length(s: &String) -> usize {
    s.len()
}
```

## Structs

```rust
struct Person {
    name: String,
    age: u32,
}

impl Person {
    fn new(name: &str, age: u32) -> Self {
        Person {
            name: String::from(name),
            age,
        }
    }
    
    fn greet(&self) -> String {
        format!("Hello, {}", self.name)
    }
}
```

## Enums and Pattern Matching

```rust
enum Direction {
    Up,
    Down,
    Left,
    Right,
}

fn main() {
    let dir = Direction::Up;
    
    match dir {
        Direction::Up => println!("Going up"),
        Direction::Down => println!("Going down"),
        Direction::Left => println!("Going left"),
        Direction::Right => println!("Going right"),
    }
}
```

## Error Handling

```rust
use std::fs;

fn main() {
    match fs::read_to_string("file.txt") {
        Ok(content) => println!("{}", content),
        Err(e) => println!("Error: {}", e),
    }
}
```

## Best Practices

1. Embrace the ownership system
2. Use `clippy` for linting
3. Write tests with `cargo test`
4. Prefer `&str` over `&String` in function arguments
5. Use `Option` and `Result` for nullable/fallible operations