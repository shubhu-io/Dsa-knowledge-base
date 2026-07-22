# C Introduction

## Why Learn C?
C is a foundational programming language that provides low-level access to memory. It's the basis for many modern languages and is essential for systems programming.

## Key Features
- **Low-level Memory Access**: Direct memory manipulation
- **Fast Execution**: Compiled language with minimal runtime
- **Portability**: Runs on virtually any platform
- **Foundation**: Basis for C++, Java, C#, and more
- **System Programming**: OS kernels, drivers, embedded systems

## Getting Started

### Installation
1. Install GCC compiler
2. Or use online IDE (Replit, OnlineGDB)

### First Program
```c
#include <stdio.h>

int main() {
    printf("Hello, World!\n");
    return 0;
}
```

Save as `hello.c` and compile with `gcc hello.c -o hello`

## Basic Syntax

### Variables
```c
int age = 30;
float height = 5.5;
char grade = 'A';
```

### Input/Output
```c
printf("Enter age: ");
scanf("%d", &age);
```

### Control Flow
```c
if (age >= 18) {
    printf("Adult\n");
}

for (int i = 0; i < 5; i++) {
    printf("%d\n", i);
}
```

## Best Practices

1. Always initialize variables
2. Check return values
3. Free allocated memory
4. Use meaningful names
5. Comment your code