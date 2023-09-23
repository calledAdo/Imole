//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

library SigValidation {
    function splitSignature(
        bytes memory sig
    ) internal pure returns (uint8 v, bytes32 r, bytes32 s) {
        require(sig.length == 65);

        assembly {
            // first 32 bytes, after the length prefix
            r := mload(add(sig, 32))
            // second 32 bytes
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(sig, 96)))
        }
    }

    function recoverSigner(
        bytes32 message,
        bytes memory sig
    ) internal pure returns (address) {
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(sig);

        return ecrecover(message, v, r, s);
    }

    function prefixed(bytes32 _hash) internal pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
            );
    }

    function isValidSignature(
        bytes memory _signature,
        address from,
        uint256 amount,
        uint _Art_ID
    ) internal view returns (bool) {
        bytes32 message = prefixed(
            keccak256(abi.encodePacked(address(this), _Art_ID, amount))
        );

        // check that the signature is from the payment sender
        return recoverSigner(message, _signature) == from;
    }
}
