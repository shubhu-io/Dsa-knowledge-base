fn binary_search(arr: &[i32], target: i32) -> Option<usize> {
    let mut left = 0;
    let mut right = arr.len();

    while left < right {
        let mid = left + (right - left) / 2;

        if arr[mid] == target {
            return Some(mid);
        } else if arr[mid] < target {
            left = mid + 1;
        } else {
            right = mid;
        }
    }

    None
}

fn main() {
    let arr = vec![2, 3, 4, 10, 40];
    let target = 10;

    match binary_search(&arr, target) {
        Some(index) => println!("Element found at index {}", index),
        None => println!("Element not found"),
    }
}