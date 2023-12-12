// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {AddressBook} from "./AddressBook.sol";

// Base Bootcamp: Error Triage Exercise
// Gray Newfield, December 12, 2023
// https://docs.base.org/base-camp/docs/new-keyword/new-keyword-exercise
contract AddressBookFactory {
    function deploy() public returns (address) {
        return address(new AddressBook(msg.sender));
    }
}