// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract PayrollSystem {
    struct Employee {
        uint employeeId;
        string name;
        uint salaryRate;
        uint hoursWorked;
        uint totalPaid;
        address payable walletAddress; // เพิ่ม wallet address
    }

    struct Bonus {
        uint bonusAmount;
        uint dateGiven;
    }

    address public owner;
    uint public companyPerformance;
    mapping(uint => Employee) public employees;
    mapping(uint => Bonus[]) public bonuses;
    uint public employeeCount;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addEmployee(string memory _name, uint _salaryRate, address payable _walletAddress) public onlyOwner {
        employeeCount++;
        employees[employeeCount] = Employee(employeeCount, _name, _salaryRate, 0, 0, _walletAddress);
    }

    function updateHoursWorked(uint _employeeId, uint _hours) public onlyOwner {
        Employee storage employee = employees[_employeeId];
        employee.hoursWorked += _hours;
    }

    function paySalary(uint _employeeId) public onlyOwner {
        Employee storage employee = employees[_employeeId];
        uint salaryDue = employee.salaryRate * employee.hoursWorked;
        require(address(this).balance >= salaryDue, "Insufficient funds");
        employee.walletAddress.transfer(salaryDue); // โอนเงินเข้า wallet address ของพนักงาน
        employee.totalPaid += salaryDue;
        employee.hoursWorked = 0; // Reset hours after payment
    }

    function recordCompanyPerformance(uint _performance) public onlyOwner {
        companyPerformance = _performance;
    }

    function payBonus(uint _employeeId) public onlyOwner {
        require(companyPerformance > 100, "Performance threshold not met");
        uint bonusAmount = employees[_employeeId].salaryRate; // Example bonus calculation
        employees[_employeeId].walletAddress.transfer(bonusAmount); // โอนโบนัสเข้า wallet address ของพนักงาน
        bonuses[_employeeId].push(Bonus(bonusAmount, block.timestamp));
    }

    function getBonusHistory(uint _employeeId) public view returns (Bonus[] memory) {
        return bonuses[_employeeId];
    }

    // Function to receive funds to the contract
    receive() external payable {}
}


/* 3. ระบบจ่ายเงินเดือนและโบนัสอัตโนมัติ
สร้างสัญญาอัจฉริยะที่จัดการการจ่ายเงินเดือนและโบนัสให้กับพนักงาน:

คำนวณและจ่ายเงินเดือนตามชั่วโมงการทำงาน
จัดการและจ่ายโบนัสตามผลประกอบการของบริษัท
จัดเก็บประวัติการจ่ายเงินเดือนและโบนัส 

คำอธิบายโค้ด:
Structs: ใช้ Employee เพื่อเก็บข้อมูลพนักงาน และ Bonus เพื่อจัดเก็บประวัติโบนัส.
Mapping: ใช้เพื่อจัดเก็บข้อมูลพนักงานและประวัติโบนัสของแต่ละพนักงาน.
Functions:
addEmployee: เพิ่มพนักงานใหม่.
updateHoursWorked: อัปเดตชั่วโมงการทำงานของพนักงาน.
paySalary: คำนวณและจ่ายเงินเดือนตามชั่วโมงการทำงาน.
recordCompanyPerformance: บันทึกผลการดำเนินงานของบริษัท.
payBonus: จ่ายโบนัสตามผลการดำเนินงานของบริษัท.
getBonusHistory: ดึงประวัติการจ่ายโบนัสของพนักงาน.


contract PayrollSystem {

    // โครงสร้างข้อมูลของพนักงาน
    struct Employee {
        uint employeeId;          // รหัสพนักงาน
        string name;              // ชื่อพนักงาน
        uint salaryRate;          // อัตราเงินเดือนต่อชั่วโมง
        uint hoursWorked;         // จำนวนชั่วโมงที่ทำงาน
        uint totalPaid;           // ยอดเงินที่จ่ายไปทั้งหมด
        address payable walletAddress; // ที่อยู่กระเป๋าเงิน (wallet) ของพนักงาน
    }

    // โครงสร้างข้อมูลของโบนัส
    struct Bonus {
        uint bonusAmount;         // จำนวนโบนัส
        uint dateGiven;           // วันที่ให้โบนัส
    }

    address public owner;         // เจ้าของสัญญา (เจ้าของระบบ)
    uint public companyPerformance; // ประสิทธิภาพของบริษัท
    mapping(uint => Employee) public employees; // การแมพจากรหัสพนักงานไปยังข้อมูลพนักงาน
    mapping(uint => Bonus[]) public bonuses;    // การแมพจากรหัสพนักงานไปยังประวัติโบนัส
    uint public employeeCount;   // จำนวนพนักงานทั้งหมด

    // ตัวกำหนดว่าเฉพาะเจ้าของเท่านั้นที่สามารถเรียกใช้ฟังก์ชันได้
    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized"); // ตรวจสอบว่าเป็นเจ้าของหรือไม่
        _;
    }

    // คอนสตรัคเตอร์สำหรับกำหนดเจ้าของระบบ
    constructor() {
        owner = msg.sender; // กำหนดเจ้าของระบบเป็นผู้ที่ deploy สัญญานี้
    }

    // ฟังก์ชันเพิ่มพนักงานใหม่
    function addEmployee(string memory _name, uint _salaryRate, address payable _walletAddress) public onlyOwner {
        employeeCount++; // เพิ่มจำนวนพนักงาน
        employees[employeeCount] = Employee(employeeCount, _name, _salaryRate, 0, 0, _walletAddress); // เพิ่มข้อมูลพนักงานใหม่
    }

    // ฟังก์ชันอัพเดทจำนวนชั่วโมงที่ทำงานของพนักงาน
    function updateHoursWorked(uint _employeeId, uint _hours) public onlyOwner {
        Employee storage employee = employees[_employeeId]; // ดึงข้อมูลพนักงานตามรหัส
        employee.hoursWorked += _hours; // เพิ่มจำนวนชั่วโมงที่ทำงาน
    }

    // ฟังก์ชันจ่ายเงินเดือนให้พนักงาน
    function paySalary(uint _employeeId) public onlyOwner {
        Employee storage employee = employees[_employeeId]; // ดึงข้อมูลพนักงานตามรหัส
        uint salaryDue = employee.salaryRate * employee.hoursWorked; // คำนวณเงินเดือนที่ต้องจ่าย
        require(address(this).balance >= salaryDue, "Insufficient funds"); // ตรวจสอบว่ายอดเงินในสัญญามีเพียงพอหรือไม่
        employee.walletAddress.transfer(salaryDue); // โอนเงินเดือนเข้า wallet address ของพนักงาน
        employee.totalPaid += salaryDue; // บันทึกยอดเงินที่จ่ายไปแล้ว
        employee.hoursWorked = 0; // รีเซ็ตจำนวนชั่วโมงที่ทำงานหลังจากจ่ายเงินเดือน
    }

    // ฟังก์ชันบันทึกประสิทธิภาพของบริษัท
    function recordCompanyPerformance(uint _performance) public onlyOwner {
        companyPerformance = _performance; // บันทึกค่าประสิทธิภาพของบริษัท
    }

    // ฟังก์ชันจ่ายโบนัสให้พนักงาน
    function payBonus(uint _employeeId) public onlyOwner {
        require(companyPerformance > 100, "Performance threshold not met"); // ตรวจสอบว่าประสิทธิภาพของบริษัทมากกว่า 100 หรือไม่
        uint bonusAmount = employees[_employeeId].salaryRate; // คำนวณโบนัส (ตัวอย่าง: ใช้อัตราเงินเดือนเป็นโบนัส)
        employees[_employeeId].walletAddress.transfer(bonusAmount); // โอนโบนัสเข้า wallet address ของพนักงาน
        bonuses[_employeeId].push(Bonus(bonusAmount, block.timestamp)); // บันทึกประวัติโบนัส
    }

    // ฟังก์ชันดึงประวัติโบนัสของพนักงาน
    function getBonusHistory(uint _employeeId) public view returns (Bonus[] memory) {
        return bonuses[_employeeId]; // คืนค่าประวัติโบนัสของพนักงาน
    }

    // ฟังก์ชันรับเงินเข้ามาในสัญญา
    receive() external payable {}
}
อธิบายเพิ่มเติม:
struct Employee: เป็นโครงสร้างข้อมูลที่ใช้เก็บรายละเอียดเกี่ยวกับพนักงาน เช่น รหัสพนักงาน, ชื่อ, อัตราเงินเดือน, จำนวนชั่วโมงที่ทำงาน, ยอดเงินที่จ่ายไปทั้งหมด และที่อยู่กระเป๋าเงินของพนักงาน
struct Bonus: เป็นโครงสร้างข้อมูลที่ใช้เก็บรายละเอียดเกี่ยวกับโบนัสที่พนักงานได้รับ เช่น จำนวนโบนัสและวันที่ให้โบนัส
address public owner: ตัวแปรที่เก็บที่อยู่ของเจ้าของสัญญา
uint public companyPerformance: ตัวแปรที่เก็บค่าประสิทธิภาพของบริษัท
mapping(uint => Employee) public employees: แมพจากรหัสพนักงานไปยังโครงสร้างข้อมูลพนักงาน
mapping(uint => Bonus[]) public bonuses: แมพจากรหัสพนักงานไปยังประวัติโบนัส
uint public employeeCount: ตัวแปรที่เก็บจำนวนพนักงานทั้งหมด
modifier onlyOwner(): ตัวกำหนดที่ใช้ตรวจสอบว่าเฉพาะเจ้าของเท่านั้นที่สามารถเรียกใช้ฟังก์ชันที่มีตัวกำหนดนี้ได้
constructor(): คอนสตรัคเตอร์ที่ใช้กำหนดเจ้าของระบบเป็นผู้ที่ deploy สัญญานี้
function addEmployee: ฟังก์ชันที่ใช้เพิ่มพนักงานใหม่
function updateHoursWorked: ฟังก์ชันที่ใช้บันทึกจำนวนชั่วโมงที่พนักงานทำงาน
function paySalary: ฟังก์ชันที่ใช้จ่ายเงินเดือนให้พนักงาน
function recordCompanyPerformance: ฟังก์ชันที่ใช้บันทึกประสิทธิภาพของบริษัท
function payBonus: ฟังก์ชันที่ใช้จ่ายโบนัสให้พนักงาน
function getBonusHistory: ฟังก์ชันที่ใช้ดึงประวัติโบนัสของพนักงาน
receive() external payable {}: ฟังก์ชันที่ใช้รับเงินเข้ามาในสัญญา
สัญญานี้จะช่วยในการจัดการระบบการจ่ายเงินเดือนและโบนัสให้กับพนักงานของบริษัท โดยมีการตรวจสอบสิทธิ์การเข้าถึงฟังก์ชันต่างๆ ด้วย modifier onlyOwner เพื่อให้แน่ใจว่าเฉพาะเจ้าของสัญญาเท่านั้นที่สามารถดำเนินการสำคัญๆ ได้


*/