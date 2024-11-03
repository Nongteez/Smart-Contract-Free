// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Hostpital {

    struct People {
        uint256 PatientsNationalID;
        string FirstName;
        string SurName;
        string Address;
        string Occupation;
        string TelephoneNumber;
        string Email;
        string Symptoms;
        string DrugAllergies;
        string DoctorsNameOfLastVisite;
    }

    People[] public person;
    mapping(uint256 => People) public persons;

  function Store(
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
        People memory newPerson = People({
            PatientsNationalID: _Id,
            FirstName: _FirstName,
            SurName: _Surname,
            Address: _Address,
            Occupation: _Occupation,
            TelephoneNumber: _TelephoneNumber,
            Email: _Email,
            Symptoms: _Symptoms,
            DrugAllergies: _DrugAllergies,
            DoctorsNameOfLastVisite: _DoctorName
        });

        person.push(newPerson);

    }

    function retrieve(uint256 _Id) public view returns (
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
        People memory p = persons[_Id];
        return (
            p.PatientsNationalID,
            p.FirstName,
            p.SurName,
            p.Address,
            p.Occupation,
            p.TelephoneNumber,
            p.Email,
            p.Symptoms,
            p.DrugAllergies,
            p.DoctorsNameOfLastVisite
        );
    }
}



/*
contract Hostpital {
ประกาศสัญญา (contract) ชื่อว่า Hostpital


    struct People {
        uint256 PatientsNationalID;
        string FirstName;
        string SurName;
        string Address;
        string Occupation;
        string TelephoneNumber;
        string Email;
        string Symptoms;
        string DrugAllergies;
        string DoctorsNameOfLastVisite;
    }
ประกาศโครงสร้างข้อมูล (struct) ชื่อ People ซึ่งประกอบด้วยข้อมูลต่างๆ ของผู้ป่วย 
เช่น PatientsNationalID, FirstName, SurName, Address, Occupation, TelephoneNumber, Email, Symptoms, DrugAllergies, และ DoctorsNameOfLastVisite


    People[] public person;
ประกาศตัวแปร person ซึ่งเป็นอาร์เรย์ของ People และตั้งให้ตัวแปรนี้เป็น public เพื่อให้สามารถเข้าถึงได้จากภายนอกสัญญา


    mapping(uint256 => People) public persons;
ประกาศตัวแปร persons ซึ่งเป็น mapping โดยใช้ uint256 เป็นกุญแจและเก็บค่าประเภท People และตั้งให้ตัวแปรนี้เป็น public เพื่อให้สามารถเข้าถึงได้จากภายนอกสัญญา


  function Store(
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
ประกาศฟังก์ชัน Store ซึ่งมีการรับค่าพารามิเตอร์เป็นข้อมูลส่วนตัวต่างๆ 
(_Id, _FirstName, _Surname, _Address, _Occupation, _TelephoneNumber, _Email, _Symptoms, _DrugAllergies, _DoctorName) 
ทั้งหมดเป็นประเภท string ยกเว้น _Id ที่เป็น uint256 และมีการกำหนดขอบเขตเป็น public เพื่อให้สามารถเรียกใช้งานได้จากภายนอกสัญญา


        People memory newPerson = People({
            PatientsNationalID: _Id,
            FirstName: _FirstName,
            SurName: _Surname,
            Address: _Address,
            Occupation: _Occupation,
            TelephoneNumber: _TelephoneNumber,
            Email: _Email,
            Symptoms: _Symptoms,
            DrugAllergies: _DrugAllergies,
            DoctorsNameOfLastVisite: _DoctorName
        });

        person.push(newPerson);
    }
สร้างและเก็บ People ใหม่ในตัวแปร newPerson โดยใช้ค่าพารามิเตอร์ที่ได้รับ จากนั้นเพิ่ม newPerson ลงในอาร์เรย์ person


    function retrieve(uint256 _Id) public view returns (
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
        People memory p = persons[_Id];
        return (
            p.PatientsNationalID,
            p.FirstName,
            p.SurName,
            p.Address,
            p.Occupation,
            p.TelephoneNumber,
            p.Email,
            p.Symptoms,
            p.DrugAllergies,
            p.DoctorsNameOfLastVisite
        );
    }
}
contract Hostpital {
ประกาศสัญญา (contract) ชื่อว่า Hostpital


    struct People {
        uint256 PatientsNationalID;
        string FirstName;
        string SurName;
        string Address;
        string Occupation;
        string TelephoneNumber;
        string Email;
        string Symptoms;
        string DrugAllergies;
        string DoctorsNameOfLastVisite;
    }
ประกาศโครงสร้างข้อมูล (struct) ชื่อ People ซึ่งประกอบด้วยข้อมูลต่างๆ ของผู้ป่วย 
เช่น PatientsNationalID, FirstName, SurName, Address, Occupation, TelephoneNumber, Email, Symptoms, DrugAllergies, และ DoctorsNameOfLastVisite


    People[] public person;
ประกาศตัวแปร person ซึ่งเป็นอาร์เรย์ของ People และตั้งให้ตัวแปรนี้เป็น public เพื่อให้สามารถเข้าถึงได้จากภายนอกสัญญา


    mapping(uint256 => People) public persons;
ประกาศตัวแปร persons ซึ่งเป็น mapping โดยใช้ uint256 เป็นกุญแจและเก็บค่าประเภท People และตั้งให้ตัวแปรนี้เป็น public เพื่อให้สามารถเข้าถึงได้จากภายนอกสัญญา


  function Store(
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
ประกาศฟังก์ชัน Store ซึ่งมีการรับค่าพารามิเตอร์เป็นข้อมูลส่วนตัวต่างๆ 
(_Id, _FirstName, _Surname, _Address, _Occupation, _TelephoneNumber, _Email, _Symptoms, _DrugAllergies, _DoctorName) 
ทั้งหมดเป็นประเภท string ยกเว้น _Id ที่เป็น uint256 และมีการกำหนดขอบเขตเป็น public เพื่อให้สามารถเรียกใช้งานได้จากภายนอกสัญญา


        People memory newPerson = People({
            PatientsNationalID: _Id,
            FirstName: _FirstName,
            SurName: _Surname,
            Address: _Address,
            Occupation: _Occupation,
            TelephoneNumber: _TelephoneNumber,
            Email: _Email,
            Symptoms: _Symptoms,
            DrugAllergies: _DrugAllergies,
            DoctorsNameOfLastVisite: _DoctorName
        });

        person.push(newPerson);
    }
สร้างและเก็บ People ใหม่ในตัวแปร newPerson โดยใช้ค่าพารามิเตอร์ที่ได้รับ จากนั้นเพิ่ม newPerson ลงในอาร์เรย์ person


    function retrieve(uint256 _Id) public view returns (
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
        People memory p = persons[_Id];
        return (
            p.PatientsNationalID,
            p.FirstName,
            p.SurName,
            p.Address,
            p.Occupation,
            p.TelephoneNumber,
            p.Email,
            p.Symptoms,
            p.DrugAllergies,
            p.DoctorsNameOfLastVisite
        );
    }
}
ฟังก์ชัน retrieve รับพารามิเตอร์ _Id และคืนค่าข้อมูลของผู้ป่วยที่ตรงกับ _Id ที่ได้รับ โดยดึงข้อมูลจาก mapping persons และคืนค่าออกมาเป็นชุดข้อมูลต่างๆ

สรุป: โค้ดนี้เป็นสัญญา (contract) ในภาษา Solidity ที่ใช้เก็บข้อมูลส่วนตัวของผู้ป่วยในโครงสร้างข้อมูล People โดยมีอาร์เรย์ person และ mapping persons 
สำหรับเก็บข้อมูลเหล่านี้ ฟังก์ชัน Store ใช้สำหรับเพิ่มข้อมูลใหม่ และฟังก์ชัน retrieve ใช้สำหรับดึงข้อมูลตาม PatientsNationalID ที่กำหนด
*/

