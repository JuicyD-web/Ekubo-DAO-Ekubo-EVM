// SPDX-License-Identifier: ekubo-license-v1.eth
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/Core.sol";
import "../src/Router.sol";
import "../src/interfaces/ICore.sol";

contract DeployScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        // Deploy Core contract
        Core core = new Core();

        // Deploy Router contract, passing Core as ICore
        Router router = new Router(core);

        // Output deployed addresses
        console.log("Core deployed at:", address(core));
        console.log("Router deployed at:", address(router));

        vm.stopBroadcast();
    }
}
