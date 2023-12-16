// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {EnumerableSet} from "openzeppelin-contracts/contracts/utils/structs/EnumerableSet.sol";

contract HaikuNFT {
    using EnumerableSet for EnumerableSet.Bytes32Set;
    
    struct Haiku {
        address author;
        string line1;
        string line2;
        string line3;
    }
    
    uint public counter;
    Haiku[] public haikus;
    mapping(address => uint[]) public sharedHaikus;
    EnumerableSet.Bytes32Set private _lines;

    error HaikuNotUnique();
    error NotYourHaiku(uint);
    error NoHaikusShared();

    constructor() {
        counter = 1;
        haikus.push();
    }

    function _validateLine(string memory _line) private view {
        bytes32 lineHash = keccak256(abi.encode(_line));
        if (EnumerableSet.contains(_lines, lineHash)) {
            revert HaikuNotUnique();
        }
    }

    function mintHaiku(string memory _line1, string memory _line2, string memory _line3) external {
        _validateLine(_line1);
        _validateLine(_line2);
        _validateLine(_line3);


        Haiku storage mintedHaiku = haikus.push();
        mintedHaiku.author = msg.sender;
        mintedHaiku.line1 = _line1;
        mintedHaiku.line2 = _line2;
        mintedHaiku.line3 = _line3;

        counter++;
        _lines.add(keccak256(abi.encode(_line1)));
        _lines.add(keccak256(abi.encode(_line2)));
        _lines.add(keccak256(abi.encode(_line3)));
    }

    function shareHaiku(uint _id, address _to) external {
        if (haikus[_id].author != msg.sender) {
            revert NotYourHaiku(_id);
        }

        sharedHaikus[_to].push(_id);
    }

    function getMySharedHaikus() external view returns (Haiku[] memory) {
        uint[] memory myHaikuIds = sharedHaikus[msg.sender];
        if (myHaikuIds.length == 0) {
            revert NoHaikusShared();
        }

        Haiku[] memory myHaikus = new Haiku[](myHaikuIds.length);
        for (uint i = 0; i < myHaikuIds.length; i++) {
            uint haikuId = sharedHaikus[msg.sender][i];
            myHaikus[i] = haikus[haikuId];
        }
        return myHaikus;
    }

    function ownerOf(uint _id) external view returns (address) {
        return haikus[_id].author;
    }
}