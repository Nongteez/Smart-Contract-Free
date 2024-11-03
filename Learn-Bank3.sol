// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract BankSystem {
    address private owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    // โครงสร้างข้อมูลของผู้ใช้
    struct User {
        string id;
        string firstName;
        string lastName;
        address walletAddress;
        uint256 balance;
    }

    // เก็บข้อมูลผู้ใช้ทั้งหมดในอาร์เรย์
    User[] private users;

    // แมปข้อมูลผู้ใช้จาก id
    mapping(string => User) public userSearchByID;

    // แมปข้อมูลผู้ใช้จากที่อยู่กระเป๋าเงิน
    mapping(address => User) public userSearchByAddress;

    // ฟังก์ชันเปิดบัญชีผู้ใช้ใหม่
    function createAccount(
        string memory _id,
        string memory _firstName,
        string memory _lastName,
        address _walletAddress
    ) public onlyOwner {
        require(bytes(userSearchByID[_id].id).length == 0, "User already exists.");
        require(userSearchByAddress[_walletAddress].walletAddress == address(0), "Wallet address already in use.");

        User memory newUser = User({
            id: _id,
            firstName: _firstName,
            lastName: _lastName,
            walletAddress: _walletAddress,
            balance: 0
        });

        users.push(newUser);
        userSearchByID[_id] = newUser;
        userSearchByAddress[_walletAddress] = newUser;
    }

    // ฟังก์ชันฝากเงินเข้าบัญชี
    function deposit(string memory id) public payable {
        require(bytes(userSearchByID[id].id).length > 0, "User not found.");
        require(msg.value > 0, "Deposit amount must be greater than zero.");

        userSearchByID[id].balance += msg.value;
    }

    // ฟังก์ชันถอนเงินจากบัญชี
    function withdraw(string memory id, uint256 amount) public {
        require(bytes(userSearchByID[id].id).length > 0, "User not found.");
        require(userSearchByID[id].walletAddress == msg.sender, "Unauthorized.");
        require(userSearchByID[id].balance >= amount, "Insufficient balance.");

        userSearchByID[id].balance -= amount;
        payable(msg.sender).transfer(amount);
    }

    // ฟังก์ชันโอนเงินระหว่างผู้ใช้
    function transfer(string memory fromID, string memory toID, uint256 amount) public {
        require(bytes(userSearchByID[fromID].id).length > 0, "Sender not found.");
        require(bytes(userSearchByID[toID].id).length > 0, "Recipient not found.");
        require(userSearchByID[fromID].walletAddress == msg.sender, "Unauthorized.");
        require(userSearchByID[fromID].balance >= amount, "Insufficient balance.");

        userSearchByID[fromID].balance -= amount;
        userSearchByID[toID].balance += amount;
    }

    // ฟังก์ชันตรวจสอบยอดเงินคงเหลือในบัญชี
    function getBalance(string memory id) public view returns (uint256) {
        require(bytes(userSearchByID[id].id).length > 0, "User not found.");
        return userSearchByID[id].balance;
    }
}

/*
อธิบายโค้ด
ตัวแปรและโครงสร้างพื้นฐาน

owner: เก็บที่อยู่ของเจ้าของสัญญา ซึ่งถูกตั้งค่าในคอนสตรักเตอร์
users: อาร์เรย์เก็บข้อมูลผู้ใช้ทั้งหมด
userSearchByID และ userSearchByAddress: แมปที่เก็บข้อมูลผู้ใช้โดยใช้ ID และที่อยู่กระเป๋าเงินเป็นคีย์
ฟังก์ชัน

createAccount: ฟังก์ชันสำหรับเจ้าของในการเปิดบัญชีผู้ใช้ใหม่
ตรวจสอบว่า ID และที่อยู่กระเป๋าเงินยังไม่มีในระบบ
เพิ่มข้อมูลผู้ใช้ใหม่ลงในอาร์เรย์และแมป

deposit: ฟังก์ชันสำหรับผู้ใช้ในการฝากเงินเข้าบัญชี
ตรวจสอบว่าผู้ใช้มีอยู่ในระบบและจำนวนเงินฝากมากกว่า 0
เพิ่มยอดเงินฝากใน balance ของผู้ใช้

withdraw: ฟังก์ชันสำหรับผู้ใช้ในการถอนเงินจากบัญชี
ตรวจสอบว่าผู้ใช้มีอยู่ในระบบ, ผู้เรียกเป็นเจ้าของบัญชี, และมียอดเงินเพียงพอ
ลดยอดเงินใน balance ของผู้ใช้และโอนเงินไปยังผู้ใช้

transfer: ฟังก์ชันสำหรับผู้ใช้ในการโอนเงินระหว่างกัน
ตรวจสอบว่าผู้ส่งและผู้รับมีอยู่ในระบบ, ผู้เรียกเป็นเจ้าของบัญชี, และมียอดเงินเพียงพอ
ลดยอดเงินใน balance ของผู้ส่งและเพิ่มยอดเงินใน balance ของผู้รับ
getBalance: ฟังก์ชันสำหรับผู้ใช้ในการตรวจสอบยอดเงินคงเหลือในบัญชี
ตรวจสอบว่าผู้ใช้มีอยู่ในระบบ
คืนค่ายอดเงินคงเหลือใน balance ของผู้ใช้
*/