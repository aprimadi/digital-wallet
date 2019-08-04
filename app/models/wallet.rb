# == Schema Information
#
# Table name: wallets
#
#  id         :bigint           not null, primary key
#  entity_id  :integer          not null
#  guid       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Wallet < ApplicationRecord
  belongs_to :entity
  has_many :debit_transactions, foreign_key: 'source_wallet_id', class_name: 'Transaction'
  has_many :credit_transactions, foreign_key: 'target_wallet_id', class_name: 'Transaction'

  before_create :create_guid

  def balance
    credit_transactions.sum(:amount) - debit_transactions.sum(:amount)
  end

  #
  # This will generate random guid from 10000 00000 to 99999 99999
  #
  def self.generate_guid
    SecureRandom.random_number(9000000000) + 1000000000
  end

  private

  def create_guid
    self.guid = Wallet.generate_guid
  end
end
