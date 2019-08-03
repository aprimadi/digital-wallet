# == Schema Information
#
# Table name: transactions
#
#  id               :integer          not null, primary key
#  source_wallet_id :integer
#  target_wallet_id :integer
#  amount           :integer
#  state            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Transaction < ApplicationRecord
  validates :amount, greater_than: 0
end
