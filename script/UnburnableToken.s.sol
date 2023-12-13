// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Script} from "forge-std/Script.sol";

import {UnburnableToken} from "../src/UnburnableToken.sol";

contract DeployUnburnableToken is Script {

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        UnburnableToken unburnableToken = new UnburnableToken();

        vm.stopBroadcast();
    }
}
