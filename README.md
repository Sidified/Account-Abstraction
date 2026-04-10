# 🧠 Account Abstraction Wallets (ERC-4337 + zkSync Native AA)

> Building Smart Contract Wallets from scratch — from Ethereum’s ERC-4337 to zkSync’s native Account Abstraction.

---

## 🚀 Overview

This project explores **Account Abstraction (AA)** at both:

- **Application Layer (Ethereum - ERC-4337)**
- **Protocol Layer (zkSync Native AA)**

The goal is to deeply understand:
- How smart contract wallets work
- How transactions are validated and executed
- How different AA architectures compare

---

## ❗ Why Account Abstraction Matters

Traditional wallets (EOAs):
- Depend on private keys
- Require ETH for gas
- Have poor UX (seed phrases, onboarding friction)

Account Abstraction changes this:

> Control shifts from **private keys → programmable logic**

This enables:
- Gasless transactions
- Social recovery
- Session keys
- Custom authentication
- Better UX for mass adoption

---

# 🏗️ Part 1: Ethereum (ERC-4337)

## Architecture

ERC-4337 introduces AA as an overlay system:

- **UserOperation (UserOp)** → Custom transaction object  
- **Bundler** → Submits UserOps  
- **EntryPoint** → Validates + executes  
- **Smart Wallet** → Defines validation logic  

### Flow:
1. User signs a UserOp  
2. Bundler submits it  
3. EntryPoint calls `validateUserOp()`  
4. If valid → `execute()`  

---

## 🧩 Minimal Smart Wallet (`MinimalAccount.sol`)

### Features:
- ECDSA signature validation  
- EntryPoint-only access control  
- Arbitrary execution via `.call`  
- Gas prefunding support  
- Ownable access control  

---

## ⚙️ UserOperation Pipeline

Implemented full pipeline:

- Construct UserOp  
- Pack gas fields (bitwise ops)  
- Generate hash via EntryPoint  
- Sign using EIP-191  
- Submit via `handleOps()`  

---

## 🧪 Testing & Debugging

- Full integration testing with Foundry  
- Debugged:
  - Invalid sender issues  
  - Nonce mismatches (AA25)  
- Learned:
  > UserOps ≠ Transactions (completely different mental model)

---

# ⚡ Part 2: zkSync Native Account Abstraction

## 🧠 Key Difference

| Ethereum (4337) | zkSync |
|----------------|--------|
| Overlay system | Native system |
| EntryPoint     | Bootloader |
| Bundlers       | Sequencer |
| Complex flow   | Direct flow |

---

## 🌍 Native AA Model

- Every account is a smart contract  
- No EOAs at protocol level  
- No EntryPoint or Bundlers  
- AA handled directly by the protocol  

---

## 🪪 Transaction Type

- Uses **TxType 113 (0x71)**
- Routed through Bootloader

---

## 🔄 Transaction Lifecycle

### Phase 1: Validation
- Nonce checked via `NonceHolder`
- `validateTransaction()` called
- Signature verified
- Balance checked

### Phase 2: Execution
- `executeTransaction()` called
- Payload executed
- State updated

---

## 🧩 ZkMinimalAccount Implementation

Implemented full wallet:

### 🔐 Validation
- Manual nonce handling (system contract)
- Signature verification (ECDSA)
- Balance validation
- Returns protocol magic value

### ⚙️ Execution
- Handles:
  - System contract calls
  - Standard contract calls (assembly)
- Supports deployment via `ContractDeployer`

### 💸 Gas Handling
- `payForTransaction()` → pays Bootloader directly

### 🔁 External Execution
- `executeTransactionFromOutside()`
- Enables meta-transactions / relayers

---

## 🏛️ System Contracts

zkSync replaces protocol logic with contracts:

- `NonceHolder` → nonce management  
- `ContractDeployer` → deployment  
- Bootloader → execution engine  

> The protocol itself becomes programmable

---

## 🧪 Key Debugging Learnings

- Signature logic differs from Ethereum (no EIP-191)  
- Nonce must be manually incremented  
- Must use:
  ```solidity
  incrementMinNonceIfEquals
  ```
- Returning correct magic value is critical  
- Debugging often requires EVM-level tracing  

---

# 🧠 Key Takeaways

- Account Abstraction = Validation + Execution + Gas + Infra  
- ERC-4337 simulates AA → zkSync implements it natively  
- Protocol-level AA is significantly cleaner  
- Debugging AA requires system-level thinking  



---

# 🛠️ Tech Stack

- Solidity ^0.8.24  
- Foundry  
- OpenZeppelin  
- eth-infinitism (ERC-4337)  
- zkSync Era Contracts  

---

# 📌 Disclaimer

This project is for learning and experimentation.  
Not production-ready.


---

# 🔥 Final Thought

> If Web3 is going to onboard billions,  
> wallets must become programmable.

Account Abstraction is that shift.

# 🤝 Connect & Collaborate

I'm actively seeking opportunities to contribute to Web3 projects and collaborate with other developers. Whether you're:
- 👨‍💼 A company looking for smart contract developers
- 🎓 A learner wanting to discuss these concepts
- 🛠️ A developer interested in collaboration
- 🔍 A recruiter evaluating technical skills

**Let's connect!**

- 💼 **LinkedIn:** [Siddharth Choudhary](https://www.linkedin.com/in/siddharth-choudhary-797391215/)
- 🐦 **X/Twitter:** [Sid_Hary_](https://x.com/Sid_Hary_)
- 📧 **Email:** sidforwork46@gmail.com


## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

## 🤝 Acknowledgements

* **Cyfrin Updraft** for the foundational knowledge.