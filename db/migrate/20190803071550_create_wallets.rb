class CreateWallets < ActiveRecord::Migration[5.2]
  def change
    create_table :wallets do |t|
      t.integer :entity_id, null: false
      t.string  :guid, null: false

      t.timestamps
    end

    add_foreign_key :wallets, :entities, column: :entity_id
    add_index :wallets, :guid, unique: true
  end
end
