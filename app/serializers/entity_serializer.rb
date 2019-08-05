class EntitySerializer < ApplicationSerializer
  attributes :id, :type, :name, :balance

  def balance
    object.wallet.balance
  end
end
