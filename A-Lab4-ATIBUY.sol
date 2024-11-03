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
       require(msg.sender == owner ,"only owner call this function");
       
       _; //ไปที่ฟังก์ชันนั้นๆที่เรียกใช้  
    }

    function fund() public payable {
        uint256 MinimumUSD =(210*(10**18));
        uint256 MaximumUSD =(520*(10**18));

        require(getConversationRate(msg.value) >= MinimumUSD , "You Need To Pay More 210");
        require(getConversationRate(msg.value) <= MaximumUSD , "You Need To Pay More 520");

  
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
        address payable sender = payable(msg.sender);
        sender.transfer(address(this).balance);
        for(uint256 PayerIndex = 0; PayerIndex < ListOfPayer.length; PayerIndex++){
            address AddressPayer = ListOfPayer[PayerIndex];
            AddressToAmountPaid[AddressPayer] = 0;
        }
        ListOfPayer = new address[](0);
    }



}




/*

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
นำเข้าอินเตอร์เฟส AggregatorV3Interface จากไลบรารี Chainlink ซึ่งใช้สำหรับดึงข้อมูลราคาจาก Chainlink Price Feeds


contract FundMe {
ประกาศสัญญา (contract) ชื่อว่า FundMe


    mapping(address => uint256) public AddressToAmountPaid;
ประกาศตัวแปร AddressToAmountPaid ซึ่งเป็น mapping โดยใช้ address เป็นกุญแจและเก็บค่าประเภท uint256 เพื่อบันทึกจำนวนเงินที่ผู้ใช้แต่ละคนจ่ายเข้ามา


    address public owner;
ประกาศตัวแปร owner ซึ่งเก็บที่อยู่ของเจ้าของสัญญา


    address[] public ListOfPayer;
ประกาศตัวแปร ListOfPayer ซึ่งเป็นอาร์เรย์ที่เก็บที่อยู่ของผู้จ่ายเงิน


    constructor() {
        owner = msg.sender;
    }
คอนสตรักเตอร์ของสัญญา ตั้งค่า owner เป็นที่อยู่ของผู้ที่ทำการดีพลอย (deploy) สัญญานี้


    modifier onlyOwner {
        require(msg.sender == owner, "only owner call this function");
        _;
    }
ประกาศตัวแก้ (modifier) ชื่อ onlyOwner เพื่อจำกัดการเรียกใช้งานฟังก์ชันบางฟังก์ชันได้เฉพาะเจ้าของสัญญาเท่านั้น โดยตรวจสอบว่าผู้เรียกใช้เป็นเจ้าของสัญญาหรือไม่


    function fund() public payable {
        uint256 MinimumUSD = (210 * (10**18));
        uint256 MaximumUSD = (520 * (10**18));

        require(getConversationRate(msg.value) >= MinimumUSD, "You Need To Pay More 210");
        require(getConversationRate(msg.value) <= MaximumUSD, "You Need To Pay More 520");

        AddressToAmountPaid[msg.sender] += msg.value;
        ListOfPayer.push(msg.sender);
    }
ฟังก์ชัน fund รับเงินเข้ามา (payable) และตรวจสอบว่ามูลค่าในหน่วย USD ของเงินที่ได้รับอยู่ระหว่าง 210 USD ถึง 520 USD โดยใช้ฟังก์ชัน getConversationRate 
จากนั้นบันทึกจำนวนเงินที่ผู้ใช้จ่ายเข้ามาและเพิ่มที่อยู่ของผู้ใช้ลงใน ListOfPayer


    function getVersion() public view returns (uint256) {
        AggregatorV3Interface PriceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return PriceFeed.version();
    }
ฟังก์ชัน getVersion ดึงเวอร์ชันของ Chainlink Price Feed โดยใช้ที่อยู่ของ Price Feed


    function getPrice() public view returns (uint256) {
        AggregatorV3Interface PriceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 answer, , , ) = PriceFeed.latestRoundData();
        return uint256(answer) / (10**8);
    }
ฟังก์ชัน getPrice ดึงข้อมูลราคาล่าสุดของ ETH จาก Chainlink Price Feed และแปลงค่าเป็นหน่วย USD โดยหารด้วย 10^8


    function getConversationRate(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethInUSD = (ethAmount * ethPrice);
        return ethInUSD;
    }
ฟังก์ชัน getConversationRate คำนวณมูลค่า USD ของจำนวน ETH ที่ระบุ โดยใช้ฟังก์ชัน getPrice ดึงราคาของ ETH และคำนวณเป็นหน่วย USD


    function WithDraw() public payable onlyOwner {
        address payable sender = payable(msg.sender);
        sender.transfer(address(this).balance);
        for (uint256 PayerIndex = 0; PayerIndex < ListOfPayer.length; PayerIndex++) {
            address AddressPayer = ListOfPayer[PayerIndex];
            AddressToAmountPaid[AddressPayer] = 0;
        }
        ListOfPayer = new address ;
    }
ฟังก์ชัน WithDraw อนุญาตให้เจ้าของสัญญาถอนเงินทั้งหมดออกจากสัญญาและรีเซ็ตข้อมูลการชำระเงินของผู้ใช้ทั้งหมดใน AddressToAmountPaid และ ListOfPayer

สรุป: โค้ดนี้เป็นสัญญา (contract) ในภาษา Solidity ที่อนุญาตให้ผู้ใช้สามารถจ่ายเงินในช่วงระหว่าง 210 USD ถึง 520 USD โดยใช้ Chainlink Price Feed
 ในการคำนวณมูลค่า USD ของ ETH ที่ส่งเข้ามา เจ้าของสัญญาสามารถถอนเงินทั้งหมดออกจากสัญญาได้และรีเซ็ตข้อมูลการชำระเงินของผู้ใช้ทั้งหมด







*/