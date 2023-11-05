// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Evaluator} from "../src/EvaluatorToken.sol";
import {RewardToken} from "../src/RewardToken.sol";
import {StudentToken} from "../src/StudentToken.sol";
import {StudentNft} from "../src/StudentNft.sol";

contract DeploymentScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);  
        new StudentNft();
        vm.stopBroadcast();
    }
}
