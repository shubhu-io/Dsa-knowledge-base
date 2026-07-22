# Competitive Programming Mathematics

## Essential Mathematical Concepts for Competitive Programming

This document covers fundamental mathematical concepts, theorems, and techniques that are frequently used in competitive programming problems.

---

## Table of Contents
1. [Number Theory](#number-theory)
2. [Combinatorics](#combinatorics)
3. [Modular Arithmetic](#modular-arithmetic)
4. [Probability](#probability)
5. [Geometry](#geometry)
6. [Algebra](#algebra)
7. [Sequences and Series](#sequences-and-series)
8. [Miscellaneous Topics](#miscellaneous-topics)

---

## Number Theory

### Prime Numbers
**Definition**: A prime number is a natural number greater than 1 that has no positive divisors other than 1 and itself.

**Sieve of Eratosthenes** (O(n log log n)):
```cpp
vector<bool> sieve(int n) {
    vector<bool> is_prime(n + 1, true);
    is_prime[0] = is_prime[1] = false;
    for (int i = 2; i * i <= n; i++) {
        if (is_prime[i]) {
            for (int j = i * i; j <= n; j += i) {
                is_prime[j] = false;
            }
        }
    }
    return is_prime;
}
```

**Prime Factorization** (O(√n)):
```cpp
vector<pair<int, int>> factorize(int n) {
    vector<pair<int, int>> factors;
    for (int i = 2; i * i <= n; i++) {
        if (n % i == 0) {
            int count = 0;
            while (n % i == 0) {
                n /= i;
                count++;
            }
            factors.push_back({i, count});
        }
    }
    if (n > 1) {
        factors.push_back({n, 1});
    }
    return factors;
}
```

**Euler's Totient Function** φ(n):
- Counts numbers ≤ n that are coprime with n
- Formula: φ(n) = n × ∏(1 - 1/p) for all prime factors p of n
- Properties:
  - φ(p) = p - 1 for prime p
  - φ(p^k) = p) = p^a - p^(a-1)
  - If gcd(a, b) = 1, then φ(ab) = φ(a)φ(b)

```cpp
int phi(int n) {
    int result = n;
    for (int i = 2; i * i <= n; i++) {
        if (n % i == 0) {
            while (n % i == 0) n /= i;
            result -= result / i;
        }
    }
    if (n > 1) result -= result / n;
    return result;
}
```

### Greatest Common Divisor (GCD)
**Euclidean Algorithm** (O(log min(a,b))):
```cpp
int gcd(int a, int b) {
    return b == 0 ? a : gcd(b, a % b);
}
```

**Extended Euclidean Algorithm**:
- Finds integers x and y such that ax + by = gcd(a,b)
```cpp
int extended_gcd(int a, int b, int& x, int& y) {
    if (b == 0) {
        x = 1;
        y = 0;
        return a;
    }
    int x1, y1;
    int gcd = extended_gcd(b, a % b, x1, y1);
    x = y1;
    y = x1 - (a / b) * y1;
    return gcd;
}
```

### Least Common Multiple (LCM)
- LCM(a, b) = |a × b| / GCD(a, b)
- For multiple numbers: LCM(a,b,c) = LCM(LCM(a,b), c)

### Modular Exponentiation
**Binary Exponentiation** (O(log n)):
```cpp
long long mod_pow(long long base, long long exp, long long mod) {
    long long result = 1;
    base %= mod;
    while (exp > 0) {
        if (exp & 1) result = (result * base) % mod;
        base = (base * base) % mod;
        exp >>= 1;
    }
    return result;
}
```

### Modular Inverse
- Exists only when gcd(a, m) = 1
- Using Fermat's Little Theorem (when m is prime): a^(-1) ≡ a^(m-2) (mod m)
- Using Extended Euclidean Algorithm

```cpp
long long mod_inverse(long long a, long long m) {
    // Using extended Euclidean algorithm
    long long x, y;
    long long g = extended_gcd(a, m, x, y);
    if (g != 1) return -1; // Inverse doesn't exist
    return (x % m + m) % m;
}
```

### Chinese Remainder Theorem (CRT)
- Solves system of congruences:
  x ≡ a₁ (mod m₁)
  x ≡ a₂ (mod m₂)
  ...
  x ≡ aₖ (mod mₖ)
- Where mᵢ are pairwise coprime

```cpp
long long chinese_remainder(vector<int>& moduli, vector<int>& remainders) {
    long long M = 1;
    for (int m : moduli) M *= m;
    
    long long result = 0;
    for (int i = 0; i < moduli.size(); i++) {
        long long Mi = M / moduli[i];
        long long inv = mod_inverse(Mi, moduli[i]);
        result = (result + remainders[i] * Mi * inv) % M;
    }
    return (result + M) % M;
}
```

### Factorials and Exponents in Factorials
**Exponent of prime p in n!** (Legendre's formula):
- νₚ(n!) = ⌊n/p⌋ + ⌊n/p²⌋ + ⌊n/p³⌋ + ...

```cpp
int exponent_in_factorial(int n, int p) {
    int count = 0;
    for (long long i = p; n / i >= 1; i *= p) {
        count += n / i;
    }
    return count;
}
```

### Trailing Zeros in Factorial
- Number of trailing zeros in n! = exponent of 5 in n! (since there are always more 2s than 5s)
```cpp
int trailing_zeros(int n) {
    int count = 0;
    for (long long i = 5; n / i >= 1; i *= 5) {
        count += n / i;
    }
    return count;
}
```

---

## Combinatorics

### Permutations and Combinations
- Permutations (ordered): P(n, k) = n! / (n-k)!
- Combinations (unordered): C(n, k) = n! / (k! * (n-k)!)

### Binomial Coefficients
**Pascal's Triangle**: C(n, k) = C(n-1, k-1) + C(n-1, k)
**Symmetry**: C(n, k) = C(n, n-k)
**Boundary**: C(n, 0) = C(n, n) = 1

**Precomputation** (O(n²)):
```cpp
const int MAXN = 1000;
const int MOD = 1000000007;
int C[MAXN + 1][MAXN + 1];

void precompute_binomial() {
    for (int i = 0; i <= MAXN; i++) {
        C[i][0] = C[i][i] = 1;
        for (int j = 1; j < i; j++) {
            C[i][j] = (C[i-1][j-1] + C[i-1][j]) % MOD;
        }
    }
}
```

**Using Factorials** (O(n) precomputation, O(1) query):
```cpp
const int MAXN = 1000000;
const int MOD = 1000000007;
long long fact[MAXN + 1];
long long inv_fact[MAXN + 1];

long long mod_pow(long long base, long long exp, long long mod) {
    long long result = 1;
    base %= mod;
    while (exp > 0) {
        if (exp & 1) result = (result * base) % mod;
        base = (base * base) % mod;
        exp >>= 1;
    }
    return result;
}

void precompute_factorials() {
    fact[0] = 1;
    for (int i = 1; i <= MAXN; i++) {
        fact[i] = fact[i-1] * i % MOD;
    }
    inv_fact[MAXN] = mod_pow(fact[MAXN], MOD - 2, MOD);
    for (int i = MAXN; i > 0; i--) {
        inv_fact[i-1] = inv_fact[i] * i % MOD;
    }
}

long long binomial(int n, int k) {
    if (k < 0 || k > n) return 0;
    return fact[n] * inv_fact[k] % MOD * inv_fact[n-k] % MOD;
}
```

### Stars and Bars Theorem
- Number of ways to put n identical items into k distinct boxes: C(n+k-1, k-1)
- Number of ways to put n identical items into k distinct boxes with at least one item in each box: C(n-1, k-1)

### Inclusion-Exclusion Principle
For counting elements in union of sets:
|A₁ ∪ A₂ ∪ ... ∪ Aₙ| = Σ|Aᵢ| - Σ|Aᵢ ∩ Aⱼ| + Σ|Aᵢ ∩ Aⱼ ∩ Aₖ| - ... + (-1)^(n+1)|A₁ ∩ A₂ ∩ ... ∩ Aₙ|

### Derangements
Number of permutations of n elements where no element appears in its original position:
!n = n! × Σ(-1)^k/k! for k=0 to n
Recurrence: !n = (n-1)(!(n-1) + !(n-2))
Base cases: !0 = 1, !1 = 0

```cpp
long long derangement(int n) {
    if (n == 0) return 1;
    if (n == 1) return 0;
    
    vector<long long> d(n + 1);
    d[0] = 1;
    d[1] = 0;
    
    for (int i = 2; i <= n; i++) {
        d[i] = (i - 1) * (d[i-1] + d[i-2]);
    }
    return d[n];
}
```

---

## Modular Arithmetic

### Basic Properties
1. (a + b) mod m = ((a mod m) + (b mod m)) mod m
2. (a - b) mod m = ((a mod m) - (b mod m) + m) mod m
3. (a × b) mod m = ((a mod m) × (b mod m)) mod m
4. a^b mod m can be computed efficiently using binary exponentiation

### Modular Linear Equations
Solve: ax ≡ b (mod m)
- Solution exists iff gcd(a, m) divides b
- If solution exists, there are exactly gcd(a, m) solutions modulo m
- To find one solution: use extended Euclidean algorithm

### Fermat's Little Theorem
If p is prime and a is not divisible by p:
a^(p-1) ≡ 1 (mod p)
Therefore: a^(-1) ≡ a^(p-2) (mod p)  [modular inverse]

### Euler's Theorem
If gcd(a, m) = 1:
a^φ(m) ≡ 1 (mod m)
Therefore: a^(-1) ≡ a^(φ(m)-1) (mod m)

### Chinese Remainder Theorem (CRT)
Already covered in Number Theory section.

### Lucas Theorem
For computing C(n, k) mod p where p is prime:
Write n and k in base p:
n = n₀ + n₁p + n₂p² + ...
k = k₀ + k₁p + k₂p² + ...
Then: C(n, k) ≡ ∏ C(nᵢ, kᵢ) (mod p)

```cpp
int lucas_theory(int n, int k, int p) {
    if (k == 0) return 1;
    int ni = n % p;
    int ki = k % p;
    if (ki > ni) return 0;
    return (lucas_theory(n/p, k/p, p) * binomial(ni, ki)) % p;
}
```

---

## Probability

### Basic Concepts
- Sample Space (S): Set of all possible outcomes
- Event (E): Subset of sample space
- Probability: P(E) = |E| / |S| for equally likely outcomes

### Probability Rules
1. Complement: P(A') = 1 - P(A)
2. Addition: P(A ∪ B) = P(A) + P(B) - P(A ∩ B)
3. Multiplication: P(A ∩ B) = P(A) × P(B|A) = P(B) × P(A|B)
4. Independence: A and B independent iff P(A ∩ B) = P(A) × P(B)
5. Total Probability: If B₁, B₂, ..., Bₙ partition sample space, then P(A) = Σ P(A|Bᵢ)P(Bᵢ)
6. Bayes' Theorem: P(A|B) = P(B|A)P(A) / P(B)

### Expected Value
For discrete random variable X with values x₁, x₂, ..., xₙ and probabilities p₁, p₂, ..., pₙ:
E[X] = Σ xᵢpᵢ

Linearity of expectation: E[aX + bY] = aE[X] + bE[Y] (holds even if X and Y are dependent)

### Variance
Var(X) = E[(X - μ)²] = E[X²] - (E[X])²
For independent variables: Var(X + Y) = Var(X) + Var(Y)

### Common Distributions
**Binomial Distribution**: n independent trials, success probability p
- P(X = k) = C(n, k) × p^k × (1-p)^(n-k)
- E[X] = np
- Var(X) = np(1-p)

**Geometric Distribution**: Number of trials until first success
- P(X = k) = (1-p)^(k-1) × p
- E[X] = 1/p
- Var(X) = (1-p)/p²

### Randomized Algorithms
**Monte Carlo Algorithm**: May produce incorrect result with small probability
**Las Vegas Algorithm**: Always produces correct result, but running time is random

**Fermat Primality Test** (Monte Carlo):
```cpp
bool is_prime_fermat(long long n, int iterations = 5) {
    if (n < 2) return false;
    if (n == 2) return true;
    
    random_device rd;
    mt19937 gen(rd());
    uniform_int_distribution<long long> dis(2, n-2);
    
    for (int i = 0; i < iterations; i++) {
        long long a = dis(gen);
        if (mod_pow(a, n-1, n) != 1) {
            return false; // Definitely composite
        }
    }
    return true; // Probably prime
}
```

---

## Geometry

### Coordinate Geometry
**Distance Formula**: d = √((x₂-x₁)² + (y₂-y₁)²)
**Midpoint**: ((x₁+x₂)/2, (y₁+y₂)/2)
**Slope**: m = (y₂-y₁)/(x₂-x₁) (undefined for vertical lines)

### Vectors
**Dot Product**: a·b = |a||b|cosθ = a₁b₁ + a₂b₂
**Cross Product (2D)**: a×b = a₁b₂ - a₂b₁ (scalar representing signed area)
**Cross Product (3D)**: a×b = (a₂b₃-a₃b₂, a₃b₁-a₁b₃, a₁b₂-a₂b₁)

### Lines
**Point-Slope Form**: y - y₁ = m(x - x₁)
**Slope-Intercept Form**: y = mx + b
**Standard Form**: Ax + By = C
**Parametric Form**: x = x₀ + at, y = y₀ + bt

**Distance from point (x₀,y₀) to line Ax + By + C = 0**:
d = |Ax₀ + By₀ + C| / √(A² + B²)

### Circles
**Standard Equation**: (x-h)² + (y-k)² = r² (center (h,k), radius r)
**General Equation**: x² + y² + Dx + Ey + F = 0
- Center: (-D/2, -E/2)
- Radius: √((D²+E²)/4 - F)

### Triangles
**Area**:
- Using base and height: A = bh/2
- Using coordinates: A = |x₁(y₂-y₃) + x₂(y₃-y₁) + x₃(y₁-y₂)|/2
- Using side lengths (Heron's formula): A = √[s(s-a)(s-b)(s-c)] where s = (a+b+c)/2
- Using two sides and included angle: A = ab sin(C)/2

**Important Points**:
- Centroid: ((x₁+x₂+x₃)/3, (y₁+y₂+y₃)/3)
- Circumcenter: Intersection of perpendicular bisectors
- Incenter: Intersection of angle bisectors
- Orthocenter: Intersection of altitudes

### Polygons
**Area of Simple Polygon** (Shoelace formula):
A = 1/2 |Σ(xᵢyᵢ₊₁ - xᵢ₊₁yᵢ)| for i=0 to n-1 (with xₙ=x₀, yₙ=y₀)

**Pick's Theorem** (for lattice polygons):
A = I + B/2 - 1
where I = number of interior lattice points, B = number of boundary lattice points

### Trigonometry
**Basic Ratios**:
- sin θ = opposite/hypotenuse
- cos θ = adjacent/hypotenuse
- tan θ = opposite/adjacent

**Pythagorean Identity**: sin²θ + cos²θ = 1
**Reciprocal Identities**: 
- csc θ = 1/sin θ
- sec θ = 1/cos θ
- cot θ = 1/tan θ

**Angle Sum/Difference**:
- sin(α±β) = sinα cosβ ± cosα sinβ
- cos(α±β) = cosα cosβ ∓ sinα sinβ
- tan(α±β) = (tanα ± tanβ) / (1 ∓ tanα tanβ)

**Double Angle**:
- sin(2θ) = 2 sinθ cosθ
- cos(2θ) = cos²θ - sin²θ = 2cos²θ - 1 = 1 - 2sin²θ
- tan(2θ) = 2tanθ / (1 - tan²θ)

### Law of Sines
a/sin A = b/sin B = c/sin C = 2R (where R is circumradius)

### Law of Cosines
a² = b² + c² - 2bc cos A
b² = a² + c² - 2ac cos B
c² = a² + b² - 2ab cos C

### Coordinate Geometry Problems
**Point in Polygon** (Ray Casting Algorithm):
```cpp
bool point_in_polygon(vector<Point>& polygon, Point p) {
    int n = polygon.size();
    bool inside = false;
    
    for (int i = 0, j = n-1; i < n; j = i++) {
        if (((polygon[i].y > p.y) != (polygon[j].y > p.y)) &&
            (p.x < (polygon[j].x - polygon[i].x) * (p.y - polygon[i].y) / 
             (double)(polygon[j].y - polygon[i].y) + polygon[i].x)) {
            inside = !inside;
        }
    }
    return inside;
}
```

**Line Intersection**:
```cpp
// Returns true if line segments p1q1 and p2q2 intersect
bool do_intersect(Point p1, Point q1, Point p2, Point q2) {
    // Find the four orientations needed for general and special cases
    int o1 = orientation(p1, q1, p2);
    int o2 = orientation(p1, q1, q2);
    int o3 = orientation(p2, q2, p1);
    int o4 = orientation(p2, q2, q1);
    
    // General case
    if (o1 != o2 && o3 != o4)
        return true;
    
    // Special Cases
    // p1, q1 and p2 are collinear and p2 lies on segment p1q1
    if (o1 == 0 && on_segment(p1, p2, q1)) return true;
    
    // p1, q1 and q2 are collinear and q2 lies on segment p1q1
    if (o2 == 0 && on_segment(p1, q2, q1)) return true;
    
    // p2, q2 and p1 are coplanar and p1 lies on segment p2q2
    if (o3 == 0 && on_segment(p2, p1, q2)) return true;
    
    // p2, q2 and q1 are coplanar and q1 lies on segment p2q2
    if (o4 == 0 && on_segment(p2, q1, q2)) return true;
    
    return false;
}

// To find orientation of ordered triplet (p, q, r).
// Returns:
// 0 --> p, q and r are collinear
// 1 --> Clockwise
// 2 --> Counterclockwise
int orientation(Point p, Point q, Point r) {
    int val = (q.y - p.y) * (r.x - q.x) - (q.x - p.x) * (r.y - q.y);
    if (val == 0) return 0;  // collinear
    return (val > 0) ? 1 : 2; // clock or counterclockwise
}

// Check if point q lies on segment pr
bool on_segment(Point p, Point q, Point r) {
    if (q.x <= max(p.x, r.x) && q.x >= min(p.x, r.x) &&
        q.y <= max(p.y, r.y) && q.y >= min(p.y, r.y))
        return true;
    return false;
}
```

---

## Algebra

### Logarithms
**Definition**: logₐ(b) = c means a^c = b
**Properties**:
- logₐ(xy) = logₐ(x) + logₐ(y)
- logₐ(x/y) = logₐ(x) - logₐ(y)
- logₐ(x^b) = b logₐ(x)
- Change of base: logₐ(b) = log_c(b) / log_c(a)

**Common Logarithms**:
- ln(x) = logₑ(x) (natural log)
- log₁₀(x) (common log)
- lg(x) = log₂(x) (binary log, common in CS)

### Exponents
**Properties**:
- a^m × a^n = a^(m+n)
- a^m / a^n = a^(m-n)
- (a^m)^n = a^(mn)
- (ab)^m = a^m b^m
- (a/b)^m = a^m / b^m
- a^0 = 1 (for a ≠ 0)
- a^(-n) = 1/a^n

### Polynomials
**Degree**: Highest power of variable
**Roots/Zeros**: Values of x for which P(x) = 0
**Factor Theorem**: (x-r) is factor of P(x) iff P(r) = 0
**Remainder Theorem**: When P(x) is divided by (x-r), remainder is P(r)

**Vieta's Formulas** (for polynomial axⁿ + bxⁿ⁻¹ + ... + k = 0):
- Sum of roots = -b/a
- Sum of products of roots taken two at a time = c/a
- ...
- Product of roots = (-1)ⁿ × k/a

### Sequences and Series
**Arithmetic Progression (AP)**:
- aₙ = a₁ + (n-1)d
- Sum: Sₙ = n/2 × (2a₁ + (n-1)d) = n/2 × (a₁ + aₙ)

**Geometric Progression (GP)**:
- aₙ = a₁ × r^(n-1)
- Sum: Sₙ = a₁(1-r^n)/(1-r) for r ≠ 1
- Infinite sum: S∞ = a₁/(1-r) for |r| < 1

**Harmonic Progression (HP)**: Reciprocals form AP

### Complex Numbers
**Form**: z = a + bi where i² = -1
**Modulus**: |z| = √(a²+b²)
**Argument**: arg(z) = tan⁻¹(b/a) (with appropriate quadrant adjustment)
**Polar Form**: z = r(cos θ + i sin θ) = re^(iθ)
**De Moivre's Theorem**: (r(cos θ + i sin θ))^n = r^n (cos(nθ) + i sin(nθ))

### Matrices
**Operations**:
- Addition: Element-wise
- Multiplication: (AB)ᵢⱼ = Σ AᵢₖBₖⱼ
- Transpose: (Aᵀ)ᵢⱼ = Aⱼᵢ
- Determinant: Special scalar value
- Inverse: A⁻¹ such that AA⁻¹ = I

**Properties**:
- det(AB) = det(A)det(B)
- det(Aᵀ) = det(A)
- If A is invertible, det(A⁻¹) = 1/det(A)
- Trace: tr(A) = sum of diagonal elements
- tr(A+B) = tr(A) + tr(B)
- tr(AB) = tr(BA)

---

## Sequences and Series

### Arithmetic Sequences
**Definition**: Sequence where difference between consecutive terms is constant
**General Term**: aₙ = a₁ + (n-1)d
**Sum of First n Terms**: Sₙ = n/2 × (2a₁ + (n-1)d) = n/2 × (a₁ + aₙ)

### Geometric Sequences
**Definition**: Sequence where ratio between consecutive terms is constant
**General Term**: aₙ = a₁ × r^(n-1)
**Sum of First n Terms**: Sₙ = a₁(1-r^n)/(1-r) for r ≠ 1
**Sum to Infinity**: S∞ = a₁/(1-r) for |r| < 1

### Harmonic Sequences
**Definition**: Sequence whose reciprocals form an arithmetic sequence
**General Term**: aₙ = 1/(a₁ + (n-1)d) where 1/a₁, 1/a₂, ... is AP

### Fibonacci Sequence
**Definition**: F₀ = 0, F₁ = 1, Fₙ = Fₙ₋₁ + Fₙ₋₂ for n ≥ 2
**Properties**:
- Fₙ₋₁Fₙ₊₁ - Fₙ² = (-1)ⁿ (Cassini's identity)
- gcd(Fₘ, Fₙ) = F_gcd(m,n)
- Sum of first n Fibonacci numbers: F₀ + F₁ + ... + Fₙ = Fₙ₊₂ - 1
- Binet's Formula: Fₙ = (φⁿ - ψⁿ)/√5 where φ = (1+√5)/2, ψ = (1-√5)/2

### Recurrence Relations
**Linear Homogeneous Recurrence with Constant Coefficients**:
aₙ = c₁aₙ₋₁ + c₂aₙ₋₂ + ... + cₖaₙ₋ₖ

**Characteristic Equation**: rᵏ - c₁rᵏ⁻¹ - c₂rᵏ⁻² - ... - cₖ = 0

**Solution Method**:
1. Find roots of characteristic equation
2. General solution: aₙ = A₁r₁ⁿ + A₂r₂ⁿ + ... + Aₖrₖⁿ (for distinct roots)
3. For repeated roots: multiply by powers of n
4. Use initial conditions to find constants

**Example**: Fibonacci sequence
- Recurrence: Fₙ = Fₙ₋₁ + Fₙ₋₂
- Characteristic equation: r² - r - 1 = 0
- Roots: φ = (1+√5)/2, ψ = (1-√5)/2
- Solution: Fₙ = (φⁿ - ψⁿ)/√5

### Summation Techniques
**Telescoping Series**: Terms cancel out
Example: Σ(1/i - 1/(i+1)) from i=1 to n = 1 - 1/(n+1)

**Summation by Parts** (Discrete Integration by Parts):
Σ aᵢ(bᵢ₊₁ - bᵢ) = aₙbₙ₊₁ - a₁b₁ - Σ (aᵢ₊₁ - aᵢ)bᵢ₊₁

**Generating Functions**: 
Ordinary generating function for sequence {aₙ}: A(x) = Σ aₙxⁿ
Exponential generating function: A(x) = Σ aₙxⁿ/n!

---

## Miscellaneous Topics

### Bit Manipulation
**Basic Operations**:
- Set bit i: x |= (1 << i)
- Clear bit i: x &= ~(1 << i)
- Toggle bit i: x ^= (1 << i)
- Test bit i: (x >> i) & 1
- Rightmost set bit: x & (-x)
- Isolate rightmost 0 bit: ~x & (x+1)
- Turn off rightmost set bit: x & (x-1)
- Turn on rightmost 0 bit: x | (x+1)

**Common Tricks**:
- Swapping without temp: x ^= y; y ^= x; x ^= y
- Absolute value (for two's complement): (x + (x>>31)) ^ (x>>31)
- Check if power of two: x > 0 && (x & (x-1)) == 0
- Count set bits: __builtin_popcount(x) (GCC) or manual loop
- Round up to next power of two: 
  ```cpp
  unsigned int next_power_of_2(unsigned int x) {
      if (x == 0) return 1;
      x--;
      x |= x >> 1;
      x |= x >> 2;
      x |= x >> 4;
      x |= x >> 8;
      x |= x >> 16;
      return x+1;
  }
  ```

### Gray Code
**Definition**: Binary numeral system where two successive values differ in only one bit
**Generation**: 
- n-bit Gray code can be generated from (n-1)-bit Gray code
- G(n) = 0G(n-1) + 1 reverse(G(n-1))
- Direct formula: G(i) = i ^ (i >> 1)

### Invariants and Monovariants
**Invariant**: Property that remains unchanged during process
**Monovariant**: Property that monotonically increases or decreases

**Applications**:
- Proving algorithm correctness
- Proving termination
- Finding bounds on steps

### Pigeonhole Principle
If n items are put into m containers, with n > m, then at least one container must contain more than one item.

**Generalized**: If n items are put into m containers, then at least one container contains at least ⌈n/m⌉ items.

### Extremal Principle
Look at extreme cases (maximum, minimum, boundary) to derive contradictions or insights.

### Induction
**Mathematical Induction**:
1. Base case: Prove statement for n=0 or n=1
2. Inductive step: Assume true for n=k, prove for n=k+1

**Strong Induction**: Assume true for all values up to k, prove for k+1

### Recursion vs Iteration
**Recursion**: Function calls itself
- Pros: Often more intuitive for recursive problems (trees, divide and conquer)
- Cons: Stack overflow risk, overhead

**Iteration**: Uses loops
- Pros: Generally more efficient, no stack limits
- Cons: May be less intuitive for some problems

### Search Algorithms
**Linear Search**: O(n)
**Binary Search**: O(log n) on sorted array
**Ternary Search**: O(log n) for unimodal functions
**Exponential Search**: O(log n) for unbounded/search space
**Interpolation Search**: O(log log n) for uniformly distributed data

### Sorting Algorithms
**Comparison-Based** (Ω(n log n) lower bound):
- Merge Sort: O(n log n) stable
- Quick Sort: O(n log n) average, O(n²) worst-case
- Heap Sort: O(n log n) in-place
- Insertion Sort: O(n²) good for small/nearly sorted
- Bubble Sort: O(n²) mainly educational

**Non-Comparison-Based**:
- Counting Sort: O(n+k) where k is range
- Radix Sort: O(d(n+k)) where d is number of digits
- Bucket Sort: O(n+k) average case

### String Algorithms
**Knuth-Morris-Pratt (KMP)**: O(n+m) pattern matching
**Rabin-Karp**: O(n+m) average, O(nm) worst-case with rolling hash
**Z-Algorithm**: O(n+m) pattern matching
**Manacher's Algorithm**: O(n) longest palindromic substring
**Suffix Array**: O(n log n) construction, O(m log n) query
**Suffix Automaton**: O(n) construction, O(m) query

### Graph Algorithms
**Traversal**: BFS (O(V+E)), DFS (O(V+E))
**Shortest Path**:
- Unweighted: BFS
- Non-negative weights: Dijkstra (O(E log V))
- Negative weights: Bellman-Ford (O(VE))
- All-pairs: Floyd-Warshall (O(V³)), Johnson's (O(V²log V + VE))
**Minimum Spanning Tree**:
- Kruskal: O(E log E)
- Prim: O(E log V) with binary heap
**Topological Sort**: O(V+E)
**Strongly Connected Components**: Kosaraju's/Tarjan's (O(V+E))
**Maximum Flow**: Ford-Fulkerson (O(E·max_flow)), Edmonds-Karp (O(VE²)), Dinic's (O(V²E))

### Data Structures
**Arrays**: O(1) access, O(n) insert/delete
**Linked Lists**: O(n) access, O(1) insert/delete at known position
**Stacks**: LIFO, O(1) push/pop
**Queues**: FIFO, O(1) enqueue/dequeue
**Heaps/Priority Queues**: O(log n) insert/extract-min/max
**Hash Tables**: O(1) average insert/lookup/delete
**Binary Search Trees**: O(h) operations where h is height
**Balanced BSTs** (AVL, Red-Black): O(log n) operations
**Segment Trees**: O(log n) range query/update
**Binary Indexed Trees (Fenwick)**: O(log n) prefix sum/update
**Tries**: O(L) string operations where L is string length
**Disjoint Set Union (Union-Find)**: O(α(n)) per operation (nearly constant)

---

## Problem-Solving Strategies

### 1. Understand the Problem
- Read carefully multiple times
- Identify inputs, outputs, constraints
- Determine what is being asked
- Consider edge cases

### 2. Explore Examples
- Work through small examples manually
- Look for patterns
- Try to generalize from examples

### 3. Choose Approach
- Brute force (if constraints allow)
- Greedy (if optimal substructure and greedy choice property)
- Dynamic programming (if overlapping subproblems and optimal substructure)
- Divide and conquer (if problem can be split into independent subproblems)
- Graph algorithms (if problem involves relationships/connections)
- Mathematical formulation (if problem has mathematical structure)
- Data structures (if efficient querying/updating needed)

### 4. Implement and Test
- Write clean, modular code
- Test with given examples
- Test with edge cases
- Test with random small cases (compare with brute force)
- Verify complexity meets constraints

### 5. Optimize
- Identify bottlenecks
- Consider alternative algorithms
- Apply known optimizations (e.g., space optimization in DP)
- Use appropriate data structures

### Common Patterns to Recognize
- **Sliding Window**: For subarray/substring problems with constraints
- **Two Pointers**: For sorted arrays or linked lists
- **Binary Search**: For monotonic functions or sorted arrays
- **Depth-First Search**: For tree/graph traversal, backtracking
- **Breadth-First Search**: For shortest path in unweighted graphs
- **Dynamic Programming**: For optimization problems with overlapping subproblems
- **Greedy**: For problems where local optimum leads to global optimum
- **Backtracking**: For constraint satisfaction problems
- **Divide and Conquer**: For problems that can be split into similar subproblems

### When to Use What
- **Small constraints (n ≤ 20)**: Bitmask DP, brute force with pruning
- **Moderate constraints (n ≤ 1000)**: O(n²) DP, DFS/BFS on graphs
- **Large constraints (n ≤ 10⁵)**: O(n log n) algorithms, segment trees, heap
- **Very large constraints (n ≤ 10⁶ or more)**: O(n) or O(n log n) with low constant, math formulas
- **Multiple queries**: Preprocessing + O(log n) or O(1) per query
- **Updates and queries**: Segment tree, Fenwick tree, balanced BST
- **Strings**: KMP, Z-algorithm, rolling hash, suffix array/trie
- **Geometry**: Line intersection, convex hull, rotating calipers
- **Probability**: Expected value, linearity of expectation, DP on states
- **Number theory**: Modular arithmetic, prime sieves, GCD/LCM

---

## Practice Recommendations

### By Topic
**Number Theory**: 
- Sieve of Eratosthenes
- GCD/LCM problems
- Modular exponentiation
- Chinese Remainder Theorem
- Factorial problems
- Euler's Totient function

**Combinatorics**:
- Permutations and combinations
- Binomial coefficients
- Stars and bars
- Inclusion-exclusion principle
- Derangements
- Catalan numbers

**Dynamic Programming**:
- Knapsack variants
- Longest increasing subsequence
- Edit distance
- Matrix chain multiplication
- Coin change
- Word break
- Tree DP

**Graphs**:
- BFS/DFS applications
- Shortest path algorithms
- Minimum spanning tree
- Topological sorting
- Cycle detection
- Network flow

**Strings**:
- Pattern matching (KMP, Rabin-Karp)
- Palindrome problems
- String compression
- Edit distance
- Substring search

**Data Structures**:
- Heap/priority queue applications
- Hash table uses
- Segment tree/Fenwick tree
- Trie applications
- Disjoint set union

### Progressive Practice
1. **Warm-up**: Simple implementation problems
2. **Basic**: Simple greedy, basic DP, basic graph traversal
3. **Intermediate**: Advanced DP, complex graph problems, string algorithms
4. **Advanced**: Complex data structures, advanced algorithms, mathematical insights
5. **Expert**: Combine multiple techniques, optimize constant factors, handle edge cases

### Resources
- **Books**: 
  - "Competitive Programming 4" by Steven Halim & Felix Halim
  - "Introduction to Algorithms" by Cormen, Leiserson, Rivest, Stein
  - "Programming Challenges" by Skiena & Revilla
- **Websites**:
  - Codeforces (codeforces.com)
  - LeetCode (leetcode.com)
  - AtCoder (atcoder.jp)
  - HackerRank (hackerrank.com)
  - CodeChef (codechef.com)
- **Practice Strategies**:
  - Solve problems by topic
  - Participate in regular contests
  - Review editorials after contests
  - Practice upsolving (solving after contest)
  - Learn from others' solutions

Remember: The key to success in competitive programming is not just knowing algorithms, but developing the intuition to recognize which technique to apply to a given problem. Practice consistently, analyze your mistakes, and always look for patterns and generalizations.

Mathematics is the foundation of computer science - master these concepts, and you'll be well-equipped to tackle any algorithmic challenge!

Happy coding! 🚀