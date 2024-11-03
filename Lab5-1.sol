// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LoyaltyProgram {
mapping(address => uint256) public points;
address public owner;
 constructor () {
        owner = msg.sender;
    }
    modifier onlyOwner{
       require(msg.sender == owner ,"only owner call this function");
       _; 
    }

function awardPoints (address user, uint256 amount) public onlyOwner {
points [user] += amount;
}
}