// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; //Deplpy 0.8.7 

//ประกาศ Contract Lotter เริ่มสัญญา
contract Lottery {
    //State Variables
    address public manager;                          //manager ที่อยู่ของผู้จัดการ (manager) ของลอตเตอรี
    address payable[] public players;                //players อาร์เรย์ของที่อยู่เงินที่เข้าร่วมลอตเตอรี
    mapping(address => uint) public ticketsBought;   //ticketsBought การจับคู่ระหว่างที่อยู่ของผู้เล่นกับจำนวนตั๋วที่ซื้อไป
    uint private _roundsPlayed;                        // เก็บจำนวนรอบที่เล่นไปแล้ว

    constructor() {
        manager = msg.sender;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function buyLottery() public payable {
        require(msg.value == 1 ether, "Please buy lottery 1 ETH only");
        require(ticketsBought[msg.sender] < 3, "Cannot buy more than 3 tickets per person");
        
        players.push(payable(msg.sender));
        ticketsBought[msg.sender] += 1;
    }

    function getLength() public view returns (uint) {
        return players.length;
    }

    function randomNumber() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function selectWinners() public {
        require(msg.sender == manager, "Only the manager can call this function.");
        require(getLength() >= 2, "At least 2 players required.");

        uint prizePool = getBalance(); // ยอดรวมเงินรางวัล

        // คำนวณจำนวนเงินแต่ละรางวัล
        uint prize1Amount = (prizePool * 60) / 100; // 60% ของรางวัล
        uint prize2Amount = (prizePool * 30) / 100; // 30% ของรางวัล
        uint prize3Amount = prizePool - prize1Amount - prize2Amount; // 10% ของรางวัล

        // สร้างอาร์เรย์เพื่อเก็บผู้ถูกรางวัล
        address payable[] memory winners = new address payable[](3);

        // สุ่มผู้ถูกรางวัลแต่ละคน
        for (uint i = 0; i < 3; i++) {
            uint pickRandom = randomNumber();
            uint selectIndex = pickRandom % players.length;
            address payable winner = players[selectIndex];
            uint prizeAmount;

            // กำหนดเงินรางวัลของผู้ถูกรางวัล
            if (i == 0) {
                prizeAmount = prize1Amount;
            } else if (i == 1) {
                prizeAmount = prize2Amount;
            } else {
                prizeAmount = prize3Amount;
            }

            // คำนวณเงินที่ต้องหักสำหรับผู้จัดการ (0.5%)
            uint fee = (prizeAmount * 5) / 1000; // 0.5% ของเงินรางวัล
            prizeAmount -= fee; // หักค่าธรรมเนียม

            winner.transfer(prizeAmount); // โอนเงินรางวัลให้กับผู้ถูกรางวัล

            // เก็บผู้ถูกรางวัลในอาร์เรย์
            winners[i] = winner;

            // ลบผู้ถูกรางวัลจากอาร์เรย์ players เพื่อไม่ให้เข้าไปในการสุ่มซ้ำ
            players[selectIndex] = players[players.length - 1];
            players.pop();
        }

        // หักค่าธรรมเนียมและโอนเงินรางวัลให้กับผู้จัดการ
        uint managerFee = (prizePool * 5) / 1000; // 0.5% ของเงินรางวัล
        payable(manager).transfer(managerFee);

        resetLottery();
    }
    
    //ฟังก์ชัน resetLottery เพื่อลบข้อมูลการซื้อตั๋วของผู้เล่นแต่ละคน และรีเซ็ตสถานะของลอตเตอรีเพื่อเริ่มต้นใหม่
    function resetLottery() private {
        for (uint i = 0; i < players.length; i++) {
            delete ticketsBought[players[i]];
        }
        players = new address payable[](0) ;
        
        // เพิ่มจำนวนรอบที่เล่นไปแล้ว
        _roundsPlayed++;
    }
    
    //ฟังก์ชันเพื่อดูจำนวนรอบที่เล่นไปทั้งหมด
    function getRoundsPlayed() public view 
    returns (uint) {
        return _roundsPlayed;
    }
}
