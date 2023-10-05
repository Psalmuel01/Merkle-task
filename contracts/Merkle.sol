//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MerkleDistribution {
    
    bytes32 public merkleRoot;

    mapping(address => uint256) public claimed;

    function setMerkleRoot(bytes32 _merkleRoot) public {
        merkleRoot = _merkleRoot;
    }

    // function addEnabledAddresses(string memory csv) public {
    //     bytes memory csvBytes = bytes(csv);
    //     uint256 i = 0;
    //     while (i < csvBytes.length) {
    //         address addr;
    //         uint256 amount;
    //         for (uint256 j = 0; j < 20; j++) {
    //             addr |= address(csvBytes[i + j] & 0xFF) << (8 * (19 - j));
    //         }
    //         i += 20;
    //         for (uint256 j = 0; j < 32; j++) {
    //             amount |= uint256(uint8(csvBytes[i + j])) << (8 * (31 - j));
    //         }
    //         i += 32;
    //         claimed[addr] = amount;
    //     }
    // }

    function claim(uint256 amount, bytes32[] memory merkleProof) public {
        require(claimed[msg.sender] == 0, "Tokens already claimed");

        bytes32 node = keccak256(abi.encodePacked(msg.sender, amount));
        require(verify(merkleProof, node), "Invalid proof");

        claimed[msg.sender] = amount;
        ERC20 token = ERC20(0xE7f419b437f27d3f09b174DeF166D6CCC4C7d824); // Replace with actual token address
        token.transfer(msg.sender, amount);
    }

    function verify(bytes32[] memory proof, bytes32 leaf) internal view returns (bool) {
        bytes32 computedHash = leaf;

        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];

            if (computedHash < proofElement) {
                computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
            } else {
                computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
            }
        }

        return computedHash == merkleRoot;
    }
}