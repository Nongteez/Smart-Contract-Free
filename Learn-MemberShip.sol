// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MembershipManagement {
    // โครงสร้างข้อมูลของสมาชิก
    struct Member {
        string name;
        uint256 monthlyFee;
        bool isActive;
    }

    // แมปที่ใช้เก็บข้อมูลของสมาชิก
    mapping(address => Member) public members;
    address public owner;

    // ประวัติการชำระเงิน
    mapping(address => uint256) public paymentHistory;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "only owner call this function");
        _;
    }

    // ฟังก์ชันเพิ่มสมาชิกใหม่
    function addMember(address _address, string memory _name, uint256 _monthlyFee) external onlyOwner {
        require(members[_address].monthlyFee == 0, "Member already exists");
        members[_address] = Member(_name, _monthlyFee, true);
    }

    // ฟังก์ชันลบสมาชิก
    function removeMember(address _address) external onlyOwner {
        require(members[_address].monthlyFee > 0, "Member not found");
        delete members[_address];
    }

    // ฟังก์ชันอัปเดตข้อมูลส่วนตัวของสมาชิก
    function updateMember(address _address, string memory _name, uint256 _monthlyFee) external onlyOwner {
        require(members[_address].monthlyFee > 0, "Member not found");
        members[_address].name = _name;
        members[_address].monthlyFee = _monthlyFee;
    }

    // ฟังก์ชันชำระค่าสมาชิกรายเดือน
    function payMonthlyFee() external payable {
        require(members[msg.sender].monthlyFee > 0, "Member not found");
        require(msg.value == members[msg.sender].monthlyFee, "Incorrect monthly fee amount");

        // ทำการบันทึกการชำระเงิน
        paymentHistory[msg.sender] += msg.value;

        // อัปเดตสถานะการชำระเงิน
        members[msg.sender].isActive = true;
    }

    // ฟังก์ชันตรวจสอบสถานะการชำระเงินค่าสมาชิกรายเดือน
    function checkMembershipStatus(address _address) external view returns (bool) {
        if (members[_address].monthlyFee == 0) {
            return false; // สมาชิกไม่มีอยู่ในระบบ
        }
        return members[_address].isActive;
    }
}




/* โค้ดเก่า
contract MembershipManagement {
    // โครงสร้างข้อมูลของสมาชิก
    struct Member {
        string name;
        uint256 monthlyFee;
        bool isActive;
    }

    // แมปที่ใช้เก็บข้อมูลของสมาชิก
    mapping(address => Member) public members;

    // ฟังก์ชันเพิ่มสมาชิกใหม่
    function addMember(address _address, string memory _name, uint256 _monthlyFee) external {
        require(members[_address].monthlyFee == 0, "Member already exists");

        members[_address] = Member(_name, _monthlyFee, true);
    }

    // ฟังก์ชันลบสมาชิก
    function removeMember(address _address) external {
        require(members[_address].monthlyFee > 0, "Member not found");

        delete members[_address];
    }

    // ฟังก์ชันอัปเดตข้อมูลส่วนตัวของสมาชิก
    function updateMember(address _address, string memory _name, uint256 _monthlyFee) external {
        require(members[_address].monthlyFee > 0, "Member not found");

        members[_address].name = _name;
        members[_address].monthlyFee = _monthlyFee;
    }

    // ฟังก์ชันชำระค่าสมาชิกรายเดือน
    function payMonthlyFee(address _address) external payable {
        require(members[_address].monthlyFee > 0, "Member not found");
        require(msg.value == members[_address].monthlyFee, "Incorrect monthly fee amount");

        // ทำการยืนยันการชำระเงิน
        // (ตัวอย่าง: บันทึกการชำระเงินลงในบัญชีหรือส่งอีเมลแจ้งเตือน)
    }

    // ฟังก์ชันตรวจสอบสถานะการชำระเงินค่าสมาชิกรายเดือน
    function checkMembershipStatus(address _address) external view returns (bool) {
        if (members[_address].monthlyFee == 0) {
            return false; // สมาชิกไม่มีอยู่ในระบบ
        }

        return members[_address].isActive;
    }
}*/



/*
1. ระบบจัดการสมาชิกและค่าสมาชิกรายเดือน
พัฒนาสัญญาอัจฉริยะเพื่อจัดการสมาชิกภายในสโมสรหรือชุมชน รวมถึงการจัดเก็บค่าสมาชิกรายเดือน:

เพิ่ม/ลบ สมาชิก
อัปเดตข้อมูลส่วนตัวของสมาชิก
รับการชำระเงินค่าสมาชิก
ตรวจสอบสถานะการชำระเงิน

ในส่วนของสัญญานี้ เรามีโครงสร้างข้อมูล Member ที่ระบุค่าสมาชิกรายเดือน รวมถึงการเพิ่ม/ลบ/อัปเดต และตรวจสอบสมาชิก 
รวมทั้งการชำระค่าสมาชิกรายเดือนด้วยฟังก์ชัน payMonthlyFee ซึ่งต้องมีการส่ง Ether ในขณะเรียกใช้งานเพื่อชำระค่าสมาชิกรายเดือนให้กับสมาชิกที่กำหนดไว้ในสัญญา
 และ checkMembershipStatus สำหรับตรวจสอบสถานะการชำระเงินของสมาชิกในระบบ ถ้าหากมีการชำระค่าสมาชิกรายเดือนเรียบร้อยแล้ว สมาชิกจะถูกตั้งค่าให้เป็น Active โดยอัตโนมัติ 
 และสามารถใช้บริการต่างๆของสมาชิกได้ตามปกติ หากไม่ได้ชำระค่าสมาชิกรายเดือนเป็นระยะเวลานาน สมาชิกจะถูกตั้งค่าให้เป็น Inactive และจะไม่สามารถใช้บริการต่างๆของสมาชิกได

*/