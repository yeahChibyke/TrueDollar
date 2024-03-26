// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title TrueDollar
 * @author yeahChibyke
 * Collateral: Crypto-collaterized
 * Minting: Algorithmic
 * Relative Stability: Anchored to the USD
 * @notice This contract is just the ERC20 implementation of the TrueDollar stablecoin. It will be governed by the TrueEngine.
 */

contract TrueDollar is ERC20, ERC20Burnable, Ownable {
    /* Errors */

    error TrueDollar__MustBeMoreThanZero();
    error TrueDollar__BurnAmountMoreThanBalance();
    error TrueDollar__AddressNotValid();

    /* Constructor */

    constructor(
        address TrueOwner
    ) ERC20("TrueDollar", "TD$") Ownable(TrueOwner) {}

    /* Functions */

    function burn(uint256 _amount) public override onlyOwner {
        uint256 balance = balanceOf(msg.sender);
        if (_amount <= 0) {
            revert TrueDollar__MustBeMoreThanZero();
        }
        if (_amount > balance) {
            revert TrueDollar__BurnAmountMoreThanBalance();
        }
        super.burn(_amount);
    }

    function mint(
        address _to,
        uint256 _amount
    ) external onlyOwner returns (bool) {
        if (_to == address(0)) {
            revert TrueDollar__AddressNotValid();
        }
        if (_amount <= 0) {
            revert TrueDollar__MustBeMoreThanZero();
        }
        _mint(_to, _amount);
        return true;
    }
}
