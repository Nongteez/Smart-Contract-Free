// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

    contract Donation {
        mapping(address => uint256) public balances;
        address payable private _owner;
        uint256 public totalSupply;
        address[] private Monney;


    constructor() {
            _owner = payable(msg.sender);
    }
    modifier onlyOwner{
       require(msg.sender == _owner ,"only owner call this function");
       _; 
    }

    function donate() public payable {
        totalSupply += msg.value;
        require(msg.value > 0 ," 1 NAJA");
        _owner. transfer(msg.value);
        Monney.push(msg.sender);
        balances[msg.sender] += msg.value;
        
    }

}