// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {NuriBadge100} from "../src/badge/NuriBadge100.sol";
import {NuriBadge200} from "../src/badge/NuriBadge200.sol";
import {NuriBadge500} from "../src/badge/NuriBadge500.sol";
import {NuriBadge1000} from "../src/badge/NuriBadge1000.sol";
import {NuriBadge5000} from "../src/badge/NuriBadge5000.sol";
import {NuriBadge10000} from "../src/badge/NuriBadge10000.sol";

contract DeployBadge2 is Script {
    uint256 DEPLOYER_PRIVATE_KEY = vm.envUint("DEPLOYER_PRIVATE_KEY");

    function run() external {
        vm.startBroadcast(DEPLOYER_PRIVATE_KEY);
        NuriBadge100 nuriBadge100 = new NuriBadge100(
            0x4560FECd62B14A463bE44D40fE5Cfd595eEc0113,
            0xAAAEa1fB9f3DE3F70E89f37B69Ab11B47eb9Ce6F,
            "https://raw.githubusercontent.com/RamsesExchange/nuri-canvas-contracts/master/badge100.json"
        );
        console.log(address(nuriBadge100));

        NuriBadge200 nuriBadge200 = new NuriBadge200(
            0x4560FECd62B14A463bE44D40fE5Cfd595eEc0113,
            0xAAAEa1fB9f3DE3F70E89f37B69Ab11B47eb9Ce6F,
            "https://raw.githubusercontent.com/RamsesExchange/nuri-canvas-contracts/master/badge200.json"
        );
        console.log(address(nuriBadge200));

        NuriBadge500 nuriBadge500 = new NuriBadge500(
            0x4560FECd62B14A463bE44D40fE5Cfd595eEc0113,
            0xAAAEa1fB9f3DE3F70E89f37B69Ab11B47eb9Ce6F,
            "https://raw.githubusercontent.com/RamsesExchange/nuri-canvas-contracts/master/badge500.json"
        );
        console.log(address(nuriBadge500));

        NuriBadge1000 nuriBadge1000 = new NuriBadge1000(
            0x4560FECd62B14A463bE44D40fE5Cfd595eEc0113,
            0xAAAEa1fB9f3DE3F70E89f37B69Ab11B47eb9Ce6F,
            "https://raw.githubusercontent.com/RamsesExchange/nuri-canvas-contracts/master/badge1000.json"
        );
        console.log(address(nuriBadge1000));

        NuriBadge5000 nuriBadge5000 = new NuriBadge5000(
            0x4560FECd62B14A463bE44D40fE5Cfd595eEc0113,
            0xAAAEa1fB9f3DE3F70E89f37B69Ab11B47eb9Ce6F,
            "https://raw.githubusercontent.com/RamsesExchange/nuri-canvas-contracts/master/badge5000.json"
        );
        console.log(address(nuriBadge5000));

        NuriBadge10000 nuriBadge10000 = new NuriBadge10000(
            0x4560FECd62B14A463bE44D40fE5Cfd595eEc0113,
            0xAAAEa1fB9f3DE3F70E89f37B69Ab11B47eb9Ce6F,
            "https://raw.githubusercontent.com/RamsesExchange/nuri-canvas-contracts/master/badge10000.json"
        );
        console.log(address(nuriBadge10000));
        vm.stopBroadcast();
    }
}
