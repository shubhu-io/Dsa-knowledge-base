# Computer Architecture Interview Questions

## Table of Contents

1. [Fundamentals](#fundamentals)
2. [CPU and Registers](#cpu-and-registers)
3. [Memory Hierarchy](#memory-hierarchy)
4. [Caching](#caching)
5. [Virtual Memory](#virtual-memory)
6. [Pipelining](#pipelining)
7. [Performance](#performance)
8. [System Design](#system-design)

---

## Fundamentals

### Q1: Explain the Von Neumann architecture. What is the Von Neumann bottleneck?

**Answer:**

Von Neumann architecture stores both instructions and data in a single shared memory. The CPU fetches instructions sequentially, decodes them, and executes them.

The **Von Neumann bottleneck** occurs because the same bus is used for both instruction and data transfers. Since only one transfer can occur at a time, the CPU often waits for memory access, limiting throughput.

**Solutions:**
- Separate instruction and data caches (Modified Harvard)
- Wider buses and higher bandwidth memory
- Prefetching and branch prediction to hide latency

---

### Q2: What is the difference between Von Neumann and Harvard architecture?

| Feature | Von Neumann | Harvard |
|---------|------------|---------|
| Memory | Single shared | Separate (instructions + data) |
| Buses | One set | Two sets |
| Parallelism | Sequential | Can fetch + access data simultaneously |
| Cost | Lower | Higher |
| Use case | General purpose | Embedded, DSP |

---

### Q3: What is RISC vs CISC? Give examples.

**Answer:**

| | RISC | CISC |
|---|------|------|
| Instruction size | Fixed (32-bit typical) | Variable (1-15+ bytes) |
| Instructions | Many simple | Few complex |
| Memory access | Load/Store only | Many addressing modes |
| Registers | 32+ | 8-16 |
| Pipelining | Easy | Difficult |
| Examples | ARM, RISC-V, MIPS | x86, x86-64 |

Modern x86 processors use a **hybrid approach**: the CISC ISA is translated into RISC-like micro-operations internally.

---

### Q4: Explain the instruction cycle.

**Answer:**

The instruction cycle (fetch-decode-execute cycle) is:

1. **Fetch**: Read the next instruction from memory using the Program Counter (PC)
2. **Decode**: Determine the operation type and required operands
3. **Execute**: Perform the operation (ALU computation, memory access, etc.)
4. **Write Back**: Store the result in a register or memory
5. **PC Update**: Increment PC (or set to branch target)

In a pipelined processor, multiple instructions are in different stages simultaneously.

---

## CPU and Registers

### Q5: What are the different types of registers in a CPU?

**Answer:**

| Register | Purpose |
|----------|---------|
| **Program Counter (PC)** | Address of next instruction |
| **Instruction Register (IR)** | Current instruction being executed |
| **Memory Address Register (MAR)** | Address for memory access |
| **Memory Data Register (MDR)** | Data to/from memory |
| **Accumulator (ACC)** | ALU intermediate results |
| **Stack Pointer (SP)** | Top of stack address |
| **General Purpose (R0-R31)** | Data operations |
| **Status/Flag Register** | Zero, Carry, Overflow, Negative flags |

---

### Q6: What is the difference between little-endian and big-endian?

**Answer:**

Byte ordering of multi-byte values in memory:

```
Value: 0x12345678

Little-Endian (x86):     Big-Endian (Network):
Address: 0  1  2  3      Address: 0  1  2  3
Data:    78 56 34 12     Data:    12 34 56 78
         ↑ LSB first              ↑ MSB first
```

- **Little-endian**: LSB at lowest address (x86, ARM default)
- **Big-endian**: MSB at lowest address (network protocols, PowerPC)

**Why it matters**: Network byte order is big-endian. `htons()` and `ntohs()` convert between host and network byte order.

---

## Memory Hierarchy

### Q7: Explain the memory hierarchy. Why does it exist?

**Answer:**

The memory hierarchy exploits two principles:

1. **Temporal Locality**: Recently accessed data will likely be accessed again
2. **Spatial Locality**: Data near recently accessed data will likely be accessed

```
Registers    → Fastest (~0.3 ns), Smallest (~1 KB), Most Expensive
L1 Cache     → ~1 ns, 32-64 KB
L2 Cache     → ~3-10 ns, 256 KB - 1 MB
L3 Cache     → ~10-20 ns, 2-64 MB
RAM          → ~50-100 ns, 8-128 GB
SSD          → ~10-100 μs, 256 GB - 4 TB
HDD          → ~5-10 ms, 1-20 TB
```

The hierarchy exists because building all memory from the fastest technology would be prohibitively expensive. By keeping frequently used data in fast memory and less used data in slower memory, we get near-Register speed at near-RAM cost.

---

### Q8: What happens on a cache miss?

**Answer:**

When the CPU requests data not in the cache:

1. **Cache controller** checks all cache levels (L1 → L2 → L3)
2. If found in a lower level (**cache hit**): data is promoted to higher levels
3. If not found in any cache (**cache miss**): fetch from main memory
4. **Replacement policy** decides which cache line to evict (LRU, Random, etc.)
5. Data is placed in the cache line, and the request is satisfied

**Types of cache misses (3 C's):**
- **Compulsory**: First access (cold miss)
- **Capacity**: Cache too small for working set
- **Conflict**: Multiple blocks map to same set (direct-mapped)

---

## Caching

### Q9: Explain direct-mapped, set-associative, and fully associative caches.

**Answer:**

| Type | How It Works | Pros | Cons |
|------|-------------|------|------|
| **Direct-mapped** | Each block maps to exactly one cache line | Simple, fast lookup | High conflict misses |
| **N-way set-associative** | Each block maps to a set of N lines | Good balance | More complex, slower |
| **Fully associative** | Block can go anywhere | Fewest conflict misses | Expensive hardware, slow |

**Example** (32-bit address, 256 lines, 64-byte blocks):

```
Direct-mapped:
  Address = [ Tag: 20 bits | Index: 8 bits | Offset: 6 bits ]
  Index selects exactly one line.

4-way set-associative:
  Address = [ Tag: 18 bits | Set: 8 bits | Offset: 6 bits ]
  Set selects one of 64 sets, each with 4 lines.
  All 4 lines in the set are checked simultaneously.

Fully associative:
  Address = [ Tag: 26 bits | Offset: 6 bits ]
  No index; all 256 lines checked simultaneously.
```

---

### Q10: What is cache coherence? Why is it important in multicore systems?

**Answer:**

In multicore systems, each core has its own cache. When one core modifies data, other cores' copies become stale. **Cache coherence** ensures all cores see a consistent view of memory.

**Coherence protocols:**

| Protocol | States | Description |
|----------|--------|-------------|
| **MSI** | Modified, Shared, Invalid | Basic snooping protocol |
| **MESI** | Modified, Exclusive, Shared, Invalid | Adds exclusive state |
| **MOESI** | Modified, Owned, Exclusive, Shared, Invalid | Adds owned state |

**MESI states:**
- **Modified**: Only copy, dirty (needs writeback)
- **Exclusive**: Only copy, clean
- **Shared**: Multiple copies, clean
- **Invalid**: Not valid

---

### Q11: What are the different cache write policies?

**Answer:**

| Policy | Behavior | Trade-off |
|--------|----------|-----------|
| **Write-through** | Write to cache AND memory | Simple, consistent, high bus traffic |
| **Write-back** | Write to cache only; memory updated on eviction | Low bus traffic, needs dirty bit |
| **Write-allocate** | On miss: load block into cache, then write | Paired with write-back |
| **No-write-allocate** | On miss: write directly to memory | Paired with write-through |

**Most common combination**: Write-back + Write-allocate (used in most L1/L2 caches)

---

## Virtual Memory

### Q12: Explain virtual memory. Why do we need it?

**Answer:**

Virtual memory gives each process a large, private address space independent of physical memory.

**Benefits:**
1. **Process isolation**: One process cannot access another's memory
2. **Larger address space**: Programs can use more memory than physically available
3. **Simplified memory management**: No need to worry about physical addresses
4. **Memory sharing**: Shared libraries mapped into multiple processes

**How it works:**
- CPU generates **virtual addresses**
- **Page table** maps virtual → physical addresses
- **TLB** caches recent translations
- On **page fault**: OS loads missing page from disk

---

### Q13: What is a TLB? What happens on a TLB miss?

**Answer:**

The **Translation Lookaside Buffer (TLB)** is a cache for page table entries.

**TLB miss handling:**

1. **Hardware TLB refill** (most modern CPUs): Hardware page table walker traverses the page table
2. **Software TLB refill** (MIPS, SPARC): Trap to OS, OS fills TLB
3. **Page fault**: Page not in physical memory → OS loads from disk

**TLB characteristics:**
- 64 - 1536 entries
- 4-way to fully associative
- 1 cycle (L1 TLB), 3-10 cycles (L2 TLB)
- >99% hit rate for most workloads

---

### Q14: What is a page fault?

**Answer:**

A page fault occurs when a process accesses a virtual page not currently in physical memory.

**Page fault handler:**
1. Trap to OS
2. Check if the virtual address is valid (in process's address space)
3. Find a free physical frame (or evict one using page replacement)
4. Load the page from disk/swap
5. Update the page table
6. Restart the faulting instruction

**Page replacement policies:**

| Policy | Description |
|--------|-------------|
| **LRU** | Replace least recently used page |
| **Clock (Second Chance)** | Approximation of LRU |
| **Optimal** | Replace page not used for longest time (theoretical) |
| **FIFO** | Replace oldest page |

---

## Pipelining

### Q15: What are the three types of pipeline hazards?

**Answer:**

| Hazard | Cause | Solution |
|--------|-------|----------|
| **Structural** | Hardware resource conflict | Separate I/D caches, duplicate hardware |
| **Data** | Instruction depends on previous result | Forwarding, stalling, code reordering |
| **Control** | Branch changes execution flow | Branch prediction, delayed branch |

---

### Q16: Explain data forwarding (bypassing). When is it not enough?

**Answer:**

**Forwarding** routes results directly from pipeline registers to where they're needed, bypassing the register file.

```
ADD R1, R2, R3     ; Result in EX/MEM pipeline register
SUB R4, R1, R5     ; Needs R1 in EX stage → Forward from EX/MEM
```

**When forwarding is NOT enough: Load-use hazard**

```assembly
LW  R1, 0(R2)     ; Data available after MEM stage
SUB R4, R1, R5     ; Needs R1 in EX stage → 1 cycle gap!
```

Even with forwarding, the data isn't ready until after MEM. Solution: **1-cycle stall** (pipeline bubble) or **instruction reordering**.

---

### Q17: What is the branch prediction penalty?

**Answer:**

When a branch is mispredicted, all speculatively fetched instructions must be flushed.

```
Pipeline depth: 15 stages
Misprediction penalty: ~15 cycles wasted

Branch frequency: 1 in 5 instructions
Misprediction rate: 5%

CPI impact = 1 + (1/5 × 0.05 × 15) = 1 + 0.15 = 1.15
```

Modern predictors achieve >95% accuracy, making the penalty manageable.

---

## Performance

### Q18: Explain Amdahl's Law.

**Answer:**

```
Speedup = 1 / ((1 - F) + F/S)

Where:
  F = fraction of execution time that can be improved
  S = speedup of the improved fraction
```

**Example**: 60% of program is vectorizable, vector unit is 10x faster.

```
Speedup = 1 / ((1 - 0.6) + 0.6/10)
        = 1 / (0.4 + 0.06)
        = 1 / 0.46
        = 2.17x
```

**Key insight**: Even with infinite speedup for the vectorizable part:

```
Max Speedup = 1 / (1 - 0.6) = 1 / 0.4 = 2.5x
```

The sequential fraction limits overall speedup regardless of parallel resources.

---

### Q19: Calculate CPI given the following:
- 25% loads (15% cause load-use stalls of 1 cycle)
- 10% branches (80% correctly predicted, 2-cycle penalty on mispredict)
- 15% jumps (always correctly predicted, 0-cycle penalty)

**Answer:**

```
CPI = Base + Load penalty + Branch penalty

Base CPI = 1.0

Load penalty: 0.25 × 0.15 × 1.0 = 0.0375
Branch penalty: 0.10 × 0.20 × 2.0 = 0.04

CPI = 1.0 + 0.0375 + 0.04 = 1.0775
```

---

### Q20: What is the difference between throughput and latency?

**Answer:**

| Metric | Definition | Example |
|--------|-----------|---------|
| **Latency** | Time for one operation to complete | 5 ns per instruction |
| **Throughput** | Operations completed per unit time | 1 billion instructions/sec |

**Pipeline impact:**
- Latency: Same (or slightly increased due to register overhead)
- Throughput: Significantly improved (multiple instructions in flight)

**Analogy**: A laundromat with 5 machines. Each load takes 1 hour (latency). But you can do 5 loads per hour (throughput). The machines don't make each load faster; they process multiple loads in parallel.

---

## System Design

### Q21: How would you design a cache for a matrix multiplication workload?

**Answer:**

Matrix multiplication (C = A × B) has specific access patterns:

- **Matrix A**: Row-wise (good for row-major)
- **Matrix B**: Column-wise (bad for row-major; causes cache misses)
- **Matrix C**: Row-wise (good)

**Optimization strategies:**

1. **Loop tiling/blocking**: Process small blocks that fit in cache
```c
for (int ii = 0; ii < N; ii += BLOCK)
  for (int jj = 0; jj < N; jj += BLOCK)
    for (int kk = 0; kk < N; kk += BLOCK)
      // Multiply BLOCK×BLOCK submatrices
```

2. **Cache-oblivious algorithms**: Recursive decomposition
3. **Transpose B**: Convert column access to row access
4. **Use SIMD**: AVX/NEON for parallel multiply-accumulate

---

### Q22: Explain the trade-offs in designing a multi-level cache.

**Answer:**

| Design Decision | Trade-off |
|----------------|-----------|
| **L1 size** | Larger → fewer misses, but slower access |
| **Associativity** | Higher → fewer conflicts, but more hardware |
| **Inclusive vs Exclusive** | Inclusive: simple coherence, Exclusive: more effective capacity |
| **Write policy** | Write-back: lower bandwidth, Write-through: simpler coherence |
| **Replacement** | LRU: better hit rate, Random: simpler hardware |

**Typical modern design:**
- L1: 32-64 KB, 8-way, split I/D, write-back
- L2: 256 KB-1 MB, 8-way, unified, write-back
- L3: 2-64 MB, 12-16 way, shared, write-back

---

### Q23: Why is memory the bottleneck in modern systems?

**Answer:**

**The Memory Wall**: CPU speed has increased much faster than memory speed.

```
CPU speed improvement: ~60% per year
Memory speed improvement: ~10% per year

Gap grows every year!
```

**Solutions:**
- Larger caches (exploit locality)
- Prefetching (predict future accesses)
- Out-of-order execution (hide memory latency)
- Memory-level parallelism (issue multiple memory requests)
- High Bandwidth Memory (HBM)
- Near-data processing (compute closer to memory)

---

### Q24: What is a cache-friendly data structure? Give an example.

**Answer:**

A cache-friendly data structure minimizes cache misses by:

1. **Contiguous memory layout**: Arrays over linked lists
2. **Spatial locality**: Related data stored together
3. **Minimizing indirection**: Fewer pointer chasing steps

**Example:**

```cpp
// Bad: Linked list (cache unfriendly)
struct Node {
    int data;
    Node* next;  // Pointer chase → cache miss
};

// Good: Array-based (cache friendly)
std::vector<int> data;  // Contiguous memory, prefetch-friendly
```

**Performance difference:**
- Linked list traversal: ~100 ns per node (cache miss every time)
- Array traversal: ~1 ns per element (sequential access, prefetching)

---

### Q25: Explain register renaming and why it's needed.

**Answer:**

Register renaming eliminates **false dependencies** by mapping architectural registers to a larger set of physical registers.

**False dependencies:**

```assembly
ADD R1, R2, R3     ; Writes R1
SUB R5, R6, R7     ; Independent
ADD R1, R8, R9     ; WAW on R1 with first ADD (false dependency!)
                    ; The second ADD doesn't actually need the first ADD's R1
```

**After renaming:**

```assembly
ADD R1 → P1, R2, R3
SUB R5 → P5, R6, R7
ADD R1 → P12, R8, R9  ; P12 is different from P1
```

Now all three instructions can execute in parallel (no false dependencies).

---

## Quick-Fire Questions

| # | Question | Answer |
|---|----------|--------|
| 26 | What is CPI? | Cycles per instruction |
| 27 | What is IPC? | Instructions per cycle (1/CPI) |
| 28 | What is MIPS? | Million instructions per second |
| 29 | What is a pipeline bubble? | Stall cycle with no useful work |
| 30 | What is speculative execution? | Executing before branch outcome is known |
| 31 | What is a TLB? | Cache for page table entries |
| 32 | What is DMA? | Direct Memory Access (bypass CPU for I/O) |
| 33 | What is SIMD? | Single Instruction, Multiple Data |
| 34 | What is branch prediction? | Guessing branch outcome to keep pipeline full |
| 35 | What is write-back caching? | Write to cache only; memory updated on eviction |
| 36 | What is cache associativity? | How many cache lines a block can be placed in |
| 37 | What is a page table? | Virtual → physical address mapping |
| 38 | What is the PC? | Program Counter; holds next instruction address |
| 39 | What is a Harvard architecture? | Separate instruction and data memory |
| 40 | What is Flynn's taxonomy? | SISD, SIMD, MISD, MIMD classification |

---

## Tips for Architecture Interviews

1. **Draw diagrams**: Visual representations help explain concepts clearly
2. **Use concrete numbers**: "L1 cache has 1 ns latency" is better than "very fast"
3. **Know the trade-offs**: Every design decision has pros and cons
4. **Relate to real hardware**: Mention Intel, ARM, RISC-V when relevant
5. **Practice calculations**: CPI, speedup, cache miss rates
6. **Think about scale**: How does this change with more cores / more data?
