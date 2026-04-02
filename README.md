# 🧠 Minimal Account Abstraction Wallet (ERC-4337)

> Building a Smart Contract Wallet from scratch to understand the future of Web3 UX.

---

## 🚀 Overview

This project is a **Minimal Smart Contract Wallet** built using the ERC-4337 Account Abstraction standard.

Instead of traditional wallets (EOAs) controlled by private keys, this wallet is a **programmable smart contract** that defines its own validation logic.

---

## 💡 Why This Matters

Account Abstraction solves one of Web3’s biggest problems: **UX**.

Instead of:
→ Private key = control

We move to:
→ Code = control

This enables:
- Gas abstraction
- Social recovery
- Session keys
- Custom authentication

---

## 🏗️ Architecture (ERC-4337)

Flow:
1. User signs a **UserOperation**
2. Bundler submits it
3. EntryPoint validates (`validateUserOp`)
4. Wallet executes (`execute`)

---

## 📦 Current Implementation

### 🔹 Smart Contract Wallet (`MinimalAccount.sol`)

- Signature validation (ECDSA)
- EntryPoint-only access control
- Execution engine via `.call`
- Prefunding gas logic
- Ownable-based access control

---



### 🧠 Deployment Infrastructure

Built a **modular deployment architecture** using Foundry scripts:

#### 1. HelperConfig.s.sol
- Dynamically selects config based on `chainId`
- Stores:
  - EntryPoint address
  - Deployment account
- Removes need for hardcoding addresses

#### 2. DeployMinimal.s.sol
- Fetches config from HelperConfig
- Deploys `MinimalAccount`
- Automatically handles ownership transfer

👉 This makes deployment **network-agnostic + scalable**

---

### 🧪 Testing the Execution Engine

Implemented unit tests using Foundry:

#### ✅ Positive Test
- Owner successfully calls `execute()`
- Wallet interacts with ERC20Mock (mint)
- Confirms correct execution

#### 🛑 Negative Test
- Random user attempts execution
- Transaction reverts as expected
- Confirms access control is secure

---

### 🧩 UserOperation (UserOp) Construction

Implemented full scripting logic to generate ERC-4337 UserOperations:

- Built `SendPackedUserOp.s.sol`
- Generates **unsigned UserOp**
- Packs gas fields using bitwise operations
- Dynamically fetches nonce

#### ⚙️ Key Concepts:
- Bitwise packing (`<<`, `|`) for gas efficiency
- Struct-based transaction model (UserOp ≠ traditional tx)
- Separation of signing logic from contract logic

---

### ✍️ Signing & Hashing UserOps

Implemented cryptographic signing flow matching EntryPoint expectations:

- Uses `EntryPoint.getUserOpHash()`
- Applies EIP-191 signing standard
- Signs via `vm.sign` (Foundry)

#### 🔐 Security Details:
- Includes:
  - EntryPoint address
  - Chain ID  
→ prevents replay attacks across chains

---

### 🔀 Cross-Environment Compatibility

Handled differences between:

- Local (Anvil)
- Testnet (Sepolia)

#### Solution:
- Conditional signing logic based on `chainId`
- Uses:
  - Hardcoded Anvil key (local)
  - Config-based key (testnet)

---

### 🧪 Full ERC-4337 Flow Testing

Implemented full integration tests simulating:

→ Bundler → EntryPoint → Smart Wallet → Target Contract

#### Flow Verified:
1. Generate signed UserOp  
2. Fund wallet for gas  
3. Call `handleOps()`  
4. EntryPoint validates + executes  

---

### 🐞 Debugging & Fixes

Used Foundry debugger to trace EVM-level failures:

#### ❌ Bug 1: Wrong `sender`
- Used EOA instead of Smart Contract Wallet  
- Fixed by passing wallet address into UserOp  

#### ❌ Bug 2: Invalid Nonce (AA25)
- Foundry nonce mismatch  
- Fixed using:
```solidity
nonce = vm.getNonce(account) - 1;
```

---

### ✅ Result

Successfully executed full ERC-4337 flow locally:

- UserOp → validated  
- EntryPoint → executed  
- Wallet → interacted with external contract  

---

## 🧠 Key Learnings

- Deployment infra matters as much as contract logic
- Avoid hardcoding → use config abstraction
- Testing = proving security, not just functionality
- `execute()` is the real power layer of AA wallets
- Debugging at the EVM level is essential for complex protocols like ERC-4337

---

## ⚠️ Work In Progress

- [ ] Nonce validation
- [ ] Full UserOp flow testing
- [ ] Paymaster integration
- [ ] Session keys
- [ ] zkSync native AA implementation

---

## 🛠️ Tech Stack

- Solidity ^0.8.24
- Foundry
- OpenZeppelin
- eth-infinitism (ERC-4337)

---


## 📌 Disclaimer

This is a learning project. Not production-ready.

---

