// SPDX-License-Identifier: MIT
// Fragnova Simple NFT Template

pragma solidity ^0.8.7;

import "./ERC721A.sol";
import "./Ownable.sol";
import "./RoyaltiesReceiver.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract FragnovaNFTTemplate is ERC721A, Initializable, Ownable, RoyaltiesReceiver {
    function _getImmutableVariablesOffset()
        internal
        pure
        returns (uint256 offset)
    {
        assembly {
            offset := sub(
                calldatasize(),
                add(shr(240, calldataload(sub(calldatasize(), 2))), 2)
            )
        }
    }

    constructor() ERC721A("", "") {}

    function bootstrap() public initializer {
        uint256 offset = _getImmutableVariablesOffset();

        Ownable._bootstrap(tx.origin);

        setupRoyalties(tx.origin, 500);

        uint256 quantity;
        assembly {
            quantity := calldataload(add(offset, 0x60))
        }

        _mint(tx.origin, quantity);
    }

    function name() public view virtual override returns (string memory) {
        uint256 offset = _getImmutableVariablesOffset();
        bytes32 nameBytes;
        assembly {
            nameBytes := calldataload(offset)
        }
        return toString(nameBytes);
    }

    function symbol() public view virtual override returns (string memory) {
        uint256 offset = _getImmutableVariablesOffset();
        bytes32 symbolBytes;
        assembly {
            symbolBytes := calldataload(add(offset, 0x20))
        }
        return toString(symbolBytes);
    }

    function _baseURI() internal pure override returns (string memory _url) {
        uint256 offset = _getImmutableVariablesOffset();
        bytes32 baseUrlBytes;
        assembly {
            baseUrlBytes := calldataload(add(offset, 0x40))
        }
        return toString(baseUrlBytes);
    }

    function toString(bytes32 source)
        internal
        pure
        returns (string memory result)
    {
        uint8 length = 0;
        while (source[length] != 0 && length < 32) {
            length++;
        }
        assembly {
            result := mload(0x40)
            // new "memory end" including padding (the string isn't larger than 32 bytes)
            mstore(0x40, add(result, 0x40))
            // store length in memory
            mstore(result, length)
            // write actual data
            mstore(add(result, 0x20), source)
        }
    }
}
