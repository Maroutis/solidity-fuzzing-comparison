// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Setup} from "./Setup.sol";
import {Asserts} from "@chimera/Asserts.sol";

abstract contract Properties is Setup, Asserts {
    // The pool balance cannot be decreased, else it is a big vulnerability
    function invariant_funds_sent_when_proposal_surpasses_quorum() public view returns (bool result) {
        return (
            ((numberOfVotes * 100 / 5) > 51 && address(proposal).balance == 0)
                || ((numberOfVotes * 100 / 5) <= 51 && address(proposal).balance > 0)
        );
    }

    function invariant_funds_are_sent_when_proposal_is_inactive() public view returns (bool result) {
        return (
            (
                proposal.isActive() && address(proposal).balance > 0
                    || !proposal.isActive() && address(proposal).balance == 0
            )
        );
    }
}
