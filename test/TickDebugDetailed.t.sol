// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import {tickToSqrtRatio, sqrtRatioToTick} from "../src/math/ticks.sol";
import {SqrtRatio} from "../src/types/sqrtRatio.sol";

contract TickDebugDetailedTest is Test {
    function test_debug_tick_10() public {
        int32 tick = 10;
        
        // Convert tick to sqrt ratio
        SqrtRatio ratio = tickToSqrtRatio(tick);
        uint96 ratioRaw = SqrtRatio.unwrap(ratio);
        
        console.log("Tick:", uint256(int256(tick)));
        console.log("SqrtRatio raw:", uint256(ratioRaw));
        console.log("SqrtRatio as hex:");
        console.logBytes32(bytes32(uint256(ratioRaw)));
        
        // Check prefix
        uint256 prefix = uint256(ratioRaw) >> 94;
        console.log("Prefix (bits 95-94):", prefix);
        
        // Convert to fixed point
        uint256 fixedPoint = ratio.toFixed();
        console.log("FixedPoint:");
        console.logBytes32(bytes32(fixedPoint));
        console.log("FixedPoint decimal:", fixedPoint);
        
        // Expected: 1.00049987 * 2^128
        // Approximate as 1 << 128 for comparison
        uint256 oneShl128 = 1 << 128;
        console.log("1 << 128:", oneShl128);
        
        // Convert back to tick
        int32 backToTick = sqrtRatioToTick(ratio);
        console.log("Back to tick:", uint256(int256(backToTick)));
        
        assertEq(backToTick, tick, "Round trip failed");
    }
}
