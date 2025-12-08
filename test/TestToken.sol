// SPDX-License-Identifier: ekubo-license-v1.eth
// Copyright (c) 2025 JuicyD-web
// Ekubo Protocol - Licensed under Ekubo DAO Shared Revenue License 1.0
pragma solidity ^0.8.30;

import {ERC20} from "solady/tokens/ERC20.sol";

contract TestToken is ERC20 {
    constructor(address recipient) {
        _mint(recipient, type(uint256).max);
    }

    function name() public pure override returns (string memory) {
        return "TestToken";
    }

    function symbol() public pure override returns (string memory) {
        return "TT";
    }
}
