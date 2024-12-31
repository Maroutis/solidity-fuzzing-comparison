// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {NaiveReceiverLenderPool} from "../../src/01-naive-receiver/NaiveReceiverLenderPool.sol";
import {FlashLoanReceiver} from "../../src/01-naive-receiver/FlashLoanReceiver.sol";
import {BaseSetup} from "@chimera/BaseSetup.sol";
import {IHevm, vm} from "@chimera/Hevm.sol";

abstract contract Setup is BaseSetup {
    // contracts being tested

    NaiveReceiverLenderPool pool;
    FlashLoanReceiver receiver;


    uint256 initialPoolBalance = 100e18;
    uint256 initialReceiverBalance = 10e18;

    address owner = address(this);

    function setup() internal virtual override {

        pool = new NaiveReceiverLenderPool();
        receiver = new FlashLoanReceiver(payable(address(pool)));

        vm.deal(address(pool), initialPoolBalance);
        vm.deal(address(receiver), initialReceiverBalance);

    }
}