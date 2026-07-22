# Java Fundamentals Interview Questions

## Top Interview Questions

### Basics

**Q: What is the difference between JDK, JRE, and JVM?**
A: JDK (Java Development Kit) includes development tools. JRE (Java Runtime Environment) includes libraries to run Java programs. JVM (Java Virtual Machine) executes bytecode.

**Q: What are the features of Java?**
A: Platform independent, object-oriented, secure, robust, multithreaded, portable.

**Q: What is the difference between `==` and `.equals()`?**
A: `==` compares references (memory address). `.equals()` compares content/values.

### OOP Concepts

**Q: What are the four pillars of OOP?**
A: Encapsulation, Inheritance, Polymorphism, Abstraction.

**Q: What is the difference between abstract class and interface?**
A: Abstract class can have constructors and non-abstract methods. Interface can only have abstract methods (until Java 8). A class can implement multiple interfaces but extend only one class.

**Q: Explain method overloading and overriding.**
A: Overloading: Same method name, different parameters (compile-time). Overriding: Same method signature in parent/child (runtime polymorphism).

### Data Types

**Q: What is the difference between primitive and reference types?**
A: Primitive types store actual values (int, boolean). Reference types store references to objects (String, Array).

**Q: What is autoboxing and unboxing?**
A: Autoboxing: Automatic conversion from primitive to wrapper class. Unboxing: Automatic conversion from wrapper to primitive.

### Collections

**Q: What is the difference between ArrayList and LinkedList?**
A: ArrayList uses array (fast random access). LinkedList uses doubly-linked list (fast insert/delete).

**Q: What is the difference between HashMap and TreeMap?**
A: HashMap uses hash table (O(1) operations). TreeMap uses Red-Black tree (O(log n) operations, sorted order).

**Q: What is the difference between HashSet and TreeSet?**
A: HashSet uses hash table (O(1) operations). TreeSet uses Red-Black tree (O(log n) operations, sorted order).

### Exception Handling

**Q: What is the difference between checked and unchecked exceptions?**
A: Checked: Compile-time checked (IOException). Unchecked: Runtime exceptions (NullPointerException).

**Q: What is the finally block?**
A: Code that always executes after try-catch, regardless of exception. Used for cleanup.

### Multithreading

**Q: What is the difference between Thread and Runnable?**
A: Thread is a class. Runnable is an interface. Implementing Runnable is preferred as it allows extending other classes.

**Q: What is synchronization?**
A: Mechanism to control access to shared resources by multiple threads. Prevents race conditions.

### Java 8 Features

**Q: What are lambda expressions?**
A: Anonymous functions that can be passed as arguments. Syntax: `(parameters) -> expression`.

**Q: What is the Stream API?**
A: Functional-style operations on collections. Supports filter, map, reduce, collect operations.

### Coding Questions

**Q: Reverse a string.**
```java
public static String reverse(String str) {
    return new StringBuilder(str).reverse().toString();
}
```

**Q: Check if string is palindrome.**
```java
public static boolean isPalindrome(String str) {
    String reversed = new StringBuilder(str).reverse().toString();
    return str.equals(reversed);
}
```

**Q: Find factorial.**
```java
public static int factorial(int n) {
    if (n == 0) return 1;
    return n * factorial(n - 1);
}
```

**Q: Implement binary search.**
```java
public static int binarySearch(int[] arr, int target) {
    int left = 0, right = arr.length - 1;
    while (left <= right) {
        int mid = left + (right - left) / 2;
        if (arr[mid] == target) return mid;
        else if (arr[mid] < target) left = mid + 1;
        else right = mid - 1;
    }
    return -1;
}
```

## Resources

- Effective Java by Joshua Bloch
- Java: The Complete Reference
- Head First Java