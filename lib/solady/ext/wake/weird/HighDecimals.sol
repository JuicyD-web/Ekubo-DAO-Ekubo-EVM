// Copyright (C) 2020 d-xo
// SPDX-License-Identifier: AGPL-3.0-only
// Copyright (c) 2025 JuicyD-web
// Ekubo Protocol - Licensed under Ekubo DAO Shared Revenue License 1.0

pragma solidity >=0.6.12;

import {ERC20} from "./ERC20.sol";

contract HighDecimalToken is ERC20 {
    constructor(uint _totalSupply) ERC20(_totalSupply) public {
        decimals = 50;
    }
}
