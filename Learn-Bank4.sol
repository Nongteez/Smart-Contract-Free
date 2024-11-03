// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {
    address private owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    // โครงสร้างข้อมูลของบัญชีผู้ใช้
    struct Account {
        string id;
        string name;
        address payable walletAddress;
        uint256 balance;
    }

    // แมปข้อมูลบัญชีผู้ใช้จาก ID
    mapping(string => Account) public accounts;

    // ฟังก์ชันเปิดบัญชีใหม่
    function openAccount(string memory _id, string memory _name, address payable _walletAddress) public onlyOwner {
        require(accounts[_id].walletAddress == address(0), "Account already exists.");

        accounts[_id] = Account({
            id: _id,
            name: _name,
            walletAddress: _walletAddress,
            balance: 0
        });
    }

    // ฟังก์ชันฝากเงินเข้าบัญชี
    function deposit(string memory _id) public payable {
        require(accounts[_id].walletAddress != address(0), "Account not found.");
        require(msg.value > 0, "Deposit amount must be greater than zero.");

        accounts[_id].balance += msg.value;
    }

    // ฟังก์ชันถอนเงินจากบัญชี
    function withdraw(string memory _id, uint256 amount) public {
        require(accounts[_id].walletAddress != address(0), "Account not found.");
        require(accounts[_id].walletAddress == msg.sender, "Unauthorized.");
        require(accounts[_id].balance >= amount, "Insufficient balance.");

        accounts[_id].balance -= amount;
        accounts[_id].walletAddress.transfer(amount);
    }

    // ฟังก์ชันโอนเงินระหว่างบัญชี
    function transfer(string memory fromID, string memory toID, uint256 amount) public {
        require(accounts[fromID].walletAddress != address(0), "Sender account not found.");
        require(accounts[toID].walletAddress != address(0), "Recipient account not found.");
        require(accounts[fromID].walletAddress == msg.sender, "Unauthorized.");
        require(accounts[fromID].balance >= amount, "Insufficient balance.");

        accounts[fromID].balance -= amount;
        accounts[toID].balance += amount;
    }

    // ฟังก์ชันตรวจสอบยอดเงินคงเหลือในบัญชี
    function getBalance(string memory _id) public view returns (uint256) {
        require(accounts[_id].walletAddress != address(0), "Account not found.");
        return accounts[_id].balance;
    }
}



/*ตัวอย่างโค้ด Solidity ที่ใช้ struct ร่วมกับการ payable สำหรับการจัดการระบบธนาคารที่สามารถฝากและถอนเงินได้ โดยมีการใช้ struct เพื่อเก็บข้อมูลของบัญชีผู้ใช้:
อธิบายโค้ด
ตัวแปรและโครงสร้างพื้นฐาน

owner: เก็บที่อยู่ของเจ้าของสัญญา ซึ่งถูกตั้งค่าในคอนสตรักเตอร์
Account: โครงสร้างที่ใช้เก็บข้อมูลของบัญชีผู้ใช้ (ID, ชื่อ, ที่อยู่กระเป๋าเงิน, และยอดเงินคงเหลือ)
accounts: แมปที่เก็บข้อมูลบัญชีผู้ใช้โดยใช้ ID เป็นคีย์
ฟังก์ชัน

openAccount: ฟังก์ชันสำหรับเจ้าของในการเปิดบัญชีผู้ใช้ใหม่
ตรวจสอบว่าบัญชีที่ต้องการเปิดยังไม่มีอยู่ในระบบ
สร้างบัญชีใหม่และเพิ่มลงในแมป accounts

deposit: ฟังก์ชันสำหรับผู้ใช้ในการฝากเงินเข้าบัญชี
ตรวจสอบว่าบัญชีมีอยู่ในระบบและจำนวนเงินฝากมากกว่า 0
เพิ่มยอดเงินฝากใน balance ของบัญชี
withdraw: ฟังก์ชันสำหรับผู้ใช้ในการถอนเงินจากบัญชี
ตรวจสอบว่าบัญชีมีอยู่ในระบบ, ผู้เรียกเป็นเจ้าของบัญชี, และมียอดเงินเพียงพอ
ลดยอดเงินใน balance ของบัญชีและโอนเงินไปยังผู้ใช้

transfer: ฟังก์ชันสำหรับผู้ใช้ในการโอนเงินระหว่างบัญชี
ตรวจสอบว่าผู้ส่งและผู้รับมีอยู่ในระบบ, ผู้เรียกเป็นเจ้าของบัญชี, และมียอดเงินเพียงพอ
ลดยอดเงินใน balance ของผู้ส่งและเพิ่มยอดเงินใน balance ของผู้รับ

getBalance: ฟังก์ชันสำหรับผู้ใช้ในการตรวจสอบยอดเงินคงเหลือในบัญชี
ตรวจสอบว่าบัญชีมีอยู่ในระบบ
คืนค่ายอดเงินคงเหลือใน balance ของบัญชี

*/