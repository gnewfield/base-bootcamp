// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Test} from "forge-std/Test.sol";
import {HaikuNFT} from "../src/HaikuNFT.sol";

contract HaikuNFTTest is Test {
    HaikuNFT haikuNFT;

    address USER_1 = address(1);
    address USER_2 = address(2);
    
    string HAIKU_1_LINE_1 = "Ethereum's blockchain,";
    string HAIKU_1_LINE_2 = "Smart contracts, tokens take flight,";
    string HAIKU_1_LINE_3 = "Decentralized might.";
    
    string HAIKU_2_LINE_1 = "Gas fees rise and fall,";
    string HAIKU_2_LINE_2 = "DeFi, NFTs for all,";
    string HAIKU_2_LINE_3 = "Ethereum's grand hall.";


    function setUp() public {
        haikuNFT = new HaikuNFT();
    }

    function test_mintHaiku() public {
        assertEq(1, haikuNFT.counter());
        vm.startPrank(USER_1);
        haikuNFT.mintHaiku(HAIKU_1_LINE_1, HAIKU_1_LINE_2, HAIKU_1_LINE_3);
        (address _author, string memory _line1, string memory _line2, string memory _line3) = haikuNFT.haikus(1);

        assertEq(2, haikuNFT.counter());
        assertEq(USER_1, _author);
        assertEq(HAIKU_1_LINE_1, _line1);
        assertEq(HAIKU_1_LINE_2, _line2);
        assertEq(HAIKU_1_LINE_3, _line3);
    }

    function test_mintHaiku_RevertIf_HaikuNotUnique() public {
        vm.startPrank(USER_1);
        haikuNFT.mintHaiku(HAIKU_1_LINE_1, HAIKU_1_LINE_2, HAIKU_1_LINE_3);
        vm.expectRevert(abi.encodeWithSelector(HaikuNFT.HaikuNotUnique.selector));
        // Copy line 2 from haiku1
        haikuNFT.mintHaiku(HAIKU_2_LINE_1, HAIKU_1_LINE_2, HAIKU_2_LINE_3);
    }

    function test_shareHaiku() public {
        // User1 mints two haikus and share with User2
        vm.startPrank(USER_1);
        haikuNFT.mintHaiku(HAIKU_1_LINE_1, HAIKU_1_LINE_2, HAIKU_1_LINE_3);
        haikuNFT.mintHaiku(HAIKU_2_LINE_1, HAIKU_2_LINE_2, HAIKU_2_LINE_3);
        haikuNFT.shareHaiku(1, USER_2);
        haikuNFT.shareHaiku(2, USER_2);
        vm.stopPrank();
        
        vm.prank(USER_2);
        HaikuNFT.Haiku[] memory haikusSharedWithUser2 = haikuNFT.getMySharedHaikus();
        
        assertEq(2, haikusSharedWithUser2.length);
        assertEq(USER_1, haikusSharedWithUser2[0].author);
        assertEq(USER_1, haikusSharedWithUser2[1].author);
    }

    function test_shareHaiku_RevertIf_NotYourHaiku() public {
        vm.prank(USER_1);
        haikuNFT.mintHaiku(HAIKU_1_LINE_1, HAIKU_1_LINE_2, HAIKU_1_LINE_3);
        
        vm.prank(USER_2);
        vm.expectRevert(abi.encodeWithSelector(HaikuNFT.NotYourHaiku.selector, 1));
        haikuNFT.shareHaiku(1, USER_2);
    }

    function test_getMySharedHaikus_RevertIf_NoHaikusShared() public {
        vm.expectRevert(abi.encodeWithSelector(HaikuNFT.NoHaikusShared.selector));
        HaikuNFT.Haiku[] memory haikus = haikuNFT.getMySharedHaikus();
    }
}