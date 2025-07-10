// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@account-abstraction/contracts/interfaces/IEntryPoint.sol";
import "@account-abstraction/contracts/interfaces/IPaymaster.sol";
import "@account-abstraction/contracts/interfaces/UserOperation.sol";

/**
 * @title SimplePaymaster
 * @notice Pays gas fees on behalf of users (gasless onboarding)
 */
contract SimplePaymaster is IPaymaster {
    IEntryPoint public immutable entryPoint;
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(IEntryPoint _entryPoint) {
        entryPoint = _entryPoint;
        owner = msg.sender;
    }

    // Called by EntryPoint to validate sponsorship
    function validatePaymasterUserOp(
        UserOperation calldata userOp,
        bytes32,
        uint256 maxCost
    ) external override returns (bytes memory context, uint256 validationData) {
        require(msg.sender == address(entryPoint), "Invalid caller");
        
        // Example check: only allow specific sender
        require(userOp.sender != address(0), "Invalid sender");

        // You can add Reclaim identity verification check here

        // Allow gas sponsorship
        return ("", 0);
    }

    // Called by EntryPoint to pay post operation gas cost
    function postOp(PostOpMode, bytes calldata, uint256 actualGasCost, bytes calldata) external override {
        require(msg.sender == address(entryPoint), "Only entryPoint");

        // Reimburse gas to EntryPoint
        (bool success, ) = payable(msg.sender).call{value: actualGasCost}("");
        require(success, "Reimbursement failed");
    }

    // Fund this contract with ETH to pay gas
    receive() external payable {}

    // Withdraw by owner
    function withdraw(address payable to, uint256 amount) external onlyOwner {
        require(address(this).balance >= amount, "Not enough balance");
        to.transfer(amount);
    }
}
