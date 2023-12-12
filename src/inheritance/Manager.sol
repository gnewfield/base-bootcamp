// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// Base Bootcamp: Inheritance Exercise
// Gray Newfield, December 11, 2023
// https://docs.base.org/base-camp/docs/inheritance/inheritance-exercise
abstract contract Manager {
    uint[] public employeeIds;
    
    function addReport(uint _employeeId) public {
        employeeIds.push(_employeeId);
    }

    function resetReports() public {
        delete employeeIds;
    }
}