// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


struct Issue{
     bool open; //_ไม่ใช้เพราะเป็น member ตัว stuct
    mapping(address => bool) voted;
    mapping (address => uint) ballots; //บัตรเลือกตั้ง
    uint[] scores;
} 


contract Election {
    address _admin;
    mapping(uint => Issue) _issues;
    uint _issueId;
    uint _min;
    uint _max;

    event StatusChange(uint indexed  issueID, bool open);
    event Vote(uint indexed _issueId, address voter, uint indexed option);


    constructor(uint min, uint max){
        _admin = msg.sender;
        _min = min;
        _max = max;
    }

    modifier onlyAdmin{
        require(msg.sender == _admin, "unauthorized");
        _; //nextถัดไป ให้ code run ต่อ
    }

    function open () public onlyAdmin{
        require(!_issues[_issueId].open, "Election Opening");
        
        _issueId++;
        _issues[_issueId].open = true;
        _issues[_issueId].scores = new uint[](_max+1);
        emit StatusChange(_issueId, true);
    }
    
    function close() public onlyAdmin {
        require(_issues[_issueId].open, "Election Closed");

        _issues[_issueId].open = false;
        emit StatusChange(_issueId, false);
    }
    
    function vote(uint option) public {
        require(_issues[_issueId].open, "Election Closed");
        require(!_issues[_issueId].voted[msg.sender] , "you're voted" );
        require(option >= _min && option <= _max, "incorrect option");

        _issues[_issueId].scores[option]++;
        _issues[_issueId].voted[msg.sender] = true;
        _issues[_issueId].ballots[msg.sender] = option;
        emit  Vote(_issueId, msg.sender, option);
    }

    function status() public view returns(bool open_){
        return _issues[_issueId].open;

    }

    function ballot() public view returns(uint option) {
        require(_issues[_issueId].voted[msg.sender], "you are not voted");

        return _issues[_issueId].ballots[msg.sender];
    }
    
    function scores() public view returns(uint[] memory){
        return  _issues[_issueId].scores;
    }

}