// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Test} from "forge-std/Test.sol";

import {ImportsExercise} from "../src/ImportsExercise.sol";
import {SillyStringUtils} from "../src/imports/SillyStringUtils.sol";


contract ImportsExerciseTest is Test {
    string LINE_1 = "Smart contracts on chains,";
    string LINE_2 = "Ethereum's decentralized";
    string LINE_3 = "Crypto's future reigns.";

    ImportsExercise public importsExercise;

    function setUp() public {
        importsExercise = new ImportsExercise();
    }

    function test_saveHaiku() public {
        importsExercise.saveHaiku(LINE_1, LINE_2, LINE_3);

        (string memory _line1, string memory _line2, string memory _line3) = importsExercise.haiku();

        assertEq(LINE_1, _line1);
        assertEq(LINE_2, _line2);
        assertEq(LINE_3, _line3);
    }

    function test_getHaiku() public {
        importsExercise.saveHaiku(LINE_1, LINE_2, LINE_3);

        SillyStringUtils.Haiku memory haiku = importsExercise.getHaiku();

        assertEq(LINE_1, haiku.line1);
        assertEq(LINE_2, haiku.line2);
        assertEq(LINE_3, haiku.line3);
    }

    function test_shruggieHaiku() public {
        importsExercise.saveHaiku(LINE_1, LINE_2, LINE_3);

        SillyStringUtils.Haiku memory haiku = importsExercise.shruggieHaiku();

        // Verify shruggie character is appended to the return value of shruggieHaiku
        // Note: must use UTF-8 representation of shrug emoji
        assertEq("Crypto's future reigns. \xF0\x9F\xA4\xB7", haiku.line3);
        // Verify that the original haiku is unchanged
        assertEq(LINE_3, importsExercise.getHaiku().line3);
    }
}