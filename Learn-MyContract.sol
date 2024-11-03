// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract MyContract{

//Private
string _name;
uint _balance;

constructor(string memory name,uint balance){
     require(balance>=500,"balance greater 500 and equal (Money > 500) ");
     _name = name;
     _balance = balance;
}

function getBalance() public view returns (uint balance){
    return _balance;
}

function deposite(uint amount) public {
    _balance+=amount; }
    
}

/*
contract MyContract {

    // ประกาศตัวแปรแบบ private
    string _name; // ตัวแปรเก็บชื่อผู้ใช้งาน
    uint _balance; // ตัวแปรเก็บยอดเงินคงเหลือ

    // คอนสตรัคเตอร์ (Constructor) สำหรับการกำหนดค่าเริ่มต้นให้กับสัญญา
    constructor(string memory name, uint balance) {
        // ตรวจสอบเงื่อนไขว่าค่า balance ต้องไม่น้อยกว่า 500
        require(balance >= 500, "balance greater 500 and equal (Money > 500)");
        _name = name; // กำหนดค่าเริ่มต้นให้กับตัวแปร _name
        _balance = balance; // กำหนดค่าเริ่มต้นให้กับตัวแปร _balance
    }

    // ฟังก์ชันสำหรับการดูยอดเงินคงเหลือ
    function getBalance() public view returns (uint balance) {
        return _balance; // คืนค่าของตัวแปร _balance
    }

    // ฟังก์ชันสำหรับการฝากเงิน
    function deposite(uint amount) public {
        _balance += amount; // เพิ่มยอดเงินที่ฝากเข้ามาไปยังตัวแปร _balance
    }
    
}
อธิบายส่วนประกอบของโค้ด:
SPDX-License-Identifier: MIT: เป็นการกำหนดไลเซนส์ให้กับโค้ดนี้ว่าใช้ไลเซนส์ MIT
pragma solidity ^0.8.0: กำหนดเวอร์ชันของ Solidity ที่ใช้เป็นเวอร์ชัน 0.8.0 หรือใหม่กว่า
contract MyContract: การประกาศสัญญาอัจฉริยะชื่อ MyContract
string _name; uint _balance;: การประกาศตัวแปร _name และ _balance เพื่อเก็บข้อมูลชื่อและยอดเงินคงเหลือ
constructor(string memory name, uint balance): คอนสตรัคเตอร์ที่ถูกเรียกใช้เมื่อมีการสร้างสัญญาใหม่
require(balance >= 500, ...);: ตรวจสอบว่าค่า balance ที่ส่งเข้ามาต้องไม่น้อยกว่า 500
function getBalance() public view returns (uint balance): ฟังก์ชันสำหรับดูยอดเงินคงเหลือ
function deposite(uint amount) public: ฟังก์ชันสำหรับการฝากเงิน
_balance += amount;: เพิ่มยอดเงินที่ฝากเข้ามาไปยังยอดเงินคงเหลือ
โค้ดนี้จะทำงานโดยการเก็บข้อมูลชื่อและยอดเงินคงเหลือของผู้ใช้งานในตัวแปร _name และ _balance ซึ่งสามารถดูยอดเงินคงเหลือได้ผ่านฟังก์ชัน getBalance และสามารถฝากเงินได้ผ่านฟังก์ชัน deposite

*/