# 21 - Computer Architecture

## Overview

Computer Architecture is the fundamental design and organization of computer systems. It defines how hardware components interact, how data flows, and how instructions are executed. Understanding architecture is essential for writing efficient code, optimizing performance, and excelling in technical interviews.

## What You'll Learn

| Topic | File | Description |
|-------|------|-------------|
| Architecture Guide | [architecture-guide.md](architecture-guide.md) | Core concepts, Von Neumann, Harvard, and modern architectures |
| CPU & Memory Hierarchy | [cpu-memory-hierarchy.md](cpu-memory-hierarchy.md) | Registers, caches, RAM, virtual memory, and storage |
| Pipelining | [pipelining.md](pipelining.md) | Instruction pipelines, hazards, and superscalar execution |
| Interview Questions | [architecture-interview-questions.md](architecture-interview-questions.md) | Common questions and answers for technical interviews |

## Why Computer Architecture Matters

- **Performance Optimization**: Write code that leverages cache locality and branch prediction
- **System Design**: Understand trade-offs in hardware and software design
- **Interview Readiness**: Architecture questions appear in almost every systems-level interview
- **Debugging**: Diagnose performance bottlenecks at the hardware level

## Key Concepts at a Glance

```
┌─────────────────────────────────────────────┐
│              APPLICATION                     │
├─────────────────────────────────────────────┤
│              OPERATING SYSTEM                │
├──────────┬──────────┬──────────┬────────────┤
│   CPU    │  Memory  │   I/O    │  Storage   │
│ (ALU,    │ (Cache,  │ (Bus,    │ (HDD,      │
│  Control │  RAM)    │  DMA)    │  SSD)      │
│  Unit)   │          │          │            │
└──────────┴──────────┴──────────┴────────────┘
```

## Prerequisites

- Basic understanding of binary and digital logic
- Familiarity with programming concepts
- Understanding of how programs are compiled

## Study Path

1. Start with **Architecture Guide** for foundational concepts
2. Study **CPU & Memory Hierarchy** to understand the memory model
3. Learn **Pipelining** for advanced performance concepts
4. Practice with **Interview Questions** to test your knowledge

## Resources

- *Computer Organization and Design* by Patterson & Hennessy
- *Computer Architecture: A Quantitative Approach* by Hennessy & Patterson
- MIT 6.004 Computation Structures
- CMU 15-213 Introduction to Computer Systems

---

> **Tip**: Understanding cache-friendly code can improve program performance by 10-100x. Always consider memory access patterns when optimizing.
