# Ruby Basics Tutorial

## Variables and Constants

```ruby
# Variables (snake_case)
name = "Alice"
age = 30
height = 5.5
is_student = true

# Symbols
status = :active

# Constants
PI = 3.14159

# String interpolation
greeting = "Hello, #{name}!"
```

## Data Types

- **String**: Text
- **Integer/Float**: Numbers
- **Boolean**: true/false
- **Symbol**: Immutable identifiers
- **Array**: Ordered collection
- **Hash**: Key-value pairs
- **Nil**: Null value

## Control Flow

### If-Else
```ruby
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
```

### Case
```ruby
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
```

### Loops
```ruby
# Times loop
5.times { |i| puts i }

# Each loop
[1, 2, 3].each { |num| puts num }

# While loop
count = 5
while count > 0
  count -= 1
end
```

## Methods

```ruby
# Basic method
def add(a, b)
  a + b
end

# Default parameters
def greet(name, greeting = "Hello")
  "#{greeting}, #{name}!"
end

# Variable arguments
def sum(*numbers)
  numbers.reduce(0, :+)
end

# Lambda
square = ->(x) { x * x }
puts square.call(5)
```

## Classes

```ruby
class Person
  attr_accessor :name, :age

  def initialize(name, age)
    @name = name
    @age = age
  end

  def greet
    "Hello, I'm #{@name}"
  end
end

# Inheritance
class Student < Person
  def greet
    "#{super}, and I'm a student"
  end
end
```

## Modules

```ruby
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
```

## Collections

```ruby
# Arrays
numbers = [1, 2, 3, 4, 5]
numbers.push(6)
numbers.map { |n| n * 2 }

# Hash
person = { name: "Alice", age: 30 }
person[:name]
person[:email] = "alice@example.com"
```

## Blocks and Iterators

```ruby
5.times { |i| puts i }

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
```

## Error Handling

```ruby
begin
  result = 10 / 0
rescue ZeroDivisionError => e
  puts "Error: #{e.message}"
ensure
  puts "Always runs"
end
```

## Best Practices

1. Use snake_case for methods and variables
2. Use CamelCase for classes
3. Prefer blocks over Procs
4. Use symbols for hash keys
5. Leverage Ruby's expressive one-liners