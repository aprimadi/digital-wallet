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
- Handling concurrency: this is quite long so see section below [Handling
  Concurrency]


## Handling Concurrency

When building a payment system, one of the challenge is to ensure that it
handles concurrency correctly. That is if users trying to withdraw the same
account twice or more at the same time, it doesn't overdraw the account (if one
of the transaction results in an overdraw, it has to fail). The way we achieve
this is by locking the wallet involved in the transaction (to be explained
later). Another way we can do this is by locking the entire transactions table
but this isn't efficient because what this means is that the system will only be
able to process one transaction at any given time.

So what does it mean to lock the wallet involved in the transactions. First
thing to notice is that a transaction can only involve at maximum of two
wallets. By exploiting this fact, two unrelated transactions involving unrelated
wallets can be executed concurrently. We use a row locking mechanism provided by
most modern database systems to lock the wallet.

So before processing a transaction, we lock the source wallet and the target
wallet (in case of deposit - source wallet = nil or withdrawal - target wallet =
nil) to ensure that no other processes or threads are trying to create a
transaction involving either one of the wallets. In code:

```
ActiveRecord::Base.transaction(requires_new: true) do
  source_wallet.lock!
  target_wallet.lock!
  assert(source_wallet.balance >= amount, "Not enough balance")
  Transaction.create!(
    source_wallet_id: source_wallet.id,
    target_wallet_id: target_wallet.id,
    amount: amount
  )
  assert(source_wallet.balance >= 0, "Not enough balance")
end
```

## Generating Documentation

We use Yard to generate documentation, in the command line run (from the root of the project):

```
yard
```

Documentation can be found at `doc/index.html`

## Running Tests

We use `Rspec` to run tests. To run all tests do:

```
rake spec
```

The test coverage can be found at `coverage/index.html`
