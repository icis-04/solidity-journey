// SPDX-License-Identifier: MIT

pragma solidity >= 0.6.6 <0.9.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract Fund_me{
using SafeMathChainlink for uint256;

    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function fund() public payable{
        //setting threshold for how much a person can pay you
        uint256 minimumUSD = 50 * (10 * 18);//WEI amount
        require(getConvertRate(msg.value) >= minimumUSD, "MORE OR EQUAL TO $50");
        //convert dollar to etherium
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
        //eth to other currency rates
        
    
    }
    function getversion() public view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }
    function getprice() public view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int256 answer,,,) = priceFeed.latestRoundData();

        return uint256(answer * 10000000000);
    }

    function getConvertRate(uint256 ethAmount) public view returns (uint256){
      uint256 ethPrice = getprice();
      uint256 ethAmountToUsd = (ethPrice * ethAmount) / 1000000000000000000;
      return ethAmountToUsd;
    }


    modifier OnlyOwner{
        require(msg.sender == owner);
        _;
    }
    function withdraw() payable OnlyOwner public {
        //to validate who can withdraw
        msg.sender.transfer(address(this).balance);

        for (uint256 funderIndex = 0; funderIndex< funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
        
    }
}
