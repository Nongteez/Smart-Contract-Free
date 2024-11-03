// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*Role
1.Manager 1. มีจำนวนคนเดียวเท่านั้น 2.กำหนดราคาลอต(ใบละ 1ETH) 3.จัดการระบบลอตเตอรี่ (Contract / Deploy) 4.ซื้อลอตได้ 5.ประกาศผลรางวัล
2.pLayer 1.หลายคน 2.แต่ละคนซื้อได้หลายใบ 3.ลอตเตอรี่แต่ละใบมีราคา 1ETH 4.เงินรางวัลทั้งหมดมาจากคนซื้อลอต 5.มีแค่คนเดียวที่ได้รางวาล
*/

contract Lottery{
    address public manager; //เรียกใช้ address public ผู้จัดการ เพื่อสามารถดูได้ว่าใครเป็น ผู้จัดการ
    address payable [] public players; //เรียกใช้ address payable ว่าเป็นการจ่ายเงิน ในรูปแบบ array เพราะ เก็บหลายคน

    //constructor เอาไว้กำหนดว่าคน Deploy เป็นเจ้าของหรือ ผู้จัดการ
    constructor(){
        manager = msg.sender;
    }

    //function getBalance เอาไว้ตรวจสอบเงินที่มีในระบบ หรือ smart contract จากผู้เล่นที่เข้ามาซื้อ
    function getBalance() public view returns(uint) {   //
        return address(this).balance;
    }

    //function การซื้อ Lottery
    function buyLottery() public payable {
        require(msg.value == 1 ether, "Please Buy Lottery 1 ETH Only");
        players.push(payable (msg.sender));
    }

    function getLength() public view returns(uint){
        return players.length;
    } 

    function randomNumber()private  view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,players.length)));
    }

    function selectWinner() public {
        require(msg.sender == manager, "YOU CAN'T MANAGER ");
        require(getLength()>=2, "Less Then 2 Players");
        uint pickRandom = randomNumber();
        address payable winner ;
        uint selectIndex = pickRandom % players.length; 
        winner = players[selectIndex];
        winner.transfer(getBalance());
        players = new address payable [](0);
    }



}