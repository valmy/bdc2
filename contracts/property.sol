// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract Property {
    
    enum PropertyTypes { Apartment, Land }
    enum PropertyStatuses { OnSale, Sold }
    
    struct RealEstate {
        uint256 id;
        PropertyTypes propertyType;
        uint32 area;
        uint256 price;
        string location;
        string propertyAddress;
        string gps;
        address[] interests;
        address seller;
        string photoUrl;
        PropertyStatuses status;
    }
    
    address public owner;
    mapping(address => RealEstate[]) public propertiesBySeller;
    mapping(string => RealEstate[]) public propertiesByLocation;
    
    constructor() {
        owner = msg.sender;
    }
    
    // register new property
    function registerProperty(RealEstate memory realEstate) public {
        realEstate.status = PropertyStatuses.OnSale;
        uint256 id = propertiesBySeller[msg.sender].length;
        realEstate.id = id;
        propertiesByLocation[realEstate.location].push(realEstate);
        propertiesBySeller[msg.sender].push(realEstate);
    }
    
    function searchProperty(string memory location) public view returns(RealEstate[] memory) {
        return propertiesByLocation[location];
    }
    
    function registerInterest(RealEstate memory realEstate) public {
        propertiesBySeller[realEstate.seller][realEstate.id].interests.push(msg.sender);
    }
    
    function buyProperty(RealEstate memory realEstate) public payable {
        require(msg.value == propertiesBySeller[realEstate.seller][realEstate.id].price, "Wrong price");
        propertiesBySeller[realEstate.seller][realEstate.id].status = PropertyStatuses.Sold;
        payable(propertiesBySeller[realEstate.seller][realEstate.id].seller).transfer(msg.value);
    }
    
    function getPropertyByLocationLength(string calldata location) public view returns (uint256) {
        return propertiesByLocation[location].length;
    }
    
    function getPropertyBySellerLength(address seller) public view returns (uint256) {
        return propertiesBySeller[seller].length;
    }
}