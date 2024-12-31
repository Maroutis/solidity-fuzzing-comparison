## Black Box
- When a flashLoan is taken, the full amount + fee need to be paid back i.e, the internal balance cannot decrease
- Only the owner of a receiver contract can call flashLoan
- No cross-function reentrancy during the flashLoan callback

## White Box
No storage params



## Results :
- A handler function allows the fuzzers to concentrate on a very concise and simple input. Rather than fuzzing the flashLoan function with both a random receiver and amount, we limit to calling a flashLoan with a predefined receiver and a random amount.


All 3 fuzzers are able to crack 2 of the 3 invariants :

- property_receiver_balance_cannot_decrease
- property_receiver_balance_cannot_be_zero


Without creating a handler, the fuzzer would not be able to crack the second invariant which is much harder to break. To break this invariant the invariant would need to stack 10 tx for the same receiver. Randomizing the receiver's address and trying to break this invariant would be computationally very expensive.