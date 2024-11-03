// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

    contract Donation {
        mapping(address => uint256) public balances;
        address payable private _owner;
        uint256 public totalSupply;
        address[] private Monney;


    constructor() {
            _owner = payable(msg.sender);
    }
    modifier onlyOwner{
       require(msg.sender == _owner ,"only owner call this function");
       _; 
    }

    function donate() public payable {
        totalSupply += msg.value;
        _owner. transfer(msg.value);
        Monney.push(msg.sender);
        balances[msg.sender] += msg.value;
        require(msg.value > 0 ," 1 NAJA");
    }

}


/*
contract Donation {
ประกาศสัญญา (contract) ชื่อว่า Donation


    mapping(address => uint256) public balances;
ประกาศตัวแปร balances ซึ่งเป็น mapping โดยใช้ address เป็นกุญแจและเก็บค่าประเภท uint256 เพื่อบันทึกยอดเงินที่ผู้ใช้แต่ละคนได้บริจาค และตั้งให้ตัวแปรนี้เป็น public เพื่อให้สามารถเข้าถึงได้จากภายนอกสัญญา


    address payable private _owner;
ประกาศตัวแปร _owner ซึ่งเก็บที่อยู่ของเจ้าของสัญญา และตั้งให้เป็น payable เพื่อให้สามารถรับและส่ง Ether ได้ ตัวแปรนี้เป็น private จึงไม่สามารถเข้าถึงได้จากภายนอกสัญญา


    uint256 public totalSupply;
ประกาศตัวแปร totalSupply ซึ่งเป็น uint256 และตั้งให้เป็น public เพื่อให้สามารถเข้าถึงได้จากภายนอกสัญญา ตัวแปรนี้ใช้เก็บยอดรวมของเงินที่ได้รับการบริจาคทั้งหมด


    address[] private Monney;
ประกาศตัวแปร Monney ซึ่งเป็นอาร์เรย์ของ address และตั้งให้เป็น private เพื่อเก็บรายการที่อยู่ของผู้ที่ทำการบริจาค


    constructor() {
        _owner = payable(msg.sender);
    }
คอนสตรักเตอร์ของสัญญา ตั้งค่า _owner เป็นที่อยู่ของผู้ที่ทำการดีพลอย (deploy) สัญญานี้ และทำให้ _owner เป็น payable เพื่อให้สามารถรับและส่ง Ether ได้


    modifier onlyOwner {
        require(msg.sender == _owner, "only owner call this function");
        _;
    }
ประกาศตัวแก้ (modifier) ชื่อ onlyOwner เพื่อจำกัดการเรียกใช้งานฟังก์ชันบางฟังก์ชันได้เฉพาะเจ้าของสัญญาเท่านั้น โดยตรวจสอบว่าผู้เรียกใช้เป็นเจ้าของสัญญาหรือไม่


    function donate() public payable {
        totalSupply += msg.value;
        _owner.transfer(msg.value);
        Monney.push(msg.sender);
        balances[msg.sender] += msg.value;
        require(msg.value > 0, " 1 NAJA");
    }
ฟังก์ชัน donate รับเงินเข้ามา (payable) และดำเนินการดังนี้:

เพิ่มจำนวนเงินที่ได้รับบริจาค (msg.value) ลงใน totalSupply
โอนจำนวนเงินที่ได้รับบริจาคไปยัง _owner (_owner.transfer(msg.value))
เพิ่มที่อยู่ของผู้บริจาค (msg.sender) ลงในอาร์เรย์ Monney
เพิ่มจำนวนเงินที่ได้รับบริจาคลงในยอดเงินของผู้บริจาคใน balances
ตรวจสอบว่าจำนวนเงินที่บริจาค (msg.value) มากกว่า 0 (require(msg.value > 0, " 1 NAJA"))

สรุป: โค้ดนี้เป็นสัญญา (contract) ในภาษา Solidity ที่ใช้จัดการระบบบริจาค โดยมีฟังก์ชัน donate ที่ให้ผู้ใช้สามารถบริจาคเงินไปยังสัญญาได้ 
เมื่อมีการบริจาค จำนวนเงินจะถูกโอนให้กับเจ้าของสัญญา (_owner) และจะมีการบันทึกยอดรวมเงินบริจาค (totalSupply) และยอดเงินที่ผู้ใช้แต่ละคนได้บริจาค (balances)

*/