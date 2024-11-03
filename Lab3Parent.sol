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

