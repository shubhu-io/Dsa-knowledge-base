# Object-Oriented Programming in C

## Overview

C has no native support for classes, inheritance, or polymorphism. However, C's struct and function pointer mechanisms can simulate all four pillars of OOP: encapsulation, inheritance, polymorphism, and abstraction.

This approach is used extensively in production code — the Linux kernel, SQLite, GLib, and many C libraries use these patterns.

## Encapsulation

Encapsulation is achieved by hiding data inside a struct and exposing only public functions that operate on it.

```c
/* Private data hidden in .c file (opaque pointer pattern) */
/* circle.h */
typedef struct Circle Circle;

Circle *circle_create(double radius);
void circle_destroy(Circle *c);
double circle_area(Circle *c);
void circle_print(Circle *c);

/* circle.c */
struct Circle {
    double radius;   /* "private" — caller cannot access directly */
};

Circle *circle_create(double radius) {
    Circle *c = malloc(sizeof(Circle));
    c->radius = radius;
    return c;
}

void circle_destroy(Circle *c) {
    free(c);
}

double circle_area(Circle *c) {
    return 3.14159 * c->radius * c->radius;
}
```

The caller only sees the `Circle*` pointer (an opaque handle) and cannot directly read or modify `radius`.

## Inheritance via Struct Embedding

C supports "inheritance" by embedding one struct inside another as its first member.

```c
typedef struct {
    double x, y;
} Shape;

typedef struct {
    Shape base;       /* "inherits" from Shape — must be first member */
    double radius;
} Circle;

typedef struct {
    Shape base;       /* "inherits" from Shape */
    double width, height;
} Rectangle;

Circle *c = malloc(sizeof(Circle));
c->base.x = 0;
c->base.y = 0;
c->radius = 5.0;

/* Safely cast Circle* to Shape* (works because base is first member) */
Shape *s = (Shape *)c;
printf("Position: (%f, %f)\n", s->x, s->y);
```

The key rule: **the "parent" struct must be the first member** so that a pointer to the child can be safely cast to a pointer to the parent.

## Polymorphism via Function Pointers

A "virtual method table" (vtable) is an array of function pointers stored in the base struct.

```c
/* Base struct with vtable pointer */
typedef struct ShapeVtable {
    double (*area)(void *self);
    void   (*print)(void *self);
    void   (*destroy)(void *self);
} ShapeVtable;

typedef struct Shape {
    ShapeVtable *vtable;  /* pointer to shared method table */
    double x, y;
} Shape;

/* Each derived type provides its own vtable implementation */
static double circle_area(void *self) {
    Circle *c = (Circle *)self;
    return 3.14159 * c->radius * c->radius;
}

static void circle_print(void *self) {
    Circle *c = (Circle *)self;
    printf("Circle(r=%f)\n", c->radius);
}

static ShapeVtable circle_vtable = {
    .area   = circle_area,
    .print  = circle_print,
    .destroy = free
};

Circle *circle_create(double radius) {
    Circle *c = malloc(sizeof(Circle));
    c->base.vtable = &circle_vtable;
    c->base.x = 0;
    c->base.y = 0;
    c->radius = radius;
    return c;
}
```

Now you can treat all shapes polymorphically:

```c
Shape *shapes[] = {
    (Shape *)circle_create(5.0),
    (Shape *)rect_create(3.0, 4.0)
};

for (int i = 0; i < 2; i++) {
    shapes[i]->vtable->print(shapes[i]);    /* dynamic dispatch */
    printf("  area = %f\n", shapes[i]->vtable->area(shapes[i]));
    shapes[i]->vtable->destroy(shapes[i]);
}
```

## Abstraction

C achieves abstraction through opaque pointers and header/implementation separation:

- **Header (.h)**: declares the public interface (typedefs, function prototypes)
- **Implementation (.c)**: defines the private struct layout and internal logic

The consumer of a C module never sees the internal struct fields — only the opaque `typedef struct Foo Foo;` declaration.

## Comparison with Native OOP

| Concept | C++/Java | C Equivalent |
|---------|----------|--------------|
| Class | `class Foo {}` | `struct Foo {}` + functions |
| Method | `Foo::bar()` | `foo_bar(Foo *self)` |
| Virtual method | `virtual void bar()` | Function pointer in vtable |
| Inheritance | `class B : public A` | Struct embedding (first member) |
| Interface | `interface IFoo` | Pure vtable struct (no data members) |
| Constructor | `Foo()` | `foo_create()` (returns pointer) |
| Destructor | `~Foo()` | `foo_destroy()` (calls `free`) |
| Private | `private int x;` | Opaque pointer or `_` prefix convention |

## Common C Libraries Using This Pattern

- **Linux kernel**: `struct file_operations` — vtable for file I/O
- **SQLite**: `sqlite3_vtab` — virtual table interface
- **GLib**: `GObject` — full OOP system in C
- **APR**: Apache Portable Runtime — cross-platform abstractions

## See Also

- [[oop]] — OOP concepts
- [[classes]] — Shape hierarchy example in C
- [[cpp-oop]] — native OOP in C++
