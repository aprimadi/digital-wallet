# == Schema Information
#
# Table name: wallets
#
#  id         :integer          not null, primary key
#  entity_id  :integer
#  guid       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Wallet < ApplicationRecord
  belongs_to :entity
  has_many :debit_transactions, foreign_key: 'source_wallet_id', class_name: 'Transaction'
  has_many :credit_transactions, foreign_key: 'target_wallet_id', class_name: 'Transaction'

  def balance
    credit_transactions.sum(:amount) - debit_transactions.sum(:amount)
  end
end
