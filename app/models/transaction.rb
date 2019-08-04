# == Schema Information
#
# Table name: transactions
#
#  id               :bigint           not null, primary key
#  source_wallet_id :integer
#  target_wallet_id :integer
#  amount           :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Transaction < ApplicationRecord
  validates :amount, numericality: { greater_than: 0 }
end
