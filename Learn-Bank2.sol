// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Bank {
    address private owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    // Mapping เพื่อเก็บยอดเงินของผู้ใช้แต่ละคน
    mapping(address => uint256) private balances;

    // อีเวนต์สำหรับการฝากและถอนเงิน
    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);

    // ฟังก์ชันสำหรับการฝากเงิน
    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero.");
        balances[msg.sender] += msg.value;

        emit Deposit(msg.sender, msg.value);
    }

    // ฟังก์ชันสำหรับการถอนเงิน
    function withdraw(uint256 amount) public {
        require(amount > 0, "Withdrawal amount must be greater than zero.");
        require(balances[msg.sender] >= amount, "Insufficient balance.");

        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);

        emit Withdrawal(msg.sender, amount);
    }

    // ฟังก์ชันสำหรับการตรวจสอบยอดเงินคงเหลือของผู้ใช้
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    // ฟังก์ชันสำหรับการตรวจสอบยอดเงินรวมในระบบ (เฉพาะเจ้าของเท่านั้นที่เรียกได้)
    function getTotalBalance() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }
}

/*
อธิบายโค้ด
ตัวแปรและโครงสร้างพื้นฐาน

owner: เก็บที่อยู่ของเจ้าของสัญญา ซึ่งถูกตั้งค่าในคอนสตรักเตอร์
balances: แมปที่เก็บยอดเงินของผู้ใช้แต่ละคน โดยใช้ที่อยู่ของผู้ใช้เป็นคีย์
อีเวนต์

Deposit: อีเวนต์ที่แจ้งเมื่อมีการฝากเงิน
Withdrawal: อีเวนต์ที่แจ้งเมื่อมีการถอนเงิน
ฟังก์ชัน

deposit: ฟังก์ชันสำหรับผู้ใช้ในการฝากเงินเข้าระบบ

ตรวจสอบว่าจำนวนเงินที่ฝากมากกว่า 0
เพิ่มยอดเงินฝากใน balances
ส่งอีเวนต์ Deposit
withdraw: ฟังก์ชันสำหรับผู้ใช้ในการถอนเงินจากระบบ

ตรวจสอบว่าจำนวนเงินที่ถอนมากกว่า 0
ตรวจสอบว่ายอดเงินคงเหลือเพียงพอสำหรับการถอน
ลดยอดเงินใน balances
ส่งเงินให้ผู้ใช้และส่งอีเวนต์ Withdrawal
getBalance: ฟังก์ชันสำหรับผู้ใช้ในการตรวจสอบยอดเงินคงเหลือของตนเอง

คืนค่ายอดเงินคงเหลือใน balances ของผู้เรียก
getTotalBalance: ฟังก์ชันสำหรับเจ้าของสัญญาในการตรวจสอบยอดเงินรวมในระบบ

ใช้ onlyOwner modifier เพื่อจำกัดการเข้าถึง
คืนค่ายอดเงินรวมที่อยู่ในสัญญา
*/