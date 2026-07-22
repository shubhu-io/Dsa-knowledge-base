binary_search <- function(arr, target) {
  left <- 1
  right <- length(arr)
  
  while (left <= right) {
    mid <- left + (right - left) %/% 2
    
    if (arr[mid] == target) {
      return(mid)
    } else if (arr[mid] < target) {
      left <- mid + 1
    } else {
      right <- mid - 1
    }
  }
  
  -1
}

arr <- c(2, 3, 4, 10, 40)
target <- 10
result <- binary_search(arr, target)

if (result == -1) {
  cat("Element not found\n")
} else {
  cat("Element found at index", result, "\n")
}