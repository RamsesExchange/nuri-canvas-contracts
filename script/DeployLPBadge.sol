// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {NuriNativeLP} from "../src/badge/NuriNativeLP.sol";

contract DeployLPBadge is Script {
    uint256 DEPLOYER_PRIVATE_KEY = vm.envUint("DEPLOYER_PRIVATE_KEY");

    function run() external {
        vm.startBroadcast(DEPLOYER_PRIVATE_KEY);
        NuriNativeLP nurinativelp = new NuriNativeLP(
            0x4560FECd62B14A463bE44D40fE5Cfd595eEc0113,
            "https://raw.githubusercontent.com/RamsesExchange/nuri-canvas-contracts/master/badgeNuriETH.json"
        );
        console.log(address(nurinativelp));

        vm.stopBroadcast();
    }
}
