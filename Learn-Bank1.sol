// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract Bank {

    mapping(address  => uint) _balances; 
    uint _totalSupply;

    //function desposit ฝากเงิน
    function deposit() public payable  {
        _balances[msg.sender] += msg.value;
        _totalSupply += msg.value;
    }

    //function withdraw ถอนเงิน
    function withdraw(uint amount) public payable {
        require(amount <= _balances[msg.sender], "not enough money");
        payable(msg.sender).transfer(amount);
        _balances[msg.sender] -= amount;
        _totalSupply -= amount;

    }

    //funtion CheckBalance ตรวจสอบเงินที่ฝาก
    function CheckBalance()  public view  returns (uint balance) {
        return _balances[msg.sender];

    }

    //funtion checkTotalSupply เอ้าไว้ตรวงเงินในคลังว่าใครฝากไปบ้าง 
    function checkTotalSupply() public view returns(uint totalSupply){
        return _totalSupply;
    }


}



