# PHP Syntax

## Overview

PHP has evolved significantly since its inception as a templating language. Modern PHP (8.0+) features a robust type system, named arguments, attributes, enums, and a JIT compiler. PHP uses the `$` sigil for variables, `->` for object access, and `::` for static access.

## Variables and Types

```php
<?php
// Variables start with $
$name = "Alice";           // string
$age = 30;                 // integer
$pi = 3.14159;             // float
$isValid = true;           // boolean
$nothing = null;           // null

// Type declarations (PHP 7.4+)
int $count = 42;
string $label = "PHP 8";
float $price = 19.99;
array $items = [1, 2, 3];

// Constants
const MAX_SIZE = 100;
define('APP_NAME', 'MyApp');

// Type checking
var_dump($name);           // string(5) "Alice"
echo gettype($age);        // "integer"
is_string($name);          // true
```

## Arrays

```php
<?php
// Indexed arrays
$colors = ["red", "green", "blue"];
echo $colors[0];  // "red"

// Associative arrays
$person = [
    "name" => "Bob",
    "age" => 25,
    "city" => "New York"
];
echo $person["name"];  // "Bob"

// Multidimensional arrays
$matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
];

// Array functions
$nums = [3, 1, 4, 1, 5, 9, 2, 6];
sort($nums);                    // In-place sort
$reversed = array_reverse($nums);
$unique = array_unique([1, 1, 2, 3]); // [1, 2, 3]
$merged = array_merge([1, 2], [3, 4]); // [1, 2, 3, 4]

// Spread operator (PHP 7.4+)
$front = [1, 2];
$back = [3, 4];
$all = [...$front, ...$back]; // [1, 2, 3, 4]

// Destructuring
[$a, $b, $c] = [10, 20, 30];
["name" => $n, "age" => $a] = ["name" => "Eve", "age" => 28];
```

## Strings

```php
<?php
// String literals
$single = 'This is raw text, no $interpolation';
$double = "Hello, $name!";  // Variable interpolation
$heredoc = <<<EOT
Multi-line string
with $variable interpolation
EOT;

// String functions
strlen("Hello");              // 5
strtolower("HELLO");          // "hello"
strtoupper("hello");          // "HELLO"
substr("Hello World", 0, 5); // "Hello"
strpos("Hello World", "World"); // 6
str_replace("World", "PHP", "Hello World"); // "Hello PHP"
explode(",", "a,b,c");       // ["a", "b", "c"]
implode("-", ["a", "b"]);    // "a-b"
trim("  hello  ");           // "hello"

// Multibyte strings (UTF-8 safe)
mb_strlen("你好世界");        // 4
mb_substr("Hello 你好", 6);  // "你好"

// String formatting
echo sprintf("Hello, %s! You are %d.", "Alice", 30);
echo number_format(1234567.89, 2, '.', ','); // "1,234,567.89"
```

## Functions

```php
<?php
// Basic function with type declarations (PHP 7+)
function add(int $a, int $b): int {
    return $a + $b;
}

// Default parameters
function greet(string $name, string $greeting = "Hello"): string {
    return "$greeting, $name!";
}

// Named arguments (PHP 8.0+)
echo greet(name: "Bob", greeting: "Hi");

// Variadic functions
function sum(int ...$numbers): int {
    return array_sum($numbers);
}
echo sum(1, 2, 3, 4); // 10

// Union types (PHP 8.0+)
function formatId(int|string $id): string {
    return "ID: $id";
}

// Return type declarations
function divide(float $a, float $b): float|int|false {
    if ($b == 0) return false;
    return $a / $b;
}

// First-class callables (PHP 8.1+)
$fn = strlen(...);
echo $fn("Hello"); // 5
```

## Classes

```php
<?php
class User {
    // Constructor promotion (PHP 8.0+)
    public function __construct(
        public string $name,
        public string $email,
        private int $age
    ) {}

    public function getAge(): int {
        return $this->age;
    }

    // Readonly properties (PHP 8.1+)
    public readonly string $createdAt;

    public function __construct(
        public string $name,
        string $createdAt
    ) {
        $this->createdAt = $createdAt;
    }

    // Magic methods
    public function __toString(): string {
        return "{$this->name} <{$this->email}>";
    }

    public function __get(string $prop): mixed {
        return match($prop) {
            'age' => $this->age,
            default => null,
        };
    }
}

$user = new User("Alice", "alice@example.com", 30);
echo $user->name;   // "Alice"
echo $user;          // "Alice <alice@example.com>"
```

## Traits

```php
<?php
// Traits provide horizontal code reuse
trait Loggable {
    public function log(string $message): void {
        echo "[" . date('Y-m-d') . "] $message\n";
    }
}

trait Cacheable {
    private array $cache = [];

    public function cacheGet(string $key): mixed {
        return $this->cache[$key] ?? null;
    }

    public function cacheSet(string $key, mixed $value): void {
        $this->cache[$key] = $value;
    }
}

class ProductService {
    use Loggable, Cacheable;

    public function findProduct(int $id): ?array {
        $cached = $this->cacheGet("product_$id");
        if ($cached) return $cached;

        $this->log("Fetching product $id");
        // ... database query
        $product = ['id' => $id, 'name' => "Widget"];
        $this->cacheSet("product_$id", $product);
        return $product;
    }
}
```

## Namespaces and Autoloading

```php
<?php
// Namespaces organize code and prevent name collisions
namespace App\Models;

use App\Traits\HasTimestamps;

class Post {
    use HasTimestamps;

    public function __construct(
        public string $title,
        public string $body
    ) {}
}

// Using PSR-4 autoloading with Composer
// composer.json:
// {
//     "autoload": {
//         "psr-4": {
//             "App\\": "src/"
//         }
//     }
// }
// Classes in src/ are auto-loaded by namespace
```

## Error Handling

```php
<?php
// Try-catch-finally
try {
    $data = json_decode($json, true, 512, JSON_THROW_ON_ERROR);
    if ($data === null) {
        throw new InvalidArgumentException("Invalid JSON");
    }
} catch (InvalidArgumentException $e) {
    echo "Invalid data: " . $e->getMessage();
} catch (Throwable $e) {
    echo "Unexpected error: " . $e->getMessage();
} finally {
    cleanup();
}

// Custom exceptions
class ValidationException extends RuntimeException {
    public function __construct(
        public readonly array $errors
    ) {
        parent::__construct("Validation failed");
    }
}

// Error levels (PHP 8.0+)
// E_USER_ERROR, E_USER_WARNING, E_USER_NOTICE
// throw new Error() for fatal errors
// throw new Exception() for catchable errors
```

## Enums (PHP 8.1+)

```php
<?php
// Backed enums
enum Status: string {
    case Active = 'active';
    case Inactive = 'inactive';
    case Pending = 'pending';
}

function getStatus(): Status {
    return Status::Active;
}

echo getStatus()->value; // "active"

// Enum with methods
enum Color: string {
    case Red = 'red';
    case Green = 'green';
    case Blue = 'blue';

    public function label(): string {
        return match($this) {
            self::Red => 'Red',
            self::Green => 'Green',
            self::Blue => 'Blue',
        };
    }
}
```

## Composer

```bash
# Initialize a project
composer init

# Install dependencies
composer require laravel/framework
composer require --dev phpunit/phpunit

# Auto-load classes
require 'vendor/autoload.php';

# Define scripts
# composer.json
{
    "scripts": {
        "test": "phpunit",
        "lint": "phpcs src/"
    }
}
```

## Demo

```php
<?php
// Complete demo: String reversal and palindrome check
function reverseString(string $str): string {
    $reversed = '';
    $length = mb_strlen($str);
    for ($i = $length - 1; $i >= 0; $i--) {
        $reversed .= mb_substr($str, $i, 1);
    }
    return $reversed;
}

function isPalindrome(string $str): bool {
    $clean = preg_replace('/[^a-zA-Z0-9]/', '', strtolower($str));
    return $clean === reverseString($clean);
}

function countWords(string $str): int {
    return count(preg_split('/\s+/', trim($str)));
}

// Demo usage
$text = "racecar";
echo "Reversed: " . reverseString($text) . "\n";     // "racecar"
echo "Is palindrome: " . (isPalindrome($text) ? 'Yes' : 'No') . "\n"; // "Yes"

$sentence = "Hello World from PHP";
echo "Word count: " . countWords($sentence) . "\n";   // 4
echo "Is palindrome: " . (isPalindrome($sentence) ? 'Yes' : 'No') . "\n"; // "No"
```

## See Also

- [[PHP/README|PHP Overview]]
- [[PHP/Basics/php-basics-tutorial|PHP Basics Tutorial]]
- [[PHP/OOP/oop|PHP Object-Oriented Programming]]
- [[PHP/Algorithms/String/string_algorithms|String Algorithms in PHP]]
