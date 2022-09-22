// SPDX-License-Identifier: MIT
// Fragnova Simple NFT Factory

pragma solidity ^0.8.7;

import "./ClonesWithCalldata.sol";
import "./IBootstrapped.sol";

contract FragnovaSimpleNFTFactory {
    event Created(address indexed newContract);

    function create(
        string memory name,
        string memory symbol,
        string memory baseUrl,
        uint256 quantity,
        address implementation
    ) public {
        bytes32 name32 = bytes32(bytes(name));
        bytes32 symbol32 = bytes32(bytes(symbol));
        bytes32 baseUrl32 = bytes32(bytes(baseUrl));
        bytes memory ptr = new bytes(128);
        assembly {
            mstore(add(ptr, 0x20), name32)
            mstore(add(ptr, 0x40), symbol32)
            mstore(add(ptr, 0x60), baseUrl32)
            mstore(add(ptr, 0x80), quantity)
        }
        address newContract = ClonesWithCallData.cloneWithCallDataProvision(
            implementation,
            ptr
        );

        IBootstrapped(newContract).bootstrap();

        emit Created(newContract);
    }
}
