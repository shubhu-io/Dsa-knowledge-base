# Problem: Hash Map Implementation
# Description: Implement a simple hash map with separate chaining.
#
# Approach:
# - Use an array of buckets with linked list chaining
# - Compute index using hash function modulo table size
#
# Time Complexity: O(1) average, O(n) worst case
# Space Complexity: O(n)
#
# Example:
# Input: put("a", 1), put("b", 2), get("a")
# Output: 1

HashMap <- function() {
  list(size = 10, buckets = vector("list", 10))
}

hash_code <- function(key) {
  sum(as.integer(charToRaw(key)))
}

put <- function(map, key, value) {
  idx <- (hash_code(key) %% map$size) + 1
  bucket <- map$buckets[[idx]]
  for (i in seq_along(bucket)) {
    if (bucket[[i]]$key == key) {
      bucket[[i]]$value <- value
      map$buckets[[idx]] <- bucket
      return(map)
    }
  }
  bucket <- c(bucket, list(list(key = key, value = value)))
  map$buckets[[idx]] <- bucket
  map
}

get <- function(map, key) {
  idx <- (hash_code(key) %% map$size) + 1
  bucket <- map$buckets[[idx]]
  for (entry in bucket) {
    if (entry$key == key) return(entry$value)
  }
  NULL
}

remove_key <- function(map, key) {
  idx <- (hash_code(key) %% map$size) + 1
  bucket <- map$buckets[[idx]]
  for (i in seq_along(bucket)) {
    if (bucket[[i]]$key == key) {
      bucket <- bucket[-i]
      map$buckets[[idx]] <- bucket
      return(map)
    }
  }
  map
}

m <- HashMap()
m <- put(m, "a", 1)
m <- put(m, "b", 2)
m <- put(m, "c", 3)
cat("get(\"a\"):", get(m, "a"), "\n")
cat("get(\"b\"):", get(m, "b"), "\n")
cat("get(\"d\"):", get(m, "d"), "\n")
m <- remove_key(m, "b")
cat("After remove, get(\"b\"):", get(m, "b"), "\n")
