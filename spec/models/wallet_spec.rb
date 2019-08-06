require 'rails_helper'

describe Wallet do
  let(:tm) { TransactionManager.instance }

  describe '::generate_guid' do
    it 'has a lower bound of 10000 00000' do
      allow(SecureRandom).to receive(:random_number).with(9000000000).and_return(0)
      expect(Wallet.generate_guid).to eq 1000000000
    end

    it 'has a higher bound of 99999 99999' do
      allow(SecureRandom).to receive(:random_number).with(9000000000).and_return(8999999999)
      expect(Wallet.generate_guid).to eq 9999999999
    end
  end

  describe '#balance' do
    it 'returns balance correctly for multiple large deposit of 2,000,000,000' do
      wallet = create(:wallet)
      expect {
        tm.deposit(wallet, 3_000_000_000)
      }.to raise_error(ActiveModel::RangeError)
      1.upto(50) do
        tm.deposit(wallet, 2_000_000_000)
      end
      expect(wallet.balance).to eq 100_000_000_000
    end
  end
end
