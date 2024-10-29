Ran 17 tests for test/local/actions/SellCreditMarket.t.sol:SellCreditMarketTest
[PASS] testFuzz_SellCreditMarket_sellCreditMarket_exactAmountIn_properties(uint256,uint256,uint256) (runs: 256, μ: 1484361, ~: 1484836)
[PASS] testFuzz_SellCreditMarket_sellCreditMarket_exactAmountIn_specification(uint256,uint256,uint256,uint256,uint256,uint256) (runs: 256, μ: 1929094, ~: 1957881)
[PASS] testFuzz_SellCreditMarket_sellCreditMarket_exactAmountOut_properties(uint256,uint256,uint256) (runs: 256, μ: 1488773, ~: 1488888)
[PASS] testFuzz_SellCreditMarket_sellCreditMarket_exactAmountOut_specification(uint256,uint256,uint256,uint256,uint256,uint256) (runs: 256, μ: 1772920, ~: 1722733)
[PASS] testFuzz_SellCreditMarket_sellCreditMarket_exit_full(uint256,uint256,uint256) (runs: 256, μ: 2528281, ~: 2529526)
[FAIL. Reason: assertion failed; counterexample: calldata=0xe41ac624000000000000000000000028f94179d4c8c5d036612f0090f365624aad446b6a0000000000000000000000000000000000000000000013b8bd528e0957911d9700000000000070c9b0d7d75543b58f3ca2093e7c7a38bb2d2069a57bbd0e55aa args=[59883064356602489495102154190719363036720379751274 [5.988e49], 93132806206477850189207 [9.313e22], 181243094586737206731797658022250955651946965863618386064201130 [1.812e62]]] testFuzz_SellCreditMarket_sellCreditMarket_used_to_borrow(uint256,uint256,uint256) (runs: 125, μ: 1828546, ~: 1828679)
[PASS] test_SellCreditMarket_sellCreditMarket_CreditPosition_credit_is_decreased_after_exit() (gas: 2485788)
[PASS] test_SellCreditMarket_sellCreditMarket_CreditPosition_of_CreditPosition_creates_with_correct_debtPositionId() (gas: 2914619)
[PASS] test_SellCreditMarket_sellCreditMarket_does_not_create_loans_if_dust_amount() (gas: 1710694)
[PASS] test_SellCreditMarket_sellCreditMarket_does_not_create_new_CreditPosition_if_lender_tries_to_exit_fully_exited_CreditPosition() (gas: 2284932)
[PASS] test_SellCreditMarket_sellCreditMarket_exactAmountIn_numeric_example() (gas: 1884742)
[PASS] test_SellCreditMarket_sellCreditMarket_exactAmountOut_numeric_example() (gas: 1932456)
[PASS] test_SellCreditMarket_sellCreditMarket_exit_properties() (gas: 2460595)
[PASS] test_SellCreditMarket_sellCreditMarket_fragmentation() (gas: 2471144)
[PASS] test_SellCreditMarket_sellCreditMarket_reverts_if_below_borrowing_opening_limit() (gas: 1023368)
[PASS] test_SellCreditMarket_sellCreditMarket_reverts_if_lender_cannot_transfer_underlyingBorrowToken() (gas: 990699)
[PASS] test_SellCreditMarket_sellCreditMarket_used_to_borrow() (gas: 1459736)
Suite result: FAILED. 16 passed; 1 failed; 0 skipped; finished in 2.43s (7.15s CPU time)

Ran 1 test for test/invariants/foundry/FoundryTester.sol:FoundryTester
[PASS] invariant() (runs: 1000, calls: 500000, reverts: 30488)
Suite result: ok. 1 passed; 0 failed; 0 skipped; finished in 536.08s (536.08s CPU time)

Ran 43 test suites in 536.12s (553.39s CPU time): 241 tests passed, 1 failed, 0 skipped (242 total tests)

Failing tests:
Encountered 1 failing test in test/local/actions/SellCreditMarket.t.sol:SellCreditMarketTest
[FAIL. Reason: assertion failed; counterexample: calldata=0xe41ac624000000000000000000000028f94179d4c8c5d036612f0090f365624aad446b6a0000000000000000000000000000000000000000000013b8bd528e0957911d9700000000000070c9b0d7d75543b58f3ca2093e7c7a38bb2d2069a57bbd0e55aa args=[59883064356602489495102154190719363036720379751274 [5.988e49], 93132806206477850189207 [9.313e22], 181243094586737206731797658022250955651946965863618386064201130 [1.812e62]]] testFuzz_SellCreditMarket_sellCreditMarket_used_to_borrow(uint256,uint256,uint256) (runs: 125, μ: 1828546, ~: 1828679)


