## Black Box

- Sould always be able to execute the flashLoan
- Pool tokens do not decrease
- Receiver tokens do not decrease

## White Box

- `poolBalance` variable is always the same as The pool's balance

## Results :

Using a basic fuzzing setup (without a handler), we create the contracts "Pool, Receiver and Token" and tell the fuzzer to run tests using all external functions in these contracts.

- Medusa breaks the invariants easily without any problems
- Echidna however does not find the correct sequences. We have to rewrite the Token contract and instead of putting the whole `ERC20`, only the `TesToken` with the overriden `transfer` is needed. this allows Echidna to create sequences with the `transfer` fucntion that breaks the invariant
- Foundry also is able to break the invariants, but for it to work easily have to up the runs to 1000.
