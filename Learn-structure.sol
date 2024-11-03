// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

struct ManagerBank {
    string nameBank;
    uint ageBank;
    address accountBankOwner;
}

contract MyBank {
    uint private _balance = 1000; // ยอดเงินที่คนฝากเข้ามาเก็บในธนาคาร
    
    ManagerBank public manager; // นิยามผู้จัดการ
    
    // ฟังก์ชัน constructor กำหนดค่าผู้จัดการธนาคาร
    constructor(string memory _nameBank, uint _ageBank) {
        manager.nameBank = _nameBank;
        manager.ageBank = _ageBank;
        manager.accountBankOwner = msg.sender;
    }
    
    // ฟังก์ชันเรียกดูยอดเงินในธนาคาร
    function getBalance() public view returns (uint) {
        return _balance;
    }

    // ฟังก์ชันฝากเงินเข้าธนาคาร
    function deposit(uint amount) public {
        require(amount > 0, "Deposit amount must be greater than zero");
        _balance += amount;
    }

    // ฟังก์ชันถอนเงินจากธนาคาร
    function withdraw(uint amount) public {
        require(amount > 0, "Withdraw amount must be greater than zero");
        require(amount <= _balance, "Insufficient balance");
        _balance -= amount;
    }
}



/*
// โครงสร้างข้อมูลผู้จัดการธนาคาร
struct ManagerBank {
    string nameBank;          // ชื่อของผู้จัดการธนาคาร
    uint ageBank;             // อายุของผู้จัดการธนาคาร
    address accountBankOwner; // ที่อยู่ของผู้จัดการธนาคาร (ที่อยู่ Ethereum)
}

// สัญญาอัจฉริยะ (Smart Contract) ชื่อว่า MyBank
contract MyBank {
    uint private _balance = 1000; // ยอดเงินที่คนฝากเข้ามาเก็บในธนาคาร เริ่มต้นที่ 1000
   
    ManagerBank public manager; // นิยามผู้จัดการธนาคาร โดยสามารถเข้าถึงได้จากภายนอก
    
    // ฟังก์ชัน constructor กำหนดค่าผู้จัดการธนาคารเมื่อทำการสร้างสัญญา
    constructor(string memory _nameBank, uint _ageBank) {
        manager.nameBank = _nameBank;               // ตั้งค่าชื่อของผู้จัดการธนาคาร
        manager.ageBank = _ageBank;                 // ตั้งค่าอายุของผู้จัดการธนาคาร
        manager.accountBankOwner = msg.sender;      // ตั้งค่าที่อยู่ของผู้จัดการธนาคารเป็นผู้ที่ deploy สัญญานี้
    }
    
    // ฟังก์ชันสำหรับเรียกดูยอดเงินในธนาคาร
    function getBalance() public view returns (uint) {
        return _balance; // คืนค่ายอดเงินในธนาคาร
    }

    // ฟังก์ชันสำหรับฝากเงินเข้าธนาคาร
    function deposit(uint amount) public {
        require(amount > 0, "Deposit amount must be greater than zero"); // ตรวจสอบว่าจำนวนเงินที่ฝากต้องมากกว่า 0
        _balance += amount; // เพิ่มยอดเงินในธนาคารตามจำนวนที่ฝาก
    }

    // ฟังก์ชันสำหรับถอนเงินจากธนาคาร
    function withdraw(uint amount) public {
        require(amount > 0, "Withdraw amount must be greater than zero"); // ตรวจสอบว่าจำนวนเงินที่ถอนต้องมากกว่า 0
        require(amount <= _balance, "Insufficient balance"); // ตรวจสอบว่ายอดเงินในธนาคารเพียงพอต่อการถอน
        _balance -= amount; // ลดยอดเงินในธนาคารตามจำนวนที่ถอน
    }
}
การอธิบายโค้ด:
pragma solidity ^0.8.0;

กำหนดเวอร์ชันของ Solidity ที่จะใช้ในการคอมไพล์โค้ดนี้
struct ManagerBank { ... }

โครงสร้างข้อมูล ManagerBank ใช้สำหรับเก็บข้อมูลผู้จัดการธนาคาร ประกอบด้วย nameBank (ชื่อ), ageBank (อายุ), และ accountBankOwner (ที่อยู่ Ethereum)
contract MyBank { ... }

สัญญาอัจฉริยะชื่อ MyBank ที่มีการจัดการยอดเงินในธนาคารและข้อมูลผู้จัดการธนาคาร
uint private _balance = 1000;

ตัวแปร _balance เป็นตัวแปรส่วนตัว (private) ใช้เก็บยอดเงินในธนาคาร เริ่มต้นที่ 1000
ManagerBank public manager;

ตัวแปร manager เป็นตัวแปรสาธารณะ (public) ใช้เก็บข้อมูลผู้จัดการธนาคาร และสามารถเข้าถึงได้จากภายนอก
constructor(string memory _nameBank, uint _ageBank) { ... }

ฟังก์ชัน constructor ใช้สำหรับกำหนดค่าผู้จัดการธนาคารเมื่อมีการสร้างสัญญา โดยรับพารามิเตอร์ nameBank (ชื่อ) และ ageBank (อายุ) และกำหนด accountBankOwner เป็นผู้ที่ deploy สัญญานี้
function getBalance() public view returns (uint) { ... }

ฟังก์ชัน getBalance ใช้สำหรับเรียกดูยอดเงินในธนาคาร โดยคืนค่า _balance
function deposit(uint amount) public { ... }

ฟังก์ชัน deposit ใช้สำหรับฝากเงินเข้าธนาคาร โดยรับพารามิเตอร์ amount (จำนวนเงินที่ฝาก) และเพิ่มยอดเงินในธนาคารตามจำนวนที่ฝาก
function withdraw(uint amount) public { ... }

ฟังก์ชัน withdraw ใช้สำหรับถอนเงินจากธนาคาร โดยรับพารามิเตอร์ amount (จำนวนเงินที่ถอน) และลดยอดเงินในธนาคารตามจำนวนที่ถอน
โค้ดนี้ช่วยให้สามารถดำเนินการฝากและถอนเงินจากธนาคารได้ตามที่ต้องการ และยังสามารถเรียกดูยอดเงินในธนาคารได้อย่างง่ายดาย

*/