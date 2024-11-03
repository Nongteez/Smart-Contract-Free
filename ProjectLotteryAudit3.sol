// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; // Deploy 0.8.7 

contract LotteryProject {
    // State Variables
    address payable public admin; // ตัวแปรเก็บที่อยู่ของแอดมินที่สามารถรับ Ether ได้
    address payable[] public players; // ตัวแปรเก็บที่อยู่ของผู้เล่นที่เข้าร่วมการจับสลาก
    mapping(address => uint) public ticketsBought; // ตัวแปร mapping เก็บจำนวนตั๋วที่ซื้อโดยผู้เล่นแต่ละคน
    mapping(address => uint) public winnings; // ตัวแปร mapping เก็บจำนวนเงินรางวัลที่ผู้เล่นแต่ละคนชนะ
    uint private _roundsPlayed; // ตัวแปรเก็บจำนวนรอบที่เล่นไปแล้ว
    mapping(uint => address payable[]) private _winnersByRound; // ตัวแปร mapping เก็บรายชื่อผู้ชนะในแต่ละรอบ

    // Struct แอดมิน INFO ให้กรอก ตอน DEPLOY
    struct AdminInfo {
        string name; // ชื่อแอดมิน
        string agency; // หน่วยงานที่แอดมินสังกัด
        string addressLocation; // ที่อยู่ของหน่วยงาน
        string detailLottery; // รายละเอียดของการจับสลาก
        address addressWallet; // ที่อยู่กระเป๋าเงินของแอดมิน

    }

    AdminInfo public adminInfo; // ตัวแปรเก็บข้อมูลแอดมิน

    // Events
    event LotteryBought(address indexed player, uint timestamp); // เหตุการณ์ที่เกิดขึ้นเมื่อผู้เล่นซื้อตั๋ว
    event WinnerSelected(address payable[] winners, uint timestamp); // เหตุการณ์ที่เกิดขึ้นเมื่อเลือกผู้ชนะ

    // ฟังก์ชัน constructor จะทำงานเมื่อ deploy contract
    constructor(string memory _name, string memory _agency, string memory _addressLocation, string memory _detailLottery) {
        admin = payable(msg.sender); // กำหนดให้ผู้สร้าง contract เป็นแอดมิน
        adminInfo = AdminInfo({
            name: _name,
            agency: _agency,
            addressLocation: _addressLocation,
            detailLottery: _detailLottery,
            addressWallet: msg.sender

        });
    }

    // modifier เพื่อจำกัดการเข้าถึงฟังก์ชันเฉพาะแอดมิน
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only the admin can call this function.");
        _;
    }

    // ฟังก์ชันเพื่อดูยอดคงเหลือของ contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    // ฟังก์ชันสำหรับซื้อตั๋วสลาก
    function buyLottery() public payable {
        require(msg.value == 1 ether, "Please buy lottery 1 ETH only");
        require(ticketsBought[msg.sender] < 3, "Cannot buy more than 3 tickets per person");
        
        players.push(payable(msg.sender)); // เพิ่มที่อยู่ผู้เล่นในอาร์เรย์ players
        ticketsBought[msg.sender] += 1; // เพิ่มจำนวนตั๋วที่ซื้อของผู้เล่น
        
        emit LotteryBought(msg.sender, block.timestamp); // ส่ง event เมื่อผู้เล่นซื้อตั๋ว
    }

    // ฟังก์ชันเพื่อดูจำนวนผู้เล่น
    function getLength() public view returns (uint) {
        return players.length;
    }

    // ฟังก์ชันสร้างเลขสุ่ม
    function randomNumber() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    // ฟังก์ชันเลือกผู้ชนะ
    function randomWinners() public onlyAdmin {
        require(getLength() >= 5, "At least 5 players required."); // ต้องมีผู้เล่นอย่างน้อย 5 คน

        uint prizePool = getBalance(); // ดึงยอดคงเหลือทั้งหมดของ contract

        uint prize1Amount = (prizePool * 60) / 100; // จำนวนเงินรางวัลที่ 1
        uint prize2Amount = (prizePool * 30) / 100; // จำนวนเงินรางวัลที่ 2
        uint prize3Amount = prizePool - prize1Amount - prize2Amount; // จำนวนเงินรางวัลที่ 3

        address payable[] memory winners = new address payable[](3); // อาร์เรย์เก็บที่อยู่ผู้ชนะ

        for (uint i = 0; i < 3; i++) {
            uint pickRandom = randomNumber(); // เลขสุ่ม
            uint selectIndex = pickRandom % players.length; // เลือก index จากการสุ่ม
            address payable winner = players[selectIndex]; // ดึงที่อยู่ผู้ชนะจาก players
            uint prizeAmount;

            if (i == 0) {
                prizeAmount = prize1Amount; // กำหนดจำนวนเงินรางวัลที่ 1
            } else if (i == 1) {
                prizeAmount = prize2Amount; // กำหนดจำนวนเงินรางวัลที่ 2
            } else {
                prizeAmount = prize3Amount; // กำหนดจำนวนเงินรางวัลที่ 3
            }

            uint fee = (prizeAmount * 5) / 1000; // คำนวณค่าธรรมเนียม
            prizeAmount -= fee; // หักค่าธรรมเนียมออกจากจำนวนเงินรางวัล

            winnings[winner] += prizeAmount; // เพิ่มจำนวนเงินรางวัลให้กับผู้ชนะ

            winners[i] = winner; // เพิ่มผู้ชนะในอาร์เรย์ winners

            _winnersByRound[_roundsPlayed].push(winner); // บันทึกผู้ชนะในรอบนั้น

            // ลบผู้ถูกรางวัลจากอาร์เรย์ players เพื่อไม่ให้เข้าไปในการสุ่มซ้ำ
            players[selectIndex] = players[players.length - 1];
            players.pop();
        }

        uint adminFee = (prizePool * 5) / 1000; // คำนวณค่าธรรมเนียมของแอดมิน
        admin.transfer(adminFee); // โอนค่าธรรมเนียมให้แอดมิน

        emit WinnerSelected(winners, block.timestamp); // ส่ง event เมื่อเลือกผู้ชนะเสร็จสิ้น

        resetLottery(); // รีเซ็ตการจับสลากเพื่อเริ่มรอบใหม่
    }

    // ฟังก์ชันรีเซ็ตการจับสลาก
    function resetLottery() private {
        for (uint i = 0; i < players.length; i++) {
            delete ticketsBought[players[i]]; // ลบจำนวนตั๋วที่ซื้อของผู้เล่นแต่ละคน
        }
        players = new address payable[](0) ; // รีเซ็ตอาร์เรย์ players

        _roundsPlayed++; // เพิ่มจำนวนรอบที่เล่นไปแล้ว
    }

    // ฟังก์ชันเพื่อดูจำนวนรอบที่เล่นไปแล้ว
    function getRoundsPlayed() public view returns (uint) {
        return _roundsPlayed;
    }

    // ฟังก์ชันเพื่อดูผู้ชนะในแต่ละรอบ
    function getWinnersByRound(uint round) public view returns (address payable[] memory) {
        uint index = round - 1;
        return _winnersByRound[index];
    }

    // ฟังก์ชันเพื่อถอนเงินรางวัล
    function withdrawWinnings() public payable {
        uint amount = winnings[msg.sender]; // ดึงจำนวนเงินรางวัลของผู้เรียกฟังก์ชัน
        require(amount > 0, "No winnings to withdraw"); // ตรวจสอบว่ามีเงินรางวัลที่จะถอน
        winnings[msg.sender] = 0; // รีเซ็ตจำนวนเงินรางวัลเป็น 0
        payable(msg.sender).transfer(amount); // โอนเงินรางวัลให้ผู้เรียกฟังก์ชัน
    }
}
