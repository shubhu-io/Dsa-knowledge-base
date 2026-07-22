# Operating System

## Overview

An Operating System (OS) is system software that manages computer hardware and
software resources and provides common services for programs. Understanding OS
concepts is essential for systems programming, interviews, and performance
optimization.

---

## Key Concepts

### Process vs Thread

| Feature      | Process                          | Thread                        |
|-------------|----------------------------------|-------------------------------|
| Definition   | Program in execution             | Lightweight process           |
| Memory       | Separate address space           | Shared address space          |
| Creation     | Expensive                        | Cheap                         |
| Communication| IPC (pipes, sockets, shared mem) | Shared memory directly        |
| Failure      | One crash doesn't affect others  | Can crash entire process      |
| Context Switch| Expensive                       | Cheap                         |
| Examples     | Chrome (each tab is a process)   | Chrome (threads within a tab) |

---

## Process States

A process transitions through several states during its lifetime.

```
        +--------+
        | New    |
        +--------+
             |
             v
        +-----------+       +------------+
        | Ready     |<----->| Waiting/   |
        +-----------+       | Blocked    |
             |              +------------+
             v                   |
        +-----------+           |
   ---> | Running   | <---------+
        +-----------+
             |
        +----+----+
        |         |
        v         v
  +-----------+ +----------+
  | Terminated| | Timed Out|
  +-----------+ +----------+
```

### State Descriptions

- **New**: Process is being created
- **Ready**: Waiting to be assigned to CPU
- **Running**: Instructions being executed
- **Waiting**: Waiting for I/O or event
- **Terminated**: Process has finished execution

---

## CPU Scheduling Algorithms

| Algorithm         | Type   | Preemptive | Description                              |
|------------------|--------|------------|------------------------------------------|
| FCFS             | Simple | No         | First Come First Served                  |
| SJF              | Simple | No         | Shortest Job First                       |
| SRTF             | Simple | Yes        | Shortest Remaining Time First            |
| Round Robin      | Simple | Yes        | Fixed time quantum per process           |
| Priority         | Simple | Either     | Highest priority first                   |
| Multilevel Queue | Complex| Either     | Multiple queues with different priorities|
| Multilevel Feedback| Complex| Yes      | Processes move between queues            |

### Round Robin Example

```
Processes: P1(10ms), P2(4ms), P3(6ms)
Quantum: 4ms

Time: 0  4  8  12 16 18 22
      P1 P2 P3 P1 P3 P1 P1
```

---

## Memory Management

### Paging

- Divides memory into fixed-size blocks (pages)
- Process divided into pages of same size
- Page table maps logical to physical addresses
- No external fragmentation

```
Logical Address:  [ Page # | Offset ]
                       |        |
                       v        v
                 Page Table    Physical
                    |          Memory
                    v
              [ Frame # | Offset ]
```

### Segmentation

- Divides memory into variable-size segments
- Based on logical divisions (code, data, stack)
- Can cause external fragmentation
- Each segment has base address and limit

| Feature     | Paging                  | Segmentation              |
|-------------|-------------------------|---------------------------|
| Block Size  | Fixed                   | Variable                  |
| Fragmentation| Internal              | External                  |
| User View   | Transparent             | Logical division          |
| Address     | Linear                  | Segmented (seg:offset)    |

---

## Deadlock

### Four Necessary Conditions

All four must hold simultaneously for deadlock to occur:

1. **Mutual Exclusion**: At least one resource is non-sharable
2. **Hold and Wait**: Process holds resource while waiting for another
3. **No Preemption**: Resources cannot be forcibly taken
4. **Circular Wait**: Circular chain of processes waiting for resources

### Prevention Strategies

- **Break Mutual Exclusion**: Use sharable resources when possible
- **Break Hold and Wait**: Request all resources at once
- **Break No Preemption**: Allow resource preemption
- **Break Circular Wait**: Impose ordering on resource requests

### Detection and Recovery

```
# Banker's Algorithm (Deadlock Avoidance)
Available: [3, 3, 2]

Process | Allocation | Max    | Need
--------|-----------|--------|------
P0      | 0 1 0     | 7 5 3  | 7 4 3
P1      | 2 0 0     | 3 2 2  | 1 2 2
P2      | 3 0 2     | 9 0 2  | 6 0 0
P3      | 2 1 1     | 2 2 2  | 0 1 1
P4      | 0 0 2     | 4 3 3  | 4 3 1
```

### Resource Allocation Graph

```
    +---+  requests  +---+
    | P1| ---------> | R1|
    +---+            +---+
      |                ^
      | allocates       | allocates
      v                |
    +---+  requests  +---+
    | P2| ---------> | R2|
    +---+            +---+
      ^                |
      |                v
      +----------------+
        circular wait = DEADLOCK
```

---

## Virtual Memory

- Allows execution of processes not fully in physical memory
- Uses demand paging: load pages only when needed
- Page replacement algorithms:
  - **FIFO**: Replace oldest page
  - **LRU**: Replace least recently used
  - **Optimal**: Replace page not used for longest time (theoretical)

---

## Common Interview Questions

1. What is the difference between a process and a thread?
2. Explain the four conditions necessary for deadlock
3. What is virtual memory and how does paging work?
4. Compare FCFS, SJF, and Round Robin scheduling algorithms
5. What is thrashing and how can it be prevented?

---

## See Also

- [[Networking]]
- [[System-Design]]
- [[Databases]]
- [[Low-Level-Design]]
- [[Competitive-Programming]]

---

> Full content: [18-Operating-System](../18-Operating-System/)
