require 'rails_helper'

describe TransactionManager do
  let(:tm) { TransactionManager.instance }

  describe '#deposit' do
    it 'successfully handles valid deposit' do
      wallet = create(:wallet)
      tm.deposit(wallet, 5000)
    end
  end

  describe '#withdraw' do
    it 'successfully handles valid withdrawal' do
      wallet = create(:wallet)
      tm.deposit(wallet, 5000)
      tm.withdraw(wallet, 5000)
    end

    it 'handles race condition gracefully' do
      wallet = create(:wallet)
      tm.deposit(wallet, 5000)
      successful_withdraw = 0

      # Creates 1000 thread that tries to withdraw
      threads = []
      1.upto(1000) do
        threads << Thread.new do
          begin
            tm.withdraw(wallet, 10)
            successful_withdraw += 1
          rescue StandardError => e
          end
        end
      end

      # Wait for all the threads to finish executing
      threads.each(&:join)

      # Only 500 withdrawals should succeed
      expect(successful_withdraw).to be <= 500
      expect(wallet.balance).to be >= 0
    end
  end

  describe '#transfer' do
    it 'successfully handles valid transfer' do
      source_wallet = create(:wallet)
      target_wallet = create(:wallet)
      tm.deposit(source_wallet, 5000)
      tm.transfer(source_wallet, target_wallet, 5000)
      expect(source_wallet.balance).to eq 0
      expect(target_wallet.balance).to eq 5000
    end

    it "doesn't allow the same source and target with enough balance" do
      wallet = create(:wallet)
      tm.deposit(wallet, 5000)
      expect do
        tm.transfer(wallet, wallet, 5000)
      end.to raise_error(TransactionManager::TransactionError)
      expect(wallet.balance).to eq 5000
    end

    it "doesn't allow the same source and target with 0 balance" do
      wallet = create(:wallet)
      expect do
        tm.transfer(wallet, wallet, 5000)
      end.to raise_error(TransactionManager::TransactionError)
      expect(wallet.balance).to eq 0
    end

    it 'handles race condition gracefully' do
      source_wallet = create(:wallet)
      target_wallet = create(:wallet)
      tm.deposit(source_wallet, 5000)
      successful_transfer = 0

      # Creates 1000 thread that tries to transfer
      threads = []
      1.upto(1000) do
        threads << Thread.new do
          begin
            tm.transfer(source_wallet, target_wallet, 10)
            successful_transfer += 1
          rescue StandardError => e
          end
        end
      end

      # Wait for all the threads to finish executing
      threads.each(&:join)

      # Only 500 transfers should succeed
      expect(successful_transfer).to eq 500
      expect(source_wallet.balance).to eq 0
      expect(target_wallet.balance).to eq 5000
      expect(source_wallet.balance + target_wallet.balance).to eq 5000
    end
  end
end
