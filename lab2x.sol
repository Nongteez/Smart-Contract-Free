// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lab2 {
    struct Profile {
        string id;
        string name;
        string surname;
        string adddress;
        string postcode;
    }

    mapping (string => Profile) public search;

    function listProfile(
        string memory _id, 
        string memory _name,
        string memory _surname,
        string memory _adddress,
        string memory _postcode
    ) public {
        require(bytes(search[_id].id).length == 0, "ID HAVE DUPLICATE");
        search[_id] = Profile(_id, _name, _surname, _adddress, _postcode);
    }

    function isProfileExist(string memory _id) public view returns (bool) {
        return bytes(search[_id].id).length > 0;
    }

    function getProfile(string memory _id) public view returns (string memory, string memory, string memory, string memory, string memory) {
        require(isProfileExist(_id), "INVALID");
        Profile memory profile = search[_id];
        return (profile.id, profile.name, profile.surname, profile.adddress, profile.postcode);
    }
}
