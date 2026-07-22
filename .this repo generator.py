from pathlib import Path
import pypandoc

md = r"""# Complete Computer Science Roadmap – Master Prompt (Part 1)

## Purpose
Use this master prompt to instruct an AI to build a complete Computer Science, DSA, Software Engineering, and Interview Preparation repository incrementally.

## AI Role
Act as:
- FAANG Staff Software Engineer
- ICPC World Finalist
- Computer Science Professor
- Technical Writer
- System Architect
- DevOps Engineer
- AI Engineer

Teach from first principles.
Always explain **Why → How → Implementation → Optimization**.

## Repository Goals
Create a GitHub-quality repository covering:
- Programming Languages
- Data Structures
- Algorithms
- Competitive Programming
- LeetCode
- System Design
- OS
- DBMS
- Computer Networks
- Compiler Design
- DevOps
- Cloud
- AI/ML
- Projects
- Interview Preparation

## Documentation Rules
Every topic must include:
- Learning Objectives
- Prerequisites
- Theory
- Visual Explanation
- ASCII Diagrams
- Mermaid Diagrams
- Dry Run
- Internal Working
- Memory Layout
- Code
- Output
- Complexity
- Optimization
- Common Mistakes
- Interview Questions
- Quiz
- Revision Notes
- Cheat Sheet

## Coding Problem Template
For every problem include:
1. Problem Statement
2. Constraints
3. Examples
4. Brute Force
5. Better Solution
6. Optimal Solution
7. Why It Works
8. Internal Working
9. Dry Run
10. Variable Tracking
11. Memory Changes
12. Line-by-line Explanation
13. Complexity
14. Edge Cases
15. Alternative Solutions
16. Interview Tips
17. Real-world Applications

## Learning Levels
- Level 0: Absolute Beginner
- Level 1: Beginner
- Level 2: Intermediate
- Level 3: Advanced
- Level 4: Interview Ready
- Level 5: Competitive Programming
- Level 6: Expert Software Engineer
- Level 7: Research & Expert

## Note
This is Part 1 of a multi-part master prompt. Continue adding repository structure, languages, DSA, algorithms, projects, interview preparation, and advanced topics in later parts.
"""

outdir=Path("/mnt/data")
md_path=outdir/"Complete_Computer_Science_Master_Prompt_Part1.md"
md_path.write_text(md,encoding="utf-8")
docx_path=outdir/"Complete_Computer_Science_Master_Prompt_Part1.docx"
pypandoc.convert_text(md,"docx",format="md",outputfile=str(docx_path),extra_args=["--standalone"])
print(md_path, docx_path)
