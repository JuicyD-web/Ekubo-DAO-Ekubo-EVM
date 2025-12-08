// SPDX-License-Identifier: ekubo-license-v1.eth
// Copyright (c) 2025 JuicyD-web
// Ekubo Protocol - Licensed under Ekubo DAO Shared Revenue License 1.0
pragma solidity ^0.8.24;

/// @dev Returns whether the price is increasing according to the amount sign and whether the amount is of token1
/// @dev Note this expects that isToken1 only is a 0 or 1
function isPriceIncreasing(int128 amount, bool isToken1) pure returns (bool increasing) {
    assembly ("memory-safe") {
        increasing := xor(isToken1, slt(amount, 0))
    }
}
