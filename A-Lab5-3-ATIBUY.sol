// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TokenTransfer {
    mapping(address => uint256) private balances;
    uint256 public totalSupply;
    address[] public  Monney;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner call this function");
        _; //ไปที่ฟังก์ชันนั้นๆที่เรียกใช้
    }

    function fund() public payable onlyOwner {
        balances[msg.sender] += msg.value;
        Monney.push(msg.sender);
        totalSupply += msg.value;
    }

    function transfer(address recipient, uint256 amount) public {
        require(balances[msg.sender] >= amount, "NO MONEY BRO");
        balances[msg.sender] -= amount;
        balances[recipient] += amount; // Updates recipient balance
    }

    //function balancess() public returns view onlyOwner {

    //}




    /*
contract TokenTransfer {
ประกาศสัญญา (contract) ชื่อว่า TokenTransfer


    mapping(address => uint256) private balances;
ประกาศตัวแปร balances ซึ่งเป็น mapping โดยใช้ address เป็นกุญแจและเก็บค่าประเภท uint256 เพื่อบันทึกยอดเงินคงเหลือของผู้ใช้แต่ละคน ตัวแปรนี้เป็น private จึงไม่สามารถเข้าถึงได้จากภายนอกสัญญา


    uint256 public totalSupply;
ประกาศตัวแปร totalSupply ซึ่งเป็น uint256 และตั้งให้เป็น public เพื่อให้สามารถเข้าถึงได้จากภายนอกสัญญา ตัวแปรนี้ใช้เก็บยอดเงินรวมทั้งหมดที่มีอยู่ในสัญญา


    address[] public Monney;
ประกาศตัวแปร Monney ซึ่งเป็นอาร์เรย์ของ address และตั้งให้เป็น public เพื่อให้สามารถเข้าถึงได้จากภายนอกสัญญา ตัวแปรนี้ใช้เก็บรายการที่อยู่ของผู้ที่เคยทำการฝากเงิน


    address public owner;
ประกาศตัวแปร owner ซึ่งเก็บที่อยู่ของเจ้าของสัญญา และตั้งให้เป็น public เพื่อให้สามารถเข้าถึงได้จากภายนอกสัญญา


    constructor() {
        owner = msg.sender;
    }
คอนสตรักเตอร์ของสัญญา ตั้งค่า owner เป็นที่อยู่ของผู้ที่ทำการดีพลอย (deploy) สัญญานี้



    modifier onlyOwner() {
        require(msg.sender == owner, "only owner call this function");
        _;
    }
ประกาศตัวแก้ (modifier) ชื่อ onlyOwner เพื่อจำกัดการเรียกใช้งานฟังก์ชันบางฟังก์ชันได้เฉพาะเจ้าของสัญญาเท่านั้น โดยตรวจสอบว่าผู้เรียกใช้เป็นเจ้าของสัญญาหรือไม่


    function fund() public payable onlyOwner {
        balances[msg.sender] += msg.value;
        Monney.push(msg.sender);
        totalSupply += msg.value;
    }
ฟังก์ชัน fund รับเงินเข้ามา (payable) และอนุญาตให้เรียกใช้ได้เฉพาะเจ้าของสัญญาเท่านั้น (onlyOwner) ฟังก์ชันนี้เพิ่มยอดเงินของเจ้าของสัญญาใน balances 
เพิ่มที่อยู่ของเจ้าของสัญญาลงใน Monney และเพิ่มยอดเงินที่ฝากเข้ามาใน totalSupply


    function transfer(address recipient, uint256 amount) public {
        require(balances[msg.sender] >= amount, "NO MONEY BRO");
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
    }
ฟังก์ชัน transfer ใช้สำหรับโอนยอดเงินจากผู้ส่งไปยังผู้รับ โดยรับพารามิเตอร์ recipient ซึ่งเป็นที่อยู่ของผู้รับ และ amount ซึ่งเป็นจำนวนเงินที่จะโอน 
ฟังก์ชันนี้ตรวจสอบว่าผู้ส่งมียอดเงินเพียงพอที่จะโอน (require(balances[msg.sender] >= amount, "NO MONEY BRO");) หากผ่านการตรวจสอบ ยอดเงินจะถูกหักจากผู้ส่งและเพิ่มให้กับผู้รับ


    // function balancess() public view onlyOwner {
    // }
โค้ดนี้เป็นคอมเมนต์ ซึ่งบ่งบอกว่าฟังก์ชัน balancess ถูกคอมเมนต์ไว้และไม่ได้ใช้งานในขณะนี้

สรุป: โค้ดนี้เป็นสัญญา (contract) ในภาษา Solidity ที่ใช้จัดการยอดเงินฝากและการโอนยอดเงินระหว่างผู้ใช้ โดยมีฟังก์ชัน fund สำหรับเจ้าของสัญญาในการฝากเงินเข้ามาในสัญญา 
และฟังก์ชัน transfer สำหรับการโอนยอดเงินระหว่างผู้ใช้ต่างๆ

    */
}