// SPDX-License-Identifier: MIT
/*pragma solidity ^0.8.7;

contract GRADE_A_COMPANY {

    address private owner;
    constructor () {
        owner = msg.sender;
    }
    
    modifier onlyOwner{
       require(msg.sender == owner ,"adminna");
       _; //ไปที่ฟังก์ชันนั้นๆที่เรียกใช้  
    }

    // โครงสร้างข้อมูลพนักงาน
    struct EmployData {
        string id;
        string firstName;
        string lastName;
        uint256 workDays;
        address walletAddressEmployee;
        uint256 reward;
    }

    // เก็บข้อมูลพนักงานทั้งหมดในอาร์เรย์
    EmployData[] private  employees;
    
    // เก็บที่อยู่ของผู้ที่ให้เงินทุน
    address[] private  funders;
    
    // แมปข้อมูลพนักงานจาก id
    mapping(string => EmployData) public employeeSearchID;
    
    // แมปจำนวนเงินที่แต่ละที่อยู่ส่งมาให้สัญญา
    mapping(address => uint256) private  addressToAmountFunded;

    // ฟังก์ชันเพิ่มเงินทุนเข้าไปในสัญญา
    function fundCompany() public payable onlyOwner {
        require(msg.value >= 1 ,"1 UP Bro");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }   

    // ฟังก์ชันเพิ่มข้อมูลพนักงานใหม่
    function addEmployee(
        string memory _id,
        string memory _firstName,
        string memory _lastName,
        address _walletAddressEmployee
    ) public onlyOwner {
        require(bytes(employeeSearchID[_id].id).length == 0, "Employee already exists.");

        EmployData memory newEmployee = EmployData({
            id: _id,
            firstName: _firstName,
            lastName: _lastName,
            workDays: 0,
            walletAddressEmployee: _walletAddressEmployee,
            reward: 0
        });

        employees.push(newEmployee);
        employeeSearchID[_id] = newEmployee;
    }

    // ฟังก์ชันเพิ่มจำนวนวันทำงานให้กับพนักงาน
    function addWorkdays(string memory id) public onlyOwner{
        require(bytes(employeeSearchID[id].id).length > 0, "Employee not found.");

        employeeSearchID[id].workDays += 1;
    }

    // ฟังก์ชันกำหนดค่าตอบแทนต่อวันสำหรับพนักงาน
    function setReward(string memory id, uint256 newReward) public onlyOwner{
        require(bytes(employeeSearchID[id].id).length > 0, "Employee not found.");

        employeeSearchID[id].reward = newReward;
    }

    // ฟังก์ชันคำนวณเงินเดือนของพนักงาน
    function calculateSalary(string memory id) public view returns (uint256) {
        require(bytes(employeeSearchID[id].id).length > 0, "Employee not found.");

        return employeeSearchID[id].workDays * employeeSearchID[id].reward;
    }

    // ฟังก์ชันจ่ายเงินเดือนให้กับพนักงาน
    function transferSalary(string memory id) public onlyOwner{
        require(bytes(employeeSearchID[id].id).length > 0, "Employee not found.");

        uint256 salary = calculateSalary(id);
        require(salary > 0, "No salary to transfer.");

        address payable walletAddress = payable(employeeSearchID[id].walletAddressEmployee);
        require(address(this).balance >= salary, "Not enough balance in contract");
        
        walletAddress.transfer(salary);

        // รีเซ็ตค่าตอบแทนและวันทำงานหลังจากจ่ายเงินเดือน
        employeeSearchID[id].reward = 0;
        employeeSearchID[id].workDays = 0;
    }
}




/* 

//เริ่มประกาศสัญญา (contract) ใหม่ ชื่อว่า GRADE_A_COMPANY
contract GRADE_A_COMPANY {

    //address private owner;: ประกาศตัวแปร owner ที่เก็บที่อยู่ของผู้เป็นเจ้าของสัญญา
    address private owner;
    //constructor: ฟังก์ชันพิเศษที่จะถูกเรียกครั้งเดียวตอนที่สร้างสัญญา กำหนด owner เป็นผู้ที่สร้างสัญญา
    constructor () {
        owner = msg.sender;
    }
    //modifier onlyOwner: ตัวดัดแปลงฟังก์ชัน (modifier) ที่ใช้จำกัดการเข้าถึงฟังก์ชันให้เฉพาะเจ้าของสัญญาเท่านั้น
    modifier onlyOwner{
       require(msg.sender == owner ,"adminna");   //require(msg.sender == owner , "adminna");: ตรวจสอบว่าผู้เรียกฟังก์ชันเป็นเจ้าของสัญญาหรือไม่ ถ้าไม่ใช่ให้หยุดการทำงานพร้อมข้อความว่า "adminna"
       _; // สัญลักษณ์ที่ใช้บอกตำแหน่งที่จะเรียกฟังก์ชันจริง ๆ ที่ใช้ตัวดัดแปลงนี้

    }

    // โครงสร้างข้อมูลพนักงาน 
    //struct EmployData: ประกาศโครงสร้างข้อมูลสำหรับพนักงาน เก็บข้อมูลต่าง ๆ เช่น ID, ชื่อ, นามสกุล, จำนวนวันทำงาน, ที่อยู่กระเป๋าเงิน และรางวัล
    struct EmployData {
        string id;
        string firstName;
        string lastName;
        uint256 workDays;
        address walletAddressEmployee;
        uint256 reward;
    }

    // เก็บข้อมูลพนักงานทั้งหมดในอาร์เรย์ EmployData[] public employees: ประกาศอาร์เรย์ของพนักงานทั้งหมด
    EmployData[] public employees;
    
    // เก็บที่อยู่ของผู้ที่ให้เงินทุน address[] public funders: ประกาศอาร์เรย์ของผู้ให้เงินทุน
    address[] public funders;
    
    // แมปข้อมูลพนักงานจาก id mapping(string => EmployData) public employeeSearchID: แมปจาก ID ของพนักงานไปยังข้อมูลพนักงาน
    mapping(string => EmployData) public employeeSearchID;
    
    // แมปจำนวนเงินที่แต่ละที่อยู่ส่งมาให้สัญญา mapping(address => uint256) public addressToAmountFunded: แมปจากที่อยู่กระเป๋าเงินไปยังจำนวนเงินที่แต่ละที่อยู่ส่งมาให้สัญญา
    mapping(address => uint256) public addressToAmountFunded;



    // ฟังก์ชันเพิ่มเงินทุนเข้าไปในสัญญา function fundCompany() public payable onlyOwner: ฟังก์ชันเพิ่มเงินทุนเข้าไปในสัญญา เรียกใช้ได้เฉพาะเจ้าของสัญญาและต้องส่งค่า Ether มาด้วย
    function fundCompany() public payable onlyOwner {
        //require(msg.value >= 1 , "1 UP Bro");: ตรวจสอบว่าจำนวนเงินที่ส่งมาต้องมากกว่าหรือเท่ากับ 1 wei
        require(msg.value >= 1 ,"1 UP Bro"); 

        //addressToAmountFunded[msg.sender] += msg.value;: เพิ่มจำนวนเงินที่ผู้เรียกส่งมาให้กับสัญญาในแมป
        addressToAmountFunded[msg.sender] += msg.value;
        
        //funders.push(msg.sender);: เพิ่มที่อยู่ของผู้เรียกเข้าไปในอาร์เรย์ funders
        funders.push(msg.sender);
    }   



    // ฟังก์ชันเพิ่มข้อมูลพนักงานใหม่ function addEmployee: ฟังก์ชันเพิ่มข้อมูลพนักงานใหม่ เรียกใช้ได้เฉพาะเจ้าของสัญญา
    function addEmployee(
        string memory _id,
        string memory _firstName,
        string memory _lastName,
        address _walletAddressEmployee
    ) public onlyOwner {

        // ตรวจสอบว่าพนักงานที่มี ID นี้ยังไม่มีอยู่ในระบบ
        require(bytes(employeeSearchID[_id].id).length == 0, "Employee already exists.");
        
        //EmployData memory newEmployee = EmployData({...});: สร้างข้อมูลพนักงานใหม่
        EmployData memory newEmployee = EmployData({
            id: _id,
            firstName: _firstName,
            lastName: _lastName,
            workDays: 0,
            walletAddressEmployee: _walletAddressEmployee,
            reward: 0
        });

        //employees.push(newEmployee);: เพิ่มข้อมูลพนักงานใหม่เข้าไปในอาร์เรย์ employees
        employees.push(newEmployee);     

        //employeeSearchID[_id] = newEmployee;: เก็บข้อมูลพนักงานใหม่ในแมป employeeSearchID
        employeeSearchID[_id] = newEmployee;
    }




    // ฟังก์ชันเพิ่มจำนวนวันทำงานให้กับพนักงาน function addWorkdays: ฟังก์ชันเพิ่มจำนวนวันทำงานให้กับพนักงาน เรียกใช้ได้เฉพาะเจ้าของสัญญา
    function addWorkdays(string memory id) public onlyOwner{

        //require(bytes(employeeSearchID[id].id).length > 0, "Employee not found.");: ตรวจสอบว่ามีพนักงานที่มี ID นี้อยู่ในระบบหรือไม่
        require(bytes(employeeSearchID[id].id).length > 0, "Employee not found.");

        //employeeSearchID[id].workDays += 1;: เพิ่มจำนวนวันทำงานให้พนักงานที่มี ID นี้
        employeeSearchID[id].workDays += 1;
    }




    // ฟังก์ชันกำหนดค่าตอบแทนต่อวันสำหรับพนักงาน function setReward: ฟังก์ชันกำหนดค่าตอบแทนต่อวันสำหรับพนักงาน เรียกใช้ได้เฉพาะเจ้าของสัญญา
    function setReward(string memory id, uint256 newReward) public onlyOwner{

        //require(bytes(employeeSearchID[id].id).length > 0, "Employee not found.");: ตรวจสอบว่ามีพนักงานที่มี ID นี้อยู่ในระบบหรือไม่
        require(bytes(employeeSearchID[id].id).length > 0, "Employee not found.");
s
        //employeeSearchID[id].reward = newReward;: กำหนดค่าตอบแทนต่อวันให้พนักงานที่มี ID นี้
        employeeSearchID[id].reward = newReward;
    }

    // ฟังก์ชันคำนวณเงินเดือนของพนักงาน function calculateSalary: ฟังก์ชันคำนวณเงินเดือนของพนักงาน
    function calculateSalary(string memory id) public view returns (uint256) {

        //require(bytes(employeeSearchID[id].id).length > 0, "Employee not found.");: ตรวจสอบว่ามีพนักงานที่มี ID นี้อยู่ในระบบหรือไม่
        require(bytes(employeeSearchID[id].id).length > 0, "Employee not found.");

        //return employeeSearchID[id].workDays * employeeSearchID[id].reward;: คำนวณและส่งคืนเงินเดือนของพนักงาน (จำนวนวันทำงาน * ค่าตอบแทนต่อวัน)
        return employeeSearchID[id].workDays * employeeSearchID[id].reward;
    }




    // ฟังก์ชันจ่ายเงินเดือนให้กับพนักงาน function transferSalary: ฟังก์ชันจ่ายเงินเดือนให้กับพนักงาน เรียกใช้ได้เฉพาะเจ้าของสัญญา
    function transferSalary(string memory id) public onlyOwner{

        // require(bytes(employeeSearchID[id].id).length > 0, "Employee not found.");: ตรวจสอบว่ามีพนักงานที่มี ID นี้อยู่ในระบบหรือไม่
        require(bytes(employeeSearchID[id].id).length > 0, "Employee not found.");

        //uint256 salary = calculateSalary(id);: คำนวณเงินเดือนของพนักงาน
        uint256 salary = calculateSalary(id);

        /require(salary > 0, "No salary to transfer.");: ตรวจสอบว่ามีเงินเดือนให้จ่ายหรือไม่
        require(salary > 0, "No salary to transfer.");

        //address payable walletAddress = payable(employeeSearchID[id].walletAddressEmployee);: แปลงที่อยู่กระเป๋าเงินของพนักงานให้เป็น payable
        address payable walletAddress = payable(employeeSearchID[id].walletAddressEmployee);

        //require(address(this).balance >= salary, "Not enough balance in contract");: ตรวจสอบว่ามีเงินเพียงพอในสัญญาหรือไม่
        require(address(this).balance >= salary, "Not enough balance in contract");
        
        //walletAddress.transfer(salary);: โอนเงินเดือนให้กับพนักงาน
        walletAddress.transfer(salary);

        // รีเซ็ตค่าตอบแทนและวันทำงานหลังจากจ่ายเงินเดือน
        //employeeSearchID[id].reward = 0;: รีเซ็ตค่าตอบแทนหลังจากจ่ายเงินเดือน
        employeeSearchID[id].reward = 0;
        //employeeSearchID[id].workDays = 0;: รีเซ็ตจำนวนวันทำงานหลังจากจ่ายเงินเดือน
        employeeSearchID[id].workDays = 0;
    }
}

โค้ดนี้เป็นสัญญาอัจฉริยะ (Smart Contract) บน Ethereum ที่จัดการบริษัทสมมติชื่อ "GRADE_A_COMPANY" ซึ่งมีฟังก์ชันการทำงานเกี่ยวกับการจัดการพนักงานและการเงินของบริษัท ต่อไปนี้คือการอธิบายคอมเมนต์โค้ด:


contract GRADE_A_COMPANY {

    // กำหนดตัวแปรเพื่อเก็บที่อยู่ของเจ้าของสัญญา
    address private owner;

    // ฟังก์ชัน constructor ที่จะถูกเรียกเมื่อมีการสร้างสัญญา โดยจะกำหนด owner เป็นผู้ที่ทำการ deploy สัญญา
    constructor () {
        owner = msg.sender;
    }
    
    // Modifier เพื่อจำกัดการเข้าถึงฟังก์ชันต่างๆ เฉพาะเจ้าของสัญญาเท่านั้น
    modifier onlyOwner{
       require(msg.sender == owner ,"adminna");
       _; // ไปที่ฟังก์ชันนั้นๆที่เรียกใช้  
    }

    // โครงสร้างข้อมูลพนักงาน
    struct EmployData {
        string id;  // รหัสพนักงาน
        string firstName;  // ชื่อ
        string lastName;  // นามสกุล
        uint256 workDays;  // จำนวนวันที่ทำงาน
        address walletAddressEmployee;  // ที่อยู่กระเป๋าเงินของพนักงาน
        uint256 reward;  // ค่าตอบแทนต่อวัน
    }

    // อาร์เรย์สำหรับเก็บข้อมูลพนักงานทั้งหมด
    EmployData[] private employees;
    
    // อาร์เรย์สำหรับเก็บที่อยู่ของผู้ที่ให้เงินทุน
    address[] private funders;
    
    // แผนที่เพื่อแมปข้อมูลพนักงานจากรหัสพนักงาน
    mapping(string => EmployData) public employeeSearchID;
    
    // แผนที่เพื่อเก็บจำนวนเงินที่แต่ละที่อยู่ส่งมาให้สัญญา
    mapping(address => uint256) private addressToAmountFunded;

    // ฟังก์ชันเพื่อเพิ่มเงินทุนเข้าไปในสัญญา (เฉพาะเจ้าของเท่านั้น)
    function fundCompany() public payable onlyOwner {
        require(msg.value >= 1 ,"1 UP Bro");  // ต้องมีการส่งค่าอย่างน้อย 1 wei
        addressToAmountFunded[msg.sender] += msg.value;  // บันทึกจำนวนเงินที่ผู้ส่งได้ส่งมา
        funders.push(msg.sender);  // เพิ่มที่อยู่ของผู้ส่งเข้ามาในอาร์เรย์ funders
    }   

    // ฟังก์ชันเพิ่มข้อมูลพนักงานใหม่ (เฉพาะเจ้าของเท่านั้น)
    function addEmployee(
        string memory _id,
        string memory _firstName,
        string memory _lastName,
        address _walletAddressEmployee
    ) public onlyOwner {
        require(bytes(employeeSearchID[_id].id).length == 0, "Employee already exists.");  // ตรวจสอบว่าพนักงานยังไม่มีในระบบ

        // สร้างข้อมูลพนักงานใหม่
        EmployData memory newEmployee = EmployData({
            id: _id,
            firstName: _firstName,
            lastName: _lastName,
            workDays: 0,
            walletAddressEmployee: _walletAddressEmployee,
            reward: 0
        });

        employees.push(newEmployee);  // เพิ่มข้อมูลพนักงานใหม่เข้าไปในอาร์เรย์ employees
        employeeSearchID[_id] = newEmployee;  // เพิ่มข้อมูลพนักงานใหม่เข้าไปในแผนที่ employeeSearchID
    }

    // ฟังก์ชันเพิ่มจำนวนวันทำงานให้กับพนักงาน (เฉพาะเจ้าของเท่านั้น)
    function addWorkdays(string memory id) public onlyOwner {
        require(bytes(employeeSearchID[id].id).length > 0, "Employee not found.");  // ตรวจสอบว่าพนักงานมีในระบบ

        employeeSearchID[id].workDays += 1;  // เพิ่มจำนวนวันทำงานให้กับพนักงาน
    }

    // ฟังก์ชันกำหนดค่าตอบแทนต่อวันสำหรับพนักงาน (เฉพาะเจ้าของเท่านั้น)
    function setReward(string memory id, uint256 newReward) public onlyOwner {
        require(bytes(employeeSearchID[id].id).length > 0, "Employee not found.");  // ตรวจสอบว่าพนักงานมีในระบบ

        employeeSearchID[id].reward = newReward;  // กำหนดค่าตอบแทนใหม่ให้กับพนักงาน
    }

    // ฟังก์ชันคำนวณเงินเดือนของพนักงาน
    function calculateSalary(string memory id) public view returns (uint256) {
        require(bytes(employeeSearchID[id].id).length > 0, "Employee not found.");  // ตรวจสอบว่าพนักงานมีในระบบ

        return employeeSearchID[id].workDays * employeeSearchID[id].reward;  // คำนวณเงินเดือนจากจำนวนวันทำงานและค่าตอบแทนต่อวัน
    }

    // ฟังก์ชันจ่ายเงินเดือนให้กับพนักงาน (เฉพาะเจ้าของเท่านั้น)
    function transferSalary(string memory id) public onlyOwner {
        require(bytes(employeeSearchID[id].id).length > 0, "Employee not found.");  // ตรวจสอบว่าพนักงานมีในระบบ

        uint256 salary = calculateSalary(id);  // คำนวณเงินเดือน
        require(salary > 0, "No salary to transfer.");  // ตรวจสอบว่ามีเงินเดือนที่ต้องจ่าย

        address payable walletAddress = payable(employeeSearchID[id].walletAddressEmployee);  // ที่อยู่กระเป๋าเงินของพนักงาน
        require(address(this).balance >= salary, "Not enough balance in contract");  // ตรวจสอบว่าสัญญามีเงินเพียงพอ

        walletAddress.transfer(salary);  // โอนเงินเดือนให้พนักงาน

        // รีเซ็ตค่าตอบแทนและวันทำงานหลังจากจ่ายเงินเดือน
        employeeSearchID[id].reward = 0;
        employeeSearchID[id].workDays = 0;
    }
}
สรุปฟังก์ชันการทำงานหลัก:
fundCompany: เพิ่มเงินทุนเข้าสู่สัญญา (เฉพาะเจ้าของเท่านั้น)
addEmployee: เพิ่มข้อมูลพนักงานใหม่ (เฉพาะเจ้าของเท่านั้น)
addWorkdays: เพิ่มจำนวนวันทำงานให้กับพนักงาน (เฉพาะเจ้าของเท่านั้น)
setReward: กำหนดค่าตอบแทนต่อวันให้กับพนักงาน (เฉพาะเจ้าของเท่านั้น)
calculateSalary: คำนวณเงินเดือนของพนักงาน
transferSalary: จ่ายเงินเดือนให้กับพนักงาน (เฉพาะเจ้าของเท่านั้น)
โค้ดนี้ทำให้เจ้าของสัญญามีอำนาจในการจัดการและควบคุมการดำเนินการต่างๆ ของบริษัทได้ทั้งหมด ในขณะที่พนักงานและผู้ให้เงินทุนไม่สามารถเข้าถึงหรือเปลี่ยนแปลงข้อมูลในสัญญาได้.
















*/