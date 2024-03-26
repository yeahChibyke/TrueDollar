// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/* Imports */

import {TrueDollar} from "./TrueDollar.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

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
contract TrueEngine is ReentrancyGuard {
    /* Errors */

    error TrueEngine__MustBeMoreThanZero();
    error TrueEngine__AddressesLengthMismatch();
    error TrueEngine__TokenNotAllowed();
    error TrueEngine__TransferFailed();

    /* State Variables */

    mapping(address token => address priceFeed) private s_priceFeeds;
    mapping(address user => mapping(address token => uint256 amount)) private s_collateralDeposited;

    TrueDollar private immutable i_TD$;

    /* Events */

    event CollateralDeposited(address indexed user, address indexed token, uint256 indexed amount);

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

    constructor(address[] memory tokenAddresses, address[] memory priceFeedAddresses, address trueDolllarAddress) {
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
     * @notice follows CEI pattern
     * @dev Allows users to deposit collateral tokens into the contract.
     * @param tokenCollateralAddress The address of the token being deposited as collateral.
     * @param amountCollateral The amount of the token being deposited as collateral.
     */
    function depositCollateral(address tokenCollateralAddress, uint256 amountCollateral)
        external
        moreThanZero(amountCollateral)
        isAllowedToken(tokenCollateralAddress)
        nonReentrant
    {
        s_collateralDeposited[msg.sender][tokenCollateralAddress] += amountCollateral;
        emit CollateralDeposited(msg.sender, tokenCollateralAddress, amountCollateral);
        bool Success = IERC20(tokenCollateralAddress).transferFrom(msg.sender, address(this), amountCollateral);
        if (!Success) {
            revert TrueEngine__TransferFailed();
        }
    }

    function redeemCollateral() external {}

    function mintTD$() external {}

    function burnTD$() external {}

    function liquidate() external {}

    function getHealthFactor() external view {}
}
