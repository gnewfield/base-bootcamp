// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Script} from "forge-std/Script.sol";
import {ErrorTriageExercise} from "../src/ErrorTriageExercise.sol";

contract DeployErrorTriageExercise is Script {

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        ErrorTriageExercise errorTriageExercise = new ErrorTriageExercise();

        vm.stopBroadcast();
    }
}
