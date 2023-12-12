// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Hourly} from "./Hourly.sol";

// Base Bootcamp: Inheritance Exercise
// Gray Newfield, December 11, 2023
// https://docs.base.org/base-camp/docs/inheritance/inheritance-exercise
contract Salesperson is Hourly {
    constructor(uint _idNumber, uint _managerId, uint _hourlyRate) Hourly(_idNumber, _managerId, _hourlyRate) {}
}