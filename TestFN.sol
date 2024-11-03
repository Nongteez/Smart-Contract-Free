// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

contract SLR_Coin {
    struct employ_data {
        string ID;
        string First_name;
        string Last_name;
        uint256 Workdays;
        address Wallet_Address;
        uint256 Reward;
    }

    employ_data[] public Employee_No;
    address[] public funders;

    mapping(string => employ_data) public Search_By_ID;
    mapping(address => uint256) public addressToAmountFunded;

    function fund() public payable { // นำเอาเงินเข้า contract

        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }   

    function Add_Data( //นำเข้าข้อมูล
        string memory _ID,
        string memory _First_name,
        string memory _Last_name,
        address _Wallet_Address
    ) public {
        employ_data storage employee = Search_By_ID[_ID];
        require(bytes(employee.ID).length == 0, "Employee already exists.");

        Employee_No.push(
            employ_data({
                ID: _ID,
                First_name: _First_name,
                Last_name: _Last_name,
                Workdays: 0,
                Wallet_Address: _Wallet_Address,
                Reward: 0
            })
        );
        Search_By_ID[_ID] = employ_data(_ID, _First_name, _Last_name, 0, _Wallet_Address, 0);
    }

    function Add_Workdays(string memory _ID) public { // ระบุจำนวนวัน
        employ_data storage employee = Search_By_ID[_ID];
        require(bytes(employee.ID).length > 0, "Employee not found.");

        employee.Workdays += 1;
    }

    function Set_Reward(string memory _ID, uint256 _newReward) public { //เงินต่อวัน
        employ_data storage employee = Search_By_ID[_ID];
        require(bytes(employee.ID).length > 0, "Employee not found.");

        employee.Reward = _newReward;
    }

    function Calculate_Salary(string memory _ID) public view returns (uint256) { //คำนวณเงินเดือน
        employ_data storage employee = Search_By_ID[_ID];
        require(bytes(employee.ID).length > 0, "Employee not found.");

        uint256 salary = employee.Workdays * employee.Reward;
        return salary;
    }


    function Transfer_Salary(string memory _ID) public { //จ่ายเงินเดือนให้พนักงาน
        employ_data storage employee = Search_By_ID[_ID];
        require(bytes(employee.ID).length > 0, "Employee not found.");

        uint256 salary = Calculate_Salary(_ID);

        require(salary > 0, "No salary to transfer.");

        address payable walletAddress = payable(employee.Wallet_Address);
        walletAddress.transfer(salary);

        employee.Reward = 0;
        employee.Workdays = 0;
    }

}