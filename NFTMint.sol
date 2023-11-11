// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract NFTMint is ERC721Enumerable, Ownable {
    using Strings for uint256;

    struct NFTType {
        string name;
        uint256 maxSupply;
        uint256 remainingSupply;
        uint256 price;
        string uri;
    }

    struct NFTDetails {
        string name;
        uint256 maxSupply;
        uint256 remainingSupply;
        uint256 price;
        string uri;
        uint256 tokenId;
    }

    NFTType[] public nftTypes;
    mapping(string => uint256) private _nftTypeIndexes;
    mapping(uint256 => uint256) private _tokenTypeIndexes;
    mapping(uint256 => bool) private _tokenExists;


    IERC20 public paymentToken;
    address public paymentReceiver;

    event NFTTypeAdded(string name, uint256 maxSupply, uint256 price, string uri);
    event NFTMinted(address minter, uint256 tokenId, string nftTypeName);
    event URIChanged(string nftTypeName, string newUri);
    event PriceChanged(string nftTypeName, uint256 newPrice);

    constructor(string memory name, string memory symbol)
        ERC721(name, symbol)
        Ownable(msg.sender) {
        paymentReceiver = owner(); // Set the payment receiver to the contract owner
        paymentToken = IERC20(0x70AE63bA0D88335c3CC89802AeEf253114cea30c); // Initialize with injected token address
    }

    function totalMaxSupply() public view returns (uint256) {
        uint256 total = 0;
        for (uint256 i = 0; i < nftTypes.length; i++) {
            total += nftTypes[i].maxSupply;
        }
        return total;
    }

    function totalNFTsRemaining() public view returns (uint256) {
            uint256 totalRemaining = 0;
            for (uint256 i = 0; i < nftTypes.length; i++) {
                totalRemaining += nftTypes[i].remainingSupply;
            }
            return totalRemaining;
        }


    function getOwnedNFTs(address owner) public view returns (NFTDetails[] memory) {
        uint256 tokenCount = balanceOf(owner);
        NFTDetails[] memory ownedNFTs = new NFTDetails[](tokenCount);
        for (uint256 i = 0; i < tokenCount; i++) {
            uint256 tokenId = tokenOfOwnerByIndex(owner, i);
            uint256 typeId = _tokenTypeIndexes[tokenId];
            NFTType storage nftType = nftTypes[typeId];
            ownedNFTs[i] = NFTDetails({
                name: nftType.name,
                maxSupply: nftType.maxSupply,
                remainingSupply: nftType.remainingSupply,
                price: nftType.price,
                uri: nftType.uri,
                tokenId: tokenId
            });
        }
        return ownedNFTs;
    }

    function getNFTDetails(uint256 tokenId) public view returns (NFTDetails memory) {
        require(_tokenExists[tokenId], "NFT does not exist."); // Use the custom mapping for existence check
        uint256 typeId = _tokenTypeIndexes[tokenId];
        NFTType storage nftType = nftTypes[typeId];
        return NFTDetails({
            name: nftType.name,
            maxSupply: nftType.maxSupply,
            remainingSupply: nftType.remainingSupply,
            price: nftType.price,
            uri: nftType.uri,
            tokenId: tokenId
        });
    }


     function addNFTType(string memory name, uint256 maxSupply, uint256 price, string memory uri) public onlyOwner {
        require(_nftTypeIndexes[name] == 0, "NFT type name already exists");
        uint256 priceInWei = price * 10**18; // Convert price to wei
        nftTypes.push(NFTType({
            name: name,
            maxSupply: maxSupply,
            remainingSupply: maxSupply, // Set remainingSupply to maxSupply at creation
            price: priceInWei, // Store the price in wei
            uri: uri
        }));
        uint256 typeId = nftTypes.length - 1;
        _nftTypeIndexes[name] = typeId;
        emit NFTTypeAdded(name, maxSupply, priceInWei, uri);
    }
    
    function setNFTTypeURI(string memory nftTypeName, string memory newUri) public onlyOwner {
        uint256 typeId = _nftTypeIndexes[nftTypeName];
        require(typeId != 0 || keccak256(bytes(nftTypes[0].name)) == keccak256(bytes(nftTypeName)), "NFT type does not exist");
        
        NFTType storage nftType = nftTypes[typeId];
        nftType.uri = newUri;
        emit URIChanged(nftTypeName, newUri);
    }

    function setNFTTypePrice(string memory nftTypeName, uint256 newPrice) public onlyOwner {
        uint256 typeId = _nftTypeIndexes[nftTypeName];
        require(typeId != 0 || keccak256(bytes(nftTypes[0].name)) == keccak256(bytes(nftTypeName)), "NFT type does not exist");
        
        NFTType storage nftType = nftTypes[typeId];
        uint256 newPriceInWei = newPrice * 10**18; // Convert new price to wei, if needed
        nftType.price = newPriceInWei;
        emit PriceChanged(nftTypeName, newPriceInWei);
    }

   function mint(string memory nftTypeName) public {
        uint256 typeId = _nftTypeIndexes[nftTypeName];
        require(typeId != 0 || keccak256(bytes(nftTypes[0].name)) == keccak256(bytes(nftTypeName)), "NFT type does not exist");
        NFTType storage nftType = nftTypes[typeId];

        require(nftType.remainingSupply > 0, "Max supply reached for this NFT type");
        require(paymentToken.transferFrom(msg.sender, paymentReceiver, nftType.price), "Payment failed");

        uint256 newTokenId = totalSupply() + 1; // Use totalSupply() for the new token ID
        _mint(msg.sender, newTokenId);
        _tokenTypeIndexes[newTokenId] = typeId;
        _tokenExists[newTokenId] = true;
        nftType.remainingSupply--; // Decrease remaining supply

        emit NFTMinted(msg.sender, newTokenId, nftTypeName);
    }

    function getAllNFTTypes() public view returns (NFTType[] memory) {
        return nftTypes;
    }
       function getAllNFTTypesAsStrings() public view returns (string[] memory) {
        string[] memory nftTypesStrings = new string[](nftTypes.length);
        for (uint256 i = 0; i < nftTypes.length; i++) {
            NFTType memory nftType = nftTypes[i];
            nftTypesStrings[i] = nftTypeToJson(nftType);
        }
        return nftTypesStrings;
    }

    function getOwnedNFTsAsStrings(address owner) public view returns (string[] memory) {
        uint256 tokenCount = balanceOf(owner);
        string[] memory ownedNFTsStrings = new string[](tokenCount);
        for (uint256 i = 0; i < tokenCount; i++) {
            uint256 tokenId = tokenOfOwnerByIndex(owner, i);
            NFTType memory nftType = nftTypes[_tokenTypeIndexes[tokenId]];
            ownedNFTsStrings[i] = nftTypeToJson(nftType);
        }
        return ownedNFTsStrings;
    }

    function getNFTDetailsAsString(uint256 tokenId) public view returns (string memory) {
        require(_tokenExists[tokenId], "NFT does not exist.");
        NFTType memory nftType = nftTypes[_tokenTypeIndexes[tokenId]];
        return nftTypeToJson(nftType);
    }

    // Helper function to convert an NFTType to a JSON string
    function nftTypeToJson(NFTType memory nftType) private pure returns (string memory) {
        return string(abi.encodePacked(
            '{"name":"', nftType.name,
            '", "maxSupply":"', uint256(nftType.maxSupply).toString(),
            '", "remainingSupply":"', uint256(nftType.remainingSupply).toString(),
            '", "price":"', uint256(nftType.price).toString(),
            '", "uri":"', nftType.uri, '"}'
        ));
    }
}
