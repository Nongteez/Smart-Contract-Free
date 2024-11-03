// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

contract NAJA_COMPANY {
    
    // โครงสร้างข้อมูลพนักงาน
    struct EmployData {
        string id;                  // รหัสประจำตัวพนักงาน
        string firstName;           // ชื่อจริงของพนักงาน
        string lastName;            // นามสกุลของพนักงาน
        uint256 workdays;           // จำนวนวันทำงาน
        address walletAddress;      // ที่อยู่กระเป๋าเงินของพนักงาน
        uint256 reward;             // ค่าตอบแทนต่อวัน
    }

    // เก็บข้อมูลพนักงานทั้งหมดในอาร์เรย์
    EmployData[] public employees;
    
    // เก็บที่อยู่ของผู้ที่ให้เงินทุน
    address[] public funders;
    
    // แมปข้อมูลพนักงานจาก id
    mapping(string => EmployData) public employeeById;
    
    // แมปจำนวนเงินที่แต่ละที่อยู่ส่งมาให้สัญญา
    mapping(address => uint256) public addressToAmountFunded;

    // ฟังก์ชันเพิ่มเงินทุนเข้าไปในสัญญา
    function fund() public payable {
        addressToAmountFunded[msg.sender] += msg.value;  // เพิ่มจำนวนเงินที่ผู้ใช้ส่งมาในแมป
        funders.push(msg.sender);                        // เก็บที่อยู่ของผู้ที่ให้เงินทุนในอาร์เรย์
    }   

    // ฟังก์ชันเพิ่มข้อมูลพนักงานใหม่
    function addEmployee(
        string memory id,
        string memory firstName,
        string memory lastName,
        address walletAddress
    ) public {
        require(bytes(employeeById[id].id).length == 0, "Employee already exists."); // ตรวจสอบว่าพนักงานยังไม่มีอยู่ในระบบ

        EmployData memory newEmployee = EmployData({
            id: id,
            firstName: firstName,
            lastName: lastName,
            workdays: 0,             // กำหนดค่าเริ่มต้นของจำนวนวันทำงานเป็น 0
            walletAddress: walletAddress,
            reward: 0                // กำหนดค่าเริ่มต้นของค่าตอบแทนเป็น 0
        });

        employees.push(newEmployee);             // เพิ่มข้อมูลพนักงานใหม่ลงในอาร์เรย์
        employeeById[id] = newEmployee;          // เก็บข้อมูลพนักงานใหม่ในแมป โดยใช้รหัสประจำตัวพนักงานเป็นคีย์
    }

    // ฟังก์ชันเพิ่มจำนวนวันทำงานให้กับพนักงาน
    function addWorkdays(string memory id) public {
        require(bytes(employeeById[id].id).length > 0, "Employee not found."); // ตรวจสอบว่าพนักงานมีอยู่ในระบบ

        employeeById[id].workdays += 1;  // เพิ่มจำนวนวันทำงานให้กับพนักงาน
    }

    // ฟังก์ชันกำหนดค่าตอบแทนต่อวันสำหรับพนักงาน
    function setReward(string memory id, uint256 newReward) public {
        require(bytes(employeeById[id].id).length > 0, "Employee not found."); // ตรวจสอบว่าพนักงานมีอยู่ในระบบ

        employeeById[id].reward = newReward;  // กำหนดค่าตอบแทนใหม่ให้กับพนักงาน
    }

    // ฟังก์ชันคำนวณเงินเดือนของพนักงาน
    function calculateSalary(string memory id) public view returns (uint256) {
        require(bytes(employeeById[id].id).length > 0, "Employee not found."); // ตรวจสอบว่าพนักงานมีอยู่ในระบบ

        return employeeById[id].workdays * employeeById[id].reward; // คำนวณเงินเดือนจากจำนวนวันทำงานและค่าตอบแทนต่อวัน
    }

    // ฟังก์ชันจ่ายเงินเดือนให้กับพนักงาน
    function transferSalary(string memory id) public {
        require(bytes(employeeById[id].id).length > 0, "Employee not found."); // ตรวจสอบว่าพนักงานมีอยู่ในระบบ

        uint256 salary = calculateSalary(id);                                  // คำนวณเงินเดือนของพนักงาน
        require(salary > 0, "No salary to transfer.");                         // ตรวจสอบว่ามีเงินเดือนที่ต้องจ่าย

        address payable walletAddress = payable(employeeById[id].walletAddress); // แปลงที่อยู่กระเป๋าเงินให้เป็นแบบ payable
        walletAddress.transfer(salary);                                          // โอนเงินเดือนให้กับพนักงาน

        // รีเซ็ตค่าตอบแทนและวันทำงานหลังจากจ่ายเงินเดือน
        employeeById[id].reward = 0;
        employeeById[id].workdays = 0;
    }
}


/*สรุป
โครงสร้าง EmployData ใช้สำหรับจัดเก็บข้อมูลพนักงาน.
ฟังก์ชัน fund สำหรับการเพิ่มเงินทุนเข้าไปในสัญญา.
ฟังก์ชัน addEmployee สำหรับการเพิ่มข้อมูลพนักงานใหม่.
ฟังก์ชัน addWorkdays สำหรับการเพิ่มจำนวนวันทำงานให้กับพนักงาน.
ฟังก์ชัน setReward สำหรับการกำหนดค่าตอบแทนต่อวันสำหรับพนักงาน.
ฟังก์ชัน calculateSalary สำหรับการคำนวณเงินเดือนของพนักงาน.
ฟังก์ชัน transferSalary สำหรับการจ่ายเงินเดือนให้กับพนักงาน.*/