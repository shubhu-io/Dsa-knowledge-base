# Java Fundamentals

## Basic Syntax

```java
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
```

## Data Types

### Primitive Types
| Type | Size | Range |
|------|------|-------|
| byte | 1 byte | -128 to 127 |
| short | 2 bytes | -32,768 to 32,767 |
| int | 4 bytes | -2^31 to 2^31-1 |
| long | 8 bytes | -2^63 to 2^63-1 |
| float | 4 bytes | ±3.4e38 |
| double | 8 bytes | ±1.7e308 |
| char | 2 bytes | 0 to 65,535 |
| boolean | 1 bit | true/false |

### Reference Types
- String
- Arrays
- Classes
- Interfaces

## Control Flow

### If-Else
```java
if (condition) {
    // code
} else if (condition2) {
    // code
} else {
    // code
}
```

### Switch
```java
switch (expression) {
    case 1:
        // code
        break;
    case 2:
        // code
        break;
    default:
        // code
}
```

### Loops
```java
// For loop
for (int i = 0; i < 10; i++) {
    // code
}

// Enhanced for loop
int[] arr = {1, 2, 3};
for (int num : arr) {
    // code
}

// While loop
while (condition) {
    // code
}

// Do-while loop
do {
    // code
} while (condition);
```

## Methods

```java
// Method declaration
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
// Class definition
public class Person {
    // Fields
    private String name;
    private int age;
    
    // Constructor
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
    
    // Methods
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    @Override
    public String toString() {
        return name + ", " + age;
    }
}
```

## Inheritance

```java
// Parent class
public class Animal {
    protected String name;
    
    public Animal(String name) {
        this.name = name;
    }
    
    public void speak() {
        System.out.println(name + " makes a sound");
    }
}

// Child class
public class Dog extends Animal {
    public Dog(String name) {
        super(name);
    }
    
    @Override
    public void speak() {
        System.out.println(name + " barks");
    }
}
```

## Interfaces

```java
// Interface definition
public interface Drawable {
    void draw();
    default String getColor() {
        return "Black";
    }
}

// Implementation
public class Circle implements Drawable {
    @Override
    public void draw() {
        System.out.println("Drawing circle");
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
numbers.get(0);  // Access

// Set
Set<String> set = new HashSet<>();
set.add("A");
set.contains("A");  // Check

// Map
Map<String, Integer> map = new HashMap<>();
map.put("Alice", 30);
map.get("Alice");  // Access

// Queue
Queue<Integer> queue = new LinkedList<>();
queue.offer(1);
queue.poll();  // Remove

// Stack
Stack<Integer> stack = new Stack<>();
stack.push(1);
stack.pop();  // Remove
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
2. Follow naming conventions
3. Use encapsulation
4. Prefer composition over inheritance
5. Use interfaces for flexibility
6. Handle exceptions properly
7. Use try-with-resources for auto-closeable resources
8. Write documentation comments