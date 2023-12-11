// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Script} from "forge-std/Script.sol";
import {FavoriteRecords} from "../src/FavoriteRecords.sol";

contract DeployFavoriteRecords is Script {
    string[] INITIAL_APPROVED_RECORDS = [
        "Thriller",
        "Back in Black",
        "The Bodyguard",
        "The Dark Side of the Moon",
        "Their Greatest Hits (1971-1975)",
        "Hotel California",
        "Come On Over",
        "Rumours",
        "Saturday Night Fever"
    ];

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        FavoriteRecords favoriteRecords = new FavoriteRecords(INITIAL_APPROVED_RECORDS);

        vm.stopBroadcast();
    }
}
