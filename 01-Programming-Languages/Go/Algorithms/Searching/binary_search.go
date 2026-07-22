package main

import "fmt"

func binarySearch(arr []int, target int) int {
    left, right := 0, len(arr)-1

    for left <= right {
        mid := left + (right-left)/2

        if arr[mid] == target {
            return mid
        } else if arr[mid] < target {
            left = mid + 1
        } else {
            right = mid - 1
        }
    }

    return -1
}

func main() {
    arr := []int{2, 3, 4, 10, 40}
    target := 10
    result := binarySearch(arr, target)
    
    if result == -1 {
        fmt.Println("Element not found")
    } else {
        fmt.Printf("Element found at index %d\n", result)
    }
}