//SPDX-License-Identifier: MIT;
pragma solidity ^0.8.0;

contract lab2{

struct Profile {
    string id;
    string name;
    string surname;
    string adress;
    string postcode;
}

mapping (string => Profile) public search;


function listProfile(
    string memory _id, 
    string memory _name,
    string memory _surname,
    string memory _adress,
    string memory _postcode) 
    public {
        require(bytes(search[_id].id).length == 0, "ID HAVE DUPICATE");
        search[_id] = Profile(_id, _name, _surname, _adress, _postcode);
    }


}




/*
contract Lab2 {
    // Mapping to store profiles by their ID
    mapping(string => Profile) public profiles;
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
        require(bytes(profiles[_id].id).length == 0, "Profile already exists with this ID.");
        // Create and store the new profile
        profiles[_id] = Profile(_id, _firstName, _surName, _houseNumber, _streetName, _city, _postCode);
    }
}
*/