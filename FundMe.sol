// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe{
    mapping(address => uint256) public  AddressToAmountPaid;
    address public owner;
    address[] public ListOfPayer;
    
    constructor () {
        owner = msg.sender;
    }
    
    modifier onlyOwner{
       require(msg.sender == owner ,"adminna");
       
       _; //ไปที่ฟังก์ชันนั้นๆที่เรียกใช้  
    }
    function fund() public payable {
        uint256 MinimumUSD =(50*(10**18))/getPrice();
        require(getConversationRate(msg.value) >= MinimumUSD , "You Need To Pay More");
        /*if(msg.value < MinimumUSD){
           "Kuy" 
        }*/
        AddressToAmountPaid[msg.sender] += msg.value;
        ListOfPayer.push(msg.sender);
    }

    function getVersion() public view returns(uint256){
        AggregatorV3Interface PriceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return PriceFeed.version();
    }

    function getPrice() public view returns(uint256) {
        AggregatorV3Interface PriceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 answer , , , ) = PriceFeed.latestRoundData();
        return uint256(answer)/(10**8);   
    }

    function getConversationRate(uint256 ethAmount) public view returns(uint256) {
        uint256 ethPrice = getPrice(); //ตัวแปลดึง Function getPrice
        uint256 ethInUSD = (ethAmount * ethPrice);
        return ethInUSD;         
    }    

    function WithDraw() public payable onlyOwner  {
       // require(msg.sender == owner ,"adminna");
        address payable sender = payable(msg.sender);
        sender.transfer(address(this).balance);
        for(uint256 PayerIndex = 0; PayerIndex < ListOfPayer.length; PayerIndex++){
            address AddressPayer = ListOfPayer[PayerIndex];
            AddressToAmountPaid[AddressPayer] = 0;
        }
        ListOfPayer = new address[](0);
    }



}
