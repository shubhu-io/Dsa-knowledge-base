# CPU Scheduling Algorithms

## Overview

CPU scheduling determines which process gets the CPU next. The OS scheduler runs
constantly, deciding between ready processes to maximize throughput, minimize response
time, and ensure fairness.

---

## Scheduling Metrics

| Metric | Description |
|--------|-------------|
| **CPU Utilization** | Percentage of time CPU is busy (target: 40-90%) |
| **Throughput** | Number of processes completed per unit time |
| **Turnaround Time** | Time from submission to completion (T_completed - T_arrival) |
| **Waiting Time** | Time spent in ready queue (Turnaround - Burst Time) |
| **Response Time** | Time from submission to first response |

---

## Process States and Scheduling Points

```
New -> Ready -> Running -> Terminated
           ^         |
           |    (I/O or event wait)
           |         v
           +-- Waiting (blocked) --+
```

| Scheduling Type | Trigger |
|-----------------|---------|
| **Non-preemptive** | Process voluntarily releases CPU (terminates or blocks) |
| **Preemptive** | OS forcibly takes CPU away (timer interrupt, priority) |

---

## Algorithms

### 1. First-Come, First-Served (FCFS)

Processes execute in arrival order. Non-preemptive.

| Process | Burst | Start | Finish | Turnaround | Waiting |
|---------|-------|-------|--------|------------|---------|
| P1      | 24    | 0     | 24     | 24         | 0       |
| P2      | 3     | 24    | 27     | 24         | 21      |
| P3      | 3     | 27    | 30     | 27         | 24      |

- **Avg Turnaround**: (24 + 24 + 27) / 3 = **25.0 ms**
- **Avg Waiting**: (0 + 21 + 24) / 3 = **15.0 ms**
- **Con**: Convoy effect — short processes wait behind long ones

### 2. Shortest Job First (SJF)

Selects the process with the smallest burst time. Non-preemptive.

| Process | Burst | Start | Finish | Turnaround | Waiting |
|---------|-------|-------|--------|------------|---------|
| P1      | 6     | 0     | 6      | 6          | 0       |
| P2      | 8     | 6     | 14     | 12         | 6       |
| P3      | 7     | 14    | 21     | 18         | 14      |
| P4      | 3     | 21    | 24     | 21         | 18      |

- **Optimal** for minimizing average waiting time
- **Con**: Requires knowing burst times in advance; can cause starvation of long processes

### 3. Shortest Remaining Time First (SRTF)

Preemptive version of SJF. Process with shortest remaining time runs next.

| Process | Arrival | Burst | Timeline |
|---------|---------|-------|----------|
| P1      | 0       | 8     | 0-2 (preempted) |
| P2      | 1       | 4     | 2-6 |
| P3      | 2       | 9     | 6-15 |
| P1      | —       | 6 rem | 15-21 |

### 4. Round Robin (RR)

Each process gets a fixed time quantum. Preemptive.

| Parameter | Impact |
|-----------|--------|
| Small quantum | More context switches, higher overhead |
| Large quantum | Behaves like FCFS |
| Typical value | 10-100 ms |

Example (quantum = 4):

| Process | Burst | Timeline |
|---------|-------|----------|
| P1      | 10    | 0-4, 12-16, 20-22 |
| P2      | 4     | 4-8 |
| P3      | 6     | 8-12, 16-18 |

### 5. Priority Scheduling

Each process has a priority; highest priority runs first.

| Type | Description |
|------|-------------|
| **Preemptive** | Higher priority arrival preempts current process |
| **Non-preemptive** | Current process finishes before switching |
| **Starvation** | Low-priority processes may never run |
| **Solution** | Aging — gradually increase priority of waiting processes |

### 6. Multilevel Feedback Queue (MLFQ)

Multiple queues with different priorities and time quanta. Processes move between queues
based on behavior.

```
Queue 0 (highest priority, quantum = 8ms)  <-- New processes enter here
Queue 1 (medium priority,  quantum = 16ms)
Queue 2 (lowest priority,  quantum = 32ms) <-- CPU-bound processes end up here
```

**Rules**:
1. New processes enter the highest queue
2. If a process uses its entire quantum, demote it one level
3. If a process blocks for I/O before using its quantum, keep it at the same level
4. Periodically boost all processes to the highest queue (prevents starvation)

**Used by**: Most real-world OSes (Linux, Windows, macOS)

---

## Comparison

| Algorithm | Preemptive | Starvation | Optimal Wait | Use Case |
|-----------|-----------|------------|-------------|----------|
| FCFS | No | No | No | Simple batch systems |
| SJF | No | Yes | Yes (given burst) | Batch processing |
| SRTF | Yes | Yes | Yes | Interactive systems |
| Round Robin | Yes | No | No | Time-sharing systems |
| Priority | Both | Yes | No | Real-time systems |
| MLFQ | Yes | No | Near | General-purpose OSes |

---

## Real-World Scheduling

### Linux: Completely Fair Scheduler (CFS)

Uses a red-black tree keyed on virtual runtime. The process with the smallest virtual
runtime runs next. Guarantees fair CPU allocation proportional to nice values.

### Windows: Multilevel Feedback Queue

Priority levels 0-31. Dynamic priority adjustment based on I/O behavior and user
interactions. Thread priorities are adjusted by the kernel in real time.

---

## Key Formulas

```
Turnaround Time = Completion Time - Arrival Time

Waiting Time = Turnaround Time - Burst Time

Average Waiting Time = Sum(Waiting Times) / Number of Processes

Throughput = Number of Completed Processes / Total Time

CPU Utilization = (Total Busy Time) / (Total Time) × 100%
```

---

## Interview Questions

1. What is the convoy effect and which algorithm causes it?
2. Why can't SJF be used in interactive systems?
3. How does MLFQ prevent starvation?
4. What is the ideal time quantum for Round Robin?
5. Compare preemptive vs non-preemptive scheduling.
6. Explain Linux CFS and how it achieves fairness.
7. What is aging and why is it needed?
8. How does the OS decide which process to schedule next?

---

## See Also

- [[Operating-System]] — OS overview and core concepts
- [[os-processes-threads]] — Processes and threads
- [[os-memory-management]] — Memory management
- [[os-interview-questions]] — Common OS interview questions
