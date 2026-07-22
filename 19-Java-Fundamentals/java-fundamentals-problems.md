# Java Fundamentals Problems

## Beginner Problems

### 1. Basic Syntax and Data Types
**Problem**: Write a Java program that calculates the area of a rectangle given its length and width.
**Solution**:
```java
import java.util.Scanner;

public class RectangleArea {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        
        System.out.print("Enter the length of the rectangle: ");
        double length = scanner.nextDouble();
        
        System.out.print("Enter the width of the rectangle: ");
        double width = scanner.nextDouble();
        
        double area = length * width;
        
        System.out.printf("The area of the rectangle is: %.2f%n", area);
        
        scanner.close();
    }
}
```

### 2. Control Flow - Grade Calculator
**Problem**: Create a program that takes a student's score and outputs their letter grade.
**Solution**:
```java
import java.util.Scanner;

public class GradeCalculator {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        
        System.out.print("Enter the student's score (0-100): ");
        int score = scanner.nextInt();
        
        char grade;
        if (score >= 90) {
            grade = 'A';
        } else if (score >= 80) {
            grade = 'B';
        } else if (score >= 70) {
            grade = 'C';
        } else if (score >= 60) {
            grade = 'D';
        } else {
            grade = 'F';
        }
        
        System.out.println("The grade is: " + grade);
        
        scanner.close();
    }
}
```

### 3. Loops - Factorial Calculator
**Problem**: Write a program to calculate the factorial of a given number using both for and while loops.
**Solution**:
```java
import java.util.Scanner;

public class FactorialCalculator {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        
        System.out.print("Enter a non-negative integer: ");
        int n = scanner.nextInt();
        
        if (n < 0) {
            System.out.println("Factorial is not defined for negative numbers.");
        } else {
            // Using for loop
            long factorialFor = 1;
            for (int i = 1; i <= n; i++) {
                factorialFor *= i;
            }
            
            // Using while loop
            long factorialWhile = 1;
            int i = 1;
            while (i <= n) {
                factorialWhile *= i;
                i++;
            }
            
            System.out.println("Factorial using for loop: " + factorialFor);
            System.out.println("Factorial using while loop: " + factorialWhile);
        }
        
        scanner.close();
    }
}
```

### 4. Arrays - Find Maximum and Minimum
**Problem**: Write a program that finds the maximum and minimum values in an integer array.
**Solution**:
```java
import java.util.Arrays;

public class ArrayMinMax {
    public static void main(String[] args) {
        int[] numbers = {3, 7, -2, 15, 8, -1, 9, 4, 12, 6};
        
        // Using manual iteration
        int min = numbers[0];
        int max = numbers[0];
        
        for (int i = 1; i < numbers.length; i++) {
            if (numbers[i] < min) {
                min = numbers[i];
            }
            if (numbers[i] > max) {
                max = numbers[i];
            }
        }
        
        System.out.println("Array: " + Arrays.toString(numbers));
        System.out.println("Minimum value: " + min);
        System.out.println("Maximum value: " + max);
        
        // Using built-in methods
        int minBuiltIn = Arrays.stream(numbers).min().getAsInt();
        int maxBuiltIn = Arrays.stream(numbers).max().getAsInt();
        
        System.out.println("Using streams - Min: " + minBuiltIn + ", Max: " + maxBuiltIn);
    }
}
```

### 5. String Manipulation - Palindrome Checker
**Problem**: Write a program to check if a given string is a palindrome.
**Solution**:
```java
import java.util.Scanner;

public class PalindromeChecker {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        
        System.out.print("Enter a string: ");
        String input = scanner.nextLine();
        
        // Remove non-alphanumeric characters and convert to lowercase
        String cleaned = input.replaceAll("[^a-zA-Z0-9]", "").toLowerCase();
        
        // Check if palindrome
        boolean isPalindrome = true;
        int left = 0;
        int right = cleaned.length() - 1;
        
        while (left < right) {
            if (cleaned.charAt(left) != cleaned.charAt(right)) {
                isPalindrome = false;
                break;
            }
            left++;
            right--;
        }
        
        if (isPalindrome) {
            System.out.println("\"" + input + "\" is a palindrome.");
        } else {
            System.out.println("\"" + input + "\" is not a palindrome.");
        }
        
        // Alternative using StringBuilder
        String reversed = new StringBuilder(cleaned).reverse().toString();
        boolean isPalindromeAlt = cleaned.equals(reversed);
        
        System.out.println("Alternative method: " + (isPalindromeAlt ? "Palindrome" : "Not a palindrome"));
        
        scanner.close();
    }
}
```

### 6. Methods - Temperature Converter
**Problem**: Create methods to convert temperature between Celsius and Fahrenheit.
**Solution**:
```java
import java.util.Scanner;

public class TemperatureConverter {
    // Method to convert Celsius to Fahrenheit
    public static double celsiusToFahrenheit(double celsius) {
        return (celsius * 9/5) + 32;
    }
    
    // Method to convert Fahrenheit to Celsius
    public static double fahrenheitToCelsius(double fahrenheit) {
        return (fahrenheit - 32) * 5/9;
    }
    
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        
        System.out.println("Temperature Converter");
        System.out.println("1. Celsius to Fahrenheit");
        System.out.println("2. Fahrenheit to Celsius");
        System.out.print("Choose an option (1 or 2): ");
        
        int choice = scanner.nextInt();
        
        switch (choice) {
            case 1:
                System.out.print("Enter temperature in Celsius: ");
                double celsius = scanner.nextDouble();
                double fahrenheit = celsiusToFahrenheit(celsius);
                System.out.printf("%.2f°C = %.2f°F%n", celsius, fahrenheit);
                break;
            case 2:
                System.out.print("Enter temperature in Fahrenheit: ");
                double fahrenheit = scanner.nextDouble();
                double celsius = fahrenheitToCelsius(fahrenheit);
                System.out.printf("%.2f°F = %.2f°C%n", fahrenheit, celsius);
                break;
            default:
                System.out.println("Invalid choice.");
        }
        
        scanner.close();
    }
}
```

## Intermediate Problems

### 7. Object-Oriented Programming - Bank Account System
**Problem**: Design a simple bank account system with deposit, withdrawal, and balance inquiry features.
**Solution**:
```java
import java.util.ArrayList;
import java.util.List;

class BankAccount {
    private String accountNumber;
    private String accountHolderName;
    private double balance;
    
    public BankAccount(String accountNumber, String accountHolderName, double initialBalance) {
        this.accountNumber = accountNumber;
        this.accountHolderName = accountHolderName;
        if (initialBalance >= 0) {
            this.balance = initialBalance;
        } else {
            this.balance = 0;
            System.out.println("Initial balance cannot be negative. Set to 0.");
        }
    }
    
    public String getAccountNumber() {
        return accountNumber;
    }
    
    public String getAccountHolderName() {
        return accountHolderName;
    }
    
    public double getBalance() {
        return balance;
    }
    
    public void deposit(double amount) {
        if (amount > 0) {
            balance += amount;
            System.out.println("Deposited: $" + amount);
            System.out.println("New balance: $" + balance);
        } else {
            System.out.println("Deposit amount must be positive.");
        }
    }
    
    public boolean withdraw(double amount) {
        if (amount <= 0) {
            System.out.println("Withdrawal amount must be positive.");
            return false;
        }
        if (amount > balance) {
            System.out.println("Insufficient funds.");
            System.out.println("Current balance: $" + balance);
            return false;
        }
        balance -= amount;
        System.out.println("Withdrew: $" + amount);
        System.out.println("New balance: $" + balance);
        return true;
    }
    
    public void displayAccountInfo() {
        System.out.println("=== Account Information ===");
        System.out.println("Account Number: " + accountNumber);
        System.out.println("Account Holder: " + accountHolderName);
        System.out.println("Current Balance: $" + balance);
        System.out.println("==========================");
    }
}

public class BankAccountSystem {
    public static void main(String[] args) {
        // Create accounts
        BankAccount account1 = new BankAccount("ACC001", "John Doe", 1000.0);
        BankAccount account2 = new BankAccount("ACC002", "Jane Smith", 500.0);
        
        // Perform transactions
        account1.displayAccountInfo();
        account1.deposit(200);
        account1.withdraw(150);
        account1.withdraw(1200); // Should fail
        
        System.out.println();
        
        account2.displayAccountInfo();
        account2.deposit(100);
        account2.withdraw(50);
        account2.displayAccountInfo();
    }
}
```

### 8. Inheritance - Shape Hierarchy
**Problem**: Create a shape hierarchy with methods to calculate area and perimeter.
**Solution**:
```java
public abstract class Shape {
    protected String color;
    
    public Shape(String color) {
        this.color = color;
    }
    
    public String getColor() {
        return color;
    }
    
    public void setColor(String color) {
        this.color = color;
    }
    
    public abstract double calculateArea();
    public abstract double calculatePerimeter();
    
    public void displayInfo() {
        System.out.println("Shape with color: " + color);
        System.out.println("Area: " + calculateArea());
        System.out.println("Perimeter: " + calculatePerimeter());
    }
}

class Circle extends Shape {
    private double radius;
    
    public Circle(String color, double radius) {
        super(color);
        this.radius = radius;
    }
    
    @Override
    public double calculateArea() {
        return Math.PI * radius * radius;
    }
    
    @Override
    public double calculatePerimeter() {
        return 2 * Math.PI * radius;
    }
    
    @Override
    public void displayInfo() {
        super.displayInfo();
        System.out.println("Radius: " + radius);
    }
}

class Rectangle extends Shape {
    private double width;
    private double height;
    
    public Rectangle(String color, double width, double height) {
        super(color);
        this.width = width;
        this.height = height;
    }
    
    @Override
    public double calculateArea() {
        return width * height;
    }
    
    @Override
    public double calculatePerimeter() {
        return 2 * (width + height);
    }
    
    @Override
    public void displayInfo() {
        super.displayInfo();
        System.out.println("Width: " + width + ", Height: " + height);
    }
}

class Triangle extends Shape {
    private double base;
    private double height;
    private double sideA;
    private double sideB;
    
    public Triangle(String color, double base, double height, double sideA, double sideB) {
        super(color);
        this.base = base;
        this.height = height;
        this.sideA = sideA;
        this.sideB = sideB;
    }
    
    @Override
    public double calculateArea() {
        return 0.5 * base * height;
    }
    
    @Override
    public double calculatePerimeter() {
        return base + sideA + sideB;
    }
    
    @Override
    public void displayInfo() {
        super.displayInfo();
        System.out.println("Base: " + base + ", Height: " + height);
        System.out.println("Side A: " + sideA + ", Side B: " + sideB);
    }
}

public class ShapeDemo {
    public static void main(String[] args) {
        Shape[] shapes = {
            new Circle("Red", 5.0),
            new Rectangle("Blue", 4.0, 6.0),
            new Triangle("Green", 10.0, 8.0, 7.0, 9.0)
        };
        
        for (Shape shape : shapes) {
            shape.displayInfo();
            System.out.println();
        }
    }
}
```

### 9. Collections - Student Management System
**Problem**: Create a student management system using ArrayList to store and manage student records.
**Solution**:
```java
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

class Student {
    private String studentId;
    private String name;
    private int age;
    private double gpa;
    
    public Student(String studentId, String name, int age, double gpa) {
        this.studentId = studentId;
        this.name = name;
        this.age = age;
        this.gpa = gpa;
    }
    
    public String getStudentId() {
        return studentId;
    }
    
    public String getName() {
        return name;
    }
    
    public int getAge() {
        return age;
    }
    
    public double getGpa() {
        return gpa;
    }
    
    public void setGpa(double gpa) {
        this.gpa = gpa;
    }
    
    @Override
    public String toString() {
        return String.format("ID: %s, Name: %s, Age: %d, GPA: %.2f", 
                             studentId, name, age, gpa);
    }
    
    public boolean isHonorStudent() {
        return gpa >= 3.5;
    }
}

public class StudentManagementSystem {
    private List<Student> students;
    
    public StudentManagementSystem() {
        students = new ArrayList<>();
    }
    
    public void addStudent(Student student) {
        students.add(student);
        System.out.println("Student added: " + student.getName());
    }
    
    public void removeStudent(String studentId) {
        Student studentToRemove = null;
        for (Student student : students) {
            if (student.getStudentId().equals(studentId)) {
                studentToRemove = student;
                break;
            }
        }
        
        if (studentToRemove != null) {
            students.remove(studentToRemove);
            System.out.println("Student removed: " + studentToRemove.getName());
        } else {
            System.out.println("Student not found with ID: " + studentId);
        }
    }
    
    public Student findStudent(String studentId) {
        for (Student student : students) {
            if (student.getStudentId().equals(studentId)) {
                return student;
            }
        }
        return null;
    }
    
    public void displayAllStudents() {
        if (students.isEmpty()) {
            System.out.println("No students in the system.");
            return;
        }
        
        System.out.println("=== Student List ===");
        for (Student student : students) {
            System.out.println(student);
        }
        System.out.println("====================");
    }
    
    public void displayHonorStudents() {
        List<Student> honorStudents = new ArrayList<>();
        for (Student student : students) {
            if (student.isHonorStudent()) {
                honorStudents.add(student);
            }
        }
        
        if (honorStudents.isEmpty()) {
            System.out.println("No honor students found.");
            return;
        }
        
        System.out.println("=== Honor Students (GPA >= 3.5) ===");
        for (Student student : honorStudents) {
            System.out.println(student);
        }
        System.out.println("===================================");
    }
    
    public double calculateAverageGPA() {
        if (students.isEmpty()) {
            return 0.0;
        }
        
        double sum = 0.0;
        for (Student student : students) {
            sum += student.getGpa();
        }
        return sum / students.size();
    }
    
    public static void main(String[] args) {
        StudentManagementSystem sms = new StudentManagementSystem();
        Scanner scanner = new Scanner(System.in);
        
        // Add some sample students
        sms.addStudent(new Student("S001", "Alice Johnson", 20, 3.8));
        sms.addStudent(new Student("S002", "Bob Smith", 19, 3.2));
        sms.addStudent(new Student("S003", "Carol Williams", 21, 3.9));
        sms.addStudent(new Student("S004", "David Brown", 20, 2.8));
        
        boolean running = true;
        while (running) {
            System.out.println("\nStudent Management System");
            System.out.println("1. Add Student");
            System.out.println("2. Remove Student");
            System.out.println("3. Find Student");
            System.out.println("4. Display All Students");
            System.out.println("5. Display Honor Students");
            System.out.println("6. Calculate Average GPA");
            System.out.println("7. Exit");
            System.out.print("Choose an option: ");
            
            int choice = scanner.nextInt();
            scanner.nextLine(); // Consume newline
            
            switch (choice) {
                case 1:
                    System.out.print("Enter student ID: ");
                    String id = scanner.nextLine();
                    System.out.print("Enter name: ");
                    String name = scanner.nextLine();
                    System.out.print("Enter age: ");
                    int age = scanner.nextInt();
                    System.out.print("Enter GPA: ");
                    double gpa = scanner.nextDouble();
                    scanner.nextLine(); // Consume newline
                    
                    sms.addStudent(new Student(id, name, age, gpa));
                    break;
                    
                case 2:
                    System.out.print("Enter student ID to remove: ");
                    String removeId = scanner.nextLine();
                    sms.removeStudent(removeId);
                    break;
                    
                case 3:
                    System.out.print("Enter student ID to find: ");
                    String findId = scanner.nextLine();
                    Student found = sms.findStudent(findId);
                    if (found != null) {
                        System.out.println("Student found: " + found);
                    } else {
                        System.out.println("Student not found with ID: " + findId);
                    }
                    break;
                    
                case 4:
                    sms.displayAllStudents();
                    break;
                    
                case 5:
                    sms.displayHonorStudents();
                    break;
                    
                case 6:
                    double avgGPA = sms.calculateAverageGPA();
                    System.out.printf("Average GPA of all students: %.2f%n", avgGPA);
                    break;
                    
                case 7:
                    running = false;
                    System.out.println("Exiting Student Management System.");
                    break;
                    
                default:
                    System.out.println("Invalid option. Please try again.");
            }
        }
        
        scanner.close();
    }
}
```

### 10. Exception Handling - File Processor
**Problem**: Create a program that reads numbers from a file and calculates their average, handling various exceptions.
**Solution**:
```java
import java.io.*;
import java.util.*;

public class FileProcessor {
    public static void main(String[] args) {
        String filename = "numbers.txt";
        
        try {
            double average = calculateAverageFromFile(filename);
            System.out.printf("The average of numbers in '%s' is: %.2f%n", filename, average);
        } catch (FileNotFoundException e) {
            System.out.println("Error: File '" + filename + "' not found.");
            System.out.println("Please create the file with numbers (one per line) and try again.");
        } catch (IOException e) {
            System.out.println("Error reading file '" + filename + "': " + e.getMessage());
        } catch (NumberFormatException e) {
            System.out.println("Error: File contains non-numeric data.");
            System.out.println("Please ensure the file contains only numbers (one per line).");
        } catch (IllegalArgumentException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
    
    public static double calculateAverageFromFile(String filename) 
            throws FileNotFoundException, IOException, NumberFormatException, IllegalArgumentException {
        File file = new File(filename);
        
        if (!file.exists()) {
            throw new FileNotFoundException("File '" + filename + "' not found");
        }
        
        List<Double> numbers = new ArrayList<>();
        
        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            int lineNumber = 0;
            
            while ((line = reader.readLine()) != null) {
                lineNumber++;
                line = line.trim();
                
                // Skip empty lines
                if (line.isEmpty()) {
                    continue;
                }
                
                // Try to parse the number
                try {
                    double number = Double.parseDouble(line);
                    numbers.add(number);
                } catch (NumberFormatException e) {
                    throw new NumberFormatException(
                        "Invalid number on line " + lineNumber + ": '" + line + "'"
                    );
                }
            }
        }
        
        if (numbers.isEmpty()) {
            throw new IllegalArgumentException("No valid numbers found in the file");
        }
        
        // Calculate average
        double sum = 0.0;
        for (double number : numbers) {
            sum += number;
        }
        
        return sum / numbers.size();
    }
}
```

### 11. Multithreading - Prime Number Finder
**Problem**: Create a multithreaded program to find prime numbers in a given range.
**Solution**:
```java
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.*;

class PrimeFinder implements Runnable {
    private final int start;
    private final int end;
    private final List<Integer> primes;
    private final Object lock;
    
    public PrimeFinder(int start, int end, List<Integer> primes, Object lock) {
        this.start = start;
        this.end = end;
        this.primes = primes;
        this.lock = lock;
    }
    
    @Override
    public void run() {
        List<Integer> localPrimes = new ArrayList<>();
        
        for (int number = start; number <= end; number++) {
            if (isPrime(number)) {
                localPrimes.add(number);
            }
        }
        
        // Synchronized addition to shared list
        synchronized (lock) {
            primes.addAll(localPrimes);
        }
    }
    
    private boolean isPrime(int number) {
        if (number < 2) {
            return false;
        }
        if (number == 2) {
            return true;
        }
        if (number % 2 == 0) {
            return false;
        }
        
        int sqrt = (int) Math.sqrt(number);
        for (int i = 3; i <= sqrt; i += 2) {
            if (number % i == 0) {
                return false;
            }
        }
        return true;
    }
}

public class PrimeNumberFinder {
    public static void main(String[] args) {
        int startRange = 1;
        int endRange = 1000;
        int numThreads = 4;
        
        List<Integer> primes = Collections.synchronizedList(new ArrayList<>());
        Object lock = new Object();
        
        // Calculate range for each thread
        int rangeSize = (endRange - startRange + 1) / numThreads;
        int remainder = (endRange - startRange + 1) % numThreads;
        
        ExecutorService executor = Executors.newFixedThreadPool(numThreads);
        List<Future<?>> futures = new ArrayList<>();
        
        int currentStart = startRange;
        for (int i = 0; i < numThreads; i++) {
            int currentEnd = currentStart + rangeSize - 1;
            if (i < remainder) {
                currentEnd++; // Distribute remainder
            }
            
            PrimeFinder finder = new PrimeFinder(currentStart, currentEnd, primes, lock);
            futures.add(executor.submit(finder));
            
            currentStart = currentEnd + 1;
        }
        
        // Wait for all threads to complete
        for (Future<?> future : futures) {
            try {
                future.get(); // Wait for completion
            } catch (InterruptedException | ExecutionException e) {
                e.printStackTrace();
            }
        }
        
        executor.shutdown();
        
        // Sort and display results
        Collections.sort(primes);
        
        System.out.println("Prime numbers between " + startRange + " and " + endRange + ":");
        System.out.println(primes);
        System.out.println("Total primes found: " + primes.size());
    }
}
```

### 12. Generics - Custom Stack Implementation
**Problem**: Create a generic stack implementation that works with any data type.
**Solution**:
```java
public class Stack<T> {
    private java.util.List<T> elements;
    private int top;
    
    public Stack() {
        elements = new java.util.ArrayList<>();
        top = -1;
    }
    
    public void push(T item) {
        elements.add(item);
        top++;
    }
    
    public T pop() {
        if (isEmpty()) {
            throw new java.util.EmptyStackException();
        }
        T item = elements.get(top);
        elements.remove(top);
        top--;
        return item;
    }
    
    public T peek() {
        if (isEmpty()) {
            throw new java.util.EmptyStackException();
        }
        return elements.get(top);
    }
    
    public boolean isEmpty() {
        return top == -1;
    }
    
    public int size() {
        return top + 1;
    }
    
    @Override
    public String toString() {
        if (isEmpty()) {
            return "Stack[]";
        }
        
        StringBuilder sb = new StringBuilder("Stack[");
        for (int i = 0; i <= top; i++) {
            sb.append(elements.get(i));
            if (i < top) {
                sb.append(", ");
            }
        }
        sb.append("]");
        return sb.toString();
    }
    
    public static void main(String[] args) {
        // Test with Integer
        Stack<Integer> intStack = new Stack<>();
        intStack.push(10);
        intStack.push(20);
        intStack.push(30);
        System.out.println("Integer Stack: " + intStack);
        System.out.println("Popped: " + intStack.pop());
        System.out.println("After pop: " + intStack);
        System.out.println("Peek: " + intStack.peek());
        
        // Test with String
        Stack<String> stringStack = new Stack<>();
        stringStack.push("Hello");
        stringStack.push("World");
        stringStack.push("Java");
        System.out.println("\nString Stack: " + stringStack);
        System.out.println("Popped: " + stringStack.pop());
        System.out.println("After pop: " + stringStack);
        System.out.println("Peek: " + stringStack.peek());
        
        // Test with Double
        Stack<Double> doubleStack = new Stack<>();
        doubleStack.push(1.5);
        doubleStack.push(2.7);
        doubleStack.push(3.14);
        System.out.println("\nDouble Stack: " + doubleStack);
        System.out.println("Popped: " + doubleStack.pop());
        System.out.println("After pop: " + doubleStack);
        System.out.println("Peek: " + doubleStack.peek());
    }
}
```

## Advanced Problems

### 13. Lambda Expressions and Streams - Data Processing
**Problem**: Process a list of employees using lambda expressions and streams to perform various operations.
**Solution**:
```java
import java.util.*;
import java.util.stream.*;

class Employee {
    private String name;
    private String department;
    private double salary;
    private int yearsOfExperience;
    
    public Employee(String name, String department, double salary, int yearsOfExperience) {
        this.name = name;
        this.department = department;
        this.salary = salary;
        this.yearsOfExperience = yearsOfExperience;
    }
    
    public String getName() {
        return name;
    }
    
    public String getDepartment() {
        return department;
    }
    
    public double getSalary() {
        return salary;
    }
    
    public int getYearsOfExperience() {
        return yearsOfExperience;
    }
    
    @Override
    public String toString() {
        return String.format("%s (%s) - Salary: $%,.2f Experience: %d years)", 
                             name, department, salary, yearsOfExperience);
    }
    
    public boolean isSenior() {
        return yearsOfExperience >= 10;
    }
    
    public boolean isHighEarner() {
        return salary > 75000;
    }
}

public class EmployeeDataProcessor {
    public static void main(String[] args) {
        List<Employee> employees = Arrays.asList(
            new Employee("Alice Johnson", "Engineering", 85000, 5),
            new Employee("Bob Smith", "Marketing", 65000, 3),
            new Employee("Carol Williams", "Engineering", 95000, 12),
            new Employee("David Brown", "Sales", 55000, 2),
            new Employee("Eve Davis", "Engineering", 75000, 8),
            new Employee("Frank Miller", "HR", 60000, 15),
            new Employee("Grace Lee", "Engineering", 105000, 15),
            new Employee("Henry Wilson", "Marketing", 70000, 7),
            new Employee("Ivy Anderson", "Finance", 90000, 10),
            new Employee("Jack Taylor", "IT", 65000, 4)
        );
        
        System.out.println("=== All Employees ===");
        employees.forEach(System.out::println);
        
        // 1. Filter: Get employees from Engineering department
        System.out.println("\n=== Engineering Employees ===");
        List<Employee> engineeringEmployees = employees.stream()
                .filter(e -> e.getDepartment().equalsIgnoreCase("Engineering"))
                .collect(Collectors.toList());
        engineeringEmployees.forEach(System.out::println);
        
        // 2. Map: Get employee names
        System.out.println("\n=== Employee Names ===");
        List<String> names = employees.stream()
                .map(Employee::getName)
                .collect(Collectors.toList());
        names.forEach(System.out::println);
        
        // 3. Sorted: Sort by salary (descending)
        System.out.println("\n=== Employees Sorted by Salary (High to Low) ===");
        List<Employee> sortedBySalary = employees.stream()
                .sorted(Comparator.comparingDouble(Employee::getSalary).reversed())
                .collect(Collectors.toList());
        sortedBySalary.forEach(System.out::println);
        
        // 4. Aggregate: Calculate average salary
        System.out.println("\n=== Salary Statistics ===");
        double averageSalary = employees.stream()
                .mapToDouble(Employee::getSalary)
                .average()
                .orElse(0.0);
        System.out.printf("Average Salary: $%,.2f%n", averageSalary);
        
        double maxSalary = employees.stream()
                .mapToDouble(Employee::getSalary)
                .max()
                .orElse(0.0);
        System.out.printf("Maximum Salary: $%,.2f%n", maxSalary);
        
        double minSalary = employees.stream()
                .mapToDouble(Employee::getSalary)
                .min()
                .orElse(0.0);
        System.out.printf("Minimum Salary: $%,.2f%n", minSalary);
        
        // 5. Grouping: Group by department
        System.out.println("\n=== Employees Grouped by Department ===");
        Map<String, List<Employee>> byDepartment = employees.stream()
                .collect(Collectors.groupingBy(Employee::getDepartment));
        byDepartment.forEach((dept, emps) -> {
            System.out.println(dept + ":");
            emps.forEach(e -> System.out.println("  " + e));
        });
        
        // 6. Partitioning: Split into senior and non-senior employees
        System.out.println("\n=== Senior vs Non-Senior Employees ===");
        Map<Boolean, List<Employee>> bySeniority = employees.stream()
                .collect(Collectors.partitioningBy(Employee::isSenior));
        System.out.println("Senior Employees (>=10 years experience):");
        bySeniority.get(true).forEach(e -> System.out.println("  " + e));
        System.out.println("Non-Senior Employees (<10 years experience):");
        bySeniority.get(false).forEach(e -> System.out.println("  " + e));
        
        // 7. Matching: Check if any employee makes over $100k
        System.out.println("\n=== High Earner Check ===");
        boolean anyHighEarner = employees.stream()
                .anyMatch(Employee::isHighEarner);
        System.out.println("Any employee makes over $75,000? " + anyHighEarner);
        
        boolean allEngineersHighEarner = employees.stream()
                .filter(e -> e.getDepartment().equalsIgnoreCase("Engineering"))
                .allMatch(Employee::isHighEarner);
        System.out.println("Are all engineers high earners? " + allEngineersHighEarner);
        
        // 8. Finding: Find the employee with highest salary
        System.out.println("\n=== Finding Extremes ===");
        Optional<Employee> highestPaid = employees.stream()
                .max(Comparator.comparingDouble(Employee::getSalary));
        highestPaid.ifPresent(e -> 
            System.out.println("Highest paid employee: " + e));
        
        Optional<Employee> mostExperienced = employees.stream()
                .max(Comparator.comparingInt(Employee::getYearsOfExperience));
        mostExperienced.ifPresent(e -> 
            System.out.println("Most experienced employee: " + e));
        
        // 9. Reduction: Calculate total salary expense
        System.out.println("\n=== Financial Calculations ===");
        double totalSalary = employees.stream()
                .mapToDouble(Employee::getSalary)
                .sum();
        System.out.printf("Total salary expense: $%,.2f%n", totalSalary);
        
        // 10. Collect to Map: Create map of employee names to salaries
        System.out.println("\n=== Name to Salary Mapping ===");
        Map<String, Double> nameToSalary = employees.stream()
                .collect(Collectors.toMap(
                        Employee::getName,
                        Employee::getSalary
                ));
        nameToSalary.forEach((name, salary) -> 
            System.out.println(name + ": $%,.2f".formatted(salary)));
    }
}
```

### 14. File I/O and Serialization - Contact Manager
**Problem**: Create a contact manager that can save and load contacts to/from a file using serialization.
**Solution**:
```java
import java.io.*;
import java.util.*;

class Contact implements Serializable {
    private static final long serialVersionUID = 1L;
    private String name;
    private String phoneNumber;
    private String email;
    
    public Contact(String name, String phoneNumber, String email) {
        this.name = name;
        this.phoneNumber = phoneNumber;
        this.email = email;
    }
    
    public String getName() {
        return name;
    }
    
    public String getPhoneNumber() {
        return phoneNumber;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    @Override
    public String toString() {
        return String.format("Contact{name='%s', phone='%s', email='%s'}", 
                             name, phoneNumber, email);
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Contact contact = (Contact) o;
        return Objects.equals(name, contact.name) &&
               Objects.equals(phoneNumber, contact.phoneNumber) &&
               Objects.equals(email, contact.email);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(name, phoneNumber, email);
    }
}

public class ContactManager {
    private List<Contact> contacts;
    private static final String FILE_NAME = "contacts.ser";
    
    public ContactManager() {
        contacts = new ArrayList<>();
        loadContacts();
    }
    
    public void addContact(Contact contact) {
        // Check for duplicates
        if (!contacts.contains(contact)) {
            contacts.add(contact);
            System.out.println("Contact added: " + contact.getName());
            saveContacts();
        } else {
            System.out.println("Contact already exists: " + contact.getName());
        }
    }
    
    public void removeContact(String name) {
        Contact contactToRemove = null;
        for (Contact contact : contacts) {
            if (contact.getName().equalsIgnoreCase(name)) {
                contactToRemove = contact;
                break;
            }
        }
        
        if (contactToRemove != null) {
            contacts.remove(contactToRemove);
            System.out.println("Contact removed: " + contactToRemove.getName());
            saveContacts();
        } else {
            System.out.println("Contact not found: " + name);
        }
    }
    
    public Contact findContact(String name) {
        for (Contact contact : contacts) {
            if (contact.getName().equalsIgnoreCase(name)) {
                return contact;
            }
        }
        return null;
    }
    
    public void displayAllContacts() {
        if (contacts.isEmpty()) {
            System.out.println("No contacts in the system.");
            return;
        }
        
        System.out.println("=== Contact List ===");
        for (Contact contact : contacts) {
            System.out.println(contact);
        }
        System.out.println("====================");
    }
    
    public void searchContacts(String keyword) {
        List<Contact> matches = new ArrayList<>();
        String lowerKeyword = keyword.toLowerCase();
        
        for (Contact contact : contacts) {
            if (contact.getName().toLowerCase().contains(lowerKeyword) ||
                contact.getPhoneNumber().contains(lowerKeyword) ||
                contact.getEmail().toLowerCase().contains(lowerKeyword)) {
                matches.add(contact);
            }
        }
        
        if (matches.isEmpty()) {
            System.out.println("No contacts found matching: " + keyword);
            return;
        }
        
        System.out.println("=== Search Results for '" + keyword + "' ===");
        for (Contact contact : matches) {
            System.out.println(contact);
        }
        System.out.println("====================");
    }
    
    private void saveContacts() {
        try (ObjectOutputStream oos = new ObjectOutputStream(
                new FileOutputStream(FILE_NAME))) {
            oos.writeObject(contacts);
            System.out.println("Contacts saved to file: " + FILE_NAME);
        } catch (IOException e) {
            System.out.println("Error saving contacts: " + e.getMessage());
        }
    }
    
    @SuppressWarnings("unchecked")
    private void loadContacts() {
        File file = new File(FILE_NAME);
        if (!file.exists()) {
            System.out.println("No existing contact file found. Starting with empty list.");
            return;
        }
        
        try (ObjectInputStream ois = new ObjectInputStream(
                new FileInputStream(FILE_NAME))) {
            contacts = (List<Contact>) ois.readObject();
            System.out.println("Loaded " + contacts.size() + " contacts from file: " + FILE_NAME);
        } catch (IOException | ClassNotFoundException e) {
            System.out.println("Error loading contacts: " + e.getMessage());
            contacts = new ArrayList<>(); // Start fresh if there's an error
        }
    }
    
    public static void main(String[] args) {
        ContactManager manager = new ContactManager();
        Scanner scanner = new Scanner(System.in);
        
        // Add some sample contacts
        manager.addContact(new Contact("Alice Johnson", "555-1234", "alice@example.com"));
        manager.addContact(new Contact("Bob Smith", "555-5678", "bob@example.com"));
        manager.addContact(new Contact("Carol Williams", "555-9012", "carol@example.com"));
        
        boolean running = true;
        while (running) {
            System.out.println("\nContact Manager");
            System.out.println("1. Add Contact");
            System.out.println("2. Remove Contact");
            System.out.println("3. Find Contact");
            System.out.println("4. Display All Contacts");
            System.out.println("5. Search Contacts");
            System.out.println("6. Exit");
            System.out.print("Choose an option: ");
            
            int choice = scanner.nextInt();
            scanner.nextLine(); // Consume newline
            
            switch (choice) {
                case 1:
                    System.out.print("Enter name: ");
                    String name = scanner.nextLine();
                    System.out.print("Enter phone number: ");
                    String phone = scanner.nextLine();
                    System.out.print("Enter email: ");
                    String email = scanner.nextLine();
                    
                    manager.addContact(new Contact(name, phone, email));
                    break;
                    
                case 2:
                    System.out.print("Enter name of contact to remove: ");
                    String removeName = scanner.nextLine();
                    manager.removeContact(removeName);
                    break;
                    
                case 3:
                    System.out.print("Enter name of contact to find: ");
                    String findName = scanner.nextLine();
                    Contact found = manager.findContact(findName);
                    if (found != null) {
                        System.out.println("Contact found: " + found);
                    } else {
                        System.out.println("Contact not found: " + findName);
                    }
                    break;
                    
                case 4:
                    manager.displayAllContacts();
                    break;
                    
                case 5:
                    System.out.print("Enter search keyword: ");
                    String keyword = scanner.nextLine();
                    manager.searchContacts(keyword);
                    break;
                    
                case 6:
                    running = false;
                    System.out.println("Exiting Contact Manager.");
                    break;
                    
                default:
                    System.out.println("Invalid option. Please try again.");
            }
        }
        
        scanner.close();
    }
}
```

### 15. Regular Expressions - Password Validator
**Problem**: Create a password validator using regular expressions to enforce password policies.
**Solution**:
```java
import java.util.Scanner;
import java.util.regex.*;

public class PasswordValidator {
    private static final Pattern LENGTH_PATTERN = 
            Pattern.compile("^.{8,}$"); // At least 8 characters
    private static final Pattern UPPERCASE_PATTERN = 
            Pattern.compile(".*[A-Z].*"); // At least one uppercase letter
    private static final Pattern LOWERCASE_PATTERN = 
            Pattern.compile(".*[a-z].*"); // At least one lowercase letter
    private static final Pattern DIGIT_PATTERN = 
            Pattern.compile(".*\\d.*"); // At least one digit
    private static final Pattern SPECIAL_CHAR_PATTERN = 
            Pattern.compile(".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?].*"); // At least one special character
    private static final Pattern NO_SPACES_PATTERN = 
            Pattern.compile("^[^\\s]*$"); // No whitespace characters
    
    public static ValidationResult validatePassword(String password) {
        if (password == null) {
            return new ValidationResult(false, "Password cannot be null");
        }
        
        List<String> errors = new ArrayList<>();
        
        if (!LENGTH_PATTERN.matcher(password).matches()) {
            errors.add("Password must be at least 8 characters long");
        }
        
        if (!UPPERCASE_PATTERN.matcher(password).matches()) {
            errors.add("Password must contain at least one uppercase letter (A-Z)");
        }
        
        if (!LOWERCASE_PATTERN.matcher(password).matches()) {
            errors.add("Password must contain at least one lowercase letter (a-z)");
        }
        
        if (!DIGIT_PATTERN.matcher(password).matches()) {
            errors.add("Password must contain at least one digit (0-9)");
        }
        
        if (!SPECIAL_CHAR_PATTERN.matcher(password).matches()) {
            errors.add("Password must contain at least one special character (!@#$%^&*()_+-=[]{}|;':\",.<>/?)");
        }
        
        if (!NO_SPACES_PATTERN.matcher(password).matches()) {
            errors.add("Password must not contain any whitespace characters");
        }
        
        boolean isValid = errors.isEmpty();
        String message = isValid ? "Password is valid" : 
                String.join("; ", errors);
        
        return new ValidationResult(isValid, message);
    }
    
    // Alternative: Single regex pattern
    private static final Pattern SINGLE_PATTERN = Pattern.compile(
            "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)" + // At least one lowercase, uppercase, digit
            "(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?])" + // At least one special char
            "(?=\\S+$)" + // No whitespace
            ".{8,}$" // At least 8 characters
    );
    
    public static ValidationResult validatePasswordSingleRegex(String password) {
        if (password == null) {
            return new ValidationResult(false, "Password cannot be null");
        }
        
        boolean isValid = SINGLE_PATTERN.matcher(password).matches();
        String message = isValid ? 
                "Password is valid" : 
                "Password must be at least 8 characters long and contain at least one uppercase letter, " +
                "one lowercase letter, one digit, one special character, and no whitespace";
        
        return new ValidationResult(isValid, message);
    }
    
    // Simple validation result class
    public static class ValidationResult {
        private final boolean isValid;
        private final String message;
        
        public ValidationResult(boolean isValid, String message) {
            this.isValid = isValid;
            this.message = message;
        }
        
        public boolean isValid() {
            return isValid;
        }
        
        public String getMessage() {
            return message;
        }
    }
    
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        
        System.out.println("Password Validator");
        System.out.println("Requirements:");
        System.out.println("- Minimum 8 characters");
        System.out.println("- At least one uppercase letter");
        System.out.println("- At least one lowercase letter");
        System.out.println("- At least one digit");
        System.out.println("- At least one special character");
        System.out.println("- No whitespace characters");
        System.out.println();
        
        while (true) {
            System.out.print("Enter a password to validate (or 'quit' to exit): ");
            String password = scanner.nextLine();
            
            if (password.equalsIgnoreCase("quit")) {
                break;
            }
            
            // Using multi-pattern approach
            ValidationResult result = validatePassword(password);
            System.out.println("Result: " + result.getMessage());
            System.out.println("Valid: " + result.isValid());
            
            // Using single regex approach
            ValidationResult result2 = validatePasswordSingleRegex(password);
            System.out.println("Single regex result: " + result2.getMessage());
            System.out.println("Valid: " + result2.isValid());
            
            System.out.println();
        }
        
        scanner.close();
    }
    
    // Additional examples of regex usage
    public static void regexExamples() {
        String text = "Contact us at info@example.com or call 1-800-555-1234. Visit www.example.com";
        
        // Email extraction
        Pattern emailPattern = Pattern.compile("[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}");
        Matcher emailMatcher = emailPattern.matcher(text);
        System.out.println("Email addresses found:");
        while (emailMatcher.find()) {
            System.out.println("  " + emailMatcher.group());
        }
        
        // Phone number extraction
        Pattern phonePattern = Pattern.compile("\\b\\d{3}[-.]\\d{3}[-.]\\d{4}\\b");
        Matcher phoneMatcher = phonePattern.matcher(text);
        System.out.println("Phone numbers found:");
        while (phoneMatcher.find()) {
            System.out.println("  " + phoneMatcher.group());
        }
        
        // URL extraction
        Pattern urlPattern = Pattern.compile("https?://[\\w.-]+(?:\\.[\\w.-]+)+(?:[/\\w.-]*)*");
        Matcher urlMatcher = urlPattern.matcher(text);
        System.out.println("URLs found:");
        while (urlMatcher.find()) {
            System.out.println("  " + urlMatcher.group());
        }
        
        // Date extraction (MM/DD/YYYY format)
        String dateText = "Today is 12/25/2023. The event is on 01/15/2024.";
        Pattern datePattern = Pattern.compile("\\b(0[1-9]|1[0-2])/(0[1-9]|[12][0-9]|3[01])/\\d{4}\\b");
        Matcher dateMatcher = datePattern.matcher(dateText);
        System.out.println("Dates found (MM/DD/YYYY):");
        while (dateMatcher.find()) {
            System.out.println("  " + dateMatcher.group());
        }
        
        // HTML tag removal
        String html = "<p>This is <b>bold</b> and <i>italic</i> text.</p>";
        String plainText = html.replaceAll("<[^>]*>", "");
        System.out.println("HTML to plain text: " + plainText);
        
        // Credit card number formatting (separate groups of 4)
        String ccNumber = "1234567890123456";
        String formattedCC = ccNumber.replaceAll("(\\d{4})", "$1-");
        formattedCC = formattedCC.replaceAll("-$", ""); // Remove trailing dash
        System.out.println("Formatted credit card: " + formattedCC);
    }
}
```

## Java Fundamentals Cheat Sheet

[To be continued in the next file due to space constraints]