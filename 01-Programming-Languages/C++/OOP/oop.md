# Object-Oriented Programming in C++

## Overview

C++ provides native, full-featured OOP with classes, inheritance, virtual dispatch, and templates. Unlike C (which simulates OOP via structs and function pointers), C++ offers these as first-class language features with compiler-enforced semantics.

## Classes

A class bundles data (members) and behavior (methods). The constructor initializes the object; the destructor cleans up.

```cpp
class Account {
    std::string owner;
    double balance;
public:
    Account(const std::string &name, double initial)
        : owner(name), balance(initial) {}   /* member initializer list */

    void deposit(double amount)  { balance += amount; }
    bool withdraw(double amount) {
        if (amount > balance) return false;
        balance -= amount;
        return true;
    }

    double get_balance() const { return balance; }

    ~Account() {
        /* destructor — RAII cleanup */
    }
};
```

**Key features:**
- **Constructor**: Called on object creation; can be overloaded
- **Destructor**: Called on object destruction; handles cleanup
- **`const` methods**: Promise not to modify the object
- **Member initializer list**: Preferred over assignment in constructor body

## Inheritance

C++ supports single, multiple, and multilevel inheritance.

```cpp
class Shape {
protected:
    double x, y;
public:
    Shape(double x, double y) : x(x), y(y) {}
    virtual double area() const = 0;     /* pure virtual */
    virtual ~Shape() {}                  /* always virtual dtor */
};

class Circle : public Shape {
    double radius;
public:
    Circle(double x, double y, double r)
        : Shape(x, y), radius(r) {}
    double area() const override { return 3.14159 * radius * radius; }
};

class Rectangle : public Shape {
    double w, h;
public:
    Rectangle(double x, double y, double w, double h)
        : Shape(x, y), w(w), h(h) {}
    double area() const override { return w * h; }
};
```

## Virtual Functions and Polymorphism

Virtual functions enable runtime dispatch — the correct derived method is called through a base pointer or reference.

```cpp
Shape *shapes[] = { new Circle(0, 0, 5), new Rectangle(1, 1, 4, 6) };

for (auto *s : shapes)
    cout << "Area: " << s->area() << endl;  /* dynamic dispatch */

/* Always use virtual destructors with polymorphic base classes */
for (auto *s : shapes) delete s;
```

| Specifier | Meaning |
|-----------|---------|
| `virtual` | Overridable in derived class; enables dynamic dispatch |
| `override` | Compiler checks that base class virtual function exists |
| `final` | Prevents further overriding; prevents further derivation |
| `= 0` | Pure virtual — makes class abstract |

## Templates

Templates are compile-time generics — the compiler generates specialized code for each type used.

```cpp
/* Function template */
template <typename T>
T clamp(T val, T lo, T hi) {
    if (val < lo) return lo;
    if (val > hi) return hi;
    return val;
}

/* Class template */
template <typename T, size_t N>
class Stack {
    T data[N];
    size_t top = 0;
public:
    void push(const T &val) { data[top++] = val; }
    T pop() { return data[--top]; }
    bool empty() const { return top == 0; }
};
```

## RAII (Resource Acquisition Is Initialization)

RAII ties resource lifetime to object scope — the most important C++ idiom.

```cpp
/* Manual resource management (fragile — leaks on exception) */
void bad() {
    int *p = new int(42);
    some_function();  /* if this throws, p leaks */
    delete p;
}

/* RAII — safe, exception-proof */
void good() {
    auto p = std::make_unique<int>(42);
    some_function();  /* exception-safe — unique_ptr cleans up */
}   /* p destroyed here automatically */
```

**RAII in action:**
- `std::unique_ptr` / `std::shared_ptr` — heap memory
- `std::lock_guard` — mutexes
- `std::fstream` — files
- `std::vector`, `std::string` — dynamic arrays

## Multiple Inheritance

```cpp
class Printable {
public:
    virtual void print() const = 0;
    virtual ~Printable() {}
};

class Serializable {
public:
    virtual std::string serialize() const = 0;
    virtual ~Serializable() {}
};

class Document : public Printable, public Serializable {
    std::string content;
public:
    Document(const std::string &c) : content(c) {}
    void print() const override { cout << content << endl; }
    std::string serialize() const override { return "{\"doc\": \"" + content + "\"}"; }
};
```

## Operator Overloading

```cpp
class Vec2 {
public:
    double x, y;
    Vec2(double x, double y) : x(x), y(y) {}

    Vec2 operator+(const Vec2 &other) const {
        return {x + other.x, y + other.y};
    }

    bool operator==(const Vec2 &other) const {
        return x == other.x && y == other.y;
    }

    /* Stream output */
    friend std::ostream &operator<<(std::ostream &os, const Vec2 &v) {
        return os << "(" << v.x << ", " << v.y << ")";
    }
};
```

## Three Laws / Rule of Five

If you define any of these, define all five:

```cpp
class MyString {
    char *data;
    size_t len;
public:
    /* 1. Constructor */
    MyString(const char *s);
    /* 2. Copy constructor */
    MyString(const MyString &other);
    /* 3. Copy assignment */
    MyString &operator=(const MyString &other);
    /* 4. Move constructor */
    MyString(MyString &&other) noexcept;
    /* 5. Move assignment */
    MyString &operator=(MyString &&other) noexcept;
    /* Destructor */
    ~MyString();
};
```

## Common Pitfalls

| Pitfall | Problem | Fix |
|---------|---------|-----|
| Object slicing | Copying derived to base loses derived data | Use pointers/references |
| Missing virtual dtor | Derived resources leak | Always use `virtual` dtor in polymorphic base |
| Diamond problem | Ambiguity in multiple inheritance | Use virtual inheritance |
| Premature optimization | Complex code for no gain | Profile first, optimize second |
| Raw `new`/`delete` | Manual memory management errors | Use smart pointers |

## See Also

- [[cpp-classes]] — Shape hierarchy example
- [[syntax]] — C++ syntax reference
- [[oop-c]] — OOP patterns in C
- [[oop-java]] — OOP in Java
