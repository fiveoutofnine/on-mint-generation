// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/// @title On mint generation
/// @author fiveoutofnine
/// @dev `selectRandomTrait` has 2 major constraints because `_cpw` is limited to data bitpacked
/// into 1 `uint256` to keep gas costs low:
///     1. For a given property, its traits must sum to less than or equal to 255.
///     2. A property must have at most 31 traits.
/// Fortunately, most generative projects to date (Jan. 2022) fit the constraints mentioned above.
/// If more is desired, work-arounds are possible by splitting up a property's cumulative
/// probability weightings into more than just 1 `uint256`. Implementation for such solution is not
/// provided.
///
/// `generateRandomNumber` was arbitrarily implemented. Consider changing it as needed for other
/// implementations.
library OnMintGeneration {
    /// @notice Pseudo-randomly selects a trait ID based on `_seed`.
    /// @dev The algorithm is slightly modified binary search algorithm with bit shifts/masks, where
    /// the trait ID is the selected index.
    /// @param _cpw `_cpw` stands for "cumulative probability weighting". The traits' probabilities
    /// must be summed cumulatively, then bitpacked into 8 bit words (increasing right to left).
    /// Thus, the total probability weighting must sum to less than 255 (otherwise it will not fit
    /// in 8 bits). Additionally, the last 8 bits must equal
    /// `(the number of traits to select from) - 1`. Thus, a max of 31 traits can fit.
    ///
    /// An example: `_cpw = 0xF0E0D0C0B0A09080706050403020100E`
    /// For convenience, note that the above is equivalent to
    /// 240, 224, ..., 32, 16, and 14 bit-packed into 1 integer as 8 bit words.
    /// There are 15 traits (15 numbers between 240 and 16; 14 + 1 = 15), and every trait has a
    /// probability weighting of 16.
    /// @param _seed A pseudo-randomly generated number the trait is selected with.
    /// @return A pseudo-randomly selected trait ID.
    function selectRandomTrait(uint256 _cpw, uint256 _seed) internal pure returns (uint256) {
        // The smallest possible trait ID is 0.
        uint256 start;
        uint256 mid;
        // The largest possible trait ID is given by `(the last 8 bits) + 1` (see above).
        uint256 end = _cpw & 0xFF;
        // Bit shift the last 8 bits off after reading necessary information.
        _cpw >>= 8;
        // The seed is normalized to the total probability weighting. In other words,
        // `_cpw >> (end << 3)` evaluates to the first 8 bits of `_cpw`.
        _seed %= (_cpw >> (end << 3));

        uint256 selectedId;
        unchecked {
            // Binary search.
            while (start <= end) {
                mid = (start + end) >> 1;
                if ((_cpw >> (mid << 3)) & 0xFF <= _seed) start = mid + 1;
                else if (mid == 0) return end;
                else (selectedId, end) = (end, mid - 1);
            }
        }

        return selectedId;
    }

    /// @notice Generates a pseudo-random number with parameters that is hard for one entity to
    /// reasonably control.
    /// @param _nonce A nonce hashed as part of the pseudo-random generation.
    /// @return A pseudo-random uint256.
    function generateRandomNumber(uint256 _nonce) internal view returns (uint256) {
        return uint256(
            keccak256(
                abi.encodePacked(
                    msg.sender,
                    tx.gasprice,
                    block.number,
                    block.timestamp,
                    block.difficulty,
                    _nonce
                )
            )
        );
    }
}
