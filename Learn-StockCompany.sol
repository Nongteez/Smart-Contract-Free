// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract EmployeeShares {
    
    address private owner;
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }


// ฟังก์ชันสำหรับฝากเงินเข้าสัญญา
function deposit() public payable {
    // ที่นี่อาจจะบันทึกข้อมูลเพิ่มเติม หรือทำการตรวจสอบเงื่อนไขต่างๆ ถ้าจำเป็น
}

    // โครงสร้างข้อมูลพนักงาน
    struct Employee {
        string id;
        string firstName;
        string lastName;
        uint256 sharesReceived;
        address walletAddress;
        uint256 bonusShares;
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
            sharesReceived: 0,
            walletAddress: _walletAddress,
            bonusShares: 0
        });

        employees.push(newEmployee);
        employeeSearchByID[_id] = newEmployee;
    }

    // ฟังก์ชันเพิ่มจำนวนหุ้นที่ได้รับให้กับพนักงาน
    function addSharesReceived(string memory _id, uint256 _shares) public onlyOwner {
        require(bytes(employeeSearchByID[_id].id).length > 0, "Employee not found.");

        employeeSearchByID[_id].sharesReceived += _shares;
    }

    // ฟังก์ชันกำหนดจำนวนหุ้นโบนัสสำหรับพนักงาน
    function setBonusShares(string memory _id, uint256 _bonusShares) public onlyOwner {
        require(bytes(employeeSearchByID[_id].id).length > 0, "Employee not found.");

        employeeSearchByID[_id].bonusShares = _bonusShares;
    }

    // ฟังก์ชันคำนวณจำนวนหุ้นทั้งหมดที่พนักงานจะได้รับ
    function calculateTotalShares(string memory _id) public view returns (uint256) {
        require(bytes(employeeSearchByID[_id].id).length > 0, "Employee not found.");

        return employeeSearchByID[_id].sharesReceived + employeeSearchByID[_id].bonusShares;
    }

 // ฟังก์ชันโอนหุ้นให้กับพนักงาน
function transferShares(string memory _id) public onlyOwner {
    require(bytes(employeeSearchByID[_id].id).length > 0, "Employee not found.");

    uint256 totalShares = calculateTotalShares(_id);
    require(totalShares > 0, "No shares to transfer.");

    address walletAddress = employeeSearchByID[_id].walletAddress;
    
    // สมมติว่ามีฟังก์ชันเพื่อส่งหุ้น (หรือเงิน) ไปยังกระเป๋าเงินของพนักงาน
    // ตัวอย่างนี้เป็นการแสดงว่าจะโอนเงิน ไม่ได้ใช้งานจริง
    // และต้องมีการระบุวิธีการโอนหุ้นจริงหรือเชื่อมต่อกับฟังก์ชันจากสัญญาอื่น
    // (address payable(walletAddress)).transfer(totalShares);

    // รีเซ็ตจำนวนหุ้นและหุ้นโบนัสหลังจากโอนหุ้น
    employeeSearchByID[_id].sharesReceived = 0;
    employeeSearchByID[_id].bonusShares = 0;
}
}


/*โจทย์: ระบบจัดการหุ้นของพนักงาน
เพิ่มข้อมูลพนักงาน:

สร้างโครงสร้างข้อมูลสำหรับพนักงานที่เก็บข้อมูล เช่น ID, ชื่อ, นามสกุล, จำนวนหุ้นที่ได้รับ, ที่อยู่กระเป๋าเงิน และจำนวนหุ้นโบนัส
สร้างฟังก์ชันสำหรับเพิ่มข้อมูลพนักงานใหม่เข้าไปในระบบ
เพิ่มจำนวนหุ้นที่ได้รับ:

สร้างฟังก์ชันสำหรับเพิ่มจำนวนหุ้นที่ได้รับให้กับพนักงาน
กำหนดจำนวนหุ้นโบนัส:

สร้างฟังก์ชันสำหรับกำหนดจำนวนหุ้นโบนัสสำหรับพนักงาน
คำนวณจำนวนหุ้นทั้งหมด:

สร้างฟังก์ชันสำหรับคำนวณจำนวนหุ้นทั้งหมดที่พนักงานจะได้รับ
โอนหุ้นให้พนักงาน:

สร้างฟังก์ชันสำหรับโอนหุ้นให้กับพนักงาน และรีเซ็ตจำนวนหุ้นและหุ้นโบนัสหลังจากโอนหุ้น */