// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; // Deploy 0.8.7 

contract LotteryProject {
    // State Variables
    address payable public admin;                               
    address payable[] public players;                           
    mapping(address => uint) public ticketsBought;              
    mapping(address => uint) public winnings; 
    uint private _roundsPlayed;                                 
    mapping(uint => address payable[]) private _winnersByRound;

    // Struct แอดมิน INFO ให้กรอก ตอน DEPLOY
    struct AdminInfo {
        string name;
        string agency;
        string addressLocation;
        address addressWallet;
        string detailLottery;
    }

    AdminInfo public adminInfo;

    // Events ไว้บันทึกเหตุการณ์ที่เกิดขึ้นต่างๆ
    event LotteryBought(address indexed player, uint timestamp);
    event WinnerSelected(address payable[] winners, uint timestamp);

    constructor(string memory _name, string memory _agency, string memory _addressLocation, string memory _detailLottery) {
        admin = payable(msg.sender);
        
        adminInfo = AdminInfo({
            name: _name,
            agency: _agency,
            addressLocation: _addressLocation,
            addressWallet: msg.sender,
            detailLottery: _detailLottery
        });
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only the admin can call this function.");
        _;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance ;
    }

    function buyLottery() public payable {
        require(msg.value == 1 ether, "Please buy lottery 1 ETH only");
        require(ticketsBought[msg.sender] < 3, "Cannot buy more than 3 tickets per person");
        
        players.push(payable(msg.sender));
        ticketsBought[msg.sender] += 1;
        
        emit LotteryBought(msg.sender, block.timestamp);
    }

    function getLength() public view returns (uint) {
        return players.length;
    }

    function randomNumber() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function randomWinners() public onlyAdmin {
        require(getLength() >= 5, "At least 5 players required.");

        uint prizePool = getBalance();

        uint prize1Amount = (prizePool * 60) / 100;
        uint prize2Amount = (prizePool * 30) / 100;
        uint prize3Amount = prizePool - prize1Amount - prize2Amount;

        address payable[] memory winners = new address payable[](3);

        for (uint i = 0; i < 3; i++) {
            uint pickRandom = randomNumber();
            uint selectIndex = pickRandom % players.length;
            address payable winner = players[selectIndex];
            uint prizeAmount;

            if (i == 0) {
                prizeAmount = prize1Amount;
            } else if (i == 1) {
                prizeAmount = prize2Amount;
            } else {
                prizeAmount = prize3Amount;
            }

            uint fee = (prizeAmount * 5) / 1000;
            prizeAmount -= fee;

            winnings[winner] += prizeAmount;

            winners[i] = winner;

            _winnersByRound[_roundsPlayed].push(winner);

            players[selectIndex] = players[players.length - 1];
            players.pop();
        }

        uint adminFee = (prizePool * 5) / 1000;
        admin.transfer(adminFee);

        emit WinnerSelected(winners, block.timestamp);

        resetLottery();
    }

    function resetLottery() private {
        for (uint i = 0; i < players.length; i++) {
            delete ticketsBought[players[i]];
        }
        players = new address payable[](0) ;

        _roundsPlayed++;
    }

    function getRoundsPlayed() public view returns (uint) {
        return _roundsPlayed;
    }

    function getWinnersByRound(uint round) public view returns (address payable[] memory) {
        uint index = round - 1;
        return _winnersByRound[index];
    }

    function withdrawWinnings() public payable  {
        uint amount = winnings[msg.sender];
        require(amount > 0, "No winnings to withdraw");
        winnings[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}
