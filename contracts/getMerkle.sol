//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol"; 

contract MerkleRootGenerator {

 function generateMerkleRoot(address[] memory addresses, uint256[] memory amounts) public pure returns (bytes32) {
        require(addresses.length == amounts.length, "Arrays must have the same length");

        bytes32[] memory nodes = new bytes32[](addresses.length);
        for (uint256 i = 0; i < addresses.length; i++) {
            nodes[i] = keccak256(abi.encodePacked(addresses[i], amounts[i]));
        }

        bytes32 merkleRoot = generateMerkleRootFromNodes(nodes);
        return merkleRoot;
    }

  function generateMerkleRootFromNodes(bytes32[] memory nodes) public pure returns (bytes32) {
      require(nodes.length > 0, "Nodes array must not be empty");

      while (nodes.length > 1) {
          if (nodes.length % 2 != 0) {
              bytes32[] memory newNodes = new bytes32[](nodes.length + 1);
              for (uint256 i = 0; i < nodes.length; i++) {
                  newNodes[i] = nodes[i];
              }
              newNodes[nodes.length] = nodes[nodes.length - 1];
            nodes = newNodes;
          }

          bytes32[] memory parentNodes = new bytes32[](nodes.length / 2);
          for (uint256 i = 0; i < nodes.length; i += 2) {
              parentNodes[i / 2] = keccak256(abi.encodePacked(nodes[i], nodes[i + 1]));
          }

          nodes = parentNodes;
      }

      return nodes[0];
  }
  
}



