// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

// Base Bootcamp: Error Triage Exercise
// Gray Newfield, December 12, 2023
// https://docs.base.org/base-camp/docs/new-keyword/new-keyword-exercise
contract AddressBook is Ownable {
    struct Contact {
        uint id;
        string firstName;
        string lastName;
        uint[] phoneNumbers;
    }

    error ContactNotFound(uint);
    error ContactAlreadyExists(uint);

    uint[] public contactIds;
    mapping(uint => Contact) public contacts;
    mapping(uint => bool) public contactStatus;

    constructor(address _owner) {
        transferOwnership(_owner);
    }
    
    function addContact(uint _id, string memory _firstName, string memory _lastName, uint[] memory _phoneNumbers) public onlyOwner {
        if (contactStatus[_id]) {
            revert ContactAlreadyExists(_id);
        }
        Contact memory newContact = Contact(_id, _firstName, _lastName, _phoneNumbers);
        contactIds.push(_id);
        contacts[_id] = newContact;
        contactStatus[_id] = true;
    }

    function deleteContact(uint _id) public onlyOwner {
        if (!contactStatus[_id]) {
            revert ContactNotFound(_id);
        }
        contactStatus[_id] = false;
    }

    function getContact(uint _id) public view returns (Contact memory) {
        if (!contactStatus[_id]) {
            revert ContactNotFound(_id);
        }
        return contacts[_id];
    }

    function getAllContacts() public view returns (Contact[] memory) {
        uint numActiveContacts = 0;
        for (uint i = 0; i < contactIds.length; i++) {
            uint contactId = contactIds[i];
            if (contactStatus[contactId]) {
                numActiveContacts++;
            }
        }
        Contact[] memory activeContacts = new Contact[](numActiveContacts);
        uint activeContactIndex = 0;
        for (uint i = 0; i < contactIds.length; i++) {
            uint contactId = contactIds[i];
            if (contactStatus[contactId]) {
                activeContacts[activeContactIndex++] = contacts[contactId];
            }
        }
        return activeContacts;
    }
}