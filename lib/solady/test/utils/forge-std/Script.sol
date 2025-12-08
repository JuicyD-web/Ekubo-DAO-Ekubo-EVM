// SPDX-License-Identifier: MIT
// Copyright (c) 2025 JuicyD-web
// Ekubo Protocol - Licensed under Ekubo DAO Shared Revenue License 1.0
pragma solidity >=0.6.0 <0.9.0;

import "./Vm.sol";

abstract contract Script {
    bool public IS_SCRIPT = true;

    /// @dev `address(bytes20(uint160(uint256(keccak256("hevm cheat code")))))`.
    Vm public constant vm = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
}
