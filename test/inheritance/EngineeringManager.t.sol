// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Test} from "forge-std/Test.sol";

import {EngineeringManager} from "../../src/inheritance/EngineeringManager.sol";

contract EngineeringManagerTest is Test {
    EngineeringManager public engineeringManager;
    uint ID_NUMBER = 54321;
    uint MANAGER_ID = 11111;
    uint ANNUAL_SALARY = 200000;

    function setUp() public {
        engineeringManager = new EngineeringManager(ID_NUMBER, MANAGER_ID, ANNUAL_SALARY);
    }

    function test_idNumber() public {
        assertEq(ID_NUMBER, engineeringManager.idNumber());
    }

    function test_managerId() public {
        assertEq(MANAGER_ID, engineeringManager.managerId());
    }

    function test_annualSalary() public {
        assertEq(ANNUAL_SALARY, engineeringManager.annualSalary());
    }

    function test_getAnnualCost() public {
        assertEq(ANNUAL_SALARY, engineeringManager.getAnnualCost());
    }

    function test_addReport() public {
        engineeringManager.addReport(11111);
        engineeringManager.addReport(22222);

        assertEq(11111, engineeringManager.employeeIds(0));
        assertEq(22222, engineeringManager.employeeIds(1));
    }
}