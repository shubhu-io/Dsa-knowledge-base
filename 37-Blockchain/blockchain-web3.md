# Web3 Development Guide

This document covers Web3 development concepts, tools, and best practices.

## What is Web3?

Web3 refers to the next generation of the internet, built on decentralized technologies like blockchain. It emphasizes user ownership, decentralization, and token-based economics.

## Core Concepts

### Decentralized Applications (DApps)
Applications that run on peer-to-peer networks rather than centralized servers.

**Key Characteristics:**
- Open source code
- Decentralized storage
- Token-based economics
- Community governance

### Smart Contracts
Self-executing contracts with terms directly written into code.

**Features:**
- Immutable once deployed
- Transparent and verifiable
- Automatically execute when conditions are met
- No intermediaries needed

### Tokens and NFTs
- **Fungible Tokens**: Interchangeable (e.g., ETH, USDC)
- **Non-Fungible Tokens (NFTs)**: Unique digital assets

## Development Environment

### Ethereum Development Stack
1. **Solidity**: Smart contract language
2. **Hardhat**: Development framework
3. **Ethers.js**: JavaScript library
4. **OpenZeppelin**: Contract library
5. **IPFS**: Decentralized storage

### Setting Up Hardhat Project
```bash
# Initialize project
mkdir my-dapp && cd my-dapp
npm init -y

# Install Hardhat
npm install --save-dev hardhat

# Initialize Hardhat
npx hardhat init

# Install dependencies
npm install @openzeppelin/contracts
npm install ethers
```

## Smart Contract Development

### Basic Solidity Contract
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStorage {
    uint256 private storedValue;
    address public owner;
    
    event ValueChanged(uint256 newValue);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    
    constructor(uint256 initialValue) {
        storedValue = initialValue;
        owner = msg.sender;
    }
    
    function getValue() public view returns (uint256) {
        return storedValue;
    }
    
    function setValue(uint256 newValue) public onlyOwner {
        storedValue = newValue;
        emit ValueChanged(newValue);
    }
}
```

### ERC-20 Token Contract
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable {
    constructor(uint256 initialSupply) ERC20("MyToken", "MTK") {
        _mint(msg.sender, initialSupply);
    }
    
    function mint(uint256 amount) public onlyOwner {
        _mint(msg.sender, amount);
    }
}
```

### ERC-721 NFT Contract
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, ERC721URIStorage, Ownable {
    uint256 private _tokenIdCounter;
    
    constructor() ERC721("MyNFT", "MNFT") {}
    
    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter;
        _tokenIdCounter++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }
}
```

## Testing Smart Contracts

### Hardhat Tests
```javascript
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("SimpleStorage", function () {
  let simpleStorage;
  let owner;

  beforeEach(async function () {
    [owner] = await ethers.getSigners();
    const SimpleStorage = await ethers.getContractFactory("SimpleStorage");
    simpleStorage = await SimpleStorage.deploy(100);
    await simpleStorage.deployed();
  });

  it("Should store and retrieve value", async function () {
    expect(await simpleStorage.getValue()).to.equal(100);
    
    await simpleStorage.setValue(200);
    expect(await simpleStorage.getValue()).to.equal(200);
  });

  it("Should only allow owner to set value", async function () {
    const [, other] = await ethers.getSigners();
    await expect(simpleStorage.connect(other).setValue(200)).to.be.revertedWith("Not owner");
  });
});
```

## Deployment

### Hardhat Configuration
```javascript
// hardhat.config.js
require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  solidity: "0.8.19",
  networks: {
    goerli: {
      url: process.env.GOERLI_RPC_URL,
      accounts: [process.env.PRIVATE_KEY]
    },
    mainnet: {
      url: process.env.MAINNET_RPC_URL,
      accounts: [process.env.PRIVATE_KEY]
    }
  }
};
```

### Deployment Script
```javascript
// scripts/deploy.js
async function main() {
  const SimpleStorage = await ethers.getContractFactory("SimpleStorage");
  const simpleStorage = await SimpleStorage.deploy(100);
  await simpleStorage.deployed();
  
  console.log("SimpleStorage deployed to:", simpleStorage.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
```

## Frontend Integration

### Connecting Wallet
```javascript
// Connect MetaMask
async function connectWallet() {
  if (typeof window.ethereum !== 'undefined') {
    const accounts = await window.ethereum.request({ 
      method: 'eth_requestAccounts' 
    });
    console.log('Connected:', accounts[0]);
  } else {
    console.log('Please install MetaMask');
  }
}
```

### Reading from Contract
```javascript
import { ethers } from 'ethers';

const contractAddress = "0x...";
const abi = [...];

const provider = new ethers.providers.Web3Provider(window.ethereum);
const contract = new ethers.Contract(contractAddress, abi, provider);

const value = await contract.getValue();
console.log("Current value:", value.toString());
```

### Writing to Contract
```javascript
const signer = provider.getSigner();
const contractWithSigner = contract.connect(signer);

const tx = await contractWithSigner.setValue(200);
await tx.wait();

console.log("Transaction mined:", tx.hash);
```

## DeFi Concepts

### Decentralized Exchanges (DEX)
- **Automated Market Makers (AMM)**: Uniswap, SushiSwap
- **Order Books**: IDEX, 0x Protocol

### Lending Protocols
- **Aave**: Lend and borrow crypto
- **Compound**: Algorithmic interest rates

### Yield Farming
- Providing liquidity to earn rewards
- Stake tokens for yield

## Security Best Practices

### Smart Contract Security
1. **Use established patterns**: OpenZeppelin libraries
2. **Audit your code**: Professional security audits
3. **Test thoroughly**: Unit tests, integration tests
4. **Bug bounty programs**: Incentivize vulnerability discovery

### Common Vulnerabilities
- **Reentrancy**: External calls before state changes
- **Integer overflow**: Use Solidity 0.8+ or SafeMath
- **Access control**: Proper modifier usage
- **Front-running**: MEV protection

### Security Tools
- **Slither**: Static analysis
- **Mythril**: Symbolic execution
- **Echidna**: Fuzzing

## Gas Optimization

### Techniques
1. **Use appropriate data types**: uint256 vs smaller types
2. **Minimize storage writes**: Cache in memory
3. **Batch operations**: Multiple operations in one transaction
4. **Use events**: For historical data

### Gas Estimation
```javascript
// Estimate gas for transaction
const gasEstimate = await contract.estimateGas.setValue(200);
console.log("Gas estimate:", gasEstimate.toString());
```

## Resources

### Learning Resources
- **CryptoZombies**: Learn Solidity through games
- **Ethereum.org**: Official documentation
- **Hardhat Documentation**: Development framework docs
- **OpenZeppelin Docs**: Contract library

### Development Tools
- **Remix IDE**: Online Solidity editor
- **Hardhat**: Development framework
- **Truffle**: Alternative framework
- **Ganache**: Local blockchain

### Community
- **Ethereum Stack Exchange**: Q&A forum
- **ETHGlobal**: Hackathons and events
- **Developer Discord**: Real-time discussions

## See Also

- [[blockchain-guide]]
- [[blockchain-technology]]
- [[blockchain-smart-contracts]]
- [[blockchain-interview-questions]]
