// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/utils/name.sol";


contract TestName is Test {
    using StringInYul for string;

    function setUp() public {

    }

/// @dev  It should return hello as string 
    function testName() public {
        string memory hello = "hello";
        assertEq(hello,StringInYul.hello());
    }

}


