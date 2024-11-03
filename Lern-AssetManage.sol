// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract AssetManagement {
    struct Asset {
        uint256 assetId;
        string assetName;
        string description;
        bool isActive;
    }

    struct Maintenance {
        uint256 date;
        string description;
    }

    address public owner;
    uint256 public assetCount = 0;

    mapping(uint256 => Asset) public assets;
    mapping(uint256 => Maintenance[]) public assetMaintenanceHistory;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Function to add a new asset
    function addAsset(string memory name, string memory description) public onlyOwner {
        assetCount += 1;
        assets[assetCount] = Asset(assetCount, name, description, true);
    }

    // Function to deactivate an asset
    function deactivateAsset(uint256 assetId) public onlyOwner {
        require(assets[assetId].isActive, "Asset already inactive");
        assets[assetId].isActive = false;
    }

    // Function to record maintenance
    function recordMaintenance(uint256 assetId, uint256 date, string memory description) public onlyOwner {
        require(assets[assetId].isActive, "Asset is inactive");
        assetMaintenanceHistory[assetId].push(Maintenance(date, description));
    }

    // Function to retrieve asset details
    function getAssetDetails(uint256 assetId) public view returns (Asset memory) {
        return assets[assetId];
    }

    // Function to get maintenance history of an asset
    function getMaintenanceHistory(uint256 assetId) public view returns (Maintenance[] memory) {
        return assetMaintenanceHistory[assetId];
    }
}

/* 2. ระบบจัดการทรัพย์สินในบริษัท
พัฒนาสัญญาอัจฉริยะสำหรับการตรวจสอบและจัดการทรัพย์สินภายในบริษัท:

บันทึกการเข้ามาและออกของทรัพย์สิน
บันทึกการซ่อมแซมและการบำรุงรักษา
รายงานสถานะของทรัพย์สิน

คำอธิบายโค้ด:
Structs: มีสอง structs คือ Asset สำหรับจัดเก็บรายละเอียดทรัพย์สิน และ Maintenance สำหรับจัดเก็บประวัติการบำรุงรักษา.
Mappings: ใช้สำหรับการเก็บข้อมูลของทรัพย์สินและประวัติการบำรุงรักษาแยกตาม ID ของทรัพย์สิน.
Functions:
addAsset: เพิ่มทรัพย์สินใหม่.
deactivateAsset: ทำให้ทรัพย์สินเป็นสถานะไม่ใช้งาน.
recordMaintenance: บันทึกการบำรุงรักษาทรัพย์สิน.
getAssetDetails และ getMaintenanceHistory: ดึงข้อมูลทรัพย์สินและประวัติการบำรุงรักษา.
*/