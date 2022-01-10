# ERC721 With On-Mint Generation
An example of an ERC721 token with efficient on-mint generation from 7 traits (taken from BAYC; see 
details below).

Note that code written for this example has not been audited.

# Gas Usage
```
forge test --optimize-runs 0
compiling...
success.
Running 1 test for "ERC721WithOnMintGenerationTest.json":ERC721WithOnMintGenerationTest
[PASS] testMint() (gas: 65758)

Running 9 tests for ERC721WithOnMintGenerationTest
[PASS] testGenerateRandomMetadata(uint256) (μ: 9192, ~: 9196)
[PASS] testGenerateRandomNumber(uint256) (μ: 2295, ~: 2297)
[PASS] testTrait1Cpw(uint256) (μ: 1873, ~: 1860)
[PASS] testTrait2Cpw(uint256) (μ: 1970, ~: 1960)
[PASS] testTrait3Cpw(uint256) (μ: 2161, ~: 2176)
[PASS] testTrait4Cpw(uint256) (μ: 2121, ~: 2131)
[PASS] testTrait5Cpw(uint256) (μ: 2050, ~: 2086)
[PASS] testTrait6Cpw(uint256) (μ: 2148, ~: 2155)
[PASS] testTrait7Cpw(uint256) (μ: 1769, ~: 1771)
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

# Credits
- [@rari-capital/solmate](https://github.com/Rari-Capital/solmate) for an efficient implementation
of ERC721.
