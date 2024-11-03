// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TokenTransfer {
    mapping(address => uint256) private balances;
    uint256 public totalSupply;
    address[] public  Monney;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner call this function");
        _; //ไปที่ฟังก์ชันนั้นๆที่เรียกใช้
    }

    function fund() public payable onlyOwner {
        balances[msg.sender] += msg.value;
        Monney.push(msg.sender);
        totalSupply += msg.value;
    }

    function transfer(address recipient, uint256 amount) public {
        require(balances[msg.sender] >= amount, "NO MONEY BRO");
        balances[msg.sender] -= amount;
        balances[recipient] += amount; // Updates recipient balance
    }

    //function balancess() public returns view onlyOwner {

    //}
}