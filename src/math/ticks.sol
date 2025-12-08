// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {SqrtRatio, toSqrtRatio} from "../types/sqrtRatio.sol";

// Ekubo uses extended tick range (100x larger than Uniswap v3)
int32 constant MIN_TICK = -88722835;
int32 constant MAX_TICK = 88722835;

error InvalidTick(int32 tick);

/// @notice Calculates sqrt(1.0001^tick) in compact SqrtRatio format
function tickToSqrtRatio(int32 tick) pure returns (SqrtRatio sqrtRatio) {
    if (tick < MIN_TICK || tick > MAX_TICK) revert InvalidTick(tick);
    
    uint256 absTick = tick < 0 ? uint256(uint32(-tick)) : uint256(uint32(tick));
    
    // Compute sqrt(1.0001^|tick|) using bit-by-bit multiplication in Q128 format
    uint256 ratio = absTick & 0x1 != 0 ? 0xfffcb933bd6fad37aa2d162d1a594001 : 0x100000000000000000000000000000000;
    if (absTick & 0x2 != 0) ratio = (ratio * 0xfff97272373d413259a46990580e213a) >> 128;
    if (absTick & 0x4 != 0) ratio = (ratio * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128;
    if (absTick & 0x8 != 0) ratio = (ratio * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128;
    if (absTick & 0x10 != 0) ratio = (ratio * 0xffcb9843d60f6159c9db58835c926644) >> 128;
    if (absTick & 0x20 != 0) ratio = (ratio * 0xff973b41fa98c081472e6896dfb254c0) >> 128;
    if (absTick & 0x40 != 0) ratio = (ratio * 0xff2ea16466c96a3843ec78b326b52861) >> 128;
    if (absTick & 0x80 != 0) ratio = (ratio * 0xfe5dee046a99a2a811c461f1969c3053) >> 128;
    if (absTick & 0x100 != 0) ratio = (ratio * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128;
    if (absTick & 0x200 != 0) ratio = (ratio * 0xf987a7253ac413176f2b074cf7815e54) >> 128;
    if (absTick & 0x400 != 0) ratio = (ratio * 0xf3392b0822b70005940c7a398e4b70f3) >> 128;
    if (absTick & 0x800 != 0) ratio = (ratio * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128;
    if (absTick & 0x1000 != 0) ratio = (ratio * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128;
    if (absTick & 0x2000 != 0) ratio = (ratio * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128;
    if (absTick & 0x4000 != 0) ratio = (ratio * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128;
    if (absTick & 0x8000 != 0) ratio = (ratio * 0x31be135f97d08fd981231505542fcfa6) >> 128;
    if (absTick & 0x10000 != 0) ratio = (ratio * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128;
    if (absTick & 0x20000 != 0) ratio = (ratio * 0x5d6af8dedb81196699c329225ee604) >> 128;
    if (absTick & 0x40000 != 0) ratio = (ratio * 0x2216e584f5fa1ea926041bedfe98) >> 128;
    if (absTick & 0x80000 != 0) ratio = (ratio * 0x48a170391f7dc42444e8fa2) >> 128;
    
    // Additional multipliers for extended tick range
    if (absTick & 0x100000 != 0) ratio = (ratio * 0x149b34ee7ac262) >> 128;
    if (absTick & 0x200000 != 0) ratio = (ratio * 0x2f45ed6f) >> 128;
    if (absTick & 0x400000 != 0) ratio = (ratio * 0x8cdb) >> 128;
    if (absTick & 0x800000 != 0) ratio = (ratio * 0x9) >> 128;
    if (absTick & 0x1000000 != 0) ratio = (ratio * 0x3) >> 128;
    if (absTick & 0x2000000 != 0) ratio = (ratio * 0x1) >> 128;
    if (absTick & 0x4000000 != 0) ratio = (ratio * 0x1) >> 128;

    // Invert if tick is positive (multipliers compute 1/sqrt(1.0001^tick))
    if (tick > 0) {
        ratio = type(uint256).max / ratio;
    }

    // ratio is now in Q128 format (128 bits fractional)
    // Convert to 64.128 format by keeping as-is, then convert to compact SqrtRatio
    sqrtRatio = toSqrtRatio(ratio, false);
}

function sqrtRatioToTick(SqrtRatio sqrtRatio) pure returns (int32 tick) {
    // toFixed() returns 64.128 format (192 bits total: 64 integer, 128 fractional)
    uint256 sqrtRatioX128 = sqrtRatio.toFixed();
    
    uint256 ratio = sqrtRatioX128;
    
    // Find most significant bit
    uint256 r = ratio;
    uint256 msb = 0;

    assembly {
        let f := shl(7, gt(r, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
        msb := or(msb, f)
        r := shr(f, r)
    }
    assembly {
        let f := shl(6, gt(r, 0xFFFFFFFFFFFFFFFF))
        msb := or(msb, f)
        r := shr(f, r)
    }
    assembly {
        let f := shl(5, gt(r, 0xFFFFFFFF))
        msb := or(msb, f)
        r := shr(f, r)
    }
    assembly {
        let f := shl(4, gt(r, 0xFFFF))
        msb := or(msb, f)
        r := shr(f, r)
    }
    assembly {
        let f := shl(3, gt(r, 0xFF))
        msb := or(msb, f)
        r := shr(f, r)
    }
    assembly {
        let f := shl(2, gt(r, 0xF))
        msb := or(msb, f)
        r := shr(f, r)
    }
    assembly {
        let f := shl(1, gt(r, 0x3))
        msb := or(msb, f)
        r := shr(f, r)
    }
    assembly {
        let f := gt(r, 0x1)
        msb := or(msb, f)
    }

    // Calculate log2(ratio) in Q64.64 format
    int256 log_2;
    if (msb >= 128) {
        r = ratio >> (msb - 127);
        log_2 = int256(msb - 128) << 64;
    } else {
        r = ratio << (127 - msb);
        log_2 = -(int256(128 - msb) << 64);
    }

    // Refine log2 with binary search (14 iterations for precision)
    assembly {
        r := shr(127, mul(r, r))
        let f := shr(128, r)
        log_2 := or(log_2, shl(63, f))
        r := shr(f, r)
    }
    assembly {
        r := shr(127, mul(r, r))
        let f := shr(128, r)
        log_2 := or(log_2, shl(62, f))
        r := shr(f, r)
    }
    assembly {
        r := shr(127, mul(r, r))
        let f := shr(128, r)
        log_2 := or(log_2, shl(61, f))
        r := shr(f, r)
    }
    assembly {
        r := shr(127, mul(r, r))
        let f := shr(128, r)
        log_2 := or(log_2, shl(60, f))
        r := shr(f, r)
    }
    assembly {
        r := shr(127, mul(r, r))
        let f := shr(128, r)
        log_2 := or(log_2, shl(59, f))
        r := shr(f, r)
    }
    assembly {
        r := shr(127, mul(r, r))
        let f := shr(128, r)
        log_2 := or(log_2, shl(58, f))
        r := shr(f, r)
    }
    assembly {
        r := shr(127, mul(r, r))
        let f := shr(128, r)
        log_2 := or(log_2, shl(57, f))
        r := shr(f, r)
    }
    assembly {
        r := shr(127, mul(r, r))
        let f := shr(128, r)
        log_2 := or(log_2, shl(56, f))
        r := shr(f, r)
    }
    assembly {
        r := shr(127, mul(r, r))
        let f := shr(128, r)
        log_2 := or(log_2, shl(55, f))
        r := shr(f, r)
    }
    assembly {
        r := shr(127, mul(r, r))
        let f := shr(128, r)
        log_2 := or(log_2, shl(54, f))
        r := shr(f, r)
    }
    assembly {
        r := shr(127, mul(r, r))
        let f := shr(128, r)
        log_2 := or(log_2, shl(53, f))
        r := shr(f, r)
    }
    assembly {
        r := shr(127, mul(r, r))
        let f := shr(128, r)
        log_2 := or(log_2, shl(52, f))
        r := shr(f, r)
    }
    assembly {
        r := shr(127, mul(r, r))
        let f := shr(128, r)
        log_2 := or(log_2, shl(51, f))
        r := shr(f, r)
    }
    assembly {
        r := shr(127, mul(r, r))
        let f := shr(128, r)
        log_2 := or(log_2, shl(50, f))
    }

    // Convert log2(sqrtPrice) to log_sqrt(1.0001) = log2(sqrtPrice) / log2(sqrt(1.0001))
    // log2(sqrt(1.0001)) = 0.5 * log2(1.0001) ≈ 0.5 * 0.0001442695...
    int256 log_sqrt10001 = log_2 * 255738958999603826347141; // Constant for conversion

    // Get tick boundaries
    int24 tickLow = int24((log_sqrt10001 - 3402992956809132418596140100660247210) >> 128);
    int24 tickHi = int24((log_sqrt10001 + 291339464771989622907027621153398088495) >> 128);

    // Choose correct tick by comparing sqrt ratios
    tick = tickLow == tickHi ? tickLow : (tickToSqrtRatio(int32(tickHi)).toFixed() <= sqrtRatioX128 ? tickHi : tickLow);
    
    // Clamp to valid range
    if (tick < MIN_TICK) tick = MIN_TICK;
    if (tick > MAX_TICK) tick = MAX_TICK;
}