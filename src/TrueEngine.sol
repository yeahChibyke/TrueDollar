// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/* Imports */

import {TrueDollar} from "./TrueDollar.sol";

/**
 * @title TrueEngine
 * @author yeahChibyke
 * The system is designed to be as minimal as possible, and maintain a 1 token == 1 USD peg.
 *
 * TrueDollar is similar to DAI if DAI had no governance, no fees, and was backed by only WETH and WBTC.
 *
 * Our TD$ system should always be "overcollateralized". At no point, should the value of
 * all collateral < the $ backed value of all the TD$.
 *
 * @notice This contract is the core of the TrueDollar Stablecoin system. It handles all the logic
 * for minting and redeeming TD$, as well as depositing and withdrawing collateral.
 *
 * @notice This contract is VERY loosely based on the MakerDA DSS (DAI) system
 */
contract TrueEngine {
    /* Errors */

    error TrueEngine__MustBeMoreThanZero();
    error TrueEngine__AddressesLengthMismatch();
    error TrueEngine__TokenNotAllowed();

    /* State Variables */

    mapping(address token => address priceFeed) private s_priceFeeds;

    TrueDollar private immutable i_TD$;

    /* Modifiers */

    modifier moreThanZero(uint256 value) {
        if (value == 0) {
            revert TrueEngine__MustBeMoreThanZero();
        }
        _;
    }

    modifier isAllowedToken(address token) {
        if (s_priceFeeds[token] == address(0)) {
            revert TrueEngine__TokenNotAllowed();
        }
        _;
    }

    /* Functions */

    constructor(
        address[] memory tokenAddresses,
        address[] memory priceFeedAddresses,
        address trueDolllarAddress
    ) {
        if (tokenAddresses.length != priceFeedAddresses.length) {
            revert TrueEngine__AddressesLengthMismatch();
        }
        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            s_priceFeeds[tokenAddresses[i]] = priceFeedAddresses[i];
        }
        i_TD$ = TrueDollar(trueDolllarAddress);
    }

    /* External Functions */

    function depositCollateralForTD$() external {}

    function redeemCollateralForTD$() external {}

    /**
     * @dev Allows users to deposit collateral tokens into the contract.
     * @param tokenCollateralAddress The address of the token being deposited as collateral.
     * @param amountCollateral The amount of the token being deposited as collateral.
     */
    function depositCollateral(
        address tokenCollateralAddress,
        uint256 amountCollateral
    )
        external
        moreThanZero(amountCollateral)
        isAllowedToken(tokenCollateralAddress)
    {}

    function redeemCollateral() external {}

    function mintTD$() external {}

    function burnTD$() external {}

    function liquidate() external {}

    function getHealthFactor() external view {}
}
