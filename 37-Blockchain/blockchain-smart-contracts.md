# Smart Contract Development

## Table of Contents

1. [Introduction to Smart Contracts](#introduction-to-smart-contracts)
2. [Solidity Fundamentals](#solidity-fundamentals)
3. [Smart Contract Patterns](#smart-contract-patterns)
4. [Security Best Practices](#security-best-practices)
5. [Development Tools](#development-tools)
6. [Testing Strategies](#testing-strategies)
7. [Deployment Guide](#deployment-guide)
8. [Advanced Topics](#advanced-topics)

---

## Introduction to Smart Contracts

### What are Smart Contracts?

```
Smart Contracts:
├── Self-executing code on blockchain
├── Automatically enforce agreement terms
├── Immutable once deployed
├── Transparent and verifiable
└── No intermediaries needed

Use Cases:
├── Token creation (ERC-20, ERC-721)
├── DeFi protocols (DEX, lending)
├── DAOs and governance
├── Supply chain tracking
├── Digital identity
└── Gaming and NFTs
```

### Smart Contract Lifecycle

```
1. Design
   Define requirements and architecture
   
2. Develop
   Write contract code
   
3. Test
   Unit tests, integration tests, audit
   
4. Deploy
   Deploy to testnet, then mainnet
   
5. Monitor
   Track activity, handle issues
   
6. Upgrade (if applicable)
   Proxy patterns for upgradability
```

---

## Solidity Fundamentals

### Basic Structure

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MyContract {
    // State variables
    address public owner;
    uint256 public value;
    
    // Events
    event ValueChanged(uint256 newValue);
    
    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    
    // Constructor
    constructor() {
        owner = msg.sender;
    }
    
    // Function
    function setValue(uint256 _value) public onlyOwner {
        value = _value;
        emit ValueChanged(_value);
    }
    
    // View function
    function getValue() public view returns (uint256) {
        return value;
    }
}
```

### Data Types

```solidity
contract DataTypes {
    // Value types
    bool public isActive = true;
    address public owner = msg.sender;
    uint256 public count = 100;
    int256 public temperature = -10;
    bytes32 public data = "0x1234";
    bytes public rawData = "hello";
    string public name = "Smart Contract";
    
    // Reference types
    uint256[] public numbers;
    mapping(address => uint256) public balances;
    
    struct Person {
        string name;
        uint256 age;
        address wallet;
    }
    
    enum Status { Pending, Active, Completed }
    
    // Arrays
    uint256[] fixedArray;
    uint256[] dynamicArray;
    
    // Mappings
    mapping(string => uint256) public stringMap;
    mapping(address => mapping(address => uint256)) public nestedMap;
}
```

### Functions

```solidity
contract FunctionExamples {
    uint256 public value;
    
    // State-changing function
    function setValue(uint256 _value) public {
        value = _value;
    }
    
    // View function (reads state)
    function getValue() public view returns (uint256) {
        return value;
    }
    
    // Pure function (no state access)
    function add(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b;
    }
    
    // Internal function
    function _internalFunc() internal {
        // Can only be called within contract
    }
    
    // Private function
    function _privateFunc() private {
        // Can only be called within contract
    }
    
    // External function
    function externalFunc() external {
        // Can only be called from outside
    }
    
    // Function with multiple returns
    function getDetails() public view returns (uint256, address, bool) {
        return (value, msg.sender, true);
    }
    
    // Named returns
    function getNamedReturns() public view returns (uint256 val, address addr) {
        val = value;
        addr = msg.sender;
    }
}
```

### Control Structures

```solidity
contract ControlStructures {
    // If/else
    function checkValue(uint256 _value) public pure returns (string memory) {
        if (_value > 100) {
            return "high";
        } else if (_value > 50) {
            return "medium";
        } else {
            return "low";
        }
    }
    
    // For loop
    function sum(uint256 n) public pure returns (uint256) {
        uint256 total = 0;
        for (uint256 i = 1; i <= n; i++) {
            total += i;
        }
        return total;
    }
    
    // While loop
    function findFactorial(uint256 n) public pure returns (uint256) {
        uint256 result = 1;
        uint256 i = 2;
        while (i <= n) {
            result *= i;
            i++;
        }
        return result;
    }
    
    // Require, assert, revert
    function validateInput(uint256 _value) public pure {
        require(_value > 0, "Value must be positive");
        require(_value <= 100, "Value must be <= 100");
        // Code continues if requirements met
    }
    
    function dangerousOperation() public pure {
        assert(1 + 1 == 2); // Should never fail
    }
    
    function processData(uint256 _value) public pure returns (uint256) {
        if (_value == 0) {
            revert("Cannot process zero");
        }
        return _value * 2;
    }
}
```

---

## Smart Contract Patterns

### Access Control

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AccessControl {
    address public owner;
    mapping(address => bool) public admins;
    mapping(bytes32 => mapping(address => bool)) private _roles;
    
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    
    modifier onlyRole(bytes32 role) {
        require(_roles[role][msg.sender], "Not authorized");
        _;
    }
    
    constructor() {
        owner = msg.sender;
        _roles[ADMIN_ROLE][msg.sender] = true;
    }
    
    function grantRole(bytes32 role, address account) public onlyRole(ADMIN_ROLE) {
        _roles[role][account] = true;
    }
    
    function revokeRole(bytes32 role, address account) public onlyRole(ADMIN_ROLE) {
        _roles[role][account] = false;
    }
    
    function hasRole(bytes32 role, address account) public view returns (bool) {
        return _roles[role][account];
    }
}
```

### Token Patterns

```solidity
// ERC-20 Token
contract MyToken {
    string public name = "My Token";
    string public symbol = "MTK";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    constructor(uint256 _initialSupply) {
        totalSupply = _initialSupply * 10**decimals;
        balanceOf[msg.sender] = totalSupply;
    }
    
    function transfer(address to, uint256 amount) public returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        
        emit Transfer(msg.sender, to, amount);
        return true;
    }
    
    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    
    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(balanceOf[from] >= amount, "Insufficient balance");
        require(allowance[from][msg.sender] >= amount, "Insufficient allowance");
        
        balanceOf[from] -= amount;
        allowance[from][msg.sender] -= amount;
        balanceOf[to] += amount;
        
        emit Transfer(from, to, amount);
        return true;
    }
}
```

### Proxy Pattern (Upgradability)

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Proxy {
    address public implementation;
    address public admin;
    
    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }
    
    constructor(address _implementation) {
        implementation = _implementation;
        admin = msg.sender;
    }
    
    fallback() external payable {
        _delegate(implementation);
    }
    
    function upgrade(address newImplementation) external onlyAdmin {
        implementation = newImplementation;
    }
    
    function _delegate(address impl) internal {
        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), impl, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }
}

contract Implementation {
    uint256 public value;
    
    function setValue(uint256 _value) public {
        value = _value;
    }
}
```

---

## Security Best Practices

### Common Vulnerabilities

```solidity
// 1. Reentrancy Attack
// VULNERABLE
contract VulnerableVault {
    mapping(address => uint256) public balances;
    
    function withdraw() public {
        uint256 balance = balances[msg.sender];
        require(balance > 0);
        
        (bool success, ) = msg.sender.call{value: balance}("");
        require(success);
        
        balances[msg.sender] = 0; // State update too late
    }
}

// SECURE
contract SecureVault {
    mapping(address => uint256) public balances;
    bool private locked;
    
    modifier noReentrant() {
        require(!locked, "No reentrancy");
        locked = true;
        _;
        locked = false;
    }
    
    function withdraw() public noReentrant {
        uint256 balance = balances[msg.sender];
        require(balance > 0);
        
        balances[msg.sender] = 0; // State update first
        
        (bool success, ) = msg.sender.call{value: balance}("");
        require(success);
    }
}

// 2. Integer Overflow (pre-0.8.0)
// VULNERABLE (Solidity <0.8.0)
contract OverflowExample {
    uint8 public count;
    
    function increment() public {
        count++; // Can overflow
    }
}

// SECURE (Solidity >=0.8.0)
contract SafeCounter {
    uint8 public count;
    
    function increment() public {
        count++; // Automatically checks for overflow
    }
}

// 3. Access Control
// VULNERABLE
contract VulnerableAccess {
    address public owner;
    
    constructor() {
        owner = msg.sender;
    }
    
    function changeOwner(address newOwner) public {
        // Missing access control!
        owner = newOwner;
    }
}

// SECURE
contract SecureAccess {
    address public owner;
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    
    function changeOwner(address newOwner) public onlyOwner {
        owner = newOwner;
    }
}
```

### Security Checklist

```
Smart Contract Security Checklist:

Access Control:
□ Implement proper modifiers
□ Use role-based access
□ Validate all inputs
□ Check caller permissions

State Management:
□ Update state before external calls
□ Use checks-effects-interactions
□ Handle all error cases
□ Avoid state changes in loops

Reentrancy:
□ Use ReentrancyGuard
□ Update state before calls
□ Use pull payments
□ Limit gas forwarding

Arithmetic:
□ Use Solidity >=0.8.0
□ Check for overflow/underflow
□ Use SafeMath if needed
□ Validate array bounds

Gas Optimization:
□ Use appropriate data types
□ Minimize storage operations
□ Use events for logging
□ Avoid unnecessary loops

Testing:
□ Unit tests for all functions
□ Integration tests
□ Fuzz testing
□ Gas limit testing

Audit:
□ Professional audit
□ Formal verification
□ Bug bounty program
□ Peer review
```

---

## Development Tools

### Hardhat Setup

```javascript
// hardhat.config.js
require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  solidity: {
    version: "0.8.19",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  networks: {
    hardhat: {},
    goerli: {
      url: process.env.GOERLI_RPC_URL,
      accounts: [process.env.PRIVATE_KEY]
    },
    mainnet: {
      url: process.env.MAINNET_RPC_URL,
      accounts: [process.env.PRIVATE_KEY]
    }
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY
  }
};
```

```javascript
// scripts/deploy.js
const hre = require("hardhat");

async function main() {
  const MyContract = await hre.ethers.getContractFactory("MyContract");
  const contract = await MyContract.deploy();
  await contract.deployed();
  
  console.log("Contract deployed to:", contract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
```

### Foundry Setup

```bash
# Initialize project
forge init my-project
cd my-project

# Install dependencies
forge install OpenZeppelin/openzeppelin-contracts

# Compile
forge build

# Test
forge test

# Deploy
forge create src/MyContract.sol:MyContract \
  --rpc-url $RPC_URL \
  --private-key $PRIVATE_KEY
```

```solidity
// test/MyContract.t.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/MyContract.sol";

contract MyContractTest is Test {
    MyContract public contract;
    
    function setUp() public {
        contract = new MyContract();
    }
    
    function testSetValue() public {
        contract.setValue(100);
        assertEq(contract.value(), 100);
    }
    
    function testFailSetValueWithoutAuth() public {
        // Should fail if not owner
        vm.prank(address(0x1234));
        contract.setValue(100);
    }
}
```

### OpenZeppelin Contracts

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract SecureToken is ERC20, AccessControl, ReentrancyGuard {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    
    constructor() ERC20("Secure Token", "STK") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }
    
    function mint(address to, uint256 amount) public onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }
    
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }
}
```

---

## Testing Strategies

### Unit Testing

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/Token.sol";

contract TokenTest is Test {
    Token public token;
    address public owner;
    address public user1;
    address public user2;
    
    function setUp() public {
        owner = address(this);
        user1 = address(0x1);
        user2 = address(0x2);
        
        token = new Token("Test Token", "TST", 1000);
        
        vm.prank(owner);
        token.transfer(user1, 100);
        vm.prank(owner);
        token.transfer(user2, 50);
    }
    
    function testTransfer() public {
        vm.prank(user1);
        token.transfer(user2, 50);
        
        assertEq(token.balanceOf(user1), 50);
        assertEq(token.balanceOf(user2), 100);
    }
    
    function testTransferInsufficientBalance() public {
        vm.prank(user1);
        vm.expectRevert("Insufficient balance");
        token.transfer(user2, 200);
    }
    
    function testApproveAndTransferFrom() public {
        vm.prank(user1);
        token.approve(user2, 75);
        
        vm.prank(user2);
        token.transferFrom(user1, user2, 75);
        
        assertEq(token.balanceOf(user1), 25);
        assertEq(token.balanceOf(user2), 125);
    }
}
```

### Fuzz Testing

```solidity
contract FuzzTest is Test {
    Token public token;
    
    function setUp() public {
        token = new Token("Test", "TST", 10000);
    }
    
    function testFuzzTransfer(uint256 amount) public {
        // Bound amount to valid range
        amount = bound(amount, 0, 10000);
        
        token.transfer(address(0x1), amount);
        
        assertEq(token.balanceOf(address(0x1)), amount);
        assertEq(token.balanceOf(address(this)), 10000 - amount);
    }
    
    function testFuzzMultipleTransfers(
        uint256 amount1,
        uint256 amount2
    ) public {
        amount1 = bound(amount1, 0, 5000);
        amount2 = bound(amount2, 0, 5000);
        
        token.transfer(address(0x1), amount1);
        token.transfer(address(0x2), amount2);
        
        assertEq(
            token.balanceOf(address(0x1)) + 
            token.balanceOf(address(0x2)) + 
            token.balanceOf(address(this)),
            10000
        );
    }
}
```

---

## Deployment Guide

### Testnet Deployment

```bash
# Deploy to Goerli
npx hardhat run scripts/deploy.js --network goerli

# Verify contract
npx hardhat verify --network goerli DEPLOYED_ADDRESS "Constructor" "Args"
```

### Mainnet Deployment Checklist

```
Pre-Deployment:
□ All tests passing
□ Audit completed
□ Gas optimization done
□ Constructor arguments ready
□ Admin keys secured

Deployment:
□ Deploy to testnet first
□ Verify source code
□ Set up monitoring
□ Document contract addresses

Post-Deployment:
□ Verify functionality
□ Monitor for issues
□ Update documentation
□ Announce to community
```

---

## Advanced Topics

### Gas Optimization

```solidity
contract GasOptimization {
    // Use appropriate types
    uint8 public smallNumber;    // 8 bits
    uint256 public largeNumber;  // 256 bits
    
    // Pack structs
    struct Packed {
        uint128 a;
        uint128 b;
    }
    
    // Use mappings over arrays for large datasets
    mapping(address => uint256) public balances;
    
    // Cache storage variables
    function efficient() public view returns (uint256) {
        uint256 localValue = balances[msg.sender];
        // Use localValue instead of multiple storage reads
        return localValue * 2;
    }
    
    // Use events instead of storage for data
    event DataLogged(uint256 value);
    
    function logData(uint256 value) public {
        emit DataLogged(value); // Cheaper than storage
    }
}
```

### Oracle Integration

```solidity
// Chainlink Oracle
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceFeed {
    AggregatorV3Interface internal priceFeed;
    
    constructor() {
        priceFeed = AggregatorV3Interface(
            0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        );
    }
    
    function getLatestPrice() public view returns (int256) {
        (
            /* roundID */,
            /* price */,
            /* startedAt */,
            /* updatedAt */,
            /* answeredInRound */
        ) = priceFeed.latestRoundData();
        return price;
    }
}
```

---

*Last Updated: 2024*
