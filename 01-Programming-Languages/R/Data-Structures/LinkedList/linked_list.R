Node <- setRefClass("Node",
  fields = list(
    value = "numeric",
    next_node = "ANY"
  ),
  methods = list(
    initialize = function(value) {
      .self$value <- value
      .self$next_node <- NULL
    }
  )
)

LinkedList <- setRefClass("LinkedList",
  fields = list(
    head = "ANY"
  ),
  methods = list(
    initialize = function() {
      .self$head <- NULL
    },
    
    append = function(value) {
      new_node <- Node$new(value)
      if (is.null(.self$head)) {
        .self$head <- new_node
        return()
      }
      current <- .self$head
      while (!is.null(current$next_node)) {
        current <- current$next_node
      }
      current$next_node <- new_node
    },
    
    prepend = function(value) {
      new_node <- Node$new(value)
      new_node$next_node <- .self$head
      .self$head <- new_node
    },
    
    delete = function(value) {
      if (is.null(.self$head)) return()
      if (.self$head$value == value) {
        .self$head <- .self$head$next_node
        return()
      }
      current <- .self$head
      while (!is.null(current$next_node) && current$next_node$value != value) {
        current <- current$next_node
      }
      if (!is.null(current$next_node)) {
        current$next_node <- current$next_node$next_node
      }
    },
    
    display = function() {
      current <- .self$head
      while (!is.null(current)) {
        cat(current$value, "-> ")
        current <- current$next_node
      }
      cat("NULL\n")
    }
  )
)

list <- LinkedList$new()
list$append(1)
list$append(2)
list$append(3)
list$prepend(0)

cat("List:\n")
list$display()

list$delete(2)
cat("After deleting 2:\n")
list$display()