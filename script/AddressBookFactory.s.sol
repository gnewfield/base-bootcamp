// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Script} from "forge-std/Script.sol";
import {AddressBookFactory} from "../src/new/AddressBookFactory.sol";

contract DeployAddressBookFactory is Script {

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        new AddressBookFactory();

        vm.stopBroadcast();
    }
}
