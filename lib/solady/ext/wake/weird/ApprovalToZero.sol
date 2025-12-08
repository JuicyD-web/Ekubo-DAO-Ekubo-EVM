// Copyright (C) 2020 d-xo
// SPDX-License-Identifier: AGPL-3.0-only
// Copyright (c) 2025 JuicyD-web
// Ekubo Protocol - Licensed under Ekubo DAO Shared Revenue License 1.0

pragma solidity >=0.6.12;

import {ERC20} from "./ERC20.sol";

contract ApprovalToZeroToken is ERC20 {
    // --- Init ---
    constructor(uint _totalSupply) ERC20(_totalSupply) public {}

    // --- Token ---
    function approve(address usr, uint wad) override public returns (bool) {
        require(usr != address(0), "no approval for the zero address");
        return super.approve(usr, wad);
    }
}
