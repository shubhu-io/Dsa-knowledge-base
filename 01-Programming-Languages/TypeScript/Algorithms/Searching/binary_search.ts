function binarySearch(arr: number[], target: number): number {
    let left = 0;
    let right = arr.length - 1;

    while (left <= right) {
        const mid = Math.floor((left + right) / 2);

        if (arr[mid] === target) {
            return mid;
        } else if (arr[mid] < target) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }

    return -1;
}

const arr = [2, 3, 4, 10, 40];
const target = 10;
const result = binarySearch(arr, target);

if (result === -1) {
    console.log("Element not found");
} else {
    console.log(`Element found at index ${result}`);
}