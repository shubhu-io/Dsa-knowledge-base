# PHP Introduction

## Why Learn PHP?
PHP is a server-side scripting language designed for web development. It powers over 78% of websites, including WordPress, Facebook, and Wikipedia.

## Key Features
- **Web-Focused**: Built for server-side development
- **Easy to Learn**: Simple syntax for beginners
- **Huge Ecosystem**: Massive library of frameworks and CMS
- **Database Integration**: Excellent SQL support
- **Cross-Platform**: Runs on Windows, macOS, Linux
- **Large Community**: Extensive documentation and support
- **Fast Execution**: Optimized for web applications
- **WordPress**: Powers 43% of the web

## Getting Started

### Installation
1. Install via XAMPP, WAMP, or MAMP
2. Or download from php.net
3. Verify: `php --version`

### First Program
```php
<?php
echo "Hello, World!";
?>
```

Save as `hello.php` and run with `php hello.php` or access via web server

## Basic Syntax

### Variables and Data Types
```php
// Variables (start with $)
$name = "Alice";
$age = 30;
$height = 5.5;
$is_student = true;

// Constants
define('PI', 3.14159);
const MAX_SIZE = 100;

// String interpolation
$greeting = "Hello, $name!";
$greeting = "Hello, {$name}!";

// Heredoc (multi-line)
$paragraph = <<<TEXT
This is a
multi-line string
TEXT;

// Nowdoc (no interpolation)
$raw = <<<'TEXT'
This is $name literally
TEXT;
```

### Input/Output
```php
// Output
echo "Hello, World!";
print("Hello!");
var_dump($variable);
print_r($array);

// Input (from form)
$username = $_POST['username'];

// Input (from URL)
$id = $_GET['id'];
```

### Control Flow
```php
// If-else
if ($age >= 18) {
    echo "Adult";
} elseif ($age >= 13) {
    echo "Teenager";
} else {
    echo "Child";
}

// Alternative syntax (for templates)
if ($age >= 18):
    echo "Adult";
else:
    echo "Minor";
endif;

// Switch
switch ($day) {
    case "Monday":
        echo "Start of week";
        break;
    case "Friday":
        echo "Almost weekend";
        break;
    default:
        echo "Midweek";
}

// Match expression (PHP 8+)
$result = match($day) {
    "Monday" => "Start of week",
    "Friday" => "Almost weekend",
    default => "Midweek",
};

// For loop
for ($i = 0; $i < 5; $i++) {
    echo $i;
}

// While loop
$count = 5;
while ($count > 0) {
    $count--;
}

// Do-while
do {
    echo $count;
    $count++;
} while ($count < 5);

// Foreach
$numbers = [1, 2, 3, 4, 5];
foreach ($numbers as $number) {
    echo $number;
}

// Foreach with key
$person = ["name" => "Alice", "age" => 30];
foreach ($person as $key => $value) {
    echo "$key: $value";
}
```

### Functions
```php
// Basic function
function add($a, $b) {
    return $a + $b;
}

// Type hints
function multiply(float $a, float $b): float {
    return $a * $b;
}

// Default parameters
function greet(string $name, string $greeting = "Hello"): string {
    return "$greeting, $name!";
}

// Variable arguments
function sum(...$numbers): int {
    return array_sum($numbers);
}

// Return type declarations
function getPerson(): array {
    return ["name" => "Alice", "age" => 30];
}

// Arrow functions (PHP 7.4+)
$square = fn($x) => $x * $x;
$add = fn($a, $b) => $a + $b;

// Closures
$greet = function($name) {
    return "Hello, $name!";
};

// Built-in functions
$upper = strtoupper("hello");
$length = strlen("hello");
$parts = explode(",", "one,two,three");
$joined = implode("-", ["a", "b", "c"]);
```

### Classes
```php
// Basic class
class Person {
    public $name;
    public $age;

    public function __construct(string $name, int $age) {
        $this->name = $name;
        $this->age = $age;
    }

    public function greet(): string {
        return "Hello, I'm {$this->name}";
    }

    public function __toString(): string {
        return "{$this->name}, {$this->age} years old";
    }
}

// Inheritance
class Student extends Person {
    public string $grade;

    public function __construct(string $name, int $age, string $grade) {
        parent::__construct($name, $age);
        $this->grade = $grade;
    }

    public function greet(): string {
        return parent::greet() . ", and I'm a student";
    }
}

// Abstract class
abstract class Shape {
    abstract public function area(): float;
    abstract public function perimeter(): float;

    public function describe(): string {
        return "Area: {$this->area()}, Perimeter: {$this->perimeter()}";
    }
}

class Circle extends Shape {
    public function __construct(private float $radius) {}

    public function area(): float {
        return M_PI * $this->radius ** 2;
    }

    public function perimeter(): float {
        return 2 * M_PI * $this->radius;
    }
}

// Interface
interface Drawable {
    public function draw(): void;
}

class Rectangle implements Drawable {
    public function draw(): void {
        echo "Drawing rectangle";
    }
}

// Traits
trait Loggable {
    public function log(string $message): void {
        echo date('Y-m-d H:i:s') . ": $message\n";
    }
}

class User {
    use Loggable;
}
```

### Magic Methods
```php
class Dynamic {
    private $data = [];

    // Property access
    public function __get(string $name) {
        return $this->data[$name] ?? null;
    }

    public function __set(string $name, $value): void {
        $this->data[$name] = $value;
    }

    // Method call
    public function __call(string $name, array $args) {
        echo "Calling $name with " . implode(", ", $args);
    }

    // Object conversion
    public function __toString(): string {
        return json_encode($this->data);
    }

    // Serialization
    public function __serialize(): array {
        return $this->data;
    }

    public function __unserialize(array $data): void {
        $this->data = $data;
    }
}
```

### Error Handling
```php
// Try-catch
try {
    $result = 10 / 0;
} catch (DivisionByZeroError $e) {
    echo "Error: " . $e->getMessage();
} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
} finally {
    echo "Always runs";
}

// Custom exceptions
class ValidationException extends Exception {
    public function __construct(string $field, string $message) {
        parent::__construct("$field: $message");
    }
}

function validateAge(int $age): void {
    if ($age < 0) {
        throw new ValidationException("age", "Must be positive");
    }
}

// Error handling with set_error_handler
set_error_handler(function(int $errno, string $errstr) {
    throw new Exception("$errstr ($errno)");
});
```

### Namespaces and Autoloading
```php
// Namespace declaration
namespace App\Models;

class User {
    // ...
}

// Importing
use App\Models\User;
use App\Helpers\{StringHelper, ArrayHelper};

// Composer autoloading
require 'vendor/autoload.php';
```

### Generators
```php
// Generator function
function range_gen(int $start, int $end): Generator {
    for ($i = $start; $i <= $end; $i++) {
        yield $i;
    }
}

// Usage
foreach (range_gen(1, 1000000) as $number) {
    echo $number;
    if ($number > 10) break;
}

// Generator with key
function fibonacci(): Generator {
    $a = 0;
    $b = 1;
    while (true) {
        yield $a;
        [$a, $b] = [$b, $a + $b];
    }
}
```

### Modern PHP Features
```php
// Named arguments (PHP 8+)
function createUser(string $name, int $age, string $email): User {
    // ...
}
createUser(name: "Alice", age: 30, email: "alice@example.com");

// Match expression (PHP 8+)
$result = match($statusCode) {
    200 => "OK",
    404 => "Not Found",
    500 => "Server Error",
    default => "Unknown",
};

// Union types (PHP 8+)
function process(int|string $value): void {
    // ...
}

// Null safe operator (PHP 8+)
$country = $user?->address?->country;

// Enums (PHP 8.1+)
enum Status: string {
    case Active = "active";
    case Inactive = "inactive";
    case Pending = "pending";
}

// Fibers (PHP 8.1+)
$fiber = new Fiber(function(): void {
    $value = Fiber::suspend("fiber started");
    echo "Fiber resumed with: $value";
});

$result = $fiber->start();
$fiber->resume("hello");
```

## Best Practices
1. Always use type declarations
2. Follow PSR coding standards
3. Use strict types: `declare(strict_types=1);`
4. Handle errors with try-catch
5. Use Composer for dependencies
6. Write tests with PHPUnit
7. Follow SOLID principles

## Common Pitfalls
- Not using strict types
- Forgetting to close PHP tags in pure PHP files
- Not sanitizing user input
- Using `==` instead of `===`
- Not handling null values
- Mixing PHP and HTML too much