// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {JPY20Token} from "../src/JPY-20.sol";

contract JPY20TokenTest is Test {
    JPY20Token public token;

    function setUp() public {
        token = new JPY20Token(vm.addr(1));
    }

    function test_mint(address addr) public {
        token.addMinterRole(addr);
        token.mint(addr, (1.0 * 10) ^ token.decimals());
        assertEq(token.balanceOf(addr), (1.0 * 10) ^ token.decimals());
    }

    function test_name() public view {
        assertEq(token.name(), "JPY20Token");
    }

    function test_symbol() public view {
        assertEq(token.symbol(), "JPYT");
    }
}
