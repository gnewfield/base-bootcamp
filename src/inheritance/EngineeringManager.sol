// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Manager} from "./Manager.sol";
import {Salaried} from "./Salaried.sol";

// Base Bootcamp: Inheritance Exercise
// Gray Newfield, December 11, 2023
// https://docs.base.org/base-camp/docs/inheritance/inheritance-exercise
contract EngineeringManager is Salaried, Manager {
    constructor(uint _idNumber, uint _managerId, uint _annualSalary) Salaried(_idNumber, _managerId, _annualSalary) {}
}