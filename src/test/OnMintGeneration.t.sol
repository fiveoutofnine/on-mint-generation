// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import "ds-test/test.sol";

import { OnMintGeneration } from "../OnMintGeneration.sol";

contract ERC721WithOnMintGenerationTest is DSTest {
    uint256 public constant TRAIT_1_CPW = 0xFFDEBD9D7E60402007;
    uint256 public constant TRAIT_2_CPW = 0x00FDF5EBE9D9D8D1C5B8B4A7938E8A68584E2B1F12;
    uint256 public constant TRAIT_3_CPW = 0xFDF4E8E0DBD4D0CCC9C6C4C2BBB2AEABA19793897F77726B5B58524C4A463E1E;
    uint256 public constant TRAIT_4_CPW = 0xFFFAF5EBE6DEDAD2CFC3BBB6AFAAA8A399918D877F787569686158534B45431E;
    uint256 public constant TRAIT_5_CPW = 0xFFF7F1E3DAC7C1B3AAA8A29E948C897F736135341E170C16;
    uint256 public constant TRAIT_6_CPW = 0xFFF8F4EBE5DFD8D0CDCBC9B6A8A2A19E9D9B9A8E8B89605F5B59575643403D1E;
    uint256 public constant TRAIT_7_CPW = 0xFFEAD4C9BDB7B306;

    function setUp() public {}

    function testGenerateRandomNumber(uint256 _nonce) public {
        OnMintGeneration.generateRandomNumber(_nonce);
    }

    function testTrait1Cpw(uint256 _seed) public {
        OnMintGeneration.selectRandomTrait(TRAIT_1_CPW, _seed);
    }

    function testTrait2Cpw(uint256 _seed) public {
        OnMintGeneration.selectRandomTrait(TRAIT_2_CPW, _seed);
    }

    function testTrait3Cpw(uint256 _seed) public {
        OnMintGeneration.selectRandomTrait(TRAIT_3_CPW, _seed);
    }

    function testTrait4Cpw(uint256 _seed) public {
        OnMintGeneration.selectRandomTrait(TRAIT_4_CPW, _seed);
    }

    function testTrait5Cpw(uint256 _seed) public {
        OnMintGeneration.selectRandomTrait(TRAIT_5_CPW, _seed);
    }

    function testTrait6Cpw(uint256 _seed) public {
        OnMintGeneration.selectRandomTrait(TRAIT_6_CPW, _seed);
    }

    function testTrait7Cpw(uint256 _seed) public {
        OnMintGeneration.selectRandomTrait(TRAIT_7_CPW, _seed);
    }

    function testGenerateRandomMetadata(uint256 _nonce) public {
        uint256 seed = OnMintGeneration.generateRandomNumber(_nonce);
        OnMintGeneration.selectRandomTrait(TRAIT_1_CPW, seed) << 30
            | OnMintGeneration.selectRandomTrait(TRAIT_2_CPW, seed >> 8) << 25
            | OnMintGeneration.selectRandomTrait(TRAIT_3_CPW, seed >> 0x10) << 20
            | OnMintGeneration.selectRandomTrait(TRAIT_4_CPW, seed >> 0x18) << 15
            | OnMintGeneration.selectRandomTrait(TRAIT_5_CPW, seed >> 0x20) << 10
            | OnMintGeneration.selectRandomTrait(TRAIT_6_CPW, seed >> 0x28) << 5
            | OnMintGeneration.selectRandomTrait(TRAIT_7_CPW, seed >> 0x30);
    }
}
