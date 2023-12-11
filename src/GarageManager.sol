// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// Base Bootcamp: Structs Exercise
// Gray Newfield, December 11, 2023
// https://docs.base.org/base-camp/docs/structs/structs-exercise
contract GarageManager {
    struct Car {
        string make;
        string model;
        string color;
        uint numberOfDoors;
    }

    mapping(address => Car[]) public garage;

    error BadCarIndex(uint);

    function addCar(string calldata _make, string calldata _model, string calldata _color, uint _numberOfDoors) public {
        Car storage newCar = garage[msg.sender].push();
        newCar.make = _make;
        newCar.model = _model;
        newCar.color = _color;
        newCar.numberOfDoors = _numberOfDoors;
    }

    function getUserCars(address _user) external view returns (Car[] memory) {
        return garage[_user];
    }

    function updateCar(uint _index, string memory _make, string memory _model, string memory _color, uint _numberOfDoors) public {
        if (_index >= garage[msg.sender].length) {
            revert BadCarIndex(_index);
        }
        garage[msg.sender][_index].make = _make;
        garage[msg.sender][_index].model = _model;
        garage[msg.sender][_index].color = _color;
        garage[msg.sender][_index].numberOfDoors = _numberOfDoors;
    }

    function resetMyGarage() public {
        delete garage[msg.sender];
    }
}