// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract UniversityPayment {
    mapping(address => uint256) public AddressToAmountPaid;
    address public owner;
    address[] public ListOfPayers;
    AggregatorV3Interface internal priceFeed;

    constructor() {
        owner = msg.sender;
        priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function fund() public payable {
        uint256 MinimumUSD = 210 * 10**18;
        uint256 MaximumUSD = 520 * 10**18;
        
        uint256 paymentUSD = getConversionRate(msg.value);
        
        require(paymentUSD >= MinimumUSD, "You need to pay more than 210 USD");
        require(paymentUSD <= MaximumUSD, "You need to pay less than 520 USD");

        AddressToAmountPaid[msg.sender] += msg.value;
        ListOfPayers.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256) {
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        return uint256(answer) * 10**10; //ปรับราคาเป็น 18 ทศนิยม
    }

    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethInUSD = (ethAmount * ethPrice) / 10**18;
        return ethInUSD;
    }

    function withdraw() public payable onlyOwner {
        payable(msg.sender).transfer(address(this).balance);

        for (uint256 PayerIndex = 0; PayerIndex < ListOfPayers.length; PayerIndex++) {
            address AddressPayer = ListOfPayers[PayerIndex];
            AddressToAmountPaid[AddressPayer] = 0;
        }

        ListOfPayers = new address[](0) ;
    }
}
