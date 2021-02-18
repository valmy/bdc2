// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./vlt.sol";

contract VLTICO {
    address public owner;
    ValuelessToken vlt;
    uint256 minimumPurchase;
    uint256 pricePerToken;
    
    constructor(uint256 _minimumPurchase, uint256 _pricePerToken, address tokenAddr) {
        owner = msg.sender;
        vlt = ValuelessToken(tokenAddr);
        minimumPurchase = _minimumPurchase;
        pricePerToken = _pricePerToken;
    }
    
    // eg: 1 VLT = 0.001 ETH, send 0.5 ETH => buy 500 ICO (= 500 * 10 ** decimal in 'wei')
    modifier minimumCheck() {
        require(msg.value * 10 ** vlt.decimals() / pricePerToken > minimumPurchase, "Below minimum purchase");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can invoke this");
        _;
    }
    
    // BuyToken 
    function buyToken() public payable minimumCheck {
        require(msg.sender != owner, "Owner cannot buy");

        // tokenAmount in 'wei'
        uint tokenAmount = msg.value * 10 ** vlt.decimals() / pricePerToken;
        
        require(vlt.balanceOf(owner) >= tokenAmount, "Out of stock");
        
        vlt.transferFrom(owner, msg.sender, tokenAmount);
    }
    
    // change price
    function changePricePerToken(uint newPrice) public onlyOwner {
        pricePerToken = newPrice;
    }

    // send all ether to owner
    function sendFund() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    // get user balance    
    function getBalance() public view returns(uint){
        return vlt.balanceOf(msg.sender);
    }
    
    // get token balance in the contract
    function getTokenBalance() public view returns(uint) {
        return vlt.balanceOf(owner);
    }
    
    // get ether balance
    function getEtherBalance() public view returns(uint) {
        return address(this).balance;
    }
}