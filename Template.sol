// SPDX-License-Identifier: MIT
// Fragnova Simple NFT Template

pragma solidity ^0.8.4;

import "./ERC721A.sol";
import "./Ownable.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract FragnovaNFTTemplate is ERC721A, Initializable, Ownable {
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
        Ownable.bootstrap();

        uint256 offset = _getImmutableVariablesOffset();

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
        return string(abi.encodePacked(nameBytes));
    }

    function symbol() public view virtual override returns (string memory) {
        uint256 offset = _getImmutableVariablesOffset();
        bytes32 symbolBytes;
        assembly {
            symbolBytes := calldataload(add(offset, 0x20))
        }
        return string(abi.encodePacked(symbolBytes));
    }

    function _baseURI() internal pure override returns (string memory _url) {
        uint256 offset = _getImmutableVariablesOffset();
        bytes32 baseUrlBytes;
        assembly {
            baseUrlBytes := calldataload(add(offset, 0x40))
        }
        return string(abi.encodePacked(baseUrlBytes));
    }
}
