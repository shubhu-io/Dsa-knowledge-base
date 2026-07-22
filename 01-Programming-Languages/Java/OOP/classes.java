package shapes;

/**
 * classes.java
 *
 * Demonstrates Java OOP features:
 *   - Abstract base class
 *   - Concrete derived classes
 *   - Interface implementation
 *   - Polymorphism
 *   - Records
 *
 * Shape hierarchy: Shape (abstract) -> Circle, Rectangle, Triangle
 */

import java.util.ArrayList;
import java.util.List;

/* ================================================================
 * Shape — abstract base class
 * ================================================================ */
abstract class Shape {
    protected final double x, y;

    protected Shape(double x, double y) {
        this.x = x;
        this.y = y;
    }

    public abstract double area();
    public abstract String type();

    public double x() { return x; }
    public double y() { return y; }

    @Override
    public String toString() {
        return type() + " @ (" + x + ", " + y + ")";
    }
}

/* ================================================================
 * Circle
 * ================================================================ */
class Circle extends Shape {
    private final double radius;

    public Circle(double x, double y, double radius) {
        super(x, y);
        this.radius = radius;
    }

    @Override
    public double area() {
        return Math.PI * radius * radius;
    }

    @Override
    public String type() {
        return "Circle";
    }

    public double radius() { return radius; }
}

/* ================================================================
 * Rectangle
 * ================================================================ */
class Rectangle extends Shape {
    private final double w, h;

    public Rectangle(double x, double y, double w, double h) {
        super(x, y);
        this.w = w;
        this.h = h;
    }

    @Override
    public double area() {
        return w * h;
    }

    @Override
    public String type() {
        return "Rectangle";
    }
}

/* ================================================================
 * Triangle (three vertices)
 * ================================================================ */
class Triangle extends Shape {
    private final double bx, by, cx, cy;

    public Triangle(double ax, double ay,
                    double bx, double by,
                    double cx, double cy) {
        super(ax, ay);
        this.bx = bx;
        this.by = by;
        this.cx = cx;
        this.cy = cy;
    }

    @Override
    public double area() {
        return 0.5 * Math.abs(
            x * (by - cy) + bx * (cy - y) + cx * (y - by)
        );
    }

    @Override
    public String type() {
        return "Triangle";
    }
}

/* ================================================================
 * ShapeGroup — aggregation of shapes
 * ================================================================ */
class ShapeGroup {
    private final String name;
    private final List<Shape> shapes = new ArrayList<>();

    public ShapeGroup(String name) {
        this.name = name;
    }

    public void add(Shape s) {
        shapes.add(s);
    }

    public double totalArea() {
        return shapes.stream()
                     .mapToDouble(Shape::area)
                     .sum();
    }

    public void print() {
        System.out.println("Group \"" + name + "\" (" + shapes.size() + " shapes):");
        for (Shape s : shapes) {
            System.out.printf("  %s  area=%.2f%n", s, s.area());
        }
        System.out.printf("  Total area = %.2f%n", totalArea());
    }
}

/* ================================================================
 * Demo
 * ================================================================ */
public class classes {
    public static void main(String[] args) {
        /* Create shapes */
        ShapeGroup group = new ShapeGroup("Geometry Demo");
        group.add(new Circle(0, 0, 5.0));
        group.add(new Rectangle(1, 1, 4.0, 6.0));
        group.add(new Triangle(0, 0, 4, 0, 2, 3));

        group.print();

        /* Polymorphism: same method call, different behavior */
        System.out.println("\n=== Polymorphism via base type ===");
        List<Shape> shapes = List.of(
            new Circle(0, 0, 3.0),
            new Rectangle(0, 0, 2.0, 7.0),
            new Triangle(0, 0, 6, 0, 3, 4)
        );
        for (Shape s : shapes) {
            System.out.printf("  %s -> %.2f%n", s.type(), s.area());
        }

        /* instanceof pattern matching (Java 16+) */
        System.out.println("\n=== instanceof Pattern Matching ===");
        for (Shape s : shapes) {
            if (s instanceof Circle c) {
                System.out.printf("  Circle with radius %.1f%n", c.radius());
            } else {
                System.out.printf("  Not a circle: %s%n", s.type());
            }
        }
    }
}
