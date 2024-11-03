// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; //Deploy 0.8.7 

contract LotteryProject {
    // State Variables
    address payable public adminManager;                        // adminManager ที่อยู่ของผู้จัดการ (manager) ของลอตเตอรี
    address payable[] public players;                           // players อาร์เรย์ของ Address เงินที่เข้าร่วมลอตเตอรี
    mapping(address => uint) public ticketsBought;              // ticketsBought การจับคู่ระหว่างที่อยู่ของผู้เล่นกับจำนวนตั๋วที่ซื้อไป

    constructor() {
        adminManager = payable(msg.sender);
    }

    modifier onlyAdmin() {
        require(msg.sender == adminManager, "Only the adminManager can call this function.");
        _;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function buyLottery() public payable {
        require(msg.value == 1 ether, "Please buy lottery tickets for 1 ETH only.");
        require(ticketsBought[msg.sender] < 3, "You cannot purchase more than 3 tickets per person.");
        
        players.push(payable(msg.sender));
        ticketsBought[msg.sender] += 1;
    }

    function getLength() public view returns (uint) {
        return players.length;
    }

    function _randomNumber() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function selectWinner() public onlyAdmin {
        require(getLength() >= 5, "There must be at least 5 players.");

        uint pickRandom = _randomNumber();
        uint selectIndex = pickRandom % players.length;
        address payable winner = players[selectIndex];

        uint balance = getBalance();
        uint tax = (balance * 5) / 1000; // คำนวณภาษี 0.5%
        uint prize = balance - tax; // จำนวนเงินรางวัลหลังหักภาษี

        // โอนภาษีไปยัง adminManager
        payable(adminManager).transfer(tax);
        // โอนเงินรางวัลที่เหลือไปยังผู้ชนะ
        winner.transfer(prize);

        _resetLottery();
    }

    // function resetLottery
    function _resetLottery() private {
        for (uint i = 0; i < players.length; i++) {
            delete ticketsBought[players[i]];
        }
        players = new address payable[](0) ;
    }
}

















/*


//ประกาศ Contract Lotter เริ่มสัญญา
contract Lottery {
    //State Variables
    address public adminManager;                          //adminManager ที่อยู่ของผู้จัดการ (manager) ของลอตเตอรี
    address payable[] public players;                     //players อาร์เรย์ของ Address เงินที่เข้าร่วมลอตเตอรี
    mapping(address => uint) public ticketsBought;        //ticketsBought การจับคู่ระหว่างที่อยู่ของผู้เล่นกับจำนวนตั๋วที่ซื้อไป

    constructor() {
        adminManager = msg.sender;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function buyLottery() public payable {
        require(msg.value == 1 ether, "Please buy lottery tickets for 1 ETH only.");
        require(ticketsBought[msg.sender] < 3, "You cannot purchase more than 3 tickets per person.");
        
        players.push(payable(msg.sender));
        ticketsBought[msg.sender] += 1;
    }

    function getLength() public view returns (uint) {
        return players.length;
    }

    function randomNumber() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function selectWinner() public {
        require(msg.sender == adminManager, "Only the adminManager can call this function.");
        require(getLength() >= 5, "There must be at least 5 players.");

        uint pickRandom = randomNumber();
        address payable winner;
        uint selectIndex = pickRandom % players.length; 
        winner = players[selectIndex];
        winner.transfer(getBalance());

        resetLottery();
    }

    function resetLottery() private {
        for (uint i = 0; i < players.length; i++) {
            delete ticketsBought[players[i]];
        }
    players = new address payable [](0);

    }
}
*/