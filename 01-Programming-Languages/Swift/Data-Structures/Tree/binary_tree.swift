class TreeNode {
    var value: Int
    var left: TreeNode?
    var right: TreeNode?
    
    init(value: Int) {
        self.value = value
        self.left = nil
        self.right = nil
    }
}

class BinaryTree {
    var root: TreeNode?
    
    func insert(_ value: Int) {
        let newNode = TreeNode(value: value)
        
        guard let root = root else {
            self.root = newNode
            return
        }
        
        var current = root
        while true {
            if value < current.value {
                if let left = current.left {
                    current = left
                } else {
                    current.left = newNode
                    return
                }
            } else if value > current.value {
                if let right = current.right {
                    current = right
                } else {
                    current.right = newNode
                    return
                }
            } else {
                return // Duplicate
            }
        }
    }
    
    func inorder(_ node: TreeNode? = nil) {
        let currentNode = node ?? root
        guard let node = currentNode else { return }
        
        inorder(node.left)
        print("\(node.value) ", terminator: "")
        inorder(node.right)
    }
    
    func search(_ value: Int) -> Bool {
        var current = root
        while let node = current {
            if value == node.value { return true }
            current = value < node.value ? node.left : node.right
        }
        return false
    }
}

let tree = BinaryTree()
[50, 30, 70, 20, 40, 60, 80].forEach { tree.insert($0) }

print("Inorder: ", terminator: "")
tree.inorder()
print()

print("Search 40:", tree.search(40))
print("Search 90:", tree.search(90))