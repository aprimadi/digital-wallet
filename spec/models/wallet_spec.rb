require 'rails_helper'

describe Wallet do
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
end
