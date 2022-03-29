// SPDX-License-Identifier: MIT
import "./Copy_SimpleStorage.sol";

pragma solidity ^0.6.0;
contract Storage_Factory is Simple_Storage {

    Simple_Storage[] public simplestorageArray;

    function createSimpleStorageContract() public {
        Simple_Storage simplestorage = new Simple_Storage();
        simplestorageArray.push(simplestorage);
    }
    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {
        //address
        //ABI
        Simple_Storage(address(simplestorageArray[_simpleStorageIndex])).store(_simpleStorageNumber);
    }

    function sfretrieve(uint256 _simpleStorageIndex) public view returns (uint256) {
        return Simple_Storage(address(simplestorageArray[_simpleStorageIndex])).retrieve();
    }
}
