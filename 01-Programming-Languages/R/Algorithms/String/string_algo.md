# String Algorithms in R

## Overview

R's string manipulation capabilities are enhanced by the `stringr` and `stringi` packages. While base R provides functions like `nchar()`, `substr()`, and `grep()`, the tidyverse approach using `stringr` offers a more consistent API. This file covers string algorithms using both base R and stringr.

## Algorithms

### Character Frequency Count

```r
library(stringr)

# Base R using table()
char_frequency <- function(str) {
  chars <- tolower(unlist(strsplit(str, "")))
  chars <- chars[chars != " "]
  sort(table(chars), decreasing = TRUE)
}

# Using stringr
char_frequency_str <- function(str) {
  chars <- str_split(str, "")[[1]]
  chars <- chars[chars != " "]
  chars <- tolower(chars)
  sort(table(chars), decreasing = TRUE)
}
```

### Palindrome Check

```r
library(stringr)

# Idiomatic R
is_palindrome <- function(str) {
  clean <- tolower(str_replace_all(str, "[^a-zA-Z0-9]", ""))
  clean == paste(rev(unlist(strsplit(clean, ""))), collapse = "")
}
```

### Reverse a String

```r
library(stringr)

reverse_string <- function(str) {
  paste(rev(unlist(strsplit(str, ""))), collapse = "")
}
```

### Run-Length Encoding

```r
# Time: O(n), Space: O(n)
run_length_encode <- function(str) {
  if (nchar(str) == 0) return("")
  chars <- unlist(strsplit(str, ""))
  encoded <- ""
  count <- 1

  for (i in 2:length(chars)) {
    if (chars[i] == chars[i - 1]) {
      count <- count + 1
    } else {
      encoded <- paste0(encoded, chars[i - 1], count)
      count <- 1
    }
  }
  encoded <- paste0(encoded, chars[length(chars)], count)
  encoded
}

run_length_decode <- function(encoded) {
  matches <- gregexpr("(\\D)(\\d+)", encoded, perl = TRUE)
  chars <- regmatches(encoded, matches)[[1]]
  result <- paste0(
    sapply(chars, function(m) {
      char <- substr(m, 1, 1)
      count <- as.integer(substr(m, 2, nchar(m)))
      paste(rep(char, count), collapse = "")
    }),
    collapse = ""
  )
  result
}
```

### Anagram Check

```r
library(stringr)

is_anagram <- function(str1, str2) {
  clean <- function(s) {
    s <- tolower(str_replace_all(s, "[^a-z]", ""))
    paste(sort(unlist(strsplit(s, ""))), collapse = "")
  }
  clean(str1) == clean(str2)
}
```

### Longest Common Prefix

```r
longest_common_prefix <- function(strings) {
  if (length(strings) == 0) return("")
  prefix <- strings[1]
  for (i in 2:length(strings)) {
    while (!startsWith(strings[i], prefix) && nchar(prefix) > 0) {
      prefix <- substr(prefix, 1, nchar(prefix) - 1)
    }
    if (nchar(prefix) == 0) return("")
  }
  prefix
}
```

### Substring Search

```r
library(stringr)

find_occurrences <- function(haystack, needle) {
  as.numeric(str_locate_all(haystack, needle)[[1]][, "start"])
}
```

### Longest Palindromic Substring

```r
longest_palindrome <- function(str) {
  if (nchar(str) < 2) return(str)
  chars <- unlist(strsplit(str, ""))
  len <- length(chars)
  start_idx <- 1
  max_len <- 1

  expand <- function(left, right) {
    while (left >= 1 && right <= len && chars[left] == chars[right]) {
      left <- left - 1
      right <- right + 1
    }
    c(left + 1, right - left - 1)
  }

  for (i in 1:len) {
    r1 <- expand(i, i)
    r2 <- expand(i, i + 1)
    if (r1[2] > max_len) {
      start_idx <- r1[1]
      max_len <- r1[2]
    }
    if (r2[2] > max_len) {
      start_idx <- r2[1]
      max_len <- r2[2]
    }
  }

  paste(chars[start_idx:(start_idx + max_len - 1)], collapse = "")
}
```

## Demo

```r
library(stringr)

# Character frequency
text <- "hello world"
cat("Character frequency:\n")
freq <- char_frequency(text)
print(freq)

# Palindrome
cat("\nPalindrome check:\n")
cat("'racecar':", is_palindrome("racecar"), "\n")
cat("'hello':", is_palindrome("hello"), "\n")

# Run-length encoding
cat("\nRun-Length Encoding:\n")
encoded <- run_length_encode("aaabbccdddde")
cat("'aaabbccdddde' ->", encoded, "\n")
cat("Decoded:", run_length_decode(encoded), "\n")

# Longest palindrome
cat("\nLongest Palindromic Substring:\n")
cat("'babad' ->", longest_palindrome("babad"), "\n")
cat("'cbbd' ->", longest_palindrome("cbbd"), "\n")
```

## R String Function Reference

| Function | Package | Purpose | Example |
|----------|---------|---------|---------|
| `nchar()` | base | Character count | `nchar("hello")` => `5` |
| `substr()` | base | Extract substring | `substr("hello", 1, 3)` => `"hel"` |
| `strsplit()` | base | Split string | `strsplit("a,b", ",")` |
| `gsub()` | base | Global substitution | `gsub("l", "r", "hello")` => `"herro"` |
| `grepl()` | base | Pattern matching | `grepl("\\d", "a1b")` => `TRUE` |
| `str_detect()` | stringr | Pattern matching | `str_detect("hello", "ll")` => `TRUE` |
| `str_extract()` | stringr | Extract first match | `str_extract("a1b2", "\\d+")` => `"1"` |
| `str_replace_all()` | stringr | Replace all matches | `str_replace_all("hello", "l", "r")` |
| `str_split()` | stringr | Split string | `str_split("a,b,c", ",")` |
| `str_flatten()` | stringr | Collapse vector | `str_flatten(c("a","b"), "-")` => `"a-b"` |
| `str_to_lower()` | stringr | Lowercase | `str_to_lower("HELLO")` => `"hello"` |

## See Also

- [[R/Algorithms/String/string_algorithms|String Algorithms (code)]]
- [[R/Basics/syntax|R Syntax]]
- [[R/OOP/oop|R OOP]]
