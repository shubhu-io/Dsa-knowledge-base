func binarySearch(_ arr: [Int], target: Int) -> Int? {
    var left = 0
    var right = arr.count - 1
    
    while left <= right {
        let mid = left + (right - left) / 2
        
        if arr[mid] == target {
            return mid
        } else if arr[mid] < target {
            left = mid + 1
        } else {
            right = mid - 1
        }
    }
    
    return nil
}

let arr = [2, 3, 4, 10, 40]
let target = 10

if let index = binarySearch(arr, target: target) {
    print("Element found at index \(index)")
} else {
    print("Element not found")
}