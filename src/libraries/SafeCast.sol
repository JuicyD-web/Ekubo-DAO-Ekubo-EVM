// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title SafeCast
/// @notice Safe type casting library
library SafeCast {
    /// @notice Cast a uint256 to a uint160, revert on overflow
    function toUint160(uint256 y) internal pure returns (uint160 z) {
        require((z = uint160(y)) == y);
    }

    /// @notice Cast a int256 to a int128, revert on overflow
    function toInt128(int256 y) internal pure returns (int128 z) {
        require((z = int128(y)) == y);
    }

    /// @notice Cast a uint256 to a int256, revert on overflow
    function toInt256(uint256 y) internal pure returns (int256 z) {
        require(y < 2**255);
        z = int256(y);
    }
}
