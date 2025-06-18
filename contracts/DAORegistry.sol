// Solidity Contract - DidHealthDAO.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DidHealthDAO {
    struct Member {
        string did;
        string role;
        string orgName;
        bool exists;
    }

    mapping(address => Member) public members;
    address public owner;
    uint256 public registrationFee = 0.01 ether;

    constructor() {
        owner = msg.sender;
    }

    function setRegistrationFee(uint256 fee) external {
        require(msg.sender == owner, "Only owner");
        registrationFee = fee;
    }

    function withdraw() external {
        require(msg.sender == owner, "Only owner");
        payable(owner).transfer(address(this).balance);
    }

    function addMember(address addr, string memory did, string memory role, string memory orgName) public payable {
        require(!members[addr].exists, "Already a member");
        require(msg.value >= registrationFee, "Insufficient fee");
        members[addr] = Member({ did: did, role: role, orgName: orgName, exists: true });
    }

    function removeMember(address addr) public {
        require(members[addr].exists, "Not a member");
        require(msg.sender == owner, "Only owner can remove members");
        delete members[addr];
    }

    function isMember(address addr) public view returns (bool) {
        return members[addr].exists;
    }

    function getProfile(address addr) public view returns (string memory, string memory, string memory) {
        require(members[addr].exists, "Not a member");
        Member memory m = members[addr];
        return (m.did, m.role, m.orgName);
    }
}