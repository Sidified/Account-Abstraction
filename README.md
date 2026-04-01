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

## 🧠 Key Learnings

- Deployment infra matters as much as contract logic
- Avoid hardcoding → use config abstraction
- Testing = proving security, not just functionality
- `execute()` is the real power layer of AA wallets

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

