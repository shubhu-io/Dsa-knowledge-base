# R Object-Oriented Programming

## Overview

R has multiple OOP systems, each designed for different use cases. Unlike most languages, R doesn't have a single dominant OOP paradigm. The three main systems are **S3** (informal, most common), **S4** (formal, used in Bioconductor), and **R6** (reference-based, similar to Python/Java). Understanding when to use each is key to effective R programming.

## S3 Classes (Informal OOP)

```r
# S3 is the simplest and most common OOP system in R
# Classes are just attributes set on objects

# Constructor
Person <- function(name, age) {
  structure(
    list(name = name, age = age),
    class = "Person"
  )
}

# Methods are regular functions named Class.method
print.Person <- function(x, ...) {
  cat(x$name, "is", x$age, "years old\n")
}

greet <- function(obj) UseMethod("greet")
greet.Person <- function(obj) {
  paste("Hello, I'm", obj$name)
}

# Create and use
p <- Person("Alice", 30)
print(p)     # "Alice is 30 years old"
greet(p)     # "Hello, I'm Alice"
class(p)     # "Person"
inherits(p, "Person")  # TRUE

# S3 inheritance
Student <- function(name, age, grade) {
  person <- Person(name, age)
  person$grade <- grade
  class(person) <- c("Student", "Person")
  person
}

print.Student <- function(x, ...) {
  cat(x$name, "is", x$age, "years old, grade:", x$grade, "\n")
}

s <- Student("Bob", 20, "A")
print(s)     # "Bob is 20 years old, grade: A"
greet(s)     # "Hello, I'm Bob" (inherits from Person)
```

## S4 Classes (Formal OOP)

```r
# S4 provides formal class definitions with validation
# Used extensively in Bioconductor packages

setClass("Person",
  representation(
    name = "character",
    age = "numeric"
  ),
  prototype(
    name = "",
    age = 0
  ),
  validity = function(object) {
    if (object@age < 0) stop("Age cannot be negative")
    if (nchar(object@name) == 0) stop("Name cannot be empty")
    TRUE
  }
)

# Constructor function
setMethod("initialize", "Person", function(.Object, name, age) {
  .Object@name <- name
  .Object@age <- age
  .Object
})

# Methods
setMethod("show", "Person", function(object) {
  cat(object@name, "is", object@age, "years old\n")
})

setGeneric("greet", function(object) standardGeneric("greet"))
setMethod("greet", "Person", function(object) {
  paste("Hello, I'm", object@name)
})

# Create and use
p <- new("Person", name = "Alice", age = 30)
show(p)     # "Alice is 30 years old"
greet(p)    # "Hello, I'm Alice"

# S4 inheritance
setClass("Student",
  contains = "Person",
  representation(grade = "character")
)

s <- new("Student", name = "Bob", age = 20, grade = "A")
show(s)     # "Bob is 20 years old"
is(s, "Person")  # TRUE
```

## R6 Classes (Reference-Based)

```r
# R6 provides reference-based OOP similar to Python/Java
# Created by Winston Chang, now part of base R

library(R6)

Person <- R6Class("Person",
  # Public members
  public = list(
    name = NULL,
    age = NULL,

    initialize = function(name, age) {
      self$name <- name
      self$age <- age
      private$log_creation()
    },

    greet = function() {
      paste("Hello, I'm", self$name)
    },

    describe = function() {
      paste(self$name, "is", self$age, "years old")
    },

    # Reference semantics: modifies in place
    set_age = function(new_age) {
      if (new_age < 0) stop("Age cannot be negative")
      self$age <- new_age
      invisible(self)  # Enable chaining
    }
  ),

  # Private members
  private = list(
    created_at = NULL,

    log_creation = function() {
      private$created_at <- Sys.time()
    }
  ),

  # Active bindings (like properties)
  active = list(
    info = function() {
      paste(self$name, "(", self$age, ")")
    }
  )
)

# Create and use
p <- Person$new("Alice", 30)
p$greet()        # "Hello, I'm Alice"
p$set_age(31)    # Reference semantics — modifies in place
p$info           # "Alice ( 31 )"

# R6 inheritance
Student <- R6Class("Student",
  inherit = Person,
  public = list(
    grade = NULL,

    initialize = function(name, age, grade) {
      super$initialize(name, age)
      self$grade <- grade
    },

    describe = function() {
      paste(super$describe(), "grade:", self$grade)
    }
  )
)

s <- Student$new("Bob", 20, "A")
s$describe()  # "Bob is 20 years old grade: A"
```

## S3 vs S4 vs R6 Comparison

| Feature | S3 | S4 | R6 |
|---------|----|----|-----|
| Formality | Informal | Formal | Formal |
| Validation | No | Yes (validity method) | Optional |
| Reference semantics | No (copy on modify) | No | Yes |
| Encapsulation | No | Partial | Yes (private/public) |
| Performance | Fastest | Slowest | Moderate |
| Complexity | Simple | Complex | Moderate |
| When to use | Quick prototyping, most R code | Bioconductor, formal APIs | Shiny, OOP-heavy code |
| Inheritance | Attribute-based | `contains` keyword | `inherit` keyword |
| Method dispatch | Generic | Generic | Direct |

## When to Use Each

```r
# S3: Default choice for most R code
# - Quick prototypes
# - Simple class hierarchies
# - Packages that need to be lightweight
# - When you want R's standard print/format behavior

# S4: Use when you need
# - Formal validation
# - Multiple inheritance
# - Method signatures with types
# - Bioconductor packages (require S4)
# - Complex class hierarchies

# R6: Use when you need
# - Reference semantics (in-place modification)
# - Private/public members
# - Shiny reactive values
# - When coming from Python/Java background
# - Stateful objects
```

## Demo

```r
# S3 Shape hierarchy
Shape <- function(name) {
  structure(list(name = name), class = "Shape")
}

Circle <- function(radius) {
  shape <- Shape("Circle")
  shape$radius <- radius
  class(shape) <- c("Circle", "Shape")
  shape
}

Rectangle <- function(width, height) {
  shape <- Shape("Rectangle")
  shape$width <- width
  shape$height <- height
  class(shape) <- c("Rectangle", "Shape")
  shape
}

area <- function(shape) UseMethod("area")
area.Circle <- function(shape) pi * shape$radius^2
area.Rectangle <- function(shape) shape$width * shape$height

perimeter <- function(shape) UseMethod("perimeter")
perimeter.Circle <- function(shape) 2 * pi * shape$radius
perimeter.Rectangle <- function(shape) 2 * (shape$width + shape$height)

# R6 Shape hierarchy
library(R6)

R6Shape <- R6Class("R6Shape",
  public = list(
    name = NULL,
    initialize = function(name) { self$name <- name },
    area = function() stop("Not implemented"),
    describe = function() {
      paste(self$name, "area:", round(self$area(), 2))
    }
  )
)

R6Circle <- R6Class("R6Circle",
  inherit = R6Shape,
  public = list(
    radius = NULL,
    initialize = function(radius) {
      super$initialize("Circle")
      self$radius <- radius
    },
    area = function() pi * self$radius^2
  )
)

# Usage
shapes_s3 <- list(Circle(5), Rectangle(4, 6))
for (s in shapes_s3) {
  cat(class(s)[1], ": area =", round(area(s), 2), "\n")
}

shapes_r6 <- list(R6Circle$new(5))
for (s in shapes_r6) {
  cat(s$describe(), "\n")
}
```

## See Also

- [[R/README|R Overview]]
- [[R/Basics/syntax|R Syntax]]
- [[R/OOP/classes|R Classes (code)]]
