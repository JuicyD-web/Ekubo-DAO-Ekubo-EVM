// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title IPoolFactory
/// @notice Interface for the Ekubo Pool Factory
interface IPoolFactory {
    /// @notice Emitted when a pool is created
    event PoolCreated(
        address indexed token0,
        address indexed token1,
        uint24 indexed fee,
        int24 tickSpacing,
        address pool
    );

    /// @notice Emitted when a new fee tier is enabled
    event FeeAmountEnabled(uint24 indexed fee, int24 indexed tickSpacing);

    /// @notice Emitted when ownership changes
    event OwnerChanged(address indexed oldOwner, address indexed newOwner);

    /// @notice Returns the current owner
    function owner() external view returns (address);

    /// @notice Returns the tick spacing for a given fee tier
    function feeAmountTickSpacing(uint24 fee) external view returns (int24);

    /// @notice Returns the pool address for a token pair and fee
    function getPool(
        address tokenA,
        address tokenB,
        uint24 fee
    ) external view returns (address pool);

    /// @notice Deployment parameters struct
    function parameters()
        external
        view
        returns (
            address factory,
            address token0,
            address token1,
            uint24 fee,
            int24 tickSpacing
        );

    /// @notice Creates a new pool
    function createPool(
        address tokenA,
        address tokenB,
        uint24 fee
    ) external returns (address pool);

    /// @notice Sets the owner
    function setOwner(address _owner) external;

    /// @notice Enables a new fee tier
    function enableFeeAmount(uint24 fee, int24 tickSpacing) external;
}
