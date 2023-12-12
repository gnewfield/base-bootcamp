// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Test} from "forge-std/Test.sol";

import {AddressBook} from "../../src/new/AddressBook.sol";
import {AddressBookFactory} from "../../src/new/AddressBookFactory.sol";

contract AddressBookFactoryTest is Test {
    AddressBookFactory factory;
    address TEST_USER = address(1);

    function setUp() public {
        factory = new AddressBookFactory();
    }

    function test_deploy() public {
        vm.prank(TEST_USER);
        address contractAddress = factory.deploy();
        AddressBook addressBook = AddressBook(contractAddress);
        // Verify that TEST_USER is the owner
        assertEq(TEST_USER, addressBook.owner());
    }


}