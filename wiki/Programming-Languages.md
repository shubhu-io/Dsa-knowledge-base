# Programming Languages

A comprehensive guide to the 15 programming languages covered in this knowledge base,
with guidance on when to use each and how they relate to data structures, algorithms,
and interview preparation.

---

## Overview

The `01-Programming-Languages/` folder contains guides, code examples, and data structure
implementations for 15 languages. Each language folder has the same structure:

```
Language/
├── [language]-introduction.md   # Overview, setup, key features
├── Basics/                      # Syntax, variables, control flow, functions
├── Algorithms/                  # Common algorithm implementations
└── Data-Structures/             # Data structure implementations
```

---

## Languages at a Glance

| Language | Typing | Speed | Paradigm | Primary Use Cases |
|----------|--------|-------|----------|-------------------|
| **C** | Static | Fast | Procedural | OS, embedded, systems |
| **C++** | Static | Fast | Multi-paradigm | Systems, games, competitive programming |
| **Dart** | Static | Medium | Multi-paradigm | Flutter, cross-platform mobile |
| **Go** | Static | Fast | Procedural/concurrent | Microservices, cloud infrastructure |
| **Java** | Static | Medium | OOP | Enterprise, Android, distributed systems |
| **JavaScript** | Dynamic | Slow | Multi-paradigm | Web (frontend + backend), serverless |
| **Kotlin** | Static | Medium | Multi-paradigm | Android, JVM, server-side |
| **PHP** | Dynamic | Medium | Procedural/OOP | Web (WordPress, Laravel) |
| **Python** | Dynamic | Slow | Multi-paradigm | Data science, ML/AI, scripting, web |
| **R** | Dynamic | Slow | Functional | Statistics, data analysis, visualization |
| **Ruby** | Dynamic | Medium | OOP | Web (Rails), scripting |
| **Rust** | Static | Fast | Multi-paradigm | Systems, WebAssembly, CLI tools |
| **Scala** | Static | Medium | Functional/OOP | Big Data (Spark), distributed systems |
| **Swift** | Static | Fast | Multi-paradigm | iOS/macOS development |
| **TypeScript** | Static | Medium | Multi-paradigm | Type-safe JavaScript, large-scale web |

---

## Choosing a Language

### For Data Structures & Algorithms Interviews

| Recommendation | Language | Why |
|----------------|----------|-----|
| **Best overall** | C++ | STL provides ready-made data structures; fastest execution; most competitive programming support |
| **Most popular** | Java | Strong typing, collections framework, widely accepted in interviews |
| **Easiest to learn** | Python | Clean syntax, built-in lists/dicts/sets; fastest to prototype solutions |
| **Systems focus** | C | Manual memory management teaches how things work under the hood |

### For Web Development

| Focus | Language | Framework/Ecosystem |
|-------|----------|-------------------|
| Frontend | JavaScript/TypeScript | React, Vue, Angular |
| Backend (full-stack) | JavaScript/TypeScript | Node.js, Express, NestJS |
| Backend (enterprise) | Java | Spring Boot |
| Backend (rapid prototyping) | Python | Django, Flask |
| Backend (APIs) | Go | Gin, Echo |
| CMS/E-commerce | PHP | WordPress, Laravel |
| Full-stack (batteries included) | Ruby | Rails |

### For Mobile Development

| Platform | Language | Framework |
|----------|----------|-----------|
| Android (native) | Kotlin | Jetpack Compose |
| Android (legacy) | Java | Android SDK |
| iOS (native) | Swift | SwiftUI |
| Cross-platform | Dart | Flutter |
| Cross-platform | Kotlin | KMM (Kotlin Multiplatform) |

### For Data Science & Machine Learning

| Focus | Language | Libraries |
|-------|----------|-----------|
| General ML/AI | Python | scikit-learn, TensorFlow, PyTorch |
| Statistical analysis | R | ggplot2, dplyr, caret |
| Big Data processing | Scala | Apache Spark |
| Data pipelines | Python | pandas, NumPy, Airflow |

### For Systems Programming

| Focus | Language | Why |
|-------|----------|-----|
| OS / embedded | C | Direct hardware access, minimal runtime |
| Performance-critical systems | C++ | Zero-cost abstractions, RAII |
| Memory-safe systems | Rust | Borrow checker prevents data races at compile time |
| Cloud infrastructure | Go | Simple concurrency model, fast compilation |

---

## Language Details

### C

The foundation of modern programming. Direct memory access via pointers, manual
memory management, and minimal runtime overhead.

- **Strengths**: Maximum performance, hardware control, minimal binary size
- **Weaknesses**: No memory safety, manual memory management, no built-in data structures
- **Key Concepts**: Pointers, manual malloc/free, struct, function pointers, preprocessor
- **Used In**: Linux kernel, SQLite, Redis, embedded firmware

### C++

C with classes, templates, and the Standard Template Library (STL). Dominates
competitive programming due to STL's extensive data structure and algorithm support.

- **Strengths**: Zero-cost abstractions, STL, RAII, templates
- **Weaknesses**: Complex syntax, long compile times, steep learning curve
- **Key Concepts**: Templates, RAII, move semantics, STL containers/algorithms
- **Used In**: Game engines (Unreal), browsers (Chrome), databases (MongoDB)

### Dart

Type-safe language designed for client development. Best known as the language
behind Flutter for cross-platform mobile app development.

- **Strengths**: Hot reload, strong typing, good for UI development
- **Weaknesses**: Smaller ecosystem outside Flutter, less community support
- **Key Concepts**: Null safety, mixins, extensions, async/await
- **Used In**: Flutter apps, Google internal tools

### Go

Simple, fast language designed at Google for concurrent server-side programming.
Goroutines and channels make handling thousands of connections straightforward.

- **Strengths**: Fast compilation, built-in concurrency, simple syntax
- **Weaknesses**: No generics (until 1.18), limited abstractions
- **Key Concepts**: Goroutines, channels, interfaces, error handling
- **Used In**: Docker, Kubernetes, Terraform, cloud infrastructure

### Java

The enterprise workhorse. Strongly typed with a massive ecosystem of libraries
and frameworks. Runs on the JVM, making it platform-independent.

- **Strengths**: Mature ecosystem, JVM portability, garbage collected, strong OOP
- **Weaknesses**: Verbose syntax, slower startup time, more memory usage
- **Key Concepts**: Generics, collections framework, concurrency, JVM internals
- **Used In**: Enterprise apps, Android (legacy), Hadoop, Elasticsearch

### JavaScript

The language of the web. Runs in browsers and on servers (Node.js). Dynamic
typing with first-class functions and prototypal inheritance.

- **Strengths**: Ubiquitous, asynchronous, huge ecosystem (npm), full-stack potential
- **Weaknesses**: Dynamic typing pitfalls, callback hell (mitigated by async/await)
- **Key Concepts**: Closures, prototypes, async/await, event loop
- **Used In**: Every website, Node.js servers, React Native, Electron

### Kotlin

Modern JVM language that interoperates fully with Java. Concise syntax with
null safety. Official language for Android development.

- **Strengths**: Null safety, concise, coroutines, Java interop
- **Weaknesses**: Smaller community than Java, slower compilation
- **Key Concepts**: Data classes, sealed classes, coroutines, extension functions
- **Used In**: Android (primary), IntelliJ IDEA, Spring Boot

### PHP

Server-side language that powers ~77% of websites with known server-side languages.
Has matured significantly with PHP 8+ (JIT compilation, named arguments, enums).

- **Strengths**: Huge hosting ecosystem, easy deployment, mature frameworks
- **Weaknesses**: Inconsistent API design (improving), legacy codebase stigma
- **Key Concepts**: Composer, PSR standards, Laravel/Symfony, type declarations
- **Used In**: WordPress, Facebook (legacy), Wikipedia, Laravel apps

### Python

Readable, versatile language dominant in data science, ML/AI, and scripting.
Extensive standard library and third-party packages.

- **Strengths**: Readability, vast ecosystem, rapid prototyping, data science tools
- **Weaknesses**: Slow execution, GIL limits threading, dynamic typing
- **Key Concepts**: List comprehensions, decorators, generators, type hints
- **Used In**: ML/AI (TensorFlow, PyTorch), data science, scripting, Django/Flask

### R

Language built specifically for statistics and data analysis. excels at
data visualization and statistical modeling.

- **Strengths**: Statistical libraries, visualization (ggplot2), CRAN packages
- **Weaknesses**: Slow, niche outside statistics, memory-heavy
- **Key Concepts**: Tidyverse, data frames, formula syntax, RMarkdown
- **Used In**: Academic research, biostatistics, data analysis, reporting

### Ruby

Expressive, object-oriented language famous for the Ruby on Rails framework.
Optimized for developer happiness and rapid web development.

- **Strengths**: Readable, Rails framework, developer ergonomics, metaprogramming
- **Weaknesses**: Slower performance, smaller ecosystem than Python/JS
- **Key Concepts**: Blocks/procs/lambdas, mixins, metaprogramming, convention over configuration
- **Used In**: Rails apps, Shopify, GitHub (legacy), scripting

### Rust

Systems language with compile-time memory safety via the borrow checker.
No garbage collector — memory safety without runtime cost.

- **Strengths**: Memory safety, zero-cost abstractions, fearless concurrency
- **Weaknesses**: Steep learning curve (borrow checker), slower compilation
- **Key Concepts**: Ownership, borrowing, lifetimes, traits, pattern matching
- **Used In**: Firefox (Servo), Android (new components), CLI tools, WebAssembly

### Scala

Hybrid functional/OOP language on the JVM. Primary language for Apache Spark
and big data processing.

- **Strengths**: Functional + OOP, Spark integration, type inference, pattern matching
- **Weaknesses**: Complex syntax, long compile times, steeper learning curve
- **Key Concepts**: Immutability, case classes, pattern matching, implicits/using
- **Used In**: Apache Spark, Kafka, LinkedIn, Twitter (backend)

### Swift

Modern language for Apple ecosystem development. Clean syntax with safety
features and high performance approaching C++.

- **Strengths**: Safe, fast, modern syntax, ARC memory management
- **Weaknesses**: Apple ecosystem lock-in, evolving language
- **Key Concepts**: Optionals, protocols, value types, SwiftUI, ARC
- **Used In**: iOS/macOS/watchOS apps, server-side Swift (Vapor)

### TypeScript

JavaScript with static types. Adds optional type annotations, interfaces,
and compile-time error checking to JavaScript.

- **Strengths**: Type safety, IDE support, gradual adoption, JavaScript compatible
- **Weaknesses**: Compilation step, type complexity, learning curve
- **Key Concepts**: Interfaces, generics, union types, utility types, declaration files
- **Used In**: Angular, large React/Vue projects, Node.js backends

---

## Hello World Comparison

### Python

```python
def greet(name: str) -> str:
    return f"Hello, {name}!"

print(greet("World"))
```

### Java

```java
public class HelloWorld {
    public static String greet(String name) {
        return "Hello, " + name + "!";
    }

    public static void main(String[] args) {
        System.out.println(greet("World"));
    }
}
```

### C

```c
#include <stdio.h>

const char* greet(const char* name) {
    return name;
}

int main() {
    printf("Hello, %s!\n", greet("World"));
    return 0;
}
```

### C++

```cpp
#include <iostream>
#include <string>

std::string greet(const std::string& name) {
    return "Hello, " + name + "!";
}

int main() {
    std::cout << greet("World") << std::endl;
    return 0;
}
```

### JavaScript

```javascript
const greet = (name) => `Hello, ${name}!`;
console.log(greet("World"));
```

### Go

```go
package main

import "fmt"

func greet(name string) string {
    return "Hello, " + name + "!"
}

func main() {
    fmt.Println(greet("World"))
}
```

### Rust

```rust
fn greet(name: &str) -> String {
    format!("Hello, {}!", name)
}

fn main() {
    println!("{}", greet("World"));
}
```

### TypeScript

```typescript
function greet(name: string): string {
    return `Hello, ${name}!`;
}

console.log(greet("World"));
```

---

## Language Selection Decision Tree

```
What are you building?
├── Website / Web App
│   ├── Frontend only → JavaScript/TypeScript
│   ├── Full-stack → JavaScript/TypeScript (Node.js) or Python (Django)
│   └── Enterprise backend → Java (Spring Boot) or Go
├── Mobile App
│   ├── Android only → Kotlin
│   ├── iOS only → Swift
│   └── Cross-platform → Dart (Flutter) or JavaScript (React Native)
├── Data Science / ML
│   ├── General ML → Python
│   ├── Statistical analysis → R
│   └── Big Data (Spark) → Scala
├── Systems / Performance
│   ├── OS / embedded → C
│   ├── Game engine / high-perf → C++
│   └── Memory-safe systems → Rust
├── APIs / Microservices
│   ├── Simple concurrent servers → Go
│   ├── Enterprise → Java
│   └── Rapid prototyping → Python
└── Not sure → Start with Python or JavaScript
```

---

## Resources by Language

### C

- *The C Programming Language* — Kernighan and Ritchie
- CS50 (Harvard's intro to CS)
- Learn-C.org interactive tutorials

### C++

- *C++ Primer* — Lippman, Lajoie, and Moo
- cppreference.com
- Stroustrup's *The C++ Programming Language*

### Dart

- dart.dev official documentation
- Flutter.dev for mobile development
- *Dart in Action*

### Go

- *The Go Programming Language* — Donovan and Kernighan
- Go Tour (tour.golang.org)
- Go by Example (gobyexample.com)

### Java

- *Effective Java* — Joshua Bloch
- Oracle Java Tutorials
- Baeldung.com

### JavaScript

- *Eloquent JavaScript* — Marijn Haverbeke
- MDN Web Docs
- javascript.info

### Kotlin

- kotlinlang.org official docs
- Kotlin Koans (playground exercises)
- *Kotlin in Action*

### PHP

- php.net official documentation
- Laracasts (Laravel-focused)
- PHP: The Right Way

### Python

- *Python Crash Course* — Eric Matthes
- Python.org documentation
- Real Python website

### R

- R for Data Science — Hadley Wickham
- RStudio documentation
- CRAN Task Views

### Ruby

- *Programming Ruby* (The Pickaxe Book)
- Ruby on Rails Guide
- ruby-lang.org

### Rust

- *The Rust Programming Language* (The Book)
- Rustlings exercises
- Rust by Example

### Scala

- *Programming in Scala* — Odersky, Spoon, Venners
- docs.scala-lang.org
- Scala Exercises

### Swift

- *The Swift Programming Language* (Apple's official book)
- Swift Playgrounds
- hackingwithswift.com

### TypeScript

- TypeScript Handbook (official)
- *Programming TypeScript* — Boris Cherny
- type-level-typescript.com

---

## See Also

- [[Data-Structures]] — Implementations across all 15 languages
- [[Algorithms]] — Algorithm code examples in each language
- [[Getting-Started]] — Choose your learning path and language
- [[Time-Complexity]] — Performance characteristics vary by language

---

> Full content: [01-Programming-Languages](../01-Programming-Languages/)
