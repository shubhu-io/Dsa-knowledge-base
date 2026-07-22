/**
 * oop.c
 *
 * Demonstrates object-oriented design in C using:
 *   - Structs for data
 *   - Function pointers for virtual dispatch (polymorphism)
 *   - Struct embedding for inheritance
 *   - Opaque pointer pattern for encapsulation
 *
 * Shape hierarchy: Shape (base) -> Circle, Rectangle, Triangle
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

/* ================================================================
 * Base: Shape (abstract — never instantiated directly)
 * ================================================================ */

/* Forward declarations */
typedef struct Shape Shape;
typedef struct Circle Circle;
typedef struct Rectangle Rectangle;
typedef struct Triangle Triangle;

/* Virtual method table — each concrete type provides its own */
typedef struct ShapeVtbl {
    double (*area)(const Shape *self);
    void   (*print)(const Shape *self);
    void   (*destroy)(Shape *self);
} ShapeVtbl;

/* Base shape struct */
struct Shape {
    const ShapeVtbl *vtable;
    double x, y;    /* position */
};

/* Virtual dispatch wrappers (the public "method" API) */
static inline double shape_area(const Shape *s)       { return s->vtable->area(s); }
static inline void   shape_print(const Shape *s)      { s->vtable->print(s); }
static inline void   shape_destroy(Shape *s)          { s->vtable->destroy(s); }

/* ================================================================
 * Circle
 * ================================================================ */

struct Circle {
    Shape base;     /* must be first member for safe casting */
    double radius;
};

static double circle_area(const Shape *self) {
    const Circle *c = (const Circle *)self;
    return M_PI * c->radius * c->radius;
}

static void circle_print(const Shape *self) {
    const Circle *c = (const Circle *)self;
    printf("Circle  @ (%.1f, %.1f)  r=%.1f  area=%.2f\n",
           c->base.x, c->base.y, c->radius, circle_area(self));
}

static void circle_destroy(Shape *self) {
    free(self);
}

static const ShapeVtbl circle_vtbl = {
    .area    = circle_area,
    .print   = circle_print,
    .destroy = circle_destroy
};

Circle *circle_create(double x, double y, double radius) {
    Circle *c = (Circle *)malloc(sizeof(Circle));
    c->base.vtable = &circle_vtbl;
    c->base.x = x;
    c->base.y = y;
    c->radius = radius;
    return c;
}

/* ================================================================
 * Rectangle
 * ================================================================ */

struct Rectangle {
    Shape base;
    double width, height;
};

static double rect_area(const Shape *self) {
    const Rectangle *r = (const Rectangle *)self;
    return r->width * r->height;
}

static void rect_print(const Shape *self) {
    const Rectangle *r = (const Rectangle *)self;
    printf("Rectangle @ (%.1f, %.1f)  %.1f x %.1f  area=%.2f\n",
           r->base.x, r->base.y, r->width, r->height, rect_area(self));
}

static void rect_destroy(Shape *self) { free(self); }

static const ShapeVtbl rect_vtbl = {
    .area    = rect_area,
    .print   = rect_print,
    .destroy = rect_destroy
};

Rectangle *rect_create(double x, double y, double w, double h) {
    Rectangle *r = (Rectangle *)malloc(sizeof(Rectangle));
    r->base.vtable = &rect_vtbl;
    r->base.x = x;
    r->base.y = y;
    r->width = w;
    r->height = h;
    return r;
}

/* ================================================================
 * Triangle (base on three vertices)
 * ================================================================ */

struct Triangle {
    Shape base;
    double bx, by;  /* second vertex (base.x, base.y is first) */
    double cx, cy;  /* third vertex */
};

static double tri_area(const Shape *self) {
    const Triangle *t = (const Triangle *)self;
    /* Cross product formula */
    return 0.5 * fabs(
        t->base.x * (t->by - t->cy) +
        t->bx      * (t->cy - t->base.y) +
        t->cx      * (t->base.y - t->by)
    );
}

static void tri_print(const Shape *self) {
    const Triangle *t = (const Triangle *)self;
    printf("Triangle @ (%.1f,%.1f)-(%.1f,%.1f)-(%.1f,%.1f)  area=%.2f\n",
           t->base.x, t->base.y, t->bx, t->by, t->cx, t->cy, tri_area(self));
}

static void tri_destroy(Shape *self) { free(self); }

static const ShapeVtbl tri_vtbl = {
    .area    = tri_area,
    .print   = tri_print,
    .destroy = tri_destroy
};

Triangle *triangle_create(double ax, double ay,
                          double bx, double by,
                          double cx, double cy) {
    Triangle *t = (Triangle *)malloc(sizeof(Triangle));
    t->base.vtable = &tri_vtbl;
    t->base.x = ax;
    t->base.y = ay;
    t->bx = bx;
    t->by = by;
    t->cx = cx;
    t->cy = cy;
    return t;
}

/* ================================================================
 * Helper: total area of an array of shapes
 * ================================================================ */

double total_area(Shape **shapes, int count) {
    double sum = 0.0;
    for (int i = 0; i < count; i++)
        sum += shape_area(shapes[i]);
    return sum;
}

/* ================================================================
 * Demo
 * ================================================================ */

int main(void) {
    /* Create shapes (upcast to Shape* — the polymorphic handle) */
    Shape *shapes[3];
    shapes[0] = (Shape *)circle_create(0, 0, 5.0);
    shapes[1] = (Shape *)rect_create(1, 1, 4.0, 6.0);
    shapes[2] = (Shape *)triangle_create(0, 0, 4, 0, 2, 3);

    /* Polymorphic operations — same API, different behavior */
    printf("=== Individual Shapes ===\n");
    for (int i = 0; i < 3; i++)
        shape_print(shapes[i]);

    printf("\n=== Total Area ===\n");
    printf("Total area = %.2f\n", total_area(shapes, 3));

    /* Cleanup */
    for (int i = 0; i < 3; i++)
        shape_destroy(shapes[i]);

    return 0;
}
