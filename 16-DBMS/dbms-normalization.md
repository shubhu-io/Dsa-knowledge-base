# DBMS Normalization

## 1. What is Normalization?

Normalization is the process of organizing data in a database to reduce redundancy and improve data integrity. It involves dividing larger tables into smaller, related tables and defining relationships between them.

### Why Normalize?

- Eliminate redundant (duplicate) data
- Ensure data dependencies make sense
- Avoid update anomalies (insertion, update, deletion)
- Simplify query maintenance

### The Three Update Anomalies

Consider this **unnormalized** table:

| StudentID | StudentName | CourseID | CourseName | Instructor | Grade |
|-----------|-------------|----------|------------|------------|-------|
| 101 | Alice | CS201 | Databases | Dr. Smith | A |
| 101 | Alice | CS301 | Algorithms | Dr. Jones | B |
| 102 | Bob | CS201 | Databases | Dr. Smith | A |
| 103 | Carol | CS301 | Algorithms | Dr. Jones | C |

Anomalies:
- **Insertion**: Cannot add a course until a student enrolls in it.
- **Update**: Changing "Dr. Smith" to "Dr. Brown" requires updating multiple rows.
- **Deletion**: Deleting Bob's enrollment would lose the fact that "Databases" is taught by Dr. Smith.

## 2. Functional Dependencies

A functional dependency $X \to Y$ means: if two rows have the same value for X, they must also have the same value for Y.

### Notation

- $X \to Y$ — X determines Y (X is a determinant)
- $X \to Y, Z$ — X determines both Y and Z
- $X \to Y, Y \to Z$ — transitive dependency: $X \to Z$

### Armstrong's Axioms

| Rule | Description | Example |
|------|-------------|---------|
| Reflexivity | If $Y \subseteq X$, then $X \to Y$ | $\text{emp\_id, name} \to \text{emp\_id}$ |
| Augmentation | If $X \to Y$, then $XZ \to YZ$ | If $\text{id} \to \text{name}$, then $\text{id, dept} \to \text{name, dept}$ |
| Transitivity | If $X \to Y$ and $Y \to Z$, then $X \to Z$ | If $\text{emp\_id} \to \text{dept\_id}$ and $\text{dept\_id} \to \text{dept\_name}$, then $\text{emp\_id} \to \text{dept\_name}$ |

### Finding Candidate Keys

Given relation R(A, B, C, D) with FDs: $A \to B$, $B \to C$, $C \to D$

- $A \to B$, $A \to C$ (transitivity), $A \to D$ (transitivity) → A determines all → A is the candidate key.

## 3. Normal Forms

### First Normal Form (1NF)

A relation is in 1NF if every attribute contains atomic (indivisible) values.

```
❌ NOT 1NF (non-atomic values):
StudentID | PhoneNumbers
101      | 555-0100, 555-0101

✅ 1NF:
StudentID | PhoneNumber
101      | 555-0100
101      | 555-0101
```

**Rules:**
- Each cell has a single value
- Each column contains values of the same type
- Each row is unique (has a primary key)
- No repeating groups

### Second Normal Form (2NF)

A relation is in 2NF if it is in 1NF AND every non-key attribute is **fully functionally dependent** on the **entire** primary key (no partial dependency).

```
❌ NOT 2NF (partial dependency):
OrderID | ProductID | ProductName | Quantity | Price
PK: (OrderID, ProductID)
"ProductName" depends only on ProductID, not on (OrderID, ProductID)

✅ 2NF:
Orders            OrderDetails               Products
┌─────────┐      ┌─────────┬──────────┐    ┌──────────┬─────────────┐
│ OrderID  │      │ OrderID │ ProductID│    │ProductID │ ProductName │
│ Date     │      ├─────────┼──────────┤    ├──────────┼─────────────┤
│ Customer │      │         │ Quantity │    │          │ Price       │
└─────────┘      │         │ Price    │    └──────────┴─────────────┘
                 └─────────┴──────────┘
```

### Third Normal Form (3NF)

A relation is in 3NF if it is in 2NF AND no **transitive dependency** exists (non-key attribute does not depend on another non-key attribute).

```
❌ NOT 3NF (transitive dependency):
Employee(emp_id, emp_name, dept_id, dept_name)
emp_id → dept_id, dept_id → dept_name (transitive: emp_id → dept_name)

✅ 3NF:
Employees(emp_id, emp_name, dept_id)
Departments(dept_id, dept_name)
```

### Boyce-Codd Normal Form (BCNF)

A relation is in BCNF if for every functional dependency $X \to Y$, X is a **super key**. BCNF is a stricter version of 3NF.

```
❌ NOT BCNF:
StudentCourse(StudentID, Subject, Professor)
FD: Subject → Professor (but Subject is not a super key)

Here a student can have multiple subjects and a subject has one professor,
but the key is (StudentID, Subject). Professor depends on Subject, not on the full key.

✅ BCNF:
Enrollment(StudentID, SubjectID)
SubjectProfessor(SubjectID, Professor)
```

### 3NF vs BCNF

For every FD $X \to Y$:
- **3NF**: Either X is a super key OR Y is part of a candidate key.
- **BCNF**: X must be a super key.

BCNF eliminates all redundancy based on FDs, but may lose some FDs (not dependency-preserving). 3NF is always dependency-preserving.

### Fourth Normal Form (4NF)

A relation is in 4NF if it is in BCNF AND has no **multi-valued dependencies** (MVDs). MVDs occur when an attribute's value is independent of another attribute's value.

```
❌ NOT 4NF:
EmployeeSkills(emp_id, skill, language)
MVDs: emp_id →→ skill, emp_id →→ language (two independent multi-valued facts)

✅ 4NF:
EmployeeSkill(emp_id, skill)
EmployeeLanguage(emp_id, language)
```

### Fifth Normal Form (5NF / PJNF)

A relation is in 5NF if it cannot be losslessly decomposed into smaller tables. Also called Project-Join Normal Form (PJNF). Rarely violated in practice.

## 4. Normalization Process Summary

```
Unnormalized Form (UNF)
    │  Remove repeating groups
    ▼
First Normal Form (1NF)
    │  Remove partial dependencies
    ▼
Second Normal Form (2NF)
    │  Remove transitive dependencies
    ▼
Third Normal Form (3NF)
    │  Remove FDs where determinant is not a super key
    ▼
Boyce-Codd Normal Form (BCNF)
    │  Remove multi-valued dependencies
    ▼
Fourth Normal Form (4NF)
    │  Remove join dependencies
    ▼
Fifth Normal Form (5NF)
```

## 5. Denormalization

Denormalization is the intentional introduction of redundancy to improve read performance.

### When to Denormalize

- Heavy read workloads (reporting, dashboards)
- Expensive joins across large tables
- Caching computed values (totals, counts)
- Time-series or logging data

### Trade-offs

| Aspect | Normalized | Denormalized |
|--------|-----------|-------------|
| Storage | Minimal | More (redundancy) |
| Write speed | Faster | Slower (more tables to update) |
| Read speed | Slower (joins) | Faster (fewer joins) |
| Consistency | High | Lower (risk of anomalies) |
| Maintenance | Complex schema | Simpler queries |

## 6. Step-by-Step Normalization Example

### Step 0: Unnormalized Form (UNF)

```
Order(OrderID, OrderDate, CustomerName, CustomerPhone,
      Products: [ProductID, ProductName, Quantity, Price, Total])
```

### Step 1: 1NF — Remove repeating groups

```
Order(OrderID, OrderDate, CustomerName, CustomerPhone, ProductID, ProductName, Quantity, Price, Total)
PK: (OrderID, ProductID)
```

### Step 2: 2NF — Remove partial dependencies

```
OrderHeader(OrderID, OrderDate, CustomerName, CustomerPhone)
OrderLine(OrderID, ProductID, Quantity, Price, Total)
Product(ProductID, ProductName)
```

### Step 3: 3NF — Remove transitive dependencies

```
OrderHeader(OrderID, OrderDate, CustomerID)
OrderLine(OrderID, ProductID, Quantity, Price)
Product(ProductID, ProductName, ListPrice)
Customer(CustomerID, CustomerName, CustomerPhone)
```

Final schema is normalized and free from insertion, update, and deletion anomalies.
