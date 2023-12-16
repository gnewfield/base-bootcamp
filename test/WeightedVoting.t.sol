// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Test} from "forge-std/Test.sol";
import {WeightedVoting} from "../src/WeightedVoting.sol";

contract WeightedVotingTest is Test {
    WeightedVoting weightedVoting;
    address TEST_USER_1 = address(1);
    address TEST_USER_2 = address(2);
    address TEST_USER_3 = address(3);
    string TEST_ISSUE_DESC = "This is a test issue.";
    
    function setUp() public {
        weightedVoting = new WeightedVoting();
    }

    function test_maxSupply() public {
        assertEq(1_000_000, weightedVoting.maxSupply());
    }

    function test_claim_RevertIf_TokensClaimed() public {
        vm.startPrank(TEST_USER_1);
        weightedVoting.claim();
        vm.expectRevert(abi.encodeWithSelector(WeightedVoting.TokensClaimed.selector));
        weightedVoting.claim();
    }

    function test_claim_RevertIf_AllTokensClaimed() public {
        vm.store(address(weightedVoting), bytes32(uint256(1)), bytes32(uint256(weightedVoting.maxSupply())));
        vm.expectRevert(abi.encodeWithSelector(WeightedVoting.AllTokensClaimed.selector));
        weightedVoting.claim();
    }

    function test_claim() public {
        assertEq(0, weightedVoting.balances(TEST_USER_1));
        vm.prank(TEST_USER_1);
        weightedVoting.claim();
        assertEq(100, weightedVoting.balances(TEST_USER_1));
        assertEq(100, weightedVoting.totalClaimed());
        assertEq(true, weightedVoting.hasClaimed(TEST_USER_1));
    }

    function test_createIssue_RevertIf_NoTokensHeld() public {
        vm.expectRevert(abi.encodeWithSelector(WeightedVoting.NoTokensHeld.selector));
        weightedVoting.createIssue(TEST_ISSUE_DESC, 100);
    }

    function test_createIssue_RevertIf_QuorumTooHigh() public {
        vm.startPrank(TEST_USER_1);
        weightedVoting.claim();
        vm.expectRevert(abi.encodeWithSelector(WeightedVoting.QuorumTooHigh.selector, 200));
        weightedVoting.createIssue(TEST_ISSUE_DESC, 200);
    }

    function test_createIssue() public {
        vm.startPrank(TEST_USER_1);
        weightedVoting.claim();
        uint issueIndex = weightedVoting.createIssue(TEST_ISSUE_DESC, 100);
        assertEq(1, issueIndex);
    }

    function test_getIssue_RevertIf_IssueNotFound() public {
        vm.prank(TEST_USER_1);
        vm.expectRevert(abi.encodeWithSelector(WeightedVoting.IssueNotFound.selector, 1));
        weightedVoting.getIssue(1);
    }

    function test_getIssue() public {
        vm.startPrank(TEST_USER_1);
        weightedVoting.claim();
        uint issueIndex = weightedVoting.createIssue(TEST_ISSUE_DESC, 100);

        WeightedVoting.ReturnableIssue memory issue = weightedVoting.getIssue(issueIndex);

        assertEq(TEST_ISSUE_DESC, issue.issueDesc);
        assertEq(0, issue.votesFor);
        assertEq(0, issue.votesAgainst);
        assertEq(0, issue.votesAbstain);
        assertEq(0, issue.totalVotes);
        assertEq(100, issue.quorum);
        assertEq(0, issue.voters.length);
        assertEq(false, issue.closed);
        assertEq(false, issue.passed);
    }

    function test_vote_RevertIf_AlreadyVoted() public {
        vm.startPrank(TEST_USER_1);
        weightedVoting.claim();
        uint issueIndex = weightedVoting.createIssue(TEST_ISSUE_DESC, 100);
        weightedVoting.vote(issueIndex, WeightedVoting.Vote.FOR);
        vm.expectRevert(abi.encodeWithSelector(WeightedVoting.AlreadyVoted.selector));
        weightedVoting.vote(issueIndex, WeightedVoting.Vote.FOR);
    }

    function test_vote_RevertIf_VotingClosed() public {
        vm.startPrank(TEST_USER_1);
        weightedVoting.claim();
        uint issueIndex = weightedVoting.createIssue(TEST_ISSUE_DESC, 100);
        weightedVoting.vote(issueIndex, WeightedVoting.Vote.FOR);
        vm.stopPrank();
        vm.startPrank(TEST_USER_2);
        weightedVoting.claim();
        vm.expectRevert(abi.encodeWithSelector(WeightedVoting.VotingClosed.selector));
        weightedVoting.vote(issueIndex, WeightedVoting.Vote.FOR);
    }

    function test_vote_Passes() public {
        vm.prank(TEST_USER_1);
        weightedVoting.claim();
        vm.prank(TEST_USER_2);
        weightedVoting.claim();
        vm.prank(TEST_USER_3);
        weightedVoting.claim();

        vm.prank(TEST_USER_1);
        uint issueIndex = weightedVoting.createIssue(TEST_ISSUE_DESC, 300);
        vm.prank(TEST_USER_1);
        weightedVoting.vote(issueIndex, WeightedVoting.Vote.FOR);
        
        vm.prank(TEST_USER_2);
        weightedVoting.vote(issueIndex, WeightedVoting.Vote.AGAINST);

        vm.prank(TEST_USER_3);
        weightedVoting.vote(issueIndex, WeightedVoting.Vote.FOR);

        WeightedVoting.ReturnableIssue memory issue = weightedVoting.getIssue(issueIndex);
        assertEq(TEST_USER_1, issue.voters[0]);
        assertEq(TEST_USER_2, issue.voters[1]);
        assertEq(TEST_USER_3, issue.voters[2]);
        assertEq(200, issue.votesFor);
        assertEq(100, issue.votesAgainst);
        assertEq(0, issue.votesAbstain);
        assertEq(300, issue.totalVotes);
        assertEq(true, issue.closed);
        assertEq(true, issue.passed);
    }

    function test_vote_Fails() public {
        vm.prank(TEST_USER_1);
        weightedVoting.claim();
        vm.prank(TEST_USER_2);
        weightedVoting.claim();
        vm.prank(TEST_USER_3);
        weightedVoting.claim();

        vm.prank(TEST_USER_1);
        uint issueIndex = weightedVoting.createIssue(TEST_ISSUE_DESC, 300);
        vm.prank(TEST_USER_1);
        weightedVoting.vote(issueIndex, WeightedVoting.Vote.FOR);
        
        vm.prank(TEST_USER_2);
        weightedVoting.vote(issueIndex, WeightedVoting.Vote.AGAINST);

        vm.prank(TEST_USER_3);
        weightedVoting.vote(issueIndex, WeightedVoting.Vote.AGAINST);

        WeightedVoting.ReturnableIssue memory issue = weightedVoting.getIssue(issueIndex);
        assertEq(TEST_USER_1, issue.voters[0]);
        assertEq(TEST_USER_2, issue.voters[1]);
        assertEq(TEST_USER_3, issue.voters[2]);
        assertEq(100, issue.votesFor);
        assertEq(200, issue.votesAgainst);
        assertEq(0, issue.votesAbstain);
        assertEq(300, issue.totalVotes);
        assertEq(true, issue.closed);
        assertEq(false, issue.passed);
    }

    function test_vote_Ties() public {
        vm.prank(TEST_USER_1);
        weightedVoting.claim();
        vm.prank(TEST_USER_2);
        weightedVoting.claim();
        vm.prank(TEST_USER_3);
        weightedVoting.claim();

        vm.prank(TEST_USER_1);
        uint issueIndex = weightedVoting.createIssue(TEST_ISSUE_DESC, 300);
        vm.prank(TEST_USER_1);
        weightedVoting.vote(issueIndex, WeightedVoting.Vote.FOR);
        
        vm.prank(TEST_USER_2);
        weightedVoting.vote(issueIndex, WeightedVoting.Vote.AGAINST);

        vm.prank(TEST_USER_3);
        weightedVoting.vote(issueIndex, WeightedVoting.Vote.ABSTAIN);

        WeightedVoting.ReturnableIssue memory issue = weightedVoting.getIssue(issueIndex);
        assertEq(TEST_USER_1, issue.voters[0]);
        assertEq(TEST_USER_2, issue.voters[1]);
        assertEq(TEST_USER_3, issue.voters[2]);
        assertEq(100, issue.votesFor);
        assertEq(100, issue.votesAgainst);
        assertEq(100, issue.votesAbstain);
        assertEq(300, issue.totalVotes);
        assertEq(true, issue.closed);
        assertEq(false, issue.passed);
    }
}