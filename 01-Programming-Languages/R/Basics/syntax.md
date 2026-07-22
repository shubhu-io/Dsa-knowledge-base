# R Syntax

## Overview

R is a language built for data analysis. Its syntax revolves around vectors — the fundamental data structure. R uses `<-` for assignment (though `=` works), has no scalar type (scalars are length-1 vectors), and provides powerful vectorized operations that eliminate the need for most loops. The tidyverse ecosystem (dplyr, ggplot2, tidyr) provides a cohesive, readable syntax for data manipulation.

## Vectors

```r
# Vectors are the fundamental building blocks (all elements same type)
nums <- c(1, 2, 3, 4, 5)
chars <- c("a", "b", "c")
logicals <- c(TRUE, FALSE, TRUE)

# Named vectors
scores <- c(alice = 95, bob = 87, carol = 92)
scores["alice"]  # 95

# Sequences
1:10                    # 1, 2, 3, ..., 10
seq(1, 10, by = 2)     # 1, 3, 5, 7, 9
rep(1:3, times = 2)    # 1, 2, 3, 1, 2, 3
rep(1:3, each = 2)     # 1, 1, 2, 2, 3, 3

# Vectorized operations (no loops needed!)
c(1, 2, 3) + c(10, 20, 30)   # 11, 22, 33
c(1, 2, 3) * 2               # 2, 4, 6
c(10, 20, 30) > 15            # FALSE, TRUE, TRUE

# Subsetting
nums <- c(10, 20, 30, 40, 50)
nums[c(1, 3, 5)]    # 10, 30, 50
nums[nums > 25]     # 30, 40, 50
nums[-1]            # 20, 30, 40, 50 (exclude first)
```

## Matrices

```r
# Matrices: 2D arrays of same type
mat <- matrix(1:12, nrow = 3, ncol = 4)
#      [,1] [,2] [,3] [,4]
# [1,]    1    4    7   10
# [2,]    2    5    8   11
# [3,]    3    6    9   12

# Matrix operations
mat * 2               # Scalar multiplication
t(mat)                # Transpose
mat %*% t(mat)        # Matrix multiplication
solve(mat[,1:3] %*% t(mat[,1:3]))  # Inverse (if square)
eigen(mat %*% t(mat)) # Eigenvalues/eigenvectors

# Row/column operations
rowSums(mat)          # Sum of each row
colMeans(mat)         # Mean of each column
apply(mat, 1, max)   # Max of each row (1=row, 2=col)
```

## Data Frames and Tibbles

```r
# Data frames: the workhorse of R data analysis
df <- data.frame(
  name = c("Alice", "Bob", "Carol", "Dave"),
  age = c(25, 30, 35, 28),
  score = c(95.5, 87.3, 92.1, 88.7),
  passed = c(TRUE, FALSE, TRUE, TRUE)
)

df$name       # Access column by name
df[1, ]       # First row
df[, 2]       # Second column
df[df$age > 28, ]  # Filter rows

# Tibbles (tidyverse enhanced data frames)
library(tibble)
tb <- tibble(
  x = 1:3,
  y = c("a", "b", "c"),
  z = runif(3)
)
print(tb)  # Better display than data.frame

# dplyr: data manipulation grammar
library(dplyr)

df %>%
  filter(age > 27) %>%
  arrange(desc(score)) %>%
  mutate(grade = ifelse(score > 90, "A", "B")) %>%
  select(name, score, grade)
```

## Lists

```r
# Lists: heterogeneous collections (can contain anything)
my_list <- list(
  name = "Alice",
  scores = c(90, 85, 92),
  active = TRUE,
  nested = list(a = 1, b = 2)
)

my_list$name       # "Alice"
my_list[[2]]       # c(90, 85, 92)
my_list[["scores"]][1]  # 90

# Unlisting
unlist(my_list[1:3])  # Flatten to vector
```

## Factors

```r
# Factors: categorical data representation
grade <- factor(c("A", "B", "A", "C", "B", "A"))
levels(grade)      # "A" "B" "C"
table(grade)       # Count frequencies

# Ordered factors
satisfaction <- factor(
  c("low", "high", "medium", "high"),
  levels = c("low", "medium", "high"),
  ordered = TRUE
)
satisfaction > "medium"  # FALSE, TRUE, FALSE, TRUE
```

## Apply Family

```r
# apply(): Apply function over array margins
mat <- matrix(1:12, nrow = 3)
apply(mat, 1, sum)      # Row sums
apply(mat, 2, mean)     # Column means

# lapply(): Apply to list, returns list
lapply(1:5, function(x) x^2)

# sapply(): Apply to list, returns vector (simplified)
sapply(1:5, function(x) x^2)

# vapply(): Like sapply but with type-safe return
vapply(1:5, function(x) x^2, numeric(1))

# tapply(): Apply by groups
tapply(mtcars$mpg, mtcars$cyl, mean)

# Map (purrr): Modern alternative
library(purrr)
map(1:5, ~ .x^2)          # Returns list
map_dbl(1:5, ~ .x^2)      # Returns double vector
map2(1:5, 6:10, +)         # Two inputs
pmap(list(1:5, 6:10, 11:15), +)  # Multiple inputs
```

## Functions

```r
# Basic function
add <- function(a, b) {
  a + b
}

# Default arguments and named parameters
greet <- function(name, greeting = "Hello") {
  paste(greeting, name, "!")
}

# Variadic arguments (...)
sum_all <- function(...) {
  args <- list(...)
  sum(unlist(args))
}
sum_all(1, 2, 3, c(4, 5))  # 15

# Return multiple values as a list
describe <- function(x) {
  list(
    mean = mean(x),
    sd = sd(x),
    min = min(x),
    max = max(x),
    n = length(x)
  )
}

stats <- describe(rnorm(100, mean = 50, sd = 10))
stats$mean  # ~50
```

## ggplot2

```r
library(ggplot2)

# Grammar of graphics: data + aesthetics + geometry
ggplot(mtcars, aes(x = wt, y = mpg, color = factor(cyl))) +
  geom_point(size = 3, alpha = 0.7) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "Car Weight vs Fuel Economy",
    x = "Weight (1000 lbs)",
    y = "Miles Per Gallon",
    color = "Cylinders"
  ) +
  theme_minimal()

# Bar chart
ggplot(diamonds, aes(x = cut, fill = cut)) +
  geom_bar() +
  coord_flip() +
  labs(title = "Diamond Cuts Distribution") +
  theme_minimal()

# Histogram with density
ggplot(mtcars, aes(x = mpg)) +
  geom_histogram(aes(y = after_stat(density)), bins = 10, fill = "steelblue", alpha = 0.7) +
  geom_density(color = "red", linewidth = 1) +
  labs(title = "MPG Distribution") +
  theme_minimal()
```

## Tidyverse Data Manipulation

```r
library(dplyr)
library(tidyr)
library(readr)

# Read data
df <- read_csv("data.csv")

# Core dplyr verbs
result <- df %>%
  filter(!is.na(score)) %>%           # Keep non-NA scores
  group_by(category) %>%               # Group by category
  summarise(                            # Aggregate
    avg_score = mean(score),
    count = n(),
    sd_score = sd(score)
  ) %>%
  arrange(desc(avg_score)) %>%          # Sort descending
  mutate(
    grade = case_when(
      avg_score >= 90 ~ "A",
      avg_score >= 80 ~ "B",
      avg_score >= 70 ~ "C",
      TRUE ~ "F"
    )
  )

# Pivoting (tidyr)
# Wide to long
long <- df %>% pivot_longer(
  cols = starts_with("test"),
  names_to = "test_name",
  values_to = "score"
)

# Long to wide
wide <- long %>% pivot_wider(
  names_from = test_name,
  values_from = score
)
```

## S3, S4, and R6 Classes

```r
# S3: Informal OOP (most common in R)
person <- function(name, age) {
  structure(
    list(name = name, age = age),
    class = "Person"
  )
}

print.Person <- function(x, ...) {
  cat(x$name, "is", x$age, "years old\n")
}

p <- person("Alice", 30)
print(p)  # "Alice is 30 years old"

# S4: Formal OOP (more rigid)
setClass("Person",
  representation(name = "character", age = "numeric")
)
setMethod("show", "Person", function(object) {
  cat(object@name, "is", object@age, "years old\n")
})

# R6: Reference-based OOP (like Python/Java classes)
library(R6)
Person <- R6Class("Person",
  public = list(
    name = NULL,
    age = NULL,
    initialize = function(name, age) {
      self$name <- name
      self$age <- age
    },
    greet = function() {
      paste("Hello, I'm", self$name)
    }
  )
)

p <- Person$new("Bob", 25)
p$greet()  # "Hello, I'm Bob"
```

## Demo

```r
# Complete demo: String analysis and data manipulation
library(stringr)

analyze_string <- function(text) {
  list(
    length = nchar(text),
    word_count = str_count(text, "\\S+"),
    char_frequency = sort(table(str_split_1(str_to_lower(text), "")), decreasing = TRUE),
    reversed = str_flatten(rev(str_split_1(text, ""))),
    is_palindrome = str_to_lower(str_remove_all(text, "[^a-zA-Z0-9]")) ==
                    str_flatten(rev(str_split_1(str_to_lower(str_remove_all(text, "[^a-zA-Z0-9]")), ""))),
    contains_number = str_detect(text, "\\d"),
    title_case = str_to_title(text)
  )
}

text <- "Hello World from R"
result <- analyze_string(text)
cat("Length:", result$length, "\n")
cat("Word count:", result$word_count, "\n")
cat("Is palindrome:", result$is_palindrome, "\n")
cat("Title case:", result$title_case, "\n")

# Data manipulation demo
library(dplyr)

mtcars %>%
  mutate(
    performance = mpg * hp,
    cylinder_factor = factor(cyl)
  ) %>%
  group_by(cylinder_factor) %>%
  summarise(
    avg_mpg = mean(mpg),
    avg_hp = mean(hp),
    count = n()
  ) %>%
  arrange(desc(avg_mpg))
```

## See Also

- [[R/README|R Overview]]
- [[R/Basics/r-basics-tutorial|R Basics Tutorial]]
- [[R/OOP/oop|R Object-Oriented Programming]]
- [[R/Algorithms/String/string_algorithms|String Algorithms in R]]
