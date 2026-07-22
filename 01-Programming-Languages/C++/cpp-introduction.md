# C++ Introduction

## Why Learn C++?
C++ is a powerful, high-performance language used in system software, game development, and competitive programming.

## Key Features
- **Object-Oriented**: Classes, inheritance, polymorphism
- **STL**: Standard Template Library with containers and algorithms
- **Memory Management**: Manual and automatic
- **High Performance**: Used in performance-critical applications
- **Competitive Programming**: Fast I/O and STL

## Getting Started

### Installation
1. Install GCC/G++ compiler
2. Or use Visual Studio, CLion

### First Program
```cpp
#include <iostream>
using namespace std;

int main() {
    cout << "Hello, World!" << endl;
    return 0;
}
```

## Basic Syntax

### Variables
```cpp
int age = 30;
double pi = 3.14159;
string name = "Alice";
bool isActive = true;
```

### Control Flow
```cpp
if (age >= 18) {
    cout << "Adult" << endl;
}

for (int i = 0; i < 5; i++) {
    cout << i << endl;
}
```

## Best Practices

1. Use references over pointers
2. Use smart pointers
3. Use STL containers
4. Follow RAII principle
5. Use const for constants