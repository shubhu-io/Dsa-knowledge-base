# Competitive Programming Geometry

## Computational Geometry for Competitive Programming

This document covers essential computational geometry concepts, algorithms, and techniques that are frequently used in competitive programming problems.

---

## Table of Contents
1. [Basic Geometry Primitives](#basic-geometry-primitives)
2. [Point Operations](#point-operations)
3. [Line and Segment Operations](#line-and-segment-operations)
4. [Polygon Operations](#polygon-operations)
5. [Circle Operations](#circle-operations)
6. [Convex Hull Algorithms](#convex-hull-algorithms)
7. [Line Sweep Algorithms](#line-sweep-algorithms)
8. [Geometric Data Structures](#geometric-data-structures)
9. [Advanced Topics](#advanced-topics)
10. [Common Problems and Solutions](#common-problems-and-solutions)

---

## Basic Geometry Primitives

### Point Structure
```cpp
struct Point {
    long long x, y;
    Point() : x(0), y(0) {}
    Point(long long x, long long y) : x(x), y(y) {}
    
    // Vector operations
    Point operator+(const Point& other) const {
        return Point(x + other.x, y + other.y);
    }
    
    Point operator-(const Point& other) const {
        return Point(x - other.x, y - other.y);
    }
    
    Point operator*(long long scalar) const {
        return Point(x * scalar, y * scalar);
    }
    
    Point operator/(long long scalar) const {
        return Point(x / scalar, y / scalar);
    }
    
    // Comparison
    bool operator==(const Point& other) const {
        return x == other.x && y == other.y;
    }
    
    bool operator<(const Point& other) const {
        if (x != other.x) return x < other.x;
        return y < other.y;
    }
};
```

### Vector Operations
```cpp
// Dot product
long long dot(const Point& a, const Point& b) {
    return a.x * b.x + a.y * b.y;
}

// Cross product (2D) - returns signed area of parallelogram
long long cross(const Point& a, const Point& b) {
    return a.x * b.y - a.y * b.x;
}

// Cross product for three points - returns signed area of triangle
long long cross(const Point& a, const Point& b, const Point& c) {
    return cross(b - a, c - a);
}

// Scalar triple product (3D) - not needed for 2D CP but included for completeness
// long long triple(const Point& a, const Point& b, const Point& c) {
//     return dot(a, cross(b, c));
// }
```

### Distance Operations
```cpp
// Squared distance (avoids sqrt for comparison)
long long dist2(const Point& a, const Point& b) {
    long long dx = a.x - b.x;
    long long dy = a.y - b.y;
    return dx * dx + dy * dy;
}

// Euclidean distance
double dist(const Point& a, const Point& b) {
    return sqrt(dist2(a, b));
}
```

### Angle Operations
```cpp
// Angle between vectors a and b
double angle(const Point& a, const Point& b) {
    double dot_product = dot(a, b);
    double magnitude_a = sqrt(dot(a, a));
    double magnitude_b = sqrt(dot(b, b));
    return acos(dot_product / (magnitude_a * magnitude_b));
}

// Angle at point b formed by points a-b-c
double angle(const Point& a, const Point& b, const Point& c) {
    return angle(b - a, c - b);
}
```

### Rotation Operations
```cpp
// Rotate point p around origin by angle theta (radians)
Point rotate(const Point& p, double theta) {
    long long x = p.x;
    long long y = p.y;
    return Point(
        x * cos(theta) - y * sin(theta),
        x * sin(theta) + y * cos(theta)
    );
}

// Rotate point p around point center by angle theta (radians)
Point rotate_about(const Point& p, const Point& center, double theta) {
    Point translated = p - center;
    Point rotated = rotate(translated, theta);
    return rotated + center;
}
```

### Reflection Operations
```cpp
// Reflect point p over line through points a and b
Point reflect(const Point& p, const Point& a, const Point& b) {
    // Project p onto line ab, then reflect
    Point ab = b - a;
    Point ap = p - a;
    
    double ab_len2 = dot(ab, ab);
    if (ab_len2 == 0) return p; // a and b are the same point
    
    double t = dot(ap, ab) / ab_len2;
    Point projection = a + ab * t;
    
    return projection * 2 - p;
}
```

---

## Point Operations

### Quadrant Detection
```cpp
int quadrant(const Point& p) {
    if (p.x > 0 && p.y >= 0) return 1;
    if (p.x <= 0 && p.y > 0) return 2;
    if (p.x < 0 && p.y <= 0) return 3;
    if (p.x >= 0 && p.y < 0) return 4;
    return 0; // Origin
}
```

### Point in Triangle (Barycentric Coordinates)
```cpp
bool point_in_triangle(const Point& p, const Point& a, const Point& b, const Point& c) {
    // Using barycentric technique
    long long area = abs(cross(a, b, c));
    long long area1 = abs(cross(p, b, c));
    long long area2 = abs(cross(a, p, c));
    long long area3 = abs(cross(a, b, p));
    
    // Account for possible overflow in integer coordinates
    return (area1 + area2 + area3) == area;
}

// Alternative using same-side technique
bool same_side(const Point& p1, const Point& p2, const Point& a, const Point& b) {
    long long cp1 = cross(b - a, p1 - a);
    long long cp2 = cross(b - a, p2 - a);
    return cp1 * cp2 >= 0;
}

bool point_in_triangle_ss(const Point& p, const Point& a, const Point& b, const Point& c) {
    return same_side(p, a, b, c) &&
           same_side(p, b, a, c) &&
           same_side(p, c, a, b);
}
```

### Point on Line
```cpp
bool point_on_line(const Point& p, const Point& a, const Point& b) {
    // Check if cross product is zero (collinear)
    return cross(b - a, p - a) == 0;
}
```

### Point on Segment
```cpp
bool point_on_segment(const Point& p, const Point& a, const Point& b) {
    // First check if collinear
    if (cross(b - a, p - a) != 0) return false;
    
    // Then check if within bounding box
    return (p.x >= min(a.x, b.x) && p.x <= max(a.x, b.x) &&
            p.y >= min(a.y, b.y) && p.y <= max(a.y, b.y));
}
```

### Point in Rectangle (Axis-Aligned)
```cpp
bool point_in_rect(const Point& p, const Point& bottom_left, const Point& top_right) {
    return (p.x >= bottom_left.x && p.x <= top_right.x &&
            p.y >= bottom_left.y && p.y <= top_right.y);
}
```

### Closest Pair of Points (Divide and Conquer)
```cpp
double closest_pair(vector<Point>& points) {
    if (points.size() < 2) return numeric_limits<double>::max();
    
    vector<Point> points_x = points;
    vector<Point> points_y = points;
    
    sort(points_x.begin(), points_x.end(), 
         [](const Point& a, const Point& b) {
             return a.x < b.x || (a.x == b.x && a.y < b.y);
         });
         
    sort(points_y.begin(), points_y.end(), 
         [](const Point& a, const Point& b) {
             return a.y < b.y || (a.y == b.y && a.x < b.x);
         });
    
    return closest_pair_rec(points_x, points_y, 0, points.size());
}

double closest_pair_rec(vector<Point>& points_x, vector<Point>& points_y, 
                       int left, int right) {
    if (right - left <= 3) {
        // Brute force for small cases
        double min_dist = numeric_limits<double>::max();
        for (int i = left; i < right; i++) {
            for (int j = i + 1; j < right; j++) {
                min_dist = min(min_dist, dist(points_x[i], points_x[j]));
            }
        }
        return min_dist;
    }
    
    int mid = (left + right) / 2;
    Point mid_point = points_x[mid];
    
    // Split points_y into left and right halves
    vector<Point> left_y, right_y;
    for (const Point& p : points_y) {
        if (p.x <= mid_point.x) {
            left_y.push_back(p);
        } else {
            right_y.push_back(p);
        }
    }
    
    // Recursively find closest pairs in left and right halves
    double dl = closest_pair_rec(points_x, left_y, left, mid);
    double dr = closest_pair_rec(points_x, right_y, mid, right);
    double d = min(dl, dr);
    
    // Find points within d of the vertical line through mid_point
    vector<Point> strip;
    for (const Point& p : points_y) {
        if (abs(p.x - mid_point.x) < d) {
            strip.push_back(p);
        }
    }
    
    // Check points in strip
    double min_strip = d;
    for (size_t i = 0; i < strip.size(); i++) {
        // Only need to check next 7 points due to geometric properties
        for (size_t j = i + 1; j < strip.size() && j <= i + 7; j++) {
            min_strip = min(min_strip, dist(strip[i], strip[j]));
        }
    }
    
    return min(min_strip, d);
}
```

---

## Line and Segment Operations

### Line Representation
```cpp
struct Line {
    // ax + by = c
    long long a, b, c;
    
    Line() : a(0), b(0), c(0) {}
    Line(long long _a, long long _b, long long _c) : a(_a), b(_b), c(_c) {}
    
    // Construct from two points
    Line(const Point& p1, const Point& p2) {
        a = p2.y - p1.y;
        b = p1.x - p2.x;
        c = a * p1.x + b * p1.y;
    }
    
    // Normalize line (make a^2 + b^2 = 1 for distance calculations)
    void normalize() {
        double len = sqrt(a * a + b * b);
        if (len != 0) {
            a /= len;
            b /= len;
            c /= len;
        }
    }
};
```

### Line Intersection
```cpp
// Returns true if lines intersect, false if parallel
// If intersect, stores intersection point in result
bool line_intersection(const Line& l1, const Line& l2, Point& result) {
    long long determinant = l1.a * l2.b - l2.a * l1.b;
    
    if (determinant == 0) {
        // Lines are parallel
        return false;
    }
    
    result.x = (l2.b * l1.c - l1.b * l2.c) / determinant;
    result.y = (l1.a * l2.c - l2.a * l1.c) / determinant;
    return true;
}
```

### Line Segment Intersection
```cpp
// Check if two line segments intersect
bool segments_intersect(const Point& a1, const Point& a2, 
                       const Point& b1, const Point& b2) {
    // Find the four orientations needed for general and special cases
    int o1 = orientation(a1, a2, b1);
    int o2 = orientation(a1, a2, b2);
    int o3 = orientation(b1, b2, a1);
    int o4 = orientation(b1, b2, a2);
    
    // General case
    if (o1 != o2 && o3 != o4)
        return true;
    
    // Special Cases
    // a1, a2 and b1 are collinear and b1 lies on segment a1a2
    if (o1 == 0 && on_segment(a1, b1, a2)) return true;
    
    // a1, a2 and b2 are collinear and b2 lies on segment a1a2
    if (o2 == 0 && on_segment(a1, b2, a2)) return true;
    
    // b1, b2 and a1 are collinear and a1 lies on segment b1b2
    if (o3 == 0 && on_segment(b1, a1, b2)) return true;
    
    // b1, b2 and a2 are collinear and a2 lies on segment b1b2
    if (o4 == 0 && on_segment(b1, a2, b2)) return true;
    
    return false;
}

// To find orientation of ordered triplet (p, q, r).
// Returns:
// 0 --> p, q and r are collinear
// 1 --> Clockwise
// 2 --> Counterclockwise
int orientation(const Point& p, const Point& q, const Point& r) {
    long long val = (q.y - p.y) * (r.x - q.x) - (q.x - p.x) * (r.y - q.y);
    if (val == 0) return 0;  // collinear
    return (val > 0) ? 1 : 2; // clock or counterclockwise
}

// Check if point q lies on segment pr
bool on_segment(const Point& p, const Point& q, const Point& r) {
    if (q.x <= max(p.x, r.x) && q.x >= min(p.x, r.x) &&
        q.y <= max(p.y, r.y) && q.y >= min(p.y, r.y))
        return true;
    return false;
}
```

### Distance from Point to Line
```cpp
// Distance from point p to line through points a and b
double point_to_line_distance(const Point& p, const Point& a, const Point& b) {
    // Using formula: |(b-a) x (p-a)| / |b-a|
    long long numerator = abs(cross(b - a, p - a));
    double denominator = sqrt(dist2(a, b));
    if (denominator == 0) return 0; // a and b are the same point
    return (double)numerator / denominator;
}

// Distance from point p to line segment ab
double point_to_segment_distance(const Point& p, const Point& a, const Point& b) {
    // Find projection of p onto line ab
    Point ab = b - a;
    Point ap = p - a;
    long long ab_len2 = dot(ab, ab);
    
    if (ab_len2 == 0) {
        // a and b are the same point
        return dist(p, a);
    }
    
    double t = dot(ap, ab) / (double)ab_len2;
    
    if (t < 0) {
        // Beyond point a
        return dist(p, a);
    } else if (t > 1) {
        // Beyond point b
        return dist(p, b);
    } else {
        // Projection falls on segment
        Point projection = a + ab * t;
        return dist(p, projection);
    }
}
```

### Angle Between Two Lines
```cpp
// Angle between two lines
double angle_between_lines(const Line& l1, const Line& l2) {
    // Using formula: cos(theta) = |a1*a2 + b1*b2| / (sqrt(a1^2+b1^2) * sqrt(a2^2+b2^2))
    long long dot_product = l1.a * l2.a + l1.b * l2.b;
    double magnitude1 = sqrt(l1.a * l1.a + l1.b * l1.b);
    double magnitude2 = sqrt(l2.a * l2.a + l2.b * l2.b);
    
    if (magnitude1 == 0 || magnitude2 == 0) return 0;
    
    double cos_theta = abs((double)dot_product) / (magnitude1 * magnitude2);
    // Clamp to [-1, 1] to avoid floating point errors
    cos_theta = max(-1.0, min(1.0, cos_theta));
    return acos(cos_theta);
}
```

---

## Polygon Operations

### Simple Polygon Definition
A polygon is simple if its edges only intersect at vertices.

### Area of Polygon (Shoelace Formula)
```cpp
// Area of simple polygon
double polygon_area(const vector<Point>& polygon) {
    int n = polygon.size();
    if (n < 3) return 0;
    
    double area = 0;
    for (int i = 0; i < n; i++) {
        int j = (i + 1) % n;
        area += (polygon[i].x * polygon[j].y - polygon[j].x * polygon[i].y);
    }
    return abs(area) / 2.0;
}

// Signed area (positive for counter-clockwise, negative for clockwise)
double polygon_signed_area(const vector<Point>& polygon) {
    int n = polygon.size();
    if (n < 3) return 0;
    
    double area = 0;
    for (int i = 0; i < n; i++) {
        int j = (i + 1) % n;
        area += (polygon[i].x * polygon[j].y - polygon[j].x * polygon[i].y);
    }
    return area / 2.0;
}
```

### Point in Polygon (Ray Casting Algorithm)
```cpp
bool point_in_polygon(const vector<Point>& polygon, const Point& p) {
    int n = polygon.size();
    if (n < 3) return false;
    
    bool inside = false;
    for (int i = 0, j = n - 1; i < n; j = i++) {
        if (((polygon[i].y > p.y) != (polygon[j].y > p.y)) &&
            (p.x < (polygon[j].x - polygon[i].x) * (p.y - polygon[i].y) / 
             (double)(polygon[j].y - polygon[i].y) + polygon[i].x)) {
            inside = !inside;
        }
    }
    return inside;
}
```

### Point in Polygon (Winding Number Algorithm)
```cpp
bool point_in_polygon_wn(const vector<Point>& polygon, const Point& p) {
    int n = polygon.size();
    if (n < 3) return false;
    
    int winding_number = 0;
    
    for (int i = 0; i < n; i++) {
        int j = (i + 1) % n;
        
        if (polygon[i].y <= p.y) {
            if (polygon[j].y > p.y && // upward crossing
                is_left(polygon[i], polygon[j], p) > 0) {
                winding_number++;
            }
        } else {
            if (polygon[j].y <= p.y && // downward crossing
                is_left(polygon[i], polygon[j], p) < 0) {
                winding_number--;
            }
        }
    }
    
    return winding_number != 0;
}

// Helper function for winding number algorithm
long long is_left(const Point& p0, const Point& p1, const Point& p2) {
    return (p1.x - p0.x) * (p2.y - p0.y) - (p2.x - p0.x) * (p1.y - p0.y);
}
```

### Polygon Centroid
```cpp
Point polygon_centroid(const vector<Point>& polygon) {
    int n = polygon.size();
    if (n < 3) return Point(0, 0);
    
    double cx = 0, cy = 0;
    double area = polygon_signed_area(polygon);
    
    if (abs(area) < 1e-9) return Point(0, 0); // Avoid division by zero
    
    for (int i = 0; i < n; i++) {
        int j = (i + 1) % n;
        double cross_val = cross(polygon[i], polygon[j]);
        cx += (polygon[i].x + polygon[j].x) * cross_val;
        cy += (polygon[i].y + polygon[j].y) * cross_val;
    }
    
    cx /= (6 * area);
    cy /= (6 * area);
    
    return Point(cx, cy);
}
```

### Polygon Convexity Check
```cpp
bool is_convex_polygon(const vector<Point>& polygon) {
    int n = polygon.size();
    if (n < 3) return false;
    
    bool has_positive = false;
    bool has_negative = false;
    
    for (int i = 0; i < n; i++) {
        int j = (i + 1) % n;
        int k = (j + 1) % n;
        
        long long cross_val = cross(polygon[i], polygon[j], polygon[k]);
        
        if (cross_val > 0) has_positive = true;
        if (cross_val < 0) has_negative = true;
        
        // If we have both positive and negative cross products, it's not convex
        if (has_positive && has_negative) return false;
    }
    
    return true;
}
```

### Polygon Triangulation (Ear Clipping Method)
```cpp
// Simple ear clipping algorithm for convex polygons
vector<vector<Point>> triangulate_convex_polygon(const vector<Point>& polygon) {
    vector<vector<Point>> triangles;
    int n = polygon.size();
    
    if (n < 3) return triangles;
    
    // For convex polygon, any triangulation works
    // Use fan triangulation from vertex 0
    for (int i = 1; i < n - 1; i++) {
        vector<Point> triangle = {polygon[0], polygon[i], polygon[i+1]};
        triangles.push_back(triangle);
    }
    
    return triangles;
}
```

---

## Circle Operations

### Circle Structure
```cpp
struct Circle {
    Point center;
    double radius;
    
    Circle() : center(Point(0, 0)), radius(0) {}
    Circle(const Point& c, double r) : center(c), radius(r) {}
    
    // Check if point is inside circle
    bool contains(const Point& p) const {
        return dist2(p, center) <= radius * radius;
    }
    
    // Check if point is on circle (within epsilon)
    bool on_boundary(const Point& p, double eps = 1e-9) const {
        return abs(dist2(p, center) - radius * radius) < eps;
    }
    
    // Check if point is outside circle
    bool outside(const Point& p) const {
        return dist2(p, center) > radius * radius;
    }
};
```

### Circle from Three Points
```cpp
// Returns true if three points are not collinear and returns the circle
bool circle_from_three_points(const Point& a, const Point& b, const Point& c, Circle& result) {
    // Check if points are collinear
    if (cross(a, b, c) == 0) {
        return false; // Points are collinear, no unique circle
    }
    
    // Find perpendicular bisectors of ab and bc
    // Intersection of these bisectors is the circle center
    
    // Midpoint of ab
    Point mid_ab = Point((a.x + b.x) / 2.0, (a.y + b.y) / 2.0);
    // Slope of ab
    double slope_ab = (b.y - a.y) / (double)(b.x - a.x);
    // Slope of perpendicular bisector of ab
    double slope_pab = -1.0 / slope_ab; // Handle vertical line case
    
    // Midpoint of bc
    Point mid_bc = Point((b.x + c.x) / 2.0, (b.y + c.y) / 2.0);
    // Slope of bc
    double slope_bc = (c.y - b.y) / (double)(c.x - b.x);
    // Slope of perpendicular bisector of bc
    double slope_pbc = -1.0 / slope_bc; // Handle vertical line case
    
    // Handle vertical lines (infinite slope)
    if (abs(b.x - a.x) < 1e-9) { // ab is vertical
        result.center.x = mid_ab.x;
        // Use bc's perpendicular bisector
        if (abs(c.x - b.x) > 1e-9) { // bc is not vertical
            result.center.y = mid_bc.y + (result.center.x - mid_bc.x) / slope_pbc;
        } else {
            // Both ab and bc vertical - shouldn't happen if not collinear
            return false;
        }
    } else if (abs(c.x - b.x) < 1e-9) { // bc is vertical
        result.center.x = mid_bc.x;
        // Use ab's perpendicular bisector
        result.center.y = mid_ab.y + (result.center.x - mid_ab.x) / slope_pab;
    } else {
        // Neither segment is vertical
        // Solve: y = mid_ab.y + slope_pab * (x - mid_ab.x)
        //        y = mid_bc.y + slope_pbc * (x - mid_bc.x)
        // 
        // mid_ab.y + slope_pab * (x - mid_ab.x) = mid_bc.y + slope_pbc * (x - mid_bc.x)
        // x * (slope_pab - slope_pbc) = mid_bc.y - mid_ab.y + slope_pbc * mid_bc.x - slope_pab * mid_ab.x
        double denominator = slope_pab - slope_pbc;
        if (abs(denominator) < 1e-9) {
            return false; // Parallel bisectors (shouldn't happen for non-collinear points)
        }
        
        result.center.x = (mid_bc.y - mid_ab.y + slope_pbc * mid_bc.x - slope_pab * mid_ab.x) / denominator;
        result.center.y = mid_ab.y + slope_pab * (result.center.x - mid_ab.x);
    }
    
    result.radius = dist(result.center, a);
    return true;
}
```

### Circle-Line Intersection
```cpp
// Returns number of intersection points (0, 1, or 2)
// If intersections exist, stores them in points[]
int circle_line_intersection(const Circle& circle, const Point& p1, const Point& p2, 
                            vector<Point>& points) {
    points.clear();
    
    // Line represented as p1 + t*(p2-p1)
    Point d = p2 - p1; // direction vector
    Point f = p1 - circle.center; // vector from center to p1
    
    double a = dot(d, d);
    double b = 2 * dot(f, d);
    double c = dot(f, f) - circle.radius * circle.radius;
    
    double discriminant = b * b - 4 * a * c;
    
    if (discriminant < -1e-9) {
        return 0; // No intersection
    } else if (abs(discriminant) < 1e-9) {
        // One intersection (tangent)
        double t = -b / (2 * a);
        points.push_back(p1 + d * t);
        return 1;
    } else {
        // Two intersections
        double sqrt_disc = sqrt(discriminant);
        double t1 = (-b - sqrt_disc) / (2 * a);
        double t2 = (-b + sqrt_disc) / (2 * a);
        points.push_back(p1 + d * t1);
        points.push_back(p1 + d * t2);
        return 2;
    }
}
```

### Circle-Circle Intersection
```cpp
// Returns number of intersection points (0, 1, 2, or -1 for infinite)
// If intersections exist, stores them in points[]
int circle_circle_intersection(const Circle& c1, const Circle& c2, 
                              vector<Point>& points) {
    points.clear();
    
    Point d = c2.center - c1.center;
    double dist2 = dot(d, d);
    double r1 = c1.radius;
    double r2 = c2.radius;
    
    // Check for no intersection
    if (dist2 > (r1 + r2) * (r1 + r2) + 1e-9) return 0; // Too far apart
    if (dist2 < (r1 - r2) * (r1 - r2) - 1e-9) return 0; // One inside another
    
    // Check for coincident circles
    if (abs(dist2) < 1e-9 && abs(r1 - r2) < 1e-9) {
        return -1; // Infinite intersections (same circle)
    }
    
    // Calculate intersection points
    double a = (r1*r1 - r2*r2 + dist2) / (2 * sqrt(dist2));
    double h = sqrt(max(0.0, r1*r1 - a*a));
    
    Point p2 = c1.center + d * (a / sqrt(dist2));
    
    // Intersection points
    Point offset = Point(-d.y * (h / sqrt(dist2)), d.x * (h / sqrt(dist2)));
    
    points.push_back(p2 + offset);
    if (abs(h) > 1e-9) { // Avoid duplicate point when tangent
        points.push_back(p2 - offset);
    }
    
    return points.size();
}
```

---

## Convex Hull Algorithms

### Graham Scan
**Time Complexity**: O(n log n)
**Steps**:
1. Find point with lowest y-coordinate (break ties by x-coordinate)
2. Sort remaining points by polar angle with respect to the anchor point
3. Process points and maintain convex hull using stack

```cpp
vector<Point> graham_scan(vector<Point> points) {
    int n = points.size();
    if (n < 3) return points;
    
    // Step 1: Find the bottom-most point
    int bottom = 0;
    for (int i = 1; i < n; i++) {
        if (points[i].y < points[bottom].y || 
            (points[i].y == points[bottom].y && points[i].x < points[bottom].x)) {
            bottom = i;
        }
    }
    swap(points[0], points[bottom]);
    
    // Step 2: Sort points by polar angle with points[0]
    sort(points.begin() + 1, points.end(),
         [&](const Point& a, const Point& b) {
             long long cross_val = cross(points[0], a, b);
             if (cross_val == 0) {
                 // If collinear, keep closer point first
                 return dist2(points[0], a) < dist2(points[0], b);
             }
             return cross_val > 0; // Counter-clockwise order
         });
    
    // Step 3: Remove collinear points except the farthest
    vector<Point> sorted_points;
    sorted_points.push_back(points[0]);
    for (int i = 1; i < n; i++) {
        // Skip points that are collinear with points[0] and points[i-1]
        // unless points[i] is farther than points[i-1]
        if (i < n-1 && cross(points[0], points[i], points[i+1]) == 0) {
            continue;
        }
        sorted_points.push_back(points[i]);
    }
    
    // If all points are collinear
    if (sorted_points.size() < 3) {
        return sorted_points;
    }
    
    // Step 4: Process points and build hull
    vector<Point> hull;
    hull.push_back(sorted_points[0]);
    hull.push_back(sorted_points[1]);
    hull.push_back(sorted_points[2]);
    
    for (int i = 3; i < sorted_points.size(); i++) {
        // While the angle formed by points[i-2], points[i-1], and points[i]
        // makes a non-left turn, remove points[i-1] from hull
        while (hull.size() >= 2 && 
               cross(hull[hull.size()-2], hull.back(), sorted_points[i]) <= 0) {
            hull.pop_back();
        }
        hull.push_back(sorted_points[i]);
    }
    
    return hull;
}
```

### Andrew's Monotone Chain Algorithm
**Time Complexity**: O(n log n)
**Advantages**: Simpler to implement, handles collinear points naturally

```cpp
vector<Point> monotone_chain(vector<Point> points) {
    int n = points.size();
    if (n < 3) return points;
    
    // Sort points lexicographically (by x, then by y)
    sort(points.begin(), points.end(),
         [](const Point& a, const Point& b) {
             return a.x < b.x || (a.x == b.x && a.y < b.y);
         });
    
    // Build lower hull
    vector<Point> lower;
    for (int i = 0; i < n; i++) {
        while (lower.size() >= 2 && 
               cross(lower[lower.size()-2], lower.back(), points[i]) <= 0) {
            lower.pop_back();
        }
        lower.push_back(points[i]);
    }
    
    // Build upper hull
    vector<Point> upper;
    for (int i = n - 1; i >= 0; i--) {
        while (upper.size() >= 2 && 
               cross(upper[upper.size()-2], upper.back(), points[i]) <= 0) {
            upper.pop_back();
        }
        upper.push_back(points[i]);
    }
    
    // Concatenate lower and upper hulls, removing duplicate endpoints
    // Remove last point of each list because it's the same as the first point of the other list
    lower.pop_back();
    upper.pop_back();
    
    lower.insert(lower.end(), upper.begin(), upper.end());
    return lower;
}
```

### Jarvis March (Gift Wrapping)
**Time Complexity**: O(nh) where h is number of points on hull
**Better than O(n log n)** when h is small

```cpp
vector<Point> jarvis_march(vector<Point> points) {
    int n = points.size();
    if (n < 3) return points;
    
    // Find the leftmost point
    int leftmost = 0;
    for (int i = 1; i < n; i++) {
        if (points[i].x < points[leftmost].x) {
            leftmost = i;
        }
    }
    
    vector<Point> hull;
    int p = leftmost;
    int q;
    
    do {
        hull.push_back(points[p]);
        q = (p + 1) % n;
        
        for (int i = 0; i < n; i++) {
            // If i is more counterclockwise than current q, then update q
            if (cross(points[p], points[i], points[q]) > 0) {
                q = i;
            }
        }
        
        p = q;
    } while (p != leftmost); // Until we come back to starting point
    
    return hull;
}
```

### QuickHull
**Average Case Time Complexity**: O(n log n)
**Worst Case Time Complexity**: O(n²)
**Similar to quicksort** in approach

```cpp
// Helper function to find distance from point to line
double line_distance(const Point& p, const Point& a, const Point& b) {
    return abs(cross(b - a, p - a)) / sqrt(dist2(a, b));
}

// Helper function to find point farthest from line ab
Point farthest_point(const vector<Point>& points, const Point& a, const Point& b) {
    double max_dist = 0;
    Point farthest = a;
    
    for (const Point& p : points) {
        double dist = line_distance(p, a, b);
        if (dist > max_dist) {
            max_dist = dist;
            farthest = p;
        }
    }
    return farthest;
}

// Recursive function to find hull points on one side of line ab
void quickhull_rec(vector<Point>& points, const Point& a, const Point& b, 
                  vector<Point>& hull) {
    if (points.empty()) return;
    
    // Find point farthest from line ab
    Point c = farthest_point(points, a, b);
    
    // If no point is farther than the line itself, add endpoints to hull
    if (line_distance(c, a, b) == 0) {
        hull.push_back(a);
        hull.push_back(b);
        return;
    }
    
    // Split points into two sets: those on left side of ac and bc
    vector<Point> left_of_ac, left_of_bc;
    for (const Point& p : points) {
        if (cross(a, c, p) > 0) {
            left_of_ac.push_back(p);
        }
        if (cross(c, b, p) > 0) {
            left_of_bc.push_back(p);
        }
    }
    
    // Recursively find hull points
    quickhull_rec(left_of_ac, a, c, hull);
    quickhull_rec(left_of_bc, c, b, hull);
}

vector<Point> quickhull(vector<Point> points) {
    int n = points.size();
    if (n < 3) return points;
    
    // Find leftmost and rightmost points
    int leftmost = 0, rightmost = 0;
    for (int i = 1; i < n; i++) {
        if (points[i].x < points[leftmost].x) leftmost = i;
        if (points[i].x > points[rightmost].x) rightmost = i;
    }
    
    vector<Point> hull;
    quickhull_rec(points, points[leftmost], points[rightmost], hull);
    quickhull_rec(points, points[rightmost], points[leftmost], hull);
    
    // Remove duplicates (if any)
    sort(hull.begin(), hull.end());
    auto last = unique(hull.begin(), hull.end());
    hull.erase(last, hull.end());
    
    return hull;
}
```

---

## Line Sweep Algorithms

### Basic Line Sweep Concept
**Idea**: Imagine a vertical line sweeping from left to right across the plane, processing events as it encounters them.

**Events**:
- **Point events**: When sweep line reaches a point
- **Segment events**: When sweep line reaches the start or end of a segment

**Data Structures**:
- **Event queue**: Usually a priority queue sorted by x-coordinate
- **Status structure**: Usually a balanced BST (like set in C++) storing active segments sorted by y-coordinate at current sweep line position

### Closest Pair of Points (Line Sweep Version)
**Time Complexity**: O(n log n)
**Alternative to divide and conquer approach**

```cpp
double closest_pair_line_sweep(vector<Point>& points) {
    int n = points.size();
    if (n < 2) return numeric_limits<double>::max();
    
    // Sort points by x-coordinate
    sort(points.begin(), points.end(),
         [](const Point& a, const Point& b) {
             return a.x < b.x || (a.x == b.x && a.y < b.y);
         });
    
    double min_dist = numeric_limits<double>::max();
    set<Point> active_set; // Ordered by y-coordinate
    int left = 0;
    
    for (int i = 0; i < n; i++) {
        // Remove points that are too far in x-direction
        while (left < i && points[i].x - points[left].x > min_dist) {
            active_set.erase(points[left]);
            left++;
        }
        
        // Check points in active set within min_dist in y-direction
        // Since set is ordered by y, we can efficiently find candidates
        Point lower_bound_point = Point(-1000000000, points[i].y - min_dist);
        Point upper_bound_point = Point(1000000000, points[i].y + min_dist);
        
        auto it_low = active_set.lower_bound(lower_bound_point);
        auto it_high = active_set.upper_bound(upper_bound_point);
        
        for (auto it = it_low; it != it_high; ++it) {
            double dist = dist2(points[i], *it);
            if (dist < min_dist * min_dist) {
                min_dist = sqrt(dist);
            }
        }
        
        // Add current point to active set
        active_set.insert(points[i]);
    }
    
    return min_dist;
}
```

### Rectangle Union Area
**Problem**: Find the total area covered by a set of axis-aligned rectangles.

**Solution** (Line sweep along x-axis):
```cpp
struct Event {
    double x;
    int type; // 0 = left edge, 1 = right edge
    double y1, y2;
    
    Event(double _x, int _type, double _y1, double _y2) 
        : x(_x), type(_type), y1(_y1), y2(_y2) {}
    
    bool operator<(const Event& other) const {
        if (x != other.x) return x < other.x;
        return type < other.type; // Process left edges before right edges at same x
    }
};

double rectangle_union_area(vector<tuple<double, double, double, double>>& rects) {
    // Each rect: (x1, y1, x2, y2) where (x1,y1) is bottom-left, (x2,y2) is top-right
    
    vector<Event> events;
    for (auto& rect : rects) {
        double x1 = get<0>(rect);
        double y1 = get<1>(rect);
        double x2 = get<2>(rect);
        double y2 = get<3>(rect);
        
        events.push_back(Event(x1, 0, y1, y2)); // Left edge
        events.push_back(Event(x2, 1, y1, y2)); // Right edge
    }
    
    sort(events.begin(), events.end());
    
    double total_area = 0;
    multiset<pair<double, double>> active_intervals; // (y1, y2) pairs
    double prev_x = events[0].x;
    
    for (const Event& event : events) {
        double width = event.x - prev_x;
        if (width > 0 && !active_intervals.empty()) {
            // Calculate total length of union of active intervals
            double covered_length = 0;
            double current_end = -1e18;
            
            for (auto interval : active_intervals) {
                double start = interval.first;
                double end = interval.second;
                
                if (start > current_end) {
                    covered_length += end - start;
                    current_end = end;
                } else {
                    current_end = max(current_end, end);
                }
            }
            
            total_area += covered_length * width;
        }
        
        // Update active intervals
        if (event.type == 0) { // Left edge
            active_intervals.insert({event.y1, event.y2});
        } else { // Right edge
            active_intervals.erase(active_intervals.find({event.y1, event.y2}));
        }
        
        prev_x = event.x;
    }
    
    return total_area;
}
```

### Skyline Problem
**Problem**: Given buildings represented by (left, right, height), find the skyline formed by these buildings.

**Solution** (Line sweep with max-heap):
```cpp
struct BuildingEvent {
    double x;
    int type; // 0 = start, 1 = end
    int height;
    bool is_start;
    
    BuildingEvent(double _x, int _type, int _height, bool _is_start)
        : x(_x), type(_type), height(_height), is_start(_is_start) {}
    
    bool operator<(const BuildingEvent& other) const {
        if (x != other.x) return x < other.x;
        // If same x, process start events before end events
        // For start events, higher height first
        // For end events, lower height first
        if (type != other.type) {
            return is_start > other.is_start;
        }
        if (is_start) {
            return height > other.height;
        } else {
            return height < other.height;
        }
    }
};

vector<pair<double, int>> get_skyline(vector<tuple<double, double, int>>& buildings) {
    // Each building: (left, right, height)
    
    vector<BuildingEvent> events;
    for (auto& building : buildings) {
        double left = get<0>(building);
        double right = get<1>(building);
        int height = get<2>(building);
        
        events.push_back(BuildingEvent(left, 0, height, true));  // Start event
        events.push_back(BuildingEvent(right, 1, height, false)); // End event
    }
    
    sort(events.begin(), events.end());
    
    vector<pair<double, int>> skyline;
    // Max heap to track active building heights
    // We use negative values because priority_queue is max-heap by default
    priority_queue<int> active_heights;
    active_heights.push(0); // Ground level
    
    // Map to track counts of heights for lazy deletion
    unordered_map<int, int> height_count;
    height_count[0] = 1;
    
    int prev_max_height = 0;
    
    for (const BuildingEvent& event : events) {
        if (event.is_start) {
            // Add height to active set
            active_heights.push(event.height);
            height_count[event.height]++;
        } else {
            // Remove height from active set (lazy deletion)
            height_count[event.height]--;
            // Actual removal happens when we check the top
        }
        
        // Remove invalid heights from top of heap
        while (!active_heights.empty() && height_count[active_heights.top()] == 0) {
            active_heights.pop();
        }
        
        int current_max_height = active_heights.top();
        
        // If max height changed, add point to skyline
        if (current_max_height != prev_max_height) {
            skyline.push_back({event.x, current_max_height});
            prev_max_height = current_max_height;
        }
    }
    
    return skyline;
}
```

---

## Geometric Data Structures

### KD-Tree (2-Dimensional)
**Purpose**: Efficient nearest neighbor search and range search in 2D
**Average Case**: O(log n) for search, O(n log n) for construction
**Worst Case**: O(n) for search (can be mitigated)

```cpp
struct KDTreeNode {
    Point point;
    int id;
    KDTreeNode *left, *right;
    int dimension; // 0 for x, 1 for y
    
    KDTreeNode(const Point& p, int i, int d) 
        : point(p), id(i), left(nullptr), right(nullptr), dimension(d) {}
};

class KDTree {
private:
    KDTreeNode* root;
    int dimensions;
    
    KDTreeNode* build_recursive(vector<pair<Point, int>>& points, 
                               int depth, int left, int right) {
        if (left > right) return nullptr;
        
        int axis = depth % dimensions;
        int mid = (left + right) / 2;
        
        // Sort by axis
        auto compare_by_axis = [axis](const pair<Point, int>& a, 
                                     const pair<Point, int>& b) {
            if (axis == 0) {
                return a.first.x < b.first.x || 
                       (a.first.x == b.first.x && a.first.y < b.first.y);
            } else {
                return a.first.y < b.first.y || 
                       (a.first.y == b.first.y && a.first.x < b.first.x);
            }
        };
        
        sort(points.begin() + left, points.begin() + right + 1, compare_by_axis);
        
        KDTreeNode* node = new KDTreeNode(points[mid].first, points[mid].second, axis);
        
        node->left = build_recursive(points, depth + 1, left, mid - 1);
        node->right = build_recursive(points, depth + 1, mid + 1, right);
        
        return node;
    }
    
    void nearest_neighbor_search(KDTreeNode* node, const Point& target, 
                                int depth, double& best_dist, Point& best_point,
                                int& best_id) {
        if (!node) return;
        
        double dist = dist2(node->point, target);
        if (dist < best_dist) {
            best_dist = dist;
            best_point = node->point;
            best_id = node->id;
        }
        
        int axis = node->dimension;
        double diff = (axis == 0) ? (target.x - node->point.x) : (target.y - node->point.y);
        
        // Search nearer subtree first
        KDTreeNode* first = (diff < 0) ? node->left : node->right;
        KDTreeNode* second = (diff < 0) ? node->right : node->left;
        
        nearest_neighbor_search(first, target, depth + 1, best_dist, best_point, best_id);
        
        // Check if we need to search farther subtree
        double axis_dist = abs(diff);
        if (axis_dist * axis_dist < best_dist) {
            nearest_neighbor_search(second, target, depth + 1, best_dist, best_point, best_id);
        }
    }
    
public:
    KDTree(vector<Point>& points, vector<int>& ids) {
        dimensions = 2;
        vector<pair<Point, int>> points_with_ids;
        for (int i = 0; i < points.size(); i++) {
            points_with_ids.push_back({points[i], ids[i]});
        }
        root = build_recursive(points_with_ids, 0, 0, points.size() - 1);
    }
    
    pair<Point, int> nearest_neighbor(const Point& target) {
        double best_dist = numeric_limits<double>::max();
        Point best_point;
        int best_id = -1;
        
        nearest_neighbor_search(root, target, 0, best_dist, best_point, best_id);
        return {best_point, best_id};
    }
};
```

### QuadTree
**Purpose**: Spatial partitioning for 2D space
**Use Cases**: Collision detection, spatial indexing, image processing

```cpp
struct QuadTreeNode {
    Point top_left;
    Point bottom_right;
    Point point; // Point stored in this node (if leaf)
    QuadTreeNode* children[4]; // NW, NE, SW, SE
    bool is_leaf;
    
    QuadTreeNode(const Point& tl, const Point& br) 
        : top_left(tl), bottom_right(br), is_leaf(true) {
        memset(children, 0, sizeof(children));
    }
};

class QuadTree {
private:
    QuadTreeNode* root;
    int max_points_per_node;
    
    int get_quadrant(const Point& p, const QuadTreeNode* node) {
        double mid_x = (node->top_left.x + node->bottom_right.x) / 2.0;
        double mid_y = (node->top_left.y + node->bottom_right.y) / 2.0;
        
        bool left = (p.x < mid_x);
        bool top = (p.y < mid_y);
        
        if (top && left) return 0;    // NW
        if (top && !left) return 1;   // NE
        if (!top && left) return 2;   // SW
        if (!top && !left) return 3;  // SE
    }
    
    void subdivide(QuadTreeNode* node) {
        double mid_x = (node->top_left.x + node->bottom_right.x) / 2.0;
        double mid_y = (node->top_left.y + node->bottom_right.y) / 2.0;
        
        node->children[0] = new QuadTreeNode(
            Point(node->top_left.x, node->top_left.y),
            Point(mid_x, mid_y)
        ); // NW
        
        node->children[1] = new QuadTreeNode(
            Point(mid_x, node->top_left.y),
            Point(node->bottom_right.x, mid_y)
        ); // NE
        
        node->children[2] = new QuadTreeNode(
            Point(node->top_left.x, mid_y),
            Point(mid_x, node->bottom_right.y)
        ); // SW
        
        node->children[3] = new QuadTreeNode(
            Point(mid_x, mid_y),
            Point(node->bottom_right.x, node->bottom_right.y)
        ); // SE
        
        node->is_leaf = false;
    }
    
    bool insert_recursive(QuadTreeNode* node, const Point& p) {
        // If node is external (no point stored) and not subdivided
        if (node->is_leaf && 
            (node->point.x == 0 && node->point.y == 0) && // Assuming (0,0) indicates empty
            node->children[0] == nullptr) {
            // Check capacity
            int point_count = 0;
            if (node->point.x != 0 || node->point.y != 0) point_count = 1;
            
            if (point_count < max_points_per_node) {
                // Store point in this node
                if (node->point.x == 0 && node->point.y == 0) {
                    node->point = p;
                }
                // In a more complete implementation, we'd store multiple points per leaf
                return true;
            } else {
                // Need to subdivide
                if (node->children[0] == nullptr) {
                    subdivide(node);
                }
                // Try to insert into children
                int quadrant = get_quadrant(p, node);
                return insert_recursive(node->children[quadrant], p);
            }
        } else if (!node->is_leaf) {
            // Internal node, try to insert into children
            int quadrant = get_quadrant(p, node);
            return insert_recursive(node->children[quadrant], p);
        }
        
        return false; // Should not reach here in normal operation
    }
    
public:
    QuadTree(const Point& top_left, const Point& bottom_right, int max_points = 4) 
        : root(new QuadTreeNode(top_left, bottom_right)), 
          max_points_per_node(max_points) {}
    
    bool insert(const Point& p) {
        return insert_recursive(root, p);
    }
};
```

### Range Tree
**Purpose**: Efficient orthogonal range reporting and counting
**Time Complexity**: O(log² n + k) for reporting k points in 2D
**Space Complexity**: O(n log n)

```cpp
// Simplified 2D Range Tree for counting points in rectangle
class RangeTree {
private:
    struct Node {
        Point point;
        Node* left;
        Node* right;
        vector<Point> y_sorted; // Points in subtree sorted by y-coordinate
        
        Node(const Point& p) : point(p), left(nullptr), right(nullptr) {}
    };
    
    Node* root;
    
    Node* build_recursive(vector<Point>& points, int left, int right) {
        if (left > right) return nullptr;
        
        int mid = (left + right) / 2;
        // Sort by x-coordinate
        sort(points.begin() + left, points.begin() + right + 1,
             [](const Point& a, const Point& b) {
                 return a.x < b.x || (a.x == b.x && a.y < b.y);
             });
        
        Node* node = new Node(points[mid]);
        
        // Build y-sorted array for this subtree
        vector<Point> subtree_points(points.begin() + left, points.begin() + right + 1);
        sort(subtree_points.begin(), subtree_points.end(),
             [](const Point& a, const Point& b) {
                 return a.y < b.y || (a.y == b.y && a.x < b.x);
             });
        node->y_sorted = subtree_points;
        
        node->left = build_recursive(points, left, mid - 1);
        node->right = build_recursive(points, mid + 1, right);
        
        return node;
    }
    
    int count_in_range_rec(Node* node, double y1, double y2) {
        if (!node) return 0;
        
        // Count points in y_sorted within [y1, y2] using binary search
        auto it_low = lower_bound(node->y_sorted.begin(), node->y_sorted.end(),
                                 Point(-1e18, y1),
                                 [](const Point& a, const Point& b) {
                                     return a.y < b.y || (a.y == b.y && a.x < b.x);
                                 });
        auto it_high = upper_bound(node->y_sorted.begin(), node->y_sorted.end(),
                                  Point(1e18, y2),
                                  [](const Point& a, const Point& b) {
                                      return a.y < b.y || (a.y == b.y && a.x < b.x);
                                  });
        
        return distance(it_low, it_high);
    }
    
    void query_rec(Node* node, double x1, double x2, double y1, double y2, 
                  vector<Point>& result) {
        if (!node) return;
        
        // If node's point is within range, add it
        if (node->point.x >= x1 && node->point.x <= x2 &&
            node->point.y >= y1 && node->point.y <= y2) {
            result.push_back(node->point);
        }
        
        // Recurse on children if they might contain points in range
        if (node->left && node->left->point.x <= x2) {
            query_rec(node->left, x1, x2, y1, y2, result);
        }
        if (node->right && node->right->point.x >= x1) {
            query_rec(node->right, x1, x2, y1, y2, result);
        }
    }
    
public:
    RangeTree(vector<Point>& points) {
        root = build_recursive(points, 0, points.size() - 1);
    }
    
    // Count points in rectangle [x1, x2] x [y1, y2]
    int count_in_rectangle(double x1, double x2, double y1, double y2) {
        // This is a simplified version - a full range tree would use secondary trees
        // For brevity, we'll implement a basic version
        vector<Point> result;
        query_rec(root, x1, x2, y1, y2, result);
        return result.size();
    }
    
    // Report points in rectangle
    vector<Point> report_in_rectangle(double x1, double x2, double y1, double y2) {
        vector<Point> result;
        query_rec(root, x1, x2, y1, y2, result);
        return result;
    }
};
```

---

## Advanced Topics

### Rotating Calipers
**Purpose**: Technique to solve various convex polygon problems efficiently
**Applications**: 
- Diameter of convex polygon
- Width of convex polygon
- Minimum area enclosing rectangle
- Maximum distance between two convex polygons
- Convex polygon intersection

**Example: Diameter of Convex Polygon**
```cpp
double convex_polygon_diameter(const vector<Point>& hull) {
    int n = hull.size();
    if (n < 2) return 0;
    if (n == 2) return dist2(hull[0], hull[1]);
    
    // Find point with maximum y-coordinate (starting point)
    int k = 1;
    while (abs(cross(hull[n-1], hull[0], hull[(k+1)%n])) > 
           abs(cross(hull[n-1], hull[0], hull[k]))) {
        k++;
    }
    
    double max_dist = 0;
    int i = 0, j = k;
    
    // Roating calipers technique
    for (int count = 0; count < n; count++) {
        max_dist = max(max_dist, dist2(hull[i], hull[j]));
        
        // Advance j or i based on cross product comparison
        int next_i = (i + 1) % n;
        int next_j = (j + 1) % n;
        
        long long cross_val = cross(
            Point(hull[next_i].x - hull[i].x, hull[next_i].y - hull[i].y),
            Point(hull[next_j].x - hull[j].x, hull[next_j].y - hull[j].y)
        );
        
        if (cross_val >= 0) {
            j = next_j;
        } else {
            i = next_i;
        }
        
        // If we've made a full loop, break
        if (i == 0) break;
    }
    
    return sqrt(max_dist);
}
```

### Voronoi Diagrams and Delaunay Triangulation
**Voronoi Diagram**: Partitions plane into regions based on distance to points in a set
**Delaunay Triangulation**: Dual graph of Voronoi diagram; maximizes minimum angle

**Fortune's Algorithm**: O(n log n) algorithm for constructing Voronoi diagrams
**Too complex** to implement fully here, but worth knowing exists

### Sweepline for Line Segment Intersection
**Time Complexity**: O((n + k) log n) where k is number of intersections
**Uses**: Binary search tree to store active segments, priority queue for events

### Incremental Convex Hull
**Purpose**: Add points to convex hull efficiently
**Applications**: Dynamic convex hull problems
**Algorithms**: 
- Andrew's monotone chain with insertion (O(n) per insertion worst case)
- More complex structures with O(log n) per insertion

### Kinetic Data Structures
**Purpose**: Maintain geometric properties as points move along known trajectories
**Applications**: Moving points, collision detection over time
**Complex but powerful** for certain types of problems

### Geometric Hashing
**Purpose**: Object recognition and pattern matching
**Applications**: Pattern recognition, shape matching
**Complex but useful** for certain pattern matching problems

---

## Common Problems and Solutions

### 1. Rectangle Overlap
**Problem**: Determine if two rectangles overlap.

**Solution**:
```cpp
bool is_rectangle_overlap(vector<int>& rec1, vector<int>& rec2) {
    // Check if one rectangle is to the left of the other
    if (rec1[2] <= rec2[0] || rec2[2] <= rec1[0]) return false;
    
    // Check if one rectangle is above the other
    if (rec1[3] <= rec2[1] || rec2[3] <= rec1[1]) return false;
    
    return true;
}
```

### 2. Rectangle Area
**Problem**: Find the total area covered by two rectilinear rectangles.

**Solution**:
```cpp
int computeArea(int ax1, int ay1, int ax2, int ay2, 
                int bx1, int by1, int bx2, int by2) {
    int area1 = (ax2 - ax1) * (ay2 - ay1);
    int area2 = (bx2 - bx1) * (by2 - by1);
    
    int overlap_width = max(0, min(ax2, bx2) - max(ax1, bx1));
    int overlap_height = max(0, min(ay2, by2) - max(ay1, by1));
    int overlap_area = overlap_width * overlap_height;
    
    return area1 + area2 - overlap_area;
}
```

### 3. Valid Rectangle
**Problem**: Given four points, determine if they form a valid rectangle.

**Solution**:
```cpp
bool valid_rectangle(vector<vector<int>>& points) {
    // Calculate all 6 distances between pairs of points
    vector<long long> dists;
    for (int i = 0; i < 4; i++) {
        for (int j = i + 1; j < 4; j++) {
            long long dx = points[i][0] - points[j][0];
            long long dy = points[i][1] - points[j][1];
            dists.push_back(dx * dx + dy * dy);
        }
    }
    
    // Sort distances
    sort(dists.begin(), dists.end());
    
    // For a rectangle: 
    // - 4 equal sides (smallest 4 distances)
    // - 2 equal diagonals (largest 2 distances)
    // - Diagonal^2 = 2 * side^2 (Pythagorean theorem)
    return (dists[0] > 0 && 
            dists[0] == dists[1] && 
            dists[1] == dists[2] && 
            dists[2] == dists[3] && 
            dists[4] == dists[5] && 
            dists[3] * 2 == dists[4]);
}
```

### 4. Minimum Area Rectangle
**Problem**: Given a set of points, find the minimum area of a rectangle formed from these points.

**Solution** (Using hash set for O(n²) approach):
```cpp
double min_area_rectangle(vector<vector<int>>& points) {
    unordered_set<long long> point_set;
    for (auto& p : points) {
        // Encode point as single integer for hashing
        long long key = ((long long)p[0] << 32) | (unsigned int)(p[1] & 0xffffffffLL);
        point_set.insert(key);
    }
    
    double min_area = numeric_limits<double>::max();
    int n = points.size();
    
    for (int i = 0; i < n; i++) {
        for (int j = i + 1; j < n; j++) {
            // Only consider points that could be diagonal of rectangle
            if (points[i][0] == points[j][0] || points[i][1] == points[j][1]) {
                continue; // Same x or y - can't be diagonal
            }
            
            // Check if the other two corners exist
            long long key1 = ((long long)points[i][0] << 32) | 
                           (unsigned int)(points[j][1] & 0xffffffffLL);
            long long key2 = ((long long)points[j][0] << 32) | 
                           (unsigned int)(points[i][1] & 0xffffffffLL);
            
            if (point_set.count(key1) && point_set.count(key2)) {
                double area = abs((double)(points[i][0] - points[j][0]) * 
                                 (double)(points[i][1] - points[j][1]));
                min_area = min(min_area, area);
            }
        }
    }
    
    return (min_area == numeric_limits<double>::max()) ? 0 : min_area;
}
```

### 5. Largest Triangle Area
**Problem**: Given points on a 2D plane, find the largest triangle area.

**Solution** (O(n³) brute force - acceptable for n ≤ 50):
```cpp
double largest_triangle_area(vector<vector<int>>& points) {
    double max_area = 0;
    int n = points.size();
    
    for (int i = 0; i < n; i++) {
        for (int j = i + 1; j < n; j++) {
            for (int k = j + 1; k < n; k++) {
                // Using shoelace formula for triangle area
                long long area2 = abs(
                    (long long)points[i][0] * (points[j][1] - points[k][1]) +
                    (long long)points[j][0] * (points[k][1] - points[i][1]) +
                    (long long)points[k][0] * (points[i][1] - points[j][1])
                );
                max_area = max(max_area, (double)area2 / 2.0);
            }
        }
    }
    return max_area;
}
```

**Optimized Solution** (O(n² log n) using convex hull):
```cpp
double largest_triangle_area_hull(vector<vector<int>>& points) {
    // Convert to Point format
    vector<Point> pts;
    for (auto& p : points) {
        pts.push_back(Point(p[0], p[1]));
    }
    
    // If less than 3 points, area is 0
    if (pts.size() < 3) return 0;
    
    // Compute convex hull
    vector<Point> hull = monotone_chain(pts);
    int n = hull.size();
    
    // If hull has less than 3 points, area is 0
    if (n < 3) return 0;
    
    double max_area = 0;
    
    // For each edge of hull, find point that maximizes area
    // Using rotating calipers technique for maximum triangle area
    for (int i = 0; i < n; i++) {
        int k = (i + 2) % n; // Start with point two steps ahead
        
        for (int j = i + 1; j < i + n - 1; j++) {
            int jj = j % n;
            
            // Move k forward while area increases
            while (true) {
                int kk = (k + 1) % n;
                double area1 = abs(cross(hull[i], hull[jj], hull[k])) / 2.0;
                double area2 = abs(cross(hull[i], hull[jj], hull[kk])) / 2.0;
                
                if (area2 > area1) {
                    k = kk;
                } else {
                    break;
                }
            }
            
            max_area = max(max_area, abs(cross(hull[i], hull[jj], hull[k])) / 2.0);
        }
    }
    
    return max_area;
}
```

### 6. Intersecting Circles
**Problem**: Given two circles, determine if they intersect and find intersection points.

**Solution** (Already covered in Circle Operations section)

### 7. Point Closest to Origin
**Problem**: Given points, find the k closest points to the origin.

**Solution** (Using max-heap):
```cpp
vector<vector<int>> k_closest(vector<vector<int>>& points, int k) {
    // Max heap to store k closest points
    // We store negative distance to simulate max heap with min heap behavior
    priority_queue<pair<long long, vector<int>>> max_heap;
    
    for (auto& point : points) {
        long long dist2 = (long long)point[0] * point[0] + 
                         (long long)point[1] * point[1];
        
        if (max_heap.size() < k) {
            max_heap.push({dist2, point});
        } else if (dist2 < max_heap.top().first) {
            max_heap.pop();
            max_heap.push({dist2, point});
        }
    }
    
    vector<vector<int>> result;
    while (!max_heap.empty()) {
        result.push_back(max_heap.top().second);
        max_heap.pop();
    }
    return result;
}
```

### 8. Line Reflection
**Problem**: Given n points on a 2D plane, find if there is such a line parallel to y-axis that reflects the given points.

**Solution**:
```cpp
bool is_reflected(vector<vector<int>>& points) {
    if (points.empty()) return true;
    
    int min_x = INT_MAX;
    int max_x = INT_MIN;
    unordered_set<long long> point_set;
    
    for (auto& point : points) {
        min_x = min(min_x, point[0]);
        max_x = max(max_x, point[0]);
        // Encode point for hashing
        long long key = ((long long)point[0] << 32) | 
                       (unsigned int)(point[1] & 0xffffffffLL);
        point_set.insert(key);
    }
    
    long long sum = (long long)min_x + max_x;
    
    for (auto& point : points) {
        long long reflected_x = sum - point[0];
        long long key = (reflected_x << 32) | 
                       (unsigned int)(point[1] & 0xffffffffLL);
        if (point_set.find(key) == point_set.end()) {
            return false;
        }
    }
    return true;
}
```

### 9. Convex Polygon Check
**Problem**: Given points in order, determine if they form a convex polygon.

**Solution** (Already covered in Polygon Operations section)

### 10. Polygon Area
**Problem**: Calculate the area of a polygon given its vertices.

**Solution** (Already covered in Polygon Operations section)

### 11. Number of Visible Points
**Problem**: Given points and an angle, find the maximum number of points visible from a given location within the angle.

**Solution**:
```cpp
int visible_points(vector<vector<int>>& points, int angle, 
                   vector<int>& location) {
    int same_point_count = 0;
    vector<double> angles;
    
    int x0 = location[0];
    int y0 = location[1];
    
    for (auto& point : points) {
        int x = point[0];
        int y = point[1];
        
        if (x == x0 && y == y0) {
            same_point_count++;
            continue;
        }
        
        // Calculate angle in radians
        double angle_rad = atan2(y - y0, x - x0);
        angles.push_back(angle_rad);
    }
    
    sort(angles.begin(), angles.end());
    
    // Duplicate angles to handle circular nature
    vector<double> extended_angles;
    for (double a : angles) {
        extended_angles.push_back(a);
        extended_angles.push_back(a + 2 * M_PI);
    }
    
    int max_count = 0;
    int j = 0;
    double angle_rad = angle * M_PI / 180.0; // Convert to radians
    
    for (int i = 0; i < angles.size(); i++) {
        while (j < extended_angles.size() && 
               extended_angles[j] <= angles[i] + angle_rad) {
            j++;
        }
        max_count = max(max_count, j - i);
    }
    
    return max_count + same_point_count;
}
```

### 12. Minimum Time to Visit All Points
**Problem**: Given points, find minimum time to visit all points in order moving diagonally, horizontally, or vertically.

**Solution**:
```cpp
int min_time_to_visit_all_points(vector<vector<int>>& points) {
    int time = 0;
    for (int i = 1; i < points.size(); i++) {
        int dx = abs(points[i][0] - points[i-1][0]);
        int dy = abs(points[i][1] - points[i-1][1]);
        // Time to move from point i-1 to i is max(dx, dy) 
        // because we can move diagonally
        time += max(dx, dy);
    }
    return time;
}
```

### 13. K Points Such That Minimum Distance is Maximized
**Problem**: Given n points, select k points such that the minimum distance between any two selected points is maximized.

**Solution** (Binary search + greedy):
```cpp
bool can_place_k_points(vector<Point>& points, int k, double min_dist) {
    int count = 1;
    Point last_placed = points[0];
    
    for (int i = 1; i < points.size(); i++) {
        if (dist(last_placed, points[i]) >= min_dist) {
            count++;
            last_placed = points[i];
            if (count >= k) return true;
        }
    }
    return false;
}

double max_min_distance(vector<Point>& points, int k) {
    if (points.size() < k) return 0;
    
    // Sort points
    sort(points.begin(), points.end(),
         [](const Point& a, const Point& b) {
             return a.x < b.x || (a.x == b.x && a.y < b.y);
         });
    
    double left = 0;
    double right = 1e9; // Upper bound
    
    // Binary search for answer
    for (int iter = 0; iter < 60; iter++) { // Enough for precision
        double mid = (left + right) / 2;
        if (can_place_k_points(points, k, mid)) {
            left = mid;
        } else {
            right = mid;
        }
    }
    
    return left;
}
```

---

## Common Formulas and Identities

### Vector Identities
1. **Commutativity**: a + b = b + a
2. **Associativity**: (a + b) + c = a + (b + c)
3. **Distributivity**: c(a + b) = ca + cb
4. **Dot Product**: a · b = |a||b|cosθ
5. **Cross Product Magnitude**: |a × b| = |a||b|sinθ
6. **Triple Product**: a · (b × c) = b · (c × a) = c · (a × b)
7. **Lagrange's Identity**: |a × b|² = |a|²|b|² - (a · b)²

### Trigonometric Identities
1. **Pythagorean**: sin²θ + cos²θ = 1
2. **Angle Sum**: 
   - sin(α+β) = sinα cosβ + cosα sinβ
   - cos(α+β) = cosα cosβ - sinα sinβ
3. **Double Angle**:
   - sin(2θ) = 2 sinθ cosθ
   - cos(2θ) = cos²θ - sin²θ = 2cos²θ - 1 = 1 - 2sin²θ
4. **Half Angle**:
   - sin²(θ/2) = (1 - cosθ)/2
   - cos²(θ/2) = (1 + cosθ)/2

### Geometric Formulas
1. **Distance**: d = √((x₂-x₁)² + (y₂-y₁)²)
2. **Midpoint**: M = ((x₁+x₂)/2, (y₁+y₂)/2)
3. **Slope**: m = (y₂-y₁)/(x₂-x₁)
4. **Line Equation**: y - y₁ = m(x - x₁)
5. **Circle Equation**: (x-h)² + (y-k)² = r²
6. **Ellipse Equation**: (x-h)²/a² + (y-k)²/b² = 1
7. **Parabola Equation**: (x-h)² = 4p(y-k) or (y-k)² = 4p(x-h)
8. **Triangle Area**: 
   - Base × Height / 2
   - |x₁(y₂-y₃) + x₂(y₃-y₁) + x₃(y₁-y₂)|/2
   - √[s(s-a)(s-b)(s-c)] (Heron's formula)
9. **Polygon Area**: ½|Σ(xᵢyᵢ₊₁ - xᵢ₊₁yᵢ)|
10. **Circle Area**: πr²
11. **Circle Circumference**: 2πr

### Matrix Transformations (Affine)
1. **Translation**: 
   [1 0 tx]
   [0 1 ty]
   [0 0  1 ]
2. **Scaling**:
   [sx 0  0]
   [0  sy 0]
   [0  0  1]
3. **Rotation** (counter-clockwise by θ):
   [cosθ -sinθ 0]
   [sinθ  cosθ 0]
   [0     0    1]
4. **Shear**:
   [1 shx 0]
   [shy 1  0]
   [0   0  1]
5. **Reflection** (over x-axis):
   [1  0  0]
   [0 -1  0]
   [0  0  1]

---

## Tips and Best Practices

### Precision and Floating Point Issues
1. **Use EPS for comparisons**: 
   ```cpp
   const double EPS = 1e-9;
   bool equal(double a, double b) { return abs(a - b) < EPS; }
   ```
2. **Avoid division when possible**: Use cross products instead of angles
3. **Use squared distances** for comparisons to avoid sqrt
4. **Be careful with very large or very small coordinates**
5. **Consider using long double** for extra precision when needed

### Integer vs Floating Point
1. **Use integer arithmetic** when possible (cross products, dot products)
2. **Only use floating point** when absolutely necessary (angles, distances requiring sqrt)
3. **Rational approximations** can sometimes replace floating point

### Algorithm Selection
1. **For convex hull**: 
   - Monotone chain (Andrew's) - simplest and efficient
   - Graham scan - good for educational purposes
   - Jarvis march - when h (hull size) is very small
2. **For closest pair**:
   - Line sweep - easier to implement correctly
   - Divide and conquer - classic approach
3. **For line intersection**: 
   - Use cross products to avoid division when possible
   - Handle parallel cases carefully
4. **For point in polygon**:
   - Ray casting - simpler to implement
   - Winding number - handles complex polygons better

### Common Mistakes to Avoid
1. **Assuming general position**: Don't assume no three points are collinear unless guaranteed
2. **Ignoring edge cases**: Points on boundaries, zero-area shapes, etc.
3. **Floating point precision errors**: Always use EPS for comparisons
4. **Incorrect angle calculations**: Be careful with quadrants when using atan2
5. **Missing negative zero**: In some systems, -0.0 behaves differently than 0.0
6. **Overlooking symmetry**: Many problems have symmetric solutions that can simplify calculations
7. **Using wrong formula**: Double-check formulas for area, distance, etc.

### Performance Considerations
1. **Precompute when possible**: If you'll use the same values multiple times
2. **Use reserve() for vectors**: If you know approximate size
3. **Consider cache efficiency**: Access patterns matter for performance
4. **Batch operations**: Process multiple points together when possible
5. **Early termination**: Stop as soon as you know the answer

### Testing Strategies
1. **Test with known shapes**: Triangles, rectangles, circles
2. **Test edge cases**: Collinear points, duplicate points, zero-area shapes
3. **Test with random points**: Use random number generators
4. **Test boundary conditions**: Minimum/maximum inputs
5. **Compare with brute force**: For small n, compare with O(n³) or O(n⁴) solutions
6. **Visualize when possible**: Debug by drawing points and shapes

### Libraries and Resources
1. **CGAL**: The Computational Geometry Algorithms Library (powerful but heavy)
2. **Boost.Geometry**: Part of Boost libraries
3. **Shapely**: Python library (good for learning concepts)
4. **Java Topology Suite (JTS)**: For Java developers
5. **ROS Geometry**: For robotics applications

### When to Skip Geometry
1. **When problem can be solved combinatorially**
2. **When approximation is acceptable**
3. **When constraints allow brute force**
4. **When you can transform to non-geometric problem**
5. **When time is limited and geometry is complex**

### Final Advice
1. **Master the basics**: Be extremely comfortable with points, vectors, lines, and basic operations
2. **Understand the theory**: Know why formulas work, not just how to use them
3. **Recognize patterns**: Learn to map geometric problems to known algorithms
4. **Practice implementation**: The best way to learn is by implementing and debugging
5. **Learn from mistakes**: When your solution fails, understand why and how to fix it
6. **Consider constraints**: Always check if your chosen algorithm fits the problem limits
7. **Think about alternatives**: Sometimes a combinatorial approach works better than geometric
8. **Stay updated**: New techniques and optimizations are constantly developed
9. **Use existing code**: Don't reinvent the wheel unless necessary (but understand how it works)
10. **Practice visualization**: The ability to visualize geometric relationships is invaluable

Remember that computational geometry is not just about memorizing formulas—it's about developing spatial intuition and the ability to translate geometric problems into algorithmic solutions. The ability to recognize when a problem has a geometric component and to choose the right approach is often more valuable than knowing the exact implementation details.

Happy coding, and may your angles always be acute and your points always in general position! 🚀