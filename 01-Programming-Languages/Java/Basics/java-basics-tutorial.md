# Java Basics Tutorial

## Variables and Data Types

```java
public class Main {
    public static void main(String[] args) {
        // Primitive types
        int age = 30;
        double height = 5.5;
        char grade = 'A';
        boolean isStudent = true;
        
        // Reference types
        String name = "Alice";
        
        // Constants
        final double PI = 3.14159;
        
        System.out.println("Name: " + name + ", Age: " + age);
    }
}
```

## Data Types

- **byte**: 8-bit integer
- **short**: 16-bit integer
- **int**: 32-bit integer
- **long**: 64-bit integer
- **float**: 32-bit decimal
- **double**: 64-bit decimal
- **char**: 16-bit Unicode
- **boolean**: true/false

## Control Flow

### If-Else
```java
if (age >= 18) {
    System.out.println("Adult");
} else if (age >= 13) {
    System.out.println("Teenager");
} else {
    System.out.println("Child");
}
```

### Switch
```java
switch (day) {
    case "Monday":
        System.out.println("Start of week");
        break;
    case "Friday":
        System.out.println("Almost weekend");
        break;
    default:
        System.out.println("Midweek");
}
```

### For Loop
```java
for (int i = 0; i < 5; i++) {
    System.out.println(i);
}

// Enhanced for loop
int[] numbers = {1, 2, 3, 4, 5};
for (int num : numbers) {
    System.out.println(num);
}
```

## Methods

```java
// Basic method
public static int add(int a, int b) {
    return a + b;
}

// Method overloading
public static double add(double a, double b) {
    return a + b;
}

// Varargs
public static int sum(int... numbers) {
    int total = 0;
    for (int num : numbers) {
        total += num;
    }
    return total;
}
```

## Classes and Objects

```java
public class Person {
    private String name;
    private int age;
    
    // Constructor
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
    
    // Getters and setters
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }
    
    // Method
    public String greet() {
        return "Hello, I'm " + name;
    }
    
    @Override
    public String toString() {
        return name + ", " + age + " years old";
    }
}
```

## Inheritance

```java
public class Student extends Person {
    private String grade;
    
    public Student(String name, int age, String grade) {
        super(name, age);
        this.grade = grade;
    }
    
    @Override
    public String greet() {
        return super.greet() + ", and I'm a student";
    }
}
```

## Abstract Classes

```java
public abstract class Shape {
    public abstract double area();
    public abstract double perimeter();
    
    public String describe() {
        return "Area: " + area() + ", Perimeter: " + perimeter();
    }
}

public class Circle extends Shape {
    private double radius;
    
    public Circle(double radius) {
        this.radius = radius;
    }
    
    @Override
    public double area() {
        return Math.PI * radius * radius;
    }
    
    @Override
    public double perimeter() {
        return 2 * Math.PI * radius;
    }
}
```

## Interfaces

```java
public interface Drawable {
    void draw();
    default String getColor() {
        return "Black";
    }
}

public class Rectangle implements Drawable {
    @Override
    public void draw() {
        System.out.println("Drawing rectangle");
    }
}
```

## Generics

```java
// Generic class
public class Box<T> {
    private T content;
    
    public void set(T content) {
        this.content = content;
    }
    
    public T get() {
        return content;
    }
}

// Generic method
public static <T> T getFirst(List<T> list) {
    return list.get(0);
}
```

## Collections

```java
import java.util.*;

// List
List<Integer> numbers = new ArrayList<>();
numbers.add(1);
numbers.add(2);
numbers.add(3);

// Map
Map<String, Integer> map = new HashMap<>();
map.put("Alice", 30);
map.put("Bob", 25);

// Set
Set<String> set = new HashSet<>();
set.add("A");
set.add("B");

// Iterating
for (int num : numbers) {
    System.out.println(num);
}
```

## Exception Handling

```java
try {
    int result = 10 / 0;
} catch (ArithmeticException e) {
    System.out.println("Error: " + e.getMessage());
} finally {
    System.out.println("Always runs");
}

// Custom exception
public class ValidationException extends Exception {
    public ValidationException(String message) {
        super(message);
    }
}
```

## Best Practices

1. Use meaningful variable names
2. Follow naming conventions (camelCase for methods/variables, PascalCase for classes)
3. Use encapsulation (private fields, public getters/setters)
4. Prefer composition over inheritance
5. Use interfaces for flexibility
6. Handle exceptions properly
7. Use try-with-resources for auto-closeable resources