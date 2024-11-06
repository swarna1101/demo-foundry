// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/stBTC.sol";

contract stBTCScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        // Deploy the stBTC contract
        stBTC token = new stBTC();

        // Set a new minter contract address with the correct checksum
        address minterContract = address(0x1234567890AbcdEF1234567890aBcdef12345678);
        token.setNewMinterContract(minterContract);

        // Log the address of the deployed contract and minter contract
        console.log("stBTC deployed at:", address(token));
        console.log("Minter contract set to:", minterContract);

        vm.stopBroadcast();
    }
}
