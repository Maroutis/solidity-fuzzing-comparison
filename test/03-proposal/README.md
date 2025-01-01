# Black-Box
- Funds are sent to the creator of the contract when proposal does not pass
- Funds are sent to the voters when proposal passes
- No funds should remain in the contract
- Rewards will always be disctributed at a certain point
- `Proposal` is active until voting has finished or the proposal has timed out
- While active, eligible voters can vote `for` or `against`

# White-Box
- Only `ALLOWED` voters can vote
- Total amount of distributed funds is exactly the initial contract balance


# Results
All three fuzzers are able to break the invariants pretty easily. Both invariants are actually the same but expressed with 2 different methods.

# Notes
- balanceContract argument in echidna.yaml defines the funds that are sent to the fuzzing contract before it is given to the Proposal contarct.
- Since we are using a handler we do not need allContracts to be active
- targetContractsBalances in medusa.json refers to the funds to send to the fuzzing contract.