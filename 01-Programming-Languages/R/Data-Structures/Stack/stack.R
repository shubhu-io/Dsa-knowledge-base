Stack <- setRefClass("Stack",
  fields = list(
    items = "list"
  ),
  methods = list(
    initialize = function() {
      .self$items <- list()
    },
    
    push = function(item) {
      .self$items <- c(.self$items, list(item))
    },
    
    pop = function() {
      if (length(.self$items) == 0) return(NULL)
      item <- .self$items[[length(.self$items)]]
      .self$items <- .self$items[-length(.self$items)]
      item
    },
    
    peek = function() {
      if (length(.self$items) == 0) return(NULL)
      .self$items[[length(.self$items)]]
    },
    
    is_empty = function() {
      length(.self$items) == 0
    },
    
    size = function() {
      length(.self$items)
    }
  )
)

stack <- Stack$new()
stack$push(1)
stack$push(2)
stack$push(3)

cat("Stack size:", stack$size(), "\n")
cat("Popped:", stack$pop(), "\n")
cat("Top:", stack$peek(), "\n")