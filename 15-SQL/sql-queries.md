# SQL Queries — Practical Examples

## Schema Used in Examples

```sql
-- Departments table
CREATE TABLE departments (
    dept_id     SERIAL PRIMARY KEY,
    dept_name   VARCHAR(100) NOT NULL,
    location    VARCHAR(100)
);

-- Employees table
CREATE TABLE employees (
    emp_id      SERIAL PRIMARY KEY,
    first_name  VARCHAR(50) NOT NULL,
    last_name   VARCHAR(50) NOT NULL,
    email       VARCHAR(100) UNIQUE NOT NULL,
    hire_date   DATE DEFAULT CURRENT_DATE,
    salary      DECIMAL(10,2) CHECK (salary > 0),
    dept_id     INTEGER REFERENCES departments(dept_id),
    manager_id  INTEGER REFERENCES employees(emp_id)
);

-- Projects table
CREATE TABLE projects (
    project_id   SERIAL PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    budget       DECIMAL(12,2),
    dept_id      INTEGER REFERENCES departments(dept_id)
);

-- Employee-Project assignment (many-to-many)
CREATE TABLE assignments (
    emp_id      INTEGER REFERENCES employees(emp_id),
    project_id  INTEGER REFERENCES projects(project_id),
    hours_worked DECIMAL(8,2),
    PRIMARY KEY (emp_id, project_id)
);

-- Sample data
INSERT INTO departments VALUES
(1, 'Engineering', 'New York'),
(2, 'Marketing', 'San Francisco'),
(3, 'Sales', 'Chicago'),
(4, 'HR', 'New York');

INSERT INTO employees VALUES
(1, 'Alice', 'Johnson', 'alice@example.com', '2020-01-15', 95000, 1, NULL),
(2, 'Bob', 'Smith', 'bob@example.com', '2019-06-01', 72000, 2, 1),
(3, 'Carol', 'Davis', 'carol@example.com', '2021-03-10', 86000, 1, 1),
(4, 'David', 'Wilson', 'david@example.com', '2020-11-20', 65000, 3, 2),
(5, 'Eve', 'Brown', 'eve@example.com', '2022-07-05', 78000, 2, 2),
(6, 'Frank', 'Miller', 'frank@example.com', '2018-09-12', 92000, 1, 1),
(7, 'Grace', 'Lee', 'grace@example.com', '2023-01-01', 54000, 4, 3);
```

## 1. Basic Queries

```sql
-- All employees
SELECT * FROM employees;

-- Employees hired after 2020
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date > '2020-01-01'
ORDER BY hire_date;

-- Count employees per department
SELECT dept_id, COUNT(*) AS count
FROM employees
GROUP BY dept_id;
```

## 2. Joins in Action

```sql
-- Employees with department names
SELECT e.first_name, e.last_name, d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;

-- Employees working on 'Project Alpha'
SELECT e.first_name, e.last_name, a.hours_worked
FROM employees e
JOIN assignments a ON e.emp_id = a.emp_id
JOIN projects p ON a.project_id = p.project_id
WHERE p.project_name = 'Project Alpha';

-- Departments with no employees
SELECT d.dept_name
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
WHERE e.emp_id IS NULL;
```

## 3. Aggregation and Grouping

```sql
-- Average salary per department (with names)
SELECT d.dept_name, AVG(e.salary)::DECIMAL(10,2) AS avg_salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name
ORDER BY avg_salary DESC;

-- Departments with total salary > 150000
SELECT d.dept_name, SUM(e.salary) AS total_salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING SUM(e.salary) > 150000;

-- Employee count and salary stats by location
SELECT d.location,
       COUNT(*) AS emp_count,
       ROUND(AVG(e.salary), 2) AS avg_salary,
       MAX(e.salary) AS max_salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
GROUP BY d.location;
```

## 4. Subqueries

```sql
-- Employees earning above their department average
SELECT e.first_name, e.last_name, e.salary, e.dept_id
FROM employees e
WHERE e.salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE dept_id = e.dept_id
)
ORDER BY e.dept_id;

-- Second highest salary
SELECT MAX(salary) FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);

-- Departments with above-average employee count
SELECT dept_id, COUNT(*) AS emp_count
FROM employees
GROUP BY dept_id
HAVING COUNT(*) > (
    SELECT AVG(emp_count) FROM (
        SELECT COUNT(*) AS emp_count FROM employees GROUP BY dept_id
    ) AS dept_counts
);
```

## 5. Date and Time Queries

```sql
-- Employees hired in the last 90 days
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date >= CURRENT_DATE - INTERVAL '90 days';

-- Years of service
SELECT
    first_name,
    last_name,
    hire_date,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, hire_date)) AS years_of_service
FROM employees
ORDER BY years_of_service DESC;

-- Employees hired each year
SELECT
    EXTRACT(YEAR FROM hire_date) AS hire_year,
    COUNT(*) AS hired_count
FROM employees
GROUP BY hire_year
ORDER BY hire_year;
```

## 6. String Operations

```sql
-- Full name concatenation
SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM employees;

-- Email domain extraction
SELECT
    SUBSTRING(email FROM '@(.*)$') AS domain,
    COUNT(*) AS count
FROM employees
GROUP BY domain;

-- Name formatting
SELECT
    UPPER(last_name) || ', ' || INITCAP(first_name) AS formatted_name
FROM employees;

-- Search by partial name
SELECT * FROM employees
WHERE LOWER(first_name || ' ' || last_name) LIKE '%brown%';
```

## 7. Window Functions

```sql
-- Row number by salary ranking
SELECT
    first_name,
    last_name,
    salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) AS rank
FROM employees;

-- Dense rank within department
SELECT
    first_name,
    last_name,
    dept_id,
    salary,
    DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS dept_rank
FROM employees;

-- Running total of salaries (ordered by hire date)
SELECT
    hire_date,
    first_name,
    salary,
    SUM(salary) OVER (ORDER BY hire_date) AS running_total
FROM employees;

-- Moving average (3-row window)
SELECT
    hire_date,
    salary,
    AVG(salary) OVER (ORDER BY hire_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg
FROM employees;
```

## 8. Common Table Expressions (CTEs)

```sql
-- Department salary stats
WITH dept_stats AS (
    SELECT
        dept_id,
        AVG(salary) AS avg_salary,
        MAX(salary) AS max_salary
    FROM employees
    GROUP BY dept_id
)
SELECT d.dept_name, ds.avg_salary, ds.max_salary
FROM dept_stats ds
JOIN departments d ON ds.dept_id = d.dept_id;

-- Recursive CTE: organizational hierarchy
WITH RECURSIVE org_tree AS (
    -- Base: top-level managers
    SELECT emp_id, first_name, last_name, manager_id, 0 AS level
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive: direct reports
    SELECT e.emp_id, e.first_name, e.last_name, e.manager_id, ot.level + 1
    FROM employees e
    JOIN org_tree ot ON e.manager_id = ot.emp_id
)
SELECT * FROM org_tree ORDER BY level, emp_id;
```

## 9. Data Modification

```sql
-- Give 10% raise to Engineering
UPDATE employees
SET salary = salary * 1.10
WHERE dept_id = (SELECT dept_id FROM departments WHERE dept_name = 'Engineering');

-- Delete employees with no project assignments
DELETE FROM employees
WHERE emp_id NOT IN (SELECT DISTINCT emp_id FROM assignments);

-- Merge (upsert) - PostgreSQL syntax
INSERT INTO employees (emp_id, first_name, last_name, email, salary, dept_id)
VALUES (8, 'Henry', 'Taylor', 'henry@example.com', 70000, 2)
ON CONFLICT (emp_id)
DO UPDATE SET
    first_name = EXCLUDED.first_name,
    last_name = EXCLUDED.last_name,
    salary = EXCLUDED.salary;
```
