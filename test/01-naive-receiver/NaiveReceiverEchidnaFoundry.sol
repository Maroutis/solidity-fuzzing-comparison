// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { TargetFunctions } from "./TargetFunctions.sol";
import { FoundryAsserts } from "@chimera/FoundryAsserts.sol";
import { Test } from "forge-std/Test.sol";

// run from base project directory with:
// forge test --match-contract NaiveReceiverEchidnaFoundry
// (if an invariant fails add -vvvvv on the end to see what failed)
//
// get coverage report (see https://medium.com/@rohanzarathustra/forge-coverage-overview-744d967e112f):
//
// 1) forge coverage --report lcov --report-file test/01-naive-receiver/coverage-foundry.lcov --match-contract NaiveReceiverEchidnaFoundry
// 2) genhtml test/01-naive-receiver/coverage-foundry.lcov -o test/01-naive-receiver/coverage-foundry
// 3) open test/01-naive-receiver/coverage-foundry/index.html in your browser and
//    navigate to the relevant source file to see line-by-line execution records

contract NaiveReceiverEchidnaFoundry is Test, TargetFunctions, FoundryAsserts {
    function setUp() public {
      setup();

      // Foundry doesn't use config files but does
      // the setup programmatically here

      // target the fuzzer on this contract as it will
      // contain the handler functions
      targetContract(address(this));

      // handler functions to target during invariant tests
      bytes4[] memory selectors = new bytes4[](1);
      selectors[0] = this.handler_flashLoan.selector;

      targetSelector(FuzzSelector({ addr: address(this), selectors: selectors }));
    }

    // wrap every "property_*" invariant function into
    // a Foundry-style "invariant_*" function
    function invariant_pool_balance_cannot_decrease() public {
      assertTrue(property_pool_balance_cannot_decrease());
    }
    function invariant_property_receiver_balance_cannot_decrease() public {
        assertTrue(property_receiver_balance_cannot_decrease());
      }
      function invariant_receiver_balance_cannot_be_zero() public {
        assertTrue(property_receiver_balance_cannot_be_zero());
      }
}
