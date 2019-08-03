require 'singleton'

#
# TransactionManager encapsulates the complexity of any transaction or money
# manipulation. Application should not create transaction directly from
# +Transaction+ object but should use this class to do money manipulation.
#
class TransactionManager
  class TransactionError < StandardError
  end

  include Singleton

  #
  # Deposit money to the given wallet
  #
  # @param [Wallet] wallet Wallet to deposit to
  # @param [Integer] amount Amount to deposit
  #
  # @raise [TransactionManager::TransactionError]
  # @raise [ActiveRecord::ActiveRecordError]
  #
  def deposit(wallet, amount)
    assert(amount > 0, "Deposit amount must be greater than 0")
    ActiveRecord::Base.transaction do
      # First grab a lock on the target wallet (to make sure that no one is
      # trying to make a transaction that involves the wallet)
      wallet.lock!
      Transaction.create!(source_wallet_id: nil, target_wallet_id: wallet.id, amount: amount)
    end
  end

  #
  # Withdraw money from the given wallet
  #
  # @param [Wallet] wallet Wallet to withdraw from
  # @param [Integer] amount Amount to withdraw
  #
  # @raise [TransactionManager::TransactionError]
  # @raise [ActiveRecord::ActiveRecordError]
  #
  def withdraw(wallet, amount)
    assert(amount > 0, "Withdraw amount must be greater than 0")
    ActiveRecord::Base.transaction(requires_new: true) do
      wallet.lock!
      assert(wallet.balance >= amount, "Not enough balance")
      Transaction.create!(
        source_wallet_id: wallet.id,
        target_wallet_id: nil,
        amount: amount
      )
      assert(wallet.balance >= 0, "Not enough balance")
    end
  end

  #
  # Transfer money from source to target wallet
  #
  # @param [Wallet] source_wallet Source wallet to transfer money from
  # @param [Wallet] target_wallet Target wallet to transfer money to
  # @param [Integer] amount Amount to transfer
  #
  # @raise [TransactionManager::TransactionError]
  # @raise [ActiveRecord::ActiveRecordError]
  #
  def transfer(source_wallet, target_wallet, amount)
    assert(amount > 0, "Transfer amount must be greater than 0")
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
  end

  private

  def assert(condition, message)
    if !condition
      raise TransactionError.new(message)
    end
  end
end
