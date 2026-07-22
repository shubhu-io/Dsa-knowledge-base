/*
Problem: Merge Sort
Description: Sort an array using the divide-and-conquer merge sort algorithm.
Recursively split the array into halves, sort each half, then merge them.

Approach:
- Divide array into two halves recursively until single elements
- Merge sorted halves by comparing elements and combining in order

Time Complexity: O(n log n)
Space Complexity: O(n)

Example:
Input: [38, 27, 43, 3, 9, 82, 10]
Output: [3, 9, 10, 27, 38, 43, 82]
*/

function mergeSort(arr) {
  if (arr.length <= 1) return arr;
  const mid = Math.floor(arr.length / 2);
  const left = mergeSort(arr.slice(0, mid));
  const right = mergeSort(arr.slice(mid));
  return merge(left, right);
}

function merge(left, right) {
  const result = [];
  let i = 0, j = 0;
  while (i < left.length && j < right.length) {
    if (left[i] <= right[j]) result.push(left[i++]);
    else result.push(right[j++]);
  }
  return result.concat(left.slice(i)).concat(right.slice(j));
}

const arr = [38, 27, 43, 3, 9, 82, 10];
console.log('Input:', arr);
console.log('Output:', mergeSort(arr));
