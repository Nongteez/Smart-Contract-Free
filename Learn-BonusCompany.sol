// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract EmployeeBenefits {
    
    address private owner;
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    // โครงสร้างข้อมูลพนักงาน
    struct Employee {
        string id;
        string firstName;
        string lastName;
        uint256 monthsWorked;
        address walletAddress;
        uint256 monthlyBonus;
    }

    // เก็บข้อมูลพนักงานทั้งหมดในอาร์เรย์
    Employee[] public employees;
    
    // แมปข้อมูลพนักงานจาก id
    mapping(string => Employee) public employeeSearchByID;
    
    // ฟังก์ชันเพิ่มข้อมูลพนักงานใหม่
    function addEmployee(
        string memory _id,
        string memory _firstName,
        string memory _lastName,
        address _walletAddress
    ) public onlyOwner {
        require(bytes(employeeSearchByID[_id].id).length == 0, "Employee already exists.");

        Employee memory newEmployee = Employee({
            id: _id,
            firstName: _firstName,
            lastName: _lastName,
            monthsWorked: 0,
            walletAddress: _walletAddress,
            monthlyBonus: 0
        });

        employees.push(newEmployee);
        employeeSearchByID[_id] = newEmployee;
    }

    // ฟังก์ชันเพิ่มจำนวนเดือนที่ทำงานให้กับพนักงาน
    function addMonthsWorked(string memory _id) public onlyOwner {
        require(bytes(employeeSearchByID[_id].id).length > 0, "Employee not found.");

        employeeSearchByID[_id].monthsWorked += 1;
    }

    // ฟังก์ชันกำหนดโบนัสต่อเดือนสำหรับพนักงาน
    function setMonthlyBonus(string memory _id, uint256 _newBonus) public onlyOwner {
        require(bytes(employeeSearchByID[_id].id).length > 0, "Employee not found.");

        employeeSearchByID[_id].monthlyBonus = _newBonus;
    }

    // ฟังก์ชันคำนวณโบนัสทั้งหมดที่พนักงานจะได้รับ
    function calculateTotalBonus(string memory _id) public view returns (uint256) {
        require(bytes(employeeSearchByID[_id].id).length > 0, "Employee not found.");

        return employeeSearchByID[_id].monthsWorked * employeeSearchByID[_id].monthlyBonus;
    }

    // ฟังก์ชันจ่ายโบนัสให้กับพนักงาน
    function transferBonus(string memory _id) public onlyOwner {
        require(bytes(employeeSearchByID[_id].id).length > 0, "Employee not found.");

        uint256 totalBonus = calculateTotalBonus(_id);
        require(totalBonus > 0, "No bonus to transfer.");

        address payable walletAddress = payable(employeeSearchByID[_id].walletAddress);
        require(address(this).balance >= totalBonus, "Not enough balance in contract");

        walletAddress.transfer(totalBonus);

        // รีเซ็ตจำนวนเดือนที่ทำงานและโบนัสหลังจากจ่ายโบนัส
        employeeSearchByID[_id].monthsWorked = 0;
        employeeSearchByID[_id].monthlyBonus = 0;
    }
}


/*
โจทย์: ระบบจัดการสวัสดิการพนักงาน
เพิ่มข้อมูลพนักงาน:

สร้างโครงสร้างข้อมูลสำหรับพนักงานที่เก็บข้อมูล เช่น ID, ชื่อ, นามสกุล, จำนวนเดือนที่ทำงาน, ที่อยู่กระเป๋าเงิน และโบนัส
สร้างฟังก์ชันสำหรับเพิ่มข้อมูลพนักงานใหม่เข้าไปในระบบ
เพิ่มจำนวนเดือนที่ทำงาน:

สร้างฟังก์ชันสำหรับเพิ่มจำนวนเดือนที่ทำงานให้กับพนักงาน
กำหนดโบนัสต่อเดือน:

สร้างฟังก์ชันสำหรับกำหนดโบนัสต่อเดือนสำหรับพนักงาน
คำนวณโบนัสทั้งหมด:

สร้างฟังก์ชันสำหรับคำนวณโบนัสทั้งหมดที่พนักงานจะได้รับ
จ่ายโบนัสให้พนักงาน:

สร้างฟังก์ชันสำหรับจ่ายโบนัสให้กับพนักงาน และรีเซ็ตจำนวนเดือนที่ทำงานและโบนัสหลังจากจ่ายโบนัส
*/