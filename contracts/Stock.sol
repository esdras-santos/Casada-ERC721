pragma solidity ^0.5.0;

import "./DSM.sol";

contract Stock{

    mapping(string => DSM) private _assets;

    constructor() public {}

    function registerStock(string calldata name, string calldata symbol, uint256 totalSupply) external {
        _assets[name] = new DSM(name, symbol, totalSupply);
    }

    function getStock(string calldata stockName) external returns(DSM){
        return _assets[stockName];
    }

    function name()

}