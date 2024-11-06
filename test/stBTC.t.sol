// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/stBTC.sol";

contract stBTCTest is Test {
    stBTC token;
    address owner = address(this);
    address minter = address(0x1234);
    address user = address(0x5678);

    function setUp() public {
        token = new stBTC();
        token.transferOwnership(owner);
        token.setNewMinterContract(minter);
    }

    function testMintByMinter() public {
        vm.prank(minter);
        token.mint(user, 1000 ether);
        assertEq(token.balanceOf(user), 1000 ether);
    }

    function testMintByNonMinter() public {
        vm.expectRevert(abi.encodeWithSelector(stBTC.InvalidMintor.selector, address(this)));
        token.mint(user, 1000 ether);
    }

    function testSetNewMinterContractByOwner() public {
        address newMinter = address(0x9ABC);
        token.setNewMinterContract(newMinter);
        vm.prank(newMinter);
        token.mint(user, 500 ether);
        assertEq(token.balanceOf(user), 500 ether);
    }

    function testSetNewMinterContractByNonOwner() public {
        vm.prank(user);
        vm.expectRevert("Ownable: caller is not the owner");
        token.setNewMinterContract(address(0xDEAD));
    }

    function testSetNewMinterContractToZeroAddress() public {
        vm.expectRevert(stBTC.InvaildAddress.selector);
        token.setNewMinterContract(address(0));
    }

    function testBurn() public {
        vm.prank(minter);
        token.mint(user, 1000 ether);
        vm.prank(user);
        token.burn(500 ether);
        assertEq(token.balanceOf(user), 500 ether);
    }
}
