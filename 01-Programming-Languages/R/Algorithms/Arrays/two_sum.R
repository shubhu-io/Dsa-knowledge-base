two_sum <- function(nums, target) {
  num_map <- list()
  
  for (i in seq_along(nums)) {
    num <- nums[i]
    complement <- target - num
    if (as.character(complement) %in% names(num_map)) {
      return(c(num_map[[as.character(complement)]], i - 1))
    }
    num_map[[as.character(num)]] <- i - 1
  }
  
  NULL
}

nums <- c(2, 7, 11, 15)
target <- 9
result <- two_sum(nums, target)

if (!is.null(result)) {
  cat("Indices:", result, "\n")
} else {
  cat("No solution found\n")
}