# Digital Wallet

Goal: Internal wallet transactional system (with a front end)

Requirements:
- Based on relationships every entity e.g. User, Team, Stock or any other should have their own defined "wallet" to which we could transfer money or withdraw
- Every request for credit/debit (deposit or withdraw) should be based on records in database for given model
- Every instance of a single transaction should have proper validations against required fields and their source and target wallet, e.g. from who we are taking money and transferring to whom? (Credits == source wallet == nil, Debits == target wallet == nil)
- Each record should be created in database transactions to comply with ACID standards
- Balance for given entity (User, Team, Stock) should be calculated by summing records

Tasks:
1. Architect generic wallet solution (money manipulation) between entities (User, Stock, Team or any other)
2. Create model relationships and validations for achieving proper calculations of every wallet, transactions
3. Use STI (or any other design pattern) for proper money manipulation

## Design Decision

- Each entity (User, Team, Stock) has one wallet
- Each wallet belongs to an entity
- Money is handled as an integer, the assumption is that we're creating the
  application for Indonesian market, in which, the smallest amount of money is
  Rp. 100. Even if the system is being used to handle USD or AUD, it is
  beneficial to store money as integer (in cents) rather than as floating point
  (decimal) because of the way computer stores floating point number as an
  approximation. I won't go into details about this but in floating point number
  representation (0 = 0) might not be true, but instead you need to compare it
  with range (0 >= 0 - epsilon and 0 <= 0 + epsilon) where epsilon is a small value for example 0.000001.


## Generating Documentation

We use Yard to generate documentation, in the command line run (from the root of the project):

```
yard
```

Documentation can be found in `doc/index.html`