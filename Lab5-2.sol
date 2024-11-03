// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

contract LoyaltyProgram {
mapping(address => uint8) public points;

function reward(address user, uint8 pointsToAdd) public {
    require(points[user] + pointsToAdd >=  255 ,"over flow");
    //require(pointsToAdd + points[user] >= points[user] ,"over flow");
    points[user] = points[user] += pointsToAdd;
}

}