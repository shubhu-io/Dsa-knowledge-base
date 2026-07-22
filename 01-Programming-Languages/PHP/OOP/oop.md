# PHP Object-Oriented Programming

## Overview

PHP has evolved into a full-featured OOP language with classes, interfaces, abstract classes, traits, enums, and advanced features like constructor promotion, readonly properties, and named arguments. PHP's OOP model supports encapsulation, inheritance, polymorphism, and multiple inheritance through traits.

## Classes and Objects

```php
<?php
class User {
    // Constructor promotion (PHP 8.0+)
    public function __construct(
        public string $name,
        public readonly string $email,
        private int $age
    ) {}

    public function getAge(): int {
        return $this->age;
    }

    public function setAge(int $age): void {
        if ($age < 0 || $age > 150) {
            throw new InvalidArgumentException("Invalid age: $age");
        }
        $this->age = $age;
    }

    // Readonly properties (PHP 8.1+)
    public readonly string $createdAt;

    public function __construct(
        public string $name,
        string $createdAt
    ) {
        $this->createdAt = $createdAt;
    }

    // String representation
    public function __toString(): string {
        return "{$this->name} <{$this->email}>";
    }
}

$user = new User("Alice", "alice@example.com");
echo $user->name;   // "Alice"
echo $user;          // "Alice <alice@example.com>"
```

## Interfaces

```php
<?php
// Interfaces define contracts that classes must fulfill
interface Serializable {
    public function serialize(): string;
    public static function deserialize(string $data): static;
}

interface Validatable {
    public function validate(): bool;
    public function errors(): array;
}

// Interface with default implementation (PHP 8.0+)
interface LoggerInterface {
    public function log(string $message): void;

    // Default method
    public function logInfo(string $message): void {
        $this->log("[INFO] $message");
    }

    public function logError(string $message): void {
        $this->log("[ERROR] $message");
    }
}

class UserService implements Serializable, Validatable, LoggerInterface {
    public function __construct(
        private string $name
    ) {}

    public function serialize(): string {
        return json_encode(['name' => $this->name]);
    }

    public static function deserialize(string $data): static {
        $decoded = json_decode($data, true);
        return new static($decoded['name']);
    }

    public function validate(): bool {
        return !empty($this->name);
    }

    public function errors(): array {
        return $this->validate() ? [] : ['Name is required'];
    }

    public function log(string $message): void {
        echo "$message\n";
    }
}
```

## Abstract Classes

```php
<?php
// Abstract classes can have both abstract and concrete methods
abstract class Shape {
    protected float $x;
    protected float $y;

    public function __construct(float $x = 0, float $y = 0) {
        $this->x = $x;
        $this->y = $y;
    }

    // Abstract methods must be implemented by subclasses
    abstract public function area(): float;
    abstract public function perimeter(): float;
    abstract public function type(): string;

    // Concrete methods shared by all shapes
    public function position(): string {
        return "({$this->x}, {$this->y})";
    }

    public function describe(): string {
        return "{$this->type()} at {$this->position()}: " .
               "area={$this->area()}, perimeter={$this->perimeter()}";
    }
}

class Circle extends Shape {
    public function __construct(
        float $x,
        float $y,
        private float $radius
    ) {
        parent::__construct($x, $y);
    }

    public function area(): float {
        return M_PI * $this->radius ** 2;
    }

    public function perimeter(): float {
        return 2 * M_PI * $this->radius;
    }

    public function type(): string {
        return "Circle";
    }
}
```

## Traits

```php
<?php
// Traits provide horizontal code reuse (multiple inheritance)
trait Timestampable {
    private ?string $createdAt = null;
    private ?string $updatedAt = null;

    public function setCreatedAt(): void {
        $this->createdAt = date('Y-m-d H:i:s');
    }

    public function setUpdatedAt(): void {
        $this->updatedAt = date('Y-m-d H:i:s');
    }

    public function getCreatedAt(): ?string {
        return $this->createdAt;
    }
}

trait SoftDeletable {
    private ?string $deletedAt = null;

    public function softDelete(): void {
        $this->deletedAt = date('Y-m-d H:i:s');
    }

    public function restore(): void {
        $this->deletedAt = null;
    }

    public function isDeleted(): bool {
        return $this->deletedAt !== null;
    }
}

trait Sluggable {
    public string $slug;

    public function generateSlug(string $field): void {
        $this->slug = strtolower(trim(preg_replace('/[^A-Za-z0-9-]+/', '-', $this->$field), '-'));
    }
}

// Using multiple traits
class Post {
    use Timestampable, SoftDeletable, Sluggable;

    public function __construct(
        public string $title,
        public string $content
    ) {
        $this->setCreatedAt();
        $this->generateSlug('title');
    }
}
```

## Late Static Binding

```php
<?php
// Late static binding resolves to the calling class
class Model {
    protected static string $table;

    public static function find(int $id): static {
        // 'static' refers to the calling class, not the defining class
        echo "Finding from " . static::$table . " where id=$id\n";
        return new static();
    }

    public static function create(array $data): static {
        echo "Creating in " . static::$table . "\n";
        return new static();
    }
}

class User extends Model {
    protected static string $table = 'users';
}

class Post extends Model {
    protected static string $table = 'posts';
}

User::find(1);   // "Finding from users where id=1"
Post::find(5);   // "Finding from posts where id=5"
```

## Magic Methods

```php
<?php
class MagicClass {
    private array $data = [];

    // Called when accessing undefined properties
    public function __get(string $name): mixed {
        return $this->data[$name] ?? null;
    }

    // Called when setting undefined properties
    public function __set(string $name, mixed $value): void {
        $this->data[$name] = $value;
    }

    // Called when checking property existence
    public function __isset(string $name): bool {
        return isset($this->data[$name]);
    }

    // Called when unset() is used
    public function __unset(string $name): void {
        unset($this->data[$name]);
    }

    // Called when the object is used as a string
    public function __toString(): string {
        return json_encode($this->data);
    }

    // Called when the object is called as a function
    public function __invoke(string $key): mixed {
        return $this->data[$key] ?? null;
    }

    // Called for dynamic static method calls
    public static function __callStatic(string $name, array $args): mixed {
        echo "Static method '$name' called with: " . implode(', ', $args) . "\n";
    }

    // Called for undefined instance methods
    public function __call(string $name, array $args): mixed {
        echo "Method '$name' called with: " . implode(', ', $args) . "\n";
    }
}

$obj = new MagicClass();
$obj->name = "Alice";          // __set
echo $obj->name . "\n";        // __get
echo $obj . "\n";              // __toString
echo $obj('name') . "\n";      // __invoke
```

## Namespaces and Autoloading

```php
<?php
// PSR-4 Autoloading with Composer
// composer.json:
// {
//     "autoload": {
//         "psr-4": {
//             "App\\": "src/"
//         }
//     }
// }

namespace App\Models;

use App\Traits\HasTimestamps;

class User {
    use HasTimestamps;

    public function __construct(
        public string $name,
        public string $email
    ) {}
}

// Namespace organization
namespace App\Services;

use App\Models\User;

class UserService {
    public function create(string $name, string $email): User {
        return new User($name, $email);
    }
}
```

## Enums (PHP 8.1+)

```php
<?php
// Backed enums
enum Status: string {
    case Draft = 'draft';
    case Published = 'published';
    case Archived = 'archived';
}

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

    public function hex(): string {
        return match($this) {
            self::Red => '#FF0000',
            self::Green => '#00FF00',
            self::Blue => '#0000FF',
        };
    }
}

// Using enums
$status = Status::Published;
echo $status->value;  // "published"

// Enum in match
function getBadgeClass(Status $status): string {
    return match($status) {
        Status::Draft => 'badge-gray',
        Status::Published => 'badge-green',
        Status::Archived => 'badge-red',
    };
}
```

## Generics (via PHPDoc)

```php
<?php
/**
 * @template T
 */
class Collection {
    /** @var T[] */
    private array $items = [];

    /** @param T $item */
    public function add(mixed $item): void {
        $this->items[] = $item;
    }

    /** @return T[] */
    public function getAll(): array {
        return $this->items;
    }

    /** @param callable(T): bool $predicate
     *  @return T[] */
    public function filter(callable $predicate): array {
        return array_filter($this->items, $predicate);
    }
}

/** @var Collection<User> $users */
$users = new Collection();
$users->add(new User("Alice", "alice@test.com"));
```

## Demo

```php
<?php
// Shape hierarchy demonstrating PHP OOP features

// Interface
interface Drawable {
    public function draw(): string;
}

// Abstract class
abstract class Shape {
    abstract public function area(): float;
    abstract public function perimeter(): float;
    abstract public function type(): string;

    public function describe(): string {
        return sprintf(
            "%s: area=%.2f, perimeter=%.2f",
            $this->type(),
            $this->area(),
            $this->perimeter()
        );
    }
}

// Trait
trait Printable {
    public function printDescription(): void {
        echo $this->describe() . "\n";
    }
}

// Concrete classes
class Circle extends Shape implements Drawable {
    use Printable;

    public function __construct(private float $radius) {}

    public function area(): float {
        return M_PI * $this->radius ** 2;
    }

    public function perimeter(): float {
        return 2 * M_PI * $this->radius;
    }

    public function type(): string { return "Circle"; }
    public function draw(): string { return "Drawing circle r={$this->radius}"; }
}

class Rectangle extends Shape implements Drawable {
    use Printable;

    public function __construct(
        private float $width,
        private float $height
    ) {}

    public function area(): float {
        return $this->width * $this->height;
    }

    public function perimeter(): float {
        return 2 * ($this->width + $this->height);
    }

    public function type(): string { return "Rectangle"; }
    public function draw(): string { return "Drawing rect {$this->width}x{$this->height}"; }
}

// Usage
$shapes = [new Circle(5), new Rectangle(4, 6), new Circle(3)];
foreach ($shapes as $shape) {
    echo $shape->draw() . "\n";
    $shape->printDescription();
}
```

## See Also

- [[PHP/README|PHP Overview]]
- [[PHP/Basics/syntax|PHP Syntax]]
- [[PHP/OOP/classes|PHP Classes (code)]]
