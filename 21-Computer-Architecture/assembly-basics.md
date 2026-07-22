# Assembly Language Basics

This document introduces assembly language concepts, focusing on x86-64 architecture.

## What is Assembly Language?

Assembly language is a low-level programming language that provides a direct correspondence between human-readable mnemonics and machine code instructions. Each assembly instruction maps to a specific machine code instruction.

## x86-64 Architecture Overview

### Registers
The x86-64 architecture provides several types of registers:

**General-Purpose Registers (64-bit):**
- `RAX` - Accumulator (return values)
- `RBX` - Base pointer
- `RCX` - Counter (loop operations)
- `RDX` - Data register
- `RSI` - Source index (string operations)
- `RDI` - Destination index (string operations)
- `RBP` - Base pointer (stack frame)
- `RSP` - Stack pointer
- `R8`-`R15` - Additional general-purpose registers

**Lower 32-bit portions:** `EAX`, `EBX`, `ECX`, `EDX`, etc.
**Lower 16-bit portions:** `AX`, `BX`, `CX`, `DX`, etc.
**8-bit portions:** `AL`, `AH`, `BL`, `BH`, `CL`, `CH`, `DL`, `DH`

### Memory Addressing
x86-64 supports various addressing modes:
```
[RIP]           - Direct RIP-relative
[RAX]           - Register indirect
[RAX + 8]       - Register + displacement
[RAX + RBX*2]   - Scaled index
[RAX + RCX*4 + 16] - Complex addressing
```

## Basic Instructions

### Data Movement
```assembly
mov rax, 5        ; Move immediate value 5 to RAX
mov rbx, rax      ; Copy RAX to RBX
mov [rcx], rax    ; Store RAX at memory address in RCX
mov rdx, [rsi]    ; Load from memory address in RSI to RDX
lea rax, [rbx+8]  ; Load effective address
```

### Arithmetic Operations
```assembly
add rax, rbx      ; RAX = RAX + RBX
sub rax, 3        ; RAX = RAX - 3
imul rax, rbx     ; Signed multiply RAX by RBX
div rbx           ; Unsigned divide RAX by RBX
inc rax           ; Increment RAX by 1
dec rax           ; Decrement RAX by 1
neg rax           ; Negate RAX (two's complement)
```

### Logical Operations
```assembly
and rax, rbx      ; Bitwise AND
or rax, rbx       ; Bitwise OR
xor rax, rbx      ; Bitwise XOR
not rax           ; Bitwise NOT
shl rax, 2        ; Shift left by 2 bits
shr rax, 1        ; Shift right by 1 bit
sar rax, 1        ; Arithmetic right shift
```

### Control Flow
```assembly
jmp label         ; Unconditional jump
je label          ; Jump if equal (ZF=1)
jne label         ; Jump if not equal (ZF=0)
jg label          ; Jump if greater
jl label          ; Jump if less
jge label         ; Jump if greater or equal
jle label         ; Jump if less or equal
call function     ; Call function
ret               ; Return from function
```

## Stack Operations

### Stack Basics
The stack grows downward (from high to low addresses). `RSP` points to the top of the stack.

```assembly
push rax          ; Push RAX onto stack, RSP -= 8
pop rbx           ; Pop from stack to RBX, RSP += 8
```

### Stack Frame
Functions typically set up a stack frame:
```assembly
push rbp          ; Save old base pointer
mov rbp, rsp      ; Set up new base pointer
sub rsp, 16       ; Allocate space for local variables
; ... function body ...
mov rsp, rbp      ; Restore stack pointer
pop rbp           ; Restore base pointer
ret               ; Return
```

## Functions and Calling Conventions

### System V AMD64 ABI (Linux/macOS)
- Arguments passed in: `RDI`, `RSI`, `RDX`, `RCX`, `R8`, `R9`
- Additional arguments on stack
- Return value in `RAX`
- Caller-saved: `RAX`, `RCX`, `RDX`, `RSI`, `RDI`, `R8`-`R11`
- Callee-saved: `RBX`, `RBP`, `R12`-`R15`

### Example Function
```assembly
; int add(int a, int b)
add_numbers:
    push rbp
    mov rbp, rsp
    mov eax, edi      ; First argument (a)
    add eax, esi      ; Add second argument (b)
    pop rbp
    ret
```

## Assembly Program Structure

### Using NASM Syntax
```assembly
section .data
    msg db 'Hello, World!', 0x0a  ; String with newline
    len equ $ - msg               ; Length of string

section .text
    global _start

_start:
    ; Write system call
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, msg        ; message
    mov rdx, len        ; length
    syscall

    ; Exit system call
    mov rax, 60         ; sys_exit
    xor rdi, rdi        ; exit code 0
    syscall
```

### Compiling and Running
```bash
# Assemble
nasm -f elf64 program.asm

# Link
ld -o program program.o

# Run
./program
```

## Common Patterns

### Loop Example
```assembly
; Sum numbers from 1 to N
sum_loop:
    xor rax, rax      ; Initialize sum = 0
    mov rcx, 1        ; Start from 1
.loop:
    add rax, rcx      ; Add current number
    inc rcx           ; Next number
    cmp rcx, rdi      ; Compare with N
    jle .loop         ; Continue if <= N
    ret
```

### Conditional Example
```assembly
; int max(int a, int b)
max:
    mov eax, edi      ; a
    cmp edi, esi      ; Compare a and b
    jge .done         ; If a >= b, skip
    mov eax, esi      ; Otherwise use b
.done:
    ret
```

## Debugging Assembly

### Using GDB
```bash
# Compile with debug info
nasm -f elf64 -g program.asm
ld -o program program.o

# Debug
gdb ./program
(gdb) break _start
(gdb) run
(gdb) stepi
(gdb) info registers
(gdb) x/10x $rsp
```

## See Also

- [[cpu-memory-hierarchy]]
- [[pipelining]]
- [[architecture-guide]]
- [[architecture-interview-questions]]
