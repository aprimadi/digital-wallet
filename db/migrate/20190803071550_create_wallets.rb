class CreateWallets < ActiveRecord::Migration[5.2]
  def change
    create_table :wallets do |t|
      t.integer :entity_id
      t.string  :guid

      t.timestamps
    end
  end
end
