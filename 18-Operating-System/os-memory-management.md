# Memory Management in Operating Systems

## Overview

Memory management is the OS function responsible for allocating, deallocating, and tracking
memory resources. It ensures processes get the memory they need without interfering with
each other, and makes efficient use of limited physical memory.

---

## Memory Hierarchy

```
Registers     ──>  Fastest, smallest (bytes)
L1 Cache      ──>  ~1-2 ns, ~32-64 KB
L2 Cache      ──>  ~3-10 ns, ~256 KB-1 MB
L3 Cache      ──>  ~10-20 ns, ~2-8 MB
Main Memory   ──>  ~50-100 ns, ~8-64 GB
SSD/Disk      ──>  ~100 μs-10 ms, TB range
```

---

## Logical vs Physical Address Space

| Concept | Description |
|---------|-------------|
| **Logical Address** | CPU-generated address seen by a process |
| **Physical Address** | Actual address in main memory hardware |
| **MMU (Memory Management Unit)** | Hardware that translates logical to physical addresses |
| **Address Space** | Set of logical addresses a process can reference |

The MMU uses a **relocation register** to add an offset to every logical address,
converting it to a physical address before accessing memory.

---

## Memory Allocation Strategies

### Contiguous Allocation

Each process gets a single contiguous block of memory.

| Method | Description | Drawback |
|--------|-------------|----------|
| **First Fit** | Allocate first hole that fits | Fast, but fragments memory |
| **Best Fit** | Allocate smallest hole that fits | Leaves tiny unusable holes |
| **Worst Fit** | Allocate largest hole available | Leaves large leftover holes |
| **Next Fit** | First fit starting from last allocation | Spreads allocations evenly |

### Fragmentation

- **External Fragmentation**: Free memory exists but is not contiguous enough for a process
- **Internal Fragmentation**: Allocated memory block is larger than needed; leftover space is wasted

---

## Paging

Paging eliminates external fragmentation by dividing memory into fixed-size blocks.

| Term | Description |
|------|-------------|
| **Page** | Fixed-size block of logical memory (typically 4 KB) |
| **Frame** | Fixed-size block of physical memory (same size as a page) |
| **Page Table** | Maps logical page numbers to physical frame numbers |
| **Page Number (p)** | Upper bits of logical address — index into page table |
| **Page Offset (d)** | Lower bits of logical address — offset within the page |

### Address Translation

```
Logical Address = [Page Number | Page Offset]

Physical Address = [Frame Number (from page table) | Page Offset]

Example: 16-bit address space, 4 KB pages
  Page size = 2^12 = 4096 bytes
  Page number = upper 4 bits (16 - 12 = 4)
  Offset = lower 12 bits
```

### Multi-Level Page Tables

Reduce the memory needed for large page tables by splitting them into levels.

- **Two-level page table**: Outer table indexes inner tables; only inner tables for
  used virtual address ranges need to be in memory
- **x86-64** uses a 4-level page table hierarchy

### Inverted Page Table

One entry per physical frame (instead of per page). Reduces table size but requires
searching the entire table to find a process's page — often accelerated with a hash table.

---

## Segmentation

Segmentation divides memory into variable-size segments based on logical divisions
(code, data, stack, heap).

| Feature | Paging | Segmentation |
|---------|--------|--------------|
| Block size | Fixed | Variable |
| External fragmentation | None | Yes |
| Internal fragmentation | Yes | No |
| User visibility | Transparent | Visible to programmer |

A segment table maps (segment number, offset) to physical addresses, with each entry
storing the segment base and limit.

---

## Virtual Memory

Virtual memory allows processes to use more memory than physically available by
keeping only active pages in RAM and storing the rest on disk.

### Demand Paging

Pages are loaded into memory only when referenced (page fault triggers loading).

```
Process references page
  -> Page in memory?  -> Yes: continue
  -> No (Page Fault)  -> OS finds frame on disk
                       -> Load page into frame
                       -> Update page table
                       -> Restart instruction
```

### Page Replacement Algorithms

When memory is full and a new page must be loaded, the OS must choose a victim page
to evict.

| Algorithm | Description | Complexity | Optimal? |
|-----------|-------------|------------|----------|
| **FIFO** | Replace oldest page | O(1) | No — suffers Belady's anomaly |
| **Optimal** | Replace page not used for longest time | O(n) | Yes — but impossible to implement |
| **LRU** | Replace least recently used page | O(n) | Near-optimal |
| **LRU Approximation (Clock)** | Use reference bit + circular buffer | O(1) | Good practical approximation |
| **LFU** | Replace least frequently used page | O(n) | Good for skewed access patterns |
| **MFU** | Replace most frequently used page | O(n) | Rarely used |

### Belady's Anomaly

For some algorithms (like FIFO), increasing the number of frames can actually **increase**
page faults. LRU and Optimal are not susceptible to this anomaly.

### Thrashing

When a process spends more time paging than executing — caused by insufficient frames
for its working set. The OS detects this via high page fault rates and responds by
swapping out entire processes or allocating more frames.

---

## Copy-on-Write (COW)

Fork() initially shares parent's pages with the child. Pages are only copied when
either process attempts to write, reducing overhead for fork-heavy workloads.

---

## Memory-Mapped Files

Files can be mapped directly into a process's address space, allowing file I/O through
normal memory reads/writes. The OS handles paging the file contents in and out.

---

## Key Formulas

```
Page Table Size = (Logical Address Space) / (Page Size)

Number of Pages = (Process Size) / (Page Size)

Effective Access Time (EAT) = p × fault_time + (1-p) × memory_time
  where p = page fault rate, fault_time ~ 10 ms, memory_time ~ 100 ns

For p = 0.001 (1 in 1000):
  EAT = 0.001 × 10ms + 0.999 × 100ns ≈ 10 μs
```

---

## Interview Questions

1. What is the difference between paging and segmentation?
2. Explain how demand paging works and what happens on a page fault.
3. What is Belady's anomaly? Which algorithms are affected?
4. How does the OS detect and handle thrashing?
5. Compare LRU and FIFO page replacement algorithms.
6. What is copy-on-write and when is it useful?
7. Explain the purpose of a TLB (Translation Lookaside Buffer).
8. What is the difference between internal and external fragmentation?

---

## See Also

- [[Operating-System]] — OS overview and core concepts
- [[os-processes-threads]] — Processes and threads
- [[os-interview-questions]] — Common OS interview questions
- [[os-scheduling]] — CPU scheduling algorithms
