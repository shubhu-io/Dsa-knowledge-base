# PHP Basics Tutorial

## Variables and Constants

```php
<?php
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
?>
```

## Data Types

- **String**: Text
- **Integer/Float**: Numbers
- **Boolean**: true/false
- **Array**: Ordered collection
- **Object**: Class instances
- **NULL**: Null value

## Control Flow

### If-Else
```php
<?php
if ($age >= 18) {
    echo "Adult";
} elseif ($age >= 13) {
    echo "Teenager";
} else {
    echo "Minor";
}
?>
```

### Switch
```php
<?php
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
?>
```

### Loops
```php
<?php
// For loop
for ($i = 0; $i < 5; $i++) {
    echo $i;
}

// Foreach
$numbers = [1, 2, 3, 4, 5];
foreach ($numbers as $number) {
    echo $number;
}
?>
```

## Functions

```php
<?php
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

// Arrow functions
$square = fn($x) => $x * $x;
?>
```

## Classes

```php
<?php
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
}

// Inheritance
class Student extends Person {
    public string $grade;

    public function greet(): string {
        return parent::greet() . ", and I'm a student";
    }
}
?>
```

## Error Handling

```php
<?php
try {
    $result = 10 / 0;
} catch (DivisionByZeroError $e) {
    echo "Error: " . $e->getMessage();
} finally {
    echo "Always runs";
}
?>
```

## Best Practices

1. Always use type declarations
2. Follow PSR coding standards
3. Use strict types: `declare(strict_types=1);`
4. Handle errors with try-catch
5. Use Composer for dependencies