# Blockchain Interview Questions

## Table of Contents

1. [Fundamental Concepts](#fundamental-concepts)
2. [Cryptocurrency](#cryptocurrency)
3. [Smart Contracts](#smart-contracts)
4. [Consensus & Architecture](#consensus--architecture)
5. [DeFi & Web3](#defi--web3)
6. [Security & Auditing](#security--auditing)
7. [Technical Implementation](#technical-implementation)
8. [Scenario-Based Questions](#scenario-based-questions)

---

## Fundamental Concepts

### General Blockchain Questions

**Q1: What is blockchain and how does it work?**

```
Answer:
Blockchain is a distributed, immutable ledger that records
transactions across multiple computers.

How it works:
1. Transaction initiated
2. Broadcast to network nodes
3. Nodes validate transaction
4. Valid transactions grouped into block
5. Block added to chain via consensus
6. Transaction complete

Key properties:
• Decentralization
• Immutability
• Transparency
• Security through cryptography
```

**Q2: What are the key components of a blockchain?**

```
Answer:
┌─────────────────────────────────────────────┐
│           KEY COMPONENTS                     │
├─────────────────────────────────────────────┤
│ Block          │ Contains transactions       │
│ Chain          │ Linked blocks               │
│ Hash           │ Unique block identifier     │
│ Nonce          │ Number used in mining       │
│ Merkle Root    │ Transaction tree root       │
│ Previous Hash  │ Links to previous block     │
│ Nodes          │ Network participants        │
│ Consensus      │ Agreement mechanism         │
└─────────────────────────────────────────────┘
```

**Q3: What is the difference between blockchain and database?**

```
Answer:
┌───────────────┬─────────────────┬─────────────────┐
│ Feature       │ Blockchain      │ Database        │
├───────────────┼─────────────────┼─────────────────┤
│ Control       │ Decentralized   │ Centralized     │
│ Mutability    │ Immutable       │ Mutable         │
│ Trust         │ Trustless       │ Requires trust  │
│ Speed         │ Slower          │ Faster          │
│ Transparency  │ Public/visible  │ Private         │
│ Cost          │ Higher          │ Lower           │
└───────────────┴─────────────────┴─────────────────┘
```

**Q4: What are the different types of blockchains?**

```
Answer:
1. Public Blockchain
   • Anyone can join
   • Fully decentralized
   • Example: Bitcoin, Ethereum

2. Private Blockchain
   • Controlled access
   • Single organization
   • Example: Hyperledger Fabric

3. Consortium Blockchain
   • Group of organizations
   • Semi-decentralized
   • Example: R3 Corda

4. Hybrid Blockchain
   • Mix of public and private
   • Configurable permissions
   • Example: Dragonchain
```

---

## Cryptocurrency

**Q5: What is the difference between Bitcoin and Ethereum?**

```
Answer:
┌───────────────┬─────────────────┬─────────────────┐
│ Feature       │ Bitcoin         │ Ethereum        │
├───────────────┼─────────────────┼─────────────────┤
│ Purpose       │ Digital money   │ Smart contracts │
│ Consensus     │ PoW             │ PoS             │
│ Block time    │ 10 minutes      │ 12 seconds      │
│ TPS           │ 7               │ 15-30           │
│ Smart contracts│ No             │ Yes (Solidity)  │
│ Supply        │ 21M max         │ No cap          │
│ Use case      │ Store of value  │ DApps, DeFi     │
└───────────────┴─────────────────┴─────────────────┘
```

**Q6: What is a Merkle Tree and why is it used?**

```
Answer:
A Merkle Tree is a hash-based data structure that
efficiently verifies data integrity.

Structure:
         Root Hash
         /      \
     Hash(AB)  Hash(CD)
     /    \    /    \
   Tx A  Tx B Tx C  Tx D

Benefits:
• Efficient verification
• Scalable integrity checks
• Quick change detection
• Used in SPV (Simplified Payment Verification)
• Reduces data needed for verification
```

**Q7: What are gas fees and why do they exist?**

```
Answer:
Gas fees are payments for computational resources
on Ethereum network.

Why they exist:
• Prevent spam
• Compensate validators
• Allocate network resources
• Discourage abuse

Factors affecting gas:
• Network congestion
• Transaction complexity
• Gas price (Gwei)
• Gas limit

Optimization:
• Use appropriate gas limit
• Batch transactions
• Use Layer 2 solutions
• Time transactions strategically
```

---

## Smart Contracts

**Q8: What is a smart contract?**

```
Answer:
A smart contract is self-executing code stored on
blockchain that automatically enforces agreement terms.

Characteristics:
• Immutable once deployed
• Transparent
• Runs exactly as programmed
• No intermediaries needed
• Trustless execution

Use Cases:
• Token creation
• DeFi protocols
• DAOs
• Supply chain
• Insurance
```

**Q9: What is the difference between Solidity and Vyper?**

```
Answer:
┌───────────────┬─────────────────┬─────────────────┐
│ Feature       │ Solidity        │ Vyper           │
├───────────────┼─────────────────┼─────────────────┤
│ Syntax        │ JavaScript-like │ Python-like     │
│ Complexity    │ Feature-rich    │ Minimalist      │
│ Learning      │ Easier          │ Harder          │
│ Gas           │ Less optimized  │ More optimized  │
│ Security      │ More attack     │ Fewer attacks   │
│               │ surface         │ surface         │
│ Ecosystem     │ Larger          │ Smaller         │
└───────────────┴─────────────────┴─────────────────┘
```

**Q10: What is the Checks-Effects-Interactions pattern?**

```
Answer:
A security pattern to prevent reentrancy attacks.

1. Checks: Validate all conditions
2. Effects: Update state variables
3. Interactions: Make external calls

Example (vulnerable):
function withdraw() public {
    uint balance = balances[msg.sender];
    // Interaction first - vulnerable!
    (bool success, ) = msg.sender.call{value: balance}("");
    balances[msg.sender] = 0;  // State update too late
}

Example (secure):
function withdraw() public {
    uint balance = balances[msg.sender];
    // Check
    require(balance > 0);
    // Effect
    balances[msg.sender] = 0;
    // Interaction
    (bool success, ) = msg.sender.call{value: balance}("");
}
```

---

## Consensus & Architecture

**Q11: What is Proof of Work and how does it work?**

```
Answer:
Consensus mechanism where miners compete to solve
complex mathematical puzzles.

Process:
1. Collect pending transactions
2. Create candidate block
3. Find nonce producing hash below target
4. First to find broadcasts block
5. Others verify and accept
6. Miner receives reward

Pros:
• Battle-tested
• Highly decentralized
• Strong security

Cons:
• Energy intensive
• Slow transactions
• Centralization risk (mining pools)
```

**Q12: What is Proof of Stake and how does it differ from PoW?**

```
Answer:
Consensus where validators are selected based on
their staked cryptocurrency.

Selection:
• Validators lock tokens as stake
• Randomized selection weighted by stake
• Higher stake = higher chance

Pros:
• Energy efficient
• Faster transactions
• Lower barriers

Cons:
• "Rich get richer" concern
• Nothing-at-stake problem
• Validator centralization

Ethereum's PoS:
• Minimum 32 ETH stake
• Slashing for bad behavior
• Random validator selection
```

**Q13: What is a 51% attack?**

```
Answer:
When a single entity controls majority of network's
mining/staking power.

Impact:
• Double spending
• Transaction reversal
• Block censorship
• Network disruption

Prevention:
• Decentralization
• High network hash rate
• Economic penalties
• Checkpointing

Real-world examples:
• Ethereum Classic
• Bitcoin Gold
• Verge
```

---

## DeFi & Web3

**Q14: What is DeFi and what are its main components?**

```
Answer:
Decentralized Finance - financial services without
traditional intermediaries.

Components:
├── DEX (Decentralized Exchanges)
│   └── Uniswap, SushiSwap
├── Lending/Borrowing
│   └── Aave, Compound
├── Stablecoins
│   └── DAI, USDC
├── Yield Farming
│   └── Yearn Finance
├── Derivatives
│   └── Synthetix, dYdX
└── Insurance
    └── Nexus Mutual
```

**Q15: What is a DEX and how does it work?**

```
Answer:
Decentralized Exchange allows peer-to-peer trading
without intermediaries.

Types:
1. Order Book DEX
   • Traditional order matching
   • Example: Serum

2. AMM (Automated Market Maker)
   • Liquidity pools
   • Price algorithm
   • Example: Uniswap

AMM Formula:
x * y = k
x = Token A amount
y = Token B amount
k = Constant

Benefits:
• No KYC
• Self-custody
• Composable
• Global access
```

**Q16: What are Layer 2 solutions?**

```
Answer:
Scaling solutions built on top of main chain.

Types:
1. Rollups
   • Optimistic (Optimism, Arbitrum)
   • zk-Rollups (zkSync, StarkNet)

2. State Channels
   • Lightning Network
   • Raiden Network

3. Sidechains
   • Polygon
   • xDai

Benefits:
• Higher throughput
• Lower fees
• Main chain security
• Better UX
```

---

## Security & Auditing

**Q17: What are common smart contract vulnerabilities?**

```
Answer:
┌─────────────────────────────────────────────────┐
│            COMMON VULNERABILITIES                │
├─────────────────────────────────────────────────┤
│ Reentrancy       │ External call before update   │
│ Integer Overflow │ Arithmetic without checks     │
│ Access Control   │ Missing permission checks     │
│ Front-running    │ Transaction ordering          │
│ Flash Loans      │ Price manipulation            │
│ Oracle Manipulation │ False price feeds         │
│ Denial of Service│ Gas exhaustion attacks        │
│ Time Dependence  │ Block timestamp manipulation  │
└─────────────────────────────────────────────────┘
```

**Q18: How do you audit a smart contract?**

```
Answer:
1. Manual Code Review
   • Line-by-line analysis
   • Logic verification
   • Pattern identification

2. Automated Testing
   • Unit tests
   • Integration tests
   • Fuzz testing

3. Static Analysis
   • Slither
   • Mythril
   • Securify

4. Formal Verification
   • Mathematical proofs
   • State machine analysis

5. Economic Analysis
   • Incentive alignment
   • Attack scenarios
   • Game theory

6. Documentation
   • Findings report
   • Risk assessment
   • Recommendations
```

**Q19: What is a reentrancy attack and how do you prevent it?**

```
Answer:
Attack where external contract calls back into
vulnerable contract before state is updated.

Attack Flow:
1. Attacker calls vulnerable function
2. Function makes external call
3. Attacker's fallback executes
4. Attacker calls function again
5. Repeats until drained

Prevention:
1. Checks-Effects-Interactions pattern
2. ReentrancyGuard (OpenZeppelin)
3. State update before external call
4. Pull payments pattern

Example:
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Vault is ReentrancyGuard {
    function withdraw() public nonReentrant {
        // State update first
        balances[msg.sender] = 0;
        // Then external call
        payable(msg.sender).transfer(amount);
    }
}
```

---

## Technical Implementation

**Q20: How does Ethereum Virtual Machine (EVM) work?**

```
Answer:
EVM is runtime environment for smart contracts.

Components:
├── Stack-based execution
├── 256-bit word size
├── Bytecode compilation
├── Gas metering
└── Deterministic execution

Execution Flow:
1. Solidity → Compiler → Bytecode
2. Bytecode deployed to blockchain
3. EVM executes bytecode
4. State changes recorded
5. Gas consumed for operations

Opcodes:
• PUSH: Stack operations
• ADD/SUB: Arithmetic
• SLOAD/SSTORE: Storage
• CALL: External calls
• RETURN: Exit execution
```

**Q21: What are events in Solidity and why are they important?**

```
Answer:
Events are logs emitted during contract execution.

Importance:
• Off-chain indexing
• Transaction tracking
• UI updates
• Debugging
• Cost-efficient storage

Example:
contract MyContract {
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    function transfer(address to, uint256 amount) public {
        // ... logic ...
        emit Transfer(msg.sender, to, amount);
    }
}

Benefits:
• Cheaper than storage (256 gas vs 20,000 gas)
• Indexed for filtering
• Accessible via web3
• Permanent record
```

**Q22: What is the difference between call, delegatecall, and staticcall?**

```
Answer:
┌──────────────┬─────────────────┬─────────────────┐
│ Feature      │ call            │ delegatecall    │
├──────────────┼─────────────────┼─────────────────┤
│ Context      │ Called contract │ Calling contract│
│ Storage      │ Called contract │ Calling contract│
│ msg.sender   │ Caller          │ Original sender │
│ Use case     │ External calls  │ Libraries       │
└──────────────┴─────────────────┴─────────────────┘

staticcall:
• Read-only call
• Cannot modify state
• Used for view functions
• Reverts if state change attempted
```

---

## Scenario-Based Questions

**Q23: How would you design a token sale contract?**

```
Answer:
Key Requirements:
• Whitelist management
• Hard cap/soft cap
• Time-bound sale
• Price tiers
• Refund mechanism

Design:
1. State variables
   • saleStart, saleEnd
   • hardCap, softCap
   • pricePerToken
   • whitelist mapping

2. Functions
   • buyTokens()
   • claimTokens()
   • withdrawFunds()
   • emergencyRefund()

3. Security
   • ReentrancyGuard
   • Access control
   • Pausable
   • SafeMath

4. Events
   • TokensPurchased
   • SaleFinalized
   • RefundIssued
```

**Q24: How would you handle an upgrade to a deployed contract?**

```
Answer:
Upgrade Strategies:

1. Proxy Pattern (Recommended)
   • Separate logic and storage
   • Upgrade logic contract
   • Keep storage intact

2. Data Migration
   • Deploy new contract
   • Migrate state
   • Update references

Considerations:
• Storage layout compatibility
• Function signature changes
• Testing on testnet
• Governance approval
• User migration plan

Tools:
• OpenZeppelin Upgrades
• Hardhat Upgrades
• Diamond Pattern
```

**Q25: How do you optimize gas costs in smart contracts?**

```
Answer:
Optimization Strategies:

1. Storage Optimization
   • Pack variables
   • Use events over storage
   • Clear unused storage

2. Code Optimization
   • Cache storage variables
   • Use short-circuiting
   • Avoid loops when possible

3. Data Types
   • Use appropriate sizes
   • bytes32 over string
   • uint8 for small numbers

4. External Calls
   • Batch operations
   • Use libraries
   • Minimize cross-contract calls

5. Development Practices
   • Gas profiling
   • Test with gas limits
   • Use optimizer
```

---

## Quick Reference

### Solidity Cheat Sheet

```solidity
// Data Types
uint256, int256, bool, address, bytes32, string

// Visibility
public, private, internal, external

// State Mutability
view, pure, payable

// Modifiers
onlyOwner, nonReentrant, whenNotPaused

// Common Patterns
// ReentrancyGuard
// Ownable
// Pausable
// AccessControl
```

### Common Gas Costs

| Operation | Gas Cost |
|-----------|----------|
| SSTORE (new) | 20,000 |
| SSTORE (update) | 5,000 |
| SLOAD | 2,100 |
| CALL (external) | 700 |
| CREATE | 32,000 |
| Transaction | 21,000 |

### Interview Preparation Checklist

```
□ Understand blockchain fundamentals
□ Know major cryptocurrencies
□ Master Solidity basics
□ Understand consensus mechanisms
□ Learn DeFi concepts
□ Study security best practices
□ Practice coding problems
□ Review common vulnerabilities
□ Build portfolio projects
□ Stay updated on trends
```

---

*Last Updated: 2024*
