pragma solidity ^0.5.0;

import "./DSM.sol";

contract Stock is DSM{


    constructor() public {}

    function mint(address _to, uint256 _tokenId) external {
        _mint(_to, _tokenId);
    }

}