// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Test} from "forge-std/Test.sol";

import {UnburnableToken} from "../src/UnburnableToken.sol";

contract UnburnableTokenTest is Test {
    UnburnableToken unburnableToken;
    uint TOTAL_SUPPLY = 100_000_000;
    address TEST_USER_1 = address(1);
    address TEST_USER_2 = address(2);
    address TEST_USER_3 = address(3);

    function setUp() public {
        unburnableToken = new UnburnableToken();
    }

    function test_totalSupply() public {
        assertEq(TOTAL_SUPPLY, unburnableToken.totalSupply());
    }

    function test_claim() public {
        assertEq(0, unburnableToken.balances(TEST_USER_1));

        vm.prank(TEST_USER_1);
        unburnableToken.claim();

        assertEq(1000, unburnableToken.balances(TEST_USER_1));
        assertEq(1000, unburnableToken.totalClaimed());
    }

    function test_claim_RevertIf_AlreadyClaimed() public {
        assertEq(0, unburnableToken.balances(TEST_USER_1));
        vm.startPrank(TEST_USER_1);
        unburnableToken.claim();

        vm.expectRevert(abi.encodeWithSelector(UnburnableToken.TokensClaimed.selector));
        unburnableToken.claim();
    }

    function test_claim_RevertIf_AllClaimed() public {
        // Set totalSupply to 1_000
        vm.store(address(unburnableToken), bytes32(uint256(0)), bytes32(uint256(1_000)));
        assertEq(1_000, unburnableToken.totalSupply());
        assertEq(0, unburnableToken.balances(TEST_USER_1));
        // Make allowed claim
        vm.prank(TEST_USER_1);
        unburnableToken.claim();
        assertEq(1000, unburnableToken.totalClaimed());

        // Attempt to claim
        vm.expectRevert(abi.encodeWithSelector(UnburnableToken.AllTokensClaimed.selector));
        vm.prank(TEST_USER_2);
        unburnableToken.claim();
    }

    function test_safeTransfer_RevertIf_InsufficientTokens() public {
        vm.prank(TEST_USER_1);
        vm.expectRevert(abi.encodeWithSelector(UnburnableToken.InsufficientTokens.selector));
        unburnableToken.safeTransfer(TEST_USER_2, 1_000);
    }

    function test_safeTransfer_RevertIf_UnsafeTransfer_ToZeroAddress() public {
        vm.startPrank(TEST_USER_1);
        unburnableToken.claim();
        vm.expectRevert(abi.encodeWithSelector(UnburnableToken.UnsafeTransfer.selector, address(0)));
        unburnableToken.safeTransfer(address(0), 1_000);
    }

    function test_safeTransfer_RevertIf_UnsafeTransfer_ToEmptyAddress() public {
        vm.startPrank(TEST_USER_1);
        unburnableToken.claim();
        vm.expectRevert(abi.encodeWithSelector(UnburnableToken.UnsafeTransfer.selector, TEST_USER_2));
        unburnableToken.safeTransfer(TEST_USER_2, 1_000);
    }

    function test_safeTransfer() public {
        vm.startPrank(TEST_USER_1);
        unburnableToken.claim();
        vm.deal(TEST_USER_2, 1 ether);

        unburnableToken.safeTransfer(TEST_USER_2, 500);
    }
}