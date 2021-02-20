// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ValuelessToken is ERC20 {

    constructor() ERC20("Valueless Token", "VLT") {
        // set total supply 30,000 
        _mint(msg.sender, 30000 ether);
    }
}
