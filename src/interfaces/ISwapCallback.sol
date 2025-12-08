// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title ISwapCallback
/// @notice Callback interface for swap execution
interface ISwapCallback {
    /// @notice Called by the pool after a swap
    /// @param amount0Delta The change in token0 balance (positive = owed to pool)
    /// @param amount1Delta The change in token1 balance (positive = owed to pool)
    /// @param data Arbitrary data passed through the swap
    function ekuboSwapCallback(
        int256 amount0Delta,
        int256 amount1Delta,
        bytes calldata data
    ) external;
}
