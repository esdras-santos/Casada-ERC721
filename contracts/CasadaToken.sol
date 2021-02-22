pragma solidity ^0.5.0;

contract CasadaToken{
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    mapping (address => uint256) public balanceOf;
    mapping (uint256 => address) public ownerOf;

    
}