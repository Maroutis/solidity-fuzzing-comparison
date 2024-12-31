// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Setup} from "./Setup.sol";
import {Asserts} from "@chimera/Asserts.sol";

abstract contract Properties is Setup, Asserts {

    // The pool balance cannot be decreased, else it is a big vulnerability
    function property_pool_balance_cannot_decrease() public view returns (bool result) {
        if (address(pool).balance >= initialPoolBalance) result = true; 
    }

    // @note We expect that only the owner can call the flashLoan on receiver. Anyone else we expect not to be able to do so.
    function property_receiver_balance_cannot_decrease() public view returns (bool result) {
        if (address(receiver).balance >= initialReceiverBalance) result = true; 
    }

    // @note We expect that only the owner can call the flashLoan on receiver. Anyone else we expect not to be able to do so. But if there is a bug then somebody will be able to empty the contract.
    function property_receiver_balance_cannot_be_zero() public view returns (bool result) {
        if (address(receiver).balance != 0) result = true; 
    }
}