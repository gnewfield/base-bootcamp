// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {EnumerableSet} from "openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";

// Base Bootcamp: ERC-20 Tokens Exercise
// Gray Newfield, December 13, 2023
// https://docs.base.org/base-camp/docs/erc-20-token/erc-20-exercise
contract WeightedVoting {
    uint public maxSupply;
    uint public totalClaimed;

    mapping(address => bool) public hasClaimed;
    mapping(address => uint) public balances;

    Issue[] private issues;

    error TokensClaimed();
    error AllTokensClaimed();
    error NoTokensHeld();
    error InsufficientTokens();
    error QuorumTooHigh(uint);
    error IssueNotFound(uint);
    error AlreadyVoted();
    error VotingClosed();

    using EnumerableSet for EnumerableSet.AddressSet;
    struct Issue {
        string issueDesc;    

        uint votesFor;
        uint votesAgainst;
        uint votesAbstain;
        uint totalVotes;
        uint quorum;

        EnumerableSet.AddressSet voters;

        bool closed;
        bool passed;
    }

    struct ReturnableIssue {
        address[] voters;
        string issueDesc;
        uint votesFor;
        uint votesAgainst;
        uint votesAbstain;
        uint totalVotes;
        uint quorum;
        bool passed;
        bool closed;
    }

    enum Vote {
        AGAINST,
        FOR,
        ABSTAIN
    }

    constructor() {
        maxSupply = 1_000_000;
        
        // Burn zeroth issue
        Issue storage newIssue = issues.push();
        newIssue.issueDesc = "PLACE_HOLDER";
        newIssue.votesFor = 0;
        newIssue.votesAgainst = 0;
        newIssue.votesAbstain = 0;
        newIssue.totalVotes = 0;
        newIssue.quorum = 0;
        newIssue.closed = false;
        newIssue.passed = false;
    }

    function claim() external {
        if (hasClaimed[msg.sender]) {
            revert TokensClaimed();
        }

        if (totalClaimed == maxSupply) {
            revert AllTokensClaimed();
        }

        hasClaimed[msg.sender] = true;
        balances[msg.sender] = 100;
        totalClaimed += 100;
    }

    function createIssue(string memory _description, uint _quorum) external returns (uint) {
        if (balances[msg.sender] == 0) {
            revert NoTokensHeld();
        }

        if (_quorum > totalClaimed) {
            revert QuorumTooHigh(_quorum);
        }

        Issue storage newIssue = issues.push();
        newIssue.issueDesc = _description;
        newIssue.votesFor = 0;
        newIssue.votesAgainst = 0;
        newIssue.votesAbstain = 0;
        newIssue.totalVotes = 0;
        newIssue.quorum = _quorum;
        newIssue.closed = false;
        newIssue.passed = false;

        return issues.length - 1;
    }

    function getIssue(uint _id) external view returns (ReturnableIssue memory) {
        if (_id >= issues.length) {
            revert IssueNotFound(_id);
        }
        address[] memory voters = EnumerableSet.values(issues[_id].voters);
        ReturnableIssue memory returnableIssue = ReturnableIssue({
            issueDesc: issues[_id].issueDesc,
            votesFor: issues[_id].votesFor,
            votesAgainst: issues[_id].votesAgainst,
            votesAbstain: issues[_id].votesAbstain,
            totalVotes: issues[_id].totalVotes,
            quorum: issues[_id].quorum,
            voters: voters,
            closed: issues[_id].closed,
            passed: issues[_id].passed
        });
        return returnableIssue;
    }

    function vote(uint _issueId, Vote _vote) external {
        Issue storage issue = issues[_issueId];
        if (issue.voters.contains(msg.sender)) {
            revert AlreadyVoted();
        }
        if (issue.closed) {
            revert VotingClosed();
        }
        EnumerableSet.add(issue.voters, msg.sender);
        if (_vote == Vote.FOR) {
            issue.votesFor += balances[msg.sender];
        } else if (_vote == Vote.AGAINST) {
            issue.votesAgainst += balances[msg.sender];
        } else {
            issue.votesAbstain += balances[msg.sender];
        }
        issue.totalVotes += balances[msg.sender];
        if (issue.totalVotes >= issue.quorum) {
            issue.closed = true;
            issue.passed = issue.votesFor > issue.votesAgainst;
        }
    }

    function totalSupply() public view returns (uint) {
        return totalClaimed;
    }

    function balanceOf(address _owner) public view returns (uint) {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value) external {
        if(balances[msg.sender] < _value) {
            revert InsufficientTokens();
        }
        balances[msg.sender] -= _value;
        balances[_to] += _value;
    }
}