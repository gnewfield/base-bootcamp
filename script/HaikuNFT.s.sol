// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Script} from "forge-std/Script.sol";
import {HaikuNFT} from "../src/HaikuNFT.sol";

contract DeployHaikuNFT is Script {

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        HaikuNFT haikuNFT = new HaikuNFT();

        vm.stopBroadcast();
    }
}
