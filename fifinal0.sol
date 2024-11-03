// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

contract GRADE_A_COMPANY {
    
    // โครงสร้างข้อมูลพนักงาน
    struct EmployData {
        string id;
        string firstName;
        string lastName;
        uint256 workdays;
        address walletAddress;
        uint256 reward;
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
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }   

    // ฟังก์ชันเพิ่มข้อมูลพนักงานใหม่
    function addEmployee(
        string memory id,
        string memory firstName,
        string memory lastName,
        address walletAddress
    ) public {
        require(bytes(employeeById[id].id).length == 0, "Employee already exists.");

        EmployData memory newEmployee = EmployData({
            id: id,
            firstName: firstName,
            lastName: lastName,
            workdays: 0,
            walletAddress: walletAddress,
            reward: 0
        });

        employees.push(newEmployee);
        employeeById[id] = newEmployee;
    }

    // ฟังก์ชันเพิ่มจำนวนวันทำงานให้กับพนักงาน
    function addWorkdays(string memory id) public {
        require(bytes(employeeById[id].id).length > 0, "Employee not found.");

        employeeById[id].workdays += 1;
    }

    // ฟังก์ชันกำหนดค่าตอบแทนต่อวันสำหรับพนักงาน
    function setReward(string memory id, uint256 newReward) public {
        require(bytes(employeeById[id].id).length > 0, "Employee not found.");

        employeeById[id].reward = newReward;
    }

    // ฟังก์ชันคำนวณเงินเดือนของพนักงาน
    function calculateSalary(string memory id) public view returns (uint256) {
        require(bytes(employeeById[id].id).length > 0, "Employee not found.");

        return employeeById[id].workdays * employeeById[id].reward;
    }

    // ฟังก์ชันจ่ายเงินเดือนให้กับพนักงาน
    function transferSalary(string memory id) public {
        require(bytes(employeeById[id].id).length > 0, "Employee not found.");

        uint256 salary = calculateSalary(id);
        require(salary > 0, "No salary to transfer.");

        address payable walletAddress = payable(employeeById[id].walletAddress);
        require(address(this).balance >= salary, "Not enough balance in contract");
        
        walletAddress.transfer(salary);

        // รีเซ็ตค่าตอบแทนและวันทำงานหลังจากจ่ายเงินเดือน
        employeeById[id].reward = 0;
        employeeById[id].workdays = 0;
    }
}



/*
การกำหนดโครงสร้างข้อมูลพนักงาน (EmployData)

    struct EmployData {
        string id;
        string firstName;
        string lastName;
        uint256 workdays;
        address walletAddress;
        uint256 reward;
    }
กำหนดโครงสร้างข้อมูลพนักงานที่ประกอบด้วย:
id: รหัสประจำตัวพนักงาน (string)
firstName: ชื่อจริงของพนักงาน (string)
lastName: นามสกุลของพนักงาน (string)
workdays: จำนวนวันที่ทำงาน (uint256)
walletAddress: ที่อยู่กระเป๋าเงินของพนักงาน (address)
reward: ค่าตอบแทนต่อวัน (uint256)

3. การประกาศตัวแปรสำหรับจัดเก็บข้อมูล

    EmployData[] public employees;
    address[] public funders;
    mapping(string => EmployData) public employeeById;
    mapping(address => uint256) public addressToAmountFunded;
employees: อาร์เรย์เก็บข้อมูลพนักงานทั้งหมด.
funders: อาร์เรย์เก็บที่อยู่ของผู้ที่ให้เงินทุน.
employeeById: แมป (mapping) ที่เก็บข้อมูลพนักงานจาก ID.
addressToAmountFunded: แมปที่เก็บจำนวนเงินที่แต่ละที่อยู่ส่งมาให้สัญญา.

4. ฟังก์ชันเพิ่มเงินทุนเข้าไปในสัญญา

    function fund() public payable {
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }
ฟังก์ชัน fund สำหรับการเพิ่มเงินทุนเข้าไปในสัญญา.
msg.sender คือที่อยู่ของผู้เรียกใช้ฟังก์ชัน.
msg.value คือจำนวนเงินที่ส่งเข้ามาในสัญญา.
เพิ่มที่อยู่ของผู้ที่ให้เงินทุนลงในอาร์เรย์ funders.

5. ฟังก์ชันเพิ่มข้อมูลพนักงานใหม่

    function addEmployee(
        string memory id,
        string memory firstName,
        string memory lastName,
        address walletAddress
    ) public {
        require(bytes(employeeById[id].id).length == 0, "Employee already exists.");

        EmployData memory newEmployee = EmployData({
            id: id,
            firstName: firstName,
            lastName: lastName,
            workdays: 0,
            walletAddress: walletAddress,
            reward: 0
        });

        employees.push(newEmployee);
        employeeById[id] = newEmployee;
    }
ฟังก์ชัน addEmployee สำหรับการเพิ่มข้อมูลพนักงานใหม่.
ใช้ require ตรวจสอบว่าพนักงานยังไม่มีอยู่ในระบบ.
สร้างข้อมูลพนักงานใหม่และเพิ่มลงในอาร์เรย์ employees และแมป employeeById.

6. ฟังก์ชันเพิ่มจำนวนวันทำงานให้กับพนักงาน

    function addWorkdays(string memory id) public {
        require(bytes(employeeById[id].id).length > 0, "Employee not found.");

        employeeById[id].workdays += 1;
    }
ฟังก์ชัน addWorkdays สำหรับการเพิ่มจำนวนวันทำงานให้กับพนักงาน.
ใช้ require ตรวจสอบว่าพนักงานมีอยู่ในระบบ.
เพิ่มจำนวนวันทำงานใน workdays ของพนักงาน.

7. ฟังก์ชันกำหนดค่าตอบแทนต่อวันสำหรับพนักงาน

    function setReward(string memory id, uint256 newReward) public {
        require(bytes(employeeById[id].id).length > 0, "Employee not found.");

        employeeById[id].reward = newReward;
    }
ฟังก์ชัน setReward สำหรับการกำหนดค่าตอบแทนต่อวันสำหรับพนักงาน.
ใช้ require ตรวจสอบว่าพนักงานมีอยู่ในระบบ.
กำหนดค่าตอบแทนใหม่ใน reward ของพนักงาน.

8. ฟังก์ชันคำนวณเงินเดือนของพนักงาน

    function calculateSalary(string memory id) public view returns (uint256) {
        require(bytes(employeeById[id].id).length > 0, "Employee not found.");

        return employeeById[id].workdays * employeeById[id].reward;
    }
ฟังก์ชัน calculateSalary สำหรับการคำนวณเงินเดือนของพนักงาน.
ใช้ require ตรวจสอบว่าพนักงานมีอยู่ในระบบ.
คำนวณเงินเดือนจากจำนวนวันทำงาน (workdays) และค่าตอบแทนต่อวัน (reward).

9. ฟังก์ชันจ่ายเงินเดือนให้กับพนักงาน


    function transferSalary(string memory id) public {
        require(bytes(employeeById[id].id).length > 0, "Employee not found.");

        uint256 salary = calculateSalary(id);
        require(salary > 0, "No salary to transfer.");

        address payable walletAddress = payable(employeeById[id].walletAddress);
        require(address(this).balance >= salary, "Not enough balance in contract");
        
        walletAddress.transfer(salary);

        // รีเซ็ตค่าตอบแทนและวันทำงานหลังจากจ่ายเงินเดือน
        employeeById[id].reward = 0;
        employeeById[id].workdays = 0;
    }
ฟังก์ชัน transferSalary สำหรับการจ่ายเงินเดือนให้กับพนักงาน.
ใช้ require ตรวจสอบว่าพนักงานมีอยู่ในระบบ.
คำนวณเงินเดือนและตรวจสอบว่ามียอดเงินเพียงพอในสัญญา.
โอนเงินเดือนให้กับพนักงานและรีเซ็ตค่าตอบแทนและวันทำงาน.
 โด
*/