# C Syntax Reference

## Variables and Data Types

C is statically typed — every variable must have its type declared at compile time.

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    /* Integer types */
    char c = 'A';              /* 1 byte  */
    short s = 1000;            /* 2 bytes */
    int i = 42;                /* 4 bytes */
    long l = 100000L;          /* 4-8 bytes */
    long long ll = 1000000LL;  /* 8 bytes */

    /* Floating point */
    float f = 3.14f;           /* 4 bytes */
    double d = 3.14159265;     /* 8 bytes */

    /* Unsigned variants */
    unsigned int ui = 42u;

    /* Constants */
    const int MAX = 100;
    #define PI 3.14159

    printf("int size: %zu bytes\n", sizeof(int));
    printf("double: %.6f\n", d);
    return 0;
}
```

## Pointers

Pointers are C's most distinctive feature — they store memory addresses and enable direct memory manipulation.

```c
int x = 42;
int *p = &x;        /* p holds address of x */
printf("%d\n", *p);  /* dereference: prints 42 */

/* Pointer arithmetic */
int arr[] = {10, 20, 30};
int *ptr = arr;      /* points to arr[0] */
printf("%d\n", *(ptr + 1));  /* prints 20 */

/* Dynamic memory allocation */
int *heap = (int *)malloc(5 * sizeof(int));
if (heap == NULL) {
    fprintf(stderr, "malloc failed\n");
    return 1;
}
free(heap);
```

## Arrays

```c
/* Declaration and initialization */
int nums[5] = {1, 2, 3, 4, 5};
int zeros[10] = {0};          /* all zeros */
int flexible[] = {1, 2, 3};   /* compiler infers size */

/* Multidimensional arrays */
int matrix[3][3] = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
};

/* Arrays decay to pointers when passed to functions */
void print_array(int *arr, int len) {
    for (int i = 0; i < len; i++)
        printf("%d ", arr[i]);
    printf("\n");
}
```

## Strings

C has no native string type — strings are null-terminated character arrays.

```c
char greeting[] = "Hello";          /* includes '\0' terminator */
char name[50] = "Alice";           /* modifiable buffer */
const char *literal = "read only";  /* string literal */

/* String operations require <string.h> */
printf("Length: %zu\n", strlen(greeting));

char dest[20];
strcpy(dest, greeting);
strcat(dest, " World");
printf("%s\n", dest);              /* "Hello World" */

int cmp = strcmp("abc", "abd");    /* negative */
```

## Structs and Unions

```c
/* Struct: sequential memory layout */
struct Point {
    double x;
    double y;
};

struct Point p1 = {3.0, 4.0};
printf("(%f, %f)\n", p1.x, p1.y);

/* Typedef for cleaner syntax */
typedef struct {
    char name[50];
    int age;
} Person;

Person alice = {"Alice", 30};

/* Union: all members share the same memory */
union Data {
    int i;
    float f;
    char str[20];
};

union Data d;
d.i = 42;    /* d.f and d.str are now invalid */
printf("%d\n", d.i);
```

## Enums

```c
enum Color { RED, GREEN, BLUE };  /* values: 0, 1, 2 */
enum Color c = GREEN;
printf("%d\n", c);  /* 1 */

enum Weekday { MON=1, TUE, WED, THU, FRI, SAT, SUN };
```

## Control Flow

```c
/* If/else if/else */
if (score >= 90) {
    grade = 'A';
} else if (score >= 80) {
    grade = 'B';
} else {
    grade = 'F';
}

/* Switch */
switch (choice) {
    case 1: printf("One\n"); break;
    case 2: printf("Two\n"); break;
    default: printf("Other\n"); break;
}

/* For loop */
for (int i = 0; i < 10; i++) {
    printf("%d ", i);
}

/* While loop */
while (running) {
    process_input();
}

/* Do-while: executes at least once */
do {
    scanf("%d", &input);
} while (input != 0);
```

## Functions

```c
/* Function declaration (prototype) */
int add(int a, int b);

/* Function definition */
int add(int a, int b) {
    return a + b;
}

/* Pass by reference using pointers */
void swap(int *a, int *b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

/* Variadic functions */
double average(int count, ...) {
    va_list args;
    va_start(args, count);
    double sum = 0;
    for (int i = 0; i < count; i++)
        sum += va_arg(args, double);
    va_end(args);
    return sum / count;
}
```

## Function Pointers

Function pointers enable runtime dispatch, callbacks, and simulated polymorphism.

```c
/* Declare a function pointer */
int (*operation)(int, int);

/* Assign and call */
int add(int a, int b) { return a + b; }
int mul(int a, int b) { return a * b; }

operation = add;
printf("%d\n", operation(2, 3));  /* 5 */

operation = mul;
printf("%d\n", operation(2, 3));  /* 6 */

/* Array of function pointers */
int (*operations[])(int, int) = { add, mul };
```

## Preprocessor

```c
/* Macros */
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define SQUARE(x) ((x) * (x))

/* Conditional compilation */
#ifdef DEBUG
    printf("Debug mode\n");
#endif

/* Include guards */
#ifndef MYHEADER_H
#define MYHEADER_H
/* header contents */
#endif

/* Stringification and token pasting */
#define STR(x) #x
#define PASTE(a, b) a ## b
```

## Memory Management

```c
#include <stdlib.h>

/* Allocate memory for n ints on the heap */
int *arr = (int *)malloc(n * sizeof(int));
if (arr == NULL) {
    /* handle allocation failure */
}

/* Allocate zero-initialized memory */
int *zeros = (int *)calloc(n, sizeof(int));

/* Reallocate to a new size */
arr = (int *)realloc(arr, new_size * sizeof(int));

/* Free heap memory when done */
free(arr);
free(zeros);

/* Stack vs Heap:
 * - Stack: automatic, fast, limited (usually 1-8 MB)
 * - Heap: manual, slower, large (limited by RAM)
 * - Always free heap memory to avoid leaks
 */
```

## Common Pitfalls

| Pitfall | Problem | Fix |
|---------|---------|-----|
| Uninitialized variables | Undefined behavior | Always initialize |
| Dangling pointers | Use-after-free | Set pointer to `NULL` after `free` |
| Buffer overflow | Security vulnerability | Bounds-check all array access |
| Memory leaks | Exhausted memory | Match every `malloc` with `free` |
| Null pointer deref | Segfault | Check before dereferencing |

## See Also

- [[c-basics-tutorial]]
- [[c-introduction]]
- [[string_algorithms]]
