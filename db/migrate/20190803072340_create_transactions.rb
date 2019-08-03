class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.integer :source_wallet_id
      t.integer :target_wallet_id
      t.integer :amount
      t.string :state

      t.timestamps
    end
  end
end
