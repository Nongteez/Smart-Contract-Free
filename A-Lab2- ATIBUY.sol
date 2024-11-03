// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lab2 {

    // Mapping to store profiles by their ID
    mapping(string => Profile) public SearchProfile;  //ประกาศ Mapping

    // Struct for storing detailed profile information
    // Struct Profile เก็บข้อมูลส่วนตัวต่างๆ
    struct Profile {
        string id;
        string firstName;
        string surName;
        string houseNumber;
        string streetName;
        string city;
        string postCode;
    }

    // Fuction ListProfile ทำให้เก็บค่าจากผู้ใช้้ _ นำหน้าคือ Private
    // Function to list a new profile with unique ID 
    function listProfile(
        string memory _id,
        string memory _firstName, 
        string memory _surName, 
        string memory _houseNumber,
        string memory _streetName,
        string memory _city,
        string memory _postCode
    ) public {
        // Check if profile already exists to avoid overwriting and ensure uniqueness
        require(bytes(SearchProfile[_id].id).length == 0, "NO ID SUT NAJA");
        // Create and store the new profile
        SearchProfile[_id] = Profile(_id, _firstName, _surName, _houseNumber, _streetName, _city, _postCode);
    }


}



/*
contract Lab2 {
ประกาศสัญญา (contract) ชื่อว่า Lab2

    // Mapping to store profiles by their ID
    mapping(string => Profile) public SearchProfile;
ประกาศตัวแปร SearchProfile ซึ่งเป็น mapping โดยใช้ string เป็นกุญแจและเก็บค่าประเภท Profile และตั้งให้ตัวแปรนี้เป็น public เพื่อให้สามารถเข้าถึงได้จากภายนอกสัญญา


    // Struct for storing detailed profile information
    struct Profile {
        string id;
        string firstName;
        string surName;
        string houseNumber;
        string streetName;
        string city;
        string postCode;
    }
ประกาศโครงสร้างข้อมูล (struct) ชื่อ Profile ซึ่งประกอบด้วยข้อมูลส่วนตัวต่างๆ เช่น id, firstName, surName, houseNumber, streetName, city, และ postCode


    // Function to list a new profile with unique ID 
    function listProfile(
        string memory _id,
        string memory _firstName, 
        string memory _surName, 
        string memory _houseNumber,
        string memory _streetName,
        string memory _city,
        string memory _postCode
    ) public {
ประกาศฟังก์ชัน listProfile ซึ่งมีการรับค่าพารามิเตอร์เป็นข้อมูลส่วนตัวต่างๆ (_id, _firstName, _surName, _houseNumber, _streetName, _city, _postCode) ทั้งหมดเป็นประเภท 
string และมีการกำหนดขอบเขตเป็น public เพื่อให้สามารถเรียกใช้งานได้จากภายนอกสัญญา


        // Check if profile already exists to avoid overwriting and ensure uniqueness
        require(bytes(SearchProfile[_id].id).length == 0, "NO ID SUT NAJA");
ตรวจสอบว่ามีโปรไฟล์ที่มี _id นี้อยู่แล้วหรือไม่ โดยการเช็คว่าความยาวของ id ที่อยู่ใน SearchProfile เป็น 0 หรือไม่ ถ้ามีค่าความยาวไม่เป็น 0 จะแสดงข้อความว่า "NO ID SUT NAJA" และไม่ทำการเพิ่มโปรไฟล์ใหม่


        // Create and store the new profile
        SearchProfile[_id] = Profile(_id, _firstName, _surName, _houseNumber, _streetName, _city, _postCode);
    }
}
สร้างและเก็บโปรไฟล์ใหม่ใน SearchProfile โดยใช้ _id เป็นกุญแจ และกำหนดค่าให้ Profile ตามพารามิเตอร์ที่ได้รับมา


สรุป: โค้ดนี้เป็นสัญญา (contract) ในภาษา Solidity ที่ใช้เก็บข้อมูลส่วนตัวของผู้ใช้โดยใช้ id เป็นกุญแจในการเข้าถึงข้อมูลใน mapping ที่ชื่อ SearchProfile 
และมีฟังก์ชัน listProfile สำหรับเพิ่มโปรไฟล์ใหม่โดยต้องตรวจสอบว่า id นั้นยังไม่มีการใช้งานก่อนที่จะเพิ่มข้อมูลใหม่เข้าไป
*/