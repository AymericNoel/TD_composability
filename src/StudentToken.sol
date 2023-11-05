// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;
pragma abicoder v2;

import "./IStudentToken.sol";
import "./EvaluatorToken.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@uniswap/v3-core/contracts/interfaces/INonfungiblePositionManager.sol";
import "@uniswap/v3-periphery/contracts/interfaces/INonfungiblePositionManager.sol";
import "@uniswap/v3-periphery/contracts/interfaces/INonfungiblePositionManager.sol";

contract StudentToken is ERC20, IStudentToken {
    address public constant routerAddress =
        0xE592427A0AEce92De3Edee1F18E0157C05861564;
    ISwapRouter public immutable swapRouter = ISwapRouter(routerAddress);
    IERC20 public wethToken = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2); // Example address for WETH on the Ethereum mainnet
    uint24 public constant poolFee = 3000;

    constructor() ERC20("DominikToken", "DTK") {        
        uint256 decimals = decimals();
        uint256 multiplicator = 10 ** decimals;
        uint valueToMint = 100000 * multiplicator;
        _mint(msg.sender, valueToMint);
    }

      function approveEvaluator(Evaluator evaluatorTokenAddress, uint256 amountToMint) public returns(bool) {
        _approve(address(this), address(evaluatorTokenAddress), amountToMint);
        return true;
      }

      function swapRewardToken(address tokenIn, address tokenOut, uint256 amountOut, uint256 amountInMaximum)
        external
        returns (uint256 amountOut)
    {
        IERC20 inToken = IERC20(tokenIn);
        inToken.approve(address(swapRouter), amountInMaximum);        

        ISwapRouter.ExactOutputSingleParams memory params = ISwapRouter
            .ExactOutputSingleParams({
                tokenIn: tokenIn,
                tokenOut: tokenOut,
                fee: poolFee,
                recipient: address(this),
                deadline: block.timestamp,
                amountOut: amountOut,
                amountInMaximum: amountInMaximum,
                sqrtPriceLimitX96: 0
            });

        amountIn = swapRouter.exactOutputSingle(params);

        if (amountIn < amountInMaximum) {
            inToken.approve(address(swapRouter), 0);      
            inToken.transfer(address(this), amountInMaximum - amountIn);
        }
    }

    function approveRewardToken(RewardToken rewardTokenAddress, uint256 amountToMint) public returns(bool) {
        _approve(address(this), address(rewardTokenAddress), amountToMint);
        return true;
      }

    function createLiquidityPool(uint256 amountDTK, uint256 amountWETH, uint256 tickLower, uint256 tickUpper) external {
      require(msg.sender == owner, "Only the owner can create a liquidity pool");

        _approve(address(nonfungiblePositionManager), amountDTK);
        wethToken.approve(address(nonfungiblePositionManager), amountWETH);

        // Create the liquidity position
        (uint256 tokenId, , , , , , ) = nonfungiblePositionManager.mint(
            INonfungiblePositionManager.MintParams({
                token0: address(DTK),
                token1: address(WETH),
                tickLower: int24(tickLower),
                tickUpper: int24(tickUpper),
                amount0Desired: amountDTK,
                amount1Desired: amountWETH,
                amount0Min: 0,
                amount1Min: 0,
                recipient: address(this),
                deadline: block.timestamp + 600
            })
        );
    }
}
