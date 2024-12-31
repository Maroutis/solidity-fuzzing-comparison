// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Properties} from "./Properties.sol";
import {BaseTargetFunctions} from "@chimera/BaseTargetFunctions.sol";
import {IHevm, vm} from "@chimera/Hevm.sol";

abstract contract TargetFunctions is BaseTargetFunctions, Properties {
    function handler_flashLoan(uint256 borrowAmount) external {
        //
        // note: using `between` provided by Chimera instead of
        // Foundry's `bound` for cross-fuzzer compatibility
        borrowAmount = between(borrowAmount, 0, address(pool).balance);

        // vm.prank(msg.sender);
        pool.flashLoan(address(receiver), borrowAmount);
    }
}
