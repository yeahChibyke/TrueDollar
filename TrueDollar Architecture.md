## TrueDollar Architecture

- **Relative Stability**: Pegged to the USD
  - Chainlink Pricefeed
  - Set function to swap ETH and BTC for $ equivalent
- **Stability Method**: Algorithmic
  - People can only mint stablecoin with adequate collateral (hard-coded)
- **Collateral Type**: Exogenous (Crypto-collaterized)
  - wETH (wrapped ETH)
  - wBTC (wrapped BTC)

// Layout of Contract:
  // version  
  // imports  
  // interfaces, libraries, contracts  
  // errors  
  // Type declarations  
  // State variables  
  // Events  
  // Modifiers  
  // Functions  

// Layout of Functions:
  // constructor  
  // receive function (if exists)  
  // fallback function (if exists)  
  // external  
  // public  
  // internal  
  // private  
  // view & pure functions

