// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Employee} from "./Employee.sol";

// Base Bootcamp: Inheritance Exercise
// Gray Newfield, December 11, 2023
// https://docs.base.org/base-camp/docs/inheritance/inheritance-exercise
abstract contract Hourly is Employee {
    uint public hourlyRate;

    constructor(uint _idNumber, uint _managerId, uint _hourlyRate) Employee(_idNumber, _managerId) {
        hourlyRate = _hourlyRate;
    }

    function getAnnualCost() public override view returns (uint) {
        return hourlyRate * 2080;
    }
}