# Deployment Script Instructions

This folder contains deployment and utility scripts for the Ekubo Protocol EVM implementation.

## How to Use Deploy.s.sol

1. **Replace `YourContract`**  
   - In `Deploy.s.sol`, change `YourContract` to the name of the contract you want to deploy (e.g., `EkuboCore`, etc.).
   - Update the import path if your contract is not in `src/base/`.

2. **Add Constructor Arguments**  
   - If your contract requires constructor arguments, provide them in the `new YourContract(/* constructor args */)` line.

## Example:
```solidity
import {EkuboCore} from "../src/core/EkuboCore.sol";

contract Deploy is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        // Deploy the EkuboCore contract with constructor arguments
        EkuboCore deployed = new EkuboCore(arg1, arg2);
        vm.stopBroadcast();
    }
}
```
- Replace `arg1, arg2` with the actual arguments required by your contract's constructor.

3. **Run the Script**  
   - Open your terminal in the repo root.
   - Run the deployment script using Forge:
     ```bash
     forge script script/Deploy.s.sol --rpc-url <YOUR_RPC_URL> --broadcast
     ```
   - Replace `<YOUR_RPC_URL>` with your Ethereum node or testnet RPC endpoint.

4. **Verify Deployment**  
   - Check the output for the deployed contract address and transaction details.

## Notes

- You can create additional scripts for other deployment or utility tasks as needed.
- Always review and update constructor arguments and import paths to match your contract structure.

**Last Updated:** December 4, 2025