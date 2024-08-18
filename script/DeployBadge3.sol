// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {NuriBadge20000} from "../src/badge/NuriBadge20000.sol";
import {NuriBadge30000} from "../src/badge/NuriBadge30000.sol";
import {NuriBadge50000} from "../src/badge/NuriBadge50000.sol";

contract DeployBadge2 is Script {
    uint256 DEPLOYER_PRIVATE_KEY = vm.envUint("DEPLOYER_PRIVATE_KEY");

    function run() external {
        vm.startBroadcast(DEPLOYER_PRIVATE_KEY);
        NuriBadge20000 nuriBadge20000 = new NuriBadge20000(
            0x4560FECd62B14A463bE44D40fE5Cfd595eEc0113,
            0xAAAEa1fB9f3DE3F70E89f37B69Ab11B47eb9Ce6F,
            "https://raw.githubusercontent.com/RamsesExchange/nuri-canvas-contracts/master/badge20000.json"
        );
        console.log(address(nuriBadge20000));

        NuriBadge30000 nuriBadge30000 = new NuriBadge30000(
            0x4560FECd62B14A463bE44D40fE5Cfd595eEc0113,
            0xAAAEa1fB9f3DE3F70E89f37B69Ab11B47eb9Ce6F,
            "https://raw.githubusercontent.com/RamsesExchange/nuri-canvas-contracts/master/badge30000.json"
        );
        console.log(address(nuriBadge30000));

        NuriBadge50000 nuriBadge50000 = new NuriBadge50000(
            0x4560FECd62B14A463bE44D40fE5Cfd595eEc0113,
            0xAAAEa1fB9f3DE3F70E89f37B69Ab11B47eb9Ce6F,
            "https://raw.githubusercontent.com/RamsesExchange/nuri-canvas-contracts/master/badge50000.json"
        );
        console.log(address(nuriBadge50000));

            NuriBadge50000 nuriBadge50000animated = new NuriBadge50000(
            0x4560FECd62B14A463bE44D40fE5Cfd595eEc0113,
            0xAAAEa1fB9f3DE3F70E89f37B69Ab11B47eb9Ce6F,
            "https://raw.githubusercontent.com/RamsesExchange/nuri-canvas-contracts/master/badge50000-animated.json"
        );
        console.log(address(nuriBadge50000animated));
        vm.stopBroadcast();
    }
}
