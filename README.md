# DID Health Registry Contract

## Description
The DID Health Registry Contract is a smart contract written in Solidity that provides a decentralized identity (DID) management system for healthcare-related data. It allows users to register and manage their DIDs on the blockchain, enabling secure and verifiable access to their health-related information.

## SPDX-License-Identifier
This contract is licensed under the MIT License.
```SPDX-License-Identifier: MIT```

## Prerequisites
- Solidity version 0.8.17 or higher is required to deploy and interact with this contract.

## Dependencies
This contract relies on an external library for data structures, which is imported as follows:

```import "./lib/Structs.sol";```

## Contract Functions

### registerDID(string memory _healthDID, string memory _uri)
- Description: Registers a new DID with the specified healthDID and URI.
- Parameters:
  - _healthDID: The unique identifier for the health DID.
  - _uri: The URI pointing to the associated health data.
- Returns: bool indicating the success of the operation.
  
### updateDIDData(string memory _healthDid, string memory _uri)
- Description: Updates the URI associated with an existing DID.
- Parameters:
  - _healthDid: The unique identifier for the health DID.
  - _uri: The new URI pointing to the updated health data.
- Returns: bool indicating the success of the operation.

### addAltData(string memory _healthDid, string[] memory _uris)
- Description: Adds alternative URIs to an existing DID's data.
- Parameters:
  - _healthDid: The unique identifier for the health DID.
  - _uris: An array of alternative URIs.
- Returns: bool indicating the success of the operation.

### addDelegateAddress(address _peerAddress, string memory _healthDid)
- Description: Adds a delegate address for accessing the specified DID.
- Parameters:
  - _peerAddress: The address of the delegate.
  - _healthDid: The unique identifier for the health DID.
- Returns: bool indicating the success of the operation.

### removeDelegateAddress(address _peerAddress, string memory _healthDid)
- Description: Removes a delegate address from accessing the specified DID.
- Parameters:
  - _peerAddress: The address of the delegate.
  -  _healthDid: The unique identifier for the health DID.
- Returns: bool indicating the success of the operation.
  
### transferOwnership(address _newAddress, string memory _healthDid)
- Description: Transfers ownership of the specified DID to a new address.
- Parameters:
  - _newAddress: The address to which ownership is transferred.
  - _healthDid: The unique identifier for the health DID.
- Returns: bool indicating the success of the operation.

### getHealtDID(string memory _healthDid)
- Description: Retrieves the health DID information associated with a specific health DID.
- Parameters:
  - _healthDid: The unique identifier for the health DID.
- Returns: A Structs.HealthDID struct containing the health DID information.
  
### resolveChainId(string memory did)
- Description: Resolves the chain ID from the given DID.
- Parameters:
  - did: The DID from which to extract the chain ID.
- Returns: The resolved chain ID as a uint256.

### getChainID()
- Description: Retrieves the current chain ID.
- Returns: The current chain ID as a uint256.

#### stringToBytes32(string memory _source)
- Description: Converts a string to bytes32.
- Parameters:
  - _source: The source string.
- Returns: The converted bytes32 value.

## Usage
To use this contract, deploy it on a compatible Ethereum blockchain, and interact with it using a compatible Ethereum wallet or smart contract interface.

## License
This contract is licensed under the MIT License. See the LICENSE file for details.
