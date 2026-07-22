# Object-Oriented Programming in Java

## Overview

Java is a class-based, object-oriented language with built-in support for encapsulation, inheritance, polymorphism, and abstraction. It enforces single inheritance of implementation but allows multiple interface implementation, and provides extensive features for managing complexity in large systems.

## Classes

A Java class defines the structure (fields) and behavior (methods) of objects.

```java
public class BankAccount {
    private final String owner;      /* encapsulation: private field */
    private double balance;

    /* Constructor */
    public BankAccount(String owner, double initial) {
        this.owner = owner;
        this.balance = initial;
    }

    /* Methods */
    public void deposit(double amount) {
        if (amount <= 0) throw new IllegalArgumentException("Amount must be positive");
        balance += amount;
    }

    public boolean withdraw(double amount) {
        if (amount > balance) return false;
        balance -= amount;
        return true;
    }

    public double getBalance() { return balance; }

    @Override
    public String toString() {
        return String.format("Account(%s, $%.2f)", owner, balance);
    }
}
```

## Interfaces

An interface defines a contract — a set of methods a class must implement. Java interfaces can contain default and static methods.

```java
public interface Drawable {
    void draw();                                /* abstract */
    default void drawHighlighted() {            /* default (Java 8+) */
        draw();
        System.out.println("Highlighted!");
    }
}

public interface Serializable {
    String toJson();
}

/* A class implements one or more interfaces */
public class Circle implements Drawable, Serializable {
    private double radius;

    public Circle(double radius) { this.radius = radius; }

    @Override
    public void draw() {
        System.out.println("Drawing circle r=" + radius);
    }

    @Override
    public String toJson() {
        return "{\"type\":\"circle\",\"r\":" + radius + "}";
    }
}
```

## Abstract Classes

Abstract classes can have both implemented and abstract methods — useful for partial implementations.

```java
public abstract class Shape {
    protected double x, y;

    public Shape(double x, double y) {
        this.x = x;
        this.y = y;
    }

    /* Abstract — subclasses must implement */
    public abstract double area();
    public abstract String type();

    /* Concrete — shared implementation */
    public void moveTo(double newX, double newY) {
        this.x = newX;
        this.y = newY;
    }
}
```

## Inheritance and Polymorphism

```java
public class Rectangle extends Shape {
    private final double w, h;

    public Rectangle(double x, double y, double w, double h) {
        super(x, y);
        this.w = w;
        this.h = h;
    }

    @Override
    public double area() { return w * h; }

    @Override
    public String type() { return "Rectangle"; }
}

/* Polymorphism: base type, derived behavior */
Shape s = new Rectangle(0, 0, 4, 6);
System.out.println(s.area());    /* 24.0 — runtime dispatch */
System.out.println(s.type());   /* "Rectangle" */
```

## Generics

Type parameters enable reusable, type-safe code without casting.

```java
/* Generic class */
public class Pair<A, B> {
    private final A first;
    private final B second;

    public Pair(A first, B second) {
        this.first = first;
        this.second = second;
    }

    public A first() { return first; }
    public B second() { return second; }
}

Pair<String, Integer> pair = new Pair<>("Alice", 30);

/* Bounded type parameters */
public static <T extends Comparable<T>> T min(T a, T b) {
    return a.compareTo(b) <= 0 ? a : b;
}

/* Wildcard generics */
public static double sumList(List<? extends Number> list) {
    double sum = 0;
    for (Number n : list) sum += n.doubleValue();
    return sum;
}
```

## Enums

Enums in Java are first-class types with fields, methods, and constructors.

```java
public enum Direction {
    NORTH(0, 1),
    SOUTH(0, -1),
    EAST(1, 0),
    WEST(-1, 0);

    private final int dx, dy;

    Direction(int dx, int dy) {
        this.dx = dx;
        this.dy = dy;
    }

    public int dx() { return dx; }
    public int dy() { return dy; }

    public Direction opposite() {
        return switch (this) {
            case NORTH -> SOUTH;
            case SOUTH -> NORTH;
            case EAST  -> WEST;
            case WEST  -> EAST;
        };
    }
}
```

## Inner Classes

```java
public class LinkedList<T> {
    private Node<T> head;

    /* Inner class — has access to outer class fields */
    private static class Node<T> {
        T data;
        Node<T> next;
        Node(T data) { this.data = data; }
    }

    public void add(T item) {
        Node<T> node = new Node<>(item);
        node.next = head;
        head = node;
    }

    /* Anonymous inner class */
    public void printAll() {
        forEach(System.out::println);
    }
}
```

## SOLID Principles

| Principle | Meaning | Java Mechanism |
|-----------|---------|----------------|
| **S**ingle Responsibility | One class, one job | Class design |
| **O**pen/Closed | Open for extension, closed for modification | Abstract classes + interfaces |
| **L**iskov Substitution | Derived classes must be substitutable for base | Proper inheritance |
| **I**nterface Segregation | Many small interfaces over one large | Interface design |
| **D**ependency Inversion | Depend on abstractions, not concretions | Interface injection |

```java
/* DIP example: depend on interface, not concrete class */
public class OrderService {
    private final PaymentProcessor processor;  /* interface, not class */

    public OrderService(PaymentProcessor processor) {
        this.processor = processor;  /* injected */
    }
}
```

## Records (Java 16+)

Records provide concise, immutable data carriers.

```java
public record Point(double x, double y) {
    /* Compact canonical constructor */
    public Point {
        if (x < 0 || y < 0) throw new IllegalArgumentException("Negative coords");
    }

    public double distanceTo(Point other) {
        return Math.hypot(x - other.x, y - other.y);
    }
}

Point p = new Point(3, 4);
System.out.println(p.x());      /* 3.0 */
System.out.println(p);          /* Point[x=3.0, y=4.0] */
```

## Common Pitfalls

| Pitfall | Problem | Fix |
|---------|---------|-----|
| Forgetting `@Override` | Silent method misspelling | Always annotate |
| Mutable shared state | Race conditions | Use immutable objects, `synchronized` |
| Raw types | Loss of type safety | Always use parameterized types |
| `==` vs `.equals()` | Reference comparison, not value | Override `.equals()` and `.hashCode()` |
| NPE | Null pointer exception | Use `Optional<T>`, null checks |

## See Also

- [[syntax-java]] — Java syntax reference
- [[classes-java]] — Shape hierarchy example
- [[oop-cpp]] — OOP in C++
