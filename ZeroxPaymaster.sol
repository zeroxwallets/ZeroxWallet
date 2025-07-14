// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ZeroxPaymaster {
    address public sponsor;

    constructor() {
        sponsor = msg.sender;
    }

    function getSponsor() public view returns (address) {
        return sponsor;
    }
}
