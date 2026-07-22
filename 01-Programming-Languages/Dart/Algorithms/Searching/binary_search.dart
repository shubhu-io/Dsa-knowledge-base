int binarySearch(List<int> arr, int target) {
  var left = 0;
  var right = arr.length - 1;

  while (left <= right) {
    final mid = left + (right - left) ~/ 2;

    if (arr[mid] == target) {
      return mid;
    } else if (arr[mid] < target) {
      left = mid + 1;
    } else {
      right = mid - 1;
    }
  }

  return -1;
}

void main() {
  final arr = [2, 3, 4, 10, 40];
  final target = 10;
  final result = binarySearch(arr, target);

  if (result == -1) {
    print('Element not found');
  } else {
    print('Element found at index $result');
  }
}