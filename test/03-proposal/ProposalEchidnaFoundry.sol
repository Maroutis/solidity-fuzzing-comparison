// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {TargetFunctions} from "./TargetFunctions.sol";
import {FoundryAsserts} from "@chimera/FoundryAsserts.sol";
import {Test} from "forge-std/Test.sol";

// run from base project directory with:
// forge test --match-contract ProposalEchidnaFoundry
// (if an invariant fails add -vvvvv on the end to see what failed)
//
// get coverage report (see https://medium.com/@rohanzarathustra/forge-coverage-overview-744d967e112f):
//
// 1) forge coverage --report lcov --report-file test/03-proposal/coverage-foundry.lcov --match-contract ProposalEchidnaFoundry
// 2) genhtml test/03-proposal/coverage-foundry.lcov -o test/03-proposal/coverage-foundry
// 3) open test/03-proposal/coverage-foundry/index.html in your browser and
//    navigate to the relevant source file to see line-by-line execution records

contract ProposalEchidnaFoundry is Test, TargetFunctions, FoundryAsserts {
    function setUp() public {
        setup();

        // Foundry doesn't use config files but does
        // the setup programmatically here

        // target the fuzzer on this contract as it will
        // contain the handler functions
        targetContract(address(this));

        // handler functions to target during invariant tests
        bytes4[] memory selectors = new bytes4[](1);
        selectors[0] = this.handler_vote.selector;

        targetSelector(FuzzSelector({addr: address(this), selectors: selectors}));

        // constrain fuzz test senders to the set of allowed voting addresses
        for(uint256 i; i<allowlist.length; ++i) {
          targetSender(allowlist[i]);
      }
    }

    // wrap every "property_*" invariant function into
    // a Foundry-style "invariant_*" function
    function invariant_funds_sent_when_proposal_surpasses_quorum_f() public view {
        assertTrue(invariant_funds_sent_when_proposal_surpasses_quorum());
    }

    function invariant_funds_are_sent_when_proposal_is_inactive_f() public view {
        assertTrue(invariant_funds_are_sent_when_proposal_is_inactive());
    }
}
