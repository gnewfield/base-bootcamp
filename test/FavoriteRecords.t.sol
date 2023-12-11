// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Test} from "forge-std/Test.sol";
import {FavoriteRecords} from "../src/FavoriteRecords.sol";

contract FavoriteRecordsTest is Test {
    FavoriteRecords public favoriteRecords;
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
    address private TEST_USER = address(1);

    function setUp() public {
        favoriteRecords = new FavoriteRecords(INITIAL_APPROVED_RECORDS);
    }

    function test_getApprovedRecords() public {
        uint256 numApprovedRecords = INITIAL_APPROVED_RECORDS.length;
        string[] memory approvedRecords = favoriteRecords.getApprovedRecords();
        assertEq(numApprovedRecords, approvedRecords.length);
        for (uint256 i = 0; i < numApprovedRecords; i++) {
            assertEq(INITIAL_APPROVED_RECORDS[i], approvedRecords[i]);
        }
    }

    function test_addRecord_AddsApprovedAlbum() public {
        vm.prank(TEST_USER);
        favoriteRecords.addRecord("Thriller");
        assertEq("Thriller", favoriteRecords.allUserFavorites(TEST_USER, 0));
        assertEq(true, favoriteRecords.userFavorites(TEST_USER, "Thriller"));
    }

    function test_addRecord_RevertIf_AlbumNotApproved() public {
        string memory FOLKLORE = "Folklore";
        vm.expectRevert(abi.encodeWithSelector(FavoriteRecords.NotApproved.selector, FOLKLORE));
        vm.prank(TEST_USER);
        favoriteRecords.addRecord(FOLKLORE);
    }

    function test_getUserFavorites() public {
        assertEq(0, favoriteRecords.getUserFavorites(TEST_USER).length);
        vm.prank(TEST_USER);
        favoriteRecords.addRecord("Thriller");
        assertEq(1, favoriteRecords.getUserFavorites(TEST_USER).length);
        assertEq("Thriller", favoriteRecords.getUserFavorites(TEST_USER)[0]);
    }

    function test_resetUserFavorites() public {
        vm.prank(TEST_USER);
        favoriteRecords.addRecord("Thriller");
        vm.prank(TEST_USER);
        favoriteRecords.addRecord("Hotel California");
        assertEq(2, favoriteRecords.getUserFavorites(TEST_USER).length);
        vm.prank(TEST_USER);
        favoriteRecords.resetUserFavorites();
        assertEq(0, favoriteRecords.getUserFavorites(TEST_USER).length);
    }
}
