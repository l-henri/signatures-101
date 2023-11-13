// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {ERC20TD} from "src/ERC20TD.sol";
import {Evaluator} from "src/Evaluator.sol";
import {BouncerProxy} from "src/BouncerProxy.sol";
// import {TDSolution} from "src/TDSolution.sol";

contract DeployScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        // vm.startBroadcast(vm.envUint("anvil"));
        ERC20TD token = new ERC20TD("TD-ERC20-101","TD-ERC20-101",0);
        BouncerProxy bouncer = new BouncerProxy();
        Evaluator evaluator = new Evaluator(token, payable(address(bouncer)));
        token.setTeacher(address(evaluator), true);
        vm.stopBroadcast();
    }
}
