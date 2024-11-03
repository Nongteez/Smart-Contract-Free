// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; // Deploy 0.8.7 

contract LotteryProject_GradeA_Nakub {
    // ตัวแปรสถานะ
    address payable public admin;                                           // admin ที่อยู่ของผู้จัดการ (admin) ของลอตเตอรี
    address payable[] private players;                                       // ตัวแปรเก็บ Address ของผู้เล่นที่เข้าร่วมการจับสลาก
    mapping(address => uint) public ticketsBought;                          // ตัวแปร mapping เก็บจำนวนตั๋วที่ซื้อโดยผู้เล่นแต่ละคน
    mapping(address => uint) public winnings;                               // ตัวแปร mapping เก็บจำนวนเงินรางวัลที่ผู้เล่นแต่ละคนที่ชนะ
    uint private _roundsPlayed;                                             // ตัวแปรเก็บจำนวนรอบที่เล่นไปแล้ว
    mapping(uint => address payable[]) private _winnersByRound;             // ตัวแปร mapping เก็บรายชื่อผู้ชนะในแต่ละรอบ

    // Struct แอดมิน INFO ให้กรอก ตอน DEPLOY 1.ขื่อ 2.หน่วยงาน, 3.ที่อยู่หน่วยงาน, 4.รายละเอียดล็อตเตอร์รี่, 5.Addressกระเป๋าเงิน 
    struct AdminInfo {
        string name;
        string agency;
        string addressLocation;
        string detailLottery;
        address addressWallet;

    }

    // ตัวแปรเก็บข้อมูลแอดมิน
    AdminInfo public adminInfo; 

    // Events ไว้บันทึกเหตุการณ์ต่างๆที่เกิดขึ้นในนี้เก็บ 1.LotteryBought , 2.WinnerSelected 
    event LotteryBought(address indexed player, uint timestamp);                // 1.LotteryBought สำหรับบันทึกการซื้อหวย 
    event WinnerSelected(address payable[] winners, uint timestamp);            // 2.WinnerSelected สำหรับบันทึกผู้ถูกรางวัล

    // ฟังก์ชัน constructor จะทำงานเมื่อ deploy contract ก็เก็บข้อมูล ใน Struct AdminInfo
    constructor(string memory _name, string memory _agency, string memory _addressLocation, string memory _detailLottery) {
        admin = payable(msg.sender); //// กำหนดให้ผู้สร้าง contract เป็นแอดมิน
        
        //ข้อมูลที่บันทึกตอน Deploy
        adminInfo = AdminInfo({
            name: _name,
            agency: _agency,
            addressLocation: _addressLocation,
            detailLottery: _detailLottery,
            addressWallet: msg.sender
        });
    }
    
    // modifier  onlyAdmin เพื่อจำกัดการเข้าถึงฟังก์ชันเฉพาะแอดมิน
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only the admin can call this function.");
        _;
    }

    // function getBalance ฟังก์ชันเพื่อดูยอดคงเหลือของ contract ยอนเงินที่ผู้ใช้ทำการซื้อหวย ยอดเงินทั้งหมดจะถูกเก็บ และสามารถ เรียกใช้ getBalance เพื่อดูยอดเงิน
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    // function buyLottery ฟังก์ชันสำหรับซื้อสลาก
    function buyLottery() public payable {
        require(msg.value == 1 ether, "Please buy lottery 1 ETH only");                           //แจ้งเตือนให้ผู้ใช้ ซื้อจำนวน 1 ETH เท่านั้น
        require(ticketsBought[msg.sender] < 3, "Cannot buy more than 3 tickets per person");      //ผู้ใช้ สามารถซื้อได้ 3 ใบ ต่อ 1รอบ
        
        players.push(payable(msg.sender));                  // เพิ่ม Address ผู้เล่นในอาร์เรย์ players
        ticketsBought[msg.sender] += 1;                     // เพิ่มจำนวนตั๋วที่ซื้อของผู้เล่น
        
        // ส่ง event เมื่อผู้เล่นซื้อตั๋ว
        emit LotteryBought(msg.sender, block.timestamp);   
    }

    // function getLength ฟังก์ชันเพื่อดูจำนวนผู้เล่น
    function getLength() public view returns (uint) {
        return players.length;
    }

    // ฟังก์ชันสร้างเลขสุ่ม
    function randomNumber() private view returns  (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    // ฟังก์ชันเลือกผู้ชนะ ใช้ได้แค่ Admin 
    function randomWinners() public onlyAdmin {
        require(getLength() >= 5, "At least 5 players required.");  // แจ้งเตือน ต้องมีผู้เล่นอย่างน้อย 5 คน ถ้าคนเล่นไม่ถึง 5 คน จะไม่สามารถสุ่มได้

        // ดึงยอดคงเหลือทั้งหมดของ contract
        uint prizePool = getBalance();  

        uint prize1Amount = (prizePool * 60) / 100;                             // จำนวนเงินรางวัลที่ 1 60% ของรางวัล
        uint prize2Amount = (prizePool * 30) / 100;                             // จำนวนเงินรางวัลที่ 2 40% ของรางวัล
        uint prize3Amount = prizePool - prize1Amount - prize2Amount;            // จำนวนเงินรางวัลที่ 3 10% ของรางวัล

        address payable[] memory winners = new address payable[](3);            // อาร์เรย์เก็บ Address ของผู้ชนะ ทั้ง 3 คน

        // for สำหรับ หาผู้ชนะ รางวัล ที่ 1- 3
        for (uint i = 0; i < 3; i++) {
            uint pickRandom = randomNumber();                   // เลขสุ่ม
            uint selectIndex = pickRandom % players.length;     // เลือก index จากการสุ่ม
            address payable winner = players[selectIndex];      // ดึงที่อยู่ผู้ชนะจาก players
            uint prizeAmount;

            // กำหนดเงินรางวัลของผู้ถูกรางวัล
            if (i == 0) {
                prizeAmount = prize1Amount;     // กำหนดจำนวนเงินรางวัลที่ 1
            } else if (i == 1) {
                prizeAmount = prize2Amount;     // กำหนดจำนวนเงินรางวัลที่ 2
            } else {
                prizeAmount = prize3Amount;     // กำหนดจำนวนเงินรางวัลที่ 3
            }
            
            // คำนวณเงินที่ต้องหักสำหรับผู้จัดการ (0.5%)
            uint fee = (prizeAmount * 5) / 1000;      // 0.5% ของเงินรางวัล
            prizeAmount -= fee;                       // หักค่าธรรมเนียมออกจากจำนวนเงินรางวัล

            // เพิ่มจำนวนเงินรางวัลให้กับผู้ชนะ
            winnings[winner] += prizeAmount;
            
            // เพิ่มผู้ชนะในอาร์เรย์ winners
            winners[i] = winner;

            // บันทึก ผู้ถูกรางวัลลงในรายการของ แต่ละรอบ
            _winnersByRound[_roundsPlayed].push(winner);

            // ลบผู้ถูกรางวัลจากอาร์เรย์ players เพื่อไม่ให้เข้าไปในการสุ่มซ้ำ
            players[selectIndex] = players[players.length - 1];
            players.pop();
        }

        // หักค่าธรรมเนียมและโอนเงินรางวัลให้กับผู้จัดการ
        uint adminFee = (prizePool * 5) / 1000;     // คำนวณค่าธรรมเนียมของแอดมิน
        admin.transfer(adminFee);                   // โอนค่าธรรมเนียมให้แอดมิน

        // เรียก Event สำหรับบันทึกผู้ถูกรางวัล
        emit WinnerSelected(winners, block.timestamp);

        // รีเซ็ตการจับสลากเพื่อเริ่มรอบใหม่
        resetLottery(); 
    }

    // function resetLottery ฟังก์ชันรีเซ็ตการจับสลาก
    function resetLottery() private {
        for (uint i = 0; i < players.length; i++) {
            delete ticketsBought[players[i]];
        }
        players = new address payable[](0) ;

        _roundsPlayed++;
    }

    // function getRoundsPlayed ฟังก์ชันเพื่อดูจำนวนรอบที่เล่นไปทั้งหมด
    function getRoundsPlayed() public view returns (uint) {
        return _roundsPlayed;
    }

    // function getWinnersByRound ฟังก์ชันเพื่อดูผู้ชนะในแต่ละรอบ
    function getWinnersByRound(uint round) public view returns (address payable[] memory) {
        uint index = round - 1;
        return _winnersByRound[index];
    }

    // function withdrawWinnings ฟังก์ชันเพื่อถอนเงินรางวัล สำหรับผู้ที่ถูกรางวัล
    function withdrawWinnings() public payable {
        uint amount = winnings[msg.sender];                     // ดึงจำนวนเงินรางวัลของผู้เรียกฟังก์ชัน
        require(amount > 0, "No winnings to withdraw");         // ตรวจสอบว่ามีเงินรางวัลที่จะถอน ถ้าไม่มีจะขึ้น  No winnings to withdraw ก็แสดงว่าไม่ถูกรางวัล
        winnings[msg.sender] = 0;                               // ตั้งค่าเงินรางวัลเป็น 0 ก่อนโอนเงิน และ ป้องกัน Reentrancy
        payable(msg.sender).transfer(amount);                   // โอนเงินรางวัลให้ผู้เรียกฟังก์ชัน
    }
}
