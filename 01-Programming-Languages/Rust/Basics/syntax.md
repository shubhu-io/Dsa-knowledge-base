# Rust Syntax

## Overview
Rust has a modern, expressive syntax with powerful features for memory safety and concurrency. This guide covers the essential syntax elements including ownership, borrowing, traits, enums, pattern matching, and error handling.

## Variables and Mutability

```rust
// Immutable by default
let x = 5;
// x = 6;  // Error: cannot assign twice to immutable variable

// Mutable variables
let mut y = 5;
y = 6;  // OK: variable is mutable

// Type inference
let z = 10;  // Type inferred as i32
let w: i64 = 100;  // Explicit type annotation

// Shadowing (rebinding)
let x = 5;
let x = x + 1;  // Shadow previous x
let x = x * 2;  // x is now 12

// Constants (must have type annotation)
const MAX_POINTS: u32 = 100_000;

// Unused variables (prefix with underscore)
let _unused = 42;
```

## Scalar Types

```rust
// Integers: i8, i16, i32, i64, i128, isize
// Unsigned: u8, u16, u32, u64, u128, usize
let a: i32 = -42;
let b: u32 = 42;
let c: i64 = 1_000_000;

// Floats: f32, f64 (default is f64)
let f: f64 = 3.14;

// Boolean
let is_active: bool = true;

// Char (4 bytes, Unicode)
let c: char = 'z';
let z: char = 'ℤ';
let heart = '❤';
```

## Compound Types

```rust
// Tuple (fixed size, can hold different types)
let tup: (i32, f64, bool) = (500, 6.4, true);
let (x, y, z) = tup;  // Destructuring
let five_hundred = tup.0;  // Index access

// Array (fixed size, same type)
let a = [1, 2, 3, 4, 5];
let a: [i32; 5] = [1, 2, 3, 4, 5];
let a = [3; 5];  // [3, 3, 3, 3, 3]

// Accessing arrays
let first = a[0];
let second = a[1];
```

## Ownership System

```rust
// Each value has exactly one owner
let s1 = String::from("hello");
let s2 = s1;  // s1 is moved to s2
// println!("{}", s1);  // Error: s1 is no longer valid

// Clone (deep copy)
let s1 = String::from("hello");
let s2 = s1.clone();  // Both s1 and s2 are valid
println!("s1 = {}, s2 = {}", s1, s2);

// Copy trait (stack-only types)
let x = 5;
let y = x;  // x is copied, not moved
println!("x = {}, y = {}", x, y);  // Both valid
```

## Borrowing and References

```rust
// Immutable references (can have many)
fn calculate_length(s: &String) -> usize {
    s.len()
}

let s1 = String::from("hello");
let len = calculate_length(&s1);  // Borrow s1
println!("The length of '{}' is {}.", s1, len);  // s1 still valid

// Mutable references (only one at a time)
fn change(s: &mut String) {
    s.push_str(", world");
}

let mut s1 = String::from("hello");
change(&mut s1);

// Rules of references:
// 1. Can have either one mutable reference OR any number of immutable references
// 2. References must always be valid (no dangling references)
```

## Lifetimes

```rust
// Lifetime annotations
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() { x } else { y }
}

// Struct with lifetime
struct ImportantExcerpt<'a> {
    part: &'a str,
}

impl<'a> ImportantExcerpt<'a> {
    fn level(&self) -> i32 {
        3
    }

    fn announce_and_return_part(&self, announcement: &str) -> &str {
        println!("Attention please: {}", announcement);
        self.part
    }
}

// Lifetime elision rules
// 1. Each parameter gets its own lifetime
// 2. If there's exactly one input lifetime, it's assigned to all outputs
// 3. If there's a &self or &mut self lifetime, it's assigned to outputs
```

## Enums and Pattern Matching

```rust
// Enum definition
enum IpAddrKind {
    V4(u8, u8, u8, u8),
    V6(String),
}

// Pattern matching
fn route(ip_kind: &IpAddrKind) {
    match ip_kind {
        IpAddrKind::V4(a, b, c, d) => println!("{}.{}.{}.{}", a, b, c, d),
        IpAddrKind::V6(addr) => println!("{}", addr),
    }
}

// if let (alternative to match)
let config_max = Some(3u8);
if let Some(max) = config_max {
    println!("The maximum is configured to be {}", max);
}

// while let
let mut stack = Vec::new();
stack.push(1);
stack.push(2);
stack.push(3);
while let Some(top) = stack.pop() {
    println!("{}", top);
}
```

## Option and Result

```rust
// Option<T> - represents optional values
let some_number: Option<i32> = Some(5);
let absent_number: Option<i32> = None;

// Working with Option
match some_number {
    Some(n) => println!("Found: {}", n),
    None => println!("Not found"),
}

// Unwrap with default
let value = some_number.unwrap_or(0);

// ? operator for error propagation
fn read_file(path: &str) -> Result<String, std::io::Error> {
    let content = std::fs::read_to_string(path)?;
    Ok(content)
}
```

## Structs

```rust
// Struct definition
struct User {
    username: String,
    email: String,
    sign_in_count: u64,
    active: bool,
}

// Creating instances
let user = User {
    email: String::from("someone@example.com"),
    username: String::from("someusername123"),
    active: true,
    sign_in_count: 1,
};

// Struct update syntax
let user2 = User {
    email: String::from("another@example.com"),
    ..user  // Fill remaining fields from user
};

// Tuple structs
struct Color(i32, i32, i32);
struct Point(i32, i32, i32);

// Unit structs (no fields)
struct AlwaysEqual;

// Methods
impl User {
    // Associated function (constructor-like)
    fn new(email: String, username: String) -> User {
        User {
            email,
            username,
            active: true,
            sign_in_count: 1,
        }
    }

    // Method (takes &self)
    fn name(&self) -> &str {
        &self.username
    }

    // Mutable method (takes &mut self)
    fn change_email(&mut self, new_email: String) {
        self.email = new_email;
    }

    // Consuming method (takes self)
    fn into_name(self) -> String {
        self.username
    }
}
```

## Traits

```rust
// Trait definition
trait Summary {
    fn summarize(&self) -> String;

    // Default implementation
    fn preview(&self) -> String {
        format!("(Read more...)", )
    }
}

struct NewsArticle {
    headline: String,
    location: String,
    author: String,
    content: String,
}

impl Summary for NewsArticle {
    fn summarize(&self) -> String {
        format!("{}, by {} ({})", self.headline, self.author, self.location)
    }
}

struct Tweet {
    username: String,
    content: String,
    reply: bool,
    retweet: bool,
}

impl Summary for Tweet {
    fn summarize(&self) -> String {
        format!("{}: {}", self.username, self.content)
    }
}

// Trait bounds
fn notify(item: &impl Summary) {
    println!("Breaking news! {}", item.summarize());
}

// Multiple trait bounds
fn notify(item: &(impl Summary + Display)) {
    println!("Breaking news! {}", item.summarize());
}

// where clause
fn some_function<T, U>(t: &T, u: &U) -> i32
where
    T: Display + Clone,
    U: Clone + Debug,
{
    // implementation
}
```

## Closures

```rust
// Basic closure
let add_one = |x: i32| -> i32 { x + 1 };
let add_one = |x| x + 1;  // Type inferred

// Closure capturing environment
let name = String::from("Alice");
let greeting = || println!("Hello, {}", name);

// Mutable closure
let mut list = vec![1, 2, 3];
let mut push_to_list = || list.push(4);
push_to_list();

// Closure as parameter
fn apply<F: Fn(i32) -> i32>(f: F, x: i32) -> i32 {
    f(x)
}

// Fn traits:
// Fn: immutable borrow of captured values
// FnMut: mutable borrow of captured values
// Fn: consumes captured values
```

## Smart Pointers

```rust
// Box<T> - heap allocation
let b = Box::new(5);
println!("b = {}", b);

// Rc<T> - reference counting (single-threaded)
use std::rc::Rc;
let a = Rc::new(String::from("hello"));
let b = Rc::clone(&a);  // Increment reference count

// RefCell<T> - interior mutability
use std::cell::RefCell;
let data = RefCell::new(5);
*data.borrow_mut() += 1;

// Weak<T> - weak references to Rc
use std::rc::Weak;
let weak = Rc::downgrade(&a);
```

## Error Handling

```rust
// panic! macro (unrecoverable)
fn divide(a: i32, b: i32) -> i32 {
    if b == 0 {
        panic!("Division by zero!");
    }
    a / b
}

// Result<T, E> (recoverable)
use std::fs::File;
use std::io::{self, Read};

fn read_username_from_file() -> Result<String, io::Error> {
    let mut file = File::open("username.txt")?;
    let mut username = String::new();
    file.read_to_string(&mut username)?;
    Ok(username)
}

// Custom error types
#[derive(Debug)]
enum AppError {
    NotFound(String),
    ParseError(String),
    IoError(io::Error),
}

impl From<io::Error> for AppError {
    fn from(error: io::Error) -> Self {
        AppError::IoError(error)
    }
}

// ? operator propagates errors
fn process_file(path: &str) -> Result<String, AppError> {
    let content = std::fs::read_to_string(path)?;  // Converts io::Error to AppError
    Ok(content.to_uppercase())
}
```

## Example: Complete Rust Program
```rust
use std::collections::HashMap;

#[derive(Debug, Clone)]
struct Student {
    name: String,
    grades: Vec<f64>,
}

impl Student {
    fn new(name: &str) -> Self {
        Student {
            name: String::from(name),
            grades: Vec::new(),
        }
    }

    fn add_grade(&mut self, grade: f64) {
        self.grades.push(grade);
    }

    fn average(&self) -> f64 {
        if self.grades.is_empty() {
            return 0.0;
        }
        let sum: f64 = self.grades.iter().sum();
        sum / self.grades.len() as f64
    }

    fn letter_grade(&self) -> &str {
        match self.average() as u32 {
            90..=100 => "A",
            80..=89 => "B",
            70..=79 => "C",
            60..=69 => "D",
            _ => "F",
        }
    }
}

fn main() {
    let mut students: HashMap<String, Student> = HashMap::new();

    let mut alice = Student::new("Alice");
    alice.add_grade(95.0);
    alice.add_grade(87.5);
    alice.add_grade(92.0);

    let mut bob = Student::new("Bob");
    bob.add_grade(78.0);
    bob.add_grade(82.5);
    bob.add_grade(88.0);

    students.insert(alice.name.clone(), alice);
    students.insert(bob.name.clone(), bob);

    for (name, student) in &students {
        println!(
            "{}: Average = {:.1}, Grade = {}",
            name,
            student.average(),
            student.letter_grade()
        );
    }
}
```

## See Also
- [[../00-Getting-Started/README|Getting Started]]
- [[oop.md|OOP in Rust]]
- [[../Algorithms/String/string_algorithms.rs|String Algorithms]]
- [The Rust Programming Language](https://doc.rust-lang.org/book/)
- [Rust by Example](https://doc.rust-lang.org/rust-by-example/)