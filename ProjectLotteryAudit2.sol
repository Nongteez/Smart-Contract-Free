// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LotteryProject {
    // State Variables
    address payable public admin;                               
    address payable[] private players;                           
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

    // Events
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
        return address(this).balance;
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

    function getWinnersByRound(uint round) public view returns (string memory) {
        uint index = round - 1;
        address payable[] memory winners = _winnersByRound[index];
        string memory result = "";
        for (uint i = 0; i < winners.length; i++) {
            result = string(abi.encodePacked(result, "address: ", toAsciiString(winners[i]), ", "));
        }
        return result;
    }

    function toAsciiString(address x) internal pure returns (string memory) {
        bytes memory s = new bytes(42);
        s[0] = '0';
        s[1] = 'x';
        for (uint i = 0; i < 20; i++) {
            bytes1 b = bytes1(uint8(uint(uint160(x)) / (2**(8*(19 - i)))));
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2*i + 2] = char(hi);
            s[2*i + 3] = char(lo);            
        }
        return string(s);
    }

    function char(bytes1 b) internal pure returns (bytes1 c) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
        else return bytes1(uint8(b) + 0x57);
    }

    function withdrawWinnings() public payable {
        uint amount = winnings[msg.sender];
        require(amount > 0, "No winnings to withdraw");
        winnings[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}
