class CreateEntities < ActiveRecord::Migration[5.2]
  def change
    create_table :entities do |t|
      t.string  :type, null: false
      t.string  :name, null: false
      t.string  :status, null: false, default: 'active'

      t.timestamps
    end
  end
end
