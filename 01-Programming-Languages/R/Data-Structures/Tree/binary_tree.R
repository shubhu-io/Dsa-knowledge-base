TreeNode <- setRefClass("TreeNode",
  fields = list(
    value = "numeric",
    left = "ANY",
    right = "ANY"
  ),
  methods = list(
    initialize = function(value) {
      .self$value <- value
      .self$left <- NULL
      .self$right <- NULL
    }
  )
)

BinaryTree <- setRefClass("BinaryTree",
  fields = list(
    root = "ANY"
  ),
  methods = list(
    initialize = function() {
      .self$root <- NULL
    },
    
    insert = function(value) {
      new_node <- TreeNode$new(value)
      if (is.null(.self$root)) {
        .self$root <- new_node
        return()
      }
      current <- .self$root
      repeat {
        if (value < current$value) {
          if (is.null(current$left)) {
            current$left <- new_node
            return()
          }
          current <- current$left
        } else if (value > current$value) {
          if (is.null(current$right)) {
            current$right <- new_node
            return()
          }
          current <- current$right
        } else {
          return()  # Duplicate
        }
      }
    },
    
    inorder = function(node = .self$root) {
      if (is.null(node)) return()
      .self$inorder(node$left)
      cat(node$value, " ")
      .self$inorder(node$right)
    },
    
    search = function(value) {
      current <- .self$root
      while (!is.null(current)) {
        if (value == current$value) return(TRUE)
        if (value < current$value) {
          current <- current$left
        } else {
          current <- current$right
        }
      }
      FALSE
    }
  )
)

tree <- BinaryTree$new()
for (v in c(50, 30, 70, 20, 40, 60, 80)) {
  tree$insert(v)
}

cat("Inorder: ")
tree$inorder()
cat("\n")

cat("Search 40:", tree$search(40), "\n")
cat("Search 90:", tree$search(90), "\n")