/*
Problem: Kth Largest Element in a Stream
Description: Find kth largest element using a min-heap of size k.

Approach:
- Maintain min-heap of size k; root is the kth largest

Time Complexity: O(n log k)
Space Complexity: O(k)

Example:
Input: stream = [4,5,8,2], k = 3, add(3), add(5), add(10), add(9), add(4)
Output: 4, 5, 5, 8, 8
*/

class MinHeap {
  private heap: number[] = [];

  size(): number { return this.heap.length; }

  peek(): number { return this.heap[0]; }

  push(val: number): void {
    this.heap.push(val);
    this._bubbleUp(this.heap.length - 1);
  }

  pop(): number {
    const top = this.heap[0];
    const bottom = this.heap.pop()!;
    if (this.heap.length > 0) {
      this.heap[0] = bottom;
      this._sinkDown(0);
    }
    return top;
  }

  private _bubbleUp(idx: number): void {
    while (idx > 0) {
      const parent = Math.floor((idx - 1) / 2);
      if (this.heap[parent] <= this.heap[idx]) break;
      [this.heap[parent], this.heap[idx]] = [this.heap[idx], this.heap[parent]];
      idx = parent;
    }
  }

  private _sinkDown(idx: number): void {
    const length = this.heap.length;
    while (true) {
      let smallest = idx;
      const left = 2 * idx + 1;
      const right = 2 * idx + 2;
      if (left < length && this.heap[left] < this.heap[smallest]) smallest = left;
      if (right < length && this.heap[right] < this.heap[smallest]) smallest = right;
      if (smallest === idx) break;
      [this.heap[idx], this.heap[smallest]] = [this.heap[smallest], this.heap[idx]];
      idx = smallest;
    }
  }
}

class KthLargest {
  private k: number;
  private heap: MinHeap;

  constructor(k: number, nums: number[]) {
    this.k = k;
    this.heap = new MinHeap();
    for (const num of nums) this.add(num);
  }

  add(val: number): number {
    this.heap.push(val);
    if (this.heap.size() > this.k) this.heap.pop();
    return this.heap.peek();
  }
}

const kth = new KthLargest(3, [4, 5, 8, 2]);
console.log('add(3):', kth.add(3));
console.log('add(5):', kth.add(5));
console.log('add(10):', kth.add(10));
console.log('add(9):', kth.add(9));
console.log('add(4):', kth.add(4));
