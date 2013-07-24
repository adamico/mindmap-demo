class AddOldidToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :oldid, :integer
  end
end
