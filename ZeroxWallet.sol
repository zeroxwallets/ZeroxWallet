// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ZeroxWallet {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function getOwner() public view returns (address) {
        return owner;
    }
}
