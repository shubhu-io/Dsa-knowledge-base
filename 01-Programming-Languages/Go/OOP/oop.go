// Package main demonstrates Go's approach to object-oriented programming
// using interfaces, struct embedding, and composition instead of classes and inheritance.
package main

import (
	"fmt"
	"math"
)

// Shape interface defines the contract for all shapes.
// In Go, interfaces are satisfied implicitly - no "implements" keyword needed.
type Shape interface {
	Area() float64
	Perimeter() float64
	String() string
}

// Circle represents a circle shape.
type Circle struct {
	Radius float64
}

// Area calculates the area of the circle.
// Time complexity: O(1)
func (c Circle) Area() float64 {
	return math.Pi * c.Radius * c.Radius
}

// Perimeter calculates the circumference of the circle.
// Time complexity: O(1)
func (c Circle) Perimeter() float64 {
	return 2 * math.Pi * c.Radius
}

// String returns a string representation of the circle.
func (c Circle) String() string {
	return fmt.Sprintf("Circle{Radius: %.2f}", c.Radius)
}

// Rectangle represents a rectangle shape.
type Rectangle struct {
	Width, Height float64
}

// Area calculates the area of the rectangle.
// Time complexity: O(1)
func (r Rectangle) Area() float64 {
	return r.Width * r.Height
}

// Perimeter calculates the perimeter of the rectangle.
// Time complexity: O(1)
func (r Rectangle) Perimeter() float64 {
	return 2 * (r.Width + r.Height)
}

// String returns a string representation of the rectangle.
func (r Rectangle) String() string {
	return fmt.Sprintf("Rectangle{Width: %.2f, Height: %.2f}", r.Width, r.Height)
}

// Triangle represents a triangle shape using three sides.
type Triangle struct {
	A, B, C float64 // Sides
}

// Area calculates the area using Heron's formula.
// Time complexity: O(1)
func (t Triangle) Area() float64 {
	s := (t.A + t.B + t.C) / 2
	return math.Sqrt(s * (s - t.A) * (s - t.B) * (s - t.C))
}

// Perimeter calculates the perimeter of the triangle.
// Time complexity: O(1)
func (t Triangle) Perimeter() float64 {
	return t.A + t.B + t.C
}

// String returns a string representation of the triangle.
func (t Triangle) String() string {
	return fmt.Sprintf("Triangle{A: %.2f, B: %.2f, C: %.2f}", t.A, t.B, t.C)
}

// Square embeds Rectangle to reuse its functionality.
// This demonstrates composition over inheritance.
type Square struct {
	Rectangle // Embedded struct
}

// NewSquare creates a new square with the given side length.
func NewSquare(side float64) Square {
	return Square{
		Rectangle: Rectangle{Width: side, Height: side},
	}
}

// Area is promoted from Rectangle, but we can override it if needed.
// Time complexity: O(1)
func (s Square) Area() float64 {
	return s.Rectangle.Area() // Explicitly call embedded method
}

// String returns a string representation of the square.
func (s Square) String() string {
	return fmt.Sprintf("Square{Side: %.2f}", s.Rectangle.Width)
}

// ShapeCollection demonstrates working with a collection of shapes.
type ShapeCollection struct {
	shapes []Shape
}

// NewShapeCollection creates a new shape collection.
func NewShapeCollection() *ShapeCollection {
	return &ShapeCollection{
		shapes: make([]Shape, 0),
	}
}

// Add adds a shape to the collection.
func (sc *ShapeCollection) Add(s Shape) {
	sc.shapes = append(sc.shapes, s)
}

// TotalArea calculates the sum of areas of all shapes.
// Time complexity: O(n) where n is the number of shapes
func (sc *ShapeCollection) TotalArea() float64 {
	total := 0.0
	for _, shape := range sc.shapes {
		total += shape.Area()
	}
	return total
}

// TotalPerimeter calculates the sum of perimeters of all shapes.
// Time complexity: O(n) where n is the number of shapes
func (sc *ShapeCollection) TotalPerimeter() float64 {
	total := 0.0
	for _, shape := range sc.shapes {
		total += shape.Perimeter()
	}
	return total
}

// LargestShape returns the shape with the largest area.
// Time complexity: O(n)
func (sc *ShapeCollection) LargestShape() Shape {
	if len(sc.shapes) == 0 {
		return nil
	}

	largest := sc.shapes[0]
	for _, shape := range sc.shapes[1:] {
		if shape.Area() > largest.Area() {
			largest = shape
		}
	}
	return largest
}

// PrintAll prints information about all shapes.
func (sc *ShapeCollection) PrintAll() {
	fmt.Println("Shape Collection:")
	fmt.Println("================")
	for i, shape := range sc.shapes {
		fmt.Printf("%d. %s\n", i+1, shape)
		fmt.Printf("   Area: %.2f, Perimeter: %.2f\n", shape.Area(), shape.Perimeter())
	}
	fmt.Printf("\nTotal Area: %.2f\n", sc.TotalArea())
	fmt.Printf("Total Perimeter: %.2f\n", sc.TotalPerimeter())
	if largest := sc.LargestShape(); largest != nil {
		fmt.Printf("Largest Shape: %s (Area: %.2f)\n", largest, largest.Area())
	}
}

// Matrix demonstrates struct embedding for code reuse.
type Matrix struct {
	Rows, Cols int
	data       [][]float64
}

// NewMatrix creates a new matrix with the given dimensions.
func NewMatrix(rows, cols int) *Matrix {
	data := make([][]float64, rows)
	for i := range data {
		data[i] = make([]float64, cols)
	}
	return &Matrix{Rows: rows, Cols: cols, data: data}
}

// Set sets a value in the matrix.
func (m *Matrix) Set(row, col int, value float64) {
	if row >= 0 && row < m.Rows && col >= 0 && col < m.Cols {
		m.data[row][col] = value
	}
}

// Get gets a value from the matrix.
func (m *Matrix) Get(row, col int) float64 {
	if row >= 0 && row < m.Rows && col >= 0 && col < m.Cols {
		return m.data[row][col]
	}
	return 0
}

// String returns a string representation of the matrix.
func (m *Matrix) String() string {
	result := fmt.Sprintf("Matrix{%dx%d}:\n", m.Rows, m.Cols)
	for i := 0; i < m.Rows; i++ {
		for j := 0; j < m.Cols; j++ {
			result += fmt.Sprintf("%6.2f ", m.data[i][j])
		}
		result += "\n"
	}
	return result
}

func main() {
	fmt.Println("=== Go's Approach to Object-Oriented Programming ===")
	fmt.Println("Demonstrating interfaces, struct embedding, and composition")
	fmt.Println()

	// Create different shapes
	circle := Circle{Radius: 5.0}
	rectangle := Rectangle{Width: 4.0, Height: 6.0}
	triangle := Triangle{A: 3.0, B: 4.0, C: 5.0}
	square := NewSquare(4.0)

	// Demonstrate that all shapes implement the Shape interface
	fmt.Println("Individual Shapes:")
	fmt.Printf("%s\n", circle)
	fmt.Printf("  Area: %.2f, Perimeter: %.2f\n\n", circle.Area(), circle.Perimeter())

	fmt.Printf("%s\n", rectangle)
	fmt.Printf("  Area: %.2f, Perimeter: %.2f\n\n", rectangle.Area(), rectangle.Perimeter())

	fmt.Printf("%s\n", triangle)
	fmt.Printf("  Area: %.2f, Perimeter: %.2f\n\n", triangle.Area(), triangle.Perimeter())

	fmt.Printf("%s\n", square)
	fmt.Printf("  Area: %.2f, Perimeter: %.2f\n\n", square.Area(), square.Perimeter())

	// Use shapes polymorphically through the Shape interface
	fmt.Println("Polymorphic usage:")
	shapes := []Shape{circle, rectangle, triangle, square}
	for _, shape := range shapes {
		fmt.Printf("Shape: %s\n", shape)
	}

	// Use ShapeCollection to group shapes
	fmt.Println("\n=== Shape Collection Demo ===")
	collection := NewShapeCollection()
	collection.Add(circle)
	collection.Add(rectangle)
	collection.Add(triangle)
	collection.Add(square)
	collection.PrintAll()

	// Demonstrate method promotion through embedding
	fmt.Println("\n=== Struct Embedding Demo ===")
	fmt.Println("Square inherits from Rectangle through embedding:")
	fmt.Printf("Square area (promoted): %.2f\n", square.Area())
	fmt.Printf("Square perimeter (promoted): %.2f\n", square.Perimeter())

	// Matrix example showing code reuse
	fmt.Println("\n=== Matrix with Embedded Structs ===")
	m := NewMatrix(2, 2)
	m.Set(0, 0, 1.0)
	m.Set(0, 1, 2.0)
	m.Set(1, 0, 3.0)
	m.Set(1, 1, 4.0)
	fmt.Println(m)

	// Interface satisfaction check
	fmt.Println("=== Interface Satisfaction ===")
	fmt.Printf("Circle satisfies Shape: %v\n", doesImplement(circle))
	fmt.Printf("Rectangle satisfies Shape: %v\n", doesImplement(rectangle))
	fmt.Printf("int satisfies Shape: %v\n", doesImplement(42))
}

// doesImplement checks if a type implements the Shape interface.
// This is a runtime check; in Go, interface satisfaction is usually verified at compile time.
func doesImplement(shape interface{}) bool {
	_, ok := shape.(Shape)
	return ok
}