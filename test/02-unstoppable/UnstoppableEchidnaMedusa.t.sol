// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "../../src/02-unstoppable/UnstoppableLender.sol";
import "../../src/02-unstoppable/ReceiverUnstoppable.sol";

import "../../src/TestToken.sol";

// configure solc-select to use compiler version:
// solc-select use 0.8.23 
//
// run from base project directory with:
// echidna --config test/02-unstoppable/echidna.yaml ./ --contract UnstoppableEchidnaMedusa
// medusa --config test/02-unstoppable/medusa.json fuzz
contract UnstoppableEchidnaMedusa {
    
    // initial tokens in pool
    uint256 constant INIT_TOKENS_POOL     = 1000000e18;
    uint256 constant RECEIVER_TOKENS      = 100e18;
    // initial tokens attacker
    uint256 constant INIT_TOKENS_ATTACKER = 100e18;

    // contracts required for test
    TestToken           token;//@note using TestToken with an overriden transfer function for echidna to break the tests
    UnstoppableLender   pool;
    ReceiverUnstoppable receiver;
    address             attacker = address(0x41747461636b6572000000000000000000000000); // address(bytes20("Attacker"))

    // constructor has to be payable if balanceContract > 0 in yaml config
    constructor() payable {
        // setup contracts to be tested
        token    = new TestToken(INIT_TOKENS_POOL + INIT_TOKENS_ATTACKER + RECEIVER_TOKENS, 18);
        pool     = new UnstoppableLender(address(token));
        receiver = new ReceiverUnstoppable(payable(address(pool)));

        // transfer deposit initial tokens into pool
        token.approve(address(pool), INIT_TOKENS_POOL);
        pool.depositTokens(INIT_TOKENS_POOL);

        // transfer tokens to receiver
        token.transfer(address(receiver), RECEIVER_TOKENS);

        // transfer remaining tokens to the attacker
        token.transfer(attacker, INIT_TOKENS_ATTACKER);

        // attacker configured as msg.sender in yaml config
    }

    // Pool balance should not decrease
    function invariant_pool_balance_cannot_decrease() public returns (bool) {
        if(token.balanceOf(address(pool)) >= INIT_TOKENS_POOL) return true;
    }

    //  There are no flashloan fees, the balance of the receiver cannot decrease 
    function invariant_receiver_balance_cannot_decrease() public returns (bool) {
        if(token.balanceOf(address(receiver)) >= RECEIVER_TOKENS) return true;
    }

    // invariant #1 very generic but medusa can still break it even
    // if this is the only invariant
    // Echidna however cannot break this. In order for echidna to break it, the transfer function has to be added into TestToken contarct for it to be added into a sequence. Using ERC20 instead of TestToken is also not good enough
    function invariant_receiver_can_take_flash_loan() public returns (bool) {
        receiver.executeFlashLoan(10);
        return true;
    }

    // invariant #2 is more specific and medusa can easily break it
    // Echidna however cannot break this. In order for echidna to break it, the transfer function has to be added into TestToken contarct for it to be added into a sequence. Using ERC20 instead of TestToken is also not good enough
    function invariant_pool_bal_equal_token_pool_bal() public view returns(bool) {
        return(pool.poolBalance() == token.balanceOf(address(pool)));
    }
}