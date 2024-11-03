//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/*contract contract1 {
    function c1Function() public pure returns (string memory){
        string memory str="I am a contract 1 Function";
        return str;
    }
}

contract contract2 is contract1 {
    function c2Function() public pure returns (string memory){
        string memory str="I am a contract 2 Function";
        return str;
    }
}*/
contract A {

uint internal a;

function getA(uint _value) external {
a = _value;

}
}
contract B {

uint internal b;

function getB(uint _value) external{
b = _value;

}
}

contract C is A, B {

function getValueOfSum() external view returns(uint) {
    return a + b;
}
}