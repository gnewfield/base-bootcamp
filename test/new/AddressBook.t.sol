// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Test} from "forge-std/Test.sol";

import {AddressBook} from "../../src/new/AddressBook.sol";

contract AddressBookTest is Test {
    AddressBook addressBook;
    address TEST_USER = address(1);
    uint[] TEST_PHONE_NUMBERS = [1111111, 2222222, 3333333];
    AddressBook.Contact TEST_CONTACT_1 = AddressBook.Contact(
        1,
        "Gray",
        "Newfield",
        TEST_PHONE_NUMBERS
    );

    function setUp() public {
        addressBook = new AddressBook(TEST_USER);
    }

    function test_owner() public {
        assertEq(TEST_USER, addressBook.owner());
    }

    function test_addContact() public {
        vm.prank(TEST_USER);
        addressBook.addContact(
            TEST_CONTACT_1.id, 
            TEST_CONTACT_1.firstName, 
            TEST_CONTACT_1.lastName, 
            TEST_CONTACT_1.phoneNumbers
        );
        
        AddressBook.Contact memory addedContact = addressBook.getContact(1);

        assertEq(TEST_CONTACT_1.id, addedContact.id);
        assertEq(TEST_CONTACT_1.firstName, addedContact.firstName);
        assertEq(TEST_CONTACT_1.lastName, addedContact.lastName);
        assertEq(TEST_CONTACT_1.phoneNumbers[0], addedContact.phoneNumbers[0]);
        assertEq(TEST_CONTACT_1.phoneNumbers[1], addedContact.phoneNumbers[1]);
        assertEq(TEST_CONTACT_1.phoneNumbers[2], addedContact.phoneNumbers[2]);
    }

    function test_addContact_RevertIf_ContactAlreadyExists() public {
        vm.prank(TEST_USER);
        addressBook.addContact(
            TEST_CONTACT_1.id, 
            TEST_CONTACT_1.firstName, 
            TEST_CONTACT_1.lastName, 
            TEST_CONTACT_1.phoneNumbers
        );
        
        vm.expectRevert(abi.encodeWithSelector(AddressBook.ContactAlreadyExists.selector, TEST_CONTACT_1.id));
        vm.prank(TEST_USER);
        addressBook.addContact(
            TEST_CONTACT_1.id, 
            TEST_CONTACT_1.firstName, 
            TEST_CONTACT_1.lastName, 
            TEST_CONTACT_1.phoneNumbers
        );
    }

    function test_addContact_RevertIf_UserIsNotOwner() public {
        vm.expectRevert("Ownable: caller is not the owner");
        addressBook.addContact(
            TEST_CONTACT_1.id, 
            TEST_CONTACT_1.firstName, 
            TEST_CONTACT_1.lastName, 
            TEST_CONTACT_1.phoneNumbers
        );
    }

    function test_deleteContact() public {
        vm.prank(TEST_USER);
        addressBook.addContact(
            TEST_CONTACT_1.id, 
            TEST_CONTACT_1.firstName, 
            TEST_CONTACT_1.lastName, 
            TEST_CONTACT_1.phoneNumbers
        );
        AddressBook.Contact[] memory contacts = addressBook.getAllContacts();
        assertEq(1, contacts.length);

        vm.prank(TEST_USER);
        addressBook.deleteContact(1);

        AddressBook.Contact[] memory emptyContacts = addressBook.getAllContacts();
        assertEq(0, emptyContacts.length);
    }

    function test_deleteContact_RevertIf_ContactNotFound() public {
        vm.expectRevert(abi.encodeWithSelector(AddressBook.ContactNotFound.selector, 1));
        vm.prank(TEST_USER);
        addressBook.deleteContact(1);
    }

    function test_getContact_RevertIf_ContactNotFound() public {
        vm.expectRevert(abi.encodeWithSelector(AddressBook.ContactNotFound.selector, TEST_CONTACT_1.id));
        addressBook.getContact(1);
    }

    function test_getAllContacts_NoContacts() public {
        AddressBook.Contact[] memory contacts = addressBook.getAllContacts();
        assertEq(0, contacts.length);
    }

    function test_getAllContacts_MultipleContacts() public {
        vm.prank(TEST_USER);
        addressBook.addContact(
            TEST_CONTACT_1.id, 
            TEST_CONTACT_1.firstName, 
            TEST_CONTACT_1.lastName, 
            TEST_CONTACT_1.phoneNumbers
        );
        vm.prank(TEST_USER);
        addressBook.addContact(
            2, 
            "Other", 
            "Test", 
            TEST_CONTACT_1.phoneNumbers
        );
        
        AddressBook.Contact[] memory contacts = addressBook.getAllContacts();

        assertEq(2, contacts.length);
        assertEq("Gray", contacts[0].firstName);
        assertEq("Other", contacts[1].firstName);
    }
}