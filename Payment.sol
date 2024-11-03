// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract UniversityRegistration {
    mapping(address => uint256) public AddressToAmountPaid;
    address public owner;
    address[] public ListOfStudents;
    
    uint256 public constant MINIMUM_USD = 210 * 10**18;
    uint256 public constant MAXIMUM_USD = 520 * 10**18;
    AggregatorV3Interface internal priceFeed;

    constructor(address _priceFeed) {
        owner = msg.sender;
        priceFeed = AggregatorV3Interface(_priceFeed);
    }
    
    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function fund() public payable {
        uint256 ethAmountInUsd = getConversionRate(msg.value);
        require(ethAmountInUsd >= MINIMUM_USD, "You need to pay at least 210 USD");
        require(ethAmountInUsd <= MAXIMUM_USD, "You need to pay at most 520 USD");
        
        AddressToAmountPaid[msg.sender] += msg.value;
        ListOfStudents.push(msg.sender);
    }

    function getPrice() public view returns (uint256) {
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer * 10**10);
    }

    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethAmount * ethPrice) / 10**18;
        return ethAmountInUsd;
    }

    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);

        for (uint256 i = 0; i < ListOfStudents.length; i++) {
            address student = ListOfStudents[i];
            AddressToAmountPaid[student] = 0;
        }

        ListOfStudents = new address[](0);
    }
}
