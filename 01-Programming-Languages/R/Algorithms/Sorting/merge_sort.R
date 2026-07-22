merge_sort <- function(arr) {
  if (length(arr) <= 1) {
    return(arr)
  }
  
  mid <- length(arr) %/% 2
  left <- merge_sort(arr[1:mid])
  right <- merge_sort(arr[(mid + 1):length(arr)])
  
  merge(left, right)
}

merge <- function(left, right) {
  result <- c()
  i <- 1
  j <- 1
  
  while (i <= length(left) && j <= length(right)) {
    if (left[i] <= right[j]) {
      result <- c(result, left[i])
      i <- i + 1
    } else {
      result <- c(result, right[j])
      j <- j + 1
    }
  }
  
  c(result, left[i:length(left)], right[j:length(right)])
}

arr <- c(38, 27, 43, 3, 9, 82, 10)
cat("Original:", arr, "\n")
cat("Sorted:", merge_sort(arr), "\n")