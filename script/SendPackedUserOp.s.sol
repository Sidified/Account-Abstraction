// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {PackedUserOperation} from "lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {IEntryPoint} from "lib/account-abstraction/contracts/interfaces/IEntryPoint.sol";
import {MessageHashUtils} from "@openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol";

contract SendPackedUserOp is Script {
    using MessageHashUtils for bytes32;
    function run() public {}

    function generateSignedUserOperation(
        bytes memory callData,
        HelperConfig.NetworkConfig memory config,
        address minimalAccount // (i) add this parameter
    ) public view returns (PackedUserOperation memory) {
        // // 1. Generate an unsigned data
        // uint256 nonce = vm.getNonce(config.account);

        // PackedUserOperation memory userOp = _generateUnsignedUserOperation(callData, config.account, nonce);
        // // 2. Get userOp Hash

        ////////// -------- After Deebugging --------- //////////////

        // [(ii)]. The nonce belongs to the smart contract, not the EOA
        // uint256 nonce = vm.getNonce(minimalAccount); -->> we did thie before but it gave the error. so we will ask the EntryPoint for the nonce of the account using key 0, which is what the account will use for its operations

        // PATRICK did like this -> uint256 nonce = vm.getNonce(minimalAccount) - 1; but it is not a good solution because it relies on the fact that the account has never sent any operations before, which is not a safe assumption. So we will ask the EntryPoint for the nonce of the account using key 0, which is what the account will use for its operations

        // (ii) Ask the EntryPoint for the account's specific UserOp nonce (using key 0)
        uint256 nonce = IEntryPoint(config.entryPoint).getNonce(minimalAccount, 0);

        // (iii). The sender is the smart contract, not config.account
        PackedUserOperation memory userOp = _generateUnsignedUserOperation(callData, minimalAccount, nonce);
        bytes32 userOpHash = IEntryPoint(config.entryPoint).getUserOpHash(userOp);
        bytes32 digest = userOpHash.toEthSignedMessageHash();

        // 3. Sign it and return it
        uint8 v;
        bytes32 r;
        bytes32 s;
        uint256 ANVIL_DEFAULT_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
        if (block.chainid == 31337) {
            (v, r, s) = vm.sign(ANVIL_DEFAULT_KEY, digest);
        } else {
            (v, r, s) = vm.sign(config.account, digest);
        }
        userOp.signature = abi.encodePacked(r, s, v);
        return userOp;
    }

    function _generateUnsignedUserOperation(bytes memory callData, address sender, uint256 nonce)
        internal
        pure
        returns (PackedUserOperation memory)
    {
        uint128 verificationGasLimit = 16777216;
        uint128 callGasLimit = verificationGasLimit;
        uint128 maxPriorityFeePerGas = 256;
        uint128 maxFeePerGas = maxPriorityFeePerGas;

        return PackedUserOperation({
            sender: sender,
            nonce: nonce,
            initCode: hex"",
            callData: callData,
            accountGasLimits: bytes32(uint256(verificationGasLimit) << 128 | uint256(callGasLimit)),
            preVerificationGas: verificationGasLimit,
            gasFees: bytes32(uint256(maxPriorityFeePerGas) << 128 | uint256(maxFeePerGas)),
            paymasterAndData: hex"",
            signature: hex""
        });
    }
}
