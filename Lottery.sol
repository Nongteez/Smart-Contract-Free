// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {
    address public manager; // ที่อยู่ของผู้ดูแลล็อตเตอร์
    address[] public players; // อาร์เรย์ของที่อยู่ของผู้เล่นที่เข้าร่วมล็อตเตอร์
    uint public numTickets; // จำนวนตั๋วหวยที่ถูกซื้อ
    uint public winningNumber; // เลขที่ถูกรางวัล
    bool public lotteryEnded; // สถานะการจบการจับสลาก
    
    constructor() {
        manager = msg.sender;
    }
    
    // ฟังก์ชันในการซื้อตั๋วหวย
    function buyTicket() public payable {
        require(msg.value == 1 ether, "Ticket price must be 0.01 ether");
        players.push(msg.sender);
        numTickets++;
    }
    
    // ฟังก์ชันในการสุ่มเลขรางวัล
    function generateWinningNumber() public restricted {
        require(!lotteryEnded, "Lottery has ended");
        winningNumber = uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
        lotteryEnded = true;
    }
    
    // ฟังก์ชันในการจ่ายเงินรางวัลให้กับผู้ชนะ
    function distributePrize() public restricted {
        require(lotteryEnded, "Lottery has not ended yet");
        require(numTickets > 0, "No tickets were purchased");
        
        for (uint i = 0; i < players.length; i++) {
            if (uint(keccak256(abi.encodePacked(players[i]))) == winningNumber) {
                payable(players[i]).transfer(address(this).balance);
            }
        }
    }
    
    // ฟังก์ชันในการตรวจสอบสถานะการซื้อตั๋ว
    function checkLotteryStatus() public view returns (bool) {
        return lotteryEnded;
    }
    
    // ฟังก์ชันในการตรวจสอบผู้เล่นที่เข้าร่วมล็อตเตอร์
    function getPlayers() public view returns (address[] memory) {
        return players;
    }
    
    // ฟังก์ชัน modifier ในการจำกัดสิทธิ์เฉพาะผู้ดูแลล็อตเตอร์เท่านั้น
    modifier restricted() {
        require(msg.sender == manager, "Only manager can call this function");
        _;
    }
}
