func twoSum(_ nums: [Int], target: Int) -> (Int, Int)? {
    var numDict: [Int: Int] = [:]
    
    for (i, num) in nums.enumerated() {
        let complement = target - num
        if let index = numDict[complement] {
            return (index, i)
        }
        numDict[num] = i
    }
    
    return nil
}

let nums = [2, 7, 11, 15]
let target = 9

if let (i, j) = twoSum(nums, target: target) {
    print("Indices: (\(i), \(j))")
} else {
    print("No solution found")
}