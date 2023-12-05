// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {ERC721, ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {SafeERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract NFTMint is ERC721Enumerable, Ownable, ReentrancyGuard {
    using Strings for uint256;
    using SafeERC20 for IERC20;

    struct NFTType {
        string name;
        uint256 maxSupply;
        uint256 remainingSupply;
        uint256 price;
        string uri;
    }

    mapping(uint256 => NFTType) private nftTypes;
    mapping(string => uint256) private _nftTypeIndexes;
    mapping(uint256 => uint256) private _tokenTypeIndexes;
    mapping(uint256 => bool) private _tokenExists;
    mapping(string => bool) private _typeExists;
    // owner -> typeId
    mapping(address => uint256[]) private _typesByOwner;

    IERC20 immutable public paymentToken;
    address immutable public paymentReceiver;

    uint256 public totalMaxSupply;
    uint256 public totalNFTTypes; 
    uint256 public totalRemainingSupply;
    uint256 internal currentTokenId;

    event NFTTypeAdded(string name, uint256 maxSupply, uint256 price, string uri);
    event NFTMinted(address minter, uint256 tokenId, string nftTypeName);
    event URIChanged(string nftTypeName, string newUri);
    event PriceChanged(string nftTypeName, uint256 newPrice);

    modifier exists(string memory nftTypeName) {
        if (nftTypes[_nftTypeIndexes[nftTypeName]].maxSupply == 0) 
            revert("NFT type does not exist");
        _;
    }

    constructor(string memory _name, string memory _symbol) 
        Ownable(msg.sender)
        ERC721(_name, _symbol
    ) {
        paymentReceiver = msg.sender; // Set the payment receiver to the contract owner
        paymentToken = IERC20(0xd9145CCE52D386f254917e481eB44e9943F39138); // Initialize with injected token address
    }

     function addNFTType(
        string memory _name, 
        uint256 maxSupply, 
        uint256 price, 
        string memory uri
    ) external onlyOwner {
        if (_typeExists[_name]) revert("NFT type name already exists");
        if (maxSupply == 0) revert("Invalid maxSupply");

        uint256 priceInWei = price * 10**18; // Convert price to wei

        nftTypes[totalNFTTypes] = NFTType(
            _name,
            maxSupply,
            maxSupply, // Set remainingSupply to maxSupply at creation
            priceInWei, // Store the price in wei
            uri
        );

        _nftTypeIndexes[_name] = totalNFTTypes;
        _typeExists[_name] = true;

        unchecked {
            totalMaxSupply += maxSupply;
            totalRemainingSupply += maxSupply;
            totalNFTTypes++;
        }

        emit NFTTypeAdded(_name, maxSupply, priceInWei, uri);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        if (!_tokenExists[tokenId]) revert("ERC721Metadata: URI query for nonexistent token");
        uint256 nftTypeId = _tokenTypeIndexes[tokenId];
        return nftTypes[nftTypeId].uri;
    }
    
    function setNFTTypeURI(
        string memory nftTypeName, 
        string memory newUri
    ) external onlyOwner exists(nftTypeName) {
        nftTypes[_nftTypeIndexes[nftTypeName]].uri = newUri;
        emit URIChanged(nftTypeName, newUri);
    }

    function setNFTTypePrice(
        string memory nftTypeName, 
        uint256 newPrice
    ) external onlyOwner exists(nftTypeName) {        
        uint256 newPriceInWei = newPrice * 10**18; // Convert new price to wei, if needed
        nftTypes[_nftTypeIndexes[nftTypeName]].price = newPriceInWei;
        emit PriceChanged(nftTypeName, newPriceInWei);
    }

   function mint(string memory nftTypeName) external nonReentrant exists(nftTypeName) {
        uint256 typeId = _nftTypeIndexes[nftTypeName];

        if (nftTypes[typeId].remainingSupply == 0) revert("Max supply reached for this NFT type");

        // paymentToken.safeTransferFrom(msg.sender, paymentReceiver, nftTypes[typeId].price);

        _mint(msg.sender, currentTokenId);

        _typesByOwner[msg.sender].push(typeId);
        _tokenTypeIndexes[currentTokenId] = typeId;
        _tokenExists[currentTokenId] = true;

        emit NFTMinted(msg.sender, totalMaxSupply, nftTypeName);

        unchecked {
            nftTypes[typeId].remainingSupply--; // Decrease remaining supply
            totalRemainingSupply--; // Decrease total remaining supply
            currentTokenId++;
        }
    }

    function getNFTTypesByOwner(address _owner) external view returns (uint256[] memory) {
        return _typesByOwner[_owner];
    }

    function getTokenIDsByOwner(address _owner) external view returns (uint256[] memory) {
        uint256 tokenCount = balanceOf(_owner);
        uint256[] memory ownedNFTs = new uint256[](tokenCount);

        unchecked {
            for (uint256 i; i < tokenCount; i++) {
                ownedNFTs[i] = tokenOfOwnerByIndex(_owner, i);
            }
        }
        return ownedNFTs;
    }

    function getNFTDetails(uint256 tokenId) external view returns (string memory) {
        if (!_tokenExists[tokenId]) revert("NFT does not exist.");
        return nftTypeToJson(nftTypes[_tokenTypeIndexes[tokenId]]);
    }

    // Helper function to convert an NFTType to a JSON string
    function nftTypeToJson(NFTType memory nftType) internal pure returns (string memory) {
        return string(abi.encodePacked(
            '{',
            '"name":"', nftType.name,
            '", "maxSupply":"', uint256(nftType.maxSupply).toString(),
            '", "remainingSupply":"', uint256(nftType.remainingSupply).toString(),
            '", "price":"', uint256(nftType.price).toString(),
            '", "uri":"', nftType.uri, '"}'
        ));
    }
}