/**
 * classes.cpp
 *
 * Demonstrates C++ OOP features:
 *   - Abstract base class with virtual functions
 *   - Concrete derived classes with override
 *   - Smart pointer usage (unique_ptr, shared_ptr)
 *   - RAII pattern (resource management via constructors/destructors)
 *   - Operator overloading
 *   - Template-based container
 *
 * Shape hierarchy: Shape (abstract) -> Circle, Rectangle, Triangle
 */

#include <iostream>
#include <vector>
#include <memory>
#include <cmath>
#include <string>
#include <sstream>

using namespace std;

/* ================================================================
 * Shape — abstract base class
 * ================================================================ */
class Shape {
protected:
    double x_, y_;   /* position */
public:
    Shape(double x = 0, double y = 0) : x_(x), y_(y) {}
    virtual ~Shape() = default;   /* always virtual dtor for polymorphism */

    virtual double area() const = 0;         /* pure virtual */
    virtual string type() const = 0;         /* pure virtual */
    virtual string to_string() const = 0;    /* pure virtual */

    double x() const { return x_; }
    double y() const { return y_; }
};

/* ================================================================
 * Circle
 * ================================================================ */
class Circle : public Shape {
    double radius_;
public:
    Circle(double x, double y, double r) : Shape(x, y), radius_(r) {}

    double area() const override {
        return M_PI * radius_ * radius_;
    }

    string type() const override { return "Circle"; }

    string to_string() const override {
        ostringstream oss;
        oss << "Circle @ (" << x_ << ", " << y_ << ")  r=" << radius_
            << "  area=" << area();
        return oss.str();
    }
};

/* ================================================================
 * Rectangle
 * ================================================================ */
class Rectangle : public Shape {
    double w_, h_;
public:
    Rectangle(double x, double y, double w, double h)
        : Shape(x, y), w_(w), h_(h) {}

    double area() const override { return w_ * h_; }

    string type() const override { return "Rectangle"; }

    string to_string() const override {
        ostringstream oss;
        oss << "Rectangle @ (" << x_ << ", " << y_ << ")  "
            << w_ << " x " << h_ << "  area=" << area();
        return oss.str();
    }
};

/* ================================================================
 * Triangle
 * ================================================================ */
class Triangle : public Shape {
    double bx_, by_, cx_, cy_;
public:
    Triangle(double ax, double ay, double bx, double by,
             double cx, double cy)
        : Shape(ax, ay), bx_(bx), by_(by), cx_(cx), cy_(cy) {}

    double area() const override {
        return 0.5 * abs(x_ * (by_ - cy_) +
                          bx_ * (cy_ - y_) +
                          cx_ * (y_ - by_));
    }

    string type() const override { return "Triangle"; }

    string to_string() const override {
        ostringstream oss;
        oss << "Triangle @ (" << x_ << "," << y_ << ")-("
            << bx_ << "," << by_ << ")-(" << cx_ << "," << cy_
            << ")  area=" << area();
        return oss.str();
    }
};

/* ================================================================
 * ShapeGroup — RAII container with value semantics
 * ================================================================ */
class ShapeGroup {
    vector<unique_ptr<Shape>> shapes_;
    string name_;
public:
    ShapeGroup(const string &name) : name_(name) {}

    void add(unique_ptr<Shape> s) {
        shapes_.push_back(move(s));
    }

    double total_area() const {
        double sum = 0;
        for (const auto &s : shapes_)
            sum += s->area();
        return sum;
    }

    void print() const {
        cout << "Group \"" << name_ << "\" (" << shapes_.size()
             << " shapes):" << endl;
        for (const auto &s : shapes_)
            cout << "  " << s->to_string() << endl;
        cout << "  Total area = " << total_area() << endl;
    }
};

/* ================================================================
 * RAII file wrapper — demonstrates RAII pattern
 * ================================================================ */
class ScopedFile {
    FILE *fp_;
public:
    ScopedFile(const char *path, const char *mode) {
        fp_ = fopen(path, mode);
    }

    ~ScopedFile() {
        if (fp_) fclose(fp_);
    }

    bool is_open() const { return fp_ != nullptr; }

    void write_line(const string &line) {
        if (fp_) {
            fprintf(fp_, "%s\n", line.c_str());
        }
    }

    /* Non-copyable */
    ScopedFile(const ScopedFile &) = delete;
    ScopedFile &operator=(const ScopedFile &) = delete;
};

/* ================================================================
 * Demo
 * ================================================================ */
int main() {
    /* --- Create shapes with smart pointers --- */
    ShapeGroup group("Geometry Demo");

    group.add(make_unique<Circle>(0, 0, 5.0));
    group.add(make_unique<Rectangle>(1, 1, 4.0, 6.0));
    group.add(make_unique<Triangle>(0, 0, 4, 0, 2, 3));

    group.print();

    /* --- Polymorphism via base pointer --- */
    cout << "\n=== Polymorphism via unique_ptr ===" << endl;
    vector<unique_ptr<Shape>> shapes;
    shapes.push_back(make_unique<Circle>(0, 0, 3.0));
    shapes.push_back(make_unique<Rectangle>(0, 0, 2.0, 7.0));

    for (const auto &s : shapes)
        cout << *s << " -> " << s->type() << endl;

    /* --- RAII demo --- */
    cout << "\n=== RAII File Wrapper ===" << endl;
    {
        ScopedFile file("output.txt", "w");
        if (file.is_open()) {
            file.write_line("Shape data exported:");
            file.write_line("Circle r=5.0");
            file.write_line("Rectangle 4x6");
            cout << "Wrote to output.txt (file auto-closes at scope end)" << endl;
        }
    }   /* ScopedFile destructor called here — file closed automatically */

    return 0;
}
