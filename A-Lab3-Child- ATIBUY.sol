// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./A-Lab3-Parent- ATIBUY.sol"; // เปลี่ยนชื่อไฟล์ตามจริง

contract StorageFactor {

    Hostpital[] public SimpleStorageArray;

    function CreateHostpital() public {
        Hostpital SimpleStorage_Child = new Hostpital();
        SimpleStorageArray.push(SimpleStorage_Child);
    }
    
    function SFStore(
        uint256 _SimpleStorageIndex,
        uint256 _Id,
        string memory _FirstName,
        string memory _Surname,
        string memory _Address,
        string memory _Occupation,
        string memory _TelephoneNumber,
        string memory _Email,
        string memory _Symptoms,
        string memory _DrugAllergies,
        string memory _DoctorName
    ) public {
        Hostpital SimpleStorageAddress = Hostpital(address(SimpleStorageArray[_SimpleStorageIndex]));
        SimpleStorageAddress.Store(
            _Id,
            _FirstName,
            _Surname,
            _Address,
            _Occupation,
            _TelephoneNumber,
            _Email,
            _Symptoms,
            _DrugAllergies,
            _DoctorName
        );
    } 

    function SFRetrieve(uint256 _SimpleStorageIndex, uint _Id) public view returns (
        uint256,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory
       ) {
        Hostpital SimpleStorageAddress = Hostpital(address(SimpleStorageArray[_SimpleStorageIndex]));
        return SimpleStorageAddress.retrieve(_Id);
    }
}





/*
import "./A-Lab3-Parent- ATIBUY.sol"; // เปลี่ยนชื่อไฟล์ตามจริง
นำเข้าสัญญา Hostpital จากไฟล์ A-Lab3-Parent-ATIBUY.sol (คุณอาจต้องเปลี่ยนชื่อไฟล์ตามจริงที่คุณใช้งาน)


contract StorageFactor {
ประกาศสัญญา (contract) ชื่อ StorageFactor


    Hostpital[] public SimpleStorageArray;
ประกาศตัวแปร SimpleStorageArray ซึ่งเป็นอาร์เรย์ที่เก็บที่อยู่ของสัญญา Hostpital และตั้งให้ตัวแปรนี้เป็น public เพื่อให้สามารถเข้าถึงได้จากภายนอกสัญญา


    function CreateHostpital() public {
        Hostpital SimpleStorage_Child = new Hostpital();
        SimpleStorageArray.push(SimpleStorage_Child);
    }
ฟังก์ชัน CreateHostpital ทำการสร้างสัญญา Hostpital ใหม่ และเก็บที่อยู่ของมันในอาร์เรย์ SimpleStorageArray


    function SFStore(
        uint256 _SimpleStorageIndex,
        uint256 _Id,
        string memory _FirstName,
        string memory _Surname,
        string memory _Address,
        string memory _Occupation,
        string memory _TelephoneNumber,
        string memory _Email,
        string memory _Symptoms,
        string memory _DrugAllergies,
        string memory _DoctorName
    ) public {
ฟังก์ชัน SFStore รับพารามิเตอร์หลายตัว รวมถึง _SimpleStorageIndex ซึ่งเป็นดัชนีของอาร์เรย์ SimpleStorageArray ที่จะเลือกใช้สัญญา Hostpital และข้อมูลผู้ป่วยหลายประเภท


        Hostpital SimpleStorageAddress = Hostpital(address(SimpleStorageArray[_SimpleStorageIndex]));
แปลงที่อยู่ในอาร์เรย์ SimpleStorageArray ที่ตำแหน่ง _SimpleStorageIndex เป็นตัวแปร Hostpital


        SimpleStorageAddress.Store(
            _Id,
            _FirstName,
            _Surname,
            _Address,
            _Occupation,
            _TelephoneNumber,
            _Email,
            _Symptoms,
            _DrugAllergies,
            _DoctorName
        );
    }
เรียกใช้ฟังก์ชัน Store ของสัญญา Hostpital ที่เลือก โดยส่งผ่านข้อมูลผู้ป่วยต่างๆ ที่ได้รับจากพารามิเตอร์


    function SFRetrieve(uint256 _SimpleStorageIndex, uint _Id) public view returns (
        uint256,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory,
        string memory
       ) {
ฟังก์ชัน SFRetrieve รับพารามิเตอร์ _SimpleStorageIndex และ _Id และคืนค่าข้อมูลผู้ป่วยที่มี _Id ที่ตรงกันจากสัญญา Hostpital ที่ตำแหน่ง _SimpleStorageIndex ในอาร์เรย์ SimpleStorageArray


        Hostpital SimpleStorageAddress = Hostpital(address(SimpleStorageArray[_SimpleStorageIndex]));
แปลงที่อยู่ในอาร์เรย์ SimpleStorageArray ที่ตำแหน่ง _SimpleStorageIndex เป็นตัวแปร Hostpital


        return SimpleStorageAddress.retrieve(_Id);
    }
}
เรียกใช้ฟังก์ชัน retrieve ของสัญญา Hostpital ที่เลือก และคืนค่าข้อมูลผู้ป่วยที่มี _Id ที่ตรงกัน

สรุป: โค้ดนี้เป็นสัญญา (contract) ในภาษา Solidity ที่ใช้สร้างและจัดการสัญญาย่อย (child contracts) ที่ชื่อว่า Hostpital โดยใช้ StorageFactor เป็นตัวกลางในการสร้าง 
จัดเก็บ และดึงข้อมูลจากสัญญาย่อยเหล่านั้น.

*/