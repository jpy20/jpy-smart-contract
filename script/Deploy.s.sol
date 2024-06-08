// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/JPY-20.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        JPY20Token token = new JPY20Token(msg.sender);

        vm.stopBroadcast();
    }
}

