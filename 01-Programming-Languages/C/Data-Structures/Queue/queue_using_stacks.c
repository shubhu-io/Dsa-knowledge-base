/*
Problem: Queue Using Stacks
Implement a queue using two stacks.

Approach:
- Use two stacks to simulate FIFO: push to in-stack, pop/peek from out-stack

Time Complexity: O(1) amortized per operation
Space Complexity: O(n)

Example:
enqueue(1), enqueue(2), dequeue() -> 1, enqueue(3), dequeue() -> 2
*/

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define MAX 100

typedef struct
{
    int data[MAX];
    int top;
} Stack;

void push(Stack *s, int val)
{
    s->data[++s->top] = val;
}

int pop(Stack *s)
{
    return s->data[s->top--];
}

bool is_empty(Stack *s)
{
    return s->top == -1;
}

typedef struct
{
    Stack in;
    Stack out;
} Queue;

void enqueue(Queue *q, int val)
{
    push(&q->in, val);
}

int dequeue(Queue *q)
{
    if (is_empty(&q->out))
        while (!is_empty(&q->in))
            push(&q->out, pop(&q->in));
    return pop(&q->out);
}

int main()
{
    Queue q = {.in.top = -1, .out.top = -1};
    enqueue(&q, 1);
    enqueue(&q, 2);
    printf("Dequeue: %d\n", dequeue(&q));
    enqueue(&q, 3);
    printf("Dequeue: %d\n", dequeue(&q));
    printf("Dequeue: %d\n", dequeue(&q));
    return 0;
}
