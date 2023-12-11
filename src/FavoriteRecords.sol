// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// Base Bootcamp: Mappings Exercise
// Gray Newfield, December 11, 2023
// https://docs.base.org/base-camp/docs/mappings/mappings-exercise
contract FavoriteRecords {
    mapping(string => bool) public approvedRecords;
    string[] public allApprovedRecords;

    mapping(address => mapping(string => bool)) public userFavorites;
    mapping(address => string[]) public allUserFavorites;

    error NotApproved(string);

    constructor(string[] memory _approvedRecords) {
        allApprovedRecords = _approvedRecords;
        for (uint256 i = 0; i < _approvedRecords.length; i++) {
            approvedRecords[_approvedRecords[i]] = true;
        }
    }

    function getApprovedRecords() external view returns (string[] memory) {
        return allApprovedRecords;
    }

    function addRecord(string calldata _albumName) public {
        if (approvedRecords[_albumName]) {
            userFavorites[msg.sender][_albumName] = true;
            allUserFavorites[msg.sender].push(_albumName);
        } else {
            revert NotApproved(_albumName);
        }
    }

    function getUserFavorites(address _user) public view returns (string[] memory favorites) {
        return allUserFavorites[_user];
    }

    function resetUserFavorites() public {
        uint256 numFavorites = allUserFavorites[msg.sender].length;
        for (uint256 i = 0; i < numFavorites; i++) {
            userFavorites[msg.sender][allUserFavorites[msg.sender][numFavorites - i - 1]] = false;
            allUserFavorites[msg.sender].pop();
        }
    }
}
