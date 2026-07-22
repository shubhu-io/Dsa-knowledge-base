# Instruction Pipelining

## 1. What is Pipelining?

Pipelining is a technique where multiple instructions are overlapped in execution, similar to an assembly line. While one instruction is being executed, the next is being decoded, and the one after that is being fetched.

### Without Pipelining (Sequential Execution)

```
Instruction 1: Fetch → Decode → Execute → Memory → Writeback
Instruction 2:                          Fetch → Decode → Execute → Memory → Writeback
Instruction 3:                                                   Fetch → Decode → Execute → Memory → Writeback

Time: ──────────────────────────────────────────────────────────────────────────────────────>
       5 cycles × 3 instructions = 15 cycles total
```

### With Pipelining

```
Instruction 1: Fetch → Decode → Execute → Memory → Writeback
Instruction 2:        Fetch → Decode → Execute → Memory → Writeback
Instruction 3:               Fetch → Decode → Execute → Memory → Writeback
Instruction 4:                      Fetch → Decode → Execute → Memory → Writeback

Time: ──────────────────────────────────────────────────────────────────────>
       5 + 3 = 8 cycles total (vs 15)
```

### Key Benefits

- **Throughput**: More instructions completed per unit time
- **Clock speed**: Each stage is simpler, allowing higher clock rates
- **Efficiency**: Hardware units are utilized more effectively

---

## 2. Classic 5-Stage RISC Pipeline

The classic MIPS/RISC pipeline has 5 stages:

```
┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐
│  FETCH  │──>│  DECODE │──>│ EXECUTE │──>│  MEMORY │──>│WRITEBACK│
│  (IF)   │   │  (ID)   │   │  (EX)   │   │  (MEM)  │   │  (WB)   │
└─────────┘   └─────────┘   └─────────┘   └─────────┘   └─────────┘
```

### Stage Descriptions

| Stage | Name | Action |
|-------|------|--------|
| **IF** | Instruction Fetch | Read instruction from memory at PC address |
| **ID** | Instruction Decode | Decode instruction, read registers |
| **EX** | Execute | Perform ALU operation or compute address |
| **MEM** | Memory Access | Read from or write to memory |
| **WB** | Write Back | Write result back to register file |

### Hardware Per Stage

```
IF:  Instruction Memory, PC, Adder (PC+4)
ID:  Register File, Control Unit, Sign Extender
EX:  ALU, Muxes, Forwarding Unit
MEM: Data Memory
WB:  Register File, Mux
```

---

## 3. Pipeline Registers

Pipeline registers separate stages and hold intermediate values.

```
┌──────┐  IF/ID  ┌──────┐  ID/EX  ┌──────┐  EX/MEM  ┌──────┐  MEM/WB  ┌──────┐
│  IF  │────────>│  ID  │────────>│  EX  │────────>│  MEM │────────>│  WB  │
│      │ Register│      │ Register│      │ Register│      │ Register│      │
└──────┘         └──────┘         └──────┘         └──────┘         └──────┘
```

### IF/ID Register Contents

- Instruction bits (opcode, rd, rs1, rs2, immediate)
- PC + 4 (for branch target calculation)

### ID/EX Register Contents

- Register values (rs1_val, rs2_val)
- Sign-extended immediate
- Control signals (ALUOp, RegWrite, MemRead, MemWrite, etc.)
- Destination register number

### EX/MEM Register Contents

- ALU result
- Data to write to memory (for store instructions)
- Destination register number
- Control signals (MemRead, MemWrite, RegWrite, Branch)

### MEM/WB Register Contents

- ALU result or memory read data
- Destination register number
- Control signals (MemtoReg, RegWrite)

---

## 4. Pipeline Hazards

Hazards are conditions that prevent the next instruction from executing in its designated clock cycle.

### 4.1 Structural Hazards

**Definition**: Hardware cannot support the combination of instructions that we want to execute in the same clock cycle.

#### Example

```
Single memory port for instructions and data:
Cycle 1: IF of I1 needs memory (instruction fetch)
Cycle 4: MEM of I1 needs memory (data access)
         IF of I4 needs memory (instruction fetch)  ← CONFLICT!
```

#### Solutions

| Solution | Description |
|----------|-------------|
| **Separate memories** | Harvard architecture (separate I-cache and D-cache) |
| **Separate cache banks** | Split L1 cache into instruction and data |
| **Pipeline stall** | Insert bubble to delay conflicting instruction |

### 4.2 Data Hazards

**Definition**: An instruction depends on the result of a previous instruction that hasn't completed yet.

#### Types of Data Hazards

| Hazard | Name | Example |
|--------|------|---------|
| **RAW** | Read After Write | I2 reads register that I1 writes (true dependency) |
| **WAR** | Write After Read | I2 writes register that I1 reads (anti-dependency) |
| **WAW** | Write After Write | I2 writes register that I1 writes (output dependency) |

#### Example: RAW Hazard

```assembly
ADD  R1, R2, R3    ; I1: R1 = R2 + R3 (writes R1 in WB)
SUB  R4, R1, R5    ; I2: R4 = R1 - R5 (reads R1 in ID) ← HAZARD!
```

Without forwarding, I2 must wait 2 cycles for I1 to write R1.

#### Solutions

**a) Forwarding (Bypassing)**

Route the result directly from EX/MEM or MEM/WB pipeline register to the ALU input.

```
EX/MEM.ALU_Result ──────────────────────┐
                                        ▼
                               ┌─────────────────┐
I2's EX stage:    ┌──────────>│     ALU Mux      │──> ALU Input
                  │           └─────────────────┘
MEM/WB.Result ────┘ (if EX/MEM forwarding not available)
```

**b) Pipeline Stalling (Load-Use Hazard)**

When a load instruction is followed immediately by an instruction that uses the loaded value, forwarding alone is not enough.

```assembly
LW   R1, 0(R2)    ; I1: Load from memory (result available after MEM)
SUB  R4, R1, R5    ; I2: Needs R1 in EX stage ← 1 cycle bubble needed
```

```
LW:   IF → ID → EX → MEM → WB
SUB:       IF → ID → stall → EX → MEM → WB
                        ↑
                    1-cycle bubble (stall)
```

**c) Code Reordering**

The compiler can reorder independent instructions to fill the load-use delay slot.

```assembly
; Original (hazard):
LW   R1, 0(R2)
SUB  R4, R1, R5     ; stall needed

; Reordered (no stall):
LW   R1, 0(R2)
ADD  R6, R7, R8     ; independent instruction fills delay
SUB  R4, R1, R5     ; R1 is now available
```

### 4.3 Control Hazards (Branch Hazards)

**Definition**: The pipeline makes wrong decisions on branch outcomes or targets.

#### The Problem

```
BNE  R1, R2, Target   ; Branch instruction
ADD  R3, R4, R5       ; Next instruction (may be wrong!)
SUB  R6, R7, R8       ; Instruction after (may be wrong!)
...
Target:
OR   R9, R10, R11     ; Should have been fetched after branch
```

If the branch is taken, ADD and SUB should not have been fetched.

#### Branch Penalty

| Pipeline Depth | Penalty (cycles) |
|---------------|------------------|
| 5-stage | 1-2 cycles |
| 10-stage | 3-5 cycles |
| 15-stage (modern) | 10-20 cycles |

#### Solutions

**a) Stall on Branch**

Simple but expensive: freeze pipeline until branch outcome is known.

**b) Predict Not Taken**

Assume branch not taken; if wrong, flush and refetch. Works if most branches are not taken.

**c) Predict Taken**

Assume branch taken; fetch from target address. Works with good branch prediction.

**d) Delayed Branch**

Always execute the instruction after the branch (in the delay slot). The compiler fills the delay slot with an independent or useful instruction.

```assembly
BNE  R1, R2, Target
ADD  R3, R4, R5       ; Delay slot: always executed
```

**e) Dynamic Branch Prediction** (most common in modern CPUs)

| Predictor | Description | Accuracy |
|-----------|-------------|----------|
| 1-bit | Flip on misprediction | ~70% |
| 2-bit saturating | Need 2 mispredictions to flip | ~85% |
| Correlating | Use global branch history | ~92% |
| Tournament | Meta-predictor selects best | ~96% |
| Perceptron | Neural-network based | ~97% |

---

## 5. Pipeline Performance

### Ideal Speedup

```
Speedup = Number of stages = Pipeline Depth

Example: 5-stage pipeline → up to 5x speedup (ideal)
```

### Real CPI

```
CPI_pipeline = 1 + stalls_per_instruction

Example:
  - 20% of instructions are loads
  - 50% of loads have a load-use hazard (1-cycle stall)
  - 10% of instructions are branches
  - 20% of branches are mispredicted (2-cycle penalty)

  CPI = 1 + (0.20 × 0.50 × 1) + (0.10 × 0.20 × 2)
      = 1 + 0.10 + 0.04
      = 1.14
```

### Throughput vs Latency

| Metric | Definition | Pipeline Effect |
|--------|-----------|----------------|
| **Latency** | Time for one instruction | Stays the same (or increases slightly) |
| **Throughput** | Instructions per unit time | Increases (approaches 1 IPC) |

```
Without pipeline:
  Latency = 5 cycles, Throughput = 1/5 = 0.2 inst/cycle

With 5-stage pipeline (ideal):
  Latency = 5 cycles, Throughput = 1/1 = 1.0 inst/cycle

Speedup = 5x throughput improvement
```

---

## 6. Advanced Pipelining Concepts

### Superscalar Execution

Multiple instructions issued per clock cycle.

```
Cycle 1: Issue I1, I2, I3, I4 (4-wide superscalar)
Cycle 2: Issue I5, I6, I7, I8
...
```

| Width | Instructions/Cycle | Hardware Complexity |
|-------|-------------------|---------------------|
| 2-wide | 2 | Moderate |
| 4-wide | 4 | High |
| 6-wide | 6 | Very High |
| 8-wide | 8 | Extreme (rare in practice) |

### VLIW (Very Long Instruction Word)

The compiler groups multiple operations into one very long instruction word.

- Simpler hardware (no dynamic scheduling)
- Relies heavily on compiler optimization
- Examples: Intel Itanium, TI DSPs

### Superpipelining

More pipeline stages than the classic 5, allowing higher clock rates.

| Pipeline Depth | Clock Rate | Example |
|---------------|------------|---------|
| 5 stages | ~1 GHz | Classic MIPS |
| 12 stages | ~2 GHz | Early Pentium |
| 20 stages | ~3 GHz | Pentium 4 (Netburst) |
| 14-19 stages | ~4-5 GHz | Modern Intel/AMD |

### Hazards of Deep Pipelines

- Higher branch misprediction penalty
- More pipeline registers (latency overhead)
- Greater complexity in forwarding logic
- Power consumption increases

---

## 7. Exception Handling in Pipelines

### Precise Exceptions

When an exception occurs, the pipeline must:

1. **Complete** all instructions before the excepting instruction
2. **Flush** the excepting instruction and all after it
3. **Save** the PC of the excepting instruction
4. **Transfer** to the exception handler

### Handling Mechanism

```
IF → ID → EX → MEM → WB
              │
              ▼ (Exception detected)
         Pipeline registers capture:
         - Exception type
         - Excepting instruction's PC
         - Pipeline state for rollback
```

### ROB-Based Precise Exceptions

In out-of-order processors, the Reorder Buffer ensures instructions commit in program order, making exception handling straightforward.

---

## 8. Pipeline Diagrams

### Example: 5 Instructions on a 5-Stage Pipeline

```assembly
I1: ADD  R1, R2, R3
I2: SUB  R4, R1, R5    ; RAW on R1 from I1
I3: AND  R6, R7, R8
I4: OR   R9, R1, R6    ; RAW on R1 from I1, RAW on R6 from I3
I5: XOR  R10, R11, R12
```

```
Cycle:      1    2    3    4    5    6    7    8
           ───  ───  ───  ───  ───  ───  ───  ───
I1 (ADD):  IF   ID   EX   MEM  WB
I2 (SUB):       IF   ID   EX   MEM  WB
I3 (AND):            IF   ID   EX   MEM  WB
I4 (OR):                  IF   ID   EX   MEM  WB
I5 (XOR):                       IF   ID   EX   MEM  WB
```

No stalls needed if forwarding is available.

### Example: Load-Use Hazard

```assembly
I1: LW   R1, 0(R2)
I2: ADD  R3, R1, R4     ; Uses R1 immediately
```

```
Cycle:      1    2    3    4    5    6
           ───  ───  ───  ───  ───  ───
I1 (LW):   IF   ID   EX   MEM  WB
I2 (ADD):       IF   ID   **   EX   MEM  WB
                            ↑
                      1-cycle stall (load-use)
```

---

## 9. Modern Pipeline Optimizations

### Instruction-Level Parallelism (ILP)

| Technique | Description |
|-----------|-------------|
| **Out-of-Order Execution** | Execute instructions when operands are ready, not in program order |
| **Speculative Execution** | Execute branch targets before branch is resolved |
| **Register Renaming** | Eliminate false dependencies (WAR, WAW) |
| **Loop Unrolling** | Reduce loop overhead, expose more ILP |
| **Trace Scheduling** | Optimize across basic blocks |

### Speculative Execution

```
Branch detected → Predict taken → Fetch from predicted target
                                   ↓
If prediction correct: continue (no penalty)
If prediction wrong: flush pipeline, fetch from correct path
```

### Register Renaming Example

```assembly
; Original (false dependency - WAW on R1):
ADD  R1, R2, R3
SUB  R5, R6, R7
ADD  R1, R8, R9    ; WAW on R1 with first ADD (false dependency)

; After renaming:
ADD  R1, R2, R3
SUB  R5, R6, R7
ADD  R12, R8, R9   ; R12 is a renamed version of R1
```

---

## Summary

| Concept | Key Point |
|---------|-----------|
| **Pipelining** | Overlap instruction execution for throughput |
| **5-Stage Pipeline** | IF → ID → EX → MEM → WB |
| **Structural Hazard** | Hardware resource conflict |
| **Data Hazard (RAW)** | True dependency; solved by forwarding |
| **Load-Use Hazard** | Requires 1-cycle stall even with forwarding |
| **Control Hazard** | Branch misprediction; solved by prediction |
| **Superscalar** | Multiple instructions per cycle |
| **Deep Pipeline** | Higher clock rate, higher misprediction penalty |
| **Precise Exceptions** | Must be maintained for correct exception handling |

> **Key Insight**: Pipelining doesn't reduce the time to execute a single instruction. It increases **throughput** by having multiple instructions in various stages simultaneously. The goal is to complete one instruction per clock cycle (CPI = 1).
