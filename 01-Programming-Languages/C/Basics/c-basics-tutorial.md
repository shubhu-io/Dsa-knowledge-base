# C Basics Tutorial

## Variables and Data Types

```c
#include <stdio.h>

int main() {
    // Variables
    char grade = 'A';
    int age = 30;
    float height = 5.5;
    double pi = 3.14159;
    
    // Constants
    const int MAX_SIZE = 100;
    
    printf("Age: %d, Height: %.2f\n", age, height);
    return 0;
}
```

## Data Types

| Type | Size | Range |
|------|------|-------|
| char | 1 byte | -128 to 127 |
| short | 2 bytes | -32,768 to 32,767 |
| int | 4 bytes | -2^31 to 2^31-1 |
| long | 8 bytes | -2^63 to 2^63-1 |
| float | 4 bytes | ±3.4e38 |
| double | 8 bytes | ±1.7e308 |

## Control Flow

### If-Else
```c
if (age >= 18) {
    printf("Adult\n");
} else {
    printf("Minor\n");
}
```

### Switch
```c
switch (day) {
    case 1:
        printf("Monday\n");
        break;
    case 5:
        printf("Friday\n");
        break;
    default:
        printf("Other day\n");
}
```

### Loops
```c
// For loop
for (int i = 0; i < 5; i++) {
    printf("%d\n", i);
}

// While loop
int count = 5;
while (count > 0) {
    printf("%d\n", count);
    count--;
}

// Do-while loop
do {
    printf("Runs at least once\n");
} while (0);
```

## Functions

```c
// Function declaration
int add(int a, int b);

// Function definition
int add(int a, int b) {
    return a + b;
}

// Function with pointer
void swap(int *a, int *b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}
```

## Arrays

```c
// Declaration
int numbers[5] = {1, 2, 3, 4, 5};

// Access
printf("%d\n", numbers[0]);  // 1

// Loop
for (int i = 0; i < 5; i++) {
    printf("%d ", numbers[i]);
}

// 2D Array
int matrix[3][3] = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
};
```

## Pointers

```c
int x = 10;
int *ptr = &x;  // Pointer to x

printf("Value: %d\n", *ptr);    // Dereference
printf("Address: %p\n", (void*)ptr);  // Address

// Pointer arithmetic
int arr[] = {10, 20, 30};
int *p = arr;
printf("%d\n", *(p + 1));  // 20
```

## Strings

```c
// Character array
char name[] = "Alice";

// String functions
#include <string.h>
strlen(name);           // Length
strcpy(dest, src);      // Copy
strcat(dest, src);      // Concatenate
strcmp(s1, s2);         // Compare
```

## Memory Management

```c
#include <stdlib.h>

// Allocate memory
int *arr = (int*)malloc(5 * sizeof(int));

// Reallocate
arr = (int*)realloc(arr, 10 * sizeof(int));

// Free memory
free(arr);
```

## Best Practices

1. Always initialize variables
2. Check malloc return value
3. Free allocated memory
4. Use const for constants
5. Avoid buffer overflows
6. Use meaningful variable names