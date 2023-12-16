// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Script} from "forge-std/Script.sol";

import {WeightedVoting} from "../src/WeightedVoting.sol";

contract DeployWeightedVoting is Script {

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        WeightedVoting weightedVoting = new WeightedVoting();

        vm.stopBroadcast();
    }
}
