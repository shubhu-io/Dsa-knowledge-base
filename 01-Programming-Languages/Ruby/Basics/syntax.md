# Ruby Syntax

## Overview

Ruby's syntax is designed for readability and expressiveness. Everything in Ruby is an object — including integers, booleans, and `nil`. Ruby supports multiple programming paradigms: OOP, functional, imperative, and reflective. Its syntax enables elegant DSLs (Domain-Specific Languages) through blocks, procs, and metaprogramming.

## Variables and Everything is an Object

```ruby
# Ruby has several variable types (sigil-based)
name = "Alice"          # local variable
@age = 30               # instance variable
@@counter = 0           # class variable
$global_var = true       # global variable (avoid)

# Everything is an object
42.even?                 # => false
"hello".upcase           # => "HELLO"
nil.to_s                 # => ""
true.class               # => TrueClass
[1, 2, 3].length         # => 3

# Symbols (immutable, interned strings — fast for hash keys)
status = :active
status.class             # => Symbol
status.to_s              # => "active"

# Constants
MAX_SIZE = 100
PI = 3.14159
```

## Data Structures

```ruby
# Arrays
numbers = [1, 2, 3, 4, 5]
numbers[0]               # => 1
numbers.first            # => 1
numbers.last             # => 5
numbers.push(6)          # => [1, 2, 3, 4, 5, 6]
numbers.pop              # => 6
numbers.select { |n| n.even? }   # => [2, 4]
numbers.map { |n| n * 2 }        # => [2, 4, 6, 8, 10]
numbers.reduce(0, :+)    # => 15

# Hashes (dictionaries)
person = { name: "Bob", age: 25, city: "NYC" }  # symbol keys
person[:name]            # => "Bob"
person[:email] = "bob@test.com"
person.fetch(:missing, "default")  # => "default"

# Ranges
(1..5).to_a              # => [1, 2, 3, 4, 5]
(1...5).to_a             # => [1, 2, 3, 4]
("a".."e").to_a          # => ["a", "b", "c", "d", "e"]

# Sets
require 'set'
unique = Set.new([1, 2, 2, 3])  # => #<Set: {1, 2, 3}>
unique.add(4)            # => #<Set: {1, 2, 3, 4}>
```

## Control Flow

```ruby
# Conditionals
if score >= 90
  "A"
elsif score >= 80
  "B"
else
  "C"
end

# Shorthand if/unless
puts "High score!" if score > 90
puts "Low score!" unless score > 50

# Case/when (pattern matching)
case value
when Integer
  "It's an integer"
when String
  "It's a string"
when Array
  "It's an array"
else
  "Unknown type"
end

# Pattern matching (Ruby 2.7+)
case { name: "Alice", age: 30 }
in { name: String => name, age: Integer if age >= 18 }
  puts "#{name} is an adult"
in { name: String => name }
  puts "#{name} is a minor"
end

# Ternary
result = score >= 60 ? "Pass" : "Fail"
```

## Blocks, Procs, and Lambdas

```ruby
# Blocks (most common — implicitly passed to methods)
3.times { |i| puts "Iteration #{i}" }

[1, 2, 3].each do |num|
  puts num * 10
end

# Procs (first-class closures)
double = Proc.new { |x| x * 2 }
double.call(5)           # => 10

# Lambdas (strict about arity)
triple = lambda { |x| x * 3 }
triple = ->(x) { x * 3 }  # Shorthand syntax
triple.call(5)           # => 15
triple.(5)               # => 15 (alternative syntax)

# Key difference: Proc is lenient, lambda is strict
prc = Proc.new { |a, b| [a, b] }
prc.call(1)              # => [1, nil] (no error)

lam = lambda { |a, b| [a, b] }
# lam.call(1)            # => ArgumentError

# Blocks as closures
def with_timer
  start = Time.now
  result = yield          # Execute the passed block
  elapsed = Time.now - start
  puts "Completed in #{elapsed}s"
  result
end

with_timer do
  sleep(0.1)
  "done"
end
```

## Mixins (Modules)

```ruby
# Modules provide mixins (multiple inheritance alternative)
module Timestampable
  def created_at
    @created_at ||= Time.now
  end

  def time_since_creation
    Time.now - created_at
  end
end

module Validatable
  def valid?
    errors.empty?
  end

  def errors
    @errors ||= []
  end

  def validate_presence(field)
    errors << "#{field} can't be blank" if send(field).nil?
  end
end

class User
  include Timestampable  # Instance methods
  include Validatable

  attr_accessor :name, :email

  def initialize(name, email)
    @name = name
    @email = email
    validate_presence(:name)
    validate_presence(:email)
  end
end
```

## Metaprogramming

```ruby
# Dynamic method definition
class DynamicClass
  def self.define_accessor(name)
    define_method(name) do
      instance_variable_get("@#{name}")
    end
    define_method("#{name}=") do |value|
      instance_variable_set("@#{name}", value)
    end
  end

  define_accessor :name
  define_accessor :age
end

obj = DynamicClass.new
obj.name = "Alice"
obj.name              # => "Alice"

# method_missing — intercept undefined methods
class Flexible
  def method_missing(method_name, *args)
    if method_name.to_s.start_with?("get_")
      attr = method_name.to_s[4..]
      instance_variable_get("@#{attr}") || "undefined"
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.start_with?("get_") || super
  end
end

f = Flexible.new
f.instance_variable_set(:@name, "Bob")
f.get_name            # => "Blank"

# Class methods with method_missing
class DataMapper
  def self.method_missing(method_name, *args)
    if method_name.to_s.start_with?("find_by_")
      field = method_name.to_s[8..]
      puts "SELECT * FROM users WHERE #{field} = '#{args[0]}'"
    else
      super
    end
  end
end

DataMapper.find_by_email("alice@test.com")
# SELECT * FROM users WHERE email = 'alice@test.com'
```

## DSL Patterns

```ruby
# Ruby's syntax enables elegant DSLs
class Pipeline
  attr_reader :steps

  def initialize
    @steps = []
  end

  def step(name, &block)
    @steps << { name: name, action: block }
  end

  def execute(input)
    @steps.reduce(input) do |data, step|
      puts "Executing: #{step[:name]}"
      step[:action].call(data)
    end
  end
end

# DSL-like usage
pipeline = Pipeline.new
pipeline.step("Clean") { |data| data.strip }
pipeline.step("Parse") { |data| data.split(",") }
pipeline.step("Transform") { |data| data.map(&:to_i) }
pipeline.step("Sum") { |data| data.sum }

result = pipeline.execute("  1,2,3,4,5  ")
puts result  # => 15
```

## Iterators

```ruby
# Ruby excels at block-based iteration
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# Select elements
evens = numbers.select(&:even?)           # [2, 4, 6, 8, 10]

# Map elements
squares = numbers.map { |n| n ** 2 }     # [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]

# Reduce/fold
sum = numbers.reduce(0, :+)              # 55
product = numbers.reduce(1, :*)          # 3628800

# Partition
even, odd = numbers.partition(&:even?)    # [[2,4,6,8,10], [1,3,5,7,9]]

# Find
first_large = numbers.find { |n| n > 7 } # 8

# Any/All
all_positive = numbers.all? { |n| n > 0 } # true
has_even = numbers.any?(&:even?)          # true

# Chaining
result = numbers
  .select(&:odd?)
  .map { |n| n * 3 }
  .reject { |n| n > 15 }
# => [3, 9, 15, 21]
```

## Demo

```ruby
# Complete demo: String analysis with Ruby's elegant syntax
def analyze_string(str)
  {
    length: str.length,
    word_count: str.split.length,
    char_frequency: str.chars.tally.sort_by { |_, v| -v }.to_h,
    reversed: str.reverse,
    is_palindrome: str.downcase.gsub(/[^a-z0-9]/, '') == str.downcase.gsub(/[^a-z0-9]/, '').reverse,
    contains_number: str.match?(/\d/),
    title_case: str.split.map(&:capitalize).join(' ')
  }
end

text = "Hello World from Ruby"
result = analyze_string(text)
result.each { |key, value| puts "#{key}: #{value}" }

# Elegant chaining example
puts " ".center(40, "=")
puts (1..100)
  .select { |n| (n % 3).zero? || (n % 5).zero? }
  .sum
  .to_s
```

## See Also

- [[Ruby/README|Ruby Overview]]
- [[Ruby/Basics/ruby-basics-tutorial|Ruby Basics Tutorial]]
- [[Ruby/OOP/oop|Ruby Object-Oriented Programming]]
- [[Ruby/Algorithms/String/string_algorithms|String Algorithms in Ruby]]
