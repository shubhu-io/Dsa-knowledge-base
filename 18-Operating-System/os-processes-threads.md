# Processes & Threads

## 1. Process Concept

A **process** is a program in execution — an active entity with its own address space, resources, and execution context.

`
Program (passive on disk)  →  Process (active in memory)
   /bin/ls                    PID 1234, stack, heap, data, code
`

### Process in Memory

`
┌──────────────────────┐  High address
│        Stack          │  (local variables, function calls)
├──────────────────────┤
│          ↓            │  (grows downward)
│                      │
│          ↑            │  (grows upward)
├──────────────────────┤
│         Heap          │  (dynamically allocated memory)
├──────────────────────┤
│     Data (BSS + DS)   │  (global/static variables)
├──────────────────────┤
│        Text (Code)    │  (program instructions, read-only)
└──────────────────────┘  Low address
`

### Process vs Program

| Aspect | Program | Process |
|--------|---------|---------|
| Nature | Passive (file on disk) | Active (in execution) |
| Lifetime | Permanent | Temporary (starts, runs, ends) |
| Resources | None (just disk space) | Memory, CPU, files, I/O |
| Identifier | Filename | PID (Process ID) |

## 2. Process States

`
         ┌───────────────┐
         │     New        │
         └───────┬───────┘
                 │ Admitted
                 ▼
         ┌───────────────┐
    ┌───│     Ready       │◄────────────────────────────┐
    │   └───────┬───────┘                              │
    │           │ Scheduler dispatch (context switch)   │
    │           ▼                                       │
    │   ┌───────────────┐      I/O or event wait       │
    │   │   Running      │──────────────────────────────┤
    │   └───────┬───────┘                              │
    │           │                                      │
    │           │ Interrupt / time slice expired       │
    │           └──────────────────────────────────────┘
    │
    │   ┌───────────────┐
    └───│   Terminated   │
        └───────────────┘
`

| State | Description |
|-------|-------------|
| New | Process being created |
| Ready | Loaded in memory, waiting for CPU |
| Running | CPU executing instructions |
| Waiting/Blocked | Waiting for I/O or event |
| Terminated | Finished execution |

## 3. Process Control Block (PCB)

The PCB (aka task struct) is a data structure in the kernel that stores all information about a process.

`
PCB
├── PID (Process ID)
├── Process State (Ready, Running, Waiting)
├── Program Counter (next instruction address)
├── CPU Registers (save area for context switch)
├── CPU Scheduling Info (priority, time slice)
├── Memory Management Info (page table, segment table)
├── Accounting Info (CPU time, start time)
├── I/O Status (open files, devices allocated)
└── Process List Pointers (parent, children, siblings)
`

### Context Switch

Switching CPU from one process to another involves saving the current process's PCB and loading the next process's PCB.

`
Process A (running) → save PCB_A → scheduler decision → load PCB_B → Process B (running)
     ↑                                                                    │
     │                                                                    │
     └──────────────────────────── later (reverse) ───────────────────────┘
`

Context switch overhead: typically 1-100 microseconds (depends on hardware and PCB size).

## 4. Process Scheduling

### Scheduling Queues

| Queue | Purpose |
|-------|---------|
| Job Queue | All processes in the system |
| Ready Queue | Processes in memory, ready to run |
| Device Queue | Processes waiting for I/O device |

### Schedulers

| Scheduler | Frequency | Type | Function |
|-----------|-----------|------|----------|
| Long-term | Low | Admission | Controls degree of multiprogramming |
| Short-term | High (ms) | CPU | Selects next process to run |
| Medium-term | Medium | Swapping | Removes/reintroduces processes for memory |

### Scheduling Algorithms

| Algorithm | Criteria | Characteristics |
|-----------|----------|-----------------|
| FCFS (First-Come, First-Served) | Arrival order | Non-preemptive, convoy effect |
| SJF (Shortest Job First) | Burst time | Optimal avg. waiting time, starvation possible |
| SRTF (Shortest Remaining Time) | Remaining time | Preemptive SJF, high overhead |
| RR (Round Robin) | Time quantum | Preemptive, fair, response time good |
| Priority | Priority number | Starvation (aging solves it) |
| MLQ (Multi-Level Queue) | Queue assignment | Fixed priority between queues |
| MLFQ (Multi-Level Feedback) | + behavior | Processes can move between queues |

### Comparison Table

| Algorithm | Preemptive | Avg Waiting | Starvation | Overhead |
|-----------|-----------|-------------|------------|----------|
| FCFS | No | High | No | Minimal |
| SJF | No | Low | Yes | Moderate |
| SRTF | Yes | Very low | Yes | High |
| RR | Yes | Moderate | No | Low |
| Priority | Both | Varies | Yes | Low |
| MLFQ | Yes | Low | Can be | High |

## 5. Threads

A **thread** is the smallest unit of CPU execution. A process can have multiple threads that share the same address space.

### Thread vs Process

| Aspect | Process | Thread |
|--------|---------|--------|
| Address space | Separate (isolated) | Shared (with process threads) |
| Resources | Heavy (PCB, memory map, file table) | Lightweight (stack, registers, PC) |
| Creation time | Slow (fork/exec) | Fast (pthread_create) |
| Context switch | Slow | Fast |
| Communication | IPC (pipes, sockets, shared memory) | Direct memory access |
| Crash impact | Only that process | Can crash entire process |

### Multithreading Models

`
Many-to-One:   Many user threads → 1 kernel thread
               (e.g., Green threads — obsolete)
               
One-to-One:    1 user thread → 1 kernel thread
               (e.g., Linux pthreads, Windows)
               
Many-to-Many:  Many user threads → Many kernel threads
               (e.g., Solaris — hybrid efficiency)
               
Two-Level:     Many-to-Many + allow binding one user thread
               to one kernel thread
               (e.g., IRIX, older Solaris)
`

### Thread Libraries

| Library | Platforms | API |
|---------|-----------|-----|
| POSIX Threads (pthreads) | Unix/Linux/macOS | pthread_create, pthread_join, etc. |
| Win32 Threads | Windows | CreateThread, WaitForSingleObject |
| Java Threads | Cross-platform (JVM) | Thread, Runnable, ExecutorService |

### Thread Pools

Pre-create a pool of threads and reuse them for tasks. Benefits: avoids thread creation overhead, limits resource usage.

## 6. Inter-Process Communication (IPC)

### Shared Memory

Faster, no kernel involvement after setup.

`
Process A           Memory           Process B
   │               ┌─────┐            │
   │── write() ───►│shared├─────────► │── read() ──►
   │◄──────────────┤ buf ├─────────── │◄── write() ──
   │◄── read() ────└─────┘◄────────── │
`

### Message Passing

Kernel-managed, used for distributed systems.

| Method | Description | System Calls |
|--------|-------------|-------------|
| Pipe | Unidirectional, parent-child | pipe(), ead(), write() |
| Named Pipe (FIFO) | Unidirectional, any process | mkfifo(), open(), ead(), write() |
| Message Queue | Structured messages | msgget(), msgsnd(), msgrcv() |
| Socket | Bidirectional, local or network | socket(), ind(), send(), ecv() |
| Signal | Asynchronous notification | kill(), signal(), sigaction() |

### Synchronization Primitives

| Primitive | Description | Use Case |
|-----------|-------------|----------|
| Mutex | Binary lock (mutual exclusion) | Protect critical section |
| Semaphore | Integer counter (P/V operations) | Resource counting, signaling |
| Condition Variable | Wait/signal on condition | Producer-consumer |
| Spinlock | Busy-wait loop | Short critical sections, kernel |
| Read-Write Lock | Multiple readers, exclusive writer | Read-heavy workloads |

### Classic Synchronization Problems

1. **Bounded Buffer (Producer-Consumer)**: Producer adds items, consumer removes them from a fixed-size buffer.
2. **Readers-Writers**: Multiple readers can read simultaneously, writers need exclusive access.
3. **Dining Philosophers**: 5 philosophers, 5 forks — avoid deadlock.
4. **Sleeping Barber**: Barber sleeps if no customers, cuts hair otherwise — manage waiting customers.
