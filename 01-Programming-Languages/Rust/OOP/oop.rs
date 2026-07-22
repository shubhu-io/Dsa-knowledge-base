// This file demonstrates Rust's approach to object-oriented programming
// using traits for polymorphism instead of classes and inheritance.

use std::f64::consts::PI;

// Define a trait for shapes (similar to interface in other languages)
trait Shape {
    fn area(&self) -> f64;
    fn perimeter(&self) -> f64;
    fn description(&self) -> String;
    
    // Default implementation
    fn is_congruent(&self, other: &dyn Shape) -> bool {
        (self.area() - other.area()).abs() < f64::EPSILON
    }
}

// Circle struct
#[derive(Debug, Clone)]
struct Circle {
    radius: f64,
}

impl Circle {
    // Associated function (constructor)
    fn new(radius: f64) -> Self {
        Circle { radius }
    }
    
    // Method specific to Circle
    fn diameter(&self) -> f64 {
        2.0 * self.radius
    }
}

// Implement Shape trait for Circle
impl Shape for Circle {
    fn area(&self) -> f64 {
        PI * self.radius * self.radius
    }
    
    fn perimeter(&self) -> f64 {
        2.0 * PI * self.radius
    }
    
    fn description(&self) -> String {
        format!("Circle with radius {:.2}", self.radius)
    }
    
    fn is_congruent(&self, other: &dyn Shape) -> bool {
        if let Some(other_circle) = other.downcast_ref::<Circle>() {
            (self.radius - other_circle.radius).abs() < f64::EPSILON
        } else {
            false
        }
    }
}

// Rectangle struct
#[derive(Debug, Clone)]
struct Rectangle {
    width: f64,
    height: f64,
}

impl Rectangle {
    fn new(width: f64, height: f64) -> Self {
        Rectangle { width, height }
    }
    
    fn is_square(&self) -> bool {
        (self.width - self.height).abs() < f64::EPSILON
    }
}

impl Shape for Rectangle {
    fn area(&self) -> f64 {
        self.width * self.height
    }
    
    fn perimeter(&self) -> f64 {
        2.0 * (self.width + self.height)
    }
    
    fn description(&self) -> String {
        format!("Rectangle with width {:.2} and height {:.2}", self.width, self.height)
    }
    
    fn is_congruent(&self, other: &dyn Shape) -> bool {
        if let Some(other_rect) = other.downcast_ref::<Rectangle>() {
            ((self.width - other_rect.width).abs() < f64::EPSILON
                && (self.height - other_rect.height).abs() < f64::EPSILON)
                || ((self.width - other_rect.height).abs() < f64::EPSILON
                    && (self.height - other_rect.width).abs() < f64::EPSILON)
        } else {
            false
        }
    }
}

// Triangle struct (three sides)
#[derive(Debug, Clone)]
struct Triangle {
    a: f64,
    b: f64,
    c: f64,
}

impl Triangle {
    fn new(a: f64, b: f64, c: f64) -> Result<Self, &'static str> {
        // Validate triangle inequality
        if a + b <= c || a + c <= b || b + c <= a {
            return Err("Invalid triangle: violates triangle inequality");
        }
        Ok(Triangle { a, b, c })
    }
    
    fn is_equilateral(&self) -> bool {
        (self.a - self.b).abs() < f64::EPSILON
            && (self.b - self.c).abs() < f64::EPSILON
    }
    
    fn is_isosceles(&self) -> bool {
        (self.a - self.b).abs() < f64::EPSILON
            || (self.a - self.c).abs() < f64::EPSILON
            || (self.b - self.c).abs() < f64::EPSILON
    }
}

impl Shape for Triangle {
    fn area(&self) -> f64 {
        // Heron's formula
        let s = (self.a + self.b + self.c) / 2.0;
        (s * (s - self.a) * (s - self.b) * (s - self.c)).sqrt()
    }
    
    fn perimeter(&self) -> f64 {
        self.a + self.b + self.c
    }
    
    fn description(&self) -> String {
        format!(
            "Triangle with sides {:.2}, {:.2}, {:.2}",
            self.a, self.b, self.c
        )
    }
}

// Square struct (special case of Rectangle)
#[derive(Debug, Clone)]
struct Square {
    side: f64,
}

impl Square {
    fn new(side: f64) -> Self {
        Square { side }
    }
}

impl Shape for Square {
    fn area(&self) -> f64 {
        self.side * self.side
    }
    
    fn perimeter(&self) -> f64 {
        4.0 * self.side
    }
    
    fn description(&self) -> String {
        format!("Square with side {:.2}", self.side)
    }
    
    fn is_congruent(&self, other: &dyn Shape) -> bool {
        if let Some(other_square) = other.downcast_ref::<Square>() {
            (self.side - other_square.side).abs() < f64::EPSILON
        } else {
            false
        }
    }
}

// Implement Display trait for all shapes
impl std::fmt::Display for dyn Shape {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        write!(f, "{}", self.description())
    }
}

// Collection of shapes
struct ShapeCollection {
    shapes: Vec<Box<dyn Shape>>,
}

impl ShapeCollection {
    fn new() -> Self {
        ShapeCollection {
            shapes: Vec::new(),
        }
    }
    
    fn add(&mut self, shape: Box<dyn Shape>) {
        self.shapes.push(shape);
    }
    
    fn total_area(&self) -> f64 {
        self.shapes.iter().map(|s| s.area()).sum()
    }
    
    fn total_perimeter(&self) -> f64 {
        self.shapes.iter().map(|s| s.perimeter()).sum()
    }
    
    fn largest_shape(&self) -> Option<&dyn Shape> {
        self.shapes
            .iter()
            .max_by(|a, b| a.area().partial_cmp(&b.area()).unwrap())
            .map(|s| s.as_ref())
    }
    
    fn print_all(&self) {
        println!("Shape Collection:");
        println!("================");
        for (i, shape) in self.shapes.iter().enumerate() {
            println!("{}. {}", i + 1, shape);
            println!("   Area: {:.2}, Perimeter: {:.2}", shape.area(), shape.perimeter());
        }
        println!();
        println!("Total Area: {:.2}", self.total_area());
        println!("Total Perimeter: {:.2}", self.total_perimeter());
        if let Some(largest) = self.largest_shape() {
            println!("Largest Shape: {} (Area: {:.2})", largest, largest.area());
        }
    }
}

// Trait for shapes that can be scaled
trait Scalable {
    fn scale(&mut self, factor: f64);
}

// Implement Scalable for different shapes
impl Scalable for Circle {
    fn scale(&mut self, factor: f64) {
        self.radius *= factor;
    }
}

impl Scalable for Rectangle {
    fn scale(&mut self, factor: f64) {
        self.width *= factor;
        self.height *= factor;
    }
}

impl Scalable for Square {
    fn scale(&mut self, factor: f64) {
        self.side *= factor;
    }
}

// Implement Scalable for Triangle
impl Scalable for Triangle {
    fn scale(&mut self, factor: f64) {
        self.a *= factor;
        self.b *= factor;
        self.c *= factor;
    }
}

// Demonstrate trait objects and dynamic dispatch
fn print_shape_info(shape: &dyn Shape) {
    println!("Shape: {}", shape);
    println!("  Area: {:.2}", shape.area());
    println!("  Perimeter: {:.2}", shape.perimeter());
}

// Demonstrate generic function with trait bounds
fn compare_shapes<T: Shape, U: Shape>(shape1: &T, shape2: &U) {
    println!("Comparing shapes:");
    println!("  {} vs {}", shape1.description(), shape2.description());
    println!("  Same area: {}", (shape1.area() - shape2.area()).abs() < f64::EPSILON);
    println!("  Same perimeter: {}", (shape1.perimeter() - shape2.perimeter()).abs() < f64::EPSILON);
}

fn main() {
    println!("=== Rust's Approach to Object-Oriented Programming ===");
    println!("Demonstrating traits, enums, and composition instead of classes and inheritance");
    println!();
    
    // Create different shapes
    let circle = Circle::new(5.0);
    let rectangle = Rectangle::new(4.0, 6.0);
    let triangle = Triangle::new(3.0, 4.0, 5.0).unwrap();
    let square = Square::new(4.0);
    
    // Demonstrate trait implementations
    println!("Individual Shapes:");
    println!("{}", circle);
    println!("  Area: {:.2}, Perimeter: {:.2}", circle.area(), circle.perimeter());
    println!();
    
    println!("{}", rectangle);
    println!("  Area: {:.2}, Perimeter: {:.2}", rectangle.area(), rectangle.perimeter());
    println!();
    
    println!("{}", triangle);
    println!("  Area: {:.2}, Perimeter: {:.2}", triangle.area(), triangle.perimeter());
    println!();
    
    println!("{}", square);
    println!("  Area: {:.2}, Perimeter: {:.2}", square.area(), square.perimeter());
    println!();
    
    // Demonstrate trait object usage (dynamic dispatch)
    println!("=== Trait Object Usage (Dynamic Dispatch) ===");
    let shapes: Vec<Box<dyn Shape>> = vec![
        Box::new(Circle::new(3.0)),
        Box::new(Rectangle::new(2.0, 4.0)),
        Box::new(Square::new(3.0)),
    ];
    
    for shape in &shapes {
        print_shape_info(shape.as_ref());
        println!();
    }
    
    // Demonstrate generic function (static dispatch)
    println!("=== Generic Function Usage (Static Dispatch) ===");
    compare_shapes(&circle, &rectangle);
    println!();
    
    // Demonstrate ShapeCollection
    println!("=== Shape Collection Demo ===");
    let mut collection = ShapeCollection::new();
    collection.add(Box::new(Circle::new(5.0)));
    collection.add(Box::new(Rectangle::new(4.0, 6.0)));
    collection.add(Box::new(Triangle::new(3.0, 4.0, 5.0).unwrap()));
    collection.add(Box::new(Square::new(4.0)));
    collection.print_all();
    
    // Demonstrate trait methods
    println!("\n=== Additional Trait Methods ===");
    println!("Circle is congruent to another Circle: {}", circle.is_congruent(&Circle::new(5.0)));
    println!("Rectangle is square: {}", rectangle.is_square());
    println!("Triangle is equilateral: {}", triangle.is_equilateral());
    
    // Demonstrate scaling
    println!("\n=== Scaling Shapes ===");
    let mut scalable_circle = Circle::new(2.0);
    println!("Before scaling: {}", scalable_circle);
    scalable_circle.scale(3.0);
    println!("After scaling by 3: {}", scalable_circle);
    
    // Pattern matching with enums (alternative to polymorphism)
    println!("\n=== Enums as Sum Types ===");
    let shapes_enum = vec![
        ShapeEnum::Circle(5.0),
        ShapeEnum::Rectangle(4.0, 6.0),
        ShapeEnum::Triangle(3.0, 4.0, 5.0),
    ];
    
    for shape in &shapes_enum {
        match shape {
            ShapeEnum::Circle(radius) => {
                println!("Circle with radius {}: area = {:.2}", radius, PI * radius * radius);
            }
            ShapeEnum::Rectangle(width, height) => {
                println!("Rectangle {}x{}: area = {:.2}", width, height, width * height);
            }
            ShapeEnum::Triangle(a, b, c) => {
                let s = (a + b + c) / 2.0;
                let area = (s * (s - a) * (s - b) * (s - c)).sqrt();
                println!("Triangle {} {} {}: area = {:.2}", a, b, c, area);
            }
        }
    }
}

// Alternative approach using enums instead of trait objects
#[derive(Debug)]
enum ShapeEnum {
    Circle(f64),
    Rectangle(f64, f64),
    Triangle(f64, f64, f64),
}

impl ShapeEnum {
    fn area(&self) -> f64 {
        match self {
            ShapeEnum::Circle(radius) => PI * radius * radius,
            ShapeEnum::Rectangle(width, height) => width * height,
            ShapeEnum::Triangle(a, b, c) => {
                let s = (a + b + c) / 2.0;
                (s * (s - a) * (s - b) * (s - c)).sqrt()
            }
        }
    }
    
    fn perimeter(&self) -> f64 {
        match self {
            ShapeEnum::Circle(radius) => 2.0 * PI * radius,
            ShapeEnum::Rectangle(width, height) => 2.0 * (width + height),
            ShapeEnum::Triangle(a, b, c) => a + b + c,
        }
    }
}

// Add downcast_ref to Shape trait for concrete type checking
trait ShapeExt: Shape {
    fn downcast_ref<T: 'static>(&self) -> Option<&T> {
        // In a real implementation, you'd use Any trait
        None
    }
}

impl<T: Shape + 'static> ShapeExt for T {}