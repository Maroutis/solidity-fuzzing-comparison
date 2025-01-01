// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { TargetFunctions } from "./TargetFunctions.sol";
import { CryticAsserts } from "@chimera/CryticAsserts.sol";

// configure solc-select to use compiler version:
// solc-select install 0.8.23
// solc-select use 0.8.23
//
// run from base project directory with:
// echidna . --contract ProposalEchidnaMedusa --config test/03-proposal/echidna.yaml
// medusa --config test/03-proposal/medusa.json fuzz
contract ProposalEchidnaMedusa is TargetFunctions, CryticAsserts {
  constructor() payable {
    setup();
  }
}