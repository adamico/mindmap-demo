class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :name
      t.integer :parent_id

      t.timestamps
    end
    add_index :nodes, :name
  end
end
