# CPU and Memory Hierarchy

## 1. CPU Architecture

### Core Components

```
┌─────────────────────────────────────────────────┐
│                      CPU                         │
│                                                  │
│  ┌──────────────┐       ┌──────────────────┐    │
│  │   Control     │       │    Registers     │    │
│  │   Unit (CU)   │       │  (R0-R31, PC,    │    │
│  │              │       │   SP, LR, etc.)  │    │
│  └──────┬───────┘       └────────┬─────────┘    │
│         │                        │               │
│  ┌──────┴────────────────────────┴─────────┐    │
│  │              Internal Data Bus           │    │
│  └──────┬────────────────────────┬─────────┘    │
│         │                        │               │
│  ┌──────┴───────┐       ┌───────┴─────────┐    │
│  │   ALU        │       │   FPU           │    │
│  │ (Arithmetic  │       │ (Floating Point │    │
│  │  Logic Unit) │       │  Unit)          │    │
│  └──────────────┘       └─────────────────┘    │
│                                                  │
│  ┌──────────────────────────────────────────┐   │
│  │           Control Registers               │   │
│  │  (Status, Interrupt, Mode registers)     │   │
│  └──────────────────────────────────────────┘   │
└─────────────────────────────────────────────────┘
```

### Registers

Registers are the fastest storage in a computer, located directly on the CPU.

| Register Type | Purpose | Example (ARM64) |
|---------------|---------|-----------------|
| **General Purpose** | Data operations | X0 - X30 (64-bit) |
| **Program Counter** | Points to next instruction | PC |
| **Stack Pointer** | Top of stack | SP |
| **Link Register** | Return address | LR |
| **Status Register** | Condition flags | CPSR |
| **Accumulator** | ALU operations | R0 (in some ISAs) |

### Register Characteristics

- **Access time**: < 1 nanosecond (sub-cycle)
- **Size**: 32 - 64 bits per register
- **Count**: 16 - 32 general-purpose registers typical
- **Volatile**: Lost when power is off

---

## 2. Cache Memory

### What is Cache?

Cache is small, fast SRAM memory that stores copies of frequently accessed main memory data. It bridges the speed gap between CPU registers and main memory.

### Cache Levels

| Level | Size | Latency | Location | Typical Use |
|-------|------|---------|----------|-------------|
| **L1** | 32-64 KB | 1-4 cycles | Per core | Most frequently accessed |
| **L2** | 256 KB - 1 MB | 3-10 cycles | Per core | Frequently used data |
| **L3** | 2-64 MB | 10-20 cycles | Shared across cores | Shared data between cores |
| **L4** | 128 MB+ | 20-30 cycles | On-package (eDRAM) | Specialized (e.g., Intel eDRAM) |

### Cache Organization

#### Direct-Mapped Cache

Each memory block maps to exactly one cache line.

```
Memory Address: [ Tag | Index | Offset ]

Index selects cache line.
Tag is compared to verify correct block.
Offset selects byte within block.

Example (32-bit address, 256 lines, 64-byte blocks):
┌────────┬──────────┬────────┐
│ Tag 20b │ Index 8b │ Off 6b │
└────────┴──────────┴────────┘
```

#### Fully Associative Cache

Any memory block can be stored in any cache line.

- No index needed
- Must search all lines simultaneously
- Expensive hardware (many comparators)
- Used for small, critical caches (TLBs)

#### Set-Associative Cache

Compromise between direct-mapped and fully associative.

```
N-way set-associative: each set contains N cache lines

Example (4-way set-associative):
┌────────┬─────────┬────────┐
│ Tag 18b │ Set 8b  │ Off 6b │
└────────┴─────────┴────────┘
Each set has 4 lines; any block in set can go in any of 4 lines.
```

### Cache Replacement Policies

| Policy | Description | Pros/Cons |
|--------|-------------|-----------|
| **LRU** | Replace Least Recently Used | Good hit rate, expensive for high associativity |
| **FIFO** | Replace First In, First Out | Simple, can cause Belady's anomaly |
| **Random** | Replace random line | Simple, unpredictable |
| **LFU** | Replace Least Frequently Used | Good for skewed access, needs counters |
| **Pseudo-LRU** | Tree-based approximation of LRU | Good balance, used in practice |

### Cache Write Policies

| Policy | Description | When to Use |
|--------|-------------|-------------|
| **Write-Through** | Write to both cache and main memory | Simple, consistent, higher latency |
| **Write-Back** | Write to cache only; write to memory when evicted | Lower bandwidth, needs dirty bit |
| **Write-Allocate** | On miss: load block into cache, then write | Usually paired with write-back |
| **No-Write-Allocate** | On miss: write directly to memory | Usually paired with write-through |

---

## 3. Cache Coherence

In multicore systems, each core has its own cache. When one core modifies data, other cores' caches must be updated.

### The Problem

```
Core 0 Cache:  [X = 5]
Core 1 Cache:  [X = 5]
Main Memory:   [X = 5]

Core 0 writes X = 10:
Core 0 Cache:  [X = 10]  ← updated
Core 1 Cache:  [X = 5]   ← STALE! (incorrect)
Main Memory:   [X = 5]   ← may also be stale
```

### Coherence Protocols

#### Snooping Protocols

All caches monitor (snoop) the bus for memory operations.

| Protocol | Description |
|----------|-------------|
| **MSI** | Modified, Shared, Invalid states |
| **MESI** | Adds Exclusive state (clean, only copy) |
| **MOESI** | Adds Owned state (dirty but shared) |

#### Directory-Based Protocols

A central directory tracks which caches have copies of each block.

- Better scalability for large systems
- Higher latency for directory lookups
- Used in many-core processors and distributed systems

---

## 4. Cache Miss Types (Three C's)

| Miss Type | Description | Solution |
|-----------|-------------|----------|
| **Compulsory (Cold)** | First access to a block | Prefetching |
| **Capacity** | Cache too small for working set | Increase cache size |
| **Conflict** | Multiple blocks map to same set | Increase associativity |

### Additional Miss Type

| Miss Type | Description |
|-----------|-------------|
| **Coherence** | Invalidated by another core's write | Better coherence protocol |

---

## 5. Main Memory (DRAM)

### DRAM Structure

```
┌─────────────────────────────────────┐
│              DRAM Cell               │
│                                      │
│     Word Line                        │
│     ───────────┐                     │
│                │                     │
│     Bit Line ──┤ 1T 1C              │
│                │ (Transistor +       │
│                │  Capacitor)         │
│                │                     │
└─────────────────────────────────────┘
```

### DRAM Types

| Type | Description | Bandwidth |
|------|-------------|-----------|
| **SDRAM** | Synchronous DRAM | 100-166 MHz |
| **DDR SDRAM** | Double Data Rate | 200-800 MT/s |
| **DDR2** | 4x prefetch | 400-1066 MT/s |
| **DDR3** | 8x prefetch | 800-2133 MT/s |
| **DDR4** | Bank groups | 1600-3200 MT/s |
| **DDR5** | Dual channel, on-die ECC | 3200-6400 MT/s |
| **LPDDR5** | Low power mobile | 3200-6400 MT/s |
| **HBM2/3** | High Bandwidth Memory | Up to 819 GB/s |

### Memory Channels

| Config | Description | Bandwidth |
|--------|-------------|-----------|
| **Single Channel** | One 64-bit channel | Baseline |
| **Dual Channel** | Two 64-bit channels | 2x |
| **Quad Channel** | Four 64-bit channels | 4x |
| **Octa Channel** | Eight 64-bit channels | 8x (server/HPC) |

---

## 6. Virtual Memory

Virtual memory provides each process with the illusion of a large, private address space.

### Address Translation

```
Virtual Address (VA):
┌──────────────┬──────────────┬──────────────┐
│  VPN (Virtual│  Page Number  │  Offset      │
│  Page Number) │              │              │
└──────┬───────┴──────────────┴──────────────┘
       │
       ▼
┌──────────────────┐
│    Page Table     │  ← maps VPN to PFN
│  (TLB for fast   │
│   lookup)        │
└──────┬───────────┘
       │
       ▼
┌──────────────┬──────────────┬──────────────┐
│  PFN (Physical│  Frame Number │  Offset      │
│  Frame Number) │              │              │
└───────────────┴──────────────┴──────────────┘
                   Physical Address
```

### Page Table

| Entry Component | Purpose |
|-----------------|---------|
| **Valid Bit** | Page is in physical memory |
| **Dirty Bit** | Page has been modified |
| **Reference Bit** | Page has been accessed |
| **Permission Bits** | Read, Write, Execute permissions |
| **PFN** | Physical frame number |

### TLB (Translation Lookaside Buffer)

The TLB is a cache for page table entries.

| Property | Typical Value |
|----------|--------------|
| **Size** | 64 - 1536 entries |
| **Associativity** | 4-way to fully associative |
| **Latency** | 1 cycle (L1 TLB), 3-10 cycles (L2 TLB) |
| **Hit Rate** | > 99% for sequential access |

### TLB Miss Handling

1. **Hardware TLB Miss**: Walk page table in hardware (most modern CPUs)
2. **Software TLB Miss**: Trap to OS, OS fills TLB (MIPS, SPARC)
3. **Page Fault**: Page not in memory; OS must load from disk

### Multi-Level Page Tables

```
32-bit address, 4KB pages (12-bit offset):

Single-level: 2^20 entries × 4 bytes = 4 MB per page table (per process!)

Two-level:
  Level 1 (Directory): 1024 entries × 4 bytes = 4 KB
  Level 2 (Table): Only allocated for used regions
  
  Total: Much less than 4 MB for sparse address spaces
```

---

## 7. Cache and Virtual Memory Interaction

### Virtual vs Physical Caches

| Type | Indexing | Pros/Cons |
|------|----------|-----------|
| **Virtually Indexed** | Uses virtual address | Fast (no translation needed), aliasing problem |
| **Physically Indexed** | Uses physical address | No aliasing, requires TLB first |
| **VIPT** | Virtually Indexed, Physically Tagged | Best of both; common in practice |

### VIPT Cache

```
Virtual Address:
┌────────┬────────┬────────┐
│ Tag    │ Index  │ Offset │ ← Index from VA (parallel with TLB)
└────────┴────────┴────────┘
               │
               ▼ (Index into cache)
Physical Address:
┌────────┬────────┬────────┐
│ Tag    │ Index  │ Offset │ ← Tag from PA (compare after TLB)
└────────┴────────┴────────┘
```

**Constraint**: Index must be from bits that are the same in VA and PA (i.e., page offset bits), or aliasing can occur.

---

## 8. Branch Prediction

Modern CPUs predict the outcome of branches to keep the pipeline full.

### Branch Prediction Techniques

| Technique | Description | Accuracy |
|-----------|-------------|----------|
| **Static** | Always predict taken/not-taken | ~60-70% |
| **1-bit** | Last outcome | ~70-80% |
| **2-bit saturating** | Requires two mispredictions to change | ~85-90% |
| **Correlating (m,n)** | Use m global history bits to index n-bit predictors | ~90-95% |
| **Tournament** | Meta-predictor chooses between two predictors | ~95-97% |
| **Perceptron** | Neural network-based prediction | ~96-98% |
| **BTB** | Branch Target Buffer caches branch targets | Reduces target miss |

### Branch Prediction Impact

```
Pipeline depth: 15 stages
Branch frequency: 1 in 5 instructions
Misprediction penalty: 15 cycles

Without prediction:
  CPI = 1 + (1/5 × 15) = 4.0 (terrible!)

With 95% accurate prediction:
  CPI = 1 + (1/5 × 0.05 × 15) = 1.15 (much better!)
```

---

## 9. Out-of-Order Execution

Modern CPUs execute instructions out of program order when possible to exploit ILP.

### Key Components

| Component | Purpose |
|-----------|---------|
| **Reorder Buffer (ROB)** | Tracks instructions for in-order commit |
| **Reservation Stations** | Hold instructions waiting for operands |
| **Register Renaming** | Eliminates false dependencies (WAR, WAW) |
| **Load/Store Queue** | Tracks memory operations for consistency |

### Execution Flow

```
Fetch → Decode → Rename → Dispatch → Execute → Complete → Commit
                              │                     │
                              ▼                     ▼
                        Reservation          Reorder Buffer
                        Stations             (in-order retire)
```

---

## 10. Memory Performance Optimization

### Code Patterns for Cache Efficiency

| Pattern | Bad | Good |
|---------|-----|------|
| **Row-major traversal** | Column-first in C | Row-first in C |
| **Stride access** | Large stride (> cache line) | Sequential access |
| **Spatial locality** | Random access | Block access |
| **Temporal locality** | One-time use | Repeated use |

### Example: Matrix Traversal

```c
// Bad: Column-major (poor cache performance)
for (int j = 0; j < N; j++)
    for (int i = 0; i < N; i++)
        sum += matrix[i][j];  // jumps N*sizeof(int) bytes each iteration

// Good: Row-major (cache-friendly)
for (int i = 0; i < N; i++)
    for (int j = 0; j < N; j++)
        sum += matrix[i][j];  // sequential access, prefetching works
```

### Cache Line Awareness

- Cache line size: typically 64 bytes
- `sizeof(int) = 4`, so 16 ints per cache line
- Sequential array access: 1 cache miss per 16 int accesses
- Strided access with stride > 16: every access is a miss

---

## Summary

| Component | Key Point |
|-----------|-----------|
| **Registers** | Fastest storage, directly on CPU |
| **L1 Cache** | ~1 ns, per-core, split I/D |
| **L2 Cache** | ~3-10 ns, per-core, unified |
| **L3 Cache** | ~10-20 ns, shared across cores |
| **DRAM** | ~50-100 ns, GB range |
| **Virtual Memory** | Process isolation, larger address space |
| **TLB** | Cache for page table entries |
| **Branch Prediction** | Keeps pipeline full, >95% accurate |
| **Out-of-Order** | Exploits ILP beyond program order |

> **Key Insight**: The memory hierarchy is designed around the principles of **temporal locality** (recently accessed data will be accessed again) and **spatial locality** (nearby data will be accessed soon). Writing cache-aware code can yield 10-100x performance improvements.
