// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {NuriBadge} from "../src/badge/NuriBadge.sol";

contract DeployBadge is Script {
    uint256 DEPLOYER_PRIVATE_KEY = vm.envUint("DEPLOYER_PRIVATE_KEY");

    function run() external {
        vm.startBroadcast(DEPLOYER_PRIVATE_KEY);
        NuriBadge nuriBadge = new NuriBadge(
            0xf61B5dAe16948F0f1ed9141634E4647bBaAa4A81,
            0xAAAEa1fB9f3DE3F70E89f37B69Ab11B47eb9Ce6F,
            "https://github.com/RamsesExchange/nuri-canvas-contracts/blob/master/badge.json"
        );
        console.log(address(nuriBadge));
        vm.stopBroadcast();

    }
}
