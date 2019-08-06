require 'rails_helper'

describe TransactionsController do
  let(:tm) { TransactionManager.instance }

  describe 'POST deposit' do
    it 'should not allow larger than 2,147,483,647 deposit' do
      wallet = create(:wallet)
      post :deposit, {
        params: {
          wallet_id: wallet.id,
          amount: 2147483648
        }
      }
      expect(response.status).to eq 400
      expect(wallet.balance).to eq 0
    end

    it 'allows only positive non zero amount' do
      failing_test_cases = [-1000, -100, -1, 0]
      success_test_cases = [1, 10, 100, 1000]

      failing_test_cases.each do |tc|
        wallet = create(:wallet)
        post :deposit, {
          params: {
            wallet_id: wallet.id,
            amount: tc
          }
        }
        expect(response.status).to eq 400
        expect(JSON.parse(response.body)['error']).to eq 'Invalid amount'
      end

      success_test_cases.each do |tc|
        wallet = create(:wallet)
        post :deposit, {
          params: {
            wallet_id: wallet.id,
            amount: tc
          }
        }
        expect(response.status).to eq 200
        expect(wallet.balance).to eq tc
      end
    end

    it 'allows entity_id parameter' do
      wallet = create(:wallet)
      post :deposit, {
        params: {
          entity_id: wallet.entity.id,
          amount: 1000
        }
      }
      expect(response.status).to eq 200
      expect(wallet.balance).to eq 1000
    end

    it 'returns an error for invalid wallet or entity' do
      test_cases = [
        { wallet_id: 0, amount: 1000 },
        { entity_id: 0, amount: 1000 },
        { amount: 1000 },
        { wallet_id: 0, entity_id: 0, amount: 1000 },
      ]
      wallet = create(:wallet)
      test_cases.each do |tc|
        post :deposit, { params: tc }
        expect(response.status).to eq 400
        expect(JSON.parse(response.body)['error']).to eq "Wallet not found"
        expect(wallet.balance).to eq 0
      end
    end
  end

  describe 'POST withdraw' do
    it 'allows only positive non zero amount' do
      failing_test_cases = [-1000, -100, -1, 0]
      success_test_cases = [1, 10, 100, 1000]

      failing_test_cases.each do |tc|
        wallet = create(:wallet)
        tm.deposit(wallet, 1000)
        post :withdraw, {
          params: {
            wallet_id: wallet.id,
            amount: tc
          }
        }
        expect(response.status).to eq 400
        expect(JSON.parse(response.body)['error']).to eq 'Invalid amount'
      end

      success_test_cases.each do |tc|
        wallet = create(:wallet)
        tm.deposit(wallet, 1000)
        post :withdraw, {
          params: {
            wallet_id: wallet.id,
            amount: tc
          }
        }
        expect(response.status).to eq 200
        expect(wallet.balance).to eq (1000 - tc)
      end
    end

    it 'allows entity_id parameter' do
      wallet = create(:wallet)
      tm.deposit(wallet, 1000)
      post :withdraw, {
        params: {
          entity_id: wallet.entity.id,
          amount: 1000
        }
      }
      expect(response.status).to eq 200
      expect(wallet.balance).to eq 0
    end

    it 'returns an error for invalid wallet or entity' do
      test_cases = [
        { wallet_id: 0, amount: 1000 },
        { entity_id: 0, amount: 1000 },
        { amount: 1000 },
        { wallet_id: 0, entity_id: 0, amount: 1000 },
      ]
      wallet = create(:wallet)
      tm.deposit(wallet, 1000)
      test_cases.each do |tc|
        post :withdraw, { params: tc }
        expect(response.status).to eq 400
        expect(JSON.parse(response.body)['error']).to eq "Wallet not found"
        expect(wallet.balance).to eq 1000
      end
    end

    it 'returns an error when overdrawn with 0 initial balance' do
      wallet = create(:wallet)

      test_cases = [1, 10, 100, 1000]
      test_cases.each do |tc|
        post :withdraw, params: { wallet_id: wallet.id, amount: tc }
        expect(response.status).to eq 400
        expect(JSON.parse(response.body)['error']).to eq 'Not enough balance'
        expect(wallet.balance).to eq 0
      end
    end

    it 'returns an error when overdrawn with 1000 initial balance' do
      wallet = create(:wallet)
      tm.deposit(wallet, 1000)

      test_cases = [1001, 2000, 10000, 100000]
      test_cases.each do |tc|
        post :withdraw, params: { wallet_id: wallet.id, amount: tc }
        expect(response.status).to eq 400
        expect(JSON.parse(response.body)['error']).to eq 'Not enough balance'
        expect(wallet.balance).to eq 1000
      end
    end
  end

  describe 'POST transfer' do
    it 'allows only positive non zero amount' do
      failing_test_cases = [-1000, -100, -1, 0]
      success_test_cases = [1, 10, 100, 1000]

      failing_test_cases.each do |tc|
        source_wallet = create(:wallet)
        target_wallet = create(:wallet)
        tm.deposit(source_wallet, 1000)
        post :transfer, {
          params: {
            source_wallet_id: source_wallet.id,
            target_wallet_id: target_wallet.id,
            amount: tc
          }
        }
        expect(response.status).to eq 400
        expect(JSON.parse(response.body)['error']).to eq 'Invalid amount'
        expect(source_wallet.balance).to eq 1000
        expect(target_wallet.balance).to eq 0
      end

      success_test_cases.each do |tc|
        source_wallet = create(:wallet)
        target_wallet = create(:wallet)
        tm.deposit(source_wallet, 1000)
        post :transfer, {
          params: {
            source_wallet_id: source_wallet.id,
            target_wallet_id: target_wallet.id,
            amount: tc
          }
        }
        expect(response.status).to eq 200
        expect(source_wallet.balance).to eq (1000 - tc)
        expect(target_wallet.balance).to eq tc
      end
    end

    it 'allows entity_id parameter' do
      source_wallet = create(:wallet)
      target_wallet = create(:wallet)
      tm.deposit(source_wallet, 1000)
      post :transfer, {
        params: {
          source_entity_id: source_wallet.entity.id,
          target_entity_id: target_wallet.entity.id,
          amount: 1000
        }
      }
      expect(response.status).to eq 200
      expect(source_wallet.balance).to eq 0
      expect(target_wallet.balance).to eq 1000
    end

    it 'returns an error for invalid wallet or entity' do
      source_wallet = create(:wallet)
      target_wallet = create(:wallet)
      test_cases = [
        { source_wallet_id: 0, target_wallet_id: target_wallet.id, amount: 1000 },
        { source_wallet_id: 0, amount: 1000 },
        { source_wallet_id: source_wallet.id, target_wallet_id: 0, amount: 1000 },
        { target_wallet_id: 0, amount: 1000 },
        { source_entity_id: 0, target_entity_id: target_wallet.entity.id, amount: 1000 },
        { source_entity_id: 0, amount: 1000 },
        { source_entity_id: source_wallet.entity.id, target_entity_id: 0, amount: 1000 },
        { target_entity_id: 0, amount: 1000 },
        { amount: 1000 },
        { source_entity_id: source_wallet.entity.id, target_wallet_id: 0, amount: 1000 },
        { source_wallet_id: 0, target_entity_id: target_wallet.entity.id, amount: 1000 },
      ]
      test_cases.each do |tc|
        tm.deposit(source_wallet, 1000)
        post :transfer, { params: tc }
        expect(response.status).to eq 400
        expect(JSON.parse(response.body)['error']).to match(/wallet not found/)
        expect(source_wallet.balance).to eq 1000
        expect(target_wallet.balance).to eq 0
        tm.withdraw(source_wallet, 1000)
      end
    end

    it 'returns an error when overdrawn with 0 initial balance' do
      source_wallet = create(:wallet)
      target_wallet = create(:wallet)

      test_cases = [1, 10, 100, 1000]
      test_cases.each do |tc|
        post :transfer, {
          params: {
            source_wallet_id: source_wallet.id,
            target_wallet_id: target_wallet.id,
            amount: tc,
          }
        }
        expect(response.status).to eq 400
        expect(JSON.parse(response.body)['error']).to eq 'Not enough balance'
        expect(source_wallet.balance).to eq 0
        expect(target_wallet.balance).to eq 0
      end
    end

    it 'returns an error when overdrawn with 1000 initial balance' do
      source_wallet = create(:wallet)
      target_wallet = create(:wallet)

      test_cases = [1001, 2000, 10000, 100000]
      test_cases.each do |tc|
        tm.deposit(source_wallet, 1000)
        post :transfer, {
          params: {
            source_wallet_id: source_wallet.id,
            target_wallet_id: target_wallet.id,
            amount: tc
          }
        }
        expect(response.status).to eq 400
        expect(JSON.parse(response.body)['error']).to eq 'Not enough balance'
        expect(source_wallet.balance).to eq 1000
        expect(target_wallet.balance).to eq 0
        tm.withdraw(source_wallet, 1000)
      end
    end
  end
end