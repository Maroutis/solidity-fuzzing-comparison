// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Properties} from "./Properties.sol";
import {BaseTargetFunctions} from "@chimera/BaseTargetFunctions.sol";
import {IHevm, vm} from "@chimera/Hevm.sol";

abstract contract TargetFunctions is BaseTargetFunctions, Properties {
    function handler_vote(bool inputVote) external {
        vm.prank(msg.sender);
        proposal.vote(inputVote);
        numberOfVotes = numberOfVotes + 1;
    }
}
