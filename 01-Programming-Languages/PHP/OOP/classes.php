<?php
/**
 * Shape Hierarchy in PHP
 *
 * Demonstrates PHP OOP features: abstract classes, interfaces,
 * traits, and concrete implementations.
 *
 * Run: php classes.php
 */

// ============================================================
// Interface: Defines contracts for shapes
// ============================================================
interface Drawable {
    public function draw(): string;
}

interface Resizable {
    public function resize(float $factor): void;
}

interface Comparable {
    public function compareTo(self $other): int;
}

// ============================================================
// Traits: Reusable behavior
// ============================================================
trait Timestampable {
    private string $createdAt;

    public function __constructTimestampable(): void {
        $this->createdAt = date('Y-m-d H:i:s');
    }

    public function getCreatedAt(): string {
        return $this->createdAt;
    }
}

trait Printable {
    public function printDescription(): void {
        echo $this->describe() . "\n";
    }
}

// ============================================================
// Abstract class: Common shape behavior
// ============================================================
abstract class Shape implements Drawable, Comparable {
    use Timestampable, Printable;

    protected float $x;
    protected float $y;
    protected string $color;

    public function __construct(float $x = 0, float $y = 0, string $color = "black") {
        $this->x = $x;
        $this->y = $y;
        $this->color = $color;
        $this->__constructTimestampable();
    }

    abstract public function area(): float;
    abstract public function perimeter(): float;
    abstract public function type(): string;

    public function position(): string {
        return "({$this->x}, {$this->y})";
    }

    public function describe(): string {
        return sprintf(
            "%s [%s] at %s: area=%.2f, perimeter=%.2f",
            $this->type(),
            $this->color,
            $this->position(),
            $this->area(),
            $this->perimeter()
        );
    }

    public function draw(): string {
        return "Drawing {$this->type()} at {$this->position()}";
    }

    public function compareTo(Shape $other): int {
        return $this->area() <=> $other->area();
    }
}

// ============================================================
// Concrete shapes
// ============================================================
class Circle extends Shape implements Resizable {
    private float $radius;

    public function __construct(
        float $radius,
        float $x = 0,
        float $y = 0,
        string $color = "black"
    ) {
        parent::__construct($x, $y, $color);
        $this->radius = $radius;
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

    public function radius(): float {
        return $this->radius;
    }

    public function resize(float $factor): void {
        $this->radius *= $factor;
    }

    public function draw(): string {
        return "Drawing circle r={$this->radius} at {$this->position()}";
    }
}

class Rectangle extends Shape implements Resizable {
    private float $width;
    private float $height;

    public function __construct(
        float $width,
        float $height,
        float $x = 0,
        float $y = 0,
        string $color = "black"
    ) {
        parent::__construct($x, $y, $color);
        $this->width = $width;
        $this->height = $height;
    }

    public function area(): float {
        return $this->width * $this->height;
    }

    public function perimeter(): float {
        return 2 * ($this->width + $this->height);
    }

    public function type(): string {
        return "Rectangle";
    }

    public function width(): float { return $this->width; }
    public function height(): float { return $this->height; }

    public function resize(float $factor): void {
        $this->width *= $factor;
        $this->height *= $factor;
    }
}

class Square extends Rectangle {
    public function __construct(
        float $side,
        float $x = 0,
        float $y = 0,
        string $color = "black"
    ) {
        parent::__construct($side, $side, $x, $y, $color);
    }

    public function type(): string {
        return "Square";
    }

    public function side(): float {
        return $this->width();
    }
}

class Triangle extends Shape {
    private float $a;
    private float $b;
    private float $c;

    public function __construct(
        float $a,
        float $b,
        float $c,
        float $x = 0,
        float $y = 0,
        string $color = "black"
    ) {
        parent::__construct($x, $y, $color);
        $this->a = $a;
        $this->b = $b;
        $this->c = $c;
    }

    public function area(): float {
        $s = ($this->a + $this->b + $this->c) / 2;
        return sqrt($s * ($s - $this->a) * ($s - $this->b) * ($s - $this->c));
    }

    public function perimeter(): float {
        return $this->a + $this->b + $this->c;
    }

    public function type(): string {
        return "Triangle";
    }
}

// ============================================================
// Shape collection using generics-like pattern
// ============================================================
class ShapeCollection {
    private array $shapes = [];

    public function add(Shape $shape): void {
        $this->shapes[] = $shape;
    }

    public function sortByArea(): array {
        $sorted = $this->shapes;
        usort($sorted, fn(Shape $a, Shape $b) => $a->compareTo($b));
        return $sorted;
    }

    public function totalArea(): float {
        return array_reduce($this->shapes, fn(float $sum, Shape $s) => $sum + $s->area(), 0.0);
    }

    public function all(): array {
        return $this->shapes;
    }
}

// ============================================================
// Demo
// ============================================================
echo "=== PHP Shape Hierarchy ===\n\n";

// Create shapes
$shapes = [
    new Circle(5, 0, 0, "red"),
    new Rectangle(4, 6, 1, 1, "blue"),
    new Square(3, 2, 2, "green"),
    new Triangle(3, 4, 5, 3, 3, "orange"),
];

// Display all shapes
echo "All Shapes:\n";
echo str_repeat("-", 60) . "\n";
foreach ($shapes as $shape) {
    $shape->printDescription();
}

// Demonstrate interfaces
echo "\nDrawing shapes:\n";
foreach ($shapes as $shape) {
    echo "  " . $shape->draw() . "\n";
}

// Demonstrate traits
echo "\nCreation times:\n";
foreach ($shapes as $shape) {
    echo "  {$shape->type()}: created at {$shape->getCreatedAt()}\n";
}

// Demonstrate sorting by area
echo "\nSorted by area (ascending):\n";
$collection = new ShapeCollection();
foreach ($shapes as $shape) {
    $collection->add($shape);
}
$sorted = $collection->sortByArea();
foreach ($sorted as $shape) {
    echo "  {$shape->type()}: " . round($shape->area(), 2) . "\n";
}

echo "\nTotal area: " . round($collection->totalArea(), 2) . "\n";

// Demonstrate resizing (Resizable interface)
echo "\nAfter resizing Circle by 2x:\n";
$circle = new Circle(5);
echo "  Before: radius={$circle->radius()}, area=" . round($circle->area(), 2) . "\n";
$circle->resize(2);
echo "  After:  radius={$circle->radius()}, area=" . round($circle->area(), 2) . "\n";

// Demonstrate polymorphism
echo "\nPolymorphism demo:\n";
function printShapeInfo(Shape $shape): void {
    echo "  " . $shape->describe() . "\n";
}

$shapes = [
    new Circle(3),
    new Rectangle(5, 4),
    new Square(6),
];
foreach ($shapes as $shape) {
    printShapeInfo($shape);
}
