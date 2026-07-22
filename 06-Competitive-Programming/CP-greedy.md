# Competitive Programming Greedy Algorithms

## Greedy Algorithms for Competitive Programming

This document covers fundamental greedy algorithms, their correctness proofs, and applications in competitive programming problems.

---

## Table of Contents
1. [Greedy Algorithm Principles](#greedy-algorithm-principles)
2. [Classic Greedy Problems](#classic-greedy-problems)
3. [Greedy on Arrays](#greedy-on-arrays)
4. [Greedy on Strings](#greedy-on-strings)
5. [Greedy on Graphs](#greedy-on-graphs)
6. [Greedy with Scheduling](#greedy-with-scheduling)
7. [Greedy with Trees](#greedy-with-trees)
8. [Advanced Greedy Techniques](#advanced-greedy-techniques)
9. [When Greedy Fails](#when-greedy-fails)
10. [Greedy vs Dynamic Programming](#greedy-vs-dynamic-programming)

---

## Greedy Algorithm Principles

### What is a Greedy Algorithm?
A greedy algorithm builds up a solution piece by piece, always choosing the next piece that offers the most immediate benefit. It makes locally optimal choices at each step with the hope of finding a global optimum.

### Key Characteristics
1. **Greedy Choice Property**: A globally optimal solution can be arrived at by making a locally optimal (greedy) choice.
2. **Optimal Substructure**: An optimal solution to the problem contains optimal solutions to its subproblems.

### When to Use Greedy
- When the problem exhibits both greedy choice property and optimal substructure
- When we need to optimize some value (maximize or minimize)
- When making a choice doesn't affect the feasibility of future choices (or affects it in a predictable way)
- When we can prove that the greedy choice leads to an optimal solution

### Steps to Develop a Greedy Algorithm
1. **Understand the problem**: Identify what needs to be optimized
2. **Make a greedy choice**: Determine what constitutes the "best" choice at each step
3. **Prove greedy choice property**: Show that making this choice doesn't prevent reaching an optimal solution
4. **Prove optimal substructure**: Show that after making the greedy choice, the remaining subproblem has optimal substructure
5. **Implement**: Code the algorithm based on the greedy choice
6. **Test**: Verify with examples and edge cases

### Common Greedy Strategies
1. **Always pick the largest/smallest available**
2. **Sort and process in order**
3. **Use priority queues to always access the best option**
4. **Maintain invariants** that ensure optimality
5. **Exchange arguments**: Show that any optimal solution can be transformed to include our greedy choice

---

## Classic Greedy Problems

### 1. Activity Selection Problem
**Problem**: Given n activities with their start and finish times, select the maximum number of activities that can be performed by a single person, assuming that a person can only work on a single activity at a time.

**Solution**:
```cpp
struct Activity {
    int start, finish;
};

int activity_selection(vector<Activity>& activities) {
    // Sort activities by finish time
    sort(activities.begin(), activities.end(), 
         [](const Activity& a, const Activity& b) {
             return a.finish < b.finish;
         });
    
    int count = 0;
    int last_end_time = 0;
    
    for (const Activity& act : activities) {
        if (act.start >= last_end_time) {
            count++;
            last_end_time = act.finish;
        }
    }
    return count;
}
```

**Proof of Correctness**:
- **Greedy Choice**: Choosing the activity that finishes first leaves the most time for remaining activities
- **Optimal Substructure**: After selecting the first activity, the problem reduces to selecting activities that start after it finishes

### 2. Fractional Knapsack Problem
**Problem**: Given weights and values of n items, put these items in a knapsack of capacity W to get the maximum total value in the knapsack. Unlike 0/1 knapsack, we can break items for maximizing the total value.

**Solution**:
```cpp
struct Item {
    int value, weight;
    double ratio;
    
    Item(int v, int w) : value(v), weight(w), ratio((double)v/w) {}
};

double fractional_knapsack(vector<Item>& items, int capacity) {
    // Sort items by value/weight ratio in descending order
    sort(items.begin(), items.end(), 
         [](const Item& a, const Item& b) {
             return a.ratio > b.ratio;
         });
    
    double total_value = 0;
    int current_weight = 0;
    
    for (Item item : items) {
        if (current_weight + item.weight <= capacity) {
            // Take whole item
            total_value += item.value;
            current_weight += item.weight;
        } else {
            // Take fraction of item
            int remaining = capacity - current_weight;
            total_value += item.ratio * remaining;
            break; // Knapsack full
        }
    }
    return total_value;
}
```

**Proof of Correctness**:
- **Greedy Choice**: Items with higher value/weight ratio contribute more value per unit weight
- **Optimal Substructure**: After taking some amount of the best item, the problem reduces to filling the remaining capacity

### 3. Huffman Coding
**Problem**: Given a set of characters and their frequencies, construct an optimal prefix code (Huffman code) for them.

**Solution**:
```cpp
struct HuffmanNode {
    char ch;
    int freq;
    HuffmanNode* left;
    HuffmanNode* right;
    
    HuffmanNode(char c, int f) : ch(c), freq(f), left(nullptr), right(nullptr) {}
    HuffmanNode(int f) : ch('\0'), freq(f), left(nullptr), right(nullptr) {}
    
    bool operator<(const HuffmanNode& other) const {
        return freq > other.freq; // Min-heap based on frequency
    }
};

string build_huffman_tree(string text) {
    // Count frequencies
    unordered_map<char, int> freq;
    for (char c : text) freq[c]++;
    
    // Build priority queue (min-heap)
    priority_queue<HuffmanNode*> pq;
    for (auto p : freq) {
        pq.push(new HuffmanNode(p.first, p.second));
    }
    
    // Build tree
    while (pq.size() > 1) {
        HuffmanNode* left = pq.top(); pq.pop();
        HuffmanNode* right = pq.top(); pq.pop();
        HuffmanNode* merged = new HuffmanNode(left->freq + right->freq);
        merged->left = left;
        merged->right = right;
        pq.push(merged);
    }
    
    // Generate codes
    unordered_map<char, string> codes;
    function<void(HuffmanNode*, string)> generate_codes = [&](HuffmanNode* node, string code) {
        if (!node) return;
        if (!node->left && !node->right) { // Leaf node
            codes[node->ch] = code;
            return;
        }
        generate_codes(node->left, code + "0");
        generate_codes(node->right, code + "1");
    };
    
    HuffmanNode* root = pq.top();
    generate_codes(root, "");
    
    // Encode text
    string encoded = "";
    for (char c : text) {
        encoded += codes[c];
    }
    return encoded;
}
```

**Proof of Correctness**:
- **Greedy Choice**: The two least frequent characters will be siblings in the optimal tree
- **Optimal Substructure**: After merging two least frequent nodes, the problem reduces to finding optimal tree for the new set

### 4. Job Sequencing with Deadlines
**Problem**: Given a set of jobs with deadlines and profits, schedule jobs to maximize profit where each job takes 1 unit of time and only one job can be scheduled at a time.

**Solution**:
```cpp
struct Job {
    char id;
    int deadline, profit;
};

int job_sequencing(vector<Job>& jobs) {
    // Sort jobs by decreasing profit
    sort(jobs.begin(), jobs.end(), 
         [](const Job& a, const Job& b) {
             return a.profit > b.profit;
         });
    
    // Find maximum deadline to create slots
    int max_deadline = 0;
    for (const Job& job : jobs) {
        max_deadline = max(max_deadline, job.deadline);
    }
    
    vector<bool> slot(max_deadline + 1, false);
    int total_profit = 0;
    
    for (const Job& job : jobs) {
        // Find a free slot for this job (starting from latest possible)
        for (int j = min(job.deadline, max_deadline); j > 0; j--) {
            if (!slot[j]) {
                slot[j] = true;
                total_profit += job.profit;
                break;
            }
        }
    }
    return total_profit;
}
```

**Proof of Correctness**:
- **Greedy Choice**: Selecting the highest profit job that can still be scheduled is optimal
- **Optimal Substructure**: After scheduling a job, the problem reduces to scheduling remaining jobs in available slots

### 5. Minimum Number of Platforms Required
**Problem**: Given arrival and departure times of trains, find the minimum number of platforms required so that no train waits.

**Solution**:
```cpp
int find_platforms(vector<int>& arr, vector<int>& dep) {
    sort(arr.begin(), arr.end());
    sort(dep.begin(), dep.end());
    
    int platforms_needed = 1;
    int max_platforms = 1;
    int i = 1, j = 0;
    
    while (i < arr.size() && j < dep.size()) {
        if (arr[i] <= dep[j]) {
            // Need a new platform
            platforms_needed++;
            i++;
            if (platforms_needed > max_platforms) {
                max_platforms = platforms_needed;
            }
        } else {
            // A platform is freed
            platforms_needed--;
            j++;
        }
    }
    return max_platforms;
}
```

**Proof of Correctness**:
- **Greedy Choice**: We process events in chronological order, counting how many trains are present at each time
- **Optimal Substructure**: The minimum platforms needed up to any time depends only on the schedule up to that time

---

## Greedy on Arrays

### 1. Minimum Number of Coins (Greedy Coin Change)
**Problem**: Given coin denominations, find the minimum number of coins needed to make a given value. (Note: This only works for canonical coin systems like US coins)

**Solution**:
```cpp
int min_coins_greedy(vector<int>& coins, int value) {
    sort(coins.rbegin(), coins.rend()); // Sort in descending order
    int count = 0;
    
    for (int coin : coins) {
        if (value >= coin) {
            int num_coins = value / coin;
            count += num_coins;
            value -= num_coins * coin;
        }
    }
    
    return (value == 0) ? count : -1; // Return -1 if not possible
}
```

**Note**: This only works for canonical coin systems. For arbitrary denominations, dynamic programming is needed.

### 2. Minimum Platforms Required (Already covered above)

### 3. Maximum Products of Two Arrays
**Problem**: Given two arrays, find the maximum sum of products of their elements.

**Solution** (Rearrangement Inequality):
```cpp
long long max_scalar_product(vector<int>& a, vector<int>& b) {
    sort(a.begin(), a.end());
    sort(b.begin(), b.end());
    
    long long result = 0;
    for (int i = 0; i < a.size(); i++) {
        result += (long long)a[i] * b[i];
    }
    return result;
}
```

**Proof**: By rearrangement inequality, the sum of products is maximized when both sequences are sorted in the same order.

### 4. Minimum Number of Arrows to Burst Balloons
**Problem**: Given balloons with horizontal diameters, find the minimum number of arrows needed to burst all balloons.

**Solution**:
```cpp
int find_min_arrow_shots(vector<vector<int>>& points) {
    if (points.empty()) return 0;
    
    // Sort by end coordinate
    sort(points.begin(), points.end(), 
         [](const vector<int>& a, const vector<int>& b) {
             return a[1] < b[1];
         });
    
    int arrows = 1;
    int end = points[0][1];
    
    for (int i = 1; i < points.size(); i++) {
        if (points[i][0] > end) {
            // Need new arrow
            arrows++;
            end = points[i][1];
        }
        // Else, current arrow can burst this balloon too
    }
    return arrows;
}
```

**Proof of Correctness**:
- **Greedy Choice**: Shooting at the end of the first balloon bursts it and maximizes the chance to burst overlapping balloons
- **Optimal Substructure**: After handling balloons burst by first arrow, the problem reduces to remaining balloons

### 5. Concatenation of Consecutive Binary Numbers
**Problem**: Given n, return the decimal value of the binary string formed by concatenating the binary representations of 1 to n.

**Solution** (Not strictly greedy, but uses similar insight):
```cpp
int concatenatedBinary(int n) {
    const int MOD = 1e9 + 7;
    long long result = 0;
    int length = 0;
    
    for (int i = 1; i <= n; i++) {
        // Check if i is power of 2 (adds a new bit)
        if ((i & (i - 1)) == 0) {
            length++;
        }
        // Shift left by length bits and add i
        result = ((result << length) % MOD + i) % MOD;
    }
    return (int)result;
}
```

### 6. Partition Labels
**Problem**: Partition string into as many parts as possible so that each letter appears in at most one part.

**Solution** (Greedy):
```cpp
vector<int> partitionLabels(string s) {
    vector<int> last(26, 0);
    for (int i = 0; i < s.size(); i++) {
        last[s[i] - 'a'] = i;
    }
    
    vector<int> result;
    int start = 0;
    int end = 0;
    
    for (int i = 0; i < s.size(); i++) {
        end = max(end, last[s[i] - 'a']);
        if (i == end) {
            result.push_back(end - start + 1);
            start = i + 1;
        }
    }
    return result;
}
```

**Proof of Correctness**:
- **Greedy Choice**: Extend current partition as far as needed to include all occurrences of characters seen so far
- **Optimal Substructure**: After making a cut, the problem reduces to partitioning the remainder of the string

---

## Greedy on Strings

### 1. Remove Duplicate Letters
**Problem**: Given a string s, remove duplicate letters so that every letter appears once and only once. You must make sure your result is the smallest in lexicographical order among all possible results.

**Solution**:
```cpp
string removeDuplicateLetters(string s) {
    vector<int> count(26, 0);
    vector<bool> in_result(26, false);
    string result;
    
    // Count frequency of each character
    for (char c : s) {
        count[c - 'a']++;
    }
    
    for (char c : s) {
        count[c - 'a']--;
        
        if (in_result[c - 'a']) continue;
        
        // While last character in result is greater than c 
        // and it appears later in the string, remove it
        while (!result.empty() && result.back() > c && 
               count[result.back() - 'a'] > 0) {
            in_result[result.back() - 'a'] = false;
            result.pop_back();
        }
        
        result.push_back(c);
        in_result[c - 'a'] = true;
    }
    return result;
}
```

**Proof of Correctness**:
- **Greedy Choice**: At each step, choose the smallest possible character that can lead to a valid solution
- **Optimal Substructure**: After choosing a character, the problem reduces to processing the remainder of the string

### 2. Smallest Subsequence of Distinct Characters
**Problem**: Return the lexicographically smallest subsequence of s that contains all the distinct characters of s exactly once.

**Solution** (Same as Remove Duplicate Letters):
```cpp
string smallestSubsequence(string s) {
    return removeDuplicateLetters(s); // Same algorithm
}
```

### 3. Minimum Add to Make Parentheses Valid
**Problem**: Given a string s of '(' and ')', return the minimum number of parentheses we must add to make the resulting string valid.

**Solution**:
```cpp
int minAddToMakeValid(string s) {
    int open = 0; // Number of open parentheses needed
    int close = 0; // Number of close parentheses needed
    
    for (char c : s) {
        if (c == '(') {
            open++;
        } else { // c == ')'
            if (open > 0) {
                open++; // Match with existing open
            } else {
                close++; // Need to add open parenthesis
            }
        }
    }
    return open + close;
}
```

**Alternative Solution** (using balance):
```cpp
int minAddToMakeValid(string s) {
    int balance = 0; // Open minus close
    int ans = 0;
    
    for (char c : s) {
        if (c == '(') {
            balance++;
        } else { // c == ')'
            balance--;
            if (balance < 0) { // Too many closing parentheses
                ans++; // Need to add an opening parenthesis
                balance = 0; // Reset balance
            }
        }
    }
    return ans + balance; // Remaining balance needs closing parentheses
}
```

**Proof of Correctness**:
- **Greedy Choice**: Match closing parentheses with the most recent unmatched opening parenthesis
- **Optimal Substructure**: After processing each character, the problem reduces to the remainder of the string

### 4. Minimum Window Substring (Greedy Aspect)
**Problem**: Given two strings s and t, return the minimum window in s which will contain all the characters in t.

**Note**: While the full solution uses sliding window, it has greedy aspects in expanding and contracting the window.

```cpp
string minWindow(string s, string t) {
    if (s.empty() || t.empty()) return "";
    
    unordered_map<char, int> tCount;
    for (char c : t) tCount[c]++;
    
    int required = tCount.size();
    int formed = 0;
    unordered_map<char, int> windowCount;
    
    int left = 0, right = 0;
    int min_len = INT_MAX;
    int min_left = 0;
    
    while (right < s.size()) {
        char c = s[right];
        windowCount[c]++;
        
        if (tCount.find(c) != tCount.end() && windowCount[c] == tCount[c]) {
            formed++;
        }
        
        // Try to contract the window till it ceases to be 'desirable'
        while (left <= right && formed == required) {
            c = s[left];
            
            if (right - left + 1 < min_len) {
                min_len = right - left + 1;
                min_left = left;
            }
            
            windowCount[c]--;
            if (tCount.find(c) != tCount.end() && windowCount[c] < tCount[c]) {
                formed--;
            }
            left++;
        }
        
        right++;
    }
    
    return min_len == INT_MAX ? "" : s.substr(min_left, min_len);
}
```

### 5. Reorganize String
**Problem**: Given a string s, rearrange the characters so that no two adjacent characters are the same.

**Solution**:
```cpp
string reorganizeString(string s) {
    // Count frequencies
    unordered_map<char, int> freq;
    for (char c : s) freq[c]++;
    
    // Max heap by frequency
    auto cmp = [](const pair<char, int>& a, const pair<char, int>& b) {
        return a.second < b.second;
    };
    priority_queue<pair<char, int>, vector<pair<char, int>>, decltype(cmp)> pq(cmp);
    
    for (auto p : freq) {
        pq.push(p);
    }
    
    string result = "";
    pair<char, int> prev = {'#', 0}; // Previous character
    
    while (!pq.empty()) {
        pair<char, int> curr = pq.top();
        pq.pop();
        
        result += curr.first;
        curr.second--;
        
        // If previous character still has remaining count, push it back
        if (prev.second > 0) {
            pq.push(prev);
        }
        
        prev = curr;
    }
    
    // Check if valid
    for (int i = 1; i < result.size(); i++) {
        if (result[i] == result[i-1]) {
            return ""; // Not possible
        }
    }
    return result;
}
```

**Proof of Correctness**:
- **Greedy Choice**: Always pick the most frequent character that isn't the same as the previous one
- **Optimal Substructure**: After placing a character, the problem reduces to arranging the remaining characters

### 6. Lexicographically Smallest Equivalent String
**Problem**: Given two strings s1 and s2 of the same length and a base string baseStr, return the lexicographically smallest equivalent string of baseStr.

**Solution** (Union-Find + Greedy):
```cpp
string smallestEquivalentString(string s1, string s2, string baseStr) {
    // Union-Find to group equivalent characters
    vector<int> parent(26);
    iota(parent.begin(), parent.end(), 0);
    
    function<int(int)> find = [&](int x) {
        if (x != parent[x]) parent[x] = find(parent[x]);
        return parent[x];
    };
    
    auto unite = [&](int x, int y) {
        int rootX = find(x);
        int rootY = find(y);
        if (rootX != rootY) {
            // Union by making root of smaller character the parent
            if (rootX < rootY) {
                parent[rootY] = rootX;
            } else {
                parent[rootX] = rootY;
            }
        }
    };
    
    // Build equivalence classes
    for (int i = 0; i < s1.size(); i++) {
        unite(s1[i] - 'a', s2[i] - 'a');
    }
    
    // Build result
    string result = "";
    for (char c : baseStr) {
        int root = find(c - 'a');
        result += ('a' + root);
    }
    return result;
}
```

**Proof of Correctness**:
- **Greedy Choice**: For each character, choose the smallest possible equivalent character
- **Optimal Substructure**: The choice for each character is independent of others

---

## Greedy on Graphs

### 1. Minimum Spanning Tree Algorithms (Greedy)
Already covered in graph algorithms section.

**Kruskal's Algorithm**:
- **Greedy Choice**: Always pick the smallest weight edge that doesn't form a cycle
- **Proof**: Cut property - the lightest edge crossing any cut must be in the MST

**Prim's Algorithm**:
- **Greedy Choice**: Always add the closest vertex not yet in the MST
- **Proof**: Cut property - at each step, the cut separates the MST from the rest of the graph

### 2. Dijkstra's Algorithm (Greedy Aspect)
**Problem**: Find shortest paths from a single source in a graph with non-negative edge weights.

**Solution** (Already covered):
```cpp
typedef pair<long long, int> pli; // (distance, vertex)

vector<long long> dijkstra(int start, const vector<vector<pair<int, int>>>& adj) {
    int n = adj.size();
    vector<long long> dist(n, LLONG_MAX);
    priority_queue<pli, vector<pli>, greater<pli>> pq;
    
    dist[start] = 0;
    pq.push({0, start});
    
    while (!pq.empty()) {
        long long d = pq.top().first;
        int v = pq.top().second;
        pq.pop();
        
        if (d != dist[v]) continue;
        
        for (auto edge : adj[v]) {
            int to = edge.first;
            long long weight = edge.second;
            
            if (dist[v] + weight < dist[to]) {
                dist[to] = dist[v] + weight;
                pq.push({dist[to], to});
            }
        }
    }
    return dist;
}
```

**Proof of Correctness**:
- **Greedy Choice**: Always process the vertex with smallest known distance
- **Optimal Substructure**: Once a vertex is processed, its shortest distance is finalized

### 3. Activity Selection on Graphs (Interval Scheduling)
**Problem**: Given a set of intervals on a line, find the maximum number of non-overlapping intervals.

**Solution** (Same as Activity Selection):
```cpp
int max_non_overlapping_intervals(vector<pair<int, int>>& intervals) {
    // Sort by end time
    sort(intervals.begin(), intervals.end(), 
         [](const pair<int, int>& a, const pair<int, int>& b) {
             return a.second < b.second;
         });
    
    int count = 0;
    int end = -1;
    
    for (const auto& interval : intervals) {
        if (interval.first >= end) {
            count++;
            end = interval.second;
        }
    }
    return count;
}
```

### 4. Minimum Number of Arrows to Burst Balloons (Already covered)
**Graph Interpretation**: Treat balloons as intervals on x-axis

### 5. Assign Cookies
**Problem**: Given greed factors of children and sizes of cookies, assign cookies to children such that each child gets at most one cookie and the number of content children is maximized.

**Solution**:
```cpp
int findContentChildren(vector<int>& g, vector<int>& s) {
    sort(g.begin(), g.end());
    sort(s.begin(), s.end());
    
    int child = 0;
    int cookie = 0;
    
    while (child < g.size() && cookie < s.size()) {
        if (s[cookie] >= g[child]) {
            // Child is content
            child++;
            cookie++;
        } else {
            // Try next cookie
            cookie++;
        }
    }
    return child;
}
```

**Proof of Correctness**:
- **Greedy Choice**: Assign the smallest cookie that satisfies a child
- **Optimal Substructure**: After assigning a cookie, the problem reduces to remaining children and cookies

### 6. Partition Labels (Already covered)
**Graph Interpretation**: Can be seen as finding connected components in an interval overlap graph

### 7. Reconstruct Itinerary
**Problem**: Given a list of airline tickets, reconstruct the itinerary in order.

**Solution** (Hierholzer's algorithm for Eulerian path):
```cpp
vector<string> findItinerary(vector<vector<string>>& tickets) {
    // Build graph
    unordered_map<string, map<string, int>> adj;
    for (auto& ticket : tickets) {
        adj[ticket[0]][ticket[1]]++;
    }
    
    vector<string> route;
    function<void(string)> dfs = [&](string airport) {
        while (!adj[airport].empty()) {
            string next = adj[airport].begin()->first;
            adj[airport][next]--;
            if (adj[airport][next] == 0) {
                adj[airport].erase(next);
            }
            dfs(next);
        }
        route.push_back(airport);
    };
    
    dfs("JFK");
    reverse(route.begin(), route.end());
    return route;
}
```

**Proof of Correctness**:
- **Greedy Choice**: Always visit the smallest lexicographical destination available
- **Optimal Substructure**: After using a ticket, the problem reduces to finding a path in the remaining graph

---

## Greedy with Scheduling

### 1. Course Schedule III
**Problem**: Given n courses with duration and last day to finish, find the maximum number of courses that can be taken.

**Solution**:
```cpp
int scheduleCourse(vector<vector<int>>& courses) {
    // Sort by last day
    sort(courses.begin(), courses.end(), 
         [](const vector<int>& a, const vector<int>& b) {
             return a[1] < b[1];
         });
    
    priority_queue<int> pq; // Max heap for durations
    int time = 0;
    
    for (auto& course : courses) {
        int duration = course[0];
        int lastDay = course[1];
        
        if (time + duration <= lastDay) {
            // Can take this course
            time += duration;
            pq.push(duration);
        } else if (!pq.empty() && pq.top() > duration) {
            // Replace longest course with current one if it's shorter
            time -= pq.top();
            time += duration;
            pq.pop();
            pq.push(duration);
        }
    }
    return pq.size();
}
```

**Proof of Correctness**:
- **Greedy Choice**: Always take courses that finish earliest; replace longer course with shorter one if needed
- **Optimal Substructure**: The optimal schedule for first i courses depends only on those courses

### 2. Meeting Rooms II
**Problem**: Given meeting time intervals, find the minimum number of conference rooms required.

**Solution** (Already covered in data structures):
```cpp
int minMeetingRooms(vector<vector<int>>& intervals) {
    if (intervals.empty()) return 0;
    
    vector<int> starts;
    vector<int> ends;
    
    for (auto& interval : intervals) {
        starts.push_back(interval[0]);
        ends.push_back(interval[1]);
    }
    
    sort(starts.begin(), starts.end());
    sort(ends.begin(), ends.end());
    
    int rooms = 0;
    int ended = 0;
    
    for (int i = 0; i < starts.size(); i++) {
        if (starts[i] < ends[ended]) {
            rooms++; // Need a new room
        } else {
            ended++; // A meeting ended, reuse the room
        }
    }
    return rooms;
}
```

### 3. Single-Threaded CPU
**Problem**: Given tasks with enqueue time and processing time, simulate a single-threaded CPU.

**Solution**:
```cpp
vector<int> getOrder(vector<vector<int>>& tasks) {
    int n = tasks.size();
    vector<tuple<int, int, int>> indexed_tasks; // (enqueue, process, index)
    
    for (int i = 0; i < n; i++) {
        indexed_tasks.push_back({tasks[i][0], tasks[i][1], i});
    }
    
    sort(indexed_tasks.begin(), indexed_tasks.end());
    
    vector<int> result;
    priority_queue<pair<int, int>, vector<pair<int, int>>, 
                   greater<pair<int, int>>> pq; // (process_time, index)
    
    int i = 0;
    long long time = 0;
    
    while (result.size() < n) {
        // Add all tasks that have arrived by current time
        while (i < n && get<0>(indexed_tasks[i]) <= time) {
            pq.push({get<1>(indexed_tasks[i]), get<2>(indexed_tasks[i])});
            i++;
        }
        
        if (!pq.empty()) {
            // Process the shortest task
            auto [process_time, index] = pq.top();
            pq.pop();
            result.push_back(index);
            time += process_time;
        } else if (i < n) {
            // Jump to next task arrival time
            time = get<0>(indexed_tasks[i]);
        }
    }
    return result;
}
```

**Proof of Correctness**:
- **Greedy Choice**: Always process the shortest available task
- **Optimal Substructure**: After processing a task, the problem reduces to remaining tasks

### 4. Task Scheduler
**Problem**: Given a task scheduler with cooldown period, find the least number of intervals to finish all tasks.

**Solution** (Already covered):
```cpp
int leastInterval(vector<char>& tasks, int n) {
    vector<int> count(26, 0);
    for (char c : tasks) {
        count[c - 'A']++;
    }
    
    sort(count.begin(), count.end());
    
    int max_count = count[25];
    int max_count_tasks = 1;
    
    for (int i = 24; i >= 0 && count[i] == max_count; i--) {
        max_count_tasks++;
    }
    
    int part_count = max_count - 1;
    int part_length = n - (max_count_tasks - 1);
    int empty_slots = part_count * part_length;
    int available_tasks = tasks.size() - max_count * max_count_tasks;
    int idles = max(0, empty_slots - available_tasks);
    
    return tasks.size() + idles;
}
```

**Proof of Correctness**:
- **Greedy Choice**: Schedule the most frequent tasks first, filling gaps with less frequent tasks
- **Optimal Substructure**: The optimal schedule arranges tasks in frames of size (n+1)

---

## Greedy with Trees

### 1. Maximum Binary Tree
**Problem**: Given an array with no duplicates, construct a maximum binary tree where the root is the maximum number in the array.

**Solution**:
```cpp
/*
Definition for a binary tree node.
struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
    TreeNode() : val(0), left(nullptr), right(nullptr) {}
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
    TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
};
*/

TreeNode* constructMaximumBinaryTree(vector<int>& nums) {
    function<TreeNode*(int, int)> build = [&](int left, int right) {
        if (left > right) return nullptr;
        
        // Find index of maximum element
        int max_idx = left;
        for (int i = left + 1; i <= right; i++) {
            if (nums[i] > nums[max_idx]) {
                max_idx = i;
            }
        }
        
        TreeNode* root = new TreeNode(nums[max_idx]);
        root->left = build(left, max_idx - 1);
        root->right = build(max_idx + 1, right);
        return root;
    };
    
    return build(0, nums.size() - 1);
}
```

**Proof of Correctness**:
- **Greedy Choice**: The maximum element must be the root
- **Optimal Substructure**: Left and right subtrees are constructed recursively from subarrays

### 2. Convert BST to Greater Tree
**Problem**: Given a Binary Search Tree (BST), convert it to a Greater Tree such that every key of the original BST is changed to the original key plus sum of all keys greater than the original key in BST.

**Solution**:
```cpp
/*
Definition for a binary tree node.
struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
    TreeNode() : val(0), left(nullptr), right(nullptr) {}
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
    TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
};
*/

TreeNode* convertBST(TreeNode* root) {
    int sum = 0;
    
    function<void(TreeNode*)> reverse_inorder = [&](TreeNode* node) {
        if (!node) return;
        reverse_inorder(node->right);
        sum += node->val;
        node->val = sum;
        reverse_inorder(node->left);
    };
    
    reverse_inorder(root);
    return root;
}
```

**Proof of Correctness**:
- **Greedy Choice**: Process nodes in reverse in-order (descending) order
- **Optimal Substructure**: The sum for a node depends only on nodes with greater values

### 3. Diameter of Binary Tree
**Problem**: Given a binary tree, return the length of the diameter of the tree.

**Solution**:
```cpp
/*
Definition for a binary tree node.
struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
    TreeNode() : val(0), left(nullptr), right(nullptr) {}
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
    TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
};
*/

int diameterOfBinaryTree(TreeNode* root) {
    int diameter = 0;
    
    function<int(TreeNode*)> depth = [&](TreeNode* node) {
        if (!node) return 0;
        
        int left_depth = depth(node->left);
        int right_depth = depth(node->right);
        
        // Update diameter if path through this node is longer
        diameter = max(diameter, left_depth + right_depth);
        
        // Return height of this node
        return max(left_depth, right_depth) + 1;
    };
    
    depth(root);
    return diameter;
}
```

**Proof of Correctness**:
- **Greedy Choice**: The diameter is the maximum of: left subtree diameter, right subtree diameter, or path through root
- **Optimal Substructure**: The diameter of a tree depends on diameters of subtrees and heights

### 4. Binary Tree Tilt
**Problem**: Given a binary tree, return the sum of every tree node's tilt.

**Solution**:
```cpp
/*
Definition for a binary tree node.
struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
    TreeNode() : val(0), left(nullptr), right(nullptr) {}
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
    TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
};
*/

int findTilt(TreeNode* root) {
    int total_tilt = 0;
    
    function<int(TreeNode*)> sum = [&](TreeNode* node) {
        if (!node) return 0;
        
        int left_sum = sum(node->left);
        int right_sum = sum(node->right);
        
        total_tilt += abs(left_sum - right_sum);
        
        return node->val + left_sum + right_sum;
    };
    
    sum(root);
    return total_tilt;
}
```

### 5. Distribute Coins in Binary Tree
**Problem**: Given the root of a binary tree with N nodes, each node has node.val coins, and there are N coins total. Distribute coins so that each node has exactly one coin.

**Solution**:
```cpp
/*
Definition for a binary tree node.
struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
    TreeNode() : val(0), left(nullptr), right(nullptr) {}
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
    TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
};
*/

int distributeCoins(TreeNode* root) {
    int moves = 0;
    
    function<int(TreeNode*)> balance = [&](TreeNode* node) {
        if (!node) return 0;
        
        int left = balance(node->left);
        int right = balance(node->right);
        
        moves += abs(left) + abs(right);
        
        return node->val + left + right - 1; // Excess or deficit of coins
    };
    
    balance(root);
    return moves;
}
```

**Proof of Correctness**:
- **Greedy Choice**: Each node sends excess coins to/from parent
- **Optimal Substructure**: The number of moves depends only on coin distribution in subtrees

## Advanced Greedy Techniques

### 1. Greedy with Priority Queues
**Common Pattern**: Maintain a priority queue of options and always pick the best one.

**Examples**:
- **Course Schedule III** (already covered)
- **IPO Problem**: Maximize capital after k projects
- **Meeting Rooms II** (alternative approach)
- **Process Schedule with Resource Constraints**

**IPO Problem Example**:
```cpp
int findMaximizedCapital(int k, int w, vector<int>& profits, vector<int>& capital) {
    int n = profits.size();
    vector<pair<int, int>> projects;
    for (int i = 0; i < n; i++) {
        projects.push_back({capital[i], profits[i]});
    }
    
    // Sort by capital required
    sort(projects.begin(), projects.end());
    
    priority_queue<int> pq; // Max heap for profits
    int i = 0;
    int current_capital = w;
    
    for (int level = 0; level < k; level++) {
        // Add all projects that can be afforded with current capital
        while (i < n && projects[i].first <= current_capital) {
            pq.push(projects[i].second);
            i++;
        }
        
        if (!pq.empty()) {
            // Do the most profitable project
            current_capital += pq.top();
            pq.pop();
        } else {
            break; // No more projects can be done
        }
    }
    return current_capital;
}
```

### 2. Greedy with Two Pointers
**Common Pattern**: Use two pointers to traverse array/string from different directions.

**Examples**:
- **Container With Most Water** (already covered)
- **Valid Palindrome II**: Check if string can be palindrome after removing at most one character
- **3Sum Smaller**: Count triplets with sum less than target
- **Trapping Rain Water**: Calculate water trapped between bars

**Valid Palindrome II Example**:
```cpp
bool validPalindrome(string s) {
    auto is_palindrome_range = [&](int left, int right) {
        while (left < right) {
            if (s[left] != s[right]) return false;
            left++;
            right--;
        }
        return true;
    };
    
    int left = 0;
    int right = s.size() - 1;
    
    while (left < right) {
        if (s[left] != s[right]) {
            // Try removing either left or right character
            return is_palindrome_range(left + 1, right) || 
                   is_palindrome_range(left, right - 1);
        }
        left++;
        right--;
    }
    return true;
}
```

### 3. Greedy with Sliding Window
**Common Pattern**: Maintain a window that satisfies certain properties and expand/contract it.

**Examples**:
- **Minimum Window Substring** (already covered)
- **Longest Substring Without Repeating Characters**
- **Fruit Into Baskets**: Collect maximum fruits with at most 2 types
- **Longest Substring with At Most K Distinct Characters**
- **Permutation in String**: Check if string contains permutation of another string

**Longest Substring Without Repeating Characters Example**:
```cpp
int lengthOfLongestSubstring(string s) {
    vector<int> last_index(256, -1);
    int max_len = 0;
    int start = 0;
    
    for (int i = 0; i < s.size(); i++) {
        if (last_index[s[i]] >= start) {
            start = last_index[s[i]] + 1;
        }
        last_index[s[i]] = i;
        max_len = max(max_len, i - start + 1);
    }
    return max_len;
}
```

### 4. Greedy with Mathematical Insight
**Common Pattern**: Use mathematical properties to make greedy choices.

**Examples**:
- **Bulb Switcher**: Count bulbs that are on after n rounds
- **Power of Three**: Check if number is power of three
- **Perfect Squares**: Find least number of perfect squares that sum to n
- **Rectangle Area**: Calculate area in Histogram II**

**Perfect Squares Example** (using Lagrange's four-square theorem):
```cpp
int numSquares(int n) {
    // Check if n is perfect square
    int root = sqrt(n);
    if (root * root == n) return 1;
    
    // Check if n is sum of two squares
    for (int i = 1; i * i <= n; i++) {
        int remainder = n - i * i;
        int r = sqrt(remainder);
        if (r * r == remainder) return 2;
    }
    
    // Check if n is of form 4^a*(8b+7)
    while (n % 4 == 0) {
        n /= 4;
    }
    if (n % 8 == 7) return 4;
    
    // Otherwise, answer is 3
    return 3;
}
```

### 5. Greedy with Exchange Arguments
**Common Pattern**: Prove optimality by showing that any optimal solution can be transformed to include our greedy choice without worsening the solution.

**Examples**:
- **Activity Selection**: Already covered
- **Huffman Coding**: Already covered
- **Minimum Spanning Trees**: Already covered
- **Fractional Knapsack**: Already covered

**Template for Exchange Argument**:
1. Let S be the solution produced by our greedy algorithm
2. Let O be an optimal solution
3. If S = O, we're done
4. Otherwise, find the first position where S and O differ
5. Show that we can modify O to make it agree with S at that position without decreasing its value
6. Repeat until S = O

---

## When Greedy Fails

### Common Pitfalls
1. **Lack of Greedy Choice Property**: The locally optimal choice doesn't lead to globally optimal solution
2. **Lack of Optimal Substructure**: Optimal solution doesn't contain optimal solutions to subproblems
3. **Failure to Consider Future Consequences**: Greedy choice affects future options negatively
4. **Overlooking Edge Cases**: Greedy choice works for typical cases but fails on boundaries

### Examples Where Greedy Fails

#### 1. Coin Change (Non-Canonical Systems)
**Problem**: Given coins [1, 3, 4] and target 6, greedy chooses 4+1+1 (3 coins) but optimal is 3+3 (2 coins).

**Why Greedy Fails**:
- The coin system is not canonical
- Choosing the largest coin doesn't always lead to optimal solution
- **Correct Approach**: Dynamic programming

#### 2. Longest Increasing Subsequence
**Problem**: Greedy approach of always taking next larger element fails.

**Example**: [10, 9, 2, 5, 3, 7, 101, 18]
- Greedy might take: 10 -> (nothing larger) = length 1
- Optimal: 2, 3, 7, 101 or 2, 5, 7, 101 = length 4

**Why Greedy Fails**:
- Choosing the next available larger element may block longer sequences
- **Correct Approach**: Dynamic programming or Patience sorting (O(n log n))

#### 3. Traveling Salesperson Problem (Nearest Neighbor)
**Problem**: Greedy approach of always going to nearest unvisited city fails to find optimal tour.

**Why Greedy Fails**:
- Getting stuck with very long edges at the end
- No consideration of global tour structure
- **Correct Approach**: Dynamic programming (O(n²2ⁿ)) for small n, or approximation algorithms

#### 4. Set Cover Problem
**Problem**: Given a set of elements and subsets, find minimum number of subsets that cover all elements.

**Why Greedy Fails**:
- While greedy gives ln(n)-approximation, it's not optimal
- Selecting largest subset first can lead to poor choices
- **Correct Approach**: Integer linear programming (exponential) or approximation algorithms

#### 5. Maximum Sum of Non-Adjacent Elements (House Robber)
**Wait, this actually works with greedy-like DP!**
Actually, this is better solved with DP, but there is a greedy insight:
- **Correct Approach**: DP[i] = max(DP[i-1], DP[i-2] + nums[i])
- **Greedy insight**: At each step, choose between taking current + best from i-2 or skipping current

#### 6. Graph Coloring
**Problem**: Color vertices of graph with minimum colors such that no adjacent vertices share color.

**Why Greedy Fails**:
- Greedy coloring (color vertices in order with smallest available color) doesn't guarantee optimal
- Order of vertex coloring matters significantly
- **Correct Approach**: NP-hard; use heuristics, backtracking for small graphs, or special case algorithms

### How to Detect When Greedy Might Fail
1. **No obvious optimal substructure**: Hard to see how solution builds from sub-solutions
2. **Future-dependent choices**: Current choice significantly limits future options
3. **Known counterexamples**: Be aware of classic cases where greedy fails
4. **Optimization vs. Satisfaction**: Greedy works better for optimization than for exact satisfaction problems
5. **Lack of matroid structure**: Problems that don't form matroids often defeat greedy approaches

### Strategies When Greedy Doesn't Work
1. **Try Dynamic Programming**: If problem has overlapping subproblems
2. **Try Backtracking/DFS**: For small input sizes
3. **Try Branch and Bound**: With good pruning strategies
4. **Try Approximation Algorithms**: If exact solution is too hard
5. **Try Integer Linear Programming**: For formulation and solving with solvers
6. **Try Randomized Algorithms**: With good probability guarantees
7. **Try Special Case Algorithms**: If input has special structure

---

## Greedy vs Dynamic Programming

### Similarities
Both solve optimization problems by breaking them down into smaller subproblems.

### Differences
| Aspect | Greedy | Dynamic Programming |
|--------|--------|-------------------|
| **Choice Strategy** | Makes locally optimal choice | Considers all possibilities |
| **Subproblem Dependence** | Only depends on immediate previous choice | May depend on multiple previous choices |
| **Memory Usage** | Usually O(1) or O(n) | Often O(n²) or more |
| **Time Complexity** | Usually O(n log n) or O(n) | Often O(n²) or O(n³) |
| **Correctness Proof** | Requires greedy choice property proof | Based on principle of optimality |
| **When to Use** | When greedy choice property holds | When optimal substructure holds but greedy choice doesn't |

### Decision Guide
1. **Try Greedy First**: If you can identify a clear greedy choice
2. **Verify Greedy Choice Property**: Can you prove that the greedy choice is always part of some optimal solution?
3. **If Unsure**: Try both approaches on small examples
4. **Look for Counterexamples**: Try to find cases where greedy fails
5. **Consider Constraints**: If n is small (< 100), DP or backtracking might be feasible
6. **Think About State**: What information do you need to make a decision at each step?

### Problems Solvable by Both
Some problems can be solved by either approach, with different trade-offs:

#### 1. Maximum Subarray Sum
- **Greedy (Kadane's)**: O(n) time, O(1) space
- **DP**: O(n) time, O(n) space (can be optimized to O(1))
- **Preference**: Greedy is simpler and more efficient

#### 2. House Robber
- **Greedy-like DP**: O(n) time, O(1) space
- **Pure Greedy**: Doesn't work directly
- **Preference**: DP approach is standard

#### 3. Longest Increasing Subsequence
- **Greedy**: Doesn't work for strict version
- **Greedy with Binary Search**: O(n log n) time (Patience sorting)
- **DP**: O(n²) time
- **Preference**: Greedy + binary search is preferred

#### 4. Minimum Path Sum in Triangle
- **Greedy**: Doesn't work
- **DP**: O(n²) time, O(n) space (bottom-up)
- **Preference**: DP is standard

### Hybrid Approaches
Sometimes we combine greedy ideas with other techniques:

1. **Greedy + DP**: Use greedy to reduce state space
2. **DP + Greedy Optimization**: Use greedy to optimize DP transitions
3. **Greedy + Divide and Conquer**: Use greedy choices to divide problem
4. **Greedy + Backtracking**: Use greedy to guide search order

---

## Advanced Topics

### Matroid Theory
**Purpose**: Generalizes the concept of linear independence in vector spaces
**Importance**: Greedy algorithm is optimal for optimization problems on matroids

**Matroid Properties**:
1. **Non-empty**: The empty set is independent
2. **Hereditary Property**: Every subset of an independent set is independent
3. **Exchange Property**: If A and B are independent sets with |A| < |B|, then there exists an element in B\A that can be added to A while keeping it independent

**Examples of Matroids**:
- **Uniform Matroid**: All subsets of size ≤ k are independent
- **Graphic Matroid**: Independent sets are forests in a graph
- **Partition Matroid**: Partition ground set; independent sets contain at most specified number from each partition
- **Laminar Matroid**: Based on laminar family of sets
- **Matching Matroid**: Independent sets are matchings in a graph

**Greedy Algorithm on Matroids**:
To find maximum weight independent set in a matroid:
1. Sort elements by decreasing weight
2. Start with empty set
3. For each element in sorted order, add it if it keeps the set independent

This works because of the exchange property of matroids.

### Greedy Algorithms in Online Settings
**Online Algorithms**: Must make decisions without knowing future inputs
**Competitive Ratio**: Ratio of online algorithm cost to optimal offline algorithm cost

**Examples**:
- **Online Bidding Problem**
- **Online Set Cover**
- **Online Paging/Cache Replacement** (LRU, LFU, etc.)
- **Online Matching**

### Approximation Algorithms with Greedy
Many NP-hard problems have greedy approximation algorithms:

1. **Set Cover**: Greedy gives H_n approximation (harmonic number)
2. **Vertex Cover**: Greedy gives 2-approximation
3. **Maximum Coverage**: Greedy gives (1-1/e) approximation
4. **Traveling Salesperson (Metric)**: Christofides algorithm gives 3/2-approximation
5. **Knapsack**: Greedy by value/weight gives 2-approximation (can be improved)

### Parametric Search
**Purpose**: Use greedy as a subroutine in binary search to solve optimization problems
**Pattern**: 
- Guess a value for the answer
- Use greedy algorithm to check if guess is feasible
- Adjust guess based on feasibility
- Repeat until convergence

**Examples**:
- **Minimum Time to Complete Trips**: Given time, can we complete trips? (binary search on time)
- **Split Array Largest Sum**: Can we split array with max subarray sum ≤ X? (binary search on X)
- **Minimum Size Subarray Sum**: Is there subarray with sum ≥ target? (sliding window + binary search)

### Greedy in Geometric Algorithms
1. **Convex Hull (Graham Scan)**: 
   - Sort by polar angle
   - Greedily add points while maintaining convexity
   
2. **Convex Hull (Andrew's Monotone Chain)**:
   - Sort by x then y
   - Build lower and upper hulls greedily
   
3. **Minimum Enclosing Circle**:
   - Welzl's algorithm (randomized incremental)
   
4. **Closest Pair of Points**:
   - Not greedy, but plane sweep has greedy aspects

### Greedy in String Algorithms
1. **Lyndon Factorization**:
   - Duval's algorithm: Greedily find Lyndon words
   
2. **Run Length Encoding**:
   - Naturally greedy
   
3. **Dictionary Basic Encoding**:
   - Greedy parsing

---

## Summary and Best Practices

### When to Use Greedy
1. **Clear greedy choice**: You can identify what the "best" choice is at each step
2. **Proof possible**: You can argue (or prove) that the greedy choice doesn't prevent optimality
3. **Problem structure**: The problem exhibits optimal substructure
4. **No better alternative**: Dynamic programming would be overkill or too slow

### How to Develop a Greedy Solution
1. **Understand the objective**: What are we trying to minimize/maximize?
2. **Identify choices**: What decisions do we need to make?
3. **Determine greedy criteria**: What makes one choice better than another?
4. **Test on examples**: Does the greedy choice work on small cases?
5. **Attempt proof**: Can you show that swapping choices doesn't improve solution?
6. **Consider edge cases**: Does the approach work on boundaries?
7. **Implement and test**: Code it up and test thoroughly

### Common Greedy Patterns to Recognize
1. **Sort and process**: Sort input and process in order
2. **Always take extreme**: Largest/smallest, earliest/latest
3. **Maintain invariant**: Keep some property true throughout
4. **Use priority queue**: Always access best available option
5. **Two pointers/sliding window**: Efficiently process sequences
6. **Exchange argument proof**: Show optimality through swapping
7. **Matroid structure**: When applicable, greedy is guaranteed optimal

### Red Flags for Greedy
1. **No obvious choice**: Can't decide what's "best" at each step
2. **Future penalty**: Current choice severely limits future options
3. **Known counterexamples**: Be aware of classic failures
4. **High intermixing**: Choices are highly interdependent
5. **NP-hard suspicion**: If problem is known NP-hard, greedy likely won't give exact answer

### Final Advice
1. **Start greedy**: It's often the simplest approach to try first
2. **Verify with examples**: Test on multiple cases before committing
3. **Learn from failures**: When greedy fails, understand why to improve intuition
4. **Study proofs**: Understanding why greedy works is as important as knowing how to implement it
5. **Practice recognition**: The more problems you solve, the better you'll get at spotting greedy opportunities
6. **Consider hybrids**: Sometimes greedy + DP or other techniques works best
7. **Stay humble**: If unsure, try both greedy and DP on small cases to compare

Remember: The key to mastering greedy algorithms is not just knowing when to use them, but developing the intuition to recognize when they're applicable and being able to justify why they work. Practice with a variety of problems, study both successes and failures, and always question whether your greedy choice is truly safe.

Happy coding, and may your greedy choices always lead to optimal solutions! 🚀