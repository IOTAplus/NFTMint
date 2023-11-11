# NFTMint Smart Contract
## Overview

`NFTMint` is an Ethereum-based smart contract that follows the ERC721 standard for non-fungible tokens (NFTs). It is designed to mint, manage, and interact with a variety of NFTs, each characterized by unique properties and metadata. This contract offers a structured approach to handling multiple NFT types within a single contract, allowing for diversified collections and themes.

## Table of Contents
1. [Overview](#overview)
2. [Contract Features](#contract-features)
3. [Contract Functions](#contract-functions)
   - [Minting and Management Functions](#minting-and-management-functions)
   - [View and Utility Functions](#view-and-utility-functions)
4. [Usage in Remix IDE](#usage-in-remix-ide)
5. [Potential Use Cases](#potential-use-cases)
6. [Development and Contributions](#development-and-contributions)

## Contract Features

- **ERC721 Compliance**: Fully compliant with the ERC721 standard for NFTs.
- **Various NFT Types**: Manage different types of NFTs, each with unique characteristics such as name, supply, price, and URI.
- **Controlled Minting Process**: Mint new NFTs while managing their supply and pricing.
- **Ownership Enumeration**: Support for querying NFT ownership and enumerating NFTs owned by a user.
- **Payment Token Integration**: Accept ERC20 tokens as payment for minting NFTs.
- **Metadata and URI Management**: Functionality to manage and update the metadata URI for NFT types.

## Contract Functions

### Minting and Management Functions

#### `addNFTType`
- **Description**: Adds a new NFT type to the contract.
- **Parameters**: `name`, `maxSupply`, `price`, `uri`.
- **Access**: Restricted to the contract owner.

#### `setNFTTypeURI`
- **Description**: Updates the metadata URI for a specific NFT type.
- **Parameters**: `nftTypeName`, `newUri`.
- **Access**: Restricted to the contract owner.

#### `setNFTTypePrice`
- **Description**: Updates the minting price for a specific NFT type.
- **Parameters**: `nftTypeName`, `newPrice`.
- **Access**: Restricted to the contract owner.

#### `mint`
- **Description**: Mints a new NFT of the specified type.
- **Parameters**: `nftTypeName`.
- **Access**: Public.

### View and Utility Functions

#### `totalMaxSupply`
- **Description**: Calculates the total maximum supply of all NFT types.
- **Returns**: Total maximum supply as `uint256`.

#### `totalNFTsRemaining`
- **Description**: Calculates the total remaining supply for all NFT types.
- **Returns**: Total remaining supply as `uint256`.

#### `getOwnedNFTs`
- **Description**: Retrieves the NFTs owned by a specific address.
- **Parameters**: `owner` address.
- **Returns**: An array of `NFTDetails`.

#### `getNFTDetails`
- **Description**: Provides details of a specific NFT by its token ID.
- **Parameters**: `tokenId`.
- **Returns**: `NFTDetails`.

#### `getAllNFTTypes`
- **Description**: Retrieves all NFT types created in the contract.
- **Returns**: An array of `NFTType`.

#### `getAllNFTTypesAsStrings`
- **Description**: Retrieves all NFT types in a JSON string format.
- **Returns**: Array of strings.

#### `getOwnedNFTsAsStrings`
- **Description**: Retrieves owned NFTs in JSON string format for a given owner address.
- **Parameters**: `owner` address.
- **Returns**: Array of strings.

#### `getNFTDetailsAsString`
- **Description**: Provides NFT details in JSON string format based on the token ID.
- **Parameters**: `tokenId`.
- **Returns**: NFT details as a string.

#### `nftTypeToJson`
- **Description**: Converts an `NFTType` structure to a JSON string.
- **Parameters**: `NFTType`.
- **Returns**: JSON string.

## Usage in Remix IDE

1. **Deployment**: 
   - Access [Remix IDE](https://remix.ethereum.org/).
   - Paste the contract code into a new Solidity file.
   - Compile the contract using the Solidity Compiler.
   - Deploy the contract on your desired network.

2. **Interaction**: 
   - Use Remix to interact with the deployed contract.
   - Test functions like minting NFTs, updating URIs and prices, and querying details.

## Potential Use Cases

- **Digital Art and Collectibles**: Facilitates the creation and trade of digital

 art and collectibles.
- **Virtual Assets in Gaming**: Manages in-game assets, characters, or items.
- **Event Tickets**: Issues and manages unique event tickets as NFTs.

## Development and Contributions

Contributions to `NFTMint` are welcome. Please follow these guidelines:

- **Reporting Issues**: Use GitHub Issues for bug reports or feature suggestions.
