// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >0.8.0;

import "./tokens/ERC721.sol";
// import "@openzeppelin/contracts/utils/Strings.sol";

import { OnMintGeneration } from "./OnMintGeneration.sol";

/// @title `ERC721` with on-mint generation.
/// @author fiveoutofnine
/// @notice An example of an ERC721 token with on-mint generation from 7 traits (taken from BAYC;
/// see details below).
/// @dev Inherits @rari-capital/solmate's `ERC721` implementation.
contract ERC721WithOnMintGeneration is ERC721 {
    // The following trait probabilities were taken from BAYC. Properties 3, 4, 6 had more than 31
    // traits, so some were ommitted. Additionally, the probabilities were normalized to sum to less
    // than or equal to 255. See {OnMintGeneration-selectRandomTrait} for more information.
    //         | Trait 1          | Trait 2          | Trait 3          | Trait 4          |
    //         | ================ | ================ | ================ | ================ |
    //         | PW  | %    | CPW | PW  | %    | CPW | PW  | %    | CPW | PW  | %    | CPW |
    //         | --- | ---- | --- | --- | ---- | --- | --- | ---- | --- | --- | ---- | --- |
    //         | 32  | 12.5 | 32  | 31  | 12.3 | 31  | 62  | 24.5 | 62  | 67  | 26.3 | 67  |
    //         | 32  | 12.5 | 64  | 12  | 4.7  | 43  | 8   | 3.2  | 70  | 2   | 0.8  | 69  |
    //         | 32  | 12.5 | 96  | 35  | 13.8 | 78  | 4   | 1.6  | 74  | 6   | 2.4  | 75  |
    //         | 30  | 11.8 | 126 | 10  | 4.0  | 88  | 2   | 0.8  | 76  | 8   | 3.1  | 83  |
    //         | 31  | 12.2 | 157 | 16  | 6.3  | 104 | 6   | 2.4  | 82  | 5   | 2.0  | 88  |
    //         | 32  | 12.5 | 189 | 34  | 13.4 | 138 | 6   | 2.4  | 88  | 9   | 3.5  | 97  |
    //         | 33  | 12.9 | 222 | 4   | 1.6  | 142 | 3   | 1.2  | 91  | 7   | 2.7  | 104 |
    //         | 33  | 12.9 | 255 | 5   | 2.0  | 147 | 16  | 6.3  | 107 | 1   | 0.4  | 105 |
    //         |     |      |     | 20  | 7.9  | 167 | 7   | 2.8  | 114 | 12  | 4.7  | 117 |
    //         |     |      |     | 13  | 5.1  | 180 | 5   | 2.0  | 119 | 3   | 1.2  | 120 |
    //         |     |      |     | 4   | 1.6  | 184 | 8   | 3.2  | 127 | 7   | 2.7  | 127 |
    //         |     |      |     | 13  | 5.1  | 197 | 10  | 4.0  | 137 | 8   | 3.1  | 135 |
    //         |     |      |     | 12  | 4.7  | 209 | 10  | 4.0  | 147 | 6   | 2.4  | 141 |
    //         |     |      |     | 7   | 2.8  | 216 | 4   | 1.6  | 151 | 4   | 1.6  | 145 |
    //         |     |      |     | 1   | 0.4  | 217 | 10  | 4.0  | 161 | 8   | 3.1  | 153 |
    //         |     |      |     | 16  | 6.3  | 233 | 10  | 4.0  | 171 | 10  | 3.9  | 163 |
    //         |     |      |     | 2   | 0.8  | 235 | 3   | 1.2  | 174 | 5   | 2.0  | 168 |
    //         |     |      |     | 10  | 4.0  | 245 | 4   | 1.6  | 178 | 2   | 0.8  | 170 |
    //         |     |      |     | 8   | 3.2  | 253 | 9   | 3.6  | 187 | 5   | 2.0  | 175 |
    //         |     |      |     |     |      |     | 7   | 2.8  | 194 | 7   | 2.7  | 182 |
    //         |     |      |     |     |      |     | 2   | 0.8  | 196 | 5   | 2.0  | 187 |
    //         |     |      |     |     |      |     | 2   | 0.8  | 198 | 8   | 3.1  | 195 |
    //         |     |      |     |     |      |     | 3   | 1.2  | 201 | 12  | 4.7  | 207 |
    //         |     |      |     |     |      |     | 3   | 1.2  | 204 | 3   | 1.2  | 210 |
    //         |     |      |     |     |      |     | 4   | 1.6  | 208 | 8   | 3.1  | 218 |
    //         |     |      |     |     |      |     | 4   | 1.6  | 212 | 4   | 1.6  | 222 |
    //         |     |      |     |     |      |     | 7   | 2.8  | 219 | 8   | 3.1  | 230 |
    //         |     |      |     |     |      |     | 5   | 2.0  | 224 | 5   | 2.0  | 235 |
    //         |     |      |     |     |      |     | 8   | 3.2  | 232 | 10  | 3.9  | 245 |
    //         |     |      |     |     |      |     | 12  | 4.7  | 244 | 5   | 2.0  | 250 |
    //         |     |      |     |     |      |     | 9   | 3.6  | 253 | 5   | 2.0  | 255 |
    //         | ========================================================================= |
    //                  | Trait 5          | Trait 6          | Trait 7          |
    //                  | ================ | ================ | ================ |
    //                  | PW  | %    | CPW | PW  | %    | CPW | PW  | %    | CPW |
    //                  | --- | ---- | --- | --- | ---- | --- | --- | ---- | --- |
    //                  | 12  | 4.7  | 12  | 61  | 23.9 | 61  | 179 | 70.2 | 179 |
    //                  | 11  | 4.3  | 23  | 3   | 1.2  | 64  | 4   | 1.6  | 183 |
    //                  | 7   | 2.7  | 30  | 3   | 1.2  | 67  | 6   | 2.4  | 189 |
    //                  | 22  | 8.6  | 52  | 19  | 7.5  | 86  | 12  | 4.7  | 201 |
    //                  | 1   | 0.4  | 53  | 1   | 0.4  | 87  | 11  | 4.3  | 212 |
    //                  | 44  | 17.3 | 97  | 2   | 0.8  | 89  | 22  | 8.6  | 234 |
    //                  | 18  | 7.1  | 115 | 2   | 0.8  | 91  | 21  | 8.2  | 255 |
    //                  | 12  | 4.7  | 127 | 4   | 1.6  | 95  |     |      |     |
    //                  | 10  | 3.9  | 137 | 1   | 0.4  | 96  |     |      |     |
    //                  | 3   | 1.2  | 140 | 41  | 16.1 | 137 |     |      |     |
    //                  | 8   | 3.1  | 148 | 2   | 0.8  | 139 |     |      |     |
    //                  | 10  | 3.9  | 158 | 3   | 1.2  | 142 |     |      |     |
    //                  | 4   | 1.6  | 162 | 12  | 4.7  | 154 |     |      |     |
    //                  | 6   | 2.4  | 168 | 1   | 0.4  | 155 |     |      |     |
    //                  | 2   | 0.8  | 170 | 2   | 0.8  | 157 |     |      |     |
    //                  | 9   | 3.5  | 179 | 1   | 0.4  | 158 |     |      |     |
    //                  | 14  | 5.5  | 193 | 3   | 1.2  | 161 |     |      |     |
    //                  | 6   | 2.4  | 199 | 1   | 0.4  | 162 |     |      |     |
    //                  | 19  | 7.5  | 218 | 6   | 2.4  | 168 |     |      |     |
    //                  | 9   | 3.5  | 227 | 14  | 5.5  | 182 |     |      |     |
    //                  | 14  | 5.5  | 241 | 19  | 7.5  | 201 |     |      |     |
    //                  | 6   | 2.4  | 247 | 2   | 0.8  | 203 |     |      |     |
    //                  | 8   | 3.1  | 255 | 2   | 0.8  | 205 |     |      |     |
    //                  |     |      |     | 3   | 1.2  | 208 |     |      |     |
    //                  |     |      |     | 8   | 3.1  | 216 |     |      |     |
    //                  |     |      |     | 7   | 2.7  | 223 |     |      |     |
    //                  |     |      |     | 6   | 2.4  | 229 |     |      |     |
    //                  |     |      |     | 6   | 2.4  | 235 |     |      |     |
    //                  |     |      |     | 9   | 3.5  | 244 |     |      |     |
    //                  |     |      |     | 4   | 1.6  | 248 |     |      |     |
    //                  |     |      |     | 7   | 2.7  | 255 |     |      |     |
    uint256 public constant TRAIT_1_CPW 
        = 0xFFDEBD9D7E60402007;
    uint256 public constant TRAIT_2_CPW 
        = 0x00FDF5EBE9D9D8D1C5B8B4A7938E8A68584E2B1F12;
    uint256 public constant TRAIT_3_CPW
        = 0xFDF4E8E0DBD4D0CCC9C6C4C2BBB2AEABA19793897F77726B5B58524C4A463E1E;
    uint256 public constant TRAIT_4_CPW 
        = 0xFFFAF5EBE6DEDAD2CFC3BBB6AFAAA8A399918D877F787569686158534B45431E;
    uint256 public constant TRAIT_5_CPW 
        = 0xFFF7F1E3DAC7C1B3AAA8A29E948C897F736135341E170C16;
    uint256 public constant TRAIT_6_CPW 
        = 0xFFF8F4EBE5DFD8D0CDCBC9B6A8A2A19E9D9B9A8E8B89605F5B59575643403D1E;
    uint256 public constant TRAIT_7_CPW 
        = 0xFFEAD4C9BDB7B306;

    mapping(uint256 => uint256) metadata;
    mapping(uint256 => bool) metadataSeen;

    // Saves ~15_000 gas for the first mint because setting a nonzero slot in storage costs more.
    uint256 public totalSupply = 1;

    constructor() ERC721("OnMintGeneration", "OMG") {/* 😱 */}

    function mint() external {
        uint256 tokenId = totalSupply++;
        _mint(msg.sender, tokenId);

        // There are `8 * 8 * 31 * 31 * 23 * 31 * 7 = 306_966_464` total combinations. With 10_000
        // mints, there is `1 - ∏_{i=1}^{10_000} (306_966_464 - i) / 306_966_464 ≈ 0.15` chance for
        // a duplicate to occur--higher than most would expect! Thus, 2 checks are done: if a
        // duplicate is generated, generate it again with a different nonce. This reduces the
        // probability of a duplicate to 3.54e-6 and 8.64e-11 with the 1st and 2nd checks,
        // respectively.
        uint256 tokenMetadata = generateMetadata(0);
        // 1st duplicate check.
        if (metadataSeen[tokenMetadata]) { tokenMetadata = generateMetadata(1); }
        // 2nd duplicate check.
        if (metadataSeen[tokenMetadata]) { tokenMetadata = generateMetadata(2); }

        // Same as `metadata[tokenId / 7] = (metadata[tokenId / 7] << 35) | tokenMetadata`
        // Note that, because every `uint256` returned by `generateMetadata` has at most 35 bits,
        // we can bitpack 7 of them (`35 * 7 = 245 < 256`) into 1 `uint256`. This is worthwhile
        // because setting a nonzero slot in storage requires 20_000 gas, whereas it only costs
        // 5_000 gas otherwise. i.e., storing the metadata is ~15_000 gas cheaper 6 out of 7 times.
        assembly {
            mstore(0, 7)
            mstore(0x20, div(tokenId, 7))
            let hash := keccak256(0, 0x40)
            sstore(hash, or(shr(sload(hash), 35), tokenMetadata))
        }
        metadataSeen[tokenMetadata] = true;
    }

    function generateMetadata(uint256 _nonce) internal view returns (uint256) {
        uint256 seed = OnMintGeneration.generateRandomNumber(_nonce);
        return OnMintGeneration.selectRandomTrait(TRAIT_1_CPW, seed) << 30
            | OnMintGeneration.selectRandomTrait(TRAIT_2_CPW, seed >> 8) << 25
            | OnMintGeneration.selectRandomTrait(TRAIT_3_CPW, seed >> 16) << 20
            | OnMintGeneration.selectRandomTrait(TRAIT_4_CPW, seed >> 24) << 15
            | OnMintGeneration.selectRandomTrait(TRAIT_5_CPW, seed >> 32) << 10
            | OnMintGeneration.selectRandomTrait(TRAIT_6_CPW, seed >> 40) << 5
            | OnMintGeneration.selectRandomTrait(TRAIT_7_CPW, seed >> 48);
    }

    function tokenURI(uint256 _tokenId) public pure virtual override returns (string memory) {
        /* uint256 tokenMetadata = metadata[_tokenId];

        return string(
            abi.encodePacked(
                '{"trait_one":"',
                Strings.toString(tokenMetadata >> 35),
                '","trait_two":"',
                Strings.toString((tokenMetadata >> 25) & 0x1F),
                '","trait_three":"',
                Strings.toString((tokenMetadata >> 20) & 0x1F),
                '","trait_four":"',
                Strings.toString((tokenMetadata >> 15) & 0x1F),
                '","trait_five":"',
                Strings.toString((tokenMetadata >> 10) & 0x1F),
                '","trait_six":"',
                Strings.toString((tokenMetadata >> 5) & 0x1F),
                '","trait_seven":"',
                Strings.toString(tokenMetadata & 0x1F),
                '"}'
            )
        ); */
    }
}
