// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// Base Bootcamp: Inheritance Exercise
// Gray Newfield, December 11, 2023
// https://docs.base.org/base-camp/docs/inheritance/inheritance-exercise
abstract contract Employee {
    uint public idNumber;
    uint public managerId;
    
    constructor(uint _idNumber, uint _managerId) {
        idNumber = _idNumber;
        managerId = _managerId;
    }

    function getAnnualCost() public virtual returns (uint);
}