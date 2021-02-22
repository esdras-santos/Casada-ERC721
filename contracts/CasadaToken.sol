pragma solidity ^0.5.0;

contract CasadaToken{
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    mapping (address => uint256) public balanceOf;
    mapping (uint256 => address) public ownerOf;
    mapping (uint256 => mapping(address => bool)) authorized;

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable {
        require(ownerOf[_tokenId] == msg.sender || authorized[_tokenId][msg.sender] == true);
        require(ownerOf[_tokenId] == _from);
        require(_to != 0x0);
        require(ownerOf[_tokenId] != 0x0);
        balanceOf[_from] -= 1;
        balanceOf[_to] += 1;
        ownerOf[tokenId] = _to;
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable {
        
    }

    function approve(address _approved, uint256 _tokenId) external payable{
        require(_approved != 0x0);
        require(ownerOf[_tokenId] == msg.sender || authorized[_tokenId][_approved] == true);
        authorized[_tokenId][_approved] = true;
    }
}