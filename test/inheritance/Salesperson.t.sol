// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Test} from "forge-std/Test.sol";

import {Salesperson} from "../../src/inheritance/Salesperson.sol";

contract ManagerTest is Test {
    Salesperson public salesperson;
    uint ID_NUMBER = 55555;
    uint MANAGER_ID = 12345;
    uint HOURLY_RATE = 20;

    function setUp() public {
        salesperson = new Salesperson(ID_NUMBER, MANAGER_ID, HOURLY_RATE);
    }

    function test_idNumber() public {
        assertEq(ID_NUMBER, salesperson.idNumber());
    }

    function test_managerId() public {
        assertEq(MANAGER_ID, salesperson.managerId());
    }

    function test_hourlyRate() public {
        assertEq(HOURLY_RATE, salesperson.hourlyRate());
    }

    function test_getAnnualCost() public {
        assertEq(HOURLY_RATE * 2080, salesperson.getAnnualCost());
    }
}