# 🧠 Minimal Account Abstraction Wallet (ERC-4337)

> Building a Smart Contract Wallet from scratch to understand the future of Web3 UX.

---

## 🚀 Overview

This project is a **Minimal Smart Contract Wallet** built using the ERC-4337 Account Abstraction standard.

Instead of traditional wallets (EOAs) controlled by private keys, this wallet is a **programmable smart contract** that defines its own validation logic.

The goal of this project is to deeply understand:
- How Account Abstraction works under the hood
- How UserOperations are validated and executed
- How smart contract wallets replace EOAs

---

## ❗ Problem with Traditional Wallets

Current Web3 wallets (EOAs):
- Require managing private keys / seed phrases
- Cannot customize transaction validation
- Require users to hold ETH for gas

This creates a terrible onboarding experience:
> Download wallet → Save seed phrase → Buy ETH → Transfer → Then use app

---

## 💡 What Account Abstraction Solves

Account Abstraction (ERC-4337) enables:

- ✅ Gasless transactions (via Paymasters)
- ✅ Social recovery (no seed phrase dependency)
- ✅ Session keys (better UX for games/apps)
- ✅ Custom authentication (biometrics, multi-sig, etc.)

Instead of:
> “Private key = control”

We move to:
> “Code = control”

---

## 🏗️ Architecture (ERC-4337)

The system works through:

- **UserOperation (UserOp)** → Custom transaction object
- **Bundler** → Packages multiple UserOps
- **EntryPoint** → Central contract that validates + executes
- **Smart Contract Wallet (this project)** → Defines validation logic

Flow:
1. User signs a UserOp
2. Bundler submits it to EntryPoint
3. EntryPoint calls `validateUserOp()`
4. If valid → calls `execute()`

---

## 📦 Current Implementation

### ✅ MinimalAccount.sol

A minimal ERC-4337 compliant smart contract wallet with:

#### 🔐 Signature Validation
- Uses ECDSA to verify owner signature
- Implements `_validateSignature()`

#### 🛡️ EntryPoint Access Control
- Only EntryPoint can call critical functions
- Prevents malicious direct calls

#### ⚡ Execution Engine
- `execute()` enables arbitrary contract calls
- Uses low-level `.call`

#### 💸 Prefunding Gas
- `_payPrefund()` sends ETH to EntryPoint if required

#### 👤 Ownership Model
- Based on OpenZeppelin `Ownable`
- Single owner wallet (for now)

---

## 🧠 Key Learnings So Far

- Account Abstraction separates **validation from execution**
- Transactions are no longer “transactions” → they are **UserOperations**
- Wallet logic becomes fully programmable
- Security heavily depends on `validateUserOp()`

---

## ⚠️ Work In Progress

This project is actively being built in public.

### 🔜 Upcoming Improvements

- [ ] Nonce validation (replay protection)
- [ ] Paymaster integration (gas abstraction)
- [ ] Multi-signature support
- [ ] Session keys implementation
- [ ] zkSync native AA version

---

## 🛠️ Tech Stack

- Solidity ^0.8.24
- Foundry
- OpenZeppelin Contracts
- eth-infinitism Account Abstraction repo

---

## 📅 Build in Public

I’m documenting this journey daily on X (Twitter), sharing:
- Learnings
- Code insights
- Mistakes and breakthroughs

---

## 🤝 Contributions

This is a learning-focused project, but feedback, suggestions, and discussions are always welcome.

---

## 📌 Disclaimer

This is an experimental implementation for learning purposes.  
Do NOT use in production.

---

## 🧩 Inspiration

Account Abstraction is one of the biggest UX unlocks for Web3.

> If Web3 is going to onboard billions, wallets must become invisible.
