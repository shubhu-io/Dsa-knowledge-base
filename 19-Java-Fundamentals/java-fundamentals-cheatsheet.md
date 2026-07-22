# Java Fundamentals Cheat Sheet

## Quick Reference

### Variable Declaration
```java
int num = 10;
double pi = 3.14;
String name = "Alice";
boolean flag = true;
char grade = 'A';
```

### Operators
```java
// Arithmetic: + - * / %
// Relational: == != < > <= >=
// Logical: && || !
// Bitwise: & | ^ ~ << >>
// Assignment: = += -= *= /= %=
```

### String Methods
```java
"hello".length()           // 5
"hello".charAt(0)          // 'h'
"hello".substring(1, 3)    // "el"
"hello".indexOf('l')       // 2
"hello".toUpperCase()      // "HELLO"
"hello".toLowerCase()      // "hello"
"hello".equals("hello")    // true
"hello".contains("ell")    // true
"hello".replace('l', 'r')  // "herro"
"hello".split(",")         // ["hello"]
```

### Array Operations
```java
int[] arr = new int[5];        // Declaration
int[] arr = {1, 2, 3, 4, 5};  // Initialization
arr.length                     // 5
Arrays.sort(arr)               // Sort
Arrays.toString(arr)           // String representation
Arrays.copyOf(arr, 10)         // Copy
Arrays.fill(arr, 0)            // Fill
```

### Math Class
```java
Math.abs(-10)          // 10
Math.max(5, 10)        // 10
Math.min(5, 10)        // 5
Math.sqrt(25)          // 5.0
Math.pow(2, 3)         // 8.0
Math.random()          // 0.0 to 1.0
Math.PI                // 3.14159...
Math.E                 // 2.71828...
```

### Collection Classes

#### ArrayList
```java
ArrayList<String> list = new ArrayList<>();
list.add("A");
list.get(0);
list.set(0, "B");
list.remove(0);
list.size();
list.contains("A");
list.isEmpty();
```

#### HashMap
```java
HashMap<String, Integer> map = new HashMap<>();
map.put("key", 1);
map.get("key");
map.containsKey("key");
map.containsValue(1);
map.remove("key");
map.size();
map.keySet();
map.values();
```

#### HashSet
```java
HashSet<String> set = new HashSet<>();
set.add("A");
set.remove("A");
set.contains("A");
set.size();
set.isEmpty();
```

### Sorting

```java
// Arrays
Arrays.sort(arr);
Arrays.sort(arr, Collections.reverseOrder());

// Collections
Collections.sort(list);
Collections.reverse(list);
Collections.shuffle(list);
```

### Conversions

```java
// String to int
int num = Integer.parseInt("123");

// int to String
String str = String.valueOf(123);
String str = Integer.toString(123);

// String to double
double d = Double.parseDouble("3.14");

// int to double
double d = (double) num;
```

### Enums
```java
public enum Day {
    MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY
}

Day day = Day.MONDAY;
switch (day) {
    case MONDAY:
        System.out.println("Start of week");
        break;
}
```

### Lambda Expressions
```java
// Lambda syntax
(parameters) -> expression
(parameters) -> { statements }

// Examples
(x, y) -> x + y
() -> System.out.println("Hello")
x -> x * x
```

### Stream API
```java
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5);

numbers.stream()
       .filter(n -> n % 2 == 0)
       .map(n -> n * 2)
       .collect(Collectors.toList());
```

### try-with-resources
```java
try (BufferedReader br = new BufferedReader(new FileReader("file.txt"))) {
    String line = br.readLine();
} catch (IOException e) {
    e.printStackTrace();
}
```