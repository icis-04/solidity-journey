// SPDX-License-Identifier: MIT
// use injected web3 to use with your rinkeby testnet
pragma solidity ^0.6.0;

contract Simple_Storage {
    //the variable below will be initialized to 0
    uint256 favouriteNumber;
    function store(uint256 _favouriteNumber) public{
        favouriteNumber = _favouriteNumber;
    }
    struct People {
        uint256 favouriteNumber;
        string name;
    }
    People[] public person;
    mapping(string => uint256) public nameTonumbermap;
    //view, pure 
    function retrieve() public view returns(uint256) {
        return favouriteNumber;
    }
    function addperson(string memory _name, uint256 _favouriteNumber) public {
        person.push(People({favouriteNumber: _favouriteNumber, name: _name}));
        nameTonumbermap[_name] = _favouriteNumber; 
    }
}
