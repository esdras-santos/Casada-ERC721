pragma solidity ^0.5.0;

import "./interfaces/IERC721.sol";
import "./interfaces/ERC721Receiver.sol";
import "./interfaces/extensions/ERC721Metadata.sol";
import "./interfaces/extensions/ERC721Enumerable.sol";

contract DSM is IERC721, ERC721Receiver, ERC721Metadata, IERC165 /*ERC721Enumerable*/{
    string private _name;
    string private _symbol;
    uint256 private _totalSupply;

    bytes4 private constant _InterfaceIdERC721 = 0x80ac58cd;
    bytes4 private constant _ERC721Received = 0x150b7a02;

    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    uint256[] private _tokenIndex;

    mapping (uint256 => string) private _tokenURI;
    mapping (bytes4 => bool) private _interfaces;
    mapping (address => uint256) private _balance;
    mapping (uint256 => address) private _owner;
    mapping (uint256 => address) private _approvedAddress;
    mapping(address => uint256[]) private _ownedTokens;
    mapping (address => mapping(address => bool)) private _authorizedOperator;

    constructor() public {
        _registerInterface(_InterfaceIdERC721);
    }

    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4){
        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }

    function supportsInterface(bytes4 interfaceID) external view returns (bool){
        return _interfaces[interfaceID];
    }

    function _registerInterface(bytes4 interfaceId) internal {
        require(interfaceId != 0xffffffff);
        _interfaces[interfaceId] = true;
    }

    function name() external view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory){
        return _symbol;
    }

    // function totalSupply() external view returns (uint256){
    //     return _totalSupply;
    // }

    // function tokenByIndex(uint256 _index) external view returns (uint256){
    //     require(_index < totalSupply());
    //     return _tokenIndex[_index];
    // }

    // function tokenOfOwnerByIndex(address owner, uint256 _index) external view returns (uint256){
    //     require(_index < balanceOf(owner));
    //     return _ownedTokens[owner][_index];
    // }


    function tokenURI(uint256 _tokenId) external view returns (string memory){
        require(_owner[_tokenId] != address(0));
        return _tokenURI[_tokenId];
    }

    function _setTokenURI(uint256 _tokenId, string storage _uri) internal {
        require(_owner[_tokenId] != address(0));
        _tokenURI[_tokenId] = _uri;
    }

    function balanceOf(address owner) public view returns (uint256){
        require(owner != address(0));
        return _balance[owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address){
        address owner = _owner[_tokenId];
        require(owner != address(0));
        return owner;
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory _data) public{
        require(_isApprovedOrOwner(msg.sender,_tokenId), "not the owner or approved");
        _transfer(_from, _to, _tokenId);
        require(_checkOnERC721Received(_from,_to, _tokenId, _data));
    }


    function safeTransferFrom(address _from, address _to, uint256 _tokenId) public{
        safeTransferFrom(_from,_to,_tokenId, " ");
    }

    function _transfer(address _from, address _to, uint256 _tokenId) internal{
        address owner = ownerOf(_tokenId);
        require(owner == _from);
        require(_to != address(0));
        _approvedAddress[_tokenId] = address(0);
        _balance[_from] -= 1;
        _balance[_to] += 1;
        _owner[_tokenId] = _to;
        emit Transfer(_from,_to,_tokenId);
    }

    function _isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
        address owner = ownerOf(_tokenId);
        require(owner != address(0));
        return (_spender == owner || isApprovedForAll(owner, msg.sender) == true || getApproved(_tokenId) == msg.sender);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public{
        _transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) public{
        require(_approved != address(0));
        require(ownerOf(_tokenId) == msg.sender || isApprovedForAll(msg.sender, _approved) == true);
        _approvedAddress[_tokenId] = _approved;
        emit Approval(ownerOf(_tokenId), _approved, _tokenId);

    }

    //not finished yet
    function _mint(address _to, uint256 _tokenId) internal{
        _balance[_to] += 1;
        _owner[_tokenId] = _to;
    }

    function setApprovalForAll(address _operator, bool _approved) public{
        require(_operator != msg.sender);
        _authorizedOperator[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function getApproved(uint256 _tokenId) public view returns (address){
        require(ownerOf(_tokenId) != address(0));
        return _approvedAddress[_tokenId];
    }

    function isApprovedForAll(address owner, address _operator) public view returns (bool){
        return _authorizedOperator[owner][_operator];
    }

    function _checkOnERC721Received(address _from, address _to, uint256 _tokenId, bytes memory _data) internal returns (bool){
        if (!isContract(_to)) {
            return true;
        }

        bytes4 retval = ERC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
        return (retval == _ERC721Received);
    }

    function isContract(address addr) internal returns (bool) {
        uint size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }
}
