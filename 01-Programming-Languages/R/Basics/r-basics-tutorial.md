# R Basics Tutorial

## Variables and Constants

```r
# Variables (no need to declare)
name <- "Alice"
age <- 30
height <- 5.5
is_student <- TRUE

# Constants (convention: UPPER_CASE)
PI <- 3.14159

# Assignment operators (all equivalent)
name <- "Alice"
name = "Alice"
```

## Data Types

- **numeric**: Decimal numbers
- **integer**: Whole numbers
- **character**: Text
- **logical**: TRUE/FALSE
- **factor**: Categorical data
- **vector**: 1D array
- **list**: Heterogeneous collection
- **data.frame**: Tabular data

## Control Flow

### If-Else
```r
if (age >= 18) {
  print("Adult")
} else if (age >= 13) {
  print("Teenager")
} else {
  print("Child")
}

# Vectorized ifelse
ifelse(numbers > 3, "big", "small")
```

### For Loop
```r
for (i in 1:5) {
  print(i)
}

for (name in c("Alice", "Bob")) {
  print(paste("Hello,", name))
}
```

### While Loop
```r
count <- 5
while (count > 0) {
  print(count)
  count <- count - 1
}
```

## Functions

```r
# Basic function
add <- function(a, b) {
  return(a + b)
}

# Default parameters
greet <- function(name, greeting = "Hello") {
  paste(greeting, name, "!")
}

# Lambda/Anonymous function
square <- function(x) x^2
square <- \(x) x^2  # Shorthand

# Higher-order functions
numbers <- c(1, 2, 3, 4, 5)
doubled <- sapply(numbers, function(x) x * 2)
evens <- Filter(function(x) x %% 2 == 0, numbers)
```

## Vectors

```r
# Create vectors
numbers <- c(1, 2, 3, 4, 5)
names <- c("Alice", "Bob", "Charlie")

# Operations (vectorized)
numbers + 10
numbers * 2
numbers > 3

# Indexing
numbers[1]        # First element
numbers[c(1, 3)]  # First and third
numbers[-1]       # All except first

# Useful functions
length(numbers)
sum(numbers)
mean(numbers)
sort(numbers)
```

## Lists

```r
# Create list
person <- list(
  name = "Alice",
  age = 30,
  scores = c(95, 87, 92)
)

# Access elements
person$name
person[["name"]]

# Add elements
person$email <- "alice@example.com"
```

## Data Frames

```r
# Create data frame
df <- data.frame(
  name = c("Alice", "Bob", "Charlie"),
  age = c(30, 25, 35),
  score = c(95, 87, 92)
)

# Structure
str(df)
head(df)
summary(df)

# Access
df$name
df[df$age > 25, ]
```

## dplyr

```r
library(dplyr)

# Pipe workflow
result <- df %>%
  filter(age > 25) %>%
  select(name, score) %>%
  arrange(desc(score))
```

## Best Practices

1. Use `<-` for assignment
2. Use pipes `%>%` for readable code
3. Use dplyr verbs over base R
4. Document your code
5. Use R Markdown for reports