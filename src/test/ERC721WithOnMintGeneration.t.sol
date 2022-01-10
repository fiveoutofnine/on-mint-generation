// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import "ds-test/test.sol";

import { ERC721WithOnMintGeneration } from "../ERC721WithOnMintGeneration.sol";

contract ERC721WithOnMintGenerationTest is DSTest {
    ERC721WithOnMintGeneration token;

    function setUp() public {
        token = new ERC721WithOnMintGeneration();
        token.mint();
    }

    function testMint() public {
        token.mint();
    }
}
