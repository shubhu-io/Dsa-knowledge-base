# Object-Oriented Programming in Rust

## Overview
Rust doesn't have traditional OOP features like classes, inheritance, or constructors. Instead, it uses traits for polymorphism, enums for sum types, and composition for code reuse. This approach provides the benefits of OOP while maintaining Rust's guarantees of memory safety and performance.

## Key Differences from Traditional OOP

| Feature | Traditional OOP | Rust |
|---------|----------------|------|
| Classes | Yes | No (use structs + impl blocks) |
| Inheritance | Yes | No (use trait implementations) |
| Constructors | Yes | No (use associated functions) |
| Polymorphism | Via inheritance | Via traits (static or dynamic dispatch) |
| Encapsulation | Access modifiers | Visibility modifiers (pub, crate, etc.) |
| Interfaces | Yes (separate concept) | Traits (unified concept) |

## Structs as Data Types
Rust structs are like classes without methods attached by default:

```rust
// Struct definition
struct Person {
    name: String,
    age: u32,
    email: String,
}

// Implementation block (methods)
impl Person {
    // Associated function (constructor-like)
    fn new(name: &str, age: u32, email: &str) -> Self {
        Person {
            name: String::from(name),
            age,
            email: String::from(email),
        }
    }
    
    // Method (takes &self)
    fn greet(&self) -> String {
        format!("Hello, I'm {}!", self.name)
    }
    
    // Mutable method (takes &mut self)
    fn have_birthday(&mut self) {
        self.age += 1;
    }
    
    // Consuming method (takes self)
    fn into_name(self) -> String {
        self.name
    }
}

// Multiple impl blocks allowed
impl Person {
    fn is_adult(&self) -> bool {
        self.age >= 18
    }
}
```

## Traits as Interfaces
Traits define shared behavior - any type that implements the required methods satisfies the trait:

```rust
// Trait definition
trait Drawable {
    fn draw(&self);
    
    // Default implementation
    fn description(&self) -> String {
        String::from("A drawable object")
    }
}

// Implementation for a struct
struct Circle {
    radius: f64,
}

impl Drawable for Circle {
    fn draw(&self) {
        println!("Drawing circle with radius {}", self.radius);
    }
    
    // Override default implementation
    fn description(&self) -> String {
        format!("Circle with radius {}", self.radius)
    }
}

// Another implementation
struct Rectangle {
    width: f64,
    height: f64,
}

impl Drawable for Rectangle {
    fn draw(&self) {
        println!("Drawing rectangle {}x{}", self.width, self.height);
    }
}

// Trait bounds for generic functions
fn draw_all(items: &[&impl Drawable]) {
    for item in items {
        item.draw();
    }
}

// Alternative syntax with trait bounds
fn draw_all_v2<T: Drawable>(items: &[T]) {
    for item in items {
        item.draw();
    }
}
```

## Enums for Sum Types
Rust enums are algebraic data types, more powerful than traditional OOP enums:

```rust
// Enum with variants
enum Shape {
    Circle(f64),  // Radius
    Rectangle(f64, f64),  // Width, Height
    Triangle(f64, f64, f64),  // Three sides
}

// Methods on enums
impl Shape {
    fn area(&self) -> f64 {
        match self {
            Shape::Circle(radius) => std::f64::consts::PI * radius * radius,
            Shape::Rectangle(width, height) => width * height,
            Shape::Triangle(a, b, c) => {
                let s = (a + b + c) / 2.0;
                (s * (s - a) * (s - b) * (s - c)).sqrt()
            }
        }
    }
    
    fn description(&self) -> String {
        match self {
            Shape::Circle(_) => "A circle".to_string(),
            Shape::Rectangle(_, _) => "A rectangle".to_string(),
            Shape::Triangle(_, _, _) => "A triangle".to_string(),
        }
    }
}

// Pattern matching
fn process_shape(shape: &Shape) {
    match shape {
        Shape::Circle(radius) => {
            println!("Processing circle with radius {}", radius);
        }
        Shape::Rectangle(width, height) => {
            println!("Processing rectangle {}x{}", width, height);
        }
        Shape::Triangle(a, b, c) => {
            println!("Processing triangle with sides {}, {}, {}", a, b, c);
        }
    }
}
```

## Composition Over Inheritance
Rust uses composition and trait implementations for code reuse:

```rust
// Base components
struct Position {
    x: f64,
    y: f64,
}

struct Velocity {
    dx: f64,
    dy: f64,
}

// Composed struct
struct GameObject {
    position: Position,
    velocity: Velocity,
    name: String,
}

impl GameObject {
    fn new(name: &str) -> Self {
        GameObject {
            position: Position { x: 0.0, y: 0.0 },
            velocity: Velocity { dx: 0.0, dy: 0.0 },
            name: String::from(name),
        }
    }
    
    fn update(&mut self, dt: f64) {
        self.position.x += self.velocity.dx * dt;
        self.position.y += self.velocity.dy * dt;
    }
}

// Trait for shared behavior
trait Movable {
    fn position(&self) -> (f64, f64);
    fn set_position(&mut self, x: f64, y: f64);
}

// Implement trait for composed struct
impl Movable for GameObject {
    fn position(&self) -> (f64, f64) {
        (self.position.x, self.position.y)
    }
    
    fn set_position(&mut self, x: f64, y: f64) {
        self.position.x = x;
        self.position.y = y;
    }
}
```

## Trait Objects for Dynamic Dispatch
For runtime polymorphism when types aren't known at compile time:

```rust
// Trait
trait Animal {
    fn speak(&self) -> String;
    fn move(&self) -> String;
}

struct Dog;
struct Cat;

impl Animal for Dog {
    fn speak(&self) -> String { "Woof!".to_string() }
    fn move(&self) -> String { "Runs on four legs".to_string() }
}

impl Animal for Cat {
    fn speak(&self) -> String { "Meow!".to_string() }
    fn move(&self) -> String { "Sneaks silently".to_string() }
}

// Using trait objects (Box<dyn Trait>)
fn create_animal(animal_type: &str) -> Box<dyn Animal> {
    match animal_type {
        "dog" => Box::new(Dog),
        "cat" => Box::new(Cat),
        _ => panic!("Unknown animal type"),
    }
}

// Function accepting trait objects
fn describe_animal(animal: &dyn Animal) {
    println!("Sound: {}, Movement: {}", animal.speak(), animal.move());
}

fn main() {
    let animals: Vec<Box<dyn Animal>> = vec![
        create_animal("dog"),
        create_animal("cat"),
    ];
    
    for animal in &animals {
        describe_animal(animal.as_ref());
    }
}
```

## Advanced Patterns

### Associated Types
```rust
// Trait with associated type
trait Iterator {
    type Item;
    fn next(&mut self) -> Option<Self::Item>;
}

// Implementation
struct Counter {
    current: u32,
    max: u32,
}

impl Iterator for Counter {
    type Item = u32;
    
    fn next(&mut self) -> Option<u32> {
        if self.current < self.max {
            self.current += 1;
            Some(self.current)
        } else {
            None
        }
    }
}
```

### Operator Overloading
```rust
use std::ops::Add;

#[derive(Debug, Clone, Copy)]
struct Vector2D {
    x: f64,
    y: f64,
}

impl Add for Vector2D {
    type Output = Vector2D;
    
    fn add(self, other: Vector2D) -> Vector2D {
        Vector2D {
            x: self.x + other.x,
            y: self.y + other.y,
        }
    }
}

impl std::fmt::Display for Vector2D {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        write!(f, "({}, {})", self.x, self.y)
    }
}
```

### Extension Traits
```rust
// Adding methods to existing types
trait StringUtils {
    fn word_count(&self) -> usize;
    fn truncate_ellipsis(&self, max_chars: usize) -> String;
}

impl StringUtils for str {
    fn word_count(&self) -> usize {
        self.split_whitespace().count()
    }
    
    fn truncate_ellipsis(&self, max_chars: usize) -> String {
        if self.len() <= max_chars {
            self.to_string()
        } else {
            format!("{}...", &self[..max_chars - 3])
        }
    }
}

// Usage
let text = "Hello, this is a long string";
println!("Words: {}", text.word_count());
println!("Truncated: {}", text.truncate_ellipsis(10));
```

## Benefits of Rust's Approach
1. **Memory safety**: No null pointers, dangling references, or data races
2. **Performance**: Zero-cost abstractions, no runtime overhead
3. **Fearless concurrency**: Compile-time guarantees prevent data races
4. **Explicit design**: Clear separation between data and behavior
5. **Flexibility**: Static dispatch for performance, dynamic dispatch when needed

## Example: Shape Hierarchy
See `oop.rs` for a complete example demonstrating trait-based polymorphism with shapes.

## See Also
- [[syntax.md|Rust Syntax]]
- [[../Algorithms/String/string_algorithms.rs|String Algorithms]]
- [The Rust Book: Traits](https://doc.rust-lang.org/book/ch10-02-traits.html)
- [Rust Design Patterns](https://rust-unofficial.github.io/patterns/)