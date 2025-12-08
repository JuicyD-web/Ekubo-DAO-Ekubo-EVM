// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

type Bitmap is uint256;

using {nextBelow, nextAbove, isSet, toggle, set, unset, geSetBit, leSetBit} for Bitmap global;

/// @notice Finds the most significant bit position
function _msb(uint256 x) pure returns (uint8 r) {
    unchecked {
        if (x >= 0x100000000000000000000000000000000) { x >>= 128; r += 128; }
        if (x >= 0x10000000000000000) { x >>= 64; r += 64; }
        if (x >= 0x100000000) { x >>= 32; r += 32; }
        if (x >= 0x10000) { x >>= 16; r += 16; }
        if (x >= 0x100) { x >>= 8; r += 8; }
        if (x >= 0x10) { x >>= 4; r += 4; }
        if (x >= 0x4) { x >>= 2; r += 2; }
        if (x >= 0x2) r += 1;
    }
}

/// @notice Finds the least significant bit position
function _lsb(uint256 x) pure returns (uint8 r) {
    unchecked {
        require(x > 0);
        r = 255;
        if (x & type(uint128).max > 0) { r -= 128; } else { x >>= 128; }
        if (x & type(uint64).max > 0) { r -= 64; } else { x >>= 64; }
        if (x & type(uint32).max > 0) { r -= 32; } else { x >>= 32; }
        if (x & type(uint16).max > 0) { r -= 16; } else { x >>= 16; }
        if (x & type(uint8).max > 0) { r -= 8; } else { x >>= 8; }
        if (x & 0xf > 0) { r -= 4; } else { x >>= 4; }
        if (x & 0x3 > 0) { r -= 2; } else { x >>= 2; }
        if (x & 0x1 > 0) { r -= 1; }
    }
}

/// @notice Checks if a bit is set
function isSet(Bitmap self, uint8 bit) pure returns (bool) {
    return (Bitmap.unwrap(self) & (1 << bit)) != 0;
}

/// @notice Toggles a bit (flip 0->1 or 1->0)
function toggle(Bitmap self, uint8 bit) pure returns (Bitmap) {
    return Bitmap.wrap(Bitmap.unwrap(self) ^ (1 << bit));
}

/// @notice Sets a bit to 1
function set(Bitmap self, uint8 bit) pure returns (Bitmap) {
    return Bitmap.wrap(Bitmap.unwrap(self) | (1 << bit));
}

/// @notice Unsets a bit to 0
function unset(Bitmap self, uint8 bit) pure returns (Bitmap) {
    return Bitmap.wrap(Bitmap.unwrap(self) & ~(1 << bit));
}

function nextBelow(Bitmap self, uint8 bit) pure returns (uint8 next, bool exists) {
    unchecked {
        uint256 masked = Bitmap.unwrap(self) & ((1 << bit) - 1);
        exists = masked != 0;
        if (exists) {
            next = _msb(masked);
        }
    }
}

function nextAbove(Bitmap self, uint8 bit) pure returns (uint8 next, bool exists) {
    unchecked {
        uint256 masked = Bitmap.unwrap(self) & ~((1 << (bit + 1)) - 1);
        exists = masked != 0;
        if (exists) {
            next = _lsb(masked);
        }
    }
}
/// @notice Alias for nextBelow - finds greatest bit set below given bit
function geSetBit(Bitmap self, uint8 bit) pure returns (uint8 next, bool exists) {
    return nextBelow(self, bit);
}

/// @notice Alias for nextAbove - finds least bit set above given bit
function leSetBit(Bitmap self, uint8 bit) pure returns (uint8 next, bool exists) {
    return nextAbove(self, bit);
}