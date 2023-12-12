// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Test} from "forge-std/Test.sol";

import {ErrorTriageExercise} from "../src/ErrorTriageExercise.sol";

contract ErrorTriageExerciseTest is Test {
    ErrorTriageExercise errorTriageExercise;
    
    function setUp() public {
        errorTriageExercise = new ErrorTriageExercise();
    }

    function test_diffWithNeighbor_AllDiffsPositive() public {
        uint[] memory results = errorTriageExercise.diffWithNeighbor(4, 3, 2, 1);
        assertEq(1, results[0]);
        assertEq(1, results[1]);
        assertEq(1, results[2]);
    }

    function test_diffWithNeighbor_DiffsAreNegative() public {
        uint[] memory results = errorTriageExercise.diffWithNeighbor(1, 2, 3, 4);
        assertEq(1, results[0]);
        assertEq(1, results[1]);
        assertEq(1, results[2]);
    }

    function test_applyModifier_PositiveModifier() public {
        uint _base = 1500;
        int _modifier = 50;
        assertEq(1550, errorTriageExercise.applyModifier(_base, _modifier));
    }

    function test_applyModifier_NegativeModifier() public {
        uint _base = 1500;
        int _modifier = -50;
        assertEq(1450, errorTriageExercise.applyModifier(_base, _modifier));
    }

    function test_popWithReturn() public {
        errorTriageExercise.addToArr(1);
        errorTriageExercise.addToArr(2);
        errorTriageExercise.addToArr(3);

        uint[] memory arr = errorTriageExercise.getArr();

        assertEq(3, errorTriageExercise.popWithReturn());
        assertEq(2, errorTriageExercise.popWithReturn());
        assertEq(1, errorTriageExercise.popWithReturn());
    }
}