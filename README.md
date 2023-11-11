# NFTMint Smart Contract
## Overview

`NFTMint` is a smart contract built on the Ethereum blockchain, utilizing the ERC721 token standard for non-fungible tokens (NFTs). It provides a structured way to mint, manage, and interact with various types of NFTs, each with its own unique properties and metadata.

## Table of Contents
1. [Overview](#overview)
2. [Contract Features](#contract-features)
3. [Contract Functions](#contract-functions)
   - [Minting and Management](#minting-and-management)
   - [View Functions](#view-functions)
   - [Utility Functions](#utility-functions)
4. [Usage in Remix](#usage-in-remix)
5. [Use Cases](#use-cases)
6. [Development and Contributions](#development-and-contributions)

## Contract Features

- **NFT Types Management**: Create and manage different types of NFTs with individual characteristics.
- **ERC721 Compliance**: Full compatibility with the ERC721 standard, ensuring interoperability with various marketplaces and wallets.
- **Minting Control**: Mint new NFTs with controlled supply and pricing.
- **Ownership and Enumeration**: Integrated support for querying NFT ownership and enumerating owned NFTs.
- **Payment Token Integration**: Accept payments for minting in a specific ERC20 token.
- **Metadata and URI Management**: Manage and update the metadata URI for each NFT type.

## Contract Functions

### Minting and Management

#### `addNFTType`
- **Description**: Add a new type of NFT to the contract.
- **Parameters**: `name`, `maxSupply`, `price`, `uri`
- **Access**: Only owner.

#### `setNFTTypeURI`
- **Description**: Update the metadata URI for a specific NFT type.
- **Parameters**: `nftTypeName`, `newUri`
- **Access**: Only owner.

#### `setNFTTypePrice`
- **Description**: Update the minting price for a specific NFT type.
- **Parameters**: `nftTypeName`, `newPrice`
- **Access**: Only owner.

#### `mint`
- **Description**: Mint a new NFT of a specified type.
- **Parameters**: `nftTypeName`
- **Access**: Public.

### View Functions

#### `getOwnedNFTs`
- **Description**: Retrieve the NFTs owned by a specific address.
- **Parameters**: `owner`
- **Returns**: Array of `NFTDetails`.

#### `getNFTDetails`
- **Description**: Get details of a specific NFT by its token ID.
- **Parameters**: `tokenId`
- **Returns**: `NFTDetails`.

#### `getAllNFTTypes`
- **Description**: Retrieve all available NFT types.
- **Returns**: Array of `NFTType`.

#### `getAllNFTTypesAsStrings`
- **Description**: Retrieve all NFT types in JSON string format.
- **Returns**: Array of strings.

### Utility Functions

#### `totalMaxSupply`
- **Description**: Calculate the total maximum supply of all NFT types.
- **Returns**: `uint256`.

#### `totalNFTsRemaining`
- **Description**: Calculate the total remaining supply of all NFT types.
- **Returns**: `uint256`.

## Usage in Remix

1. **Deployment**:
   - Access [Remix IDE](https://remix.ethereum.org/).
   - Paste the contract code into a new Solidity file.
   - Compile the contract and deploy it to the desired network.

2. **Interaction**:
   - Use the deployed contract interface in Remix to interact with the contract's functions.
   - Test minting, updating URIs, prices, and querying NFT details.

## Use Cases

- **NFT Minting Platform**: Create a platform for artists and creators to mint and manage their own NFTs.
- **Digital Collectibles**: Issue and manage digital collectibles across different categories or themes.
- **Gaming Assets**: Use for in-game assets, character skins, or virtual goods.

## Development and Contributions

Contributions to the `NFTMint` smart contract are encouraged. Please follow these guidelines for contributing:

- **Feature Requests and Issues**: Use the GitHub Issues section for bug reports, feature requests, or suggestions.
