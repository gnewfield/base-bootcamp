// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Script} from "forge-std/Script.sol";

import {ImportsExercise} from "../src/ImportsExercise.sol";

contract DeployImportsExercise is Script {

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        ImportsExercise importsExercise = new ImportsExercise();

        vm.stopBroadcast();
    }
}
