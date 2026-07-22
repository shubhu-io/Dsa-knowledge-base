# Ruby Introduction

## Why Learn Ruby?
Ruby is a dynamic, object-oriented language designed for simplicity and productivity. It's the language behind Ruby on Rails, one of the most popular web frameworks.

## Key Features
- **Everything is an Object**: Pure object-oriented language
- **Elegant Syntax**: Readable, English-like code
- **Dynamic Typing**: No type declarations needed
- **Garbage Collection**: Automatic memory management
- **Rich Ecosystem**: Gems (packages) for everything
- **Metaprogramming**: Code that writes code
- **Rails Framework**: Rapid web development
- **Community**: Friendly, welcoming community

## Getting Started

### Installation
1. Install via rbenv or RVM
2. Or download from ruby-lang.org
3. Verify: `ruby --version`

### First Program
```ruby
puts "Hello, World!"
```

Save as `hello.rb` and run with `ruby hello.rb`

## Basic Syntax

### Variables and Data Types
```ruby
# Variables (snake_case convention)
name = "Alice"
age = 30
height = 5.5
is_student = true

# Symbols (immutable, interned strings)
status = :active
role = :admin

# Constants
PI = 3.14159
MAX_SIZE = 100

# String interpolation
greeting = "Hello, #{name}!"

# Multi-line strings
paragraph = <<~TEXT
  This is a
  multi-line string
TEXT
```

### Input/Output
```ruby
# Output
puts "Hello, World!"
print "No newline"
$stdout.flush

# Input
print "Enter your name: "
name = gets.chomp
puts "Hello, #{name}!"
```

### Control Flow
```ruby
# If-else
if age >= 18
  puts "Adult"
elsif age >= 13
  puts "Teenager"
else
  puts "Child"
end

# Unless (opposite of if)
unless age >= 18
  puts "Minor"
end

# Ternary operator
status = age >= 18 ? "Adult" : "Minor"

# Case (like switch)
case day
when "Monday"
  puts "Start of week"
when "Friday"
  puts "Almost weekend"
when "Saturday", "Sunday"
  puts "Weekend"
else
  puts "Midweek"
end

# For loop
for i in 0..5
  puts i
end

# Times loop
5.times do |i|
  puts i
end

# Each loop
[1, 2, 3, 4, 5].each do |num|
  puts num
end

# While loop
count = 5
while count > 0
  count -= 1
end

# Until loop
count = 0
until count >= 5
  count += 1
end
```

### Methods
```ruby
# Basic method
def add(a, b)
  a + b  # Last expression is return value
end

# Method with default parameters
def greet(name, greeting = "Hello")
  "#{greeting}, #{name}!"
end

# Method with keyword arguments
def create_user(name:, age:, email: nil)
  { name: name, age: age, email: email }
end

# Variable arguments
def sum(*numbers)
  numbers.reduce(0, :+)
end

# Block and yield
def twice
  yield
  yield
end

twice { puts "Hello!" }

# Method with block
def each_with_index(array)
  array.each_with_index do |value, index|
    yield(value, index)
  end
end

# Lambda/Proc
square = ->(x) { x * x }
puts square.call(5)

# Method as argument
def apply(value, &block)
  block.call(value)
end

puts apply(5) { |x| x * 2 }
```

### Classes
```ruby
# Basic class
class Person
  attr_accessor :name, :age

  def initialize(name, age)
    @name = name
    @age = age
  end

  def greet
    "Hello, I'm #{@name}"
  end

  def to_s
    "#{@name}, #{@age} years old"
  end
end

# Inheritance
class Student < Person
  attr_accessor :grade

  def initialize(name, age, grade)
    super(name, age)
    @grade = grade
  end

  def greet
    "#{super}, and I'm a student"
  end
end

# Access modifiers
class BankAccount
  def initialize(balance)
    @balance = balance
  end

  public
  def deposit(amount)
    @balance += amount
  end

  protected
  def balance
    @balance
  end

  private
  def validate_amount(amount)
    amount > 0
  end
end
```

### Modules
```ruby
# Module (namespace + mixin)
module MathHelper
  PI = 3.14159

  def self.circle_area(radius)
    PI * radius ** 2
  end
end

# Include mixin
module Greetable
  def greet
    "Hello, I'm #{name}"
  end
end

class Person
  include Greetable
end

# Extend mixin
class MathClass
  extend MathHelper
end
```

### Collections
```ruby
# Arrays
numbers = [1, 2, 3, 4, 5]
numbers.push(6)
numbers.pop
numbers.first
numbers.last

# Hash
person = {
  name: "Alice",
  age: 30,
  email: "alice@example.com"
}

person[:name]  # Access
person[:phone] = "123-456-7890"  # Add/Update

# Common array methods
doubled = numbers.map { |n| n * 2 }
evens = numbers.select { |n| n.even? }
odds = numbers.reject { |n| n.even? }
sum = numbers.reduce(0, :+)
found = numbers.find { |n| n > 3 }
sorted = numbers.sort
flattened = [[1, 2], [3, 4]].flatten

# Hash methods
person.each { |key, value| puts "#{key}: #{value}" }
names = people.map { |p| p[:name] }
```

### Blocks and Iterators
```ruby
# Block syntax
5.times { |i| puts i }

# Do-end for multi-line
[1, 2, 3].each do |num|
  puts num * 2
end

# Yield
def with_logging
  puts "Starting..."
  yield
  puts "Finished!"
end

with_logging { puts "Doing work" }

# Proc and Lambda
square = Proc.new { |x| x ** 2 }
cube = ->(x) { x ** 3 }

[1, 2, 3].map(&square)
[1, 2, 3].map(&cube)
```

### Error Handling
```ruby
# Begin-rescue
begin
  result = 10 / 0
rescue ZeroDivisionError => e
  puts "Error: #{e.message}"
rescue StandardError => e
  puts "Other error: #{e.message}"
ensure
  puts "Always runs"
end

# Custom exceptions
class ValidationError < StandardError
  def initialize(message)
    super(message)
  end
end

def validate_age(age)
  raise ValidationError, "Age must be positive" if age < 0
end

# Retry
def fetch_with_retry(url, max_attempts = 3)
  attempts = 0
  begin
    attempts += 1
    # Fetch data
  rescue => e
    retry if attempts < max_attempts
    raise
  end
end
```

### Metaprogramming
```ruby
# Dynamic method definition
class Person
  define_method(:greet) do |greeting|
    "#{greeting}, I'm #{name}!"
  end
end

# Method missing
class DynamicFinder
  def method_missing(method_name, *args)
    if method_name.to_s.start_with?("find_by_")
      field = method_name.to_s.sub("find_by_", "")
      puts "Finding by #{field}: #{args.first}"
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.start_with?("find_by_") || super
  end
end

# eval and instance_eval
class_eval("def name; 'Alice'; end")
```

## Best Practices
1. Use snake_case for methods and variables
2. Use CamelCase for classes and modules
3. Prefer blocks over Procs when possible
4. Use symbols for hash keys and method names
5. Leverage Ruby's expressive one-liners
6. Write self-documenting code
7. Use modules for mixins over multiple inheritance

## Common Pitfalls
- Confusing `=` (assignment), `==` (equality), and `===` (case equality)
- Not understanding block scoping
- Overusing metaprogramming
- Ignoring Ruby style guide
- Not using `freeze` for immutable strings