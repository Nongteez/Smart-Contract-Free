// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

contract LoyaltyProgram {
mapping(address => uint8) public points;

function reward(address user, uint8 pointsToAdd) public {
    require(pointsToAdd + points[user] >= points[user] ,"over flow");
    points[user] = points[user] += pointsToAdd;
}

}


/*
contract LoyaltyProgram {
ประกาศสัญญา (contract) ชื่อว่า LoyaltyProgram


mapping(address => uint8) public points;
ประกาศตัวแปร points ซึ่งเป็น mapping โดยใช้ address เป็นกุญแจและเก็บค่าประเภท uint8 เพื่อบันทึกคะแนนสะสมของผู้ใช้แต่ละคน และตั้งให้ตัวแปรนี้เป็น public เพื่อให้สามารถเข้าถึงได้จากภายนอกสัญญา


function reward(address user, uint8 pointsToAdd) public {
    require(pointsToAdd + points[user] >= points[user], "over flow");
    points[user] += pointsToAdd;
}
ฟังก์ชัน reward ใช้เพิ่มคะแนนสะสมให้กับผู้ใช้ที่ระบุ โดยรับพารามิเตอร์ user ซึ่งเป็นที่อยู่ของผู้ใช้และ pointsToAdd ซึ่งเป็นจำนวนคะแนนที่จะเพิ่ม

require(pointsToAdd + points[user] >= points[user], "over flow");:
ตรวจสอบว่าเมื่อเพิ่มคะแนนใหม่ (pointsToAdd) เข้าไปในคะแนนปัจจุบัน (points[user]) แล้วจะไม่มีการเกิด overflow โดยใช้ require เพื่อยืนยันเงื่อนไขนี้
points[user] += pointsToAdd;:
ถ้าเงื่อนไข require ผ่าน ฟังก์ชันจะเพิ่มคะแนนให้กับผู้ใช้

สรุป: โค้ดนี้เป็นสัญญา (contract) ในภาษา Solidity ที่ใช้จัดการระบบคะแนนสะสม โดยมีการบันทึกคะแนนของผู้ใช้ใน mapping points ฟังก์ชัน reward ใช้สำหรับเพิ่มคะแนนให้กับผู้ใช้ 
โดยมีการตรวจสอบว่าไม่มีการเกิด overflow ก่อนที่จะเพิ่มคะแนน










*/