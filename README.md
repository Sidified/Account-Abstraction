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

---

## ⚡ zkSync Native Account Abstraction

Exploring Account Abstraction at the **protocol level** using zkSync.

Unlike Ethereum (ERC-4337), zkSync has AA built directly into the network.

---

### 🌍 Architectural Shift

Ethereum (ERC-4337):
- Uses Bundlers, Alt-Mempool, EntryPoint contract
- AA is implemented as an overlay system

zkSync (Native AA):
- No Bundlers
- No Alt-Mempool
- No EntryPoint contract
- Handled directly by the protocol (Bootloader)

---

### 🧠 Unified Account Model

- Every account is a **smart contract by default**
- Even EOAs are represented as smart contracts internally
- Enables full programmability at the base layer

---

---

## 🧩 zkSync Native AA Implementation (Completed)

Fully implemented a minimal zkSync Smart Contract Wallet (`ZkMinimalAccount.sol`) following the `IAccount` interface.

---

### 🚦 TxType 113 Lifecycle (Deep Dive)

A zkSync AA transaction follows a strict 2-phase lifecycle:

#### Phase 1: Validation (API Client)
- Nonce checked via `NonceHolder`
- `validateTransaction()` called
- Nonce must be incremented manually
- Wallet balance verified for gas
- Bootloader ensures fee coverage

#### Phase 2: Execution (Sequencer)
- `executeTransaction()` triggered
- Payload executed on-chain
- Optional Paymaster post-processing

---

### 🔒 Bootloader-Centric Security

- `validateTransaction`, `payForTransaction` restricted to Bootloader
- Prevents unauthorized access to critical wallet logic
- Ensures protocol-level trust boundaries

---

### 🧮 Nonce Management via System Contracts

- Manual nonce handling required
- Uses `NonceHolder` system contract
- Integrated via `SystemContractsCaller`

---

### 🔐 Validation Engine (zkSync)

Implemented full validation logic:

- Nonce increment via system call  
- Balance check using `totalRequiredBalance()`  
- Signature verification using ECDSA  
- Returns required magic value for Bootloader  

---

### ⚙️ Execution Engine (zkSync)

Implemented dynamic execution routing:

#### Path A: System Contracts
- Uses `SystemContractsCaller`
- Required for contract deployment

#### Path B: Standard Contracts
- Uses low-level assembly `call`
- Ensures compatibility with zkEVM execution model

---

### 💸 Gas Payment Handling

Implemented `payForTransaction()`:

- Uses helper:
  ```
  _transaction.payToTheBootloader()
  ```
- Transfers gas fee directly to Bootloader

---

### 🚪 External Execution Support

Implemented `executeTransactionFromOutside()`:

- Allows third-party execution of pre-signed transactions
- Re-validates signature internally
- Enables flexible UX patterns (relayers, meta-transactions)

---

### ♻️ Contract Refactoring (DRY)

Improved modularity via internal helpers:

- `_validateTransaction()` → shared validation logic  
- `_executeTransaction()` → shared execution routing  

---

### 🧠 Key zkSync Learnings

- Validation and execution are strictly separated
- System contracts replace core protocol logic
- Bootloader acts as the central orchestrator
- Developers must manually handle nonce + gas logic
- Native AA is significantly cleaner than ERC-4337

---


---

## 🧠 Key Learnings

- Deployment infra matters as much as contract logic
- Avoid hardcoding → use config abstraction
- Testing = proving security, not just functionality
- `execute()` is the real power layer of AA wallets
- Debugging at the EVM level is essential for complex protocols like ERC-4337
- Protocol-level abstraction (zkSync) is fundamentally cleaner than application-layer abstraction (ERC-4337)
- zkSync exposes protocol internals to developers, requiring system-level thinking
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

