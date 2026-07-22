# Shape Hierarchy in Ruby
#
# Demonstrates Ruby OOP: classes, modules (mixins),
# inheritance, open classes, and metaprogramming.
#
# Run: ruby classes.rb

# ============================================================
# Modules: Reusable behavior (mixins)
# ============================================================
module Drawable
  def draw
    "Drawing a #{type.downcase} with area #{area.round(2)}"
  end
end

module Calculable
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def from_dimensions(*dimensions)
      new(*dimensions)
    end
  end

  def summary
    "#{type}: area=#{area.round(2)}, perimeter=#{perimeter.round(2)}"
  end
end

module Measurable
  def larger_than?(other)
    area > other.area
  end

  def smaller_than?(other)
    area < other.area
  end
end

# ============================================================
# Abstract class (Ruby doesn't enforce, but convention is clear)
# ============================================================
class Shape
  include Drawable
  include Calculable
  include Measurable

  attr_reader :x, :y, :color

  def initialize(x: 0, y: 0, color: "black")
    @x = x
    @y = y
    @color = color
  end

  def area
    raise NotImplementedError, "#{self.class} must implement #area"
  end

  def perimeter
    raise NotImplementedError, "#{self.class} must implement #perimeter"
  end

  def type
    self.class.name
  end

  def to_s
    "#{type} at (#{@x}, #{@y}) [#{color}]: area=#{area.round(2)}, perimeter=#{perimeter.round(2)}"
  end

  def <=>(other)
    area <=> other.area
  end
end

# ============================================================
# Concrete shapes
# ============================================================
class Circle < Shape
  attr_reader :radius

  def initialize(radius, x: 0, y: 0, color: "black")
    super(x: x, y: y, color: color)
    @radius = radius
  end

  def area
    Math::PI * @radius ** 2
  end

  def perimeter
    2 * Math::PI * @radius
  end

  def draw
    "Drawing circle r=#{@radius} at (#{@x}, #{@y})"
  end
end

class Rectangle < Shape
  attr_reader :width, :height

  def initialize(width, height, x: 0, y: 0, color: "black")
    super(x: x, y: y, color: color)
    @width = width
    @height = height
  end

  def area
    @width * @height
  end

  def perimeter
    2 * (@width + @height)
  end
end

class Square < Rectangle
  def initialize(side, x: 0, y: 0, color: "black")
    super(side, side, x: x, y: y, color: color)
  end

  def type
    "Square"
  end

  def side
    @width
  end
end

class Triangle < Shape
  attr_reader :a, :b, :c

  def initialize(a, b, c, x: 0, y: 0, color: "black")
    super(x: x, y: y, color: color)
    @a = a
    @b = b
    @c = c
  end

  def area
    s = (@a + @b + @c) / 2.0
    Math.sqrt(s * (s - @a) * (s - @b) * (s - @c))
  end

  def perimeter
    @a + @b + @c
  end
end

# ============================================================
# Shape collection using Ruby's Enumerable
# ============================================================
class ShapeCollection
  include Enumerable

  def initialize
    @shapes = []
  end

  def add(shape)
    @shapes << shape
    self
  end

  def each(&block)
    @shapes.each(&block)
  end

  def sorted_by_area
    @shapes.sort_by(&:area)
  end

  def total_area
    @shapes.sum(&:area)
  end
end

# ============================================================
# Metaprogramming: Dynamic shape factory
# ============================================================
class ShapeFactory
  def self.create(type, *args)
    shape_class = Object.const_get(type)
    shape_class.new(*args)
  end

  # Dynamic method for each shape type
  %w[Circle Rectangle Square Triangle].each do |shape_name|
    define_singleton_method("create_#{shape_name.downcase}") do |*args|
      create(shape_name, *args)
    end
  end
end

# ============================================================
# Demo
# ============================================================
puts "=== Ruby Shape Hierarchy ==="
puts

# Create shapes
shapes = [
  Circle.new(5, x: 0, y: 0, color: "red"),
  Rectangle.new(4, 6, x: 1, y: 1, color: "blue"),
  Square.new(3, x: 2, y: 2, color: "green"),
  Triangle.new(3, 4, 5, x: 3, y: 3, color: "orange"),
]

# Display all shapes
puts "All Shapes:"
puts "-" * 60
shapes.each { |s| puts s }

# Demonstrate modules
puts "\nDrawing shapes:"
shapes.each { |s| puts "  #{s.draw}" }

# Demonstrate Measurable module
puts "\nComparisons:"
circle = shapes[0]
rectangle = shapes[1]
puts "  Circle larger than Rectangle? #{circle.larger_than?(rectangle)}"
puts "  Rectangle smaller than Triangle? #{rectangle.smaller_than?(shapes[3])}"

# Demonstrate sorting
puts "\nSorted by area (ascending):"
shapes.sort_by(&:area).each { |s| puts "  #{s.type}: #{s.area.round(2)}" }

# Demonstrate collection
puts "\nShape collection:"
collection = ShapeCollection.new
shapes.each { |s| collection.add(s) }
puts "  Total shapes: #{collection.count}"
puts "  Total area: #{collection.total_area.round(2)}"

# Demonstrate metaprogramming factory
puts "\nMetaprogramming factory:"
factory_circle = ShapeFactory.create_circle(3)
puts "  Factory circle: #{factory_circle}"
factory_square = ShapeFactory.create_square(4)
puts "  Factory square: #{factory_square}"

# Demonstrate polymorphism
puts "\nPolymorphism demo:"
def print_shape_info(shape)
  puts "  #{shape.summary}"
end

shapes.each { |s| print_shape_info(s) }
