// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LoyaltyProgram {
mapping(address => uint256) public points;
address public owner;
 constructor () {
        owner = msg.sender;
    }
    modifier onlyOwner{
       require(msg.sender == owner ,"only owner call this function");
       _; 
    }

function awardPoints (address user, uint256 amount) public onlyOwner {
points [user] += amount;
}
}


/*
contract LoyaltyProgram {
ประกาศสัญญา (contract) ชื่อว่า LoyaltyProgram


    mapping(address => uint256) public points;
ประกาศตัวแปร points ซึ่งเป็น mapping โดยใช้ address เป็นกุญแจและเก็บค่าประเภท uint256 เพื่อบันทึกคะแนนสะสมของผู้ใช้แต่ละคน และตั้งให้ตัวแปรนี้เป็น public เพื่อให้สามารถเข้าถึงได้จากภายนอกสัญญา


    address public owner;
ประกาศตัวแปร owner ซึ่งเก็บที่อยู่ของเจ้าของสัญญา


    constructor() {
        owner = msg.sender;
    }
คอนสตรักเตอร์ของสัญญา ตั้งค่า owner เป็นที่อยู่ของผู้ที่ทำการดีพลอย (deploy) สัญญานี้


    modifier onlyOwner {
        require(msg.sender == owner, "only owner call this function");
        _;
    }
ประกาศตัวแก้ (modifier) ชื่อ onlyOwner เพื่อจำกัดการเรียกใช้งานฟังก์ชันบางฟังก์ชันได้เฉพาะเจ้าของสัญญาเท่านั้น โดยตรวจสอบว่าผู้เรียกใช้เป็นเจ้าของสัญญาหรือไม่


    function awardPoints(address user, uint256 amount) public onlyOwner {
        points[user] += amount;
    }
ฟังก์ชัน awardPoints เพิ่มคะแนนสะสมให้กับผู้ใช้ที่ระบุ โดยรับพารามิเตอร์ user ซึ่งเป็นที่อยู่ของผู้ใช้และ amount ซึ่งเป็นจำนวนคะแนนที่จะเพิ่ม ฟังก์ชันนี้ใช้ตัวแก้ onlyOwner เพื่อให้เฉพาะเจ้าของสัญญาเท่านั้นที่สามารถเรียกใช้งานได้

สรุป: โค้ดนี้เป็นสัญญา (contract) ในภาษา Solidity ที่ใช้จัดการระบบคะแนนสะสม โดยมีการบันทึกคะแนนของผู้ใช้ใน
 mapping points ฟังก์ชัน awardPoints ใช้สำหรับเพิ่มคะแนนให้กับผู้ใช้ และฟังก์ชันนี้สามารถเรียกใช้งานได้เฉพาะเจ้าของสัญญาเท่านั้น
*/