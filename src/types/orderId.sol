// SPDX-License-Identifier: ekubo-license-v1.eth
// Copyright (c) 2025 JuicyD-web
// Ekubo Protocol - Licensed under Ekubo DAO Shared Revenue License 1.0
pragma solidity ^0.8.24;

/// @notice Unique identifier for a TWAMM order
/// @dev Wraps bytes32 to provide type safety for order identifiers
type OrderId is bytes32;
