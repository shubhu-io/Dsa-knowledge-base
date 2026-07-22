# Operating System Interview Questions

## Top Interview Questions

### Process Management

**Q: What is the difference between process and thread?**
A: Process is a program in execution with its own memory space. Thread is a lightweight process within a process that shares memory with other threads.

**Q: Explain process states.**
A: New → Ready → Running → Waiting → Terminated. Ready: waiting for CPU. Waiting: waiting for I/O.

**Q: What is context switching?**
A: Saving the state of current process and restoring the state of next process when CPU switches tasks.

### Memory Management

**Q: What is virtual memory?**
A: Technique that gives programs impression of having contiguous memory, even if physically fragmented. Uses paging/segmentation.

**Q: What is paging?**
A: Dividing memory into fixed-size blocks (pages). Virtual pages map to physical frames via page table.

**Q: What is thrashing?**
A: When system spends more time swapping pages than executing. Caused by insufficient memory for working set.

### Scheduling

**Q: Compare scheduling algorithms.**
A:
- FCFS: Simple, can cause convoy effect
- SJF: Optimal average waiting time, starvation possible
- Round Robin: Fair, context switch overhead
- Priority: Can cause starvation

### Deadlock

**Q: What are deadlock conditions?**
A:
1. Mutual Exclusion: Resource can't be shared
2. Hold and Wait: Holding while waiting
3. No Preemption: Can't force release
4. Circular Wait: Circular chain of waits

**Q: How to prevent deadlock?**
A: Break one of the four conditions:
- Use sharable resources
- Request all resources at once
- Allow preemption
- Order resource acquisition

### File Systems

**Q: What is the difference between hard and soft links?**
A: Hard link points to inode (same as original). Soft link is a separate file pointing to path. Hard link survives deletion, soft link doesn't.

### Linux

**Q: What is a zombie process?**
A: Process that has completed execution but still has entry in process table. Parent must call wait() to clean up.

**Q: What is the difference between kill -9 and kill -15?**
A: -9 (SIGKILL) forcefully terminates. -15 (SIGTERM) graceful termination, allows cleanup.

## Coding Questions

**Q: Implement a simple shell.**
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
    char command[100];
    
    while (1) {
        printf("$ ");
        fgets(command, 100, stdin);
        command[strcspn(command, "\n")] = 0;
        
        if (fork() == 0) {
            execlp(command, command, NULL);
            exit(1);
        } else {
            wait(NULL);
        }
    }
    return 0;
}
```

**Q: Implement producer-consumer problem.**
```python
import threading
import queue

buffer = queue.Queue(10)
empty = threading.Semaphore(10)
full = threading.Semaphore(0)

def producer():
    for i in range(20):
        empty.acquire()
        buffer.put(i)
        full.release()
        print(f"Produced: {i}")

def consumer():
    for i in range(20):
        full.acquire()
        item = buffer.get()
        empty.release()
        print(f"Consumed: {item}")

t1 = threading.Thread(target=producer)
t2 = threading.Thread(target=consumer)
t1.start()
t2.start()
```

## Resources

- Operating System Concepts (Dinosaur Book)
- Modern Operating Systems (Tanenbaum)
- Linux Kernel Development