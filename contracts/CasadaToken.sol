pragma solidity ^0.5.0;

import "./interfaces/ERC721.sol";
import "./interfaces/ERC721Receiver.sol";
import "./interfaces/extensions/ERC721Metadata.sol";

contract CasadaToken is ERC721, {
    string _name;
    string _symbol;

    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    mapping (address => uint256) _balanceOf;
    mapping (uint256 => address) _ownerOf;
    mapping (uint256 => address) _aprrovedAddress;
    mapping (uint256 => mapping(address => bool)) _authorizedOperator;

    constructor(string name, string symbol) public {
        _name = name;
        _symbol = symbol;
    }

    function name() external view returns (string _name) {
        return this._name;
    }

    function symbol() external view returns (string _symbol){
        return this._symbol;
    }

    public balanceOf(address _owner) external view returns (uint256){
        require(_owner != address(0));
        return _balanceOf[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address){
        address owner = _ownerOf[_tokenId];
        require(owner != address(0));
        return owner;
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable {
        require(ownerOf(_tokenId) == msg.sender || _authorizedOperator[_tokenId][msg.sender] == true || _approvedAddress[_tokenId] == msg.sender);
        require(ownerOf(_tokenId) == _from);
        require(_to != address(0));
        require(ownerOf[_tokenId] != address(0));
        _approvedAddress[_tokenId] = address(0);
        _balanceOf[_from] -= 1;
        _balanceOf[_to] += 1;
        _ownerOf[tokenId] = _to;
        emit Transfer(_from,_to,_tokenId);
        if (!to.isContract()) {
        checkERc721Received();
    }


    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable {
        
    }

    function approve(address _approved, uint256 _tokenId) external payable{
        require(_approved != address(0));
        require(ownerOf(_tokenId) == msg.sender || _authorizedOperator[_tokenId][_approved] == true);
        _approvedAddress[_tokenId] = _approved;
    }

    function checkERC721Received(address _from, address _to, uint256 tokenId, bytes memory _data) internal returns (bool){
        if (!to.isContract()) {
            return true;
        }

        bytes4 retval = IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data);
        return (retval == _ERC721_RECEIVED);
    }
}
