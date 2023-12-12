// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Test} from "forge-std/Test.sol";

import {Salesperson} from "../src/inheritance/Salesperson.sol";
import {EngineeringManager} from "../src/inheritance/EngineeringManager.sol";
import {InheritanceSubmission} from "../src/InheritanceSubmission.sol";


contract InheritanceSubmissionTest is Test {
    Salesperson public salesPerson;
    EngineeringManager public engineeringManager;
    InheritanceSubmission public inheritanceSubmission;

    function setUp() public {
        salesPerson = new Salesperson(55555, 12345, 20);
        engineeringManager = new EngineeringManager(54321, 11111, 200000);
        inheritanceSubmission = new InheritanceSubmission(address(salesPerson), address(engineeringManager));
    }

    function test_salesPerson() public {
        assertEq(address(salesPerson), inheritanceSubmission.salesPerson());
    }

    function test_engineeringManager() public {
        assertEq(address(engineeringManager), inheritanceSubmission.engineeringManager());
    }
}