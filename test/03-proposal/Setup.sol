// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Proposal} from "../../src/03-proposal/Proposal.sol";
import {BaseSetup} from "@chimera/BaseSetup.sol";
import {IHevm, vm} from "@chimera/Hevm.sol";

abstract contract Setup is BaseSetup {
    // contracts being tested

    Proposal proposal;
    address[] allowlist;

    uint256 initialBalance = 100e18;
    uint256 numberOfVotes;

    function setup() internal virtual override {
        allowlist.push(address(0x1000000000000000000000000000000000000000));
        allowlist.push(address(0x2000000000000000000000000000000000000000));
        allowlist.push(address(0x3000000000000000000000000000000000000000));
        allowlist.push(address(0x4000000000000000000000000000000000000000));
        allowlist.push(address(0x5000000000000000000000000000000000000000));
        proposal = new Proposal{value: initialBalance}(allowlist);
    }
    
    // required to receive refund if proposal fails
    receive() external payable {}
}
