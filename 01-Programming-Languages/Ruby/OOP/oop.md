# Ruby Object-Oriented Programming

## Overview

Ruby is a pure object-oriented language — everything is an object, including integers, booleans, and `nil`. Ruby supports classes, modules (mixins), open classes, and powerful metaprogramming. Unlike many languages, Ruby uses single inheritance with modules for code reuse, avoiding the diamond problem while maintaining flexibility.

## Classes

```ruby
# Basic class with attr_accessor
class User
  attr_accessor :name, :email
  attr_reader :created_at

  def initialize(name, email)
    @name = name
    @email = email
    @created_at = Time.now
  end

  def to_s
    "#{name} <#{email}>"
  end

  # Class method
  def self.create(name, email)
    new(name, email)
  end
end

user = User.new("Alice", "alice@test.com")
puts user  # "Alice <alice@test.com>"
```

## Inheritance

```ruby
class Animal
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def speak
    raise NotImplementedError, "#{self.class} must implement #speak"
  end

  def to_s
    "#{self.class}: #{name}"
  end
end

class Dog < Animal
  def speak
    "Woof!"
  end
end

class Cat < Animal
  def speak
    "Meow!"
  end
end

dog = Dog.new("Rex")
puts dog.speak  # "Woof!"
```

## Modules and Mixins

```ruby
# Modules as namespaces
module MathUtils
  PI = 3.14159

  def self.circle_area(radius)
    PI * radius ** 2
  end
end

# Modules as mixins (multiple inheritance alternative)
module Serializable
  def to_json
    JSON.generate(to_hash)
  end

  def to_hash
    instance_variables.each_with_object({}) do |var, hash|
      hash[var.to_s.delete('@').to_sym] = instance_variable_get(var)
    end
  end
end

module Validatable
  def valid?
    errors.empty?
  end

  def errors
    @errors ||= []
  end

  def validate(field, condition, message)
    errors << message unless condition
  end
end

# Multiple mixins
class User
  include Serializable
  include Validatable

  attr_accessor :name, :email

  def initialize(name, email)
    @name = name
    @email = email
    validate(:name, !name.nil? && !name.empty?, "Name is required")
    validate(:email, email&.match?(/@/), "Valid email is required")
  end
end
```

## Open Classes (Monkey Patching)

```ruby
# Ruby allows modifying existing classes at runtime
class String
  def palindrome?
    clean = downcase.gsub(/[^a-z0-9]/, '')
    clean == clean.reverse
  end

  def word_count
    split.length
  end

  def snakify
    gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
       .gsub(/([a-z\d])([A-Z])/, '\1_\2')
       .downcase
  end
end

"Hello World".palindrome?        # => false
"racecar".palindrome?            # => true
"Hello World".word_count         # => 2
"camelCase".snakify              # => "camel_case"
```

## Encapsulation

```ruby
class BankAccount
  # Public interface
  attr_reader :balance, :owner

  def initialize(owner, initial_balance = 0)
    @owner = owner
    @balance = initial_balance
    @transactions = []
  end

  def deposit(amount)
    validate_amount(amount)
    @balance += amount
    log_transaction(:deposit, amount)
    true
  end

  def withdraw(amount)
    validate_amount(amount)
    raise "Insufficient funds" if amount > @balance
    @balance -= amount
    log_transaction(:withdraw, amount)
    true
  end

  def statement
    @transactions.map { |t| "#{t[:type]}: #{t[:amount]}" }
  end

  private

  def validate_amount(amount)
    raise ArgumentError, "Amount must be positive" unless amount > 0
  end

  def log_transaction(type, amount)
    @transactions << { type: type, amount: amount, time: Time.now }
  end
end
```

## Polymorphism

```ruby
# Duck typing: if it quacks like a duck, it is a duck
class PDFExporter
  def export(data)
    "PDF: #{data}"
  end
end

class CSVExporter
  def export(data)
    "CSV: #{data}"
  end
end

class JSONExporter
  def export(data)
    "JSON: #{data}"
  end
end

# Any object that responds to #export works
def export_all(exporters, data)
  exporters.map { |e| e.export(data) }
end
```

## Metaprogramming

```ruby
# Dynamic method definition
class DynamicModel
  def self.field(name, type = :string)
    define_method(name) { instance_variable_get("@#{name}") }
    define_method("#{name}=") { |val| instance_variable_set("@#{name}", val) }

    # Type checking
    define_method("validate_#{name}") do
      val = send(name)
      case type
      when :string then val.is_a?(String)
      when :integer then val.is_a?(Integer)
      when :float then val.is_a?(Numeric)
      else true
      end
    end
  end

  field :name, :string
  field :age, :integer
  field :score, :float
end

obj = DynamicModel.new
obj.name = "Alice"
obj.age = 30
obj.validate_name  # => true
```

## method_missing

```ruby
class FlexibleModel
  def method_missing(method_name, *args)
    if method_name.to_s.start_with?("find_by_")
      field = method_name.to_s[8..]
      puts "SELECT * FROM model WHERE #{field} = '#{args[0]}'"
    elsif method_name.to_s.end_with?("=")
      field = method_name.to_s.chomp("=")
      instance_variable_set("@#{field}", args[0])
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.start_with?("find_by_") ||
    method_name.to_s.end_with?("=") ||
    super
  end
end
```

## DSLs with Ruby

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
      puts "  Executing: #{step[:name]}"
      step[:action].call(data)
    end
  end
end

pipeline = Pipeline.new
pipeline.step("Clean")  { |data| data.strip }
pipeline.step("Parse")  { |data| data.split(",") }
pipeline.step("Convert") { |data| data.map(&:to_i) }
pipeline.step("Sum")    { |data| data.sum }

result = pipeline.execute("  1,2,3,4,5  ")
puts "Result: #{result}"
```

## Demo

```ruby
# Complete demo: Shape hierarchy with modules and metaprogramming
module Drawable
  def draw
    "Drawing a #{self.class.name.downcase} with area #{area.round(2)}"
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
    "#{self.class.name}: area=#{area.round(2)}, perimeter=#{perimeter.round(2)}"
  end
end

class Shape
  include Drawable
  include Calculable

  def area
    raise NotImplementedError
  end

  def perimeter
    raise NotImplementedError
  end
end

class Circle < Shape
  def initialize(radius)
    @radius = radius
  end

  def area
    Math::PI * @radius ** 2
  end

  def perimeter
    2 * Math::PI * @radius
  end
end

class Rectangle < Shape
  def initialize(width, height)
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

# Usage
shapes = [Circle.new(5), Rectangle.new(4, 6)]
shapes.each { |s| puts s.summary }
```

## See Also

- [[Ruby/README|Ruby Overview]]
- [[Ruby/Basics/syntax|Ruby Syntax]]
- [[Ruby/OOP/classes|Ruby Classes (code)]]
