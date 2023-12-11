// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Test} from 'forge-std/Test.sol';
import {GarageManager} from '../src/GarageManager.sol';

contract GarageManagerTest is Test {
    GarageManager public garageManager;
    address private TEST_USER = address(1);

    function setUp() public {
        garageManager = new GarageManager();
    }

    function test_addCar() public {
        assertEq(0, garageManager.getUserCars(TEST_USER).length);
        vm.prank(TEST_USER);
        garageManager.addCar("Tesla", "Roadster", "red", 2);
        assertEq(1, garageManager.getUserCars(TEST_USER).length);
    }

    function test_updateCar() public {
        vm.prank(TEST_USER);
        garageManager.addCar("Tesla", "Roadster", "red", 2);
        vm.prank(TEST_USER);
        garageManager.addCar("Tesla", "Roadster", "blue", 2);
        
        assertEq("red", garageManager.getUserCars(TEST_USER)[0].color);
        vm.prank(TEST_USER);
        garageManager.updateCar(0, "Tesla", "Roadster", "blue", 2);
        assertEq("blue", garageManager.getUserCars(TEST_USER)[0].color);

        assertEq("Roadster", garageManager.getUserCars(TEST_USER)[1].model);
        assertEq(2, garageManager.getUserCars(TEST_USER)[1].numberOfDoors);
        vm.prank(TEST_USER);
        garageManager.updateCar(1, "Tesla", "Cybertruck", "blue", 4);
        assertEq("Cybertruck", garageManager.getUserCars(TEST_USER)[1].model);
        assertEq(4, garageManager.getUserCars(TEST_USER)[1].numberOfDoors);
    }

    function test_updateCar_RevertIf_BadCarIndex() public {
        vm.prank(TEST_USER);
        garageManager.addCar("Tesla", "Roadster", "red", 2);

        vm.expectRevert(abi.encodeWithSelector(GarageManager.BadCarIndex.selector, 1));
        vm.prank(TEST_USER);
        garageManager.updateCar(1, "Tesla", "Roadster", "blue", 2);
    }

    function test_resetMyGarage() public {
        vm.prank(TEST_USER);
        garageManager.addCar("Tesla", "Roadster", "red", 2);
        vm.prank(TEST_USER);
        garageManager.addCar("Tesla", "Roadster", "blue", 2);
        assertEq(2, garageManager.getUserCars(TEST_USER).length);

        vm.prank(TEST_USER);
        garageManager.resetMyGarage();

        assertEq(0, garageManager.getUserCars(TEST_USER).length);
    }
}