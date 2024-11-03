// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMeX{
    mapping(address => uint256) public AddressToAmountPaid;
    address public owner;
    address[] public ListOfPayer;
    uint256 public minimumUSD = 210; // Set minimum USD
    uint256 public maximumUSD = 520; // Set maximum USD
    
    constructor () {
        owner = msg.sender;
    }
    
    modifier onlyOwner{
       require(msg.sender == owner ,"s");
       _; // Go to the function calling it
    }

    function fund() public payable {
        require(getConversionRate(msg.value) >= minimumUSD, "You Need To Pay More");
        require(getConversionRate(msg.value) <= maximumUSD, "You Overpaid");

        AddressToAmountPaid[msg.sender] += msg.value;
        ListOfPayer.push(msg.sender);
    }

    function getPrice() public view returns(uint256) {
        AggregatorV3Interface PriceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 answer , , , ) = PriceFeed.latestRoundData();
        return uint256(answer)/(10**8);   //3943
    }

    function getConversionRate(uint256 ethAmount) public view returns(uint256) {
        uint256 ethPrice = getPrice(); //3943
        uint256 ethInUSD = (ethAmount * ethPrice) / 10**18; 
        return ethInUSD;         
    }    

    function WithDraw() public payable onlyOwner  {
        address payable sender = payable(msg.sender);
        sender.transfer(address(this).balance);
        for(uint256 PayerIndex = 0; PayerIndex < ListOfPayer.length; PayerIndex++){
            address AddressPayer = ListOfPayer[PayerIndex];
            AddressToAmountPaid[AddressPayer] = 0;
        }
        ListOfPayer = new address[](0);
    }
}