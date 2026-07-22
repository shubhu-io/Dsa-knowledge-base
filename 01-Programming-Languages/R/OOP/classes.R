# Shape Hierarchy in R
#
# Demonstrates R's different OOP systems:
# - S3 classes (informal, most common)
# - R6 classes (reference-based, Python/Java-like)
#
# Run: Rscript classes.R

# ============================================================
# S3 Classes: Informal OOP (most common in R)
# ============================================================

# Constructor
Shape <- function(name, color = "black") {
  structure(
    list(name = name, color = color),
    class = "Shape"
  )
}

# Methods
print.Shape <- function(x, ...) {
  cat(x$name, "[", x$color, "]\n")
}

summary.Shape <- function(object, ...) {
  cat(object$name, ": area =", round(object$area, 2),
      ", perimeter =", round(object$perimeter, 2), "\n")
}

# Circle S3 class
Circle <- function(radius, color = "black") {
  shape <- Shape("Circle", color)
  shape$radius <- radius
  shape$area <- pi * radius^2
  shape$perimeter <- 2 * pi * radius
  class(shape) <- c("Circle", "Shape")
  shape
}

print.Circle <- function(x, ...) {
  cat("Circle (r =", x$radius, ") [", x$color, "]",
      ": area =", round(x$area, 2),
      ", perimeter =", round(x$perimeter, 2), "\n")
}

# Rectangle S3 class
Rectangle <- function(width, height, color = "black") {
  shape <- Shape("Rectangle", color)
  shape$width <- width
  shape$height <- height
  shape$area <- width * height
  shape$perimeter <- 2 * (width + height)
  class(shape) <- c("Rectangle", "Shape")
  shape
}

print.Rectangle <- function(x, ...) {
  cat("Rectangle (", x$width, "x", x$height, ") [", x$color, "]",
      ": area =", round(x$area, 2),
      ", perimeter =", round(x$perimeter, 2), "\n")
}

# Triangle S3 class
Triangle <- function(a, b, c, color = "black") {
  shape <- Shape("Triangle", color)
  shape$a <- a
  shape$b <- b
  shape$c <- c
  s <- (a + b + c) / 2
  shape$area <- sqrt(s * (s - a) * (s - b) * (s - c))
  shape$perimeter <- a + b + c
  class(shape) <- c("Triangle", "Shape")
  shape
}

print.Triangle <- function(x, ...) {
  cat("Triangle (", x$a, ",", x$b, ",", x$c, ") [", x$color, "]",
      ": area =", round(x$area, 2),
      ", perimeter =", round(x$perimeter, 2), "\n")
}

# S3 generic functions
area <- function(shape) UseMethod("area")
area.Shape <- function(shape) shape$area

perimeter <- function(shape) UseMethod("perimeter")
perimeter.Shape <- function(shape) shape$perimeter

# ============================================================
# R6 Classes: Reference-based OOP
# ============================================================
library(R6)

R6Shape <- R6Class("R6Shape",
  public = list(
    name = NULL,
    color = NULL,
    x = 0,
    y = 0,

    initialize = function(name, color = "black", x = 0, y = 0) {
      self$name <- name
      self$color <- color
      self$x <- x
      self$y <- y
    },

    area = function() stop("Not implemented"),
    perimeter = function() stop("Not implemented"),

    describe = function() {
      paste0(self$name, " [", self$color, "] at (", self$x, ",", self$y, "): ",
             "area=", round(self$area(), 2),
             ", perimeter=", round(self$perimeter(), 2))
    },

    print = function(...) {
      cat(self$describe(), "\n")
      invisible(self)
    }
  )
)

R6Circle <- R6Class("R6Circle",
  inherit = R6Shape,
  public = list(
    radius = NULL,

    initialize = function(radius, color = "black", x = 0, y = 0) {
      super$initialize("Circle", color, x, y)
      self$radius <- radius
    },

    area = function() pi * self$radius^2,
    perimeter = function() 2 * pi * self$radius
  )
)

R6Rectangle <- R6Class("R6Rectangle",
  inherit = R6Shape,
  public = list(
    width = NULL,
    height = NULL,

    initialize = function(width, height, color = "black", x = 0, y = 0) {
      super$initialize("Rectangle", color, x, y)
      self$width <- width
      self$height <- height
    },

    area = function() self$width * self$height,
    perimeter = function() 2 * (self$width + self$height)
  )
)

R6Triangle <- R6Class("R6Triangle",
  inherit = R6Shape,
  public = list(
    a = NULL, b = NULL, c = NULL,

    initialize = function(a, b, c, color = "black", x = 0, y = 0) {
      super$initialize("Triangle", color, x, y)
      self$a <- a
      self$b <- b
      self$c <- c
    },

    area = function() {
      s <- (self$a + self$b + self$c) / 2
      sqrt(s * (s - self$a) * (s - self$b) * (s - self$c))
    },
    perimeter = function() self$a + self$b + self$c
  )
)

# ============================================================
# Demo: S3 classes
# ============================================================
cat("=== S3 Shape Hierarchy ===\n\n")

shapes_s3 <- list(
  Circle(5, "red"),
  Rectangle(4, 6, "blue"),
  Triangle(3, 4, 5, "orange")
)

cat("All Shapes:\n")
cat(strrep("-", 60), "\n")
for (s in shapes_s3) {
  print(s)
}

cat("\nSorted by area (ascending):\n")
areas <- sapply(shapes_s3, function(s) s$area)
sorted <- shapes_s3[order(areas)]
for (s in sorted) {
  cat("  ", s$name, ":", round(s$area, 2), "\n")
}

cat("\nTotal area:", round(sum(areas), 2), "\n")

# ============================================================
# Demo: R6 classes
# ============================================================
cat("\n=== R6 Shape Hierarchy ===\n\n")

shapes_r6 <- list(
  R6Circle$new(5, "red"),
  R6Rectangle$new(4, 6, "blue"),
  R6Triangle$new(3, 4, 5, "orange")
)

cat("All Shapes:\n")
cat(strrep("-", 60), "\n")
for (s in shapes_r6) {
  s$print()
}

cat("\nSorted by area (ascending):\n")
r6_areas <- sapply(shapes_r6, function(s) s$area())
sorted_r6 <- shapes_r6[order(r6_areas)]
for (s in sorted_r6) {
  cat("  ", s$name, ":", round(s$area(), 2), "\n")
}

cat("\nTotal area:", round(sum(r6_areas), 2), "\n")
