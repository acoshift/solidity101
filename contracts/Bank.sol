//SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Bank is ReentrancyGuard {
	// private, internal, external, public

	mapping (address => uint256) public balance;

	// user
	// => contract A (tx.origin == msg.sender == user)
	// => contract B (tx.origin == user, msg.sender == contract A)

	function deposit() external payable {
		balance[msg.sender] += msg.value;
	}

	function withdraw(uint256 amount) external nonReentrant {
		require(balance[msg.sender] >= amount, "out of balance");
		balance[msg.sender] -= amount;
		payable(msg.sender).transfer(amount);
	}
}

// -----------

interface IBank {
	function deposit() external payable;
	function withdraw(uint256) external;
}

contract Hacker {
	IBank private _bank;
	bool private withdrawed;

	function hack(IBank bank) external payable {
		_bank = bank;
		_bank.deposit{value: msg.value}();
		withdrawed = false;
		_bank.withdraw(msg.value);
	}

	receive() external payable {
		if (withdrawed) {
			return;
		}
		withdrawed = true;
		_bank.withdraw(msg.value);
	}
}
