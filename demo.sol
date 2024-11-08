// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract GetEthPrice {
    AggregatorV3Interface priceFeed;

    constructor() {
        // Sepolia ETH / USD Address
        // https://docs.chain.link/data-feeds/price-feeds/addresses
        priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
    }

    // get ETH/USD price
    function getPrice() public view returns (uint256) {
        (, int256 answer, , uint256 updatedAt, ) = priceFeed.latestRoundData();
        
        // Check price stale
        require(!isPriceStale(updatedAt), "Price data is stale.");
        
        return uint256(answer);
    }

    function isPriceStale(uint256 updatedAt) public view returns (bool) {
        // Set time threshold to 1 hour
        uint256 staleTime = 1 hours;
        return (block.timestamp - updatedAt) > staleTime;
    }

    function getDecimals() public view returns (uint8) {
        return priceFeed.decimals();
    }

    // the actual ETH/USD conversion rate, after adjusting the extra 0s.
    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 10 ** priceFeed.decimals();
        return ethAmountInUsd;
    }
}
