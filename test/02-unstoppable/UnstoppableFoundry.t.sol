// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "../../src/02-unstoppable/UnstoppableLender.sol";
import "../../src/02-unstoppable/ReceiverUnstoppable.sol";

import "../../src/TestToken.sol";
import {Test} from "forge-std/Test.sol";

// run from base project directory with:
// forge test --match-contract UnstoppableFoundry
// (if an invariant fails add -vvvvv on the end to see what failed)
//
// get coverage report (see https://medium.com/@rohanzarathustra/forge-coverage-overview-744d967e112f):
//
// 1) forge coverage --report lcov --report-file test/02-unstoppable/coverage-foundry.lcov --match-contract UnstoppableFoundry
// 2) genhtml test/02-unstoppable/coverage-foundry.lcov -o test/02-unstoppable/coverage-foundry
// 3) open test/02-unstoppable/coverage-foundry/index.html in your browser and
//    navigate to the relevant source file to see line-by-line execution records
contract UnstoppableFoundry is Test {
    // initial tokens in pool
    uint256 constant INIT_TOKENS_POOL = 1000000e18;
    uint256 constant RECEIVER_TOKENS = 100e18;
    // initial tokens attacker
    uint256 constant INIT_TOKENS_ATTACKER = 100e18;

    // contracts required for test
    ERC20 token;
    UnstoppableLender pool;
    ReceiverUnstoppable receiver;
    address attacker = address(0x41747461636b6572000000000000000000000000); // address(bytes20("Attacker"))

    // constructor has to be payable if balanceContract > 0 in yaml config
    function setUp() public {
        // setup contracts to be tested
        token = new TestToken(INIT_TOKENS_POOL + INIT_TOKENS_ATTACKER + RECEIVER_TOKENS, 18);
        pool = new UnstoppableLender(address(token));
        receiver = new ReceiverUnstoppable(payable(address(pool)));

        // transfer deposit initial tokens into pool
        token.approve(address(pool), INIT_TOKENS_POOL);
        pool.depositTokens(INIT_TOKENS_POOL);

        // transfer tokens to receiver
        token.transfer(address(receiver), RECEIVER_TOKENS);

        // transfer remaining tokens to the attacker
        token.transfer(attacker, INIT_TOKENS_ATTACKER);

        // only one attacker
        targetSender(attacker);
    }

    // Pool balance should not decrease
    function invariant_pool_balance_cannot_decrease() public {
        assert(token.balanceOf(address(pool)) >= INIT_TOKENS_POOL);
    }

    //  There are no flashloan fees, the balance of the receiver cannot decrease
    function invariant_receiver_balance_cannot_decrease() public {
        assert(token.balanceOf(address(receiver)) >= RECEIVER_TOKENS);
    }

    // invariant #1 very generic but harder to break
    function invariant_receiver_can_take_flash_loan() public {
        receiver.executeFlashLoan(10);
        assert(true);
    }

    // invariant #2 more specific, should be easier to break
    function invariant_pool_bal_equal_token_pool_bal() public view {
        assert(pool.poolBalance() == token.balanceOf(address(pool)));
    }
}
