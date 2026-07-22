# R Introduction

## Why Learn R?
R is a language and environment for statistical computing and graphics. It's the standard for data analysis, statistical modeling, and data visualization.

## Key Features
- **Statistical Computing**: Built for statistics
- **Data Visualization**: ggplot2 is industry standard
- **Package Ecosystem**: CRAN has 20,000+ packages
- **Data Manipulation**: dplyr, tidyr for data wrangling
- **Reproducible Research**: R Markdown for reports
- **Interactive**: RStudio provides excellent IDE
- **Free & Open Source**: No licensing costs
- **Academic Standard**: Most cited language in research

## Getting Started

### Installation
1. Install R from r-project.org
2. Install RStudio IDE (recommended)
3. Verify: `R --version`

### First Program
```r
print("Hello, World!")
```

Save as `hello.R` and run with `Rscript hello.R`

## Basic Syntax

### Variables and Data Types
```r
# Variables (no need to declare)
name <- "Alice"
age <- 30
height <- 5.5
is_student <- TRUE

# Assignment operators (all equivalent)
name <- "Alice"
name = "Alice"
name <<- "Alice"  # Global assignment

# Data types
class(name)      # "character"
class(age)       # "numeric"
class(is_student) # "logical"

# Vectors (fundamental data structure)
numbers <- c(1, 2, 3, 4, 5)
names <- c("Alice", "Bob", "Charlie")

# Sequences
1:10              # 1, 2, ..., 10
seq(1, 10, by=2)  # 1, 3, 5, 7, 9
rep(1, 5)         # 1, 1, 1, 1, 1

# Lists (heterogeneous)
person <- list(name="Alice", age=30, scores=c(95, 87, 92))

# Matrices
matrix(1:12, nrow=3, ncol=4)

# Data frames
df <- data.frame(
  name = c("Alice", "Bob"),
  age = c(30, 25),
  score = c(95, 87)
)
```

### Input/Output
```r
# Output
print("Hello, World!")
cat("Name:", name, "\n")

# Input
name <- readline("Enter your name: ")

# Read files
data <- read.csv("data.csv")
data <- read.table("data.txt", header=TRUE)
data <- readxl::read_excel("data.xlsx")

# Write files
write.csv(data, "output.csv")
write.table(data, "output.txt")
```

### Control Flow
```r
# If-else
if (age >= 18) {
  print("Adult")
} else if (age >= 13) {
  print("Teenager")
} else {
  print("Child")
}

# If as function (vectorized)
ifelse(numbers > 3, "big", "small")

# For loop
for (i in 1:5) {
  print(i)
}

# For loop with vector
for (name in c("Alice", "Bob", "Charlie")) {
  print(paste("Hello,", name))
}

# While loop
count <- 5
while (count > 0) {
  print(count)
  count <- count - 1
}

# Repeat loop
repeat {
  if (condition) break
}

# Switch
switch(day,
  "Monday" = "Start of week",
  "Friday" = "Almost weekend",
  "Weekend" = "Relax!",
  "Midweek"  # Default
)
```

### Functions
```r
# Basic function
add <- function(a, b) {
  return(a + b)
}

# Implicit return (last expression)
add <- function(a, b) {
  a + b
}

# Default parameters
greet <- function(name, greeting = "Hello") {
  paste(greeting, name, "!")
}

# Named arguments
greet(name="Alice", greeting="Hi")

# Variadic arguments
sum_all <- function(...) {
  sum(...)
}

# Lambda/Anonymous functions
square <- function(x) x^2
square <- \(x) x^2  # Shorthand

# Higher-order functions
numbers <- c(1, 2, 3, 4, 5)
doubled <- sapply(numbers, function(x) x * 2)
evens <- Filter(function(x) x %% 2 == 0, numbers)
total <- Reduce("+", numbers)

# Closure
make_counter <- function() {
  count <- 0
  function() {
    count <<- count + 1
    count
  }
}
```

### Vectors and Operations
```r
# Vector operations (vectorized)
numbers <- c(1, 2, 3, 4, 5)
numbers + 10        # Add 10 to each
numbers * 2         # Multiply each by 2
numbers > 3         # Logical vector

# Indexing
numbers[1]          # First element
numbers[c(1, 3)]    # First and third
numbers[-1]         # All except first
numbers[2:4]        # Subset

# Named vectors
scores <- c(Alice=95, Bob=87, Charlie=92)
scores["Alice"]
scores[c("Alice", "Bob")]

# Useful functions
length(numbers)     # 5
sum(numbers)        # 15
mean(numbers)       # 3
min(numbers)        # 1
max(numbers)        # 5
sort(numbers)       # 1, 2, 3, 4, 5
rev(numbers)        # 5, 4, 3, 2, 1
unique(c(1,1,2,2,3)) # 1, 2, 3
table(c("a","b","a","c")) # Frequency table
```

### Lists
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
person[[1]]

# Add elements
person$email <- "alice@example.com"

# Remove elements
person$email <- NULL

# Apply functions
lapply(person, length)
sapply(person, class)
```

### Data Frames
```r
# Create data frame
df <- data.frame(
  name = c("Alice", "Bob", "Charlie"),
  age = c(30, 25, 35),
  score = c(95, 87, 92),
  stringsAsFactors = FALSE
)

# Structure
str(df)
head(df)
tail(df)
summary(df)

# Access columns
df$name
df[["name"]]
df[, "name"]

# Access rows
df[1, ]
df[df$age > 25, ]

# Add rows
df <- rbind(df, data.frame(name="Diana", age=28, score=88))

# Add columns
df$grade <- c("A", "B", "A", "B+")

# Remove columns
df$grade <- NULL
```

### dplyr (Data Manipulation)
```r
library(dplyr)

# Filter rows
df %>% filter(age > 25)

# Select columns
df %>% select(name, score)

# Mutate (add/modify columns)
df <- df %>% mutate(
  pass = score >= 60,
  grade = ifelse(score >= 90, "A", "B")
)

# Arrange (sort)
df %>% arrange(score)           # Ascending
df %>% arrange(desc(score))     # Descending

# Summarize
df %>% summarise(
  avg_score = mean(score),
  max_age = max(age)
)

# Group by
df %>%
  group_by(grade) %>%
  summarise(count = n(), avg_score = mean(score))

# Pipe operator
result <- df %>%
  filter(age > 25) %>%
  select(name, score) %>%
  arrange(desc(score))
```

### ggplot2 (Visualization)
```r
library(ggplot2)

# Basic plot
ggplot(df, aes(x=age, y=score)) +
  geom_point()

# Scatter plot with color
ggplot(df, aes(x=age, y=score, color=grade)) +
  geom_point(size=3)

# Bar chart
ggplot(df, aes(x=name, y=score)) +
  geom_bar(stat="identity")

# Histogram
ggplot(df, aes(x=score)) +
  geom_histogram(binwidth=5)

# Line plot
ggplot(time_series, aes(x=date, y=value)) +
  geom_line() +
  geom_point()

# Multiple layers
ggplot(df, aes(x=age, y=score)) +
  geom_point() +
  geom_smooth(method="lm") +
  labs(title="Age vs Score", x="Age", y="Score") +
  theme_minimal()
```

### Apply Functions
```r
# apply - rows/columns
matrix(1:12, 3, 4) |> apply(1, sum)  # Row sums
matrix(1:12, 3, 4) |> apply(2, mean) # Column means

# lapply - returns list
1:5 |> lapply(function(x) x^2)

# sapply - returns vector
1:5 |> sapply(function(x) x^2)

# vapply - type-safe sapply
1:5 |> vapply(function(x) x^2, numeric(1))

# tapply - apply by group
tapply(df$score, df$grade, mean)

# mapply - multivariate apply
mapply(sum, 1:5, 5:1)
```

### Error Handling
```r
# Try-catch
tryCatch({
  result <- 10 / 0
}, warning = function(w) {
  print(paste("Warning:", w$message))
}, error = function(e) {
  print(paste("Error:", e$message))
}, finally = {
  print("Always runs")
})

# Stop
validate <- function(x) {
  if (x < 0) stop("Value must be non-negative")
}

# Warning
old_value <- function(x) {
  if (x > 100) warning("Value seems too high")
}
```

### Packages
```r
# Install package
install.packages("dplyr")

# Load library
library(dplyr)

# Access functions
dplyr::filter(df, age > 25)

# Check installed packages
installed.packages()

# Update packages
update.packages()

# Key packages
# dplyr - Data manipulation
# ggplot2 - Visualization
# tidyr - Data tidying
# readr - Read data
# purrr - Functional programming
# stringr - String manipulation
# lubridate - Dates and times
```

### R Markdown
```r
# Create R Markdown file
# File extension: .Rmd

# Header
---
title: "My Report"
author: "Alice"
date: "`r Sys.Date()`"
output: html_document
---

# Introduction
This is an R Markdown document.

```{r}
# R code chunks
summary(cars)
```

## Results
```{r, echo=FALSE}
# Code runs but not shown
plot(cars)
```

# Render
rmarkdown::render("report.Rmd")
```

### Tidyverse
```r
library(tidyverse)

# Pipe-friendly workflow
result <- raw_data %>%
  filter(!is.na(value)) %>%
  group_by(category) %>%
  summarise(
    mean = mean(value),
    sd = sd(value),
    n = n()
  ) %>%
  arrange(desc(mean))

# String manipulation with stringr
library(stringr)
str_to_upper("hello")
str_extract("abc123", "\\d+")
str_replace_all("hello world", " ", "_")

# Dates with lubridate
library(lubridate)
now()
year(Sys.Date())
today() + days(7)
```

## Best Practices
1. Use `<-` for assignment (not `=`)
2. Use pipes `%>%` for readable code
3. Use dplyr verbs over base R
4. Document your code
5. Use R Markdown for reports
6. Version control with git
7. Use projects in RStudio

## Common Pitfalls
- Forgetting to load libraries
- Factor vs character confusion
- Not handling missing values (NA)
- Base R vs Tidyverse syntax differences
- Not setting working directory
- Indexing starts at 1, not 0