# C++ Syntax Reference

## References vs Pointers

C++ references are aliases for existing objects — they must be initialized and cannot be reseated.

```cpp
#include <iostream>
#include <string>
using namespace std;

void demo() {
    int x = 42;
    int &ref = x;   /* reference: must bind at declaration */
    ref = 100;      /* modifies x */
    cout << x << endl;  /* 100 */

    int *ptr = &x;  /* pointer: can be null, reseated */
    *ptr = 200;
    cout << x << endl;  /* 200 */

    /* const references bind to temporaries (common in function params) */
    const string &greeting = string("Hello");
}
```

## RAII (Resource Acquisition Is Initialization)

RAII ties resource lifetime to object scope — the destructor runs when the object goes out of scope.

```cpp
{
    std::ifstream file("data.txt");  /* resource acquired in constructor */
    std::string line;
    std::getline(file, line);
}   /* file destructor closes the file automatically */

/* Smart pointers — RAII for heap memory */
#include <memory>

{
    auto uptr = std::make_unique<int>(42);       /* unique ownership */
    auto sptr = std::make_shared<std::string>("hello");  /* shared ownership */
}   /* memory freed automatically — no manual delete */
```

## Templates

Templates enable compile-time generic programming.

```cpp
/* Function template */
template <typename T>
T max_of(T a, T b) {
    return (a > b) ? a : b;
}

cout << max_of(3, 7) << endl;        /* 7 — deduced as int */
cout << max_of(3.14, 2.71) << endl;  /* 3.14 — deduced as double */

/* Class template */
template <typename T, size_t N>
class FixedArray {
    T data[N];
    size_t len = 0;
public:
    void push(const T &val) { data[len++] = val; }
    T &operator[](size_t i) { return data[i]; }
    size_t size() const { return len; }
};
```

## STL Containers

```cpp
#include <vector>
#include <map>
#include <unordered_map>
#include <set>
#include <stack>
#include <queue>
#include <deque>

/* Sequence containers */
vector<int> v = {5, 3, 1, 4};
v.push_back(2);
sort(v.begin(), v.end());

/* Associative containers */
map<string, int> ages;
ages["Alice"] = 30;
ages["Bob"] = 25;

unordered_map<string, double> scores;  /* hash map — O(1) avg lookup */

/* Adapters */
stack<int> s;
s.push(10);
s.push(20);
int top = s.top();  /* 20 */

queue<string> q;
q.push("first");
q.push("second");
```

## Smart Pointers

```cpp
#include <memory>

/* unique_ptr: sole ownership, zero overhead */
auto u = std::make_unique<std::vector<int>>();
u->push_back(42);

/* shared_ptr: reference-counted shared ownership */
auto s1 = std::make_shared<std::string>("hello");
auto s2 = s1;  /* reference count = 2 */
/* freed when last shared_ptr is destroyed */

/* weak_ptr: non-owning observer, breaks cycles */
std::weak_ptr<std::string> wp = s1;
if (auto locked = wp.lock()) {
    cout << *locked << endl;
}
```

## Move Semantics

Move transfers resources from one object to another without copying.

```cpp
class Buffer {
    int *data;
    size_t len;
public:
    /* Move constructor */
    Buffer(Buffer &&other) noexcept
        : data(other.data), len(other.len) {
        other.data = nullptr;
        other.len = 0;
    }

    /* Move assignment */
    Buffer &operator=(Buffer &&other) noexcept {
        delete[] data;
        data = other.data;
        len = other.len;
        other.data = nullptr;
        other.len = 0;
        return *this;
    }

    ~Buffer() { delete[] data; }
};

Buffer create_buffer() {
    Buffer b(1024);
    return b;  /* moved, not copied (NRVO or move) */
}
```

## Lambda Expressions

```cpp
/* Basic lambda */
auto greet = [](const string &name) {
    return "Hello, " + name + "!";
};

/* Capturing variables */
int factor = 3;
auto multiply = [factor](int x) { return x * factor; };

/* Mutable lambda (can modify captured copies) */
int count = 0;
auto increment = [count]() mutable { return ++count; };

/* Generic lambda (C++14) */
auto add = [](auto a, auto b) { return a + b; };

/* std::function for type-erased callables */
std::function<int(int)> factorial = [&](int n) -> int {
    return (n <= 1) ? 1 : n * factorial(n - 1);
};
```

## Ranged For and Iterators

```cpp
vector<int> nums = {1, 2, 3, 4, 5};

/* Range-based for */
for (const auto &n : nums)
    cout << n << " ";

/* Iterator-based for */
for (auto it = nums.begin(); it != nums.end(); ++it)
    cout << *it << " ";

/* Algorithms with lambdas */
auto it = find_if(nums.begin(), nums.end(),
    [](int n) { return n > 3; });
```

## Other Essentials

```cpp
/* auto type deduction */
auto x = 42;           /* int */
auto pi = 3.14;        /* double */
auto name = string("C++");

/* nullptr */
int *p = nullptr;

/* Enum class (scoped enum) */
enum class Color { Red, Green, Blue };
Color c = Color::Red;

/* Structured bindings (C++17) */
auto [key, value] = *ages.begin();

/* constexpr — compile-time evaluation */
constexpr int factorial(int n) {
    return (n <= 1) ? 1 : n * factorial(n - 1);
}
static_assert(factorial(5) == 120, "compile-time check");
```

## Common Pitfalls

| Pitfall | Problem | Fix |
|---------|---------|-----|
| Slicing | Copying derived to base loses derived data | Use pointers or references |
| Dangling reference | Reference to destroyed object | Check lifetime, use `shared_ptr` |
| Exception unsafe | Resource leak on throw | Use RAII (smart ptrs, containers) |
| ODR violation | Same function defined in multiple TUs | Mark `inline` or use anonymous namespaces |
| Implicit conversions | Surprising behavior | Use `explicit` on constructors |

## See Also

- [[cpp-basics-tutorial]]
- [[cpp-introduction]]
- [[string_algorithms]]
