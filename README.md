# ERC721 With On-Mint Generation
An example of an ERC721 token with efficient on-mint generation from 7 traits (taken from BAYC; see 
details below).

Note that code written for this example has not been audited.

# Gas Usage
```
>>> forge test --optimize-runs 0
compiling...
success.
Running 1 test for "ERC721WithOnMintGenerationTest.json":ERC721WithOnMintGenerationTest
[PASS] testMint() (gas: 66211)

Running 9 tests for ERC721WithOnMintGenerationTest
[PASS] testGenerateRandomMetadata(uint256) (μ: 9201, ~: 9198)
[PASS] testGenerateRandomNumber(uint256) (μ: 2295, ~: 2297)
[PASS] testTrait1Cpw(uint256) (μ: 1879, ~: 1860)
[PASS] testTrait2Cpw(uint256) (μ: 1972, ~: 1960)
[PASS] testTrait3Cpw(uint256) (μ: 2158, ~: 2174)
[PASS] testTrait4Cpw(uint256) (μ: 2118, ~: 2131)
[PASS] testTrait5Cpw(uint256) (μ: 2045, ~: 2052)
[PASS] testTrait6Cpw(uint256) (μ: 2145, ~: 2155)
[PASS] testTrait7Cpw(uint256) (μ: 1768, ~: 1771)
```
Note that minting will cost ~15,000 gas more if it is an address's first mint, and ~15,000 gas more
1 out of 7 times. In practice, it should cost around 80,000 ~ 110,000 gas to mint a token with
on-mint generation. See
[`{ERC721WithOnMintGeneration-mint}`](https://github.com/fiveoutofnine/on-mint-generation/blob/c65474d33f1477cae8245109c9eeb60b1bfe936b/src/ERC721WithOnMintGeneration.sol#L128)
for more information.

# Traits
The trait probabilities were taken from BAYC. Properties 3, 4, 6 had more than 31 traits, so some
were ommitted. Additionally, the probabilities were normalized to sum to less than or equal to 255.
See
[`{OnMintGeneration-selectRandomTrait}`](https://github.com/fiveoutofnine/on-mint-generation/blob/c65474d33f1477cae8245109c9eeb60b1bfe936b/src/ERC721WithOnMintGeneration.sol#L18)
for more information.

# Constraints
[`selectRandomTrait`](https://github.com/fiveoutofnine/on-mint-generation/blob/c65474d33f1477cae8245109c9eeb60b1bfe936b/src/OnMintGeneration.sol#L34)
has 2 major constraints because `_cpw` is limited to data bitpacked into 1 `uint256` to keep gas
costs low:

1. For a given a property, its traits must sum to less than or equal to 255.
2. A property must have at most 31 traits.

Fortunately, most generative projects to date (Jan. 2022) fit the constraints mentioned above. If
more is desired, work-arounds are possible by splitting up a property's cumulative probability
weightings into more than just 1 `uint256`. See
[`{OnMintGeneration-selectRandomTrait}`](https://github.com/fiveoutofnine/on-mint-generation/blob/c65474d33f1477cae8245109c9eeb60b1bfe936b/src/OnMintGeneration.sol#L19)
for an explanation.

# Using the algorithm
Read through
[ERC721WithOnMintGeneration.sol](https://github.com/fiveoutofnine/on-mint-generation/blob/main/src/ERC721WithOnMintGeneration.sol)
and
[OnMintGeneration.sol](https://github.com/fiveoutofnine/on-mint-generation/blob/main/src/OnMintGeneration.sol)
to understand how the algorithm is implemented first. Then, consider utilizing
[py_utils](https://github.com/fiveoutofnine/on-mint-generation/blob/main/py_utils)
to help:
```py
>>> python3 py_utils/generate_cpws.py
['0xffdebd9d7e60402007', '0xfdf5ebe9d9d8d1c5b8b4a7938e8a68584e2b1f12', '0xfdf4e8e0dbd4d0ccc9c6c4c2bbb2aeaba19793897f77726b5b58524c4a463e1e', '0xfffaf5ebe6dedad2cfc3bbb6afaaa8a399918d877f787569686158534b45431e', '0xfff7f1e3dac7c1b3aaa8a29e948c897f736135341e170c16', '0xfff8f4ebe5dfd8d0cdcbc9b6a8a2a19e9d9b9a8e8b89605f5b59575643403d1e', '0xffead4c9bdb7b306']
```

# Credits
- [@rari-capital/solmate](https://github.com/Rari-Capital/solmate) for an efficient implementation
of ERC721.
