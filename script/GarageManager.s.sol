// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Script} from "forge-std/Script.sol";
import {GarageManager} from "../src/GarageManager.sol";

contract DeployGarageManager is Script {

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        GarageManager garageManager = new GarageManager();

        vm.stopBroadcast();
    }
}
