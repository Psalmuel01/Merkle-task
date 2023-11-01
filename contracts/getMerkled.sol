//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MerkleTree {
    bytes32 public root;

    function generateMerkleRoot(
        address[] memory addresses,
        uint256[] memory amounts
    ) public pure returns (bytes32) {
        require(
            addresses.length == amounts.length,
            "Arrays must have the same length"
        );

        bytes32[] memory nodes = new bytes32[](addresses.length);
        for (uint256 i = 0; i < addresses.length; i++) {
            nodes[i] = keccak256(abi.encodePacked(addresses[i], amounts[i]));
        }

        require(nodes.length > 0, "At least one leaf node required");

        bytes32 merkleRoot = _calculateMerkleRoot(nodes);
        return merkleRoot;
    }

    function _calculateMerkleRoot(
        bytes32[] memory leafData
    ) internal pure returns (bytes32) {
        uint256 n = leafData.length;
        bytes32[] memory temp = new bytes32[](n * 2);

        // Populate leaf nodes
        for (uint256 i = 0; i < n; i++) {
            temp[i + n] = leafData[i];
        }

        // Calculate intermediate nodes
        for (uint256 i = n - 1; i > 0; i--) {
            temp[i] = keccak256(abi.encodePacked(temp[i * 2], temp[i * 2 + 1]));
        }

        return temp[1]; // Return the root node
    }

    function generateMerkleProof(
        uint256 leafIndex,
        bytes32 leafData
    ) public pure returns (bytes32[] memory) {
        require(leafIndex < (2 ** 256 - 1), "Invalid leaf index");
        require(
            leafIndex < (2 ** 128 - 1),
            "Leaf index must be less than 2^128 - 1"
        );

        bytes32[] memory proof = new bytes32[](128); // Maximum tree depth is 128

        uint256 index = leafIndex;
        uint256 proofIndex = 0;
        uint256 i;

        for (i = 0; i < 128; i++) {
            if (index % 2 == 1) {
                proof[proofIndex] = keccak256(
                    abi.encodePacked(proof[proofIndex], leafData)
                );
                proofIndex++;
            } else {
                proof[proofIndex] = keccak256(
                    abi.encodePacked(leafData, proof[proofIndex])
                );
                proofIndex++;
            }

            index = index / 2;

            if (index == 0) {
                break;
            }
        }

        bytes32[] memory proofResult = new bytes32[](i + 1);
        for (uint256 j = 0; j <= i; j++) {
            proofResult[j] = proof[j];
        }

        return proofResult;
    }
}
