// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; //Deplpy 0.8.7 

//ประกาศ Contract Lotter เริ่มสัญญา
contract Lottery {
    //State Variables
    address public manager;                          //manager แอดเดรส ที่อยู่ของ (manager) ของลอตเตอรี
    address payable[] public players;                //players Array ของ แอดเดรส ที่อยู่เงินที่เข้าร่วมลอตเตอรี
    mapping(address => uint) public ticketsBought;   //ticketsBought  เพื่อเก็บจำนวนตั๋วที่ซื้อไว้ของแต่ละผู้เล่น (การจับคู่ระหว่างที่อยู่ของผู้เล่นกับจำนวนตั๋วที่ซื้อไป)

    //เริ่มต้นฟังก์ชัน constructor ซึ่งจะถูกเรียกทันทีเมื่อสร้างสัญญา และกำหนด Address ของผู้สร้างสัญญาเป็นผู้จัดการสัญญา
    constructor() {
        manager = msg.sender;
    }

    //ฟังก์ชัน getBalance เพื่อคืนค่ายอดเงินในสัญญา (แสดงจำนวนเงินทั้้งหมดที่อยู่ใน Smart Contract )
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    //ฟังก์ชัน buyLottery ไว้ซื้อ lottery 
    function buyLottery() public payable {
        require(msg.value == 1 ether, "Please buy lottery 1 ETH only");                        //กำหนดให้ซื้อตั๋วลอตเตอรีด้วยการโอน 1 ETH
        require(ticketsBought[msg.sender] < 3, "Cannot buy more than 3 tickets per person");   //กำหนดให้จำกัดจำนวนตั๋วที่ซื้อได้ต่อคนเป็นสูงสุด 3 ตั๋ว
        
        //เก็บที่อยู่ของผู้เล่นที่ซื้อตั๋วในอาร์เรย์
        players.push(payable(msg.sender));
        ticketsBought[msg.sender] += 1;
    }

    //ฟังก์ชัน getLength return จำนวนผู้เล่นที่เข้าร่วมลอตเตอรี (เอาไว้ดูจำนวนผูเ้ล่นในแต่ละรอบ)
    function getLength() public view returns (uint) {
        return players.length;
    }

    /*ฟังก์ชัน randomNumber ถูกออกแบบเพื่อสร้างตัวเลขสุ่มโดยใช้ฟังก์ชันแบบ Hashing 
    ซึ่งเป็นกระบวนการที่ใช้ในการแปลงข้อมูลอินพุตให้กลายเป็นค่า Hash ที่สุ่มแบบไม่สามารถทำนายได้ ซึ่งจะมีความสุ่มขึ้นอยู่กับข้อมูลอินพุตที่ใส่เข้าไป

        block.difficulty ค่าความยากในการขุดบล็อก ซึ่งเป็นข้อมูลที่เปลี่ยนแปลงได้เมื่อมีการเพิ่มหรือลดกำลังความยากในการขุดบล็อกของเครือข่าย Ethereum
        block.timestamp เวลาที่บล็อกถูกขุดในหน่วยวินาที Unix timestamp
        players.length จำนวนผู้เล่นที่เข้าร่วมลอตเตอรีในปัจจุบัน

        abi.encodePacked จะทำให้ข้อมูลที่รับเข้ามาถูกแปลงให้อยู่ในรูปแบบที่เหมาะสำหรับการคำนวณ Hash โดยที่ไม่มีการเพิ่ม byte padding หรือ delimiter ใดๆ
        จากนั้น keccak256 จะถูกเรียกใช้เพื่อสร้างค่า Hash จากข้อมูลที่ถูกแปลงแล้ว ซึ่งจะทำให้ได้ค่า Hash ที่ไม่สามารถทำนายล่วงหน้าได้ และมีคุณสมบัติของความสุ่ม
        สุดท้าย uint จะถูกใช้เพื่อแปลงค่า Hash ที่ได้มาเป็นตัวเลขที่สามารถใช้ได้ในการเลือกผู้ชนะ โดยการใช้ % players.length เพื่อให้ได้ตัวเลขในช่วงของจำนวนผู้เล่นที่เข้าร่วมลอตเตอรี
        */
    function randomNumber() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    //ฟังก์ชั่น selectWinner // เพื่อเลือกผู้ชนะและโอนเงินในสัญญาไปยังผู้ชนะ 
    function selectWinner() public {
        require(msg.sender == manager, "Only the manager can call this function.");  //เงื่อนไขว่าเฉพาะผู้จัดการเท่านั้นที่สามารถเรียกใช้ได้
        require(getLength() >= 2, "At least 2 players required.");                   //ต้องมีอย่างน้อย 2 ผู้เล่นเข้าร่วม ถึงจะใช้ฟังก์ชันที่ได้

        uint pickRandom = randomNumber();
        address payable winner;
        uint selectIndex = pickRandom % players.length; 
        winner = players[selectIndex];
        winner.transfer(getBalance());

        resetLottery();
    }

    //ฟังก์ชัน resetLottery เพื่อลบข้อมูลการซื้อตั๋วของผู้เล่นแต่ละคน และรีเซ็ตสถานะของลอตเตอรีเพื่อเริ่มต้นใหม่
    function resetLottery() private {
        for (uint i = 0; i < players.length; i++) {
            delete ticketsBought[players[i]];
        }
    players = new address payable [](0);

    }




}
