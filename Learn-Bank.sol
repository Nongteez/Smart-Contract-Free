// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*import "github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/math/SignedMath.sol";*/

contract Bank {
    //using SafeMath for uint;
    //uint _balance;

    mapping(address => uint) _balances;

    function deposit(uint amount) public {
    
        //_balance += amount;
        /*_balance = _balance.add(amount);*/

        _balances[msg.sender] += amount;
    }
    function withdraw(uint amount) public {
        
        //require(amount <= _balance, "balance You is not enough");
        //_balance -= amount;
        /* _balance = _balance.sub(amount); */
        _balances[msg.sender] -= amount;

    }

    function CheckBalance()  public view  returns (uint balance) {
        //return _balance;
        return _balances[msg.sender];

    }
}



