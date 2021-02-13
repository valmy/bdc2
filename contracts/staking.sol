// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract Staking {
    
    uint public rate;
    address public owner;
    mapping(address => uint) public balances;
    mapping(address => uint) public counter;
    
    // rate = increment percentage (0 - 100)
    constructor(uint _rate) {
        owner = msg.sender;
        rate = _rate;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Only owner can invoke this");
        _;
    }

    function addFund() public payable onlyOwner {
        // contains unclaimed balances;
        balances[address(this)] += msg.value;
    }
    
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // increment counter
    function increment() public returns (uint) {
        uint increase = balances[msg.sender] * rate / 100;
        require(increase <= balances[address(this)], "Out of reward");
        balances[address(this)] -= increase;
        balances[msg.sender] += increase;
        counter[msg.sender] += 1;
        return counter[msg.sender];
    }

    function withdraw(uint amount) public {
        require(counter[msg.sender] >= 10, "Not enough increments");
        require(balances[msg.sender] >= amount, "Not enough funds");
        payable(msg.sender).transfer(amount);
        balances[msg.sender] -= amount;
    }    

    // get user balance    
    function getBalance() public view returns(uint){
        return balances[msg.sender];
    }

    // get user counter
    function getIncrement() public view returns(uint) {
        return counter[msg.sender];
    }

    // get reward balance
    function getRewardBalance() public view returns(uint) {
        return balances[address(this)];
    }
    
    // send all ether to owner
    function sendFund() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    function destroyContract() public payable onlyOwner{
        selfdestruct(payable(owner));
    }


}
