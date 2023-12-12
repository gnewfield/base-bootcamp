// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Script} from "forge-std/Script.sol";

import {Salesperson} from "../src/inheritance/Salesperson.sol";
import {EngineeringManager} from "../src/inheritance/EngineeringManager.sol";
import {InheritanceSubmission} from "../src/InheritanceSubmission.sol";

contract DeployInheritanceSubmission is Script {

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        Salesperson salesperson = new Salesperson(55555, 12345, 20);
        EngineeringManager engineeringManager = new EngineeringManager(54321, 11111, 200000);
        InheritanceSubmission inheritanceSubmission = new InheritanceSubmission(address(salesperson), address(engineeringManager));

        vm.stopBroadcast();
    }
}
