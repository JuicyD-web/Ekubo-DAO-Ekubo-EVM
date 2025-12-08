// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

uint256 constant MAX_NUM_VALID_TIMES = 256;
int128 constant MAX_ABS_VALUE_SALE_RATE_DELTA = type(int128).max;

/// @notice Checks if a time is a power of 2
function isTimeValid(uint32 time) pure returns (bool) {
    return time != 0 && (time & (time - 1)) == 0;
}

/// @notice Checks if a time is valid within a range
/// @param time The time to check
/// @param maxTime The maximum allowed time
/// @return True if time is a power of 2 and <= maxTime
function isTimeValid(uint256 time, uint256 maxTime) pure returns (bool) {
    if (time == 0 || time > maxTime) return false;
    return (time & (time - 1)) == 0;
}

/// @notice Gets the next valid time (power of 2) after currentTime
function nextValidTime(uint32 currentTime) pure returns (uint32) {
    unchecked {
        if (currentTime == 0) return 1;
        uint32 next = currentTime << 1;
        return next == 0 ? 0 : next;
    }
}

/// @notice Gets the next valid time within a range
/// @param startTime The start of the range
/// @param endTime The end of the range  
/// @return The next valid time (power of 2) >= startTime and <= endTime
function nextValidTime(uint256 startTime, uint256 endTime) pure returns (uint64) {
    unchecked {
        if (startTime == 0) startTime = 1;
        
        // Find the smallest power of 2 >= startTime
        uint256 nextPow2 = 1;
        while (nextPow2 < startTime && nextPow2 != 0) {
            nextPow2 <<= 1;
        }
        
        // If it's within range, return it
        if (nextPow2 != 0 && nextPow2 <= endTime) {
            return uint64(nextPow2);
        }
        
        // No valid time in range
        return 0;
    }
}

function computeStepSize(uint256 startTime, uint256 endTime) pure returns (uint256 stepSize) {
    require(isTimeValid(uint32(startTime)) && isTimeValid(uint32(endTime)), "Invalid time");
    require(endTime > startTime, "End before start");
    
    unchecked {
        uint256 diff = endTime - startTime;
        
        // Find MSB manually
        uint256 msb = 0;
        uint256 x = diff;
        if (x >= 0x100000000000000000000000000000000) { x >>= 128; msb += 128; }
        if (x >= 0x10000000000000000) { x >>= 64; msb += 64; }
        if (x >= 0x100000000) { x >>= 32; msb += 32; }
        if (x >= 0x10000) { x >>= 16; msb += 16; }
        if (x >= 0x100) { x >>= 8; msb += 8; }
        if (x >= 0x10) { x >>= 4; msb += 4; }
        if (x >= 0x4) { x >>= 2; msb += 2; }
        if (x >= 0x2) msb += 1;
        
        stepSize = 1 << msb;
    }
}