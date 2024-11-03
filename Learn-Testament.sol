// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Will {
    address _admin;
    mapping(address => address) _heirs;
    mapping(address => uint256) _balances;
    event Create(address indexed owner, address indexed heir, uint256 amount);
    event Deceased(address owner, address heir, uint256 amount);

    constructor() {
        _admin = msg.sender;
    }

    function createWill(address heir) public payable {
        require(msg.value > 0, "amount is zero");
        require(_balances[msg.sender] <= 0, "already exists");

        _heirs[msg.sender] = heir;
        _balances[msg.sender] = msg.value;

        emit Create(msg.sender, heir, msg.value);
    }

    function deceased(address owner) public {
        require(msg.sender == _admin, "unauthorized");
        require(_balances[owner] > 0, "no testament");

        emit Deceased(owner, _heirs[owner], _balances[owner]);
        payable(_heirs[owner]).transfer(_balances[owner]);
        _heirs[owner] = address(0);
        _balances[owner] = 0;
    }

    function contracts(address owner)
        public
        view
        returns (address heir, uint256 balance)
    {
        return (_heirs[owner], _balances[owner]);
    }
}

/*


contract Will {
    address _admin;
    mapping(address => address) _heirs;
    mapping(address => uint) _balances;
    event Create(address indexed owner, address indexed heir, uint amount);
    event Deceased(address owner, address heir, uint amount);
ประกาศสัญญาชื่อ Will และตัวแปร:

_admin: เก็บที่อยู่ของผู้ดูแลระบบ
_heirs: เก็บข้อมูลทายาทของแต่ละเจ้าของพินัยกรรม (mapping จากที่อยู่ของเจ้าของพินัยกรรมไปยังที่อยู่ของทายาท)
_balances: เก็บยอดเงินที่แต่ละเจ้าของพินัยกรรมฝากไว้ (mapping จากที่อยู่ของเจ้าของพินัยกรรมไปยังยอดเงิน)
event Create: อีเวนต์สำหรับการสร้างพินัยกรรม
event Deceased: อีเวนต์สำหรับการโอนเงินให้ทายาทเมื่อเจ้าของพินัยกรรมเสียชีวิต

    constructor() {
        _admin = msg.sender;
    }
คอนสตรักเตอร์ของสัญญา ตั้งค่า _admin เป็นที่อยู่ของผู้ที่ทำการดีพลอย (deploy) สัญญานี้


    function createWill(address heir) public payable {
        require(msg.value > 0, "amount is zero");
        require(_balances[msg.sender] <= 0, "already exists");

        _heirs[msg.sender] = heir;
        _balances[msg.sender] = msg.value;

        emit Create(msg.sender, heir , msg.value);
    }
ฟังก์ชัน createWill สำหรับสร้างพินัยกรรม:

รับที่อยู่ของทายาท (heir) และจำนวนเงิน (จากการจ่ายค่าแก๊ส)
ตรวจสอบว่าจำนวนเงินที่ฝากมากกว่า 0
ตรวจสอบว่าเจ้าของพินัยกรรมนี้ยังไม่มีพินัยกรรมอยู่ในระบบ
บันทึกที่อยู่ของทายาทและยอดเงินที่ฝาก
ส่งอีเวนต์ Create เพื่อแจ้งการสร้างพินัยกรรม

    function deceased(address owner) public {
        require(msg.sender == _admin, "unauthorized");
        require(_balances[owner] > 0, "no testament");
        
        emit Deceased(owner, _heirs[owner], _balances[owner]);
        payable(_heirs[owner]).transfer(_balances[owner]);
        _heirs[owner] = address(0);
        _balances[owner] = 0;
    }
ฟังก์ชัน deceased สำหรับโอนเงินให้ทายาทเมื่อเจ้าของพินัยกรรมเสียชีวิต:

รับที่อยู่ของเจ้าของพินัยกรรม (owner)
ตรวจสอบว่าผู้เรียกฟังก์ชันเป็น _admin
ตรวจสอบว่าเจ้าของพินัยกรรมมีพินัยกรรมอยู่ในระบบ
ส่งอีเวนต์ Deceased เพื่อแจ้งการโอนเงิน
โอนเงินจากเจ้าของพินัยกรรมไปยังทายาท
ลบข้อมูลพินัยกรรมที่เกี่ยวข้องกับเจ้าของพินัยกรรม

    function contracts(address owner) public view returns(address heir, uint balance) {
        return (_heirs[owner], _balances[owner]);
    }
}
ฟังก์ชัน contracts สำหรับตรวจสอบข้อมูลพินัยกรรม:

รับที่อยู่ของเจ้าของพินัยกรรม (owner)
คืนค่าที่อยู่ของทายาทและยอดเงินของเจ้าของพินัยกรรม
สรุป
โค้ดนี้เป็นสัญญาอัจฉริยะที่จัดการระบบพินัยกรรมดิจิทัล โดยมีฟังก์ชันในการสร้างพินัยกรรม (createWill), โอนเงินให้ทายาทเมื่อเจ้าของพินัยกรรมเสียชีวิต (deceased), และตรวจสอบข้อมูลพินัยกรรม (contracts)

ระบบนี้มีการตรวจสอบความถูกต้องและความปลอดภัยพื้นฐาน เช่น การตรวจสอบสิทธิ์ผู้เรียกใช้ฟังก์ชันและการตรวจสอบความถูกต้องของข้อมูลพินัยกรรม 
อย่างไรก็ตาม อาจต้องเพิ่มฟังก์ชันเพิ่มเติมเพื่อรองรับการใช้งานที่ซับซ้อนขึ้น และการจัดการเหตุการณ์ที่อาจเกิดขึ้น เช่น การอัปเดตทายาทหรือยอดเงินในพินัยกรรม
*/
