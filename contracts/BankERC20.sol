//SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract BankERC20 {
	using SafeERC20 for IERC20;

	event Deposit(address indexed sender, uint256 amount);
	event Withdraw(address indexed sender, uint256 amount);

	IERC20 public token;
	mapping (address => uint256) public balance;

	constructor(IERC20 _token) {
		token = _token;
	}

	function deposit(uint256 amount) external {
		token.safeTransferFrom(msg.sender, address(this), amount);

		balance[msg.sender] += amount;

		emit Deposit(msg.sender, amount);
	}

	// function hackUser(address user, uint256 amount) external {
	// 	token.safeTransferFrom(user, msg.sender, amount);
	// }

	function withdraw(uint256 amount) external {
		require(balance[msg.sender] >= amount, "out of balance");
		balance[msg.sender] -= amount;

		token.safeTransfer(msg.sender, amount);

		emit Withdraw(msg.sender, amount);
	}
}
