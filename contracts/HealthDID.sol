// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

struct HealthDID {
    address owner;
    string healthDid;
    string ipfsUri;
    string[] altIpfsUris;
    bool hasWorldId;
    bool hasPolygonId;
    bool hasSocialId;
    uint256 reputationScore;
}

contract HealthDIDRegistry {
    uint256 public constant REGISTRATION_FEE_WEI = 2e15; // ~$5 at $2500/ETH
    address public immutable contractOwner;

    mapping(string => address) private didOwnerAddressRegistry;
    mapping(address => HealthDID) public addressDidMapping;
    mapping(address => mapping(string => bool)) public delegateAddresses;

    modifier onlyDidOwner(string memory _healthDid) {
        require(msg.sender == didOwnerAddressRegistry[_healthDid], "Not DID owner");
        _;
    }

    modifier onlyContractOwner() {
        require(msg.sender == contractOwner, "Not contract owner");
        _;
    }

    constructor() {
        contractOwner = msg.sender;
    }

    function registerDID(string memory _healthDID, string memory _uri) public payable returns (bool) {
        require(msg.value >= REGISTRATION_FEE_WEI, "Insufficient fee");
        require(didOwnerAddressRegistry[_healthDID] == address(0), "DID already exists");
        require(bytes(addressDidMapping[msg.sender].healthDid).length == 0, "Sender already has a DID");
        require(resolveChainId(_healthDID) == getChainID(), "Chain ID mismatch");

        didOwnerAddressRegistry[_healthDID] = msg.sender;
        addressDidMapping[msg.sender] = HealthDID({
            owner: msg.sender,
            healthDid: _healthDID,
            ipfsUri: _uri,
            altIpfsUris: new string[](0),
            hasWorldId: false,
            hasPolygonId: false,
            hasSocialId: false,
            reputationScore: 10
        });

        return true;
    }

    function withdraw() public onlyContractOwner {
        (bool success, ) = contractOwner.call{ value: address(this).balance }("");
        require(success, "Withdrawal failed");
    }

    function updateDIDData(string memory _healthDid, string memory _uri) public onlyDidOwner(_healthDid) returns (bool) {
        require(resolveChainId(_healthDid) == getChainID(), "Chain ID mismatch");
        addressDidMapping[msg.sender].ipfsUri = _uri;
        return true;
    }

    function addAltData(string memory _healthDid, string[] memory _uris) public onlyDidOwner(_healthDid) returns (bool) {
        require(resolveChainId(_healthDid) == getChainID(), "Chain ID mismatch");
        for (uint256 i = 0; i < _uris.length; i++) {
            addressDidMapping[msg.sender].altIpfsUris.push(_uris[i]);
        }
        return true;
    }

    function addDelegateAddress(address _peerAddress, string memory _healthDid) public onlyDidOwner(_healthDid) returns (bool) {
        require(resolveChainId(_healthDid) == getChainID(), "Chain ID mismatch");
        delegateAddresses[_peerAddress][_healthDid] = true;
        return true;
    }

    function removeDelegateAddress(address _peerAddress, string memory _healthDid) public onlyDidOwner(_healthDid) returns (bool) {
        require(resolveChainId(_healthDid) == getChainID(), "Chain ID mismatch");
        require(delegateAddresses[_peerAddress][_healthDid], "Not a delegate");
        delegateAddresses[_peerAddress][_healthDid] = false;
        return true;
    }

    function transferOwnership(address _newOwner, string memory _healthDid) public onlyDidOwner(_healthDid) returns (bool) {
        require(resolveChainId(_healthDid) == getChainID(), "Chain ID mismatch");
        require(_newOwner != msg.sender, "Cannot transfer to self");
        addressDidMapping[msg.sender].owner = _newOwner;
        return true;
    }

    function getHealthDID(string memory _healthDid) public view returns (HealthDID memory) {
        return addressDidMapping[didOwnerAddressRegistry[_healthDid]];
    }

    function resolveChainId(string memory did) public pure returns (uint256) {
        bytes memory b = bytes(did);
        uint256 result = 0;
        for (uint256 i = 0; i < b.length; i++) {
            if (b[i] == ":") return result;
            uint8 charVal = uint8(b[i]);
            require(charVal >= 48 && charVal <= 57, "Not a valid number");
            result = result * 10 + (charVal - 48);
        }
        revert("No colon found in DID");
    }

    function getChainID() public view returns (uint256) {
        uint256 id;
        assembly {
            id := chainid()
        }
        return id;
    }

    receive() external payable {}
}
