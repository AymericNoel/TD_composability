// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {IERC20} from  "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "./EvaluatorToken.sol";

interface IStudentToken is IERC20 {
  function approveEvaluator(Evaluator evaluatorTokenAddress, uint256 amountToMint) external returns(bool);
	function createLiquidityPool(uint256 amountDTK, uint256 amountWETH, uint256 tickLower, uint256 tickUpper) external;

  function SwapRewardToken(address tokenIn, address tokenOut, uint256 amountOut, uint256 amountInMaximum) external returns(uint256 amountOut_);
}
