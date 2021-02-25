pragma solidity ^0.5.0;

import "./interfaces/ERC721.sol";
import "./interfaces/ERC721Receiver.sol";
import "./interfaces/extensions/ERC721Metadata.sol";

contract DSM is ERC721, ERC721Receiver, ERC721Metadata{
    string _name = "Decentralized Stock Market";
    string _symbol = "DSM";

    bytes4 constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
    bytes4 constant _ERC721_RECEIVED = 0x150b7a02;

    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    mapping (bytes4 => bool) _interfaces;
    mapping (address => uint256) _balanceOf;
    mapping (uint256 => address) _ownerOf;
    mapping (uint256 => address) _aprrovedAddress;
    mapping (uint256 => mapping(address => bool)) _authorizedOperator;

    constructor() public {
        registerInterface(_INTERFACE_ID_ERC721);
    }

    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) external returns(bytes4){
        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }

    function supportsInterface(bytes4 interfaceID) external view returns (bool){
        return _interfaces[interfaceID];
    }

    function registerInterface(bytes4 interfaceId)  internal{
        require(interfaceId != 0xffffffff);
        _interfaces[interfaceId] = true;
    }

    function name() external view returns (string) {
        return _name;
    }

    function symbol() external view returns (string){
        return _symbol;
    }

    function tokenURI(uint256 _tokenId) external view returns (string){

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
        require(checkOnERC721Received(_from,_to, _tokenId, _data));
        _approvedAddress[_tokenId] = address(0);
        emit  Approval(_to, address(0), _tokenId);

        _balanceOf[_from] -= 1;
        _balanceOf[_to] += 1;
        _ownerOf[tokenId] = _to;
        emit Transfer(_from,_to,_tokenId);
    }


    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable {
        safeTransferFrom(_from,_to,_tokenID, " ");
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external payable{
        require(ownerOf(_tokenId) == msg.sender || _authorizedOperator[_tokenId][msg.sender] == true || _approvedAddress[_tokenId] == msg.sender);
        require(ownerOf(_tokenId) == _from);
        require(_to != address(0));
        require(ownerOf(_tokenId) != address(0));
        _approvedAddress[_tokenId] = address(0);

        emit  Approval(_to, address(0), _tokenId);

        _balanceOf[_from] -= 1;
        _balanceOf[_to] += 1;
        _ownerOf[tokenId] = _to;
        emit Transfer(_from,_to,_tokenId);
    }

    function approve(address _approved, uint256 _tokenId) external payable{
        require(_approved != address(0));
        require(ownerOf(_tokenId) == msg.sender || _authorizedOperator[_tokenId][_approved] == true);
        _approvedAddress[_tokenId] = _approved;
        emit Approval(ownerOf(_tokenId), _approved, _tokenId);

    }

    function setApprovalForAll(address _operator, bool _approved) external{
        require(_operator != msg.sender);
        _authorizedOperator[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function getApproved(uint256 _tokenId) external view returns (address){
        require(ownerOf(_tokenId) != address(0));
        return _approvedAddress[_tokenId];
    }

    function isApprovedForAll(address _owner, address _operator) external view returns (bool){
        return _authorizedOperator[_owner][_operator];
    }

    function checkOnERC721Received(address _from, address _to, uint256 tokenId, bytes memory _data) internal returns (bool){
        if (!_to.isContract()) {
            return true;
        }

        bytes4 retval = IERC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
        return (retval == _ERC721_RECEIVED);
    }
}
