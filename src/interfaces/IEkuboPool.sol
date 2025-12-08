// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title IEkuboPool
/// @notice Interface for the Ekubo AMM Pool
interface IEkuboPool {
    /// @notice Emitted when the pool is initialized
    event Initialize(uint160 sqrtPriceX96, int24 tick);

    /// @notice Emitted when liquidity is minted
    event Mint(
        address sender,
        address indexed owner,
        int24 indexed tickLower,
        int24 indexed tickUpper,
        uint128 amount,
        uint256 amount0,
        uint256 amount1
    );

    /// @notice Emitted when liquidity is burned
    event Burn(
        address indexed owner,
        int24 indexed tickLower,
        int24 indexed tickUpper,
        uint128 amount,
        uint256 amount0,
        uint256 amount1
    );

    /// @notice Emitted when a swap is executed
    event Swap(
        address indexed sender,
        address indexed recipient,
        int256 amount0,
        int256 amount1,
        uint160 sqrtPriceX96,
        uint128 liquidity,
        int24 tick
    );

    /// @notice Emitted when fees are collected
    event Collect(
        address indexed owner,
        address recipient,
        int24 indexed tickLower,
        int24 indexed tickUpper,
        uint128 amount0,
        uint128 amount1
    );

    /// @notice Emitted when a flash loan is executed
    event Flash(
        address indexed sender,
        address indexed recipient,
        uint256 amount0,
        uint256 amount1,
        uint256 paid0,
        uint256 paid1
    );

    /// @notice The first token of the pool
    function token0() external view returns (address);

    /// @notice The second token of the pool
    function token1() external view returns (address);

    /// @notice The fee tier of the pool in hundredths of a bip
    function fee() external view returns (uint24);

    /// @notice The tick spacing of the pool
    function tickSpacing() external view returns (int24);

    /// @notice The maximum liquidity per tick
    function maxLiquidityPerTick() external view returns (uint128);

    /// @notice The pool's current price and tick state
    function slot0()
        external
        view
        returns (
            uint160 sqrtPriceX96,
            int24 tick,
            uint16 observationIndex,
            uint16 observationCardinality,
            uint16 observationCardinalityNext,
            uint8 feeProtocol,
            bool unlocked
        );

    /// @notice Global fee growth for token0
    function feeGrowthGlobal0X128() external view returns (uint256);

    /// @notice Global fee growth for token1
    function feeGrowthGlobal1X128() external view returns (uint256);

    /// @notice Protocol fees accumulated
    function protocolFees() external view returns (uint128 token0, uint128 token1);

    /// @notice Current liquidity in the pool
    function liquidity() external view returns (uint128);

    /// @notice Initializes the pool with a starting price
    function initialize(uint160 sqrtPriceX96) external;

    /// @notice Adds liquidity to a position
    function mint(
        address recipient,
        int24 tickLower,
        int24 tickUpper,
        uint128 amount,
        bytes calldata data
    ) external returns (uint256 amount0, uint256 amount1);

    /// @notice Removes liquidity from a position
    function burn(
        int24 tickLower,
        int24 tickUpper,
        uint128 amount
    ) external returns (uint256 amount0, uint256 amount1);

    /// @notice Executes a swap
    function swap(
        address recipient,
        bool zeroForOne,
        int256 amountSpecified,
        uint160 sqrtPriceLimitX96,
        bytes calldata data
    ) external returns (int256 amount0, int256 amount1);

    /// @notice Collects fees owed to a position
    function collect(
        address recipient,
        int24 tickLower,
        int24 tickUpper,
        uint128 amount0Requested,
        uint128 amount1Requested
    ) external returns (uint128 amount0, uint128 amount1);

    /// @notice Executes a flash loan
    function flash(
        address recipient,
        uint256 amount0,
        uint256 amount1,
        bytes calldata data
    ) external;
}
