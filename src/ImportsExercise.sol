// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {SillyStringUtils} from "./imports/SillyStringUtils.sol";

// Base Bootcamp: Imports Exercise
// Gray Newfield, December 11, 2023
// https://docs.base.org/base-camp/docs/imports/imports-exercise
contract ImportsExercise {
    SillyStringUtils.Haiku public haiku;

    function saveHaiku(string memory _line1, string memory _line2, string memory _line3) public {
        haiku.line1 = _line1;
        haiku.line2 = _line2;
        haiku.line3 = _line3;
    }

    function getHaiku() public view returns (SillyStringUtils.Haiku memory) {
        return haiku;
    }

    function shruggieHaiku() public view returns (SillyStringUtils.Haiku memory tempHaiku) {
        tempHaiku = haiku;
        tempHaiku.line3 = SillyStringUtils.shruggie(haiku.line3);
    }
}