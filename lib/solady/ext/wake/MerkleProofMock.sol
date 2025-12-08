// SPDX-License-Identifier: MIT
// Copyright (c) 2025 JuicyD-web
// Ekubo Protocol - Licensed under Ekubo DAO Shared Revenue License 1.0

import "src/utils/MerkleProofLib.sol";

contract MerkleProofMock {
    function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) external pure returns (bool) {
        return MerkleProofLib.verify(proof, root, leaf);
    }

    function verifyCalldata(bytes32[] calldata proof, bytes32 root, bytes32 leaf) external pure returns (bool) {
        return MerkleProofLib.verify(proof, root, leaf);
    }

    function verifyMultiProof(bytes32[] memory proof, bytes32 root, bytes32[] memory leaves, bool[] memory flags) external pure returns (bool) {
        return MerkleProofLib.verifyMultiProof(proof, root, leaves, flags);
    }

    function verifyMultiProofCalldata(bytes32[] calldata proof, bytes32 root, bytes32[] calldata leaves, bool[] calldata flags) external pure returns (bool) {
        return MerkleProofLib.verifyMultiProof(proof, root, leaves, flags);
    }
}
