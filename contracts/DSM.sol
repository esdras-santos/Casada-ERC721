pragma solidity ^0.5.0;

import "./interfaces/ERC721.sol";
import "./interfaces/ERC721Receiver.sol";
import "./interfaces/extensions/ERC721Metadata.sol";

contract DSM is ERC721, ERC721Receiver, ERC721Metadata, ERC165{
    string private _name = "Decentralized Stock Market";
    string private _symbol = "DSM";

    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;

    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    mapping (uint256 => string) private _tokenURI;
    mapping (bytes4 => bool) private _interfaces;
    mapping (address => uint256) private _balance;
    mapping (uint256 => address) private _owner;
    mapping (uint256 => address) private _approvedAddress;
    mapping (address => mapping(address => bool)) private _authorizedOperator;

    constructor() public {
        registerInterface(_INTERFACE_ID_ERC721);
    }

    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4){
        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }

    function supportsInterface(bytes4 interfaceID) external view returns (bool){
        return _interfaces[interfaceID];
    }

    function registerInterface(bytes4 interfaceId) internal {
        require(interfaceId != 0xffffffff);
        _interfaces[interfaceId] = true;
    }

    function name() external view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory){
        return _symbol;
    }

    function tokenURI(uint256 _tokenId) external view returns (string memory){
        require(_owner[_tokenId] != address(0));
        return _tokenURI[_tokenId];
    }

    function setTokenURI(uint256 _tokenId, string storage _uri) internal {
        require(_owner[_tokenId] != address(0));
        _tokenURI[_tokenId] = _uri;
    }

    function balanceOf(address owner) external view returns (uint256){
        require(owner != address(0));
        return _balance[owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address){
        address owner = _owner[_tokenId];
        require(owner != address(0));
        return owner;
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable {
        require(this.ownerOf(_tokenId) == msg.sender || _authorizedOperator[_from][msg.sender] == true || _approvedAddress[_tokenId] == msg.sender);
        require(this.ownerOf(_tokenId) == _from);
        require(_to != address(0));
        require(this.ownerOf(_tokenId) != address(0));
        require(checkOnERC721Received(_from,_to, _tokenId, data));
        this.approve(address(0),_tokenId);

        _balance[_from] -= 1;
        _balance[_to] += 1;
        _owner[_tokenId] = _to;
        emit Transfer(_from,_to,_tokenId);
    }


    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable {
        this.safeTransferFrom(_from,_to,_tokenId, " ");
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external payable{
        require(this.ownerOf(_tokenId) == msg.sender || _authorizedOperator[_from][msg.sender] == true || this.getApproved(_tokenId) == msg.sender);
        require(this.ownerOf(_tokenId) == _from);
        require(_to != address(0));
        require(this.ownerOf(_tokenId) != address(0));
        this.approve(address(0),_tokenId);

        _balance[_from] -= 1;
        _balance[_to] += 1;
        _owner[_tokenId] = _to;
        emit Transfer(_from,_to,_tokenId);
    }

    function approve(address _approved, uint256 _tokenId) external payable{
        require(_approved != address(0));
        require(this.ownerOf(_tokenId) == msg.sender || _authorizedOperator[msg.sender][_approved] == true);
        _approvedAddress[_tokenId] = _approved;
        emit Approval(this.ownerOf(_tokenId), _approved, _tokenId);

    }

    function setApprovalForAll(address _operator, bool _approved) external{
        require(_operator != msg.sender);
        _authorizedOperator[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function getApproved(uint256 _tokenId) external view returns (address){
        require(this.ownerOf(_tokenId) != address(0));
        return _approvedAddress[_tokenId];
    }

    function isApprovedForAll(address owner, address _operator) external view returns (bool){
        return _authorizedOperator[owner][_operator];
    }

    function checkOnERC721Received(address _from, address _to, uint256 _tokenId, bytes memory _data) internal returns (bool){
        if (!isContract(_to)) {
            return true;
        }

        bytes4 retval = ERC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
        return (retval == _ERC721_RECEIVED);
    }

    function isContract(address addr) internal returns (bool) {
        uint size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }
}
