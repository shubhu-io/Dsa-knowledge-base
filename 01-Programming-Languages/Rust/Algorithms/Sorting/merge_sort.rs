fn merge_sort(arr: &mut [i32]) {
    let len = arr.len();
    if len <= 1 {
        return;
    }

    let mid = len / 2;
    merge_sort(&mut arr[..mid]);
    merge_sort(&mut arr[mid..]);

    let mut temp = Vec::with_capacity(len);
    let (mut i, mut j) = (0, mid);

    while i < mid && j < len {
        if arr[i] <= arr[j] {
            temp.push(arr[i]);
            i += 1;
        } else {
            temp.push(arr[j]);
            j += 1;
        }
    }

    temp.extend_from_slice(&arr[i..mid]);
    temp.extend_from_slice(&arr[j..len]);
    arr.copy_from_slice(&temp);
}

fn main() {
    let mut arr = vec![38, 27, 43, 3, 9, 82, 10];
    println!("Original: {:?}", arr);
    merge_sort(&mut arr);
    println!("Sorted: {:?}", arr);
}