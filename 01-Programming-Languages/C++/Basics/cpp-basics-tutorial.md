# C++ Basics Tutorial

## Variables and Data Types

```cpp
#include <iostream>
using namespace std;

int main() {
    // Variables
    char grade = 'A';
    int age = 30;
    float height = 5.5;
    double pi = 3.14159;
    bool isActive = true;
    string name = "Alice";
    
    // Auto type inference
    auto score = 95;
    
    cout << "Name: " << name << ", Age: " << age << endl;
    return 0;
}
```

## Data Types

| Type | Size | Description |
|------|------|-------------|
| bool | 1 byte | true/false |
| char | 1 byte | Character |
| int | 4 bytes | Integer |
| float | 4 bytes | Decimal |
| double | 8 bytes | Large decimal |
| string | varies | Text |

## Control Flow

### If-Else
```cpp
if (age >= 18) {
    cout << "Adult" << endl;
} else if (age >= 13) {
    cout << "Teenager" << endl;
} else {
    cout << "Child" << endl;
}
```

### Switch
```cpp
switch (day) {
    case 1:
        cout << "Monday" << endl;
        break;
    case 5:
        cout << "Friday" << endl;
        break;
    default:
        cout << "Other day" << endl;
}
```

### Loops
```cpp
// For loop
for (int i = 0; i < 5; i++) {
    cout << i << endl;
}

// Range-based for (C++11)
vector<int> nums = {1, 2, 3, 4, 5};
for (int n : nums) {
    cout << n << endl;
}

// While loop
int count = 5;
while (count > 0) {
    cout << count << endl;
    count--;
}
```

## Functions

```cpp
// Function with default parameters
int add(int a, int b = 0) {
    return a + b;
}

// Function overloading
double add(double a, double b) {
    return a + b;
}

// Inline function
inline int square(int x) {
    return x * x;
}
```

## Classes and Objects

```cpp
class Person {
private:
    string name;
    int age;
    
public:
    // Constructor
    Person(string n, int a) : name(n), age(a) {}
    
    // Method
    void greet() {
        cout << "Hello, I'm " << name << endl;
    }
    
    // Getter
    string getName() { return name; }
    
    // Setter
    void setName(string n) { name = n; }
};

// Inheritance
class Student : public Person {
private:
    string grade;
    
public:
    Student(string n, int a, string g) : Person(n, a), grade(g) {}
    
    void study() {
        cout << getName() << " is studying" << endl;
    }
};
```

## STL Containers

```cpp
#include <vector>
#include <map>
#include <set>
#include <stack>
#include <queue>

// Vector
vector<int> nums = {1, 2, 3};
nums.push_back(4);
nums.pop_back();

// Map
map<string, int> ages;
ages["Alice"] = 30;

// Set
set<int> unique = {1, 2, 3, 3};  // {1, 2, 3}

// Stack
stack<int> stk;
stk.push(1);
stk.pop();

// Queue
queue<int> q;
q.push(1);
q.pop();
```

## Pointers and References

```cpp
int x = 10;
int *ptr = &x;     // Pointer
int &ref = x;      // Reference

*ptr = 20;         // Modify via pointer
ref = 30;          // Modify via reference
```

## Dynamic Memory

```cpp
// Allocate
int *arr = new int[5];

// Deallocate
delete[] arr;

// Smart pointers (C++11)
unique_ptr<int> up = make_unique<int>(10);
shared_ptr<int> sp = make_shared<int>(20);
```

## Best Practices

1. Use references over pointers when possible
2. Use smart pointers for dynamic memory
3. Use const for constant values
4. Prefer range-based for loops
5. Use auto for complex types
6. Follow RAII principle