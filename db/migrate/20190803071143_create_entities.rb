class CreateEntities < ActiveRecord::Migration[5.2]
  def change
    create_table :entities do |t|
      t.string  :name
      t.string  :status

      t.timestamps
    end
  end
end
