// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import {tickToSqrtRatio, sqrtRatioToTick} from "../src/math/ticks.sol";
import {SqrtRatio} from "../src/types/sqrtRatio.sol";

contract TickDebugTest is Test {
    function test_tick_zero() public pure {
        SqrtRatio ratio = tickToSqrtRatio(0);
        uint256 fixedPoint = ratio.toFixed();
        
        // At tick 0, sqrt(1.0001^0) = 1.0, which in Q64.128 is 2^128
        assertEq(fixedPoint, 1 << 128, "Tick 0 should be 2^128");
    }
    
    function test_tick_positive() public pure {
        int32 tick = 10;
        SqrtRatio ratio = tickToSqrtRatio(tick);
        int32 backToTick = sqrtRatioToTick(ratio);
        
        assertEq(backToTick, tick, "Round trip failed for tick 10");
    }
    
    function test_tick_negative() public pure {
        int32 tick = -10;
        SqrtRatio ratio = tickToSqrtRatio(tick);
        int32 backToTick = sqrtRatioToTick(ratio);
        
        assertEq(backToTick, tick, "Round trip failed for tick -10");
    }
    
    function test_tick_range() public pure {
        // Test a few key ticks
        int32[5] memory ticks = [int32(-887272), int32(-100), int32(0), int32(100), int32(887272)];
        
        for (uint i = 0; i < ticks.length; i++) {
            SqrtRatio ratio = tickToSqrtRatio(ticks[i]);
            int32 backToTick = sqrtRatioToTick(ratio);
            assertEq(backToTick, ticks[i], "Round trip failed");
        }
    }
}