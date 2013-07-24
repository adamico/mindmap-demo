class AddAncestryToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :ancestry, :string
    add_index :nodes, :ancestry
  end
end
