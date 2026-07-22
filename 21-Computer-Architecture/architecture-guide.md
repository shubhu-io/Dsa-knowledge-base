# Computer Architecture Guide

## 1. Introduction to Computer Architecture

Computer Architecture refers to the design and organization of a computer's components and how they interact to form a functional system. It encompasses both the hardware structure and the instruction set that software uses to communicate with hardware.

### Key Terminology

| Term | Definition |
|------|-----------|
| **ISA (Instruction Set Architecture)** | The abstract model defining how software controls hardware |
| **Microarchitecture** | The physical implementation of an ISA |
| **Organization** | How units are interconnected and how data flows |
| **Performance** | Speed of execution, measured in MIPS, FLOPS, or CPI |

---

## 2. Von Neumann Architecture

The most widely used computer architecture model, proposed by John von Neumann in 1945.

### Characteristics

- **Single shared memory** for both instructions and data
- **Sequential execution** of instructions
- **Bus bottleneck**: Only one instruction or data item can be fetched at a time (Von Neumann bottleneck)
- **Stored-program concept**: Instructions are stored in memory like data

### Components

```
┌──────────────────────────────────────────┐
│                CPU                        │
│  ┌─────────────┐  ┌──────────────────┐   │
│  │  Control     │  │  Arithmetic Logic│   │
│  │  Unit (CU)   │  │  Unit (ALU)     │   │
│  └──────┬──────┘  └────────┬─────────┘   │
│         │                  │              │
│  ┌──────┴──────────────────┴─────────┐   │
│  │          Internal Bus              │   │
│  └──────────────┬────────────────────┘   │
├─────────────────┼────────────────────────┤
│                 │   System Bus           │
├─────────────────┼────────────────────────┤
│     ┌───────────┴───────────┐            │
│     │    Memory Unit        │            │
│     │ (Instructions + Data) │            │
│     └───────────────────────┘            │
└──────────────────────────────────────────┘
```

### Advantages
- Simple design and implementation
- Easy to program (instructions are data)
- Flexible (can be reprogrammed)

### Disadvantages
- Von Neumann bottleneck limits throughput
- Single point of failure
- Limited parallelism

---

## 3. Harvard Architecture

Uses **separate memory systems** for instructions and data.

### Characteristics

- Separate buses for instruction and data memory
- Can fetch instruction and read/write data simultaneously
- Higher throughput than Von Neumann for simple systems
- Commonly used in DSPs, microcontrollers, and embedded systems

### Comparison with Von Neumann

| Feature | Von Neumann | Harvard |
|---------|------------|---------|
| Memory | Single shared | Separate for instructions and data |
| Buses | One set | Two sets |
| Throughput | Lower (bottleneck) | Higher (parallel access) |
| Cost | Lower | Higher (more hardware) |
| Complexity | Simpler | More complex |
| Use Case | General-purpose computers | Embedded systems, DSPs |

---

## 4. Modified Harvard Architecture

A hybrid approach used in most modern processors:

- Separate **L1 caches** for instructions (I-cache) and data (D-cache)
- Shared **main memory** (like Von Neumann)
- Benefits of both architectures: parallel cache access + unified memory

---

## 5. RISC vs CISC

### RISC (Reduced Instruction Set Computer)

- Simple, fixed-length instructions
- Large number of registers
- Load/store architecture (only load/store access memory)
- Hardwired control unit
- Pipelining-friendly
- Examples: ARM, RISC-V, MIPS, PowerPC

### CISC (Complex Instruction Set Computer)

- Variable-length instructions
- Fewer registers
- Memory-to-memory operations supported
- Microprogrammed control unit
- Single instructions can do complex tasks
- Examples: x86, x86-64, VAX

### Comparison

| Feature | RISC | CISC |
|---------|------|------|
| Instruction length | Fixed | Variable |
| Instructions count | Many simple | Few complex |
| Registers | Many (32+) | Few (8-16) |
| Memory access | Load/Store only | Multiple addressing modes |
| Clock cycles/inst | Few (1-2) | Many (1-15) |
| Compiler complexity | Higher | Lower |
| Code size | Larger | Smaller |
| Power consumption | Lower | Higher |

---

## 6. Instruction Cycle (Fetch-Decode-Execute)

Every processor follows this fundamental cycle:

```
┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐
│  FETCH  │───>│  DECODE │───>│ EXECUTE │───>│  WRITE  │
│         │    │         │    │         │    │  BACK   │
└─────────┘    └─────────┘    └─────────┘    └────┬────┘
      ▲                                           │
      └───────────────────────────────────────────┘
```

### Steps

1. **Fetch**: Read instruction from memory at the address in PC (Program Counter)
2. **Decode**: Determine instruction type and operands needed
3. **Execute**: Perform the operation in ALU or control unit
4. **Write Back**: Store result in register or memory

### Instruction Formats

```
R-Type:  [ opcode | rd | rs1 | rs2 | funct3 | funct7 ]
I-Type:  [ opcode | rd | rs1 | imm[11:0] | funct3   ]
S-Type:  [ opcode | imm[4:0] | rs1 | rs2 | imm[11:5] ]
B-Type:  [ opcode | imm[12|10:5] | rs1 | rs2 | imm[4:1|11] ]
U-Type:  [ opcode | rd | imm[31:12] ]
J-Type:  [ opcode | rd | imm[20|10:1|11|19:12] ]
```

---

## 7. Memory Hierarchy

The memory hierarchy exploits the **principle of locality** to provide fast access to frequently used data.

```
            Speed ↑
            Cost ↑
            Size ↓
┌──────────────────┐  ← Registers (sub-nanosecond)
│    Registers     │     ~1 KB
├──────────────────┤  ← L1 Cache (1-2 ns)
│    L1 Cache      │     32-64 KB
├──────────────────┤  ← L2 Cache (3-10 ns)
│    L2 Cache      │     256 KB - 1 MB
├──────────────────┤  ← L3 Cache (10-20 ns)
│    L3 Cache      │     2-64 MB
├──────────────────┤  ← Main Memory (50-100 ns)
│    RAM (DRAM)    │     8-128 GB
├──────────────────┤  ← SSD (10-100 μs)
│    SSD/NVMe      │     256 GB - 4 TB
├──────────────────┤  ← HDD (5-10 ms)
│    Hard Disk     │     1-20 TB
└──────────────────┘  ← Network/Cloud (>1 ms)
                      Petabytes
```

---

## 8. Bus Architecture

A bus is a communication system that transfers data between components.

### Types of Buses

| Bus Type | Purpose | Example |
|----------|---------|---------|
| **Data Bus** | Carries actual data | 64-bit data bus |
| **Address Bus** | Carries memory addresses | 32-bit (4 GB addressable) |
| **Control Bus** | Carries control signals | Read/Write, Interrupt |

### Bus Topologies

- **Shared Bus**: All components share one bus (simple but bottlenecked)
- **Point-to-Point**: Direct connections between components (faster, more expensive)
- **Crossbar**: Any component can connect to any other (used in modern CPUs)

---

## 9. I/O Methods

| Method | Description | CPU Involvement |
|--------|-------------|----------------|
| **Programmed I/O** | CPU polls device status | High |
| **Interrupt-Driven I/O** | Device signals CPU when ready | Medium |
| **DMA (Direct Memory Access)** | Device transfers data directly to/from memory | Low |

### DMA Process

1. CPU programs the DMA controller with source, destination, and count
2. CPU continues executing other instructions
3. DMA controller transfers data block directly to/from memory
4. DMA controller sends interrupt when transfer is complete

---

## 10. Performance Metrics

### Key Metrics

| Metric | Formula | Description |
|--------|---------|-------------|
| **CPI** | Cycles / Instructions | Cycles per instruction |
| **MIPS** | Clock Rate / (CPI × 10⁶) | Million instructions per second |
| **Execution Time** | Instructions × CPI × Clock Period | Total time to run a program |
| **Throughput** | Instructions / Time | Total work done per unit time |

### Amdahl's Law

```
Speedup = 1 / ((1 - F) + F/S)

Where:
  F = fraction of execution improved
  S = speedup of improved portion
```

### Example

If 60% of execution time is vectorizable and the vector unit is 5x faster:

```
Speedup = 1 / ((1 - 0.6) + 0.6/5)
        = 1 / (0.4 + 0.12)
        = 1 / 0.52
        = 1.92x
```

---

## 11. Parallelism

### Types of Parallelism

| Type | Description | Example |
|------|-------------|---------|
| **ILP (Instruction-Level)** | Execute multiple instructions simultaneously | Pipelining, superscalar |
| **TLP (Thread-Level)** | Execute multiple threads simultaneously | Multicore, SMT (Hyper-Threading) |
| **DLP (Data-Level)** | Apply same operation to multiple data elements | SIMD, vector processing |

### Flynn's Taxonomy

| Category | Description | Example |
|----------|-------------|---------|
| **SISD** | Single Instruction, Single Data | Single-core processor |
| **SIMD** | Single Instruction, Multiple Data | GPU, SSE/AVX instructions |
| **MISD** | Multiple Instructions, Single Data | Fault-tolerant systems |
| **MIMD** | Multiple Instructions, Multiple Data | Multicore processors, clusters |

---

## 12. Endianness

The byte ordering of multi-byte data in memory.

| Type | Description | Used By |
|------|-------------|---------|
| **Little-Endian** | Least significant byte at lowest address | x86, ARM (default) |
| **Big-Endian** | Most significant byte at lowest address | Network protocols (TCP/IP), PowerPC |

### Example: Storing 0x12345678

```
Little-Endian:          Big-Endian:
Address: 0  1  2  3    Address: 0  1  2  3
Data:    78 56 34 12   Data:    12 34 56 78
```

---

## Summary

| Concept | Key Takeaway |
|---------|-------------|
| Von Neumann | Shared memory for instructions and data |
| Harvard | Separate memory for instructions and data |
| RISC | Simple instructions, many registers, pipelining-friendly |
| CISC | Complex instructions, variable length |
| Memory Hierarchy | Fast/small → Slow/large trade-off |
| Bus | Communication backbone between components |
| DMA | Offloads I/O from CPU |
| Amdahl's Law | Parallel speedup is limited by sequential portion |
| Endianness | Byte order matters for multi-byte data |
