class TransactionsController < ApplicationController
  def deposit
    wallet = Wallet.find_by(id: params[:wallet_id])
    amount = params[:amount].to_i

    if wallet.nil?
      entity = Entity.find_by(id: params[:entity_id])
      wallet = entity.try(:wallet)
    end

    return api_error("Wallet not found") if wallet.nil?
    return api_error("Invalid amount") if amount <= 0

    begin
      tm = TransactionManager.instance
      tm.deposit(wallet, amount)
      api_success
    rescue StandardError => e
      api_error(e.message)
    end
  end

  def withdraw
    wallet = Wallet.find_by(id: params[:wallet_id])
    amount = params[:amount].to_i

    if wallet.nil?
      entity = Entity.find_by(id: params[:entity_id])
      wallet = entity.try(:wallet)
    end

    return api_error("Wallet not found") if wallet.nil?
    return api_error("Invalid amount") if amount <= 0

    begin
      tm = TransactionManager.instance
      tm.withdraw(wallet, amount)
      api_success
    rescue StandardError => e
      api_error(e.message)
    end
  end

  def transfer
    source_wallet = Wallet.find_by(id: params[:source_wallet_id])
    target_wallet = Wallet.find_by(id: params[:target_wallet_id])
    amount = params[:amount].to_i

    if source_wallet.nil?
      source_entity = Entity.find_by(id: params[:source_entity_id])
      source_wallet = source_entity.try(:wallet)
    end
    if target_wallet.nil?
      target_entity = Entity.find_by(id: params[:target_entity_id])
      target_wallet = target_entity.try(:wallet)
    end

    return api_error("Source wallet not found") if source_wallet.nil?
    return api_error("Target wallet not found") if target_wallet.nil?
    return api_error("Invalid amount") if amount <= 0

    begin
      tm = TransactionManager.instance
      tm.transfer(source_wallet, target_wallet, amount)
      api_success
    rescue StandardError => e
      api_error(e.message)
    end
  end
end