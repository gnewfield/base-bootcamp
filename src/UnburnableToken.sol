// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// Base Bootcamp: Minimal Tokens Exercise
// Gray Newfield, December 12, 2023
// https://docs.base.org/base-camp/docs/minimal-tokens/minimal-tokens-exercise
contract UnburnableToken {
    uint public totalSupply;
    uint public totalClaimed;
    mapping(address => uint) public balances;
    mapping(address => bool) public claimed;

    error TokensClaimed();
    error AllTokensClaimed();
    error InsufficientTokens();
    error UnsafeTransfer(address);

    constructor() {
        totalSupply = 100000000;
    }

    function claim() public {
        if (claimed[msg.sender]) {
            revert TokensClaimed();
        } else if (totalClaimed == totalSupply) {
            revert AllTokensClaimed();
        } else {
            claimed[msg.sender] = true;
            balances[msg.sender] = 1000;
            totalClaimed += 1000;
        }
    }

    function safeTransfer(address _to, uint _amount) public {
        if (_amount > balances[msg.sender]) {
            revert InsufficientTokens();
        } else if (_to == address(0) || _to.balance == 0) {
            revert UnsafeTransfer(_to);
        } else {
            balances[msg.sender] -= _amount;
            balances[_to] += _amount;
        }
    }
}