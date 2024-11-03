// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Lab3Parent.sol"; // เปลี่ยนชื่อไฟล์ตามจริง

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

