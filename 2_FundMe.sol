// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FundMe {
    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == i_owner, "Not owner!");
        _;
    }

    function withdraw() public onlyOwner {
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }
}