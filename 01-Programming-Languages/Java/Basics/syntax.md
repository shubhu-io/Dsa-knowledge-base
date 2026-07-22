# Java Syntax Reference

## Primitives and Wrapper Types

Java is statically typed with 8 primitive types and their object wrapper equivalents.

```java
public class Primitives {
    public static void main(String[] args) {
        /* Primitive types */
        byte   b = 127;            /* 8-bit  */
        short  s = 32000;          /* 16-bit */
        int    i = 2_000_000_000;  /* 32-bit */
        long   l = 9_000_000_000L; /* 64-bit */
        float  f = 3.14f;         /* 32-bit */
        double d = 3.14159265;    /* 64-bit */
        char   c = 'A';          /* 16-bit Unicode */
        boolean flag = true;      /* true or false */

        /* Wrapper classes (autoboxing/unboxing) */
        Integer boxed = i;        /* autobox */
        int unboxed = boxed;      /* unbox */

        /* String is NOT a primitive — it's an immutable object */
        String name = "Alice";
    }
}
```

## String and StringBuilder

```java
String s = "Hello, World!";

/* Immutable string operations return new strings */
String upper = s.toUpperCase();
String sub   = s.substring(0, 5);
int idx      = s.indexOf("World");
boolean has  = s.contains("World");

/* StringBuilder for mutable string construction */
StringBuilder sb = new StringBuilder();
sb.append("Hello");
sb.append(" ");
sb.append("World");
sb.insert(5, ",");
sb.reverse();
String result = sb.toString();
```

## Generics

Generics provide type safety at compile time without runtime overhead (type erasure).

```java
/* Generic class */
public class Box<T> {
    private T value;

    public Box(T value) { this.value = value; }
    public T getValue() { return value; }
    public void setValue(T value) { this.value = value; }
}

Box<String> stringBox = new Box<>("hello");
Box<Integer> intBox = new Box<>(42);

/* Bounded type parameters */
public <T extends Comparable<T>> T max(T a, T b) {
    return a.compareTo(b) >= 0 ? a : b;
}

/* Wildcards */
public double sum(List<? extends Number> list) {
    return list.stream().mapToDouble(Number::doubleValue).sum();
}
```

## Interfaces

```java
public interface Drawable {
    void draw();                          /* abstract by default */

    default void drawWithBorder() {       /* default method (Java 8+) */
        draw();
        System.out.println("Border");
    }

    static Drawable empty() {             /* static method */
        return () -> System.out.println("Nothing");
    }
}

public interface Serializable {
    String serialize();
}

/* Implementing multiple interfaces */
public class Widget implements Drawable, Serializable {
    @Override
    public void draw() { System.out.println("Widget"); }

    @Override
    public String serialize() { return "Widget{}"; }
}
```

## Enums

Enums are full classes with fields, methods, and constructors.

```java
public enum Planet {
    MERCURY(3.303e+23, 2.4397e6),
    VENUS  (4.869e+24, 6.0518e6),
    EARTH  (5.976e+24, 6.37814e6);

    private final double mass;
    private final double radius;

    Planet(double mass, double radius) {
        this.mass = mass;
        this.radius = radius;
    }

    public double surfaceGravity() {
        final double G = 6.67300E-11;
        return G * mass / (radius * radius);
    }
}

Planet p = Planet.EARTH;
System.out.println(p.name());        /* "EARTH" */
System.out.println(p.ordinal());    /* 2 */
System.out.println(p.surfaceGravity());
```

## Annotations

```java
/* Built-in annotations */
@Override     /* method overrides a superclass method */
@SuppressWarnings("unchecked")  /* suppress compiler warnings */
@FunctionalInterface  /* marks interface as single-abstract-method */

/* Custom annotation */
import java.lang.annotation.*;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface Route {
    String path();
    HttpMethod method() default HttpMethod.GET;
}
```

## Streams (Java 8+)

Streams provide a functional, declarative approach to processing collections.

```java
import java.util.List;
import java.util.stream.*;
import java.util.Optional;

List<String> names = List.of("Alice", "Bob", "Charlie", "David");

/* Filter, map, collect */
List<String> result = names.stream()
    .filter(name -> name.length() > 3)
    .map(String::toUpperCase)
    .sorted()
    .collect(Collectors.toList());
/* [ALICE, CHARLIE, DAVID] */

/* Reduce */
int totalLength = names.stream()
    .mapToInt(String::length)
    .sum();

/* Find first */
Optional<String> first = names.stream()
    .filter(n -> n.startsWith("B"))
    .findFirst();

/* Grouping */
Map<Integer, List<String>> byLength = names.stream()
    .collect(Collectors.groupingBy(String::length));
```

## Lambda Expressions

```java
/* Lambda syntax: (params) -> expression  or  (params) -> { statements; */
Runnable r = () -> System.out.println("Hello");

Comparator<String> comp = (a, b) -> a.length() - b.length();

/* Method references */
List<String> names = List.of("alice", "bob", "charlie");
names.forEach(System.out::println);          /* static method ref */
names.stream().map(String::toUpperCase);     /* instance method ref */
names.stream().map(name -> name.charAt(0));  /* equivalent lambda */
```

## Exception Handling

```java
try {
    int result = 10 / 0;
} catch (ArithmeticException e) {
    System.out.println("Error: " + e.getMessage());
} finally {
    System.out.println("Cleanup");
}

/* Try-with-resources (AutoCloseable) */
try (BufferedReader br = new BufferedReader(new FileReader("file.txt"))) {
    String line = br.readLine();
}

/* Custom exceptions */
public class InsufficientFundsException extends Exception {
    private final double deficit;
    public InsufficientFundsException(double deficit) {
        super("Insufficient funds: need " + deficit);
        this.deficit = deficit;
    }
}
```

## Records and Sealed Classes (Java 16+)

```java
/* Record — immutable data class */
public record Point(double x, double y) {
    public double distanceTo(Point other) {
        return Math.hypot(x - other.x, y - other.y);
    }
}

Point p = new Point(3.0, 4.0);
System.out.println(p.x());         /* accessor */
System.out.println(p.distanceTo(new Point(0, 0)));  /* 5.0 */

/* Sealed class — restricts which classes can extend */
public sealed interface Shape
    permits Circle, Rectangle, Triangle {}
```

## See Also

- [[java-basics-tutorial]]
- [[oop-java]]
- [[classes-java]]
